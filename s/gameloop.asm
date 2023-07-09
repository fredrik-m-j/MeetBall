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

SOFTLOCK_FRAMES		equ	15	; 15s
GameTick:		dc.b	SOFTLOCK_FRAMES	; Used to avoid soft-locking, reset on bat-collision.
FrameTick:      	dc.b    0	; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:		dc.b	-1	; -1 Not running. 0 running.

BallspeedFrames		dc.b	2	; Increase speed every x seconds
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

	bsr	ResetScores
	bsr	ClearGameArea
	bsr	InitializePlayerAreas
	bsr	DrawGamearea
	bsr	DrawAvailableBalls
	bsr	TransitionToNextLevel

	IFGT	ENABLE_DEBUG_BALL
	;bsr	ReleaseBallFromPosition
	;bsr	IncreaseBallspeed
	ENDIF

	move.b	#0,GameState

; Frame updates are done in vertical blank interrupt.
.gameLoop
	tst.b	BallsLeft
	beq	.gameOver
	tst.b	KEYARRAY+KEY_ESCAPE	; ESC -> end game
	bne	.gameOver

	tst.w	BricksLeft
	bne.s	.gameLoop

	addq.w	#1,LevelCount
	bsr	TransitionToNextLevel

	bra	.gameLoop
	
.gameOver
	move.b	#-1,GameState

	move.l	#LEVEL_TABLE,LEVELPTR
	bsr	ClearGameArea
	bsr	RestorePlayerAreas
	bsr	ClearActivePowerupEffects
	bsr	InitPlayerBobs
	bsr	ResetBricks
	bsr	OptimizeCopperlist
	bsr	ResetBrickQueues

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
	movem.l d0/a6,-(sp)

	tst.b	GameState
	bmi.w	.exit

	; Do this early in vertical blank because it seems to take quite some
	; time for sprites to "settle" when updating sprite pointers.
	bsr	SpriteAnim

        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .doUpdates
        clr.b	FrameTick
	subq.b	#1,GameTick
	subq.b	#1,BallspeedTick

	bsr	BrickDropCountDown
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$fff,$dff180
	ENDC

.doUpdates
	bsr	ClearBobs
	bsr	EnemyUpdates			; Requires bob clear
	bsr	BulletUpdates			; Requires bob clear
	bsr	DrawBobs

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC
	
	bsr	PlayerUpdates
	bsr	BallUpdates

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC

	bsr	CheckCollisions

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$55f,$dff180
	ENDC

.awaitSpritePointerUpdates			; In the rare case we get here early
	cmp.b	#$1a,$dff006
	blo.b	.awaitSpritePointerUpdates

	bsr	DrawSprites

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$00f,$dff180
	ENDC

.evenFrame
	btst	#0,FrameTick			; Even out the load
	bne.s	.oddFrame

	tst.b	WideBatCounter
	beq.s	.checkAddQueue
	move.l	WideningRoutine,a5
	jsr	(a5)
	subq.b	#1,WideBatCounter
	bne.s	.checkAddQueue
	
	move.l	WideningBat,a5
	cmp.l	#PwrWidenHoriz,WideningRoutine
	bne.s	.vertWidening
	move.l	#HorizExtBatZones,hFunctionlistAddress(a5)
	bra.s	.checkAddQueue
.vertWidening
	move.l	#VerticalExtBatZones,hFunctionlistAddress(a5)

.checkAddQueue
	move.l	AddBrickQueuePtr,a0
	cmpa.l	#AddBrickQueue,a0		; Is queue empty?
	beq.s	.exit
	tst.b	IsDroppingBricks
	bge.s	.exit
	bsr	ProcessAddBrickQueue

.oddFrame
	bsr	ShopUpdates
	bsr	ScoreUpdates
	bsr	BrickAnim
	move.l	DirtyRowQueuePtr,a0
	cmpa.l	#DirtyRowQueue,a0		; Is queue empty?
	beq.s	.exit
	bsr	ProcessDirtyRowQueue

.exit
	movem.l (sp)+,d0/a6
	rts

TransitionToNextLevel:
	move.b	#-1,GameState
	; TODO Fancy transition to next level

	clr.b	FrameTick
	move.b	#SOFTLOCK_FRAMES,GameTick
	move.b  BallspeedFrames,BallspeedTick

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
	bsr	ResetBrickQueues

	bsr     MoveShop
	move.b	#1,IsShopOpenForBusiness

	bsr	GenerateBricks

	bsr	InitGameareaForNextLevel

	IFGT	ENABLE_DEBUG_BRICKS
		move.b	#99,BrickDropMinutes
		
		bsr	AddDebugBricksAscending
		;bsr	AddDebugBricksDescending
		;bsr 	AddDebugBricksForCheckingVposWrap
		; bsr 	AddStaticDebugBricks
		; bsr 	AddPredefinedDebugBricks
	ENDIF

	bsr	DrawClockMinutes
	bsr	DrawClockSeconds
	bsr	DrawLevelCounter

	bsr	SpawnEnemies
	bsr	SetSpawnedEnemies

	bsr     AwaitAllFirebuttonsReleased

	move.b	#0,GameState
	rts