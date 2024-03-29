"
"
" Map These
" nnoremap         <F3> :call g:FlashCard($FC1)<cr>
" nnoremap <leader><F3> :call g:UnFlashCard()<cr>
"
"

let g:FLASHCARDFILE = ""
let g:FLASHCARDNUM = 1
let g:dashcount = 106

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
            nnoremap <silent> <buffer> <leader>5    :call g:FlashCardCloseOpen($FC5)<cr>
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
            nnoremap <silent> <buffer> <leader>5    :call g:FlashCardCloseOpen($FC5)<cr>
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

    let l:dent = 6 

    silent exe "normal! gg0VGd"
    silent exe "normal! \"ap"
    silent exe "normal gg0"
    silent exe "%s/^/" . repeat(" ", l:dent+2) . "/"
    silent exe "normal gg0"
    silent exe "normal! O" . "D" . repeat(" ", l:dent-1) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"
    silent exe "normal! 4O\<Esc>"
    silent exe "normal! G0"
    silent exe "normal! " .  (((26-line('.'))>0) ? 26-line('.') : 0) . "o\<Esc>"
    silent exe "normal! o" . repeat(" ", l:dent) . "+ " . repeat("-", g:dashcount) . " +\<Esc>"

    let l:tag = "git@github.com:archernar/vim-flashcard.git"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    let l:tag = "<F1> Quit FlashCard"
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    let l:tag = s:pb("1") . s:kh($FC1) . " " . s:pb("2") . s:kh($FC2)  . " " . s:pb("3") . s:kh($FC3)  . " " . s:pb("4") . s:kh($FC4) . " " . s:pb("5") . s:kh($FC5)
    silent exe "normal! o" . repeat(" ", l:dent) . repeat(" ", g:dashcount-len(l:tag)+2) . l:tag . "\<Esc>" 
    silent exe "normal! G0"
    silent exe "set nopaste"
endfunction

function! g:FlashCardDisplay()
    " https://stackoverflow.com/questions/4864073/using-substitute-on-a-variable
    let l:lccV = nr2char(0x02551)
    let l:lccH = nr2char(0x02550)
    let l:lccTLC = nr2char(0x02554)
    let l:lccBLC = nr2char(0x0255A)
    let l:lccTRC = nr2char(0x02557)
    let l:lccBRC = nr2char(0x0255D)
    let l:moe1 = nr2char(0xe2) 
    let l:moe2 = nr2char(0x80)
    let l:moe3 = nr2char(0x93)
    let l:dent = 6 
    call s:SetPaste()
    call s:nexec("gg0VG", "\"ay", "gg0VG")
    call s:exec("%s/./a/g","sort!")
    call s:nexec("\<Esc>")
    let l:n = len(getline('.'))
    call s:nexec("gg0VGd", "\"ap", "gg0")
    " *******************************************************************************************************
    exe "normal! gg0"
				if ( 1 == 2)
					call s:nexec(
				\               "O" . "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" ."\<Esc>",
				\               "O" . "         1         2         3         4         5         6         7         8         9         1" ."\<Esc>")
				endif

    call g:MasterPadder(g:dashcount-1)
    call s:exec("%s/$/" . l:lccV . "/")
    " *******************************************************************************************************

    let l:quack = nr2char(0x02593)
    call s:exec("%s/^/" . repeat(l:quack, l:dent+0) . l:lccV . " /")
    call s:nexec(
\               "gg0",
\               "O" . repeat(l:quack, l:dent) . l:lccTLC . "" . repeat(l:lccH, g:dashcount) . "" . l:lccTRC ."\<Esc>",
\               "O" . repeat(l:quack, g:dashcount+8) . "\<Esc>",
\               "O" . repeat(l:quack, g:dashcount+8) . "\<Esc>",
\            	"G0",
\               "o" . repeat(l:quack, l:dent) . l:lccBLC . "" . repeat(l:lccH, g:dashcount) . "" . l:lccBRC . "\<Esc>"
\              )
" \               (((26-line('.'))>0) ? 26-line('.') : 0) . "o\<Esc>",

    call s:taglines(l:dent,"git@github.com:archernar/vim-flashcard.git",
\                          s:catter("<F1> Quit FlashCard, ", "<F2> Previous FlashCard, ", "<F3> Next FlashCard"),
\                          s:catter(s:pb("1"),s:kh($FC1),",",s:pb("2"),s:kh($FC2),",",s:pb("3"),s:kh($FC3),",",s:pb("4"),s:kh($FC4),",",s:pb("5"),s:kh($FC5)))

    call s:nexec("gg0")
    call s:SetNoPaste()
endfunction

"\            	"0O\<Esc>",
function! s:SetPaste()
    silent exe "set paste"
endfunction
function! s:SetNoPaste()
    silent exe "set nopaste"
endfunction
function! s:exec(...)
    let l:n = 1
    let l:sz = "" 
    while l:n <= a:0
        let l:sz = l:sz . get(a:, l:n, 0)
        silent exe  get(a:, l:n, 0)
        let l:n = l:n + 1
    endwhile
endfunction
function! s:nexec(...)
    let l:n = 1
    let l:sz = "" 
    while l:n <= a:0
        let l:sz = l:sz . get(a:, l:n, 0)
        let l:n = l:n + 1
    endwhile
    silent exe  "normal! " . l:sz
endfunction

function! s:catter(...)
    let l:n = 1
    let l:sz = "" 
    let l:delim = "" 
    while l:n <= a:0
        if get(a:, l:n, 0) == ","
            let l:delim = ""
        endif
        let l:sz = l:sz . l:delim . get(a:, l:n, 0)
        let l:n = l:n + 1
        let l:delim = " "
    endwhile
    return l:sz
endfunction

function! s:taglines(...)
    let l:n = 2
    let l:quack = nr2char(0x02593)
    while l:n <= a:0
        let l:sz = get(a:, l:n, 0)
        silent exe "normal! o" . repeat(l:quack, a:1) . repeat(" ", g:dashcount-len(l:sz)+2) . l:sz . "\<Esc>" 
        let l:n = l:n + 1
    endwhile
endfunction

function! s:tagline(...)
    silent exe "normal! o" . repeat(" ", a:1) . repeat(" ", g:dashcount-len(a:2)+2) . a:2 . "\<Esc>" 
endfunction

function! s:kh(...)
    return substitute(a:1, $HOME, "~", "")
endfunction

function! s:pb(...)
    return "<L " . a:1 . ">"
endfunction
function! s:LogIt(...)
    silent exe "!echo 'Log:  " . a:1 .  "'>>/tmp/vimlog"
endfunction
