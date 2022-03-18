"
"
" nnoremap <F3> :call g:FlashCard($HOME . "/1.fc")<cr> 
"
"

let g:FLASHCARDFILE = ""
let g:FLASHCARDNUM = 1
let g:dashcount = 60 

function! g:FlashCard(...)
     let g:FLASHCARDNUM  = 1
     let g:FLASHCARDFILE = a:1
     call g:FlashCardOpen(g:FLASHCARDFILE, g:FLASHCARDNUM)
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
            silent exe "normal " . "2000" . "dd"

	    	let l:n = search("FLASH",'b')
			silent exe "normal gg0"
			silent exe "normal " . l:n . "dd"
			call g:FlashCardDisplay()
            exe "setlocal readonly"

        endif
        echom " <F1> Quit FlashCard, <F2> Previous FlashCard <F3> Next FlashCard"
        exe "set paste"
endfunction

function! g:FlashCardDisplay()
    silent exe "set paste"
    silent exe "normal! gg0VG"
    silent exe "normal! \"ay"
    silent exe "normal! gg0VG"
    silent exe "%s/./a/g"
    silent exe "sort!"
    silent exe "normal! \<Esc>"

    if ( g:dashcount < len(getline('.')) )
        let g:dashcount = len(getline('.'))
    endif

    silent exe "normal! gg0VGd"
    silent exe "normal! \"ap"
    let l:dent = 24 
    silent exe "normal gg0"
    silent exe "%s/^/" . repeat(" ", l:dent+2) . "/"
    silent exe "normal gg0"
    silent exe "normal! O" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"
    silent exe "normal! 7O\<Esc>"
    silent exe "normal! G0"
    silent exe "normal! " .  (((26-line('.'))>0) ? 26-line('.') : 0) . "o\<Esc>"
    silent exe "normal! o" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-40) . "git@github.com:archernar/vim-flashcard.git\<Esc>" 
    silent exe "normal! gg0"
    silent exe "set nopaste"
endfunction

