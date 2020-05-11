%assign bootloader_memory_address 7c0h
%assign bootloader_size 2048
%assign stack_size 1024
%assign stack_pointer_initial_offset stack_size - 1

; set up stack space after this bootloader
mov ax, bootloader_memory_address
add ax, bootloader_size ; skip to the end of the bootloader
mov ss, ax ; set stack segment
mov sp, stack_pointer_initial_offset ; set stack pointer to empty stack (remember the stack is reversed)

; set up the data segment after the stack
add ax, stack_size ; skip to the end of the stack
mov ds, ax ; set data segment
mov si, ds ; set source index pointer
mov di, ds ; set destination index pointer
