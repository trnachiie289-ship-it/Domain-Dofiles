-- =========================
-- Basic settings
-- =========================
local opt = vim.opt

opt.backup = false
opt.swapfile = false
opt.mouse = "a"
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.list = true
opt.listchars = { tab = "¦ " }
opt.foldmethod = "syntax"
opt.foldnestmax = 1
opt.foldlevelstart = 5
opt.number = true
opt.cursorline = true
opt.wrap = false -- overridden by `set wrap` further below in the original file
opt.ignorecase = true
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.autowrite = true
opt.autowriteall = true
opt.errorformat = "%f:%l:%c:%m"
opt.guicursor = "a:block"
opt.synmaxcol = 5000
opt.lazyredraw = true
opt.signcolumn = "no"
opt.makeprg = "g++ % -o %:r"
opt.helpheight = 10
opt.termguicolors = true
opt.laststatus = 0
opt.sidescroll = 1
opt.sidescrolloff = 5
opt.timeout = true
opt.timeoutlen = 200
opt.ttimeout = true
opt.ttimeoutlen = 50
opt.wrap = true -- matches the original `set wrap` (kept last, as in the source file)

vim.cmd("syntax on")

vim.g.AutoPairsMapCR = 0

if vim.fn.has("win32") == 1 then
  opt.clipboard = "unnamed"
else
  opt.clipboard = "unnamedplus"
end

-- =========================
-- Auto-save
-- =========================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local autosave_grp = augroup("AutoSave", { clear = true })

autocmd("InsertLeave", {
  group = autosave_grp,
  pattern = "*",
  callback = function()
    pcall(vim.cmd, "silent! write")
  end,
})

autocmd({ "BufLeave", "FocusLost" }, {
  group = autosave_grp,
  pattern = "*",
  callback = function()
    pcall(vim.cmd, "silent! write")
  end,
})

autocmd({ "CursorHold", "CursorHoldI" }, {
  group = autosave_grp,
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      pcall(vim.cmd, "checktime")
    end
  end,
})
autocmd({ "FocusGained", "BufEnter" }, {
  group = autosave_grp,
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      pcall(vim.cmd, "checktime")
    end
  end,
})

-- =========================
-- General keymaps
-- =========================
local map = vim.keymap.set

map("i", "<C-s>", "<Esc>:w<CR>a")
map("n", "<A-]>", ":bnext<CR>")
map("n", "<A-[>", ":bprevious<CR>")
map("n", "<leader>bd", ":bp \\| sp \\| bn \\| bd<CR>", { silent = true })
map("t", "<Esc>", "<C-\\><C-q>")

map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")
map("x", ">", ">gv")
map("x", "<", "<gv")
map("n", "<C-c>", "<C-v>")

autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- =========================
-- Plugins
-- =========================
vim.cmd([[
call plug#begin(stdpath('config').'/plugged')
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

  " Editing / bracket pairs
  Plug 'jiangmiao/auto-pairs'

  " Debugging
  Plug 'puremourning/vimspector'

  " Version control
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'airblade/vim-gitgutter'
  Plug 'samoshkin/vim-mergetool'

  " Exchange text / multi cursor
  Plug 'tommcdo/vim-exchange'

  " Utility
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'numToStr/Comment.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'

  " LSP / completion
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'


  Plug 'terryma/vim-multiple-cursors'
  Plug 'jake-stewart/multicursor.nvim'

  Plug 'svermeulen/text-to-colorscheme'

call plug#end()
]])

opt.guicursor = "n-v-c:block-CursorNormal"
opt.guicursor:append("i:block-CursorInsert")
opt.guicursor:append("r:block-CursorReplace")
opt.guicursor:append("v:block-CursorVisual")


vim.cmd([[
highlight CursorNormal  guifg=black guibg=#ffffff
highlight CursorInsert  guifg=black guibg=#00ff00
highlight CursorReplace guifg=white guibg=#ff0000
highlight CursorVisual  guifg=black guibg=#FF00FF
highlight! link @lsp.typemod.variable.defaultLibrary.cpp Identifier
]])


vim.g.multi_cursor_use_default_mapping = 0

