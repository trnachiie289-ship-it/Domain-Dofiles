let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

lua << EOF
require("nvim-tree").setup({
  filters = {
    dotfiles = false,
    custom = {},
  },
})

require("nvim-tree").setup({
  filters = {
    dotfiles = false,
    custom = {
      "^[^.]*$",  -- ẩn file không có dấu chấm (không có đuôi mở rộng)
    },
  },
})

EOF
nnoremap <C-i> :NvimTreeToggle<CR>
