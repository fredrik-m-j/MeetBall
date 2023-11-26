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
RUNNING_STATE		equ	0
SHOPPING_STATE		equ	1

SOFTLOCK_FRAMES		equ	15	; 15s

GameTick:		dc.b	SOFTLOCK_FRAMES	; Used to avoid soft-locking, reset on bat-collision.
FrameTick:      	dc.b    0		; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:		dc.b	RUNNING_STATE

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
	bsr	SetGameBall0CopperPtr
	bsr	SetGamePowerupCopperPtr

	tst.b	AttractState
	bmi	.initNormalGame

	bsr	InitAttractGame
	
	; Initialize game
.initNormalGame
	bsr	DisarmAllSprites
	bsr	RestoreBackingScreen

	IFEQ	ENABLE_MENU	; DEBUG - set ballowner
	lea	Ball0,a0
	move.l	#Bat0,hPlayerBat(a0)
	move.b	JoystickControl,Player0Enabled
	bsr	ResetBalls
	ENDC

	move.l	COPPTR_GAME,a1
	IFEQ	ENABLE_DEBUG_GAMECOPPER
	jsr	LoadCopper
	ELSE
	bsr 	LoadDebugCopperlist
.l	bra	.l
	ENDC

	move.b  #INIT_BALLCOUNT,BallsLeft
	move.w	#1,LevelCount
	move.b  BallspeedFrameCount,BallspeedFrameCountCopy

	bsr	SetPlayerCount
	move.w	#DEFAULT_MAXENEMIES,d1
	sub.w	d0,d1
	move.w	d1,MaxEnemySlots		; Balance difficulty and blitter load

	bsr	ResetScores
	bsr	ClearGameArea
	bsr	InitializePlayerAreas
	bsr	DrawGamearea
	bsr	DrawAvailableBalls
	bsr	TransitionToNextLevel

	IFGT	ENABLE_DEBUG_BALL
	bsr	ReleaseBallFromPosition
	ENDIF


; Game loop
; ---------
.gameLoop
	WAITVBL

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f0f,$dff180
	ENDC

.doUpdates
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$800,$dff180
	ENDC

	bsr	ClearBobs

	tst.b   AttractState			; Try to do other stuff while clearing
        bmi	.playerUpdates
	bsr	CpuUpdates
	bsr	CheckFirebuttons
	tst.b	d0
	bne	.ballUpdates
	clr.b	BallsLeft			; Fake game over
	bra	.exit
.playerUpdates
	bsr	PlayerUpdates
.ballUpdates
	bsr	BallUpdates
	bsr	PowerupUpdates

	bsr	EnemyUpdates			; Requires bob clear
	bsr	BulletUpdates			; Requires bob clear
	moveq	#1,d0
	bsr	DrawBobs

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC

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
	cmp.b	#25,d0
	bne	.4th
	bsr	TriggerUpdateBlinkBrick
.4th
	and.b	#3,d0				; Some updates every 4th frame
	bne	.evenFrame
	bsr	ScoreUpdates
	tst.b	InsanoState
	bmi	.evenFrame
	cmp.b	#PHAZE101OUT_STATE,InsanoState
	beq	.evenFrame
	bsr	Insanoballz

.evenFrame
	btst	#0,FrameTick			; Even out the load
	bne	.oddFrame

	tst.b	WideBatCounter
	beq	.checkAddBrickQueue
	move.l	WideningRoutine,a5
	jsr	(a5)
	subq.b	#1,WideBatCounter
	bne	.checkAddBrickQueue
	
	move.l	WideningBat,a5
	cmp.l	#PwrWidenHoriz,WideningRoutine
	bne	.vertWidening
	move.l	#HorizExtBatZones,hFunctionlistAddress(a5)
	bra	.checkAddBrickQueue
.vertWidening
	move.l	#VerticalExtBatZones,hFunctionlistAddress(a5)

.checkAddBrickQueue
	move.l	AddBrickQueuePtr,a2
	cmpa.l	#AddBrickQueue,a2		; Is queue empty?
	beq.s	.updateTicks
	tst.b	IsDroppingBricks
	bge	.updateTicks
	bsr	ProcessAddBrickQueue
	bra	.updateTicks

.oddFrame
	bsr	ShopUpdates
	bsr	BrickAnim
	move.l	DirtyRowQueuePtr,a0
	cmpa.l	#DirtyRowQueue,a0		; Is queue empty?
	beq	.checkTileQueues
	bsr	ProcessDirtyRowQueue
