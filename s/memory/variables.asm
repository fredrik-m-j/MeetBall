	SETSO	0
; ------------------ Copper pointers ------------------ 
; Adresses into copperlist where spritepointers are set
Copper_SPR0PTL:  				so.l    1               
Copper_SPR0PTH:  				so.l    1
Copper_SPR1PTL:  				so.l    1
Copper_SPR1PTH:  				so.l    1
Copper_SPR2PTL:  				so.l    1
Copper_SPR2PTH:  				so.l    1
Copper_SPR3PTL:  				so.l    1
Copper_SPR3PTH:  				so.l    1
Copper_SPR4PTL:  				so.l    1
Copper_SPR4PTH:  				so.l    1
Copper_SPR5PTL:  				so.l    1
Copper_SPR5PTH:  				so.l    1
Copper_SPR6PTL:  				so.l    1
Copper_SPR6PTH:  				so.l    1
Copper_SPR7PTL:  				so.l    1
Copper_SPR7PTH:  				so.l    1

CopperGameEndPtr:				so.l	1	; Points to AFTER initial boilerplate copper setup
CopperMiscEndPtr:				so.l	1	; -"-

; ------------------ Counters & gamestate ------------------ 
GameTick:           			so.b    1	; Used to avoid soft-locking, reset on bat-collision.
FrameTick:						so.b    1	; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:						so.b	1		
UserIntentState: 				so.b 	1
ChillCount:						so.b	1
ChillTick:						so.b	1

; ------------------ Audio ------------------ 
MusicOn:	    				so.w	1
MusicOldFilter:     			so.b    1 	; 0 = enabled. 1 = disabled
EnableSfx:      				so.b    1	; -1 = disabled. 0 = enabled

; ------------------ Players ------------------ 
; Player0Enabled:					so.b	1
; Player1Enabled:					so.b	1
; Player2Enabled:					so.b	1
; Player3Enabled:					so.b	1

; Player0EnabledCopy:				so.b	1
; Player1EnabledCopy:				so.b	1
; Player2EnabledCopy:				so.b	1
; Player3EnabledCopy:				so.b	1

BallOwnerCopy:					so.l	1


; ------------------ Balls ------------------ 
BallspeedTick:					so.b	1

; ------------------ Enemies ------------------ 
ENEMY_SpawnCount:				so.b	1

ENEMY_Count:					so.w	1
ENEMY_MaxSlots:					so.w	1

ENEMY_StackPtr:					so.l	1
ENEMY_Stack:					so.l	ENEMIES_DEFAULTMAX

ENEMY_1AnimMap:					so.b 	Enemy1AnimStruct_SizeOf*4
Enemy_1SpawnAnimMap:			so.b	Enemy1SpawnAnimStruct_SizeOf*4
ExplosionAnimMap:				so.b	ExplosionAnimMapStruct_SizeOf*ENEMY_EXPLOSIONCOUNT

; ------------------ Screens ------------------ 
GAMESCREEN_Ptr:					so.l	1
GAMESCREEN_BackPtr:				so.l	1
GAMESCREEN_PristinePtr:			so.l	1

CurrentVisibleScreenPtr:		so.l	1
; Title
TitleBufferPtr:					so.l	1
TitleBackbufferPtr:				so.l	1
LogoCopperEffectPtr:			so.l	1
TitleFrameRoutinePtr:			so.l	1
ScrollerAnimPtr:				so.l    1

MenuRasterOffset:				so.b	1
StayOnTitle:					so.b	1

; ------------------ Level ------------------ 
LevelPtr:						so.l    1
LevelCount:						so.w	1

; ------------------ Bricks ------------------ 
BricksLeft:						so.w	1

AllBricksPtr:					so.l	1

DirtyRowBits:					so.l	1	; Each bit flags a GAMEAREA row for redraw
DirtyRowBitsOnCompletion: 		so.l	1	; New value for DirtyRowBits when GAMEAREA row is completely processed

AbandonedInitialRowCopperPtr:	so.l	1
AbandonedRowCopperPtr:			so.l	1
AbandonedGameareaRowPtr:		so.l	1
AbandonedGameareaRow:			so.w	1
AbandonedNextRasterline:		so.w	1

BrickDropPtr:           		so.l    1
BrickDropMinutes:       		so.b    1
BrickDropSeconds:       		so.b    1

AnimBricksCount:				so.b	1
NextRandomBrickCode:			so.b	1

AddBrickQueuePtr:				so.l	1	; NOTE: When bricks in queue -> points to adress +1
AddTileQueuePtr:				so.l	1	; NOTE: When tiles in queue -> points to adress +1
RemoveTileQueuePtr:				so.l	1	; NOTE: When tiles in queue -> points to adress +1

RandomColor:					so.l	1

; ------------------ Powerups ------------------ 
WideningBat:					so.l	1	; Adress to bat getting wider
WideningRoutine: 				so.l	1
WideBatCounter: 				so.b	1
InsanoState:					so.b	1
InsanoTick:						so.b	1
InsanoDrops:					so.b    1

PwrExtraPointsValue:			so.l	1

PowerupFrameCount:				so.b	1
; Bullets
BulletCount:            		so.b    1
Bullet:							so.l	1

; ------------------ Balls ------------------ 
BallsLeft:						so.b    1

;--- DUMMY
Dummy:							so.b	1	; EVEN
;--- DUMMY

BallspeedBase:					so.w    1
BallspeedFrameCount:			so.b	1	; Increase speed every frame/x times
BallspeedFrameCountCopy:		so.b	1
BallSpeedx1:					so.w	1
BallSpeedx2:					so.w	1
BallSpeedx3:					so.w	1

; ------------------ Highscore ------------------ 
SortedNewHiScoreEntriesPtr:		so.b	HiscoreEntryStruct_SizeOf*4



; ------------------ System ------------------ 
BaseVBR:                		so.l	1
_OLDCOPPER1:	        		so.l	1
_OLDCOPPER2:	        		so.l	1
_OLDLEVEL2INTERRUPT:    		so.l    1
_OLDLEVEL3INTERRUPT:    		so.l    1

Variables_SizeOf:   			so.w    0