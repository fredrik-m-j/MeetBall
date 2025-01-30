	section	PublicMemBss, bss

Variables:				ds.b	Variables_SizeOf

amgRncHeaderBuffer:		ds.w	20
FadeFromPalette16:		ds.l	16
ColorTable:				ds.w	32*40 	; Contains RGB base color words
ShopPool:				ds.l	9
StringBuffer:			ds.b	56		; Roughly 56 chars possible on 1 line
KeyArray:				ds.b	$68

AllBalls:				ds.b	AllBallsStruct_SizeOf+(4*3) ; 3 extra longwords
; Extra room to compensate for poor lost-ball logic... can we lose >3 balls in 1 frame?

AllBricks:				ds.b	AllBricksStruct_SizeOf*MAXBRICKS
AllBricksEnd:

AddBrickQueue:			ds.b	AddBrickQueueStruct_SizeOf*MAXBRICKS
AddTileQueue:			ds.b	AddTileQueueStruct_SizeOf*130 ; (can be 124)
RemoveTileQueue:		ds.b	RemoveTileQueueStruct_SizeOf*130 ; (can be 124)

AnimBricks:				ds.b	AnimBricksStruct_SizeOf*MAXANIMBRICKS
AnimBricksEnd:

BlinkOnBrickPtrs:		ds.l	MAXBLINKBRICKS
BlinkOffBricks:			ds.b	BricksStruct_SizeOf*MAXBLINKBRICKS
AllBlinkBricks:			ds.b	AllBlinkBricksStruct_SizeOf*MAXBLINKBRICKS

; Keeps track of the first copper-instruction for a GAMEAREA row
GameAreaRowCopper:		ds.b	GameAreaRowCopper_SizeOf*GAMEAREA_ROWS

AllBullets:				ds.l    BULLET_MAXSLOTS

ShopAnimMap:			ds.b	ShopAnimMapStruct_SizeOf*25

ScoreDigitMap:			ds.b	10*4 ; 10 Addresses to digits in CHIP ram