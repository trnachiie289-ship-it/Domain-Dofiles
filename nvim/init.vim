set nobackup
set noswapfile
set mouse=a
set expandtab
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:\¦\
set foldmethod=syntax
set foldnestmax=1
set foldlevelstart=5
set number
set ignorecase
set completeopt=menuone,noinsert,noselect
set autowrite
set autowriteall
set errorformat=%f:%l:%c:%m
let g:AutoPairsMapCR = 0
set guicursor=a:block
set synmaxcol=5000
set lazyredraw
set signcolumn=no
set makeprg=g++\ %\ -o\ %:r
set errorformat=%f:%l:%c:%m
set helpheight=10
set cursorline
syntax on

autocmd InsertLeave * silent! write
autocmd BufLeave,FocusLost * silent! write
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

if has('win32')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

"ile
autocmd CursorHold,CursorHoldI * checktime
autocmd FocusGained,BufEnter * checktime


nnoremap <C-m> :FloatermToggle<CR>
vnoremap // y/\v<c-r>=escape(@",'/\')<cr><cr>
nnoremap /<cr> :noh<cr>


inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>

vnoremap K :m '<-2<cr>gv=gv
vnoremap J :m '>+1<cr>gv=gv

call plug#begin(stdpath('config').'/plugged')
  Plug 'm4xshen/autoclose.nvim'

  Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
" File browser

" Status bar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

"inal
  Plug 'voldikss/vim-floaterm'

"ide/se'}
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'

"ighht
  Plug 'sheerun/vim-polyglot'
  
" Debugging
  Plug 'puremourning/vimspector'

"ion control 
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'airblade/vim-gitgutter'
  Plug 'samoshkin/vim-mergetool'

" Fold 
  Plug 'tmhedberg/SimpylFold'

" Exchange text 
  Plug 'tommcdo/vim-exchange'
  Plug 'mg979/vim-visual-multi'
  Plug 'terryma/vim-multiple-cursors'

  
" LSP + Autocomplete
  Plug 'neovim/nvim-lspconfig'

"inder
  Plug 'nvim-lua/plenary.nvim'
" Highlight C++ ngon hơn
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Run code
  Plug 'akinsho/toggleterm.nvim', {'tag': '*'}

  Plug 'terryma/vim-multiple-cursors'

  Plug 'sphamba/smear-cursor.nvim'

  Plug 'numToStr/Comment.nvim'

  Plug 'lukas-reineke/indent-blankline.nvim'

  Plug 'numToStr/Comment.nvim'
  Plug 'ej-shafran/compile-mode.nvim'
  Plug 'nvim-lua/plenary.nvim'

  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

" 1. Kích hoạt Theme
set termguicolors
let g:nightflyTransparent = 0
colorscheme nightfly
let g:airline_theme='nightfly'

let g:multi_cursor_use_default_mapping=0


let g:multi_cursor_select_all_word_key = '<A-g>'

le'g<A-n>'
let g:multi_cursor_next_key            = '<C-b>'
let g:multi_cursor_prev_key            = '<C-g>'
let g:multi_cursor_skip_key            = '<C-t>'
let g:multi_cursor_quit_key            = '<Esc>'

" =========================
" Basic Highlight
" =========================

highlight Normal       guifg=#FFFFFF
highlight Comment      guifg=#32CD32 gui=bold
highlight Constant     guifg=#FFFFFF gui=bold
highlight String       guifg=#FFFFFF
highlight Character    guifg=#FFFFFF
highlight Number       guifg=#FFFFFF gui=bold

highlight Identifier   guifg=#2B92FF
highlight Function     guifg=#FFFF00 gui=bold

highlight Statement    guifg=#ED1ADC gui=bold
highlight Keyword      guifg=#ED1ADC gui=bold
highlight Conditional  guifg=#ED1ADC gui=bold
highlight Repeat       guifg=#ED1ADC gui=bold

highlight Type         guifg=#FFFF00 gui=bold
highlight StorageClass guifg=#ED1ADC gui=bold

highlight PreProc      guifg=#FFFFFF
highlight Include      guifg=#FFFFFF
highlight Define       guifg=#FFFFFF

highlight Operator     guifg=#00CED1

" =========================
" C/C++
" =========================

highlight cStatement   guifg=#ED1ADC gui=bold
highlight cRepeat      guifg=#ED1ADC gui=bold
highlight cConditional guifg=#ED1ADC gui=bold
highlight cppStatement guifg=#ED1ADC gui=bold
highlight cppModifier  guifg=#ED1ADC gui=bold
highlight cppType      guifg=#FFFF00 gui=bold


set guicursor=n-v-c:block-CursorNormal
set guicursor+=i:block-CursorInsert
set guicursor+=r:block-CursorReplace
set guicursor+=v:block-CursorVisual

highlight CursorNormal  guifg=black guibg=#ffffff
highlight CursorInsert  guifg=black guibg=#00ff00
highlight CursorReplace guifg=white guibg=#ff0000
highlight CursorVisual  guifg=black guibg=#FF00FF

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

nnoremap <silent> <leader>bd :bp \| sp \| bn \| bd<CR>

for setting_file in split(glob(stdpath('config').'/settings/*.vim'))
  execute 'source' setting_file
endfor

tnoremap <Esc> <C-\><C-q>

nnoremap <F6> :w<CR>:!g++ % -o %:r -L/usr/local/lib -I/usr/local/include -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 && ./%:r<CR>

nnoremap <C-]> :bnext<CR>
nnoremap <C-[> :bprevious<CR>


let g:VM_maps = {}
let g:VM_maps['Add Cursor At Pos'] = '<Space>' 

inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"


lua << EOF
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true },
})
EOF

lua << EOF
require('smear_cursor').setup({
})
EOF

lua << EOF
require("autoclose").setup()
EOF

source ~/.config/nvim/plugged/nvimtree/nvimtree-config.vim

lua << EOF
vim.g.compile_mode = {
    default_command = "g++ -std=c++17 -o ",
    baleia_setup = false,
    bang_expansion = false,
    directory_change_matchers = {},
    error_regexp_table = {},
    error_ignore_file_list = {},
    error_threshold = require("compile-mode").level.WARNING,
    auto_jump_to_first_error = false,
    error_locus_highlight = 500,
    use_diagnostics = false,
    recompile_no_fail = false,
    ask_about_save = false,
    ask_to_interrupt = false,
    buffer_name = "*Compile Open Source*",
    time_format = "%a %b %e %H:%M:%S",
    hidden_output = {},
    environment = nil,
    clear_environment = false,
    input_word_completion = true,
    hidden_buffer = false,
    focus_compilation_buffer = true,
    auto_scroll = false,
    use_circular_error_navigation = false,
    debug = false,
    use_pseudo_terminal = true,
}
EOF

lua << EOF
vim.api.nvim_create_autocmd("FileType", {
  pattern = "compilation",
  callback = function()
    vim.cmd("wincmd J")   -- di chuyển cửa sổ hiện tại xuống dưới cùng
vim.api.nvim_win_set_height(0, 10)  -- chiều cao 15 dòng, chỉnh tùy ý
  end,
})
EOF

lua << EOF
require('bufferline').setup({})
EOF

source ~/.config/nvim/plugged/nvimtree/nvimtree-config.vim
source ~/.config/nvim/plugged/RunProgramming.vim
