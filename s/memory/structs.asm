	SETSO	0
; Sprite structure offsets
hVStart							so.b	1
hHStart							so.b	1
hVStop							so.b	1
hControlBits					so.b	1
	
	SETSO	0
; AllBalls structure offsets
hAllBallsActive					so.l	1
hAllBallsBall0					so.l	1
hAllBallsBall1					so.l	1
hAllBallsBall2					so.l	1
hAllBallsBall3					so.l	1
hAllBallsBall4					so.l	1
hAllBallsBall5					so.l	1
hAllBallsBall6					so.l	1
hAllBallsBall7					so.l	1
AllBallsStruct_SizeOf:			so.w	0

	SETSO	0
;BobAnimStruct:
BobAnimGfx:                  	so.l	1
BobAnimMask:            	   	so.l	1
BobAnimStruct_SizeOf:        	so.w    0

	SETSO	0
;HiscoreEntryStruct:
HiscoreEntryScorePtr:			so.l	1
HiscoreEntryRank:				so.w	1	; Rank (zero-indexed). 10 = DUMMY out of bounds
HiscoreEntryInitialsPtr:		so.l	1	; Adress to initials in HighScores struct
HiscoreEntryStruct_SizeOf:		so.w	0

	SETSO	0
;AllBricksStruct:
	so.w	1						; Brick code byte - word is used to simplify coding
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
AllBricksStruct_SizeOf:			so.w	0

	SETSO	0
BrickBit_Indestructable			so.b	1
BrickBit_NoCollision			so.b	1
	SETSO	0
;BrickStruct
BrickGfxPtr						so.l	1
BrickFlags						so.b	1	; Extra properties
BrickByteWidth					so.b	1
BrickPoints						so.l	1
BrickColorY0X0					so.l	16	; A bunch of longwords with COLOR00 changes
BricksStruct_SizeOf:			so.w	0

	SETSO	0
;AddBrickQueueStruct:
	so.w	1						; Brick code byte - word is used to simplify coding
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
AddBrickQueueStruct_SizeOf:		so.w	0

	SETSO	0
;AddTileQueueStruct:
	so.b	1						; GAMEAREA row
	so.b	1						; Brick code byte
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
AddTileQueueStruct_SizeOf:		so.w	0

	SETSO	0
;RemoveTileQueueStruct:
	so.w	1						; GAMEAREA row
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
RemoveTileQueueStruct_SizeOf:	so.w	0

	SETSO	0
;AnimStruct
	so.l	1						; BrickGfxPtr
AnimType						so.w	1
NextAnimPtr						so.l	1
AnimStruct_SizeOf:				so.w	0

	SETSO	0
;AnimBricksStruct
	so.l	1						; Address to animation struct
	so.w	1						; Brick X pos
	so.w	1						; Brick Y pos
	so.l	1						; GAMEAREA byte
AnimBricksStruct_SizeOf:		so.w	0

	SETSO	0
;AllBlinkBricksStruct
hBlinkBrick						so.l	1	; Address
hBlinkBrickGameareaPtr			so.l	1	; Address into GAMEAREA where the brick is located
hBlinkBrickCopperPtr			so.l	1	; Address into copperlist where first copperinstruction is located
hBlinkBrickStruct				so.l	1	; Brickstruct with normal or half luminosity
hBlinkBrickGameareaRowstartPtr	so.l	1	; For adding to dirty queue
AllBlinkBricksStruct_SizeOf:	so.w	0

	SETSO	0
;GameAreaRowCopper
	so.l	1						; Adress into copperlist
	so.l	1						; Bytecount: sum of bytes = 1 rasterline worth of copperinstructions
GameAreaRowCopper_SizeOf:		so.w	0

	SETSO	0
;ShopAnimMapStruct
	so.l	1						; Gfx data
	so.l	1						; Mask
ShopAnimMapStruct_SizeOf:		so.w	0
