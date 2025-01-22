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