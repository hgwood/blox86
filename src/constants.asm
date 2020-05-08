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
%assign initial_ball_speed_x 2
; vertical speed with which the ball starts
; same remarks as for horizontal speed apply
%assign initial_ball_speed_y 2
; the score with which the player starts
%assign initial_score 0
; specifies how many spatial units can a player traval with one key press
%assign player_speed_multiplier 4

; constant positions and sizes
%assign arena_width 64
%assign arena_height 24
%assign arena_left_x 1
%assign arena_top_y 1
%assign arena_right_x arena_left_x + arena_width
%assign arena_bottom arena_height + 1

; character constants
%assign empty_char 20h ; ' '
