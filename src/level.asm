%assign level_size 384

%assign line_00_offset block_map_offset
%assign line_01_offset line_00_offset + 64
%assign line_02_offset line_01_offset + 64
%assign line_03_offset line_02_offset + 64
%assign line_04_offset line_03_offset + 64
%assign line_05_offset line_04_offset + 64

mov dword [di + line_00_offset + 0000], dword 00_00_00_00h
mov dword [di + line_00_offset + 0004], dword 00_00_00_00h
mov dword [di + line_00_offset + 0008], dword 00_00_00_00h
mov dword [di + line_00_offset + 0012], dword 00_00_00_00h
mov dword [di + line_00_offset + 0016], dword 00_00_00_00h
mov dword [di + line_00_offset + 0020], dword 00_00_00_00h
mov dword [di + line_00_offset + 0024], dword 00_00_00_00h
mov dword [di + line_00_offset + 0028], dword 00_00_00_00h
mov dword [di + line_00_offset + 0032], dword 00_00_00_00h
mov dword [di + line_00_offset + 0036], dword 00_00_00_00h
mov dword [di + line_00_offset + 0040], dword 00_00_00_00h
mov dword [di + line_00_offset + 0044], dword 00_00_00_00h
mov dword [di + line_00_offset + 0048], dword 00_00_00_00h
mov dword [di + line_00_offset + 0052], dword 00_00_00_00h
mov dword [di + line_00_offset + 0056], dword 00_00_00_00h
mov dword [di + line_00_offset + 0060], dword 00_00_00_00h

mov dword [di + line_01_offset + 0000], dword 00_00_00_00h
mov dword [di + line_01_offset + 0004], dword 00_00_00_00h
mov dword [di + line_01_offset + 0008], dword 00_00_00_00h
mov dword [di + line_01_offset + 0012], dword 00_00_00_00h
mov dword [di + line_01_offset + 0016], dword 00_00_00_00h
mov dword [di + line_01_offset + 0020], dword 00_00_00_00h
mov dword [di + line_01_offset + 0024], dword 00_00_00_00h
mov dword [di + line_01_offset + 0028], dword 00_00_00_00h
mov dword [di + line_01_offset + 0032], dword 00_00_00_00h
mov dword [di + line_01_offset + 0036], dword 00_00_00_00h
mov dword [di + line_01_offset + 0040], dword 00_00_00_00h
mov dword [di + line_01_offset + 0044], dword 00_00_00_00h
mov dword [di + line_01_offset + 0048], dword 00_00_00_00h
mov dword [di + line_01_offset + 0052], dword 00_00_00_00h
mov dword [di + line_01_offset + 0056], dword 00_00_00_00h
mov dword [di + line_01_offset + 0060], dword 00_00_00_00h

mov dword [di + line_02_offset + 0000], dword 00_00_00_00h
mov dword [di + line_02_offset + 0004], dword 01_01_01_01h
mov dword [di + line_02_offset + 0008], dword 01_01_01_01h
mov dword [di + line_02_offset + 0012], dword 01_01_01_01h
mov dword [di + line_02_offset + 0016], dword 01_01_01_01h
mov dword [di + line_02_offset + 0020], dword 01_01_01_01h
mov dword [di + line_02_offset + 0024], dword 01_01_01_01h
mov dword [di + line_02_offset + 0028], dword 01_01_01_01h
mov dword [di + line_02_offset + 0032], dword 01_01_01_01h
mov dword [di + line_02_offset + 0036], dword 01_01_01_01h
mov dword [di + line_02_offset + 0040], dword 01_01_01_01h
mov dword [di + line_02_offset + 0044], dword 01_01_01_01h
mov dword [di + line_02_offset + 0048], dword 01_01_01_01h
mov dword [di + line_02_offset + 0052], dword 01_01_01_01h
mov dword [di + line_02_offset + 0056], dword 01_01_01_01h
mov dword [di + line_02_offset + 0060], dword 00_00_00_00h

mov dword [di + line_03_offset + 0000], dword 00_00_00_00h
mov dword [di + line_03_offset + 0004], dword 01_01_01_01h
mov dword [di + line_03_offset + 0008], dword 01_01_01_01h
mov dword [di + line_03_offset + 0012], dword 01_01_01_01h
mov dword [di + line_03_offset + 0016], dword 01_01_01_01h
mov dword [di + line_03_offset + 0020], dword 01_01_01_01h
mov dword [di + line_03_offset + 0024], dword 01_01_01_01h
mov dword [di + line_03_offset + 0028], dword 01_01_01_01h
mov dword [di + line_03_offset + 0032], dword 01_01_01_01h
mov dword [di + line_03_offset + 0036], dword 01_01_01_01h
mov dword [di + line_03_offset + 0040], dword 01_01_01_01h
mov dword [di + line_03_offset + 0044], dword 01_01_01_01h
mov dword [di + line_03_offset + 0048], dword 01_01_01_01h
mov dword [di + line_03_offset + 0052], dword 01_01_01_01h
mov dword [di + line_03_offset + 0056], dword 01_01_01_01h
mov dword [di + line_03_offset + 0060], dword 00_00_00_00h

mov dword [di + line_04_offset + 0000], dword 00_00_00_00h
mov dword [di + line_04_offset + 0004], dword 01_01_01_01h
mov dword [di + line_04_offset + 0008], dword 01_01_01_01h
mov dword [di + line_04_offset + 0012], dword 01_01_01_01h
mov dword [di + line_04_offset + 0016], dword 01_01_01_01h
mov dword [di + line_04_offset + 0020], dword 01_01_01_01h
mov dword [di + line_04_offset + 0024], dword 01_01_01_01h
mov dword [di + line_04_offset + 0028], dword 01_01_01_01h
mov dword [di + line_04_offset + 0032], dword 01_01_01_01h
mov dword [di + line_04_offset + 0036], dword 01_01_01_01h
mov dword [di + line_04_offset + 0040], dword 01_01_01_01h
mov dword [di + line_04_offset + 0044], dword 01_01_01_01h
mov dword [di + line_04_offset + 0048], dword 01_01_01_01h
mov dword [di + line_04_offset + 0052], dword 01_01_01_01h
mov dword [di + line_04_offset + 0056], dword 01_01_01_01h
mov dword [di + line_04_offset + 0060], dword 00_00_00_00h

mov dword [di + line_05_offset + 0000], dword 00_00_00_00h
mov dword [di + line_05_offset + 0004], dword 01_01_01_01h
mov dword [di + line_05_offset + 0008], dword 01_01_01_01h
mov dword [di + line_05_offset + 0012], dword 01_01_01_01h
mov dword [di + line_05_offset + 0016], dword 01_01_01_01h
mov dword [di + line_05_offset + 0020], dword 01_01_01_01h
mov dword [di + line_05_offset + 0024], dword 01_01_01_01h
mov dword [di + line_05_offset + 0028], dword 01_01_01_01h
mov dword [di + line_05_offset + 0032], dword 01_01_01_01h
mov dword [di + line_05_offset + 0036], dword 01_01_01_01h
mov dword [di + line_05_offset + 0040], dword 01_01_01_01h
mov dword [di + line_05_offset + 0044], dword 01_01_01_01h
mov dword [di + line_05_offset + 0048], dword 01_01_01_01h
mov dword [di + line_05_offset + 0052], dword 01_01_01_01h
mov dword [di + line_05_offset + 0056], dword 01_01_01_01h
mov dword [di + line_05_offset + 0060], dword 00_00_00_00h
