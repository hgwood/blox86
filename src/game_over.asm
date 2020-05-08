
%assign game_over_display_left_x 68
%assign game_over_display_y 4

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
