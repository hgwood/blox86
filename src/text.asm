
; prints horizontal line of char=al at y=dh from x1=ch to x2=cl exclusive
print_horizontal_line:
  pusha
  cmp ch, cl
  jge .return
  mov dl, ch
  .print_horizontal_line_loop:
    call print_char_at
    inc dl
    cmp dl, cl
    jl .print_horizontal_line_loop
  .return:
    popa
    ret

; prints vertical line of char=al at x=dl from y1=ch to y2=cl exclusive
print_vertical_line:
  pusha
  cmp ch, cl
  jge .return
  mov dh, ch
  .print_vertical_line_loop:
    call print_char_at
    inc dh
    cmp dh, cl
    jl .print_vertical_line_loop
  .return:
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

hide_cursor:
  pusha
  mov cx, 2607h
  mov ah, 01h
  int 10h
  popa
  ret
