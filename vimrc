
" Key map modifiers:
" C - Control
" S - Shift
" A - Alt (same as meta)
" M - Meta (same as alt)
" D - Super (mac)
" T - Super (gtk2)
" See also http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_2%290

"execute pathogen#infect()
filetype plugin on
"let g:vimwiki_list = [{'auto_export': 1}]

" Syntastic setup (see https://github.com/scrooloose/syntastic)
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_xml_checkers = []

" Configure spelling
set spelllang=en
autocmd FileType xml set spell
autocmd FileType text set spell
autocmd FileType vimwiki set spell
autocmd BufWinEnter * syn spell toplevel

color desert
set nocompatible    " Use Vim defaults instead of 100% vi compatibility
set guifont=Inconsolata:h14
set ai
set hlsearch
let mapleader="\\"

" God's own true tabwidth
set softtabstop=2
set shiftwidth=2
set expandtab

set modelines=5

" Show tabs where they occur
autocmd Syntax * syn match TAB_CHAR "\t"
autocmd Syntax * hi link TAB_CHAR Error

" Playing along nice with the heathens
autocmd FileType python setlocal softtabstop=4
autocmd FileType python setlocal shiftwidth=4

" Resiprocate is extra special.
autocmd BufReadPost *.[ch]xx setlocal softtabstop=3
autocmd BufReadPost *.[ch]xx setlocal shiftwidth=3

" Make files have special rules. Fine. Let them.
autocmd FileType make setlocal softtabstop=0
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal tabstop=8
autocmd FileType make setlocal noexpandtab

" Go uses tabs
autocmd FileType go setlocal softtabstop=0
autocmd FileType go setlocal shiftwidth=2
autocmd FileType go setlocal tabstop=2
autocmd FileType go setlocal noexpandtab


" Syntax Highlighting Good.
syn on
filetype on
se nu
"filetype plugin on
au BufNewFile,BufRead *.webidl set filetype=idl
au BufNewFile,BufRead *.jsm set filetype=javascript

" Don't muck with my comments, thanks.
setlocal fo-=ro

" Ack
let g:ackprg="/opt/local/bin/ack-5.12 -H --nocolor --nogroup --column"

" Move buffers
function! MoveBuf(direction)
    let bufno = bufnr("%")
    hide
    exec "wincmd " . a:direction
    new
    exec "buffer " . bufno
endfunction
map <C-W><M-h> :call MoveBuf("h")<CR>
map <C-W><M-l> :call MoveBuf("l")<CR>
map <C-W><M-j> :call MoveBuf("j")<CR>
map <C-W><M-k> :call MoveBuf("k")<CR>

" Shift-w to wrap text -- TODO -- use &textwidth instead of 78
" map <S-W> :!fmt -l0 -w78<CR>
map <expr> <S-W> ":!fmt -l0 -w " . &textwidth . "<CR>"

" \r to insert random number
nmap <silent> <leader>r :r!perl -e 'print "a=extmap:1 urn:ietf:params:rtp-hdrext:stream-correlator ".int(65536 * rand)'<CR>

" see http://vim.wikia.com/wiki/Browsing_programs_with_tags
"set tags=./tags,tags,/Users/Adam/devel/mozilla/mozilla-central/tags
set tags=./tags;

" Highlight trailing whitespaces
"match Todo /\s\+$/
autocmd BufWinEnter * let w:m1=matchadd('Todo', '\s\+$', -1)

" Highlight long lines (removed "python")
"autocmd FileType c,cpp,java,php,ruby,js,javascript,html match ErrorMsg '\%>80v.\+'
"autocmd FileType c,cpp,java,php,ruby,js,javascript,html let w:m2 = matchadd('ErrorMsg', printf('\%%>%dv.\+',&textwidth), -1)
autocmd FileType text,c,cpp,java,php,ruby,js,javascript,html se textwidth=120

" Highlight tabs with underline/undercurl
highlight Tabs term=undercurl cterm=undercurl gui=undercurl guisp=#4040A0
autocmd BufWinEnter * let w:m2=matchadd('Tabs', '\t\+', -1)

" Set up textwidth indicators with a marked column and highlighted text.
se textwidth=255
autocmd BufWinEnter * let &colorcolumn=&textwidth
autocmd BufWinEnter * let w:m3=matchadd('ErrorMsg', printf('\%%>%dv.\+',&textwidth), -1)
highlight ColorColumn ctermbg=lightyellow guibg=#202020

" Trim trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    let s = @/
    %s/\s\+$//e
    call cursor(l, c)
    let @/ = s
endfun

" Removed ,python temporarily
"autocmd FileType c,cpp,js,javascript,java,php,ruby autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()


"Open tag in new window with ctrl-enter
nnoremap <C-Enter>  :<C-u>tab stag <C-r><C-w><CR>
nnoremap <S-Enter>  :<C-u>tab stag <C-r><C-w><CR>

"Open in tabs by default
augroup open-tabs
    au!
    au VimEnter * ++nested if !&diff | tab all | tabfirst | endif
augroup end

"Next/Previous Tabs
nnoremap <D-S-left>  :tabprevious<CR>
nnoremap <D-S-right> :tabnext<CR>

"nnoremap <D-S-Enter> :!open -a Eclipse %<CR><CR>
nnoremap <D-S-Enter> :!open http://dxr.mozilla.org/mozilla-central/search?redirect=true\&q=%:t<CR><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimwiki special handling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>LinkBugs()
    let l = line(".")
    let c = col(".")
    let s = @/
    %s/\[Bug \(\d\+\)\]/[[https:\/\/bugzilla.mozilla.org\/buglist.cgi\?quicksearch=\1|Bug \1]]/gie
    call cursor(l, c)
    let @/ = s
endfun
autocmd FileType vimwiki autocmd BufWritePre <buffer> :call <SID>LinkBugs()

map <Leader>d a<C-R>=strftime('%Y-%m-%d')<CR><Esc>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XML Reformatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XML formatter
function! DoFormatXML() range
  " Save the file type
  let l:origft = &ft

  " Clean the file type
  set ft=

  " Add fake initial tag (so we can process multiple top-level elements)
  exe ":let l:beforeFirstLine=" . a:firstline . "-1"
  if l:beforeFirstLine < 0
    let l:beforeFirstLine=0
  endif
  exe a:lastline . "put ='</PrettyXML>'"
  exe l:beforeFirstLine . "put ='<PrettyXML>'"
  exe ":let l:newLastLine=" . a:lastline . "+2"
  if l:newLastLine > line('$')
    let l:newLastLine=line('$')
  endif

  " Remove XML header
  exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

  " Recalculate last line of the edited code
  let l:newLastLine=search('</PrettyXML>')

  " Execute external formatter
  exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

  " Recalculate first and last lines of the edited code
  let l:newFirstLine=search('<PrettyXML>')
  let l:newLastLine=search('</PrettyXML>')

  " Get inner range
  let l:innerFirstLine=l:newFirstLine+1
  let l:innerLastLine=l:newLastLine-1

  " Remove extra unnecessary indentation
  exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

  " Remove fake tag
  exe l:newLastLine . "d"
  exe l:newFirstLine . "d"

  " Put the cursor at the first line of the edited code
  exe ":" . l:newFirstLine

  " Restore the file type
  exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

