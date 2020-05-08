BITS 16

%include "src/constants.asm"
%include "src/memory.asm"
%include "src/game_state.asm"
%include "src/level.asm"

call hide_cursor
call draw_walls
call draw_level
call draw_initial_ball
call draw_initial_player
call draw_initial_score
game_loop:
  call read_keyboard
  cmp byte [si + pause_flag_offset], 0
  jne .pause
  call update_player
  call read_time
  call update_ball
  call update_score
  cmp byte [si + game_over_flag_offset], 0
  jne game_over
  jmp game_loop
  .pause:
    mov dword [di + system_time_offset], 0
    jmp game_loop

game_over:
  mov dh, game_over_display_y
  mov dl, game_over_display_left_x
  mov al, 'G'
  call print_char_at
  inc dl
  mov al, 'A'
  call print_char_at
  inc dl
  mov al, 'M'
  call print_char_at
  inc dl
  mov al, 'E'
  call print_char_at
  inc dl
  mov al, ' '
  call print_char_at
  inc dl
  mov al, 'O'
  call print_char_at
  inc dl
  mov al, 'V'
  call print_char_at
  inc dl
  mov al, 'E'
  call print_char_at
  inc dl
  mov al, 'R'
  call print_char_at
  inc dl
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

draw_initial_score:
  pusha
  mov dl, score_display_left_x
  mov dh, score_display_y
  mov al, '0'
  mov ch, score_display_left_x
  mov cl, score_display_left_x
  add cl, 5
  add cl, 1
  call print_horizontal_line
  sub dh, 1
  mov al, 'S'
  call print_char_at
  inc dl
  mov al, 'C'
  call print_char_at
  inc dl
  mov al, 'O'
  call print_char_at
  inc dl
  mov al, 'R'
  call print_char_at
  inc dl
  mov al, 'E'
  call print_char_at
  popa
  ret

update_score:
  pusha
  cmp byte [si + score_carry_offset], 0
  je .return
  mov dx, 0
  mov dl, byte [si + score_carry_offset]
  add word [si + score_offset], dx
  mov byte [si + score_carry_offset], 0
  mov cx, score_display_width
  mov ax, word [si + score_offset]
  mov bx, 10
  .loop:
    mov dx, 0
    div bx ; ax = score // 10, dx = score % 10
    push ax
    add dl, '0' ; shift into ascii
    mov al, dl
    mov dh, score_display_y
    mov dl, score_display_left_x
    add dl, cl
    call print_char_at
    pop ax
    loop .loop
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

%include "src/blocks.asm"
%include "src/inputs.asm"
%include "src/text.asm"

dw 0aa55h ; the standard PC boot signature
