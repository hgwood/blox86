  BITS 16

start:
  mov ax, 07C0h		; Set up 4K stack space after this bootloader
  add ax, 288		; (4096 + 512) / 16 bytes per paragraph
  mov ss, ax
  mov sp, 4096

  mov ax, 07C0h		; Set data segment to where we're loaded
  mov ds, ax

  call .draw_walls
  jmp .wait_for_key_press

.draw_walls:
  call .draw_upper_wall
  call .draw_left_wall
  call .draw_right_wall
  ret

.draw_upper_wall:
  mov al, 58h
  mov dh, 0
  mov dl, 0
  .draw_upper_wall_cell:
    call .print_char_at
    add dl, 1
    cmp dl, 60
    jl .draw_upper_wall_cell
  ret

.draw_left_wall:
  mov al, 58h
  mov dh, 0
  mov dl, 0
  .draw_left_wall_cell:
    call .print_char_at
    add dh, 1
    cmp dh, 25
    jl .draw_left_wall_cell
  ret

.draw_right_wall:
  mov al, 58h
  mov dh, 0
  mov dl, 60
  .draw_right_wall_cell:
    call .print_char_at
    add dh, 1
    cmp dh, 25
    jl .draw_right_wall_cell
  ret

; draws char=al at x=dl, y=dh
.print_char_at:
  mov ah, 02h
  int 10h
  mov ah, 0eh
  int 10h
  ret

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

times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
dw 0xAA55		; The standard PC boot signature
