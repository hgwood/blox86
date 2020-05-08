%assign player_char 54h ; 'T'
%assign player_y arena_bottom - 1

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
    cmp ch, arena_left_x
    jge .draw_extend_left_side
    ; wall reached, clamp movement
    mov dh, 1
    sub dh, ch
    sub al, dh
    mov ch, [si + player_left_x_offset]
    sub ch, al
    .draw_extend_left_side:
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
    cmp cl, arena_right_x
    jle .draw_extend_right_side
    ; wall reached, clamp movement
    sub cl, arena_right_x
    sub ah, cl
    mov cl, ch
    add cl, ah
    .draw_extend_right_side:
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
