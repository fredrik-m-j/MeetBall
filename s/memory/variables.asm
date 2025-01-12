	SETSO	0
GameTick:           so.b    1       ; Used to avoid soft-locking, reset on bat-collision.
FrameTick:			so.b    1		; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:			so.b	1		

; Balls
BallspeedTick:		so.b	1


Variables_SizeOf:   so.w    0