  BITS 16

start:
  mov ax, 07C0h		; Set up 4K stack space after this bootloader
  add ax, 288		; (4096 + 512) / 16 bytes per paragraph
  mov ss, ax
  mov sp, 4096

  mov ax, 07C0h		; Set data segment to where we're loaded
  mov ds, ax

  call .draw_walls
  mov ch, 10
  mov cl, 20
  call .draw_player
  .game_loop:
    call .update_player_position
    call .draw_player
    jmp .game_loop

.update_player_position:
  mov ah, 0
  int 16h
  cmp ah, 4bh
  je .move_player_left_if_possible
  cmp ah, 4dh
  je .move_player_right_if_possible
  jmp .done
  .move_player_left_if_possible:
    cmp ch, 1
    je .done
    sub ch, 1
    sub cl, 1
    jmp .done
  .move_player_right_if_possible:
    cmp cl, 60
    je .done
    add ch, 1
    add cl, 1
    jmp .done
  .done:
    ret

; draws player between x1=ch and x2=cl
.draw_player:
  mov dh, 24 ; drawing on the bottom line

  ; reset all potential player cells to blank
  push cx
  mov al, 20h ; ' '
  mov ch, 1
  mov cl, 60
  call .print_horizontal_line

  ; actually draw player
  pop cx
  mov al, 54h ; 'T'
  call .print_horizontal_line
  ret

.draw_walls:
  mov al, 58h ; 'X'
  call .draw_upper_wall
  call .draw_left_wall
  call .draw_right_wall
  ret

.draw_upper_wall:
  mov dh, 0
  mov ch, 0
  mov cl, 60
  call .print_horizontal_line
  ret

.draw_left_wall:
  mov dl, 0
  mov ch, 0
  mov cl, 25
  call .print_vertical_line
  ret

.draw_right_wall:
  mov dl, 60
  mov ch, 0
  mov cl, 25
  call .print_vertical_line
  ret

; prints horizontal line of char=al at y=dh from x1=ch to x2=cl
.print_horizontal_line:
  mov dl, ch
  .print_horizontal_line_loop:
    call .print_char_at
    add dl, 1
    cmp dl, cl
    jl .print_horizontal_line_loop
  ret

; prints vertical line of char=al at x=dl from y1=ch to y2=cl
.print_vertical_line:
  mov dh, ch
  .print_vertical_line_loop:
    call .print_char_at
    add dh, 1
    cmp dh, cl
    jl .print_vertical_line_loop
  ret

; prints char=al at x=dl, y=dh
.print_char_at:
  mov bh, 0
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
