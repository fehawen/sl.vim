if !exists("g:sl_hide_syntax_item")
    let g:sl_hide_syntax_item = 0
endif

if !exists("g:sl_hide_file_type")
    let g:sl_hide_file_type = 0
endif

function! SyntaxItem() abort
    if g:sl_hide_syntax_item == 1
        return ""
    endif

    let l:syntaxname = synIDattr(synID(line("."), col("."), 1), "name")

    if l:syntaxname != ""
        return printf("%s ", l:syntaxname)
    else
        return ""
    endif
endfunction

function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir))
endfunction

function! LinterStatus() abort
    if PlugLoaded('ale')
        let l:counts = ale#statusline#Count(bufnr(''))

        if l:counts.total == 0
            return ""
        else
            return printf("[%d] ", l:counts.total)
        endif
    else
        return ""
    endif
endfunction

function! ReadOnly() abort
    if &readonly || !&modifiable
        return "[RO] "
    else
        return ""
    endif
endfunction

function! Modified() abort
    if &modified
        return "[+] "
    else
        return ""
    endif
endfunction

function! FileType() abort
    if g:sl_hide_file_type == 1
        return ""
    endif

    if len(&filetype) == 0
        return "text"
    endif

    return tolower(&filetype)
endfunction

let NERDTreeStatusline="%1* nerdtree %3*"

set laststatus=2

function! ActiveStatusLine() abort
    let l:statusline=""
    let l:statusline.="%1*%t "
    let l:statusline.="%{ReadOnly()}"
    let l:statusline.="%{Modified()}"
    let l:statusline.="%{LinterStatus()}"
    let l:statusline.="%{SyntaxItem()}"
    let l:statusline.="%3*%="
    let l:statusline.="%1*%l,%c"
    let l:statusline.=" %{FileType()}"

    return l:statusline
endfunction

function! InactiveStatusLine() abort
    let l:statusline=""
    let l:statusline.="%2*%t"
    let l:statusline.="%3*"

    return l:statusline
endfunction

function! SetActiveStatusLine() abort
    if &ft ==? 'nerdtree'
        return
    endif

    setlocal statusline=
    setlocal statusline+=%!ActiveStatusLine()
endfunction

function! SetInactiveStatusLine() abort
    if &ft ==? 'nerdtree'
        return
    endif

    setlocal statusline=
    setlocal statusline+=%!InactiveStatusLine()
endfunction

augroup statusline
    autocmd!
    autocmd WinEnter,BufEnter * call SetActiveStatusLine()
    autocmd WinLeave,BufLeave * call SetInactiveStatusLine()
augroup end
