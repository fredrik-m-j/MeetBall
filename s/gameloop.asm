	section	GameData, data_p

	include 's/brick.dat'
	include 's/brickdrop.dat'
	include 's/powerup.dat'
	include	's/shop.dat'
	include	's/enemies.dat'
	include	's/hiscore.dat'
	include	's/bullet.dat'

	include	'Level/x.dat'
	include	'Level/y.dat'
	include	'Level/beer.dat'
	include	'Level/plus.dat'
	include	'Level/target.dat'
	include	'Level/plusmore.dat'
	include	'Level/walls.dat'

	IFGT ENABLE_DEBUG_BALL
	include	'Level/debug_empty.dat'
	ENDC

	section	GameCode, code_p

	include	's/brick.asm'
	include	's/brickrow.asm'
	include 's/brickdrop.asm'
	include 's/tilecolor.asm'
	include 's/collision.asm'
	include 's/powerup.asm'
	include	's/shop.asm'
	include	's/enemies.asm'
	include	's/hiscore.asm'
	include 's/bullet.asm'

; GameStates
NOT_RUNNING_STATE	equ	-1
RUNNING_STATE		equ	0
SHOPPING_STATE		equ	1

SOFTLOCK_FRAMES		equ	15	; 15s

GameTick:		dc.b	SOFTLOCK_FRAMES	; Used to avoid soft-locking, reset on bat-collision.
FrameTick:      	dc.b    0		; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:		dc.b	NOT_RUNNING_STATE

BallspeedTick		dc.b	0
	even

RestoreBackingScreen:
        move.l  GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l  GAMESCREEN_BITMAPBASE_BACK,a1
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2
        bsr     CopyRestoreGamearea

	rts

StartNewGame:
	; Initialize game
	move.b  #INIT_BALLCOUNT,BallsLeft
	move.w	#1,LevelCount
	move.b  BallspeedFrameCount,BallspeedFrameCountCopy

	bsr	ResetScores
	bsr	ClearGameArea
	bsr	InitializePlayerAreas
	bsr	DrawGamearea
	bsr	DrawAvailableBalls
	bsr	TransitionToNextLevel

	IFGT	ENABLE_DEBUG_BALL
	bsr	ReleaseBallFromPosition
	ENDIF

	move.b	#RUNNING_STATE,GameState

; Frame updates are done in vertical blank interrupt when GameState is RUNNING_STATE.
.gameLoop
	tst.b	BallsLeft
	beq	.gameOver
	tst.b	KEYARRAY+KEY_ESCAPE	; ESC -> end game
	bne	.gameOver

	cmp.b	#SHOPPING_STATE,GameState
	bne.s	.checkBricks
	bsr	GoShopping

.checkBricks
	tst.w	BricksLeft
	bne.s	.gameLoop

	addq.w	#1,LevelCount
	bsr	TransitionToNextLevel

	bra	.gameLoop
	
.gameOver
	move.b	#NOT_RUNNING_STATE,GameState

	move.l	#LEVEL_TABLE,LEVELPTR
	bsr	ClearGameArea
	bsr	RestorePlayerAreas
	bsr	ClearActivePowerupEffects
	bsr	InitPlayerBobs
	bsr	RemoveAllBricks
	bsr	OptimizeCopperlist
	bsr	ResetBricks

	bsr	ClearPowerup		; Disarm sprites
	bsr	DisarmAllSprites

.stopAudio
	jsr 	StopAudio		; Just in case any sfx is being played
	move.l	HDL_MUSICMOD_2,a0
        jsr	PlayTune

	bsr	GameareaDrawGameOver

.gameOverLoop
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.gameOverLoop


	move.l	COPPTR_GAME,a0
	move.l	hAddress(a0),a0
	lea	hColor00(a0),a0

	move.l	a0,-(sp)

	jsr	SimpleFadeOut
	bsr	GameareaRestoreGameOver
	bsr	ShowHiscore

	move.l	(sp)+,a0
        jsr	ResetFadePalette

        rts

; Runs on vertical blank interrupt
UpdateFrame:
	tst.b	GameState			; Running state?
	bne.w	.fastExit

	movem.l	d0-d7/a0-a6,-(sp)

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f0f,$dff180
	ENDC

.doUpdates
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$800,$dff180
	ENDC

	bsr	ClearBobs
	bsr	EnemyUpdates			; Requires bob clear
	bsr	BulletUpdates			; Requires bob clear
	bsr	DrawBobs

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC

	bsr	PlayerUpdates
	bsr	BallUpdates
	bsr	PowerupUpdates

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC

	bsr	CheckCollisions

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$55f,$dff180
	ENDC

	bsr	SpriteAnim

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$fff,$dff180
	ENDC

	move.b	FrameTick,d0
	and.b	#3,d0				; Some updates every 4th frame
	bne.s	.evenFrame
	bsr	ScoreUpdates
	tst.b	InsanoState
	bmi	.evenFrame
	bsr	Insanoballz

