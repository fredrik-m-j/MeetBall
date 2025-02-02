	section	ChipMemBss, bss_c

; Space for active bats (can be modified during game)
Bat0ActiveBob:      ds.w	(45+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4      ; 1.w wide, 45 + top/bottom margins lines extra in 4 bitplanes
Bat0ActiveBobMask:  ds.w	(45+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4
Bat1ActiveBob:      ds.w	(45+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4
Bat1ActiveBobMask:  ds.w	(45+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4
Bat2ActiveBob:      ds.w	7*(BAT_HORIZONTAL_BYTEWIDTH/2)*4           ; 7 lines in 4 bitplanes
Bat2ActiveBobMask:  ds.w	7*(BAT_HORIZONTAL_BYTEWIDTH/2)*4
Bat3ActiveBob:      ds.w	7*(BAT_HORIZONTAL_BYTEWIDTH/2)*4
Bat3ActiveBobMask:  ds.w	7*(BAT_HORIZONTAL_BYTEWIDTH/2)*4

Copper_MISC:        ds.b   1024

; Need HUGE game copperlist to do all the tricks
; This is the fully maxed out size + small margin
Copper_GAME:        ds.b   $A800+4 ; Previously $A910+4