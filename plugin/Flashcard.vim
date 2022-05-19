"
"
" nnoremap <F3> :call g:FlashCard($HOME . "/1.fc")<cr> 
"
"

let g:FLASHCARDFILE = ""
let g:FLASHCARDNUM = 1
let g:dashcount = 88 

" ******************************************************************
" These method have been deprecated
" ******************************************************************
function! g:FlashCardOpenRawXXX(...)
        exe "set nopaste"
        let l:f = a:1
        if filereadable(l:f)
            silent exe "tabnew " . l:f
            silent exe "set buftype=nowrite"
            nnoremap <silent> <buffer> q    :call g:FlashCardExit()<cr>
            nnoremap <silent> <buffer> <F1> :call g:FlashCardExit()<cr>
            nnoremap <silent> <buffer> <F2> <ESC>
            nnoremap <silent> <buffer> <F3> <ESC>
			call g:FlashCardDisplay()
            exe "setlocal readonly"
        endif
        echom " <F1> Quit FlashCard"
        exe "set paste"
endfunction
function! g:FlashCardRawXXX(...)
    if ( a:0 == 0 )
        let l:name = input('Enter file name: ')
        let g:FLASHCARDFILE = l:name
     else
        let g:FLASHCARDFILE = a:1
     endif

     if filereadable(g:FLASHCARDFILE)
         call g:FlashCardOpenRawXXX(g:FLASHCARDFILE)
     endif
endfunction
" ******************************************************************
" ******************************************************************


function! g:DumbCard(...)
     let g:FLASHCARDNUM  = 1
     let g:FLASHCARDFILE = a:1
     call g:DumbCardOpen(g:FLASHCARDFILE, g:FLASHCARDNUM)
	 call g:DumbCardDisplay()
     silent exe "normal gg0"
     exe "setlocal readonly"
endfunction
function! g:FlashCard(...)
     let g:FLASHCARDNUM  = 1
     let g:FLASHCARDFILE = a:1
     call g:FlashCardOpen(g:FLASHCARDFILE, g:FLASHCARDNUM)
endfunction

function! g:FlashCardCloseOpen(...)
         silent exe "bd!"
         " ******************************************************************
         " ****  See if the file contains a flashcard set of just text
         " ******************************************************************
         let l:f = a:1
         let l:fcc = 0
         if filereadable(l:f)
            silent exe "tabnew " . l:f
            silent exe "set buftype=nowrite"
            let l:fcc = g:FlashCardCount()
            silent exe "bd!"
         endif

     if (l:fcc > 0)
         if filereadable(a:1)
             let g:FLASHCARDNUM  = 1
             let g:FLASHCARDFILE = a:1
             call g:FlashCardOpen(g:FLASHCARDFILE, g:FLASHCARDNUM)
         endif
     else
         if filereadable(a:1)
             let g:FLASHCARDNUM  = 1
             let g:FLASHCARDFILE = a:1
             call g:DumbCard(g:FLASHCARDFILE, g:FLASHCARDNUM)
         endif
     endif

endfunction


function! g:FlashCardExit()
    silent exe "bd!"
    echom ""
endfunction

function! g:FlashCardNext(...)
    exe "bd!"
    let g:FLASHCARDNUM = g:FLASHCARDNUM + a:1 
    call g:FlashCardOpen(g:FLASHCARDFILE, g:FLASHCARDNUM)
endfunction

function! g:FlashCardCount()
    let l:n = 1 
    let l:c = 0
    silent exe "normal gg0"
    while l:n > 0
        let l:n = search("FLASH",'We')
        if ( l:n > 0 )
            let l:c = l:c + 1 
        endif
    endwhile
    silent exe "normal gg0"
    let l:c = l:c - 1
    if ( l:c < 0 ) 
        let l:c = 0
    endif
    return l:c
endfunction

function! g:DumbCardOpen(...)
        let l:filename = a:1
        let l:cardnumber = a:2
        exe "set nopaste"
        let l:f = l:filename
        if filereadable(l:f)
            silent exe "tabnew " . l:f
            silent exe "set buftype=nowrite"
            nnoremap <silent> <buffer> q    :call g:FlashCardExit()<cr>
            nnoremap <silent> <buffer> <F1> :call g:FlashCardExit()<cr>
            nnoremap <silent> <buffer> <F2> <esc>
            nnoremap <silent> <buffer> <F3> <esc>
            nnoremap <silent> <buffer> <F4> <esc>
            nnoremap <silent> <buffer> <leader>1    :call g:FlashCardCloseOpen($FC1)<cr>
            nnoremap <silent> <buffer> <leader>2    :call g:FlashCardCloseOpen($FC2)<cr>
            nnoremap <silent> <buffer> <leader>3    :call g:FlashCardCloseOpen($FC3)<cr>
            nnoremap <silent> <buffer> <leader>4    :call g:FlashCardCloseOpen($FC4)<cr>
            silent exe "normal gg0"
        endif
        exe "set paste"
