; constant positions and sizes
%assign arena_width 64
%assign arena_height 24
%assign left_wall_x 0
%assign top_wall_y 0
%assign right_wall_x left_wall_x + arena_width + 1
%assign arena_left left_wall_x + 1
%assign player_y top_wall_y + arena_height
%assign arena_bottom player_y + 1

; character constants
%assign wall_char 58h ; 'X'
%assign player_char 54h ; 'T'
%assign ball_char 4fh ; 'O
%assign empty_char 20h ; ' '

; gameplay constants
%assign player_speed_multiplier 2

; game state offsets
%assign player_left_x_offset 0
%assign player_size_offset 1
%assign ball_x_offset 2
%assign ball_y_offset 3
%assign ball_x_carry_offset 4
%assign ball_y_carry_offset 5
%assign ball_speed_x_offset 6
%assign ball_speed_y_offset 7
%assign game_over_flag_offset 8
%assign system_time_offset 10
%assign system_time_lsw_offset system_time_offset
%assign system_time_msw_offset system_time_offset + 2
%assign block_map_offset 32

%assign level_size_bytes 64

; block operations
%assign block_is_alive_mask 0000_0001b

BITS 16

start:
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

  ; initialize game state
  mov byte [di + player_left_x_offset], byte 10 ; absolute coordinate
  mov byte [di + player_size_offset], byte 20 ; absolute coordinate
  mov byte [di + ball_x_offset], byte 1 ; absolute coordinate
  mov byte [di + ball_y_offset], byte 1 ; absolute coordinate
  mov byte [di + ball_x_carry_offset], byte 0 ; in ticks
  mov byte [di + ball_y_carry_offset], byte 0 ; in ticks
  mov byte [di + ball_speed_x_offset], byte 1 ; in ticks per unit
  mov byte [di + ball_speed_y_offset], byte 1 ; in ticks per unit
  mov byte [di + game_over_flag_offset], byte 0 ; boolean
  mov dword [di + system_time_offset], dword 0 ; in ticks since midnight as provided by the BIOS, see http://vitaly_filatov.tripod.com/ng/asm/asm_029.1.html
  ; block map
  mov byte [di + block_map_offset + 00], byte 1
  mov byte [di + block_map_offset + 01], byte 1
  mov byte [di + block_map_offset + 02], byte 1
  mov byte [di + block_map_offset + 03], byte 1
  mov byte [di + block_map_offset + 04], byte 1
  mov byte [di + block_map_offset + 05], byte 1
  mov byte [di + block_map_offset + 06], byte 1
  mov byte [di + block_map_offset + 07], byte 1
  mov byte [di + block_map_offset + 08], byte 1
  mov byte [di + block_map_offset + 09], byte 1
  mov byte [di + block_map_offset + 10], byte 1
  mov byte [di + block_map_offset + 11], byte 1
  mov byte [di + block_map_offset + 12], byte 1
  mov byte [di + block_map_offset + 13], byte 1
  mov byte [di + block_map_offset + 14], byte 1
  mov byte [di + block_map_offset + 15], byte 1
  mov byte [di + block_map_offset + 16], byte 1
  mov byte [di + block_map_offset + 17], byte 1
  mov byte [di + block_map_offset + 18], byte 1
  mov byte [di + block_map_offset + 19], byte 1
  mov byte [di + block_map_offset + 20], byte 1
  mov byte [di + block_map_offset + 21], byte 1
  mov byte [di + block_map_offset + 22], byte 1
  mov byte [di + block_map_offset + 23], byte 1
  mov byte [di + block_map_offset + 24], byte 1
  mov byte [di + block_map_offset + 25], byte 1
  mov byte [di + block_map_offset + 26], byte 1
  mov byte [di + block_map_offset + 27], byte 1
  mov byte [di + block_map_offset + 28], byte 1
  mov byte [di + block_map_offset + 29], byte 1
  mov byte [di + block_map_offset + 30], byte 1
  mov byte [di + block_map_offset + 31], byte 1
  mov byte [di + block_map_offset + 32], byte 1
  mov byte [di + block_map_offset + 33], byte 1
  mov byte [di + block_map_offset + 34], byte 1
  mov byte [di + block_map_offset + 35], byte 1
  mov byte [di + block_map_offset + 36], byte 1
  mov byte [di + block_map_offset + 37], byte 1
  mov byte [di + block_map_offset + 38], byte 1
  mov byte [di + block_map_offset + 39], byte 1
  mov byte [di + block_map_offset + 40], byte 1
  mov byte [di + block_map_offset + 41], byte 1
  mov byte [di + block_map_offset + 42], byte 1
  mov byte [di + block_map_offset + 43], byte 1
  mov byte [di + block_map_offset + 44], byte 1
  mov byte [di + block_map_offset + 45], byte 1
  mov byte [di + block_map_offset + 46], byte 1
  mov byte [di + block_map_offset + 47], byte 1
  mov byte [di + block_map_offset + 48], byte 1
  mov byte [di + block_map_offset + 49], byte 1
  mov byte [di + block_map_offset + 50], byte 1
  mov byte [di + block_map_offset + 51], byte 1
  mov byte [di + block_map_offset + 52], byte 1
  mov byte [di + block_map_offset + 53], byte 1
  mov byte [di + block_map_offset + 54], byte 1
  mov byte [di + block_map_offset + 55], byte 1
  mov byte [di + block_map_offset + 56], byte 1
  mov byte [di + block_map_offset + 57], byte 1
  mov byte [di + block_map_offset + 58], byte 1
  mov byte [di + block_map_offset + 59], byte 1
  mov byte [di + block_map_offset + 60], byte 1
  mov byte [di + block_map_offset + 61], byte 1
  mov byte [di + block_map_offset + 62], byte 1
  mov byte [di + block_map_offset + 63], byte 1