.evenFrame
	btst	#0,FrameTick			; Even out the load
	bne.s	.oddFrame

	tst.b	WideBatCounter
	beq.s	.checkAddBrickQueue
	move.l	WideningRoutine,a5
	jsr	(a5)
	subq.b	#1,WideBatCounter
	bne.s	.checkAddBrickQueue
	
	move.l	WideningBat,a5
	cmp.l	#PwrWidenHoriz,WideningRoutine
	bne.s	.vertWidening
	move.l	#HorizExtBatZones,hFunctionlistAddress(a5)
	bra.s	.checkAddBrickQueue
.vertWidening
	move.l	#VerticalExtBatZones,hFunctionlistAddress(a5)

.checkAddBrickQueue
	move.l	AddBrickQueuePtr,a0
	cmpa.l	#AddBrickQueue,a0		; Is queue empty?
	beq.s	.updateTicks
	tst.b	IsDroppingBricks
	bge.s	.updateTicks
	bsr	ProcessAddBrickQueue
	bra.s	.updateTicks

.oddFrame
	bsr	ShopUpdates
	bsr	BrickAnim
	move.l	DirtyRowQueuePtr,a0
	cmpa.l	#DirtyRowQueue,a0		; Is queue empty?
	beq.s	.checkTileQueue
	bsr	ProcessDirtyRowQueue
.checkTileQueue
	move.l	AddTileQueuePtr,a0
	cmpa.l	#AddTileQueue,a0		; Is queue empty?
	beq.s	.updateTicks
	bsr	ProcessAddTileQueue

.updateTicks
	subq.b	#1,BallspeedTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .exit

        clr.b	FrameTick
	subq.b	#1,GameTick

	bsr	TriggerUpdateBlinkBrick

	tst.b	InsanoState
	bpl	.exit
	bsr	BrickDropCountDown

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$000,$dff180
	ENDC

.exit
.awaitSpriteDraw				; In the rare case we get here early
	cmp.b	#FIRST_Y_POS-1,$dff006
	blo.b	.awaitSpriteDraw
	bsr	DrawSprites

	movem.l	(sp)+,d0-d7/a0-a6
.fastExit
	rts

TransitionToNextLevel:
	move.b	#NOT_RUNNING_STATE,GameState
	; TODO Fancy transition to next level

	clr.b	FrameTick
	move.b	#SOFTLOCK_FRAMES,GameTick
	move.b  BallspeedFrameCount,BallspeedTick

	move.l	DirtyRowQueuePtr,a0
	cmpa.l	#DirtyRowQueue,a0	; Is queue empty? (queue isn't processed every frame)
	beq.s	.transition
	bsr	ProcessDirtyRowQueue
.transition
	bsr	ClearGameArea
	bsr	ClearPowerup
	bsr	ClearActivePowerupEffects

	bsr	GameareaDrawNextLevel

	bsr	AwaitAllFirebuttonsReleased
.l2
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.l2

	bsr	GameareaRestoreGameOver

	bsr	RestorePlayerAreas
	bsr	ResetPlayers
	bsr     InitPlayerBobs
	bsr	InitialBlitPlayers
	bsr	ResetBalls
	bsr	MoveBall0ToOwner
	bsr	ResetDropClock
	bsr	ResetBricks

	bsr     MoveShop
	move.b	#1,IsShopOpenForBusiness

	bsr	GenerateBricks
	bsr	InitGameareaForNextLevel

	IFGT	ENABLE_DEBUG_BRICKS
		move.b	#99,BrickDropMinutes

		lea	Ball0,a3
		clr.b	hIndex(a3)			; Turn animation ON

		move.w	hBallEffects(a3),d1
		bset.l	#1,d1
		move.w	d1,hBallEffects(a3)

		move.l	AddBrickQueuePtr,a0
		bsr	AddDebugBricksAscending
		;bsr	AddDebugBricksDescending
		;bsr 	AddDebugBricksForCheckingVposWrap
		; bsr 	AddStaticDebugBricks
		; bsr 	AddPredefinedDebugBricks
	ENDIF

	bsr	DrawClockMinutes
	bsr	DrawClockSeconds
	bsr	DrawLevelCounter

	bsr     AwaitAllFirebuttonsReleased

	IFGT 	ENABLE_DEBUG_INSANO
	bsr	PwrStartInsanoballz
	ENDC
	IFGT	ENABLE_DEBUG_BALL
	bsr	PwrStartInsanoballz
	ENDC
 
	move.b	#RUNNING_STATE,GameState
	rts