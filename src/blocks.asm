; draws all blocks
draw_level:
  pusha
  mov bx, 0 ; block index
  .byte_loop:
    mov al, block_is_alive_mask
    and al, byte [si + level_offset + bx]
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
    mov al, block_char
    call print_char_at
    .next_byte:
      inc bx
      cmp bx, level_size
      jl .byte_loop
  .return:
    popa
    ret

; converts game coordinates to block index to lookup the level block map
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
  and cl, byte [si + level_offset + bx]
  jz .return ; no block at position
  pushf ; save zero-flag because it's the one we want to return and xor might change it
  xor byte [si + level_offset + bx], cl ; remove block from bit map
  inc byte [si + score_carry_offset]
  ; draw
  mov al, empty_char
  call print_char_at
  popf ; restore zero-flag
  .return:
    popa
    ret
