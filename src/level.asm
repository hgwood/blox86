%assign level_size 384

%assign level_line_00_offset level_offset
%assign level_line_01_offset level_line_00_offset + 64
%assign level_line_02_offset level_line_01_offset + 64
%assign level_line_03_offset level_line_02_offset + 64
%assign level_line_04_offset level_line_03_offset + 64
%assign level_line_05_offset level_line_04_offset + 64

; 1 byte = 1 block
; so each of these lines of code defines 4 blocks
; 16 lines of code defines 64 blocks, which is one block line
mov dword [di + level_line_00_offset + 0000], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0004], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0008], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0012], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0016], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0020], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0024], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0028], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0032], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0036], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0040], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0044], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0048], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0052], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0056], dword 00_00_00_00h
mov dword [di + level_line_00_offset + 0060], dword 00_00_00_00h

mov dword [di + level_line_01_offset + 0000], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0004], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0008], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0012], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0016], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0020], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0024], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0028], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0032], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0036], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0040], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0044], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0048], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0052], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0056], dword 00_00_00_00h
mov dword [di + level_line_01_offset + 0060], dword 00_00_00_00h

mov dword [di + level_line_02_offset + 0000], dword 00_00_00_00h
mov dword [di + level_line_02_offset + 0004], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0008], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0012], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0016], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0020], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0024], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0028], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0032], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0036], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0040], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0044], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0048], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0052], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0056], dword 01_01_01_01h
mov dword [di + level_line_02_offset + 0060], dword 00_00_00_00h

mov dword [di + level_line_03_offset + 0000], dword 00_00_00_00h
mov dword [di + level_line_03_offset + 0004], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0008], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0012], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0016], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0020], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0024], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0028], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0032], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0036], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0040], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0044], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0048], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0052], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0056], dword 01_01_01_01h
mov dword [di + level_line_03_offset + 0060], dword 00_00_00_00h

mov dword [di + level_line_04_offset + 0000], dword 00_00_00_00h
mov dword [di + level_line_04_offset + 0004], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0008], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0012], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0016], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0020], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0024], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0028], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0032], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0036], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0040], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0044], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0048], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0052], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0056], dword 01_01_01_01h
mov dword [di + level_line_04_offset + 0060], dword 00_00_00_00h

mov dword [di + level_line_05_offset + 0000], dword 00_00_00_00h
mov dword [di + level_line_05_offset + 0004], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0008], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0012], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0016], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0020], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0024], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0028], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0032], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0036], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0040], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0044], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0048], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0052], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0056], dword 01_01_01_01h
mov dword [di + level_line_05_offset + 0060], dword 00_00_00_00h
