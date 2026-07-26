local last_compile_command = "make -k"
local function RunProgramming(command)
  vim.cmd("silent! write")
  local file = vim.fn.expand("%")
  local ext = vim.fn.expand("%:e")
  local out = vim.fn.expand("%:r")
  local tmp = vim.fn.tempname() .. ".sh"
local cmd, display_cmd, run_cmd

if command and command ~= "" then
    cmd = command
    display_cmd = command
    run_cmd = ""
else

  if ext == "cpp" or ext == "cc" or ext == "cxx" then
    local opts = "-std=c++17 -Wall -w -g"
    local libs = "-lraylib -lGL -lm -lpthread -ldl -lrt -lX11"
    cmd = "g++ " .. opts .. " " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(out) .. " " .. libs
    display_cmd = "cc -o " .. out .. " " .. file
    run_cmd = "./" .. out
  elseif ext == "py" then
    cmd = "python3 -m py_compile " .. vim.fn.shellescape(file)
    display_cmd = "python3 " .. file
    run_cmd = "python3 " .. vim.fn.shellescape(file)
  else
    print("File not support.")
    return
  end

end
  vim.cmd("cclose")
  local errors = vim.fn.system(cmd .. " 2>&1")
  if vim.v.shell_error ~= 0 then
    vim.fn.setqflist({}, " ", { lines = vim.split(errors, "\n") })
    vim.cmd("botright copen 12")
    pcall(vim.cmd, "cfirst")
    return
  end

  vim.cmd("cclose")
  local lines = {
    "#!/bin/bash",
    'start_time=$(date "+%a %d %b %Y %I:%M:%S %p %z")',
    "start_ts=$(date +%s.%N)",
    'echo "Compilation started at $start_time"',
    'echo "' .. display_cmd .. '"',
    "echo",
    cmd .. " 2>&1",
    "code=$?",
    "end_ts=$(date +%s.%N)",
    'dur=$(echo "$end_ts - $start_ts" | bc)',
    "if [ $code -eq 0 ]; then",
    "  " .. run_cmd,
    '  end_time=$(date "+%a %d %b %Y %I:%M:%S %p %z")',
    "  echo",
    "  echo",
    '  echo -e "\\033[38;2;0;255;0mCompilation finished at $end_time, duration ${dur}\\033[0m"',
    "else",
    '  end_time=$(date "+%a %d %b %Y %I:%M:%S %p %z")',
    '  echo -e "\\033[31mCompilation exited abnormally at $end_time, duration ${dur}\\033[0m"',
    "fi",
  }

  vim.fn.writefile(lines, tmp)
  vim.fn.system("chmod +x " .. vim.fn.shellescape(tmp))
  for w = 1, vim.fn.winnr("$") do
    if vim.fn.getbufvar(vim.fn.winbufnr(w), "&buftype") == "terminal" then
      vim.cmd(w .. "wincmd w")
      pcall(vim.cmd, "bwipeout!")
      break
    end
  end

  local codewin = vim.fn.win_getid()
  vim.cmd("botright split")
  vim.cmd("resize 12")
  pcall(vim.cmd, "terminal " .. vim.fn.shellescape(tmp))
  vim.opt_local.buflisted = false
  vim.opt_local.bufhidden = "wipe"

  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "n")
  vim.defer_fn(function()
    vim.cmd("normal! 4gg")
  end, 50)
  vim.cmd("startinsert")
  _ = codewin

end

local grp = vim.api.nvim_create_augroup("TermAutoNormal", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
  group = grp,
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "n")
    end
  end,
})

vim.opt.number = true
vim.keymap.set("n", "<C-x>", RunProgramming)
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>")
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10

vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-k>", function()

local line = vim.fn.getcmdline()
local pos = vim.fn.getcmdpos() 
vim.fn.setcmdline(line:sub(1, pos - 1))
end)

vim.keymap.set("c", "<C-r>", "<C-f>")
vim.keymap.set("c", "<C-y>", "<C-r>\"")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-b>", "<Left>")

vim.api.nvim_create_user_command("Compile", function()
    local cmd = vim.fn.input("Compile command: ", last_compile_command,"shellcmd")
    if cmd == "" then
        return
    end
    last_compile_command = cmd
    RunProgramming(cmd)
end, {})

return { RunProgramming = RunProgramming }