call draw_walls
call draw_initial_ball
call draw_initial_player
call draw_level
game_loop:
  call read_time
  call update_ball
  call read_keyboard
  call update_player
  cmp byte [di + game_over_flag_offset], 1
  je game_over
  jmp game_loop

game_over:
  mov dx, 0
  mov al, 47h ; 'G'
  call print_char_at
  jmp $ ; infinite loop

draw_initial_player:
  pusha
  mov ch, [si + player_left_x_offset]
  mov cl, [si + player_left_x_offset]
  add cl, [si + player_size_offset]
  mov al, player_char
  mov dh, player_y
  call print_horizontal_line
  popa
  ret

draw_initial_ball:
  pusha
  mov dl, [si + ball_x_offset]
  mov dh, [si + ball_y_offset]
  mov al, ball_char
  call print_char_at
  popa
  ret

draw_level:
  pusha
  mov bx, 0 ; block index
  .byte_loop:
    mov al, block_is_alive_mask
    and al, byte [si + block_map_offset + bx]
    jz .next_byte
    ; compute coordinates to draw
    ; x = block_index % arena_width + 1
    ; y = block_index // arena_width + 1
    mov ax, bx
    mov dl, arena_width
    div dl ; al = block_index // arena_width, ah = block_index % arena_width
    inc al
    inc ah
    ; draw
    mov dl, ah
    mov dh, al
    mov al, 48h ; 'H'
    call print_char_at
    .next_byte:
      inc bx
      cmp bx, level_size_bytes
      jl .byte_loop
  .return:
    popa
    ret

; converts game coordinates to block index to lookup the block map
; computations is as follows:
;   block index = (y - 1) * arena_width + (x - 1)
; parameters
;   al = x
;   ah = y
; returns
;   ax = block index
convert_to_block_index:
  push bx
  push cx
  mov bx, ax
  mov ax, 0
  mov al, bh ; al = y
  sub al, 1 ; al = y - 1
  mov cl, arena_width
  mul cl ; ax = (y - 1) * arena_width
  mov bh, 0
  add ax, bx ; ax = (y - 1) * arena_width + x
  dec ax ; ax = (y - 1) * arena_width + x - 1
  pop cx
  pop bx
  ret

; destroys block at given position if one exists
; parameters
;   al = x
;   ah = y
; returns
;   zero-flag set if no block
;   zero-flag cleared if block was destroyed
destroy_block_if_exists:
  pusha
  mov dx, ax ; save position in dx so we can draw at the end if block was destroyed
  call convert_to_block_index
  mov bx, ax ; bx is the only register supported as memory offset so we move block index to it
  mov cl, block_is_alive_mask
  and cl, [si + block_map_offset + bx]
  jz .return ; no block at position
  pushf ; save zf flag because it's the one we want to return and xor might change it
  xor [si + block_map_offset + bx], cl ; remove block from bit map
  ; draw
  mov al, empty_char
  call print_char_at
  popf ; restore zf
  .return:
    popa
    ret

update_player:
  pusha
  cmp al, ah
  jg .move_left
  jl .move_right
  je .return
  .move_left:
    sub al, ah
    ; extend left side
    mov ch, [si + player_left_x_offset]
    sub ch, al
    mov cl, [si + player_left_x_offset]
    ; check boundary
    cmp ch, 0
    jle .return
    ; draw
    push ax
    mov al, player_char
    mov dh, player_y
    call print_horizontal_line
    pop ax
    ; shrink right side
    mov ch, [si + player_left_x_offset]
    add ch, [si + player_size_offset]
    mov cl, ch
    sub ch, al
    push ax
    mov al, empty_char
    mov dh, player_y
    call print_horizontal_line
    pop ax
    ; update game state
    sub [di + player_left_x_offset], al
    jmp .return
  .move_right:
    sub ah, al
    ; extend right side
    mov ch, [si + player_left_x_offset]
    add ch, [si + player_size_offset]
    mov cl, ch
    add cl, ah
    ; check boundary
    cmp cl, right_wall_x
    jg .return
    ; draw
    push ax
    mov al, player_char
    mov dh, player_y
    call print_horizontal_line
    pop ax
    ; shrink left side
    mov ch, [si + player_left_x_offset]
    mov cl, ch
    add cl, ah
    push ax
    mov al, empty_char
    mov dh, player_y
    call print_horizontal_line
    pop ax
    ; update game state
    add [di + player_left_x_offset], ah
    jmp .return
  .return:
    popa
    ret

