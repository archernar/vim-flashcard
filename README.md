# vim-flashcard plugin

    Fast and easy on screen flashcard reference
    Setup as many cards as you like, on whatever topics you like

## Screen Shot                                                                                                                   
![alt text](https://github.com/archernar/vim-flashcard/blob/main/Flashcard.png)

### Installation

    Use your plugin manager
    Map call g:FlashCard(<full path of flashcard file>)

#### Example:  Vundle

    Plugin 'archernar/vim-flashcard'
    nnoremap <F3> :call g:FlashCard($HOME . "/1.fc")<cr>



### Simple Flash Card File Setup

#### Example :
    <CR>
    FLASHCARD
    <Contents>
    FLASHCARD
    <Contents>
    FLASHCARD
    <Contents>
    FLASHCARD
    <Contents>
    FLASHCARD
    <CR>
