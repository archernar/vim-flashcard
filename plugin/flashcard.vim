let g:FLASHCARDNUM = 1


function! g:FlashCard()
     let g:FLASHCARDNUM = 1
     call s:FlashCardOpen(g:FLASHCARDNUM)
endfunction

function! g:FlashCardNext(...)
    exe "bd!"
    let g:FLASHCARDNUM = g:FLASHCARDNUM + 1
    call s:FlashCardOpen(g:FLASHCARDNUM)
endfunction

function! s:FlashCardCount()
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


function! s:FlashCardOpen(...)
        exe "set nopaste"
        let l:f = $HOME . "/1.fc"
        if filereadable(l:f)
            silent exe "tabnew " . l:f
            let l:fcc = s:FlashCardCount()
            nnoremap <silent> <buffer> q :bd!<cr>
            nnoremap <silent> <buffer> n :call g:FlashCardNext()<cr>
            nnoremap <silent> <buffer> <F1> :bd!<cr>
            nnoremap <silent> <buffer> <F2> :call g:FlashCardNext()<cr>
            nnoremap <silent> <buffer> <F3> :call g:FlashCardNext()<cr>
            silent exe "normal gg0"

            let g:FLASHCARDNUM  = a:1
            if (g:FLASHCARDNUM  > l:fcc )
                let g:FLASHCARDNUM  = 1
            endif

            let l:c = g:FLASHCARDNUM

            silent exe "normal gg0"
            let l:c = 0
            while  (l:c < (g:FLASHCARDNUM+1))
                let l:n = search("FLASH")
                silent exe "normal l"
                let l:c = l:c + 1 
            endwhile
            silent exe "normal " . "1000" . "dd"

            if ( 1 == 1 )
				let l:n = search("FLASH",'b')
				silent exe "normal gg0"
				silent exe "normal " . l:n . "dd"
				call s:FlashCardDisplay()
            endif
            exe "setlocal readonly"

        endif
        exe "set paste"
endfunction


function! s:FlashCardDisplay()
    exe "set paste"
    exe "normal gg0"
    exe "%s/^/                                       /"
    exe "normal gg0"
    exe "normal! O                                     + ------------------------------------------------------\<Esc>"
    exe "normal! O\<Esc>"
    exe "normal! O\<Esc>"
    exe "normal! O\<Esc>"
    exe "normal! O\<Esc>"
    exe "normal! O\<Esc>"
    exe "normal! O\<Esc>"
    exe "normal G0"
    exe "normal! o\<Esc>"
    let l:l = line('.')
    while l:l < 24
        exe "normal! o\<Esc>"
        let l:l = l:l + 1
    endwhile
    exe "normal! o                                     + ------------------------------------------------------\<Esc>"
    exe "set nopaste"
endfunction