; updates the game state for the ball
; dx = ticks (assumes cx set by read_time is zero)
update_ball:
  pusha
  ; save previous position on the stack
  push word [si + ball_x_offset]
  .update_x:
    ; skip if speed is zero
    cmp byte [si + ball_speed_x_offset], 0
    je .end_update_x
    ; expand carry to word and into bx so it can be added to ticks
    mov bl, [si + ball_x_carry_offset]
    mov bh, 0
    ; add carry to ticks, result in ax
    mov ax, dx
    add ax, bx
    ; divide by speed, result in ax
    idiv byte [si + ball_speed_x_offset]
    ; update position
    add byte [di + ball_x_offset], al
    ; handle wall collisions
    cmp byte [si + ball_x_offset], 0
    je .horizontal_wall_hit
    cmp byte [si + ball_x_offset], right_wall_x
    je .horizontal_wall_hit
    jne .no_horizontal_wall_hit
    .horizontal_wall_hit:
      ; negate speed
      neg byte [di + ball_speed_x_offset]
      ; reset position and clean up the stack before recursive call
      pop word [di + ball_x_offset]
      call update_ball
      jmp .return
    .no_horizontal_wall_hit:
    ; handle block collision
    push ax
    mov ax, word [si + ball_x_offset]
    call destroy_block_if_exists
    pop ax
    jnz .horizontal_wall_hit
    ; set carry for next update
    mov byte [di + ball_x_carry_offset], ah
  .end_update_x:
  .update_y:
    ; skip if speed is zero
    cmp byte [si + ball_speed_y_offset], 0
    je .end_update_y
    ; expand carry to word and into bx so it can be added to ticks
    mov bl, [si + ball_y_carry_offset]
    mov bh, 0
    ; add carry to ticks, result in ax
    mov ax, dx
    add ax, bx
    ; divide by speed, result in ax
    idiv byte [si + ball_speed_y_offset]
    ; update position
    add byte [di + ball_y_offset], al
    ; handle wall collisions
    cmp byte [si + ball_y_offset], top_wall_y
    je .vertical_wall_hit
    cmp byte [si + ball_y_offset], player_y
    je .maybe_player_hit
    jne .no_hit
    .vertical_wall_hit:
      ; negate speed
      neg byte [di + ball_speed_y_offset]
      ; reset position and clean up the stack before recursive call
      pop word [di + ball_x_offset]
      call update_ball
      jmp .return
    .maybe_player_hit:
      mov cl, byte [si + ball_x_offset]
      cmp cl, byte [si + player_left_x_offset] ; compare ball x with player left x
      jl .ball_lost ; ball is left of player
      ; compute player right x
      mov ch, byte [si + player_left_x_offset]
      add ch, byte [si + player_size_offset]
      cmp cl, ch ; compare ball x with player right x
      jge .ball_lost ; ball is right of player
      jmp .vertical_wall_hit ; player hit is same as vertical wall hit
    .ball_lost:
      mov byte [di + game_over_flag_offset], 1
      jmp .end_update_y
    .no_hit:
    ; handle block collision
    push ax
    mov ax, word [si + ball_x_offset]
    call destroy_block_if_exists
    pop ax
    jnz .vertical_wall_hit
    ; set carry for next update
    mov byte [di + ball_y_carry_offset], ah
  .end_update_y:
  .draw:
    ; pop previous position into dx
    pop dx
    ; skip draw if position has not changed
    cmp dx, word [si + ball_x_offset]
    je .return
    ; erase previous ball
    mov al, empty_char
    ; position already in dx, ready to print
    call print_char_at
    ; draw new ball
    mov al, ball_char
    mov dx, word [si + ball_x_offset]
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
    add bl, player_speed_multiplier
    jmp .read_next_key
  .right_requested:
    add bh, player_speed_multiplier
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
  sub dx, word [si + system_time_lsw_offset]
  sbb cx, word [si + system_time_msw_offset]
  ; return delta zero if game state has clock zero
  cmp dword [si + 10], 0
  jne .update_game_state
  mov cx, 0
  mov dx, 0
  .update_game_state:
    mov word [di + system_time_lsw_offset], bx
    mov word [di + system_time_msw_offset], ax
  ; restore non-return registers
  pop bx
  pop ax
  ret

draw_walls:
  pusha
  mov al, wall_char
  ; upper wall
  mov dh, top_wall_y
  mov ch, left_wall_x
  mov cl, right_wall_x
  call print_horizontal_line
  ; left wall
  mov dl, left_wall_x
  mov ch, top_wall_y
  mov cl, arena_bottom
  call print_vertical_line
  ; right wall
  mov dl, right_wall_x
  mov ch, top_wall_y
  mov cl, arena_bottom
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

dw 0aa55h ; the standard PC boot signature