-- Default mapping
vim.g.multi_cursor_start_word_key = "<C-n>"
vim.g.multi_cursor_select_all_word_key = "<A-b>"
vim.g.multi_cursor_start_key = "g<C-n>"
vim.g.multi_cursor_select_all_key = "g<A-b>"
vim.g.multi_cursor_next_key = "<C-n>"
vim.g.multi_cursor_prev_key = "<C-p>"
vim.g.multi_cursor_skip_key = "<C-m>"
vim.g.multi_cursor_quit_key = "<Esc>"

-- =========================
-- Sourced config files
-- =========================
vim.cmd("source ~/.config/nvim/plugged/nvimtree/nvimtree-config.vim")
vim.cmd("source ~/.config/nvim/plugged/RunProgramming.lua")

-- =========================
-- Lua config
-- =========================
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true },
})

require("bufferline").setup({})

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = false,
})

autocmd("FileType", {
  pattern = "compilation",
  callback = function()
    vim.cmd("wincmd J")
    vim.api.nvim_win_set_height(0, 10)
  end,
})

autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = false
  end,
})

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("clangd", {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--query-driver=/usr/bin/g++",
    "--header-insertion=never",
  },
})
vim.lsp.enable("clangd")

-- =========================
-- Tmux status integration (mode + line)
-- =========================
if vim.env.TMUX then
  local uv = vim.uv
  local timer = nil

  local function tmux_update(mode, line)
    -- Hủy timer cũ nếu còn tồn tại
    if timer then
      timer:stop()
      if not timer:is_closing() then
        timer:close()
      end
      timer = nil
    end

    local t = uv.new_timer()
    timer = t

    t:start(
      30,
      0,
      vim.schedule_wrap(function()
        if mode then
          vim.fn.jobstart({
            "tmux", "set-option", "-p", "@nvim_mode", mode,
          }, { detach = true })
        end

        if line then
          vim.fn.jobstart({
            "tmux", "set-option", "-p", "@nvim_line", line,
          }, { detach = true })
        end

        vim.fn.jobstart({
          "tmux", "refresh-client", "-S",
        }, { detach = true })

        if not t:is_closing() then
          t:close()
        end

        if timer == t then
          timer = nil
        end
      end)
    )
  end

  -- -- Cập nhật mode
  -- autocmd("ModeChanged", {
  --   pattern = "*",
  --   callback = function()
  --     local mode = vim.fn.mode()
  --     local label
  --
  --     if mode == "n" then
  --       label = "NORMAL"
  --     elseif mode == "i" then
  --       label = "INSERT"
  --     elseif mode == "R" then
  --       label = "REPLACE"
  --     elseif mode:match("^[vV\22]") then
  --       label = "VISUAL"
  --     elseif mode == "c" then
  --       label = "COMMAND"
  --     else
  --       label = mode
  --     end
  --
  --     tmux_update(label, nil)
  --   end,
  -- })

  -- Cập nhật dòng hiện tại
  autocmd({
    "CursorMoved",
    "CursorMovedI",
    "BufEnter",
  }, {
    pattern = "*",
    callback = function()
      local cur = vim.fn.line(".")
      local total = vim.fn.line("$")
      tmux_update(nil, string.format("%d/%d", cur, total))
    end,
  })

  -- Khi thoát Neovim
  autocmd("VimLeavePre", {
    callback = function()
      if timer then
        timer:stop()
        if not timer:is_closing() then
          timer:close()
        end
      end

      vim.fn.jobstart({
        "tmux", "set-option", "-p", "@nvim_mode", "",
      }, { detach = true })

      vim.fn.jobstart({
        "tmux", "set-option", "-p", "@nvim_line", "",
      }, { detach = true })
    end,
  })
end

-- Thoát Insert mode bằng jk thay vì Esc
map("i", "<C-d>", "<Esc>")

-- Thoát Terminal mode bằng jk (thay cho Ctrl-q bạn đang dùng)
map("t", "<C-x>", "<C-\\><C-n>")

-- Move cursor in the mode insert
map("i", "<Esc>H", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")
map("i", "<C-w>", "<C-o>w")
map("i", "<C-b>", "<C-o>b")
map("i", "<C-e>", "<C-o>e")

vim.g.VM_maps = {
    ["Add Cursor At Pos"] = "<Space>",
}
