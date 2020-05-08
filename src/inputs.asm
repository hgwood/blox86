
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
    cmp ah, 39h
    not byte [di + pause_flag_offset]
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
