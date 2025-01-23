	section	ChipMemBss, bss_c

; Space for active bats (can be modified during game)
Bat0ActiveBob:	        dcb.w	(45+BatVertMargin+BatVertMargin)*4      ; 1.w wide, 45 + top/bottom margins lines extra in 4 bitplanes
Bat0ActiveBobMask:      dcb.w	(45+BatVertMargin+BatVertMargin)*4
Bat1ActiveBob:	        dcb.w	(45+BatVertMargin+BatVertMargin)*4
Bat1ActiveBobMask:      dcb.w	(45+BatVertMargin+BatVertMargin)*4
Bat2ActiveBob:	        dcb.w	7*(BatHorizByteWidth/2)*4           ; 7 lines in 4 bitplanes
Bat2ActiveBobMask:      dcb.w	7*(BatHorizByteWidth/2)*4
Bat3ActiveBob:	        dcb.w	7*(BatHorizByteWidth/2)*4
Bat3ActiveBobMask:      dcb.w	7*(BatHorizByteWidth/2)*4

Copper_MISC:            dcb.b   1024

; Need HUGE game copperlist to do all the tricks
; This is the fully maxed out size + small margin
Copper_GAME:            dcb.b   $A910+4