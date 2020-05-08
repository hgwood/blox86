BITS 16

%include "src/constants.asm"
%include "src/memory_setup.asm"
%include "src/game_state.asm"
%include "src/level.asm"

init_game:
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
    ; have to reset the game state clock
    ; otherwise when we resume the game will
    ; think a lot of time has past and will
    ; shoot the ball far away
    mov dword [di + system_time_offset], 0
    jmp game_loop

%include "src/game_over.asm"
%include "src/walls.asm"
%include "src/player.asm"
%include "src/ball.asm"
%include "src/blocks.asm"
%include "src/score.asm"
%include "src/inputs.asm"
%include "src/text.asm"

dw 0aa55h ; the standard PC boot signature
