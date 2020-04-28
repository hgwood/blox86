  BITS 16

start:
  mov ax, 07C0h		; Set up 4K stack space after this bootloader
  add ax, 288		; (4096 + 512) / 16 bytes per paragraph
  mov ss, ax
  mov sp, 4096

  mov ax, 07C0h		; Set data segment to where we're loaded
  mov ds, ax


  mov si, text_string	; Put string position into SI
  call print_string	; Call our string-printing routine

.wait_for_key_press:
  mov ah, 0
  int 16h
  cmp ah, 48h
  je .move_cursor_up
  cmp ah, 50h
  je .move_cursor_down
  cmp ah, 4bh
  je .move_cursor_left
  cmp ah, 4dh
  je .move_cursor_right
  mov ah, 0eh
  int 10h
  jmp .wait_for_key_press

.move_cursor_up:
  mov bh, 0h
  mov ah, 03h ; get cursor
  int 10h
  sub dh, 1
  mov ah, 02h ; set cursor
  int 10h
  jmp .wait_for_key_press

.move_cursor_down:
  mov bh, 0h
  mov ah, 03h
  int 10h
  add dh, 1
  mov ah, 02h
  int 10h
  jmp .wait_for_key_press

.move_cursor_left:
  mov bh, 0h
  mov ah, 03h
  int 10h
  sub dl, 1
  mov ah, 02h
  int 10h
  jmp .wait_for_key_press

.move_cursor_right:
  mov bh, 0h
  mov ah, 03h
  int 10h
  add dl, 1
  mov ah, 02h
  int 10h
  jmp .wait_for_key_press

.print_keys:
  mov ah, 0
  int 16h
  mov bh, ah
  mov bl, al
  mov al, bh
  mov ah, 0eh
  int 10h
  mov al, bl
  mov ah, 0eh
  int 10h
  jmp .print_keys

  jmp $			; Jump here - infinite loop!


  text_string db 'This is my cool new OS!', 0


print_string:			; Routine: output string in SI to screen
  mov ah, 0eh		; int 10h 'print char' function

.repeat:
  lodsb			; Get character from string
  cmp al, 0
  je .done		; If char is zero, end of string
  int 10h			; Otherwise, print it
  jmp .repeat

.done:
  ret


times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
dw 0xAA55		; The standard PC boot signature
