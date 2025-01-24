	SETSO	0
Enemy1AnimStruct:
Enemy1AnimGfx:                  so.l	1
Enemy1AnimMask:            	    so.l	1
Enemy1AnimStruct_SizeOf:        so.w    0

	SETSO	0
Enemy1SpawnAnimStruct:
Enemy1SpawnAnimGfx:             so.l	1
Enemy1SpawnAnimMask: 	        so.l	1
Enemy1SpawnAnimStruct_SizeOf:   so.w    0

	SETSO	0
ExplosionAnimMapStruct:
ExplosionGfx:	                so.l	1
ExplosionMask:               	so.l	1
ExplosionAnimMapStruct_SizeOf:  so.w    0

	SETSO	0
HiscoreEntryStruct:
HiscoreEntryScorePtr:			so.l	1
HiscoreEntryRank:				so.w	1	; Rank (zero-indexed). 10 = DUMMY out of bounds
HiscoreEntryInitialsPtr:		so.l	1	; Adress to initials in HighScores struct
HiscoreEntryStruct_SizeOf:		so.w	0

	SETSO	0
AllBricksStruct:
	so.w	1						; Brick code byte - word is used to simplify coding
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
AllBricksStruct_SizeOf:			so.w	0

	SETSO	0
AddBrickQueueStruct:
	so.w	1						; Brick code byte - word is used to simplify coding
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
AddBrickQueueStruct_SizeOf:		so.w	0

	SETSO	0
AddTileQueueStruct:
	so.b	1						; GAMEAREA row
	so.b	1						; Brick code byte
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
AddTileQueueStruct_SizeOf:		so.w	0

	SETSO	0
RemoveTileQueueStruct:
	so.w	1						; GAMEAREA row
	so.w	1						; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
RemoveTileQueueStruct_SizeOf:	so.w	0

	SETSO	0
AnimBricksStruct:
	so.l	1						; Address to animation struct
	so.w	1						; Brick X pos
	so.w	1						; Brick Y pos
	so.l	1						; GAMEAREA byte
AnimBricksStruct_SizeOf:		so.w	0