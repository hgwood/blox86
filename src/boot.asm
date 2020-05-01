BITS 16

start:
  ; set up 4K stack space after this bootloader
  mov ax, 7c0h ; 7c0 is the address of the bootloader
  add ax, 512 ; skip to the end of the bootloader
  mov ss, ax ; set stack segment
  mov sp, 4095 ; set stack pointer to empty stack (remember the stack is reversed)

  ; set up the data segment after the stack
  mov ax, 7c0h ; 7c0 is the address of the bootloader
  add ax, 512 ; skip to the end of the bootloader
  add ax, 4096 ; skip to the end of the stack
  mov ds, ax ; set data segment

  call .draw_walls
  mov ch, 10
  mov cl, 20
  call .draw_player
  .game_loop:
    push cx
    call .update_player_position
    pop dx
    cmp dx, cx
    je .game_loop
    call .draw_player
    jmp .game_loop

.update_player_position:
  mov ah, 01h
  int 16h
  jz .done
  mov ah, 00h
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

times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
dw 0xAA55		; The standard PC boot signature
