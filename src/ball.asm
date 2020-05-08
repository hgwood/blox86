%assign ball_char 4fh ; 'O

draw_initial_ball:
  pusha
  mov dl, [si + ball_x_offset]
  mov dh, [si + ball_y_offset]
  mov al, ball_char
  call print_char_at
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
      cmp byte [si + invincible_flag_offset], 0
      jne .vertical_wall_hit
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
