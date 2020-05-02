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
  mov [di + 0], byte 10 ; player_left_x, relative to game arena
  mov [di + 1], byte 3 ; player_size
  mov [di + 2], byte 1 ; ball_x
  mov [di + 3], byte 1 ; ball_y
  mov [di + 4], byte 0 ; ball_x_carry
  mov [di + 5], byte 0 ; ball_y_carry
  mov [di + 6], byte 1 ; ball_speed_x, in ticks per unit
  mov [di + 7], byte 1 ; ball_speed_y, in ticks per unit
  mov [di + 10], dword 0 ; system time in ticks

call draw_walls
call draw_initial_player
game_loop:
  call read_time
  call update_ball
  call read_keyboard
  call update_player
  jmp game_loop

draw_initial_player:
  pusha
  mov ch, [si + 0]
  mov cl, [si + 0]
  add cl, [si + 1]
  mov al, 54h ; 'T'
  mov dh, 24
  call print_horizontal_line
  popa
  ret

update_player:
  pusha
  cmp al, ah
  jg .move_left
  jl .move_right
  je .return
  ; mov al, 1
  ; mov ah, 0
  .move_left:
    sub al, ah
    ; erase right side
    mov cl, [si + 0]
    add cl, [si + 1]
    dec cl
    mov ch, cl
    sub cl, al
    push ax
    mov al, 20h ; ' '
    mov dh, 24
    call print_horizontal_line
    pop ax
    ; draw left side
    mov ch, [si + 0]
    sub ch, al
    mov cl, [si + 0]
    push ax
    mov al, 54h ; 'T'
    mov dh, 24
    call print_horizontal_line
    pop ax
    ; update game state
    sub [di + 0], al
    jmp .return
  .move_right:
    sub ah, al
    mov ch, [si + 0]
    mov cl, ch
    add cl, ah
    push ax
    mov al, 20h ; ' '
    mov dh, 24
    call print_horizontal_line
    pop ax
    mov ch, [si + 0]
    add ch, [si + 1]
    mov cl, ch
    add cl, ah
    push ax
    mov al, 54h ; 'T'
    mov dh, 24
    call print_horizontal_line
    pop ax
    ; update game state
    add [di + 0], ah
    jmp .return
  .return:
    popa
    ret

; updates the game state for the ball
; dx = ticks (assumes cx set by read_time is zero)
update_ball:
  pusha
  ; save previous position for comparison at the end
  push word [si + 2]
  .update_x:
    ; skip if speed is zero
    cmp byte [si + 6], 0
    je .end_update_x
    ; expand carry to word and into bx so it can be added to ticks
    mov bl, [si + 4]
    mov bh, 0
    ; add carry to ticks, result in ax
    mov ax, dx
    add ax, bx
    ; divide by speed, result in ax
    idiv byte [si + 6]
    ; update position
    add byte [di + 2], al
    ; handle wall collisions
    cmp byte [si + 2], 0
    je .horizontal_wall_hit
    cmp byte [si + 2], 60
    je .horizontal_wall_hit
    jne .no_horizontal_wall_hit
    .horizontal_wall_hit:
      sub byte [di + 2], al
      neg byte [di + 6]
      pop word [si + 2] ; reset position and clean up the stack before recursive call
      call update_ball
      jmp .return
    .no_horizontal_wall_hit:
    ; set carry for next update
    mov byte [di + 4], ah
  .end_update_x:
  .update_y:
    ; skip if speed is zero
    cmp byte [si + 7], 0
    je .end_update_y
    ; expand carry to word and into bx so it can be added to ticks
    mov bl, [si + 5]
    mov bh, 0
    ; add carry to ticks, result in ax
    mov ax, dx
    add ax, bx
    ; divide by speed, result in ax
    idiv byte [si + 7]
    ; update position
    add byte [di + 3], al
    ; handle wall collisions
    cmp byte [si + 3], 0
    je .vertical_wall_hit
    cmp byte [si + 3], 24
    je .vertical_wall_hit
    jne .no_vertical_wall_hit
    .vertical_wall_hit:
      sub byte [di + 3], al
      neg byte [di + 7]
      pop word [si + 2] ; reset position and clean up the stack before recursive call
      call update_ball
      jmp .return
    .no_vertical_wall_hit:
    ; set carry for next update
    mov byte [di + 5], ah
  .end_update_y:
  .draw:
    ; pop previous position into dx
    pop dx
    ; skip draw if position has not changed
    cmp dx, word [si + 2]
    je .return
    ; erase previous ball
    mov al, 20h ; ' '
    ; position already in dx, ready to print
    call print_char_at
    ; draw new ball
    mov al, 4fh ; 'O'
    mov dx, word [si + 2]
    call print_char_at
  .return:
    popa
    ret

; reads keyboard buffer until exhaustion
; returns
;   al = number of key presses on left arrow
;   ah = number of key presses on right arrow
read_keyboard:
  push bx
  mov bx, 0
  .read_next_key:
    mov ah, 01h
    int 16h
    jz .return
    mov ah, 00h
    int 16h
    cmp ah, 4bh
    je .left_requested
    cmp ah, 4dh
    je .right_requested
    jmp .read_next_key
  .left_requested:
    inc bl
    jmp .read_next_key
  .right_requested:
    inc bh
    jmp .read_next_key
  .return:
    mov ax, bx
    pop bx
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

; draws player between x1=ch and x2=cl
draw_player:
  pusha
  mov dh, 24 ; drawing on the bottom line

  ; reset all potential player cells to blank
  push cx
  mov al, 20h ; ' '
  mov ch, 1
  mov cl, 60
  call print_horizontal_line

  ; actually draw player
  pop cx
  mov al, 54h ; 'T'
  call print_horizontal_line
  popa
  ret

draw_walls:
  pusha
  mov al, 58h ; 'X'
  call draw_upper_wall
  call draw_left_wall
  call draw_right_wall
  popa
  ret

draw_upper_wall:
  pusha
  mov dh, 0
  mov ch, 0
  mov cl, 60
  call print_horizontal_line
  popa
  ret

draw_left_wall:
  pusha
  mov dl, 0
  mov ch, 0
  mov cl, 25
  call print_vertical_line
  popa
  ret

draw_right_wall:
  pusha
  mov dl, 60
  mov ch, 0
  mov cl, 25
  call print_vertical_line
  popa
  ret

; prints horizontal line of char=al at y=dh from x1=ch to x2=cl exclusive
print_horizontal_line:
  pusha
  mov dl, ch
  print_horizontal_line_loop:
    call print_char_at
    inc dl
    cmp dl, cl
    jl print_horizontal_line_loop
  popa
  ret

; prints vertical line of char=al at x=dl from y1=ch to y2=cl exclusive
print_vertical_line:
  pusha
  mov dh, ch
  print_vertical_line_loop:
    call print_char_at
    inc dh
    cmp dh, cl
    jl print_vertical_line_loop
  popa
  ret

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
