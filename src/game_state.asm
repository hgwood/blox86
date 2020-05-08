; game state offsets
%assign player_left_x_offset 0
%assign player_size_offset 1
%assign ball_x_offset 2
%assign ball_y_offset 3
%assign ball_x_carry_offset 4
%assign ball_y_carry_offset 5
%assign ball_speed_x_offset 6
%assign ball_speed_y_offset 7
%assign game_over_flag_offset 8
%assign pause_flag_offset 9
%assign system_time_offset 10
%assign system_time_lsw_offset system_time_offset
%assign system_time_msw_offset system_time_offset + 2
%assign score_offset system_time_msw_offset + 2
%assign score_carry_offset score_offset + 2

; initialize game state
mov byte [di + player_left_x_offset], byte initial_player_left_x ; absolute coordinate
mov byte [di + player_size_offset], byte initial_player_size ; absolute coordinate
mov byte [di + ball_x_offset], byte initial_ball_x ; absolute coordinate
mov byte [di + ball_y_offset], byte initial_ball_y ; absolute coordinate
mov byte [di + ball_x_carry_offset], byte 0 ; in ticks
mov byte [di + ball_y_carry_offset], byte 0 ; in ticks
mov byte [di + ball_speed_x_offset], byte initial_ball_speed_x ; in ticks per unit: 1 is fastest, greater is slower
mov byte [di + ball_speed_y_offset], byte initial_ball_speed_y ; in ticks per unit: 1 is fastest, greater is slower
mov byte [di + game_over_flag_offset], byte 0 ; boolean
mov byte [di + pause_flag_offset], byte 0 ; boolean
mov dword [di + system_time_offset], dword 0 ; in ticks since midnight as provided by the BIOS, see http://vitaly_filatov.tripod.com/ng/asm/asm_029.1.html
mov word [di + score_offset], word initial_score
mov byte [di + score_carry_offset], byte 0
