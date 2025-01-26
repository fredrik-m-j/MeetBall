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
Player0Enabled:					so.b	1
Player1Enabled:					so.b	1
Player2Enabled:					so.b	1
Player3Enabled:					so.b	1

Player0Score:					so.l	1
Player1Score:					so.l	1
Player2Score:					so.l	1
Player3Score:					so.l	1
DirtyPlayer0Score:				so.b	1
DirtyPlayer1Score:				so.b	1
DirtyPlayer2Score:				so.b	1
DirtyPlayer3Score:				so.b	1

; Pointers to chip mem source gfx
Bat0BobPtr:						so.l	1
Bat0BobMaskPtr:					so.l	1
Bat1BobPtr:						so.l	1
Bat1BobMaskPtr:					so.l	1
Bat2BobPtr:						so.l	1
Bat2BobMaskPtr:					so.l	1
Bat3BobPtr:						so.l	1
Bat3BobMaskPtr:					so.l	1

PlayersEnabledCopy:				so.l	1
BallOwnerCopy:					so.l	1

Player0AfterHitCount:			so.b	1
Player1AfterHitCount:			so.b	1
Player2AfterHitCount:			so.b	1
Player3AfterHitCount:			so.b	1
Player0AfterHitBall:			so.l	1
Player1AfterHitBall:			so.l	1
Player2AfterHitBall:			so.l	1
Player3AfterHitBall:			so.l	1

; These are used for clearing "spin lines"
SpinBat0X:						so.w	1
SpinBat0Y:						so.w	1
SpinBat0BallX:					so.w	1
SpinBat0BallY:					so.w	1
SpinBat1X:						so.w	1
SpinBat1Y:						so.w	1
SpinBat1BallX:					so.w	1
SpinBat1BallY:					so.w	1
SpinBat2X:						so.w	1
SpinBat2Y:						so.w	1
SpinBat2BallX:					so.w	1
SpinBat2BallY:					so.w	1
SpinBat3X:						so.w	1
SpinBat3Y:						so.w	1
SpinBat3BallX:					so.w	1
SpinBat3BallY:					so.w	1

; ------------------ Balls ------------------ 
BallsLeft:						so.b    1
BallspeedTick:					so.b	1

BallspeedBase:					so.w    1
BallspeedFrameCount:			so.b	1	; Increase speed every frame/x times
BallspeedFrameCountCopy:		so.b	1
BallSpeedx1:					so.w	1
BallSpeedx2:					so.w	1
BallSpeedx3:					so.w	1

CollisionRetries:				so.b	1		>|
; ------------------ Enemies ------------------  |
ENEMY_SpawnCount:				so.b	1		<|

;--- DUMMY
;Dummy:							so.b	1	; EVEN
;--- DUMMY

ENEMY_Count:					so.w	1
ENEMY_MaxSlots:					so.w	1

ENEMY_StackPtr:					so.l	1
ENEMY_Stack:					so.l	ENEMIES_DEFAULTMAX

ENEMY_1Mask:					so.l	1
ENEMY_1SpawnMask:				so.l	1
ENEMY_1AnimMap:					so.b 	Enemy1AnimStruct_SizeOf*4
Enemy_1SpawnAnimMap:			so.b	Enemy1SpawnAnimStruct_SizeOf*4
ExplosionAnimMap:				so.b	ExplosionAnimMapStruct_SizeOf*ENEMY_EXPLOSIONCOUNT

; ------------------ Screens ------------------ 
GAMESCREEN_Ptr:					so.l	1
GAMESCREEN_BackPtr:				so.l	1
GAMESCREEN_PristinePtr:			so.l	1

CurrentVisibleScreenPtr:		so.l	1
ChillSequencePtr:				so.l	1

FadePhase:						so.b	1
FadeCount:						so.b	1

; Title
TitleBufferPtr:					so.l	1
TitleBackbufferPtr:				so.l	1
LogoCopperEffectPtr:			so.l	1
TitleFrameRoutinePtr:			so.l	1
ScrollerAnimPtr:				so.l    1

MenuRasterOffset:				so.b	1
StayOnTitle:					so.b	1

; Highscore
EditHiScore:					so.b    1	; Flag indicating edit mode
DirtyInitials:					so.b    1	; Flag indicating need for re-draw

CursorPlayer0Y:					so.b    1	; Cursor Y offset from SCREEN top
CursorPlayer1Y:					so.b    1
CursorPlayer2Y:					so.b    1
CursorPlayer3Y:					so.b    1

CursorPlayer0Pos:       		so.b    1	; Cursor X pos offset (0..3)
CursorPlayer1Pos:       		so.b    1
CursorPlayer2Pos:       		so.b    1
CursorPlayer3Pos:       		so.b    1

HiScorePlayer0Fire:      		so.b    1
HiScorePlayer1Fire:      		so.b    1
HiScorePlayer2Fire:      		so.b    1
HiScorePlayer3Fire:      		so.b    1

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
AbandonedNextRasterline:		so.w	1
AbandonedGameareaRowPtr:		so.l	1
AbandonedGameareaRow:			so.b	1

IsDroppingBricks:				so.b	1

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

; ------------------ Shop ------------------ 
IsShopOpenForBusiness:			so.b	1
ShopPreviousDirectionalBits:	so.b	1
Shopkeep:						so.l	1
ShopCustomerBall:				so.l	1	; The ball that hit the shop

ShopHorizontalOffset:			so.l	1
ShopVerticalOffset:				so.l	1

; Contains item functions (adress to item routine)
ShopItemA:						so.l	1
ShopItemB:						so.l	1
ShopSelectedItem:				so.l	1

ShopTopLeftPosPtr:				so.l	1

; ------------------ Highscore ------------------ 
SortedNewHiScoreEntriesPtr:		so.b	HiscoreEntryStruct_SizeOf*4

; ------------------ Graphics & music poiters ------------------ 
LogoBitmapbasePtr:				so.l	1
LogoPtr:						so.l	1 ; Shares palette

Bitmap1IffPtr:					so.l	1
Bitmap1PalettePtr:				so.l	1
Bitmap1DataPtr:					so.l	1
Bitmap2IffPtr:					so.l	1
Bitmap2PalettePtr:				so.l	1
Bitmap2DataPtr:					so.l	1
Bitmap3IffPtr:					so.l	1 ; Shares palette with BITMAP2
Bitmap3DataPtr:					so.l	1
Bitmap4IffPtr:					so.l	1 ; Shares palette with BITMAP2
Bitmap4DataPtr:					so.l	1

BobsDataPtr:					so.l	1
BobsIffPtr:						so.l	1
BobsBitmapbasePtr:				so.l	1

Mod1Ptr:						so.l	1
Mod2Ptr:						so.l	1

; ------------------ System ------------------ 
BaseVBR:                		so.l	1
_OLDCOPPER1:	        		so.l	1
_OLDCOPPER2:	        		so.l	1
_OLDLEVEL2INTERRUPT:    		so.l    1
_OLDLEVEL3INTERRUPT:    		so.l    1

Variables_SizeOf:   			so.w    0