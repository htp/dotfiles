" Disable Vi-compatibility mode.
set nocompatible

" Copy the indent from the current line when starting a new line.
set autoindent

" Automatically reload files if they're changed outside of Vim.
set autoread

" Make backspace behave like it does in typical editors.
set backspace=eol,indent,start

" Tie vim's clipboard to macOS' pasteboard if possible.
if has("clipboard")
  set clipboard=unnamed
endif

" Keep swap files in ~/tmp by default; fall back to the same directory
" as the file being edited otherwise.
set directory=~/tmp//,.

" Insert spaces instead of tabs.
set expandtab

" Allow unsaved buffers in the background.
set hidden

" Highlight search matches.
set hlsearch

" Perform case-insensitive searches if the query is completely lowercase,
" and case-sensitive searches otherwise. (See also: smartcase.)
set ignorecase

" Search while typing search commands..
set incsearch

" Show line numbers. (See also: relativenumber.)
set number

" Show line numbers relative to the current line. (See also: number.)
set relativenumber

" Show the cursor line and cursor position.
set ruler

" Enable fzf integration when available.
if isdirectory("/usr/local/opt/fzf")
  set runtimepath+=/usr/local/opt/fzf
endif

" Indent using two spaces. (See also: softtabstop, tabstop.)
set shiftwidth=2

" Show the command (as it's being typed) on the last line of the screen.
set showcmd

" Perform case-insensitive searches if the query is completely lowercase,
" and case-sensitive searches otherwise. (See also: ignorecase.)
set smartcase

" Indent using two spaces. (See also: shiftwidth, tabstop.)
set softtabstop=2

" Add new splits top-to-bottom and left-to-right. (See also: splitright.)
set splitbelow

" Add new splits top-to-bottom and left-to-right. (See also: splitbelow.)
set splitright

" Indent using two spaces. (See also: shiftwidth, softtabstop.)
set tabstop=2

" Turn on command tab-completion.
set wildmenu
set wildmode=longest:full,full

" Enable file type detection.
filetype plugin indent on

" Enable syntax highlighting.
syntax enable

" Remap the leader key to ','.
let mapleader=","

" Map shortcut for turning off highlighting search matches.
noremap // :nohlsearch<CR>

" Map shortcuts for navigating tabs.
noremap <C-y> :tabprevious<CR>
noremap <C-o> :tabnext<CR>

" Map miscellaneous shortcuts.
nnoremap ! :!
nnoremap <leader>b  :buffer<space>
nnoremap <leader>bd :bdelete<space>
nnoremap <leader>c  :close<CR>
nnoremap <leader>e  :edit<space>
nnoremap <leader>f  :set filetype=
nnoremap <leader>hn :new<space>
nnoremap <leader>hr :vertical resize<space>
nnoremap <leader>hs :split<space>
nnoremap <leader>ls :buffers<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tn :tabnew<space>
nnoremap <leader>vn :vnew<space>
nnoremap <leader>vr :resize<space>
nnoremap <leader>vs :vsplit<space>
nnoremap <leader>w  :write<CR>

" When switching back to a buffer, automatically reload it if its file has changed.
autocmd! FocusGained,BufEnter * checktime

" Turn off syntax highlighting for Markdown files.
autocmd! FileType markdown setlocal syntax=off

" Directly include the contents of the vim-tmux-navigator plugin
" (https://github.com/christoomey/vim-tmux-navigator) to avoid installing
" a package manager for one plugin.

" Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are
" no more windows in that direction, forwards the operation to tmux.
" Additionally, <C-\> toggles between last active vim splits/tmux panes.
if exists("g:loaded_tmux_navigator") || &cp || v:version < 700
  finish
endif
let g:loaded_tmux_navigator = 1

function! s:VimNavigate(direction)
  try
    execute 'wincmd ' . a:direction
  catch
    echohl ErrorMsg | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k' | echohl None
  endtry
endfunction

if !get(g:, 'tmux_navigator_no_mappings', 0)
  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
  nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
endif

if empty($TMUX)
  command! TmuxNavigateLeft call s:VimNavigate('h')
  command! TmuxNavigateDown call s:VimNavigate('j')
  command! TmuxNavigateUp call s:VimNavigate('k')
  command! TmuxNavigateRight call s:VimNavigate('l')
  command! TmuxNavigatePrevious call s:VimNavigate('p')
  finish
endif

command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
command! TmuxNavigateRight call s:TmuxAwareNavigate('l')
command! TmuxNavigatePrevious call s:TmuxAwareNavigate('p')

if !exists("g:tmux_navigator_save_on_switch")
  let g:tmux_navigator_save_on_switch = 0
endif

if !exists("g:tmux_navigator_disable_when_zoomed")
  let g:tmux_navigator_disable_when_zoomed = 0
endif

function! s:TmuxOrTmateExecutable()
  return (match($TMUX, 'tmate') != -1 ? 'tmate' : 'tmux')
endfunction

function! s:TmuxVimPaneIsZoomed()
  return s:TmuxCommand("display-message -p '#{window_zoomed_flag}'") == 1
endfunction

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  return system(cmd)
endfunction

function! s:TmuxNavigatorProcessList()
  echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxNavigatorProcessList call s:TmuxNavigatorProcessList()

let s:tmux_is_last_pane = 0
augroup tmux_navigator
  au!
  autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

function! s:NeedsVitalityRedraw()
  return exists('g:loaded_vitality') && v:version < 704 && !has("patch481")
endfunction

function! s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
  if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
  endif
  return a:tmux_last_pane || a:at_tab_page_edge
endfunction

function! s:TmuxAwareNavigate(direction)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    call s:VimNavigate(a:direction)
  endif
  let at_tab_page_edge = (nr == winnr())
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    if g:tmux_navigator_save_on_switch == 1
      try
        update " save the active buffer. See :help update
      catch /^Vim\%((\a\+)\)\=:E32/ " catches the no file name error
      endtry
    elseif g:tmux_navigator_save_on_switch == 2
      try
        wall " save all the buffers. See :help wall
      catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
      endtry
    endif
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    silent call s:TmuxCommand(args)
    if s:NeedsVitalityRedraw()
      redraw!
    endif
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction
