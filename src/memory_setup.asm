; set up 4K stack space after this bootloader
mov ax, 7c0h ; 7c0 is the address of the bootloader
add ax, 1024 ; skip to the end of the bootloader
mov ss, ax ; set stack segment
mov sp, 4095 ; set stack pointer to empty stack (remember the stack is reversed)

; set up the data segment after the stack
mov ax, 7c0h ; 7c0 is the address of the bootloader
add ax, 1024 ; skip to the end of the bootloader
add ax, 4096 ; skip to the end of the stack
mov ds, ax ; set data segment
mov si, ds ; set source index pointer
mov di, ds ; set destination index pointer
