# vim-flashcard plugin
i    Fast and easy on screen flashcard reference
    Setup as many cards as you like, on whatever topics you like

## Screen Shot                                                                                                                   
![alt text](https://github.com/archernar/vim-flashcard/blob/main/Flashcard.png)

### Installation

Use your plugin manager

#### Example:  VruUndle

    Plugin 'archernar/vim-flashcard'




### Map call g:FlashCard(<full path of flashcard file>)
        
#### Example:
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