.checkTileQueues
	move.l	AddTileQueuePtr,a0
	cmpa.l	#AddTileQueue,a0		; Is queue empty?
	beq	.removeTileQ
	tst.b	InsanoState			; Don't add protective border during slowdown
	beq	.removeTileQ
	bsr	ProcessAddTileQueue
.removeTileQ
	move.l	RemoveTileQueuePtr,a0
	cmpa.l	#RemoveTileQueue,a0		; Is queue empty?
	beq	.updateTicks
	bsr	ProcessRemoveTileQueue

.updateTicks
	subq.b	#1,BallspeedTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne	.awaitSpriteDraw

        clr.b	FrameTick
	subq.b	#1,GameTick

	bsr	TriggerUpdateBlinkBrick

	tst.b	InsanoState
	bpl	.checkAttract
	bsr	BrickDropCountDown

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$000,$dff180
	ENDC

.checkAttract
	tst.b	AttractState
	bmi	.awaitSpriteDraw
	subq.b	#1,AttractCount
	bne	.awaitSpriteDraw
	clr.b	BallsLeft			; Fake game over

.awaitSpriteDraw				; In the rare case we get here early
	cmp.b	#FIRST_Y_POS-1,$dff006
	blo	.awaitSpriteDraw
	bsr	DrawSprites


	tst.b	BallsLeft
	beq	.gameOver
	tst.b	KEYARRAY+KEY_ESCAPE	; ESC -> end game
	bne	.gameOver

	cmp.b	#SHOPPING_STATE,GameState
	bne	.checkBricks
	bsr	GoShopping

.checkBricks
	tst.w	BricksLeft
	bne	.gameLoop

	addq.w	#1,LevelCount
	bsr	TransitionToNextLevel

	bra	.gameLoop
	


.gameOver
	move.l	#LEVEL_TABLE,LEVELPTR
	bsr	ClearGameArea
	bsr	RestorePlayerAreas
	bsr	ResetTileQueues
	bsr	ClearActivePowerupEffects
	bsr	InitPlayerBobs
	bsr	RemoveAllBricks
	bsr	OptimizeCopperlist
	bsr	ResetBricks

	bsr	ClearPowerup		; Disarm sprites
	bsr	DisarmAllSprites

	tst.b	AttractState
	bpl	.exitAttract

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
	bra	.exit

.exitAttract
	move.l	Player0EnabledCopy,Player0Enabled	; Restore menu choices
	lea	Ball0,a0
	move.l	BallOwnerCopy,hPlayerBat(a0)
	clr.b	EnableSfx
	bsr	GameareaRestoreDemo
.exit
	bsr	ResetPlayers
	bsr	ResetBalls
	bsr	MoveBall0ToOwner

        rts


TransitionToNextLevel:
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

	tst.b	AttractState		; Skip for Attract mode?
	bpl	.drawDemo

	bsr	GameareaDrawNextLevel
	bsr	AwaitAllFirebuttonsReleased
.l2
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.l2

	bsr	GameareaRestoreGameOver
	bra	.continue
.drawDemo
	bsr	GameareaDrawDemo

.continue
	bsr	RestorePlayerAreas
	bsr	ResetTileQueues
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
	move.b	#$ff,InsanoDrops
	ENDC
 
	move.b	#RUNNING_STATE,GameState
	rts

InitAttractGame:
	move.b	#$ff,EnableSfx				; No sfx during attract
	move.b  #10,AttractCount
	move.l	Player0Enabled,Player0EnabledCopy	; Keep menu choices
	lea	Ball0,a0
	move.l	hPlayerBat(a0),BallOwnerCopy

	; Enable all players, but respect selected controls on menuscreen
	; to be able to check for fire using keyboard or joystick.
	tst.b	Player0Enabled
	bpl	.player1
	move.b	#JoystickControl,Player0Enabled
.player1
	tst.b	Player1Enabled
	bpl	.player2
	move.b	#JoystickControl,Player1Enabled
.player2
	tst.b	Player2Enabled
	bpl	.player3
	move.b	#JoystickControl,Player2Enabled
.player3
	tst.b	Player3Enabled
	bpl	.forceBatDraw
	move.b	#JoystickControl,Player3Enabled

.forceBatDraw
	lea	Bat0,a0
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)
	lea	Bat1,a0
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)
	lea	Bat2,a0
	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)
	lea	Bat3,a0
	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)

	rts