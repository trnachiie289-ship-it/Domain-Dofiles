" =========================
" Basic settings
" =========================
set nobackup noswapfile
set mouse=a
set expandtab tabstop=4 shiftwidth=4
set list listchars=tab:\¦\
set foldmethod=syntax foldnestmax=1 foldlevelstart=5
set number cursorline nowrap
set ignorecase
set completeopt=menuone,noinsert,noselect
set autowrite autowriteall
set errorformat=%f:%l:%c:%m
set guicursor=a:block
set synmaxcol=5000
set lazyredraw
set signcolumn=no
set makeprg=g++\ %\ -o\ %:r
set helpheight=10
set termguicolors
set laststatus=0
set sidescroll=1 sidescrolloff=5
set timeout timeoutlen=200
set ttimeout ttimeoutlen=50
set wrap
syntax on

let g:AutoPairsMapCR = 0

if has('win32')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" =========================
" Auto-save>
" =========================
autocmd InsertLeave * silent! write
autocmd BufLeave,FocusLost * silent! write
autocmd CursorHold,CursorHoldI * checktime
autocmd FocusGained,BufEnter * checktime

" =========================
" General keymaps
" =========================
inoremap <C-s> <Esc>:w<CR>a
nnoremap <A-]> :bnext<CR>
nnoremap <A-[s> :bprevious<CR>
nnoremap <silent> <leader>bd :bp \| sp \| bn \| bd<CR>
tnoremap <Esc> <C-\><C-q>

vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
xnoremap > >gv
xnoremap < <gv
nnoremap <C-c> <C-v>

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" =========================
" Plugins
" =========================
call plug#begin(stdpath('config').'/plugged')
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

  " Editing / bracket pairs
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'

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
  Plug 'ej-shafran/compile-mode.nvim'
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

  
call plug#end()

set guicursor=n-v-c:block-CursorNormal
set guicursor+=i:block-CursorInsert
set guicursor+=r:block-CursorReplace
set guicursor+=v:block-CursorVisual
highlight CursorNormal  guifg=black guibg=#ffffff
highlight CursorInsert  guifg=black guibg=#00ff00
highlight CursorReplace guifg=white guibg=#ff0000
highlight CursorVisual  guifg=black guibg=#FF00FF
highlight! link @lsp.typemod.variable.defaultLibrary.cpp Identifier

highlight Keyword guifg     =#0000ff gui=bold
highlight Conditional guifg =0000ff gui=bold
highlight Repeat guifg      =#0000ff gui=bold
highlight Type guifg        =#0000ff gui=bold
highlight Function guifg    =#0000ff gui=bold
highlight Include guifg     =#ffffff gui=bold
highlight PreProc guifg     =#0000ff gui=bold
highlight Identifier guifg  =#0000ff
highlight Constant guifg    =#0000ff
highlight String guifg      =#ffffff
highlight Include      guifg=#0000ff
highlight Comment      guifg=#00ff00 gui=bold

let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>' 
let g:multi_cursor_select_all_word_key = '<A-b>' 
let g:multi_cursor_start_key           = 'g<C-n>' 
let g:multi_cursor_select_all_key      = 'g<A-b>' 
let g:multi_cursor_next_key            = '<C-n>' 
let g:multi_cursor_prev_key            = '<C-p>' 
let g:multi_cursor_skip_key            = '<C-m>' 
let g:multi_cursor_quit_key            = '<Esc>' 


" =========================
" Sourced config files
" =========================
source ~/.config/nvim/plugged/nvimtree/nvimtree-config.vim
source ~/.config/nvim/plugged/RunProgramming.vim

luafile ~/.config/nvim/plugged/compile.lua


" =========================
" Lua config
" =========================
lua << EOF
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true },
})

require('bufferline').setup({})

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = false,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "compilation",
  callback = function()
    vim.cmd("wincmd J")
    vim.api.nvim_win_set_height(0, 10)
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = false
  end,
})

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
  matching = { disallow_symbol_nonprefix_matching = false }
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
EOF

" Tmux

" =========================
" Tmux status integration (mode + line)
" =========================
if exists('$TMUX')
lua << EOF
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

    t:start(30, 0, vim.schedule_wrap(function()
        if mode then
            vim.fn.jobstart({
                'tmux', 'set-option', '-p', '@nvim_mode', mode
            }, { detach = true })
        end

        if line then
            vim.fn.jobstart({
                'tmux', 'set-option', '-p', '@nvim_line', line
            }, { detach = true })
        end

        vim.fn.jobstart({
            'tmux', 'refresh-client', '-S'
        }, { detach = true })

        if not t:is_closing() then
            t:close()
        end

        if timer == t then
            timer = nil
        end
    end))
end

-- Cập nhật mode
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function()
        local mode = vim.fn.mode()
        local label

        if mode == "n" then
            label = "NORMAL"
        elseif mode == "i" then
            label = "INSERT"
        elseif mode == "R" then
            label = "REPLACE"
        elseif mode:match("^[vV\22]") then
            label = "VISUAL"
        elseif mode == "c" then
            label = "COMMAND"
        else
            label = mode
        end

        tmux_update(label, nil)
    end,
})

-- Cập nhật dòng hiện tại
vim.api.nvim_create_autocmd({
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
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if timer then
            timer:stop()
            if not timer:is_closing() then
                timer:close()
            end
        end

        vim.fn.jobstart({
            'tmux', 'set-option', '-p', '@nvim_mode', ''
        }, { detach = true })

        vim.fn.jobstart({
            'tmux', 'set-option', '-p', '@nvim_line', ''
        }, { detach = true })
    end,
})
EOF
endif

" Thoát Insert mode bằng jk thay vì Esc
inoremap <C-d> <Esc>

" Thoát Terminal mode bằng jk (thay cho Ctrl-q bạn đang dùng)
tnoremap <C-x> <C-\><C-n>

" Move cursor in the mode insert
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-w> <C-o>w
inoremap <C-b> <C-o>b
inoremap <C-e> <C-o>e
