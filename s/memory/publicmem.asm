	section	PublicMemBss, bss

Variables:				ds.b	Variables_SizeOf

amgRncHeaderBuffer:		ds.w	20
FadeFromPalette16:		ds.l	16
ClockDigitMap:			ds.l	11		; Contains addresses to digit or ":" in CHIP ram
ColorTable:				ds.w	32*40 	; Contains RGB base color words
ShopPool:				ds.l	9
StringBuffer:			ds.b	56		; Roughly 56 chars possible on 1 line
KeyArray:				ds.b	$68
AllBalls:				
	ds.l	1						; Number of active balls -1
	ds.l	12						; Room for more balls up to 8
; Extra room to compensate for poor lost-ball logic... can we lose >3 balls in 1 frame?

AllBricks:				ds.b	AllBricksStruct_SizeOf*MAXBRICKS
AllBricksEnd:

AddBrickQueue:			ds.b	AddBrickQueueStruct_SizeOf*MAXBRICKS
AddTileQueue:			ds.b	AddTileQueueStruct_SizeOf*130 ; (can be 124)
RemoveTileQueue:		ds.b	RemoveTileQueueStruct_SizeOf*130 ; (can be 124)

AnimBricks:				ds.b	AnimBricksStruct_SizeOf*MAXANIMBRICKS
AnimBricksEnd:

BlinkOnBrickPtrs:		ds.l	MAXBLINKBRICKS
AllBlinkBricks:			ds.b	AllBlinkBricksStruct_SizeOf*MAXBLINKBRICKS

; Keeps track of the first copper-instruction for a GAMEAREA row
GameAreaRowCopper:		ds.b	GameAreaRowCopper_SizeOf*GAMEAREA_ROWS