endfunction
function! g:FlashCardOpen(...)
        let l:filename = a:1
        let l:cardnumber = a:2
        exe "set nopaste"
        let l:f = $HOME . "/1.fc"
        let l:f = l:filename
        if filereadable(l:f)
            silent exe "tabnew " . l:f
            silent exe "set buftype=nowrite"

            let l:fcc = g:FlashCardCount()
            nnoremap <silent> <buffer> q    :call g:FlashCardExit()<cr>
            nnoremap <silent> <buffer> <F1> :call g:FlashCardExit()<cr>
            nnoremap <silent> <buffer> <F2> :call g:FlashCardNext(-1)<cr>
            nnoremap <silent> <buffer> <F3> :call g:FlashCardNext(1)<cr>
            nnoremap <silent> <buffer> <F4> <esc>
            nnoremap <silent> <buffer> <leader>1    :call g:FlashCardCloseOpen($FC1)<cr>
            nnoremap <silent> <buffer> <leader>2    :call g:FlashCardCloseOpen($FC2)<cr>
            nnoremap <silent> <buffer> <leader>3    :call g:FlashCardCloseOpen($FC3)<cr>
            nnoremap <silent> <buffer> <leader>4    :call g:FlashCardCloseOpen($FC4)<cr>
            silent exe "normal gg0"

            let g:FLASHCARDNUM  = l:cardnumber
            if (g:FLASHCARDNUM  > l:fcc)
                let g:FLASHCARDNUM = 1
            endif
            if (g:FLASHCARDNUM <= 0)
                let g:FLASHCARDNUM = l:fcc
            endif

            let l:c = g:FLASHCARDNUM

            silent exe "normal gg0"
            let l:c = 0
            while  (l:c < (g:FLASHCARDNUM+1))
                let l:n = search("FLASH")
                silent exe "normal l"
                let l:c = l:c + 1 
            endwhile
            silent exe "normal! dG"

	    	let l:n = search("FLASH",'b')
			silent exe "normal gg0"
			silent exe "normal " . l:n . "dd"
			call g:FlashCardDisplay()
            exe "setlocal readonly"

        endif
        exe "set paste"
endfunction


function! g:DumbCardDisplay()
    silent exe "set paste"
    silent exe "normal! gg0VG"
    silent exe "normal! \"ay"
    silent exe "normal! gg0VG"
    silent exe "%s/./a/g"
    silent exe "sort!"
    silent exe "normal! \<Esc>"

    let l:n = len(getline('.'))
    if (1==0)
        if ( g:dashcount < len(getline('.')) )
            let g:dashcount = len(getline('.'))
        endif
    endif

    let l:dent = 12 

    silent exe "normal! gg0VGd"
    silent exe "normal! \"ap"
    silent exe "normal gg0"
    silent exe "%s/^/" . repeat(" ", l:dent+2) . "/"
    silent exe "normal gg0"
    silent exe "normal! O" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"
    silent exe "normal! 4O\<Esc>"
    silent exe "normal! G0"
    silent exe "normal! " .  (((26-line('.'))>0) ? 26-line('.') : 0) . "o\<Esc>"
    silent exe "normal! o" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"

    let l:tag = "git@github.com:archernar/vim-flashcard.git"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    let l:tag = "<F1> Quit FlashCard"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    let l:tag = s:pb("1") . s:kh($FC1) . " " . s:pb("2") . s:kh($FC2)  . " " . s:pb("3") . s:kh($FC3)  . " " . s:pb("4") . s:kh($FC4)  
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    silent exe "normal! G0"
    silent exe "set nopaste"
endfunction
function! g:FlashCardDisplay()
    silent exe "set paste"
    silent exe "normal! gg0VG"
    silent exe "normal! \"ay"
    silent exe "normal! gg0VG"
    silent exe "%s/./a/g"
    silent exe "sort!"
    silent exe "normal! \<Esc>"

    let l:n = len(getline('.'))
    if (1==0)
        if ( g:dashcount < len(getline('.')) )
            let g:dashcount = len(getline('.'))
        endif
    endif

    let l:dent = 12 
"   if ( len(getline('.')) > 36)
"       let l:dent = 2 
"   endif

    silent exe "normal! gg0VGd"
    silent exe "normal! \"ap"
    silent exe "normal gg0"
    silent exe "%s/^/" . repeat(" ", l:dent+2) . "/"
    silent exe "normal gg0"
    silent exe "normal! O" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"
    silent exe "normal! 4O\<Esc>"
    silent exe "normal! G0"
    silent exe "normal! " .  (((26-line('.'))>0) ? 26-line('.') : 0) . "o\<Esc>"
    silent exe "normal! o" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"

    " https://stackoverflow.com/questions/4864073/using-substitute-on-a-variable
    let l:tag = "git@github.com:archernar/vim-flashcard.git"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    let l:tag = "<F1> Quit FlashCard, <F2> Previous FlashCard <F3> Next FlashCard"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    let l:tag = s:pb("1") . s:kh($FC1) . " " . s:pb("2") . s:kh($FC2)  . " " . s:pb("3") . s:kh($FC3)  . " " . s:pb("4") . s:kh($FC4)  
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    silent exe "normal! gg0"
    silent exe "set nopaste"
endfunction


function! s:kh(...)
    return substitute(a:1, $HOME, "~", "")
endfunction

function! s:pb(...)
    return "<L " . a:1 . ">" . " " 
endfunction
function! s:LogIt(...)
    silent exe "!echo 'Log:  " . a:1 .  "'>>/tmp/vimlog"
endfunction
