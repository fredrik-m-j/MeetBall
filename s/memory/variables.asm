	SETSO	0
GameTick:           		so.b    1       ; Used to avoid soft-locking, reset on bat-collision.
FrameTick:					so.b    1		; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:					so.b	1		

ChillCount:					so.b	1
ChillTick:					so.b	1
UserIntentState: 			so.b 	1

; Balls
BallspeedTick:				so.b	1

dummy:						so.b	1		; EVEN

; ------------------ Screen-related ------------------ 
CurrentVisibleScreenPtr:	so.l	1
; Title
TitleBufferPtr:				so.l	1
TitleBackbufferPtr:			so.l	1
LogoCopperEffectPtr:		so.l	1
TitleFrameRoutinePtr:		so.l	1

MenuRasterOffset:			so.b	1
StayOnTitle:				so.b	1




Variables_SizeOf:   		so.w    0