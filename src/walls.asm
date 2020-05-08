%assign wall_char 58h ; 'X'
%assign left_wall_x 0
%assign top_wall_y 0
%assign right_wall_x left_wall_x + arena_width + 1

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
