%assign score_display_left_x 68
%assign score_display_y 2
%assign score_display_width 5

draw_initial_score:
  pusha
  mov dl, score_display_left_x
  mov dh, score_display_y
  mov al, '0'
  mov ch, score_display_left_x
  mov cl, score_display_left_x
  add cl, score_display_width
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
  sub cx, 1
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
