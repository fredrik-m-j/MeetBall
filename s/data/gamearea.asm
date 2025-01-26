; Bricks start from STATICBRICKS_START
; $ff = BRICK_2ND_BYTE = second part of a 2-byte brick

LevelTable:
        
        IFD     ENABLE_DEBUG_GAMEAREA
        dc.l    GAMEAREA_DEBUG_EMPTY
        dc.l    GAMEAREA_DEBUG_ISSUE1
        dc.l    0

        ELSE

        dc.l    GAMEAREA_x
        dc.l    GAMEAREA_y
        dc.l    GAMEAREA_beer
        dc.l    GAMEAREA_plus
        dc.l    GAMEAREA_target
        dc.l    GAMEAREA_plusmore
        dc.l    GAMEAREA_walls
        dc.l    0

        ENDIF
        

; First column is left empty for algorithmic reasons - screen space starts on column 1
;               0       0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   2   2   2   2   2   2   2   2   2   2   3   3   3   3   3   3   3   3   3   3   4
;               0       1   2   3   4   5   6   7   8   9   0   1   2   3   4   5   6   7   8   9   0   1   2   3   4   5   6   7   8   9   0   1   2   3   4   5   6   7   8   9   0
GAMEAREA:
        dc.b    $00,    $05,$05,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02 ; 0
        dc.b    $00,    $fe,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$fe ; 1
        dc.b    $00,    $fe,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$fe ; 2
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 3
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 4
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 5
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 6
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 7
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 10
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 11
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 12
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 13
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 14
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 15
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 16
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 17
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 18
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 19
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 20
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 21
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 22
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 23
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 24
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 25
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 26  <- PAL VPos WRAP in the middle of this row
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 27
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 28
        dc.b    $00,    $fe,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$fe ; 29
        dc.b    $00,    $fe,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$fe ; 30
        dc.b    $00,    $03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$04,$04,$04 ; 31
        dc.b    $00,    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 32  <- Empty zone
        even

; Going clockwise around the center of the cluster in onionring-ish fashion.
; Bytes added/subtracted for brick placement in Game area.
ClusterOffsets:
        dc.w    0,      41,     -2,     -41,    2
        dc.w    41-2,   -41-2,  -41+2,  41+2

GAMEAREA_ROW_LOOKUP:
        dc.l    GAMEAREA+1+0*40
        dc.l    GAMEAREA+2+1*40
        dc.l    GAMEAREA+3+2*40
        dc.l    GAMEAREA+4+3*40
        dc.l    GAMEAREA+5+4*40
        dc.l    GAMEAREA+6+5*40
        dc.l    GAMEAREA+7+6*40
        dc.l    GAMEAREA+8+7*40
        dc.l    GAMEAREA+9+8*40
        dc.l    GAMEAREA+10+9*40
        dc.l    GAMEAREA+11+10*40
        dc.l    GAMEAREA+12+11*40
        dc.l    GAMEAREA+13+12*40
        dc.l    GAMEAREA+14+13*40
        dc.l    GAMEAREA+15+14*40
        dc.l    GAMEAREA+16+15*40
        dc.l    GAMEAREA+17+16*40
        dc.l    GAMEAREA+18+17*40
        dc.l    GAMEAREA+19+18*40
        dc.l    GAMEAREA+20+19*40
        dc.l    GAMEAREA+21+20*40
        dc.l    GAMEAREA+22+21*40
        dc.l    GAMEAREA+23+22*40
        dc.l    GAMEAREA+24+23*40
        dc.l    GAMEAREA+25+24*40
        dc.l    GAMEAREA+26+25*40
        dc.l    GAMEAREA+27+26*40
        dc.l    GAMEAREA+28+27*40
        dc.l    GAMEAREA+29+28*40
        dc.l    GAMEAREA+30+29*40
        dc.l    GAMEAREA+31+30*40
        dc.l    GAMEAREA+32+31*40

        dc.l    GAMEAREA+33+32*40       ; Cover one row beyond visible area

