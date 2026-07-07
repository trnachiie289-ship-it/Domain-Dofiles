function! RunProgramming()
  silent! write
  let file = expand('%')
  let out  = expand('%:r')
  let opts = "-std=c++17 -Wall -g"
  let libs = "-lraylib -lGL -lm -lpthread -ldl -lrt -lX11"
  let cmd  = "g++ " . opts . " " . shellescape(file) . " -o " . shellescape(out) . " " . libs
  let display_cmd = "cc -o " . out . " " . file
  let tmp = tempname() . ".sh"
  call writefile([
        \ '#!/bin/bash',
        \ 'start_time=$(date "+%a %d %b %Y %I:%M:%S %p %z")',
        \ 'start_ts=$(date +%s.%N)',
        \ 'echo "Compilation started at $start_time"',
        \ 'echo "' . display_cmd . '"',
        \ 'echo',
        \ cmd . ' 2>&1',
        \ 'code=$?',
        \ 'end_ts=$(date +%s.%N)',
        \ 'dur=$(echo "$end_ts - $start_ts" | bc)',
        \ 'if [ $code -eq 0 ]; then',
        \ '  ./' . out,
        \ '  end_time=$(date "+%a %d %b %Y %I:%M:%S %p %z")',
        \ '  echo',
        \ '  echo -e "\033[32mCompilation finished at $end_time, duration ${dur}\033[0m"',
        \ 'else',
        \ '  end_time=$(date "+%a %d %b %Y %I:%M:%S %p %z")',
        \ '  echo -e "\033[31mCompilation exited abnormally at $end_time, duration ${dur}\033[0m"',
        \ 'fi',
        \ ], tmp)
  call system('chmod +x ' . shellescape(tmp))
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&buftype') ==# 'terminal'
      execute w . 'wincmd w'
      silent! bwipeout!
      break
    endif
  endfor
  botright split
  resize 12
  silent! execute 'terminal ' . shellescape(tmp)
  startinsert
endfunction

" ==== Điều hướng cửa sổ bằng Ctrl-h/j/k/l ====
" Ở normal mode (buffer code bình thường)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Ở terminal mode (bên trong cửa sổ terminal mà RunProgramming() mở ra)
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Esc để thoát terminal-mode về normal-mode nhanh
tnoremap <Esc> <C-\><C-n>
nnoremap <F5> :call RunProgramming()<CR>
