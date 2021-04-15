function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    if l:counts.total == 0
        return ""
    else
        return printf("[%d] ", l:counts.total)
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
    if len(&filetype) == 0
        return "text"
    endif

    return tolower(&filetype)
endfunction

let NERDTreeStatusline="%1* nerdtree %3*"

set laststatus=2

function! ActiveStatusLine() abort
    let l:statusline=""
    let l:statusline.=" %1*%t "
    let l:statusline.="%1*%{ReadOnly()}"
    let l:statusline.="%1*%{Modified()}"
    let l:statusline.="%1*%{LinterStatus()}"
    let l:statusline.="%3*%="
    let l:statusline.="%1*%l:%c/%L "
    let l:statusline.="%1*%{FileType()} "

    return l:statusline
endfunction

function! InactiveStatusLine() abort
    let l:statusline=""
    let l:statusline.=" %2*%t"
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