; Lookup table to avoid costly division
GAMEAREA_BYTE_TO_ROWCOL_LOOKUP:
        dc.b    00,00   ; Column 0, Row 0
        dc.b    01,00
        dc.b    02,00
        dc.b    03,00
        dc.b    04,00
        dc.b    05,00
        dc.b    06,00
        dc.b    07,00
        dc.b    08,00
        dc.b    09,00
        dc.b    10,00
        dc.b    11,00
        dc.b    12,00
        dc.b    13,00
        dc.b    14,00
        dc.b    15,00
        dc.b    16,00
        dc.b    17,00
        dc.b    18,00
        dc.b    19,00
        dc.b    20,00
        dc.b    21,00
        dc.b    22,00
        dc.b    23,00
        dc.b    24,00
        dc.b    25,00
        dc.b    26,00
        dc.b    27,00
        dc.b    28,00
        dc.b    29,00
        dc.b    30,00
        dc.b    31,00
        dc.b    32,00
        dc.b    33,00
        dc.b    34,00
        dc.b    35,00
        dc.b    36,00
        dc.b    37,00
        dc.b    38,00
        dc.b    39,00
        dc.b    40,00
        dc.b    00,01   ; 1
        dc.b    01,01
        dc.b    02,01
        dc.b    03,01
        dc.b    04,01
        dc.b    05,01
        dc.b    06,01
        dc.b    07,01
        dc.b    08,01
        dc.b    09,01
        dc.b    10,01
        dc.b    11,01
        dc.b    12,01
        dc.b    13,01
        dc.b    14,01
        dc.b    15,01
        dc.b    16,01
        dc.b    17,01
        dc.b    18,01
        dc.b    19,01
        dc.b    20,01
        dc.b    21,01
        dc.b    22,01
        dc.b    23,01
        dc.b    24,01
        dc.b    25,01
        dc.b    26,01
        dc.b    27,01
        dc.b    28,01
        dc.b    29,01
        dc.b    30,01
        dc.b    31,01
        dc.b    32,01
        dc.b    33,01
        dc.b    34,01
        dc.b    35,01
        dc.b    36,01
        dc.b    37,01
        dc.b    38,01
        dc.b    39,01
        dc.b    40,01
        dc.b    00,02   ; 2
        dc.b    01,02
        dc.b    02,02
        dc.b    03,02
        dc.b    04,02
        dc.b    05,02
        dc.b    06,02
        dc.b    07,02
        dc.b    08,02
        dc.b    09,02
        dc.b    10,02
        dc.b    11,02
        dc.b    12,02
        dc.b    13,02
        dc.b    14,02
        dc.b    15,02
        dc.b    16,02
        dc.b    17,02
        dc.b    18,02
        dc.b    19,02
        dc.b    20,02
        dc.b    21,02
        dc.b    22,02
        dc.b    23,02
        dc.b    24,02
        dc.b    25,02
        dc.b    26,02
        dc.b    27,02
        dc.b    28,02
        dc.b    29,02
        dc.b    30,02
        dc.b    31,02
        dc.b    32,02
        dc.b    33,02
        dc.b    34,02
        dc.b    35,02
        dc.b    36,02
        dc.b    37,02
        dc.b    38,02
        dc.b    39,02
        dc.b    40,02
        dc.b    00,03   ; 3
        dc.b    01,03
        dc.b    02,03
        dc.b    03,03
        dc.b    04,03
        dc.b    05,03
        dc.b    06,03
        dc.b    07,03
        dc.b    08,03
        dc.b    09,03
        dc.b    10,03
        dc.b    11,03
        dc.b    12,03
        dc.b    13,03
        dc.b    14,03
        dc.b    15,03
        dc.b    16,03
        dc.b    17,03
        dc.b    18,03
        dc.b    19,03
        dc.b    20,03
        dc.b    21,03
        dc.b    22,03
        dc.b    23,03
        dc.b    24,03
        dc.b    25,03
        dc.b    26,03
        dc.b    27,03
        dc.b    28,03
        dc.b    29,03
        dc.b    30,03
        dc.b    31,03
        dc.b    32,03
        dc.b    33,03
        dc.b    34,03
        dc.b    35,03
        dc.b    36,03
        dc.b    37,03
        dc.b    38,03
        dc.b    39,03
        dc.b    40,03
        dc.b    00,04   ; 4
        dc.b    01,04
        dc.b    02,04
        dc.b    03,04
        dc.b    04,04
        dc.b    05,04
        dc.b    06,04
        dc.b    07,04
        dc.b    08,04
        dc.b    09,04
        dc.b    10,04
        dc.b    11,04
        dc.b    12,04
        dc.b    13,04
        dc.b    14,04
        dc.b    15,04
        dc.b    16,04
        dc.b    17,04
        dc.b    18,04
        dc.b    19,04
        dc.b    20,04
        dc.b    21,04
        dc.b    22,04
        dc.b    23,04
        dc.b    24,04
        dc.b    25,04
        dc.b    26,04
        dc.b    27,04
        dc.b    28,04
        dc.b    29,04
        dc.b    30,04
        dc.b    31,04
        dc.b    32,04
        dc.b    33,04
        dc.b    34,04
        dc.b    35,04
        dc.b    36,04
        dc.b    37,04
        dc.b    38,04
        dc.b    39,04
        dc.b    40,04
        dc.b    00,05   ; 5 -----------------
        dc.b    01,05
        dc.b    02,05
        dc.b    03,05
        dc.b    04,05
        dc.b    05,05
        dc.b    06,05
        dc.b    07,05
        dc.b    08,05
        dc.b    09,05
        dc.b    10,05
        dc.b    11,05
        dc.b    12,05
        dc.b    13,05
        dc.b    14,05
        dc.b    15,05
        dc.b    16,05
        dc.b    17,05
        dc.b    18,05
        dc.b    19,05
        dc.b    20,05
        dc.b    21,05
        dc.b    22,05
        dc.b    23,05
        dc.b    24,05
        dc.b    25,05
        dc.b    26,05
        dc.b    27,05
        dc.b    28,05
        dc.b    29,05
        dc.b    30,05
        dc.b    31,05
        dc.b    32,05
        dc.b    33,05
        dc.b    34,05
        dc.b    35,05
        dc.b    36,05
        dc.b    37,05
        dc.b    38,05
        dc.b    39,05
        dc.b    40,05
        dc.b    00,06   ; 6
        dc.b    01,06
        dc.b    02,06
        dc.b    03,06
        dc.b    04,06
        dc.b    05,06
        dc.b    06,06
        dc.b    07,06
        dc.b    08,06
        dc.b    09,06
        dc.b    10,06
        dc.b    11,06
        dc.b    12,06
        dc.b    13,06
        dc.b    14,06
        dc.b    15,06
        dc.b    16,06
        dc.b    17,06
        dc.b    18,06
        dc.b    19,06
        dc.b    20,06
        dc.b    21,06
        dc.b    22,06
        dc.b    23,06
        dc.b    24,06
        dc.b    25,06
        dc.b    26,06
        dc.b    27,06
        dc.b    28,06
        dc.b    29,06
        dc.b    30,06
        dc.b    31,06
        dc.b    32,06
        dc.b    33,06
        dc.b    34,06
        dc.b    35,06
        dc.b    36,06
        dc.b    37,06
        dc.b    38,06
        dc.b    39,06
        dc.b    40,06
        dc.b    00,07   ; 7
        dc.b    01,07
        dc.b    02,07
        dc.b    03,07
        dc.b    04,07
        dc.b    05,07
        dc.b    06,07
        dc.b    07,07
        dc.b    08,07
        dc.b    09,07
        dc.b    10,07
        dc.b    11,07
        dc.b    12,07
        dc.b    13,07
        dc.b    14,07
        dc.b    15,07
        dc.b    16,07
        dc.b    17,07
        dc.b    18,07
        dc.b    19,07
        dc.b    20,07
        dc.b    21,07
        dc.b    22,07
        dc.b    23,07
        dc.b    24,07
        dc.b    25,07
        dc.b    26,07
        dc.b    27,07
        dc.b    28,07
        dc.b    29,07
        dc.b    30,07
        dc.b    31,07
        dc.b    32,07
        dc.b    33,07
        dc.b    34,07
        dc.b    35,07
        dc.b    36,07
        dc.b    37,07
        dc.b    38,07
        dc.b    39,07
        dc.b    40,07
        dc.b    00,08   ; 8
        dc.b    01,08
        dc.b    02,08
        dc.b    03,08
        dc.b    04,08
        dc.b    05,08
        dc.b    06,08
        dc.b    07,08
        dc.b    08,08
        dc.b    09,08
        dc.b    10,08
        dc.b    11,08
        dc.b    12,08
        dc.b    13,08
        dc.b    14,08
        dc.b    15,08
        dc.b    16,08
        dc.b    17,08
        dc.b    18,08
        dc.b    19,08
        dc.b    20,08
        dc.b    21,08
        dc.b    22,08
        dc.b    23,08
        dc.b    24,08
        dc.b    25,08
        dc.b    26,08
        dc.b    27,08
        dc.b    28,08
        dc.b    29,08
        dc.b    30,08
        dc.b    31,08
        dc.b    32,08
        dc.b    33,08
        dc.b    34,08
        dc.b    35,08
        dc.b    36,08
        dc.b    37,08
        dc.b    38,08
        dc.b    39,08
        dc.b    40,08
        dc.b    00,09   ; 9
        dc.b    01,09
        dc.b    02,09
        dc.b    03,09
        dc.b    04,09
        dc.b    05,09
        dc.b    06,09
        dc.b    07,09
        dc.b    08,09
        dc.b    09,09
        dc.b    10,09
        dc.b    11,09
        dc.b    12,09
        dc.b    13,09
        dc.b    14,09
        dc.b    15,09
        dc.b    16,09
        dc.b    17,09
        dc.b    18,09
        dc.b    19,09
        dc.b    20,09
        dc.b    21,09
        dc.b    22,09
        dc.b    23,09
        dc.b    24,09
        dc.b    25,09
        dc.b    26,09
        dc.b    27,09
        dc.b    28,09
        dc.b    29,09
        dc.b    30,09
        dc.b    31,09
        dc.b    32,09
        dc.b    33,09
        dc.b    34,09
        dc.b    35,09
        dc.b    36,09
        dc.b    37,09
        dc.b    38,09
        dc.b    39,09
        dc.b    40,09
        dc.b    00,10   ; 10
        dc.b    01,10
        dc.b    02,10
        dc.b    03,10
        dc.b    04,10
        dc.b    05,10
        dc.b    06,10
        dc.b    07,10
        dc.b    08,10
        dc.b    09,10
        dc.b    10,10
        dc.b    11,10
        dc.b    12,10
        dc.b    13,10
        dc.b    14,10
        dc.b    15,10
        dc.b    16,10
        dc.b    17,10
        dc.b    18,10
        dc.b    19,10
        dc.b    20,10
        dc.b    21,10
        dc.b    22,10
        dc.b    23,10
        dc.b    24,10
        dc.b    25,10
        dc.b    26,10
        dc.b    27,10
        dc.b    28,10
        dc.b    29,10
        dc.b    30,10
        dc.b    31,10
        dc.b    32,10
        dc.b    33,10
        dc.b    34,10
        dc.b    35,10
        dc.b    36,10
        dc.b    37,10
        dc.b    38,10
        dc.b    39,10
        dc.b    40,10
        dc.b    00,11   ; 11
        dc.b    01,11
        dc.b    02,11
        dc.b    03,11
        dc.b    04,11
        dc.b    05,11
        dc.b    06,11
        dc.b    07,11
        dc.b    08,11
        dc.b    09,11
        dc.b    10,11
        dc.b    11,11
        dc.b    12,11
        dc.b    13,11
        dc.b    14,11
        dc.b    15,11
        dc.b    16,11
        dc.b    17,11
        dc.b    18,11
        dc.b    19,11
        dc.b    20,11
        dc.b    21,11
        dc.b    22,11
        dc.b    23,11
        dc.b    24,11
        dc.b    25,11
        dc.b    26,11
        dc.b    27,11
        dc.b    28,11
        dc.b    29,11
        dc.b    30,11
        dc.b    31,11
        dc.b    32,11
        dc.b    33,11
        dc.b    34,11
        dc.b    35,11
        dc.b    36,11
        dc.b    37,11
        dc.b    38,11
        dc.b    39,11
        dc.b    40,11
        dc.b    00,12   ; 12
        dc.b    01,12
        dc.b    02,12
        dc.b    03,12
        dc.b    04,12
        dc.b    05,12
        dc.b    06,12
        dc.b    07,12
        dc.b    08,12
        dc.b    09,12
        dc.b    10,12
        dc.b    11,12
        dc.b    12,12
        dc.b    13,12
        dc.b    14,12
        dc.b    15,12
        dc.b    16,12
        dc.b    17,12
        dc.b    18,12
        dc.b    19,12
        dc.b    20,12
        dc.b    21,12
        dc.b    22,12
        dc.b    23,12
        dc.b    24,12
        dc.b    25,12
        dc.b    26,12
        dc.b    27,12
        dc.b    28,12
        dc.b    29,12
        dc.b    30,12
        dc.b    31,12
        dc.b    32,12
        dc.b    33,12
        dc.b    34,12
        dc.b    35,12
        dc.b    36,12
        dc.b    37,12
        dc.b    38,12
        dc.b    39,12
        dc.b    40,12
        dc.b    00,13   ; 13
        dc.b    01,13
        dc.b    02,13
        dc.b    03,13
        dc.b    04,13
        dc.b    05,13
        dc.b    06,13
        dc.b    07,13
        dc.b    08,13
        dc.b    09,13
        dc.b    10,13
        dc.b    11,13
        dc.b    12,13
        dc.b    13,13
        dc.b    14,13
        dc.b    15,13
        dc.b    16,13
        dc.b    17,13
        dc.b    18,13
        dc.b    19,13
        dc.b    20,13
        dc.b    21,13
        dc.b    22,13
        dc.b    23,13
        dc.b    24,13
        dc.b    25,13
        dc.b    26,13
        dc.b    27,13
        dc.b    28,13
        dc.b    29,13
        dc.b    30,13
        dc.b    31,13
        dc.b    32,13
        dc.b    33,13
        dc.b    34,13
        dc.b    35,13
        dc.b    36,13
        dc.b    37,13
        dc.b    38,13
        dc.b    39,13
        dc.b    40,13
        dc.b    00,14   ; 14
        dc.b    01,14
        dc.b    02,14
        dc.b    03,14
        dc.b    04,14
        dc.b    05,14
        dc.b    06,14
        dc.b    07,14
        dc.b    08,14
        dc.b    09,14
        dc.b    10,14
        dc.b    11,14
        dc.b    12,14
        dc.b    13,14
        dc.b    14,14
        dc.b    15,14
        dc.b    16,14
        dc.b    17,14
        dc.b    18,14
        dc.b    19,14
        dc.b    20,14
        dc.b    21,14
        dc.b    22,14
        dc.b    23,14
        dc.b    24,14
        dc.b    25,14
        dc.b    26,14
        dc.b    27,14
        dc.b    28,14
        dc.b    29,14
        dc.b    30,14
        dc.b    31,14
        dc.b    32,14
        dc.b    33,14
        dc.b    34,14
        dc.b    35,14
        dc.b    36,14
        dc.b    37,14
        dc.b    38,14
        dc.b    39,14
        dc.b    40,14
        dc.b    00,15   ; 15
        dc.b    01,15
        dc.b    02,15
        dc.b    03,15
        dc.b    04,15
        dc.b    05,15
        dc.b    06,15
        dc.b    07,15
        dc.b    08,15
        dc.b    09,15
        dc.b    10,15
        dc.b    11,15
        dc.b    12,15
        dc.b    13,15
        dc.b    14,15
        dc.b    15,15
        dc.b    16,15
        dc.b    17,15
        dc.b    18,15
        dc.b    19,15
        dc.b    20,15
        dc.b    21,15
        dc.b    22,15
        dc.b    23,15
        dc.b    24,15
        dc.b    25,15
        dc.b    26,15
        dc.b    27,15
        dc.b    28,15
        dc.b    29,15
        dc.b    30,15
        dc.b    31,15
        dc.b    32,15
        dc.b    33,15
        dc.b    34,15
        dc.b    35,15
        dc.b    36,15
        dc.b    37,15
        dc.b    38,15
        dc.b    39,15
        dc.b    40,15
        dc.b    00,16   ; 16
        dc.b    01,16
        dc.b    02,16
        dc.b    03,16
        dc.b    04,16
        dc.b    05,16
        dc.b    06,16
        dc.b    07,16
        dc.b    08,16
        dc.b    09,16
        dc.b    10,16
        dc.b    11,16
        dc.b    12,16
        dc.b    13,16
        dc.b    14,16
        dc.b    15,16
        dc.b    16,16
        dc.b    17,16
        dc.b    18,16
        dc.b    19,16
        dc.b    20,16
        dc.b    21,16
        dc.b    22,16
        dc.b    23,16
        dc.b    24,16
        dc.b    25,16
        dc.b    26,16
        dc.b    27,16
        dc.b    28,16
        dc.b    29,16
        dc.b    30,16
        dc.b    31,16
        dc.b    32,16
        dc.b    33,16
        dc.b    34,16
        dc.b    35,16
        dc.b    36,16
        dc.b    37,16
        dc.b    38,16
        dc.b    39,16
        dc.b    40,16
        dc.b    00,17   ; 17
        dc.b    01,17
        dc.b    02,17
        dc.b    03,17
        dc.b    04,17
        dc.b    05,17
        dc.b    06,17
        dc.b    07,17
        dc.b    08,17
        dc.b    09,17
        dc.b    10,17
        dc.b    11,17
        dc.b    12,17
        dc.b    13,17
        dc.b    14,17
        dc.b    15,17
        dc.b    16,17
        dc.b    17,17
        dc.b    18,17
        dc.b    19,17
        dc.b    20,17
        dc.b    21,17
        dc.b    22,17
        dc.b    23,17
        dc.b    24,17
        dc.b    25,17
        dc.b    26,17
        dc.b    27,17
        dc.b    28,17
        dc.b    29,17
        dc.b    30,17
        dc.b    31,17
        dc.b    32,17
        dc.b    33,17
        dc.b    34,17
        dc.b    35,17
        dc.b    36,17
        dc.b    37,17
        dc.b    38,17
        dc.b    39,17
        dc.b    40,17
        dc.b    00,18   ; 18
        dc.b    01,18
        dc.b    02,18
        dc.b    03,18
        dc.b    04,18
        dc.b    05,18
        dc.b    06,18
        dc.b    07,18
        dc.b    08,18
        dc.b    09,18
        dc.b    10,18
        dc.b    11,18
        dc.b    12,18
        dc.b    13,18
        dc.b    14,18
        dc.b    15,18
        dc.b    16,18
        dc.b    17,18
        dc.b    18,18
        dc.b    19,18
        dc.b    20,18
        dc.b    21,18
        dc.b    22,18
        dc.b    23,18
        dc.b    24,18
        dc.b    25,18
        dc.b    26,18
        dc.b    27,18
        dc.b    28,18
        dc.b    29,18
        dc.b    30,18
        dc.b    31,18
        dc.b    32,18
        dc.b    33,18
        dc.b    34,18
        dc.b    35,18
        dc.b    36,18
        dc.b    37,18
        dc.b    38,18
        dc.b    39,18
        dc.b    40,18
        dc.b    00,19   ; 19
        dc.b    01,19
        dc.b    02,19
        dc.b    03,19
        dc.b    04,19
        dc.b    05,19
        dc.b    06,19
        dc.b    07,19
        dc.b    08,19
        dc.b    09,19
        dc.b    10,19
        dc.b    11,19
        dc.b    12,19
        dc.b    13,19
        dc.b    14,19
        dc.b    15,19
        dc.b    16,19
        dc.b    17,19
        dc.b    18,19
        dc.b    19,19
        dc.b    20,19
        dc.b    21,19
        dc.b    22,19
        dc.b    23,19
        dc.b    24,19
        dc.b    25,19
        dc.b    26,19
        dc.b    27,19
        dc.b    28,19
        dc.b    29,19
        dc.b    30,19
        dc.b    31,19
        dc.b    32,19
        dc.b    33,19
        dc.b    34,19
        dc.b    35,19
        dc.b    36,19
        dc.b    37,19
        dc.b    38,19
        dc.b    39,19
        dc.b    40,19
        dc.b    00,20   ; 20
        dc.b    01,20
        dc.b    02,20
        dc.b    03,20
        dc.b    04,20
        dc.b    05,20
        dc.b    06,20
        dc.b    07,20
        dc.b    08,20
        dc.b    09,20
        dc.b    10,20
        dc.b    11,20
        dc.b    12,20
        dc.b    13,20
        dc.b    14,20
        dc.b    15,20
        dc.b    16,20
        dc.b    17,20
        dc.b    18,20
        dc.b    19,20
        dc.b    20,20
        dc.b    21,20
        dc.b    22,20
        dc.b    23,20
        dc.b    24,20
        dc.b    25,20
        dc.b    26,20
        dc.b    27,20
        dc.b    28,20
        dc.b    29,20
        dc.b    30,20
        dc.b    31,20
        dc.b    32,20
        dc.b    33,20
        dc.b    34,20
        dc.b    35,20
        dc.b    36,20
        dc.b    37,20
        dc.b    38,20
        dc.b    39,20
        dc.b    40,20
        dc.b    00,21   ; 21
        dc.b    01,21
        dc.b    02,21
        dc.b    03,21
        dc.b    04,21
        dc.b    05,21
        dc.b    06,21
        dc.b    07,21
        dc.b    08,21
        dc.b    09,21
        dc.b    10,21
        dc.b    11,21
        dc.b    12,21
        dc.b    13,21
        dc.b    14,21
        dc.b    15,21
        dc.b    16,21
        dc.b    17,21
        dc.b    18,21
        dc.b    19,21
        dc.b    20,21
        dc.b    21,21
        dc.b    22,21
        dc.b    23,21
        dc.b    24,21
        dc.b    25,21
        dc.b    26,21
        dc.b    27,21
        dc.b    28,21
        dc.b    29,21
        dc.b    30,21
        dc.b    31,21
        dc.b    32,21
        dc.b    33,21
        dc.b    34,21
        dc.b    35,21
        dc.b    36,21
        dc.b    37,21
        dc.b    38,21
        dc.b    39,21
        dc.b    40,21
        dc.b    00,22   ; 22
        dc.b    01,22
        dc.b    02,22
        dc.b    03,22
        dc.b    04,22
        dc.b    05,22
        dc.b    06,22
        dc.b    07,22
        dc.b    08,22
        dc.b    09,22
        dc.b    10,22
        dc.b    11,22
        dc.b    12,22
        dc.b    13,22
        dc.b    14,22
        dc.b    15,22
        dc.b    16,22
        dc.b    17,22
        dc.b    18,22
        dc.b    19,22
        dc.b    20,22
        dc.b    21,22
        dc.b    22,22
        dc.b    23,22
        dc.b    24,22
        dc.b    25,22
        dc.b    26,22
        dc.b    27,22
        dc.b    28,22
        dc.b    29,22
        dc.b    30,22
        dc.b    31,22
        dc.b    32,22
        dc.b    33,22
        dc.b    34,22
        dc.b    35,22
        dc.b    36,22
        dc.b    37,22
        dc.b    38,22
        dc.b    39,22
        dc.b    40,22
        dc.b    00,23   ; 23
        dc.b    01,23
        dc.b    02,23
        dc.b    03,23
        dc.b    04,23
        dc.b    05,23
        dc.b    06,23
        dc.b    07,23
        dc.b    08,23
        dc.b    09,23
        dc.b    10,23
        dc.b    11,23
        dc.b    12,23
        dc.b    13,23
        dc.b    14,23
        dc.b    15,23
        dc.b    16,23
        dc.b    17,23
        dc.b    18,23
        dc.b    19,23
        dc.b    20,23
        dc.b    21,23
        dc.b    22,23
        dc.b    23,23
        dc.b    24,23
        dc.b    25,23
        dc.b    26,23
        dc.b    27,23
        dc.b    28,23
        dc.b    29,23
        dc.b    30,23
        dc.b    31,23
        dc.b    32,23
        dc.b    33,23
        dc.b    34,23
        dc.b    35,23
        dc.b    36,23
        dc.b    37,23
        dc.b    38,23
        dc.b    39,23
        dc.b    40,23
        dc.b    00,24   ; 24
        dc.b    01,24
        dc.b    02,24
        dc.b    03,24
        dc.b    04,24
        dc.b    05,24
        dc.b    06,24
        dc.b    07,24
        dc.b    08,24
        dc.b    09,24
        dc.b    10,24
        dc.b    11,24
        dc.b    12,24
        dc.b    13,24
        dc.b    14,24
        dc.b    15,24
        dc.b    16,24
        dc.b    17,24
        dc.b    18,24
        dc.b    19,24
        dc.b    20,24
        dc.b    21,24
        dc.b    22,24
        dc.b    23,24
        dc.b    24,24
        dc.b    25,24
        dc.b    26,24
        dc.b    27,24
        dc.b    28,24
        dc.b    29,24
        dc.b    30,24
        dc.b    31,24
        dc.b    32,24
        dc.b    33,24
        dc.b    34,24
        dc.b    35,24
        dc.b    36,24
        dc.b    37,24
        dc.b    38,24
        dc.b    39,24
        dc.b    40,24
        dc.b    00,25   ; 25
        dc.b    01,25
        dc.b    02,25
        dc.b    03,25
        dc.b    04,25
        dc.b    05,25
        dc.b    06,25
        dc.b    07,25
        dc.b    08,25
        dc.b    09,25
        dc.b    10,25
        dc.b    11,25
        dc.b    12,25
        dc.b    13,25
        dc.b    14,25
        dc.b    15,25
        dc.b    16,25
        dc.b    17,25
        dc.b    18,25
        dc.b    19,25
        dc.b    20,25
        dc.b    21,25
        dc.b    22,25
        dc.b    23,25
        dc.b    24,25
        dc.b    25,25
        dc.b    26,25
        dc.b    27,25
        dc.b    28,25
        dc.b    29,25
        dc.b    30,25
        dc.b    31,25
        dc.b    32,25
        dc.b    33,25
        dc.b    34,25
        dc.b    35,25
        dc.b    36,25
        dc.b    37,25
        dc.b    38,25
        dc.b    39,25
        dc.b    40,25
        dc.b    00,26   ; 26
        dc.b    01,26
        dc.b    02,26
        dc.b    03,26
        dc.b    04,26
        dc.b    05,26
        dc.b    06,26
        dc.b    07,26
        dc.b    08,26
        dc.b    09,26
        dc.b    10,26
        dc.b    11,26
        dc.b    12,26
        dc.b    13,26
        dc.b    14,26
        dc.b    15,26
        dc.b    16,26
        dc.b    17,26
        dc.b    18,26
        dc.b    19,26
        dc.b    20,26
        dc.b    21,26
        dc.b    22,26
        dc.b    23,26
        dc.b    24,26
        dc.b    25,26
        dc.b    26,26
        dc.b    27,26
        dc.b    28,26
        dc.b    29,26
        dc.b    30,26
        dc.b    31,26
        dc.b    32,26
        dc.b    33,26
        dc.b    34,26
        dc.b    35,26
        dc.b    36,26
        dc.b    37,26
        dc.b    38,26
        dc.b    39,26
        dc.b    40,26
        dc.b    00,27   ; 27 -------------
        dc.b    01,27
        dc.b    02,27
        dc.b    03,27
        dc.b    04,27
        dc.b    05,27
        dc.b    06,27
        dc.b    07,27
        dc.b    08,27
        dc.b    09,27
        dc.b    10,27
        dc.b    11,27
        dc.b    12,27
        dc.b    13,27
        dc.b    14,27
        dc.b    15,27
        dc.b    16,27
        dc.b    17,27
        dc.b    18,27
        dc.b    19,27
        dc.b    20,27
        dc.b    21,27
        dc.b    22,27
        dc.b    23,27
        dc.b    24,27
        dc.b    25,27
        dc.b    26,27
        dc.b    27,27
        dc.b    28,27
        dc.b    29,27
        dc.b    30,27
        dc.b    31,27
        dc.b    32,27
        dc.b    33,27
        dc.b    34,27
        dc.b    35,27
        dc.b    36,27
        dc.b    37,27
        dc.b    38,27
        dc.b    39,27
        dc.b    40,27
        dc.b    00,28   ; 28
        dc.b    01,28
        dc.b    02,28
        dc.b    03,28
        dc.b    04,28
        dc.b    05,28
        dc.b    06,28
        dc.b    07,28
        dc.b    08,28
        dc.b    09,28
        dc.b    10,28
        dc.b    11,28
        dc.b    12,28
        dc.b    13,28
        dc.b    14,28
        dc.b    15,28
        dc.b    16,28
        dc.b    17,28
        dc.b    18,28
        dc.b    19,28
        dc.b    20,28
        dc.b    21,28
        dc.b    22,28
        dc.b    23,28
        dc.b    24,28
        dc.b    25,28
        dc.b    26,28
        dc.b    27,28
        dc.b    28,28
        dc.b    29,28
        dc.b    30,28
        dc.b    31,28
        dc.b    32,28
        dc.b    33,28
        dc.b    34,28
        dc.b    35,28
        dc.b    36,28
        dc.b    37,28
        dc.b    38,28
        dc.b    39,28
        dc.b    40,28
        dc.b    00,29   ; 29
        dc.b    01,29
        dc.b    02,29
        dc.b    03,29
        dc.b    04,29
        dc.b    05,29
        dc.b    06,29
        dc.b    07,29
        dc.b    08,29
        dc.b    09,29
        dc.b    10,29
        dc.b    11,29
        dc.b    12,29
        dc.b    13,29
        dc.b    14,29
        dc.b    15,29
        dc.b    16,29
        dc.b    17,29
        dc.b    18,29
        dc.b    19,29
        dc.b    20,29
        dc.b    21,29
        dc.b    22,29
        dc.b    23,29
        dc.b    24,29
        dc.b    25,29
        dc.b    26,29
        dc.b    27,29
        dc.b    28,29
        dc.b    29,29
        dc.b    30,29
        dc.b    31,29
        dc.b    32,29
        dc.b    33,29
        dc.b    34,29
        dc.b    35,29
        dc.b    36,29
        dc.b    37,29
        dc.b    38,29
        dc.b    39,29
        dc.b    40,29
        dc.b    00,30   ; 30
        dc.b    01,30
        dc.b    02,30
        dc.b    03,30
        dc.b    04,30
        dc.b    05,30
        dc.b    06,30
        dc.b    07,30
        dc.b    08,30
        dc.b    09,30
        dc.b    10,30
        dc.b    11,30
        dc.b    12,30
        dc.b    13,30
        dc.b    14,30
        dc.b    15,30
        dc.b    16,30
        dc.b    17,30
        dc.b    18,30
        dc.b    19,30
        dc.b    20,30
        dc.b    21,30
        dc.b    22,30
        dc.b    23,30
        dc.b    24,30
        dc.b    25,30
        dc.b    26,30
        dc.b    27,30
        dc.b    28,30
        dc.b    29,30
        dc.b    30,30
        dc.b    31,30
        dc.b    32,30
        dc.b    33,30
        dc.b    34,30
        dc.b    35,30
        dc.b    36,30
        dc.b    37,30
        dc.b    38,30
        dc.b    39,30
        dc.b    40,30
        dc.b    00,31   ; 31
        dc.b    01,31
        dc.b    02,31
        dc.b    03,31
        dc.b    04,31
        dc.b    05,31
        dc.b    06,31
        dc.b    07,31
        dc.b    08,31
        dc.b    09,31
        dc.b    10,31
        dc.b    11,31
        dc.b    12,31
        dc.b    13,31
        dc.b    14,31
        dc.b    15,31
        dc.b    16,31
        dc.b    17,31
        dc.b    18,31
        dc.b    19,31
        dc.b    20,31
        dc.b    21,31
        dc.b    22,31
        dc.b    23,31
        dc.b    24,31
        dc.b    25,31
        dc.b    26,31
        dc.b    27,31
        dc.b    28,31
        dc.b    29,31
        dc.b    30,31
        dc.b    31,31
        dc.b    32,31
        dc.b    33,31
        dc.b    34,31
        dc.b    35,31
        dc.b    36,31
        dc.b    37,31
        dc.b    38,31
        dc.b    39,31
        dc.b    40,31