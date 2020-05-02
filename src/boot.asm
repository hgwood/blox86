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
  mov si, ds ; set source index pointer
  mov di, ds ; set destination index pointer

  ; initialize game state
  mov [di + 0], byte 0 ; player_left_x, relative to game arena
  mov [di + 1], byte 10 ; player_size
  mov [di + 2], byte 0 ; ball_x
  mov [di + 3], byte 0 ; ball_y
  mov [di + 4], word 0 ; ball_x_carry
  mov [di + 6], word 0 ; ball_y_carry
  mov [di + 8], byte 10 ; ball_speed_x, in ticks per unit
  mov [di + 9], byte 20 ; ball_speed_y, in ticks per unit
  mov [di + 10], dword 0 ; system time in ticks

game_loop:
  call read_time
  call update_ball
  jmp game_loop

; updates the game state for the ball
; dx = ticks (assumes cx set by read_time is zero)
update_ball:
  pusha
  push word [si + 2] ; save previous position for comparison at the end
  .update_x:
    cmp byte [si + 8], 0
    je .update_y
    mov ax, dx
    add ax, word [si + 4]
    div byte [si + 8]
    add byte [di + 2], al
    mov al, ah
    mov ah, 0
    mov word [di + 4], ax
  .update_y:
    cmp byte [si + 9], 0
    je .draw
    mov ax, dx
    add ax, word [si + 6]
    div byte [si + 9]
    add byte [di + 3], al
    mov al, ah
    mov ah, 0
    mov word [di + 6], ax
  .draw:
    pop dx
    cmp dx, word [si + 2]
    je .return
    mov al, 20h ; ' '
    ; position already in dx, ready to print
    call print_char_at
    mov al, 4fh ; 'O'
    mov dx, word [si + 2]
    call print_char_at
  .return:
    popa
    ret

; draws a char at the position of the ball in the current game state
; al = char
; bl = color
draw_ball:
  pusha
  mov dl, [si + 2]
  mov dh, [si + 3]
  call print_char_at
  popa
  ret

; reads keyboard buffer until exhaustion
; returns
;   al = number of key presses on left arrow
;   ah = number of key presses on right arrow
read_keyboard:
  mov ax, 0
  mov ah, 01h
  int 16h
  jz .return
  mov ah, 00h
  int 16h
  cmp ah, 4bh
  je .left_requested
  cmp ah, 4dh
  je .right_requested
  jmp read_keyboard
  .left_requested:
    add al, 1
    jmp read_keyboard
  .right_requested:
    add ah, 1
    jmp read_keyboard
  .return:
    ret

; updates the game state to the current time
; returns
;   cx:dx = the delta between the previous game state time and the new game state time
read_time:
  ; save non-return registers
  push ax
  push bx
  ; read system time into cx:dx
  mov ah, 00h
  int 1ah
  ; save system time to ax:bx
  mov bx, dx
  mov ax, cx
  ; compute delta
  sub dx, [si + 10]
  sbb cx, [si + 12]
  ; return delta zero if game state has clock zero
  cmp dword [si + 10], 0
  jne .update_game_state
  mov cx, 0
  mov dx, 0
  .update_game_state:
    mov [di + 10], bx
    mov [di + 12], ax
  ; restore non-return registers
  pop bx
  pop ax
  ret


; old code
;   call .draw_walls
;   mov ch, 10
;   mov cl, 20
;   call .draw_player
;   .game_loop:
;     push cx
;     call .update_player_position
;     pop dx
;     cmp dx, cx
;     je .game_loop
;     call .draw_player
;     jmp .game_loop

; .update_player_position:
;   mov ah, 01h
;   int 16h
;   jz .done
;   mov ah, 00h
;   int 16h
;   cmp ah, 4bh
;   je .move_player_left_if_possible
;   cmp ah, 4dh
;   je .move_player_right_if_possible
;   jmp .done
;   .move_player_left_if_possible:
;     cmp ch, 1
;     je .done
;     sub ch, 1
;     sub cl, 1
;     jmp .done
;   .move_player_right_if_possible:
;     cmp cl, 60
;     je .done
;     add ch, 1
;     add cl, 1
;     jmp .done
;   .done:
;     ret

; ; draws player between x1=ch and x2=cl
; .draw_player:
;   mov dh, 24 ; drawing on the bottom line

;   ; reset all potential player cells to blank
;   push cx
;   mov al, 20h ; ' '
;   mov ch, 1
;   mov cl, 60
;   call .print_horizontal_line

;   ; actually draw player
;   pop cx
;   mov al, 54h ; 'T'
;   call .print_horizontal_line
;   ret

; .draw_walls:
;   mov al, 58h ; 'X'
;   call .draw_upper_wall
;   call .draw_left_wall
;   call .draw_right_wall
;   ret

; .draw_upper_wall:
;   mov dh, 0
;   mov ch, 0
;   mov cl, 60
;   call .print_horizontal_line
;   ret

; .draw_left_wall:
;   mov dl, 0
;   mov ch, 0
;   mov cl, 25
;   call .print_vertical_line
;   ret

; .draw_right_wall:
;   mov dl, 60
;   mov ch, 0
;   mov cl, 25
;   call .print_vertical_line
;   ret

; ; prints horizontal line of char=al at y=dh from x1=ch to x2=cl
; .print_horizontal_line:
;   mov dl, ch
;   .print_horizontal_line_loop:
;     call .print_char_at
;     add dl, 1
;     cmp dl, cl
;     jl .print_horizontal_line_loop
;   ret

; ; prints vertical line of char=al at x=dl from y1=ch to y2=cl
; .print_vertical_line:
;   mov dh, ch
;   .print_vertical_line_loop:
;     call .print_char_at
;     add dh, 1
;     cmp dh, cl
;     jl .print_vertical_line_loop
;   ret

; prints char=al at x=dl, y=dh
print_char_at:
  pusha
  mov bh, 0
  mov ah, 02h
  int 10h
  mov ah, 0eh
  int 10h
  popa
  ret

times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
dw 0xAA55		; The standard PC boot signature
