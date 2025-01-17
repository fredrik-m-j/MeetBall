	SETSO	0
GameTick:           			so.b    1	; Used to avoid soft-locking, reset on bat-collision.
FrameTick:						so.b    1	; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:						so.b	1		

ChillCount:						so.b	1
ChillTick:						so.b	1
UserIntentState: 				so.b 	1

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

MenuRasterOffset:				so.b	1
StayOnTitle:					so.b	1

; ------------------ Bricks ------------------ 
AbandonedInitialRowCopperPtr:	so.l	1
AbandonedRowCopperPtr:			so.l	1
AbandonedGameareaRowPtr:		so.l	1
AbandonedGameareaRow:			so.w	1
AbandonedNextRasterline:		so.w	1

; ------------------ Bullets------------------ 
Bullet:							so.l	1


Variables_SizeOf:   			so.w    0