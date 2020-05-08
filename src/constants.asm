; constant positions and sizes
%assign arena_width 64
%assign arena_height 24
%assign left_wall_x 0
%assign top_wall_y 0
%assign right_wall_x left_wall_x + arena_width + 1
%assign arena_left left_wall_x + 1
%assign player_y top_wall_y + arena_height
%assign arena_bottom player_y + 1
%assign score_display_left_x 68
%assign score_display_y 2
%assign score_display_width 5
%assign game_over_display_left_x 68
%assign game_over_display_y 4

; character constants
%assign wall_char 58h ; 'X'
%assign player_char 54h ; 'T'
%assign ball_char 4fh ; 'O
%assign block_char 48h ; 'H'
%assign empty_char 20h ; ' '

; gameplay constants
; absolute horizontal coordinate at which the player starts
; range: [1, 65 - player_size]
%assign initial_player_left_x 10
; width of the player at the start of the game
; range: [1, 64]
%assign initial_player_size 5
; absolute horizontal coordinate at which the ball starts
%assign initial_ball_x 10
; absolute vertical coordinate at which the ball starts
%assign initial_ball_y 10
; horizontal speed with which the ball starts
; the speed is measured in time ticks needed to travel from position n to n + 1
; notice that this unit is inverted, so greater values mean slower speeds
; zero means the ball is not moving horizontally, positive speed means going left, negative speed means going right
; range [1, 255]
%assign initial_ball_speed_x 6
; vertical speed with which the ball starts
; same remarks as for horizontal speed apply
%assign initial_ball_speed_y 6
; the score with which the player starts
%assign initial_score 0
; specifies how many spatial units can a player traval with one key press
%assign player_speed_multiplier 4

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
%assign level_offset 32

; block operations
%assign block_is_alive_mask 0000_0001b
