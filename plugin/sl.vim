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

    let l:s = synID(line("."), col("."), 1)
    let l:attr = synIDattr(l:s, "name")
    let l:trans = synIDattr(synIDtrans(l:s), "name")

    if l:attr != ""
        if l:trans != "" && l:trans != l:attr
            return printf("\ %s\ ->\ %s\ ", l:attr, l:trans)
        else
            return printf("\ %s\ ", l:attr)
        endif
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
    if PlugLoaded("ale")
        let l:counts = ale#statusline#Count(bufnr(""))

        if l:counts.total == 0
            return ""
        else
            return printf("\ [%d]\ ", l:counts.total)
        endif
    else
        return ""
    endif
endfunction

function! ReadOnly() abort
    if &readonly || !&modifiable
        return "\ [RO]\ "
    else
        return ""
    endif
endfunction

function! Modified() abort
    if &modified
        return "\ [+]\ "
    else
        return ""
    endif
endfunction

function! FileType() abort
    if g:sl_hide_file_type == 1
        return ""
    endif

    if len(&filetype) == 0
        return "\ text\ "
    endif

    return printf("\ %s\ ", tolower(&filetype))
endfunction

let NERDTreeStatusline="%1*\ NERDTree\ %3*"

set laststatus=2

function! ActiveStatusLine() abort
    let l:statusline=""
    let l:statusline.="%1*\ %t\ "
    let l:statusline.="%{ReadOnly()}"
    let l:statusline.="%{Modified()}"
    let l:statusline.="%{LinterStatus()}"
    let l:statusline.="%3*%=%1*"
    let l:statusline.="%{SyntaxItem()}"
    let l:statusline.="%{FileType()}"
    let l:statusline.="\ %l/%L:%c\ "

    return l:statusline
endfunction

function! InactiveStatusLine() abort
    let l:statusline=""
    let l:statusline.="%2*\ %t\ "
    let l:statusline.="%3*%=%2*"
    let l:statusline.="\ %l/%L:%c\ "

    return l:statusline
endfunction

function! SetActiveStatusLine() abort
    if &ft ==? "nerdtree"
        return
    endif

    setlocal statusline=
    setlocal statusline+=%!ActiveStatusLine()
endfunction

function! SetInactiveStatusLine() abort
    if &ft ==? "nerdtree"
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
