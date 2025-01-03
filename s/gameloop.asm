	section	GameData, data_p

	include 's/brick.dat'
	include 's/brickdrop.dat'
	include 's/powerup.dat'
	include	's/shop.dat'
	include	's/enemies.dat'
	include	's/bullet.dat'

	include	'Level/x.dat'
	include	'Level/y.dat'
	include	'Level/beer.dat'
	include	'Level/plus.dat'
	include	'Level/target.dat'
	include	'Level/plusmore.dat'
	include	'Level/walls.dat'

	IFGT ENABLE_DEBUG_BALL|ENABLE_DEBUG_ENEMYCOLLISION|ENABLE_DEBUG_BRICKBUG1|ENABLE_DEBUG_BOUNCE_REPT|ENABLE_DEBUGLEVEL
	include	'Level/debug_empty.dat'
	include	'Level/debug_issue1.dat'
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
	include 's/bullet.asm'

; GameStates
CONFIRM_EXIT_STATE	equ	-2
NOT_RUNNING_STATE	equ	-1
RUNNING_STATE		equ	0
SHOPPING_STATE		equ	1

SOFTLOCK_FRAMES		equ	15	; 15s

GameTick:		dc.b	SOFTLOCK_FRAMES	; Used to avoid soft-locking, reset on bat-collision.
FrameTick:      	dc.b    0		; Syncs to PAL 50 Hz ; TODO: Count downwards instead
GameState:		dc.b	NOT_RUNNING_STATE

BallspeedTick:		dc.b	0
	even

RestoreBackingScreen:
        move.l  GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l  GAMESCREEN_BITMAPBASE_BACK,a1
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2
        bsr     CopyRestoreGamearea

	add.l	#(ScrBpl*255*4),a0	; Restore last line with CPU
	add.l	#(ScrBpl*255*4),a1
	move.w	#ScrBpl-1,d0
.l
	move.b	ScrBpl*0(a0),ScrBpl*0(a1)
	move.b	ScrBpl*1(a0),ScrBpl*1(a1)
	move.b	ScrBpl*2(a0),ScrBpl*2(a1)
	move.b	ScrBpl*3(a0),ScrBpl*3(a1)
	addq.l	#1,a0
	addq.l	#1,a1
	dbf	d0,.l

	rts

; In:	a6 = address to CUSTOM $dff000
StartNewGame:
	bsr	RestoreGamescreen

	tst.b	UserIntentState
	beq	.initNormalGame

	bsr	InitDemoGame

	; Initialize game
.initNormalGame
	bsr	DisarmAllSprites
	bsr	RestoreBackingScreen

	IFEQ	ENABLE_USERINTENT	; DEBUG
		move.l	#-1,Player0Enabled	; Disable all
		lea	Ball0,a0

		; move.l	#Bat0,hPlayerBat(a0)
		; move.b	#JoystickControl,Player0Enabled
		; move.l	#Bat1,hPlayerBat(a0)
		; move.b	#KeyboardControl,Player1Enabled
		move.l	#Bat2,hPlayerBat(a0)
		move.b	#KeyboardControl,Player2Enabled
		; move.l	#Bat3,hPlayerBat(a0)
		; move.b	#KeyboardControl,Player3Enabled
		bsr	ResetBalls
	ENDC

	move.l	COPPTR_GAME,a1
	jsr	LoadCopper

	move.b  #INIT_BALLCOUNT,BallsLeft
	move.w	#1,LevelCount
	move.b  BallspeedFrameCount,BallspeedFrameCountCopy

	bsr	SetPlayerCount
	move.w	#DEFAULT_MAXENEMIES,d1
	sub.w	d0,d1
	lsr.w	d0
	sub.w	d0,d1
	move.w	d1,MaxEnemySlots		; Balance difficulty and blitter load

	bsr	BalanceScoring

	bsr	ResetScores

	WAITBLIT a6				; Make sure entire GAMESCREEN is blitted
	bsr	InitializePlayerAreas
	bsr	RegenerateGameareaCopperlist
	bsr	DrawAvailableBalls
	bsr	TransitionToNextLevel

	IFGT	ENABLE_DEBUG_BALL|ENABLE_DEBUG_ENEMYCOLLISION|ENABLE_DEBUG_BOUNCE_REPT
		; lea	Bat2,a1
		; bsr	PwrStartWideBat
		bsr	ReleaseBallFromPosition
	ENDIF

; Frame updates are done in vertical blank interrupt when GameState is RUNNING_STATE.
.gameLoop
	tst.b	BallsLeft
	beq	.gameOver
	tst.b	KEYARRAY+KEY_ESCAPE	; ESC -> end game
	bne	.checkIntent

	cmp.b	#SHOPPING_STATE,GameState
	bne.s	.checkBricks
	bsr	GoShopping

.checkBricks
	tst.w	BricksLeft
	bne.s	.gameLoop

	addq.w	#1,LevelCount
	bsr	TransitionToNextLevel

	bra	.gameLoop

.checkIntent
	tst.b	UserIntentState
	beq	.gameOver		; Playing then ragequit?

	move.b	#USERINTENT_QUIT,UserIntentState

.gameOver
	move.b	#NOT_RUNNING_STATE,GameState

	move.l	#LEVEL_TABLE,LEVELPTR
	bsr	ClearGameArea
	bsr	RegenerateGameareaCopperlist
	bsr	RestorePlayerAreas
	bsr	ResetBricksAndTiles
	bsr	ClearActivePowerupEffects
	bsr	InitPlayerBobs

	bsr	ClearPowerup		; Disarm sprites
	bsr	DisarmAllSprites

	tst.b	UserIntentState
	beq	.stopAudio
	bra	.chillOrNewGameIntent

.stopAudio
	jsr 	StopAudio		; Just in case any sfx is being played
	move.l	HDL_MUSICMOD_2,a0
        jsr	PlayTune

	bsr	GameareaDrawGameOver

.gameOverLoop
	bsr	ProcessDirtyRowQueue
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.gameOverLoop

	move.l	COPPTR_GAME,a0
	move.l	hAddress(a0),a0
	lea	hColor00(a0),a0

	move.l	a0,-(sp)

	jsr	SimpleFadeOut
	bsr	GameareaRestoreGameOver
	bsr	ShowHiscorescreen

	move.l	(sp)+,a0
        jsr	ResetFadePalette
	bra	.exit

.chillOrNewGameIntent
	move.l	Player0EnabledCopy,Player0Enabled	; Restore control choices
	lea	Ball0,a0
	move.l	BallOwnerCopy,hPlayerBat(a0)
	clr.b	EnableSfx
	bsr	GameareaRestoreDemo
.exit
        rts

; --------------------------------
; Runs on vertical blank interrupt
; --------------------------------
UpdateFrame:
	tst.b	GameState		; Running state?
	bne.w	.fastExit

	movem.l	d0-d7/a0-a6,-(sp)

	lea	CUSTOM,a6		; Set up a6 for use in frame

.doUpdates
	IFGT	ENABLE_RASTERMONITOR
	move.w	#$800,$dff180
	ENDC

	; Spin-line clearing - before clearing bobs
	move.l	#SpinBat0X,a0
	tst.w	(a0)
	beq	.checkBat1SpinClear
	bsr	SpinlineXOr
	clr.l	(a0)+			; Line removed clear variables
	clr.l	(a0)
.checkBat1SpinClear
	move.l	#SpinBat1X,a0
	tst.w	(a0)
	beq	.checkBat2SpinClear
	bsr	SpinlineXOr
	clr.l	(a0)+
	clr.l	(a0)
.checkBat2SpinClear
	move.l	#SpinBat2X,a0
	tst.w	(a0)
	beq	.checkBat3SpinClear
	bsr	SpinlineXOr
	clr.l	(a0)+
	clr.l	(a0)
.checkBat3SpinClear
	move.l	#SpinBat3X,a0
	tst.w	(a0)
	beq	.noLineClear
	bsr	SpinlineXOr
	clr.l	(a0)+
	clr.l	(a0)
.noLineClear

	bsr	ClearBobs


	tst.b   UserIntentState			; Try to do other stuff while clearing
        beq	.playerUpdates

	bsr	CpuUpdates
	bsr	CheckAllPossibleFirebuttons
	tst.b	d0
	bne	.bulletUpdates

	clr.b	BallsLeft			; Fake game over
	move.b	#USERINTENT_NEW_GAME,UserIntentState
	bra	.exit

.playerUpdates
	IFGT	ENABLE_DEBUG_PLAYERS
	bsr	CpuUpdates
	ENDC

	bsr	PlayerUpdates
.bulletUpdates

	bsr	BulletUpdates
	moveq	#1,d0
	bsr	DrawBobs

	bsr	PowerupUpdates
	bsr	BallUpdates

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC

	bsr	CheckCollisions

	; Spin-line drawing - after bullet-clear & possibly bat-redraw in collision checks
	move.l	#SpinBat0X,a0
	tst.w	(a0)
	beq	.checkBat1SpinDraw
	bsr	SpinlineXOr
.checkBat1SpinDraw
	move.l	#SpinBat1X,a0
	tst.w	(a0)
	beq	.checkBat2SpinDraw
	bsr	SpinlineXOr
.checkBat2SpinDraw
	move.l	#SpinBat2X,a0
	tst.w	(a0)
	beq	.checkBat3SpinDraw
	bsr	SpinlineXOr
.checkBat3SpinDraw
	move.l	#SpinBat3X,a0
	tst.w	(a0)
	beq	.doneLineDraw
	bsr	SpinlineXOr
.doneLineDraw

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$55f,$dff180
	ENDC

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$fff,$dff180
	ENDC

	tst.l	DirtyRowBits
	beq	.frameTick			; Is stack empty?
	tst.b	CUSTOM+VPOSR+1			; Check for extreme load - passed vertical wrap?
	beq	.doDirtyRow
	cmp.b	#$0a,$dff006			; Check for extreme load
	bhi	.frameTick
.doDirtyRow
	bsr	ProcessDirtyRowQueue

.frameTick
	tst.b	CUSTOM+VPOSR+1			; Check for extreme load - passed vertical wrap?
	beq	.t
	cmp.b	#$20,$dff006			; Check for extreme load
	bhi	.updateTicks			; ABANDON any further work this frame
.t
	move.b	FrameTick,d0
	cmp.b	#25,d0
	bne	.4th
	bsr	TriggerUpdateBlinkBrick
.4th
	and.b	#3,d0				; Some updates every 4th frame
	bne.s	.evenFrame
	bsr	ScoreUpdates
	tst.b	InsanoState
	bmi	.evenFrame
	cmp.b	#PHAZE101OUT_STATE,InsanoState
	beq	.evenFrame
	bsr	Insanoballz

	tst.b	CUSTOM+VPOSR+1			; Check for extreme load - passed vertical wrap?
	beq	.t2
	cmp.b	#$30,$dff006			; Check for extreme load
	bhi	.updateTicks			; ABANDON any further work this frame
.t2

.evenFrame
	btst	#0,FrameTick			; Even out the load
	bne.s	.oddFrame

.skipDirtyRow
	move.l	AddBrickQueuePtr,a2
	cmpa.l	#AddBrickQueue,a2		; Is queue empty?
	beq.s	.checkBatWidening
	tst.b	IsDroppingBricks
	bge.s	.checkBatWidening
	bsr	ProcessAddBrickQueue
.checkBatWidening
	tst.b	WideBatCounter
	beq.s	.updateTicks
	move.l	WideningRoutine,a5
	jsr	(a5)
	subq.b	#1,WideBatCounter
	bne.s	.updateTicks

	move.l	WideningBat,a5
	cmp.l	#PwrWidenHoriz,WideningRoutine
	bne.s	.vertWidening
	move.l	#HorizExtBatZones,hFunctionlistAddress(a5)
	bra.s	.updateTicks
.vertWidening
	move.l	#VerticalExtBatZones,hFunctionlistAddress(a5)

	bra.s	.updateTicks

.oddFrame
	bsr	BrickAnim
.checkTileQueues
	move.l	AddTileQueuePtr,a0
	cmpa.l	#AddTileQueue,a0		; Is queue empty?
	beq.s	.removeTileQ
	tst.b	InsanoState			; Don't add protective border during slowdown
	beq	.removeTileQ
	bsr	ProcessAddTileQueue
.removeTileQ
	move.l	RemoveTileQueuePtr,a0
	cmpa.l	#RemoveTileQueue,a0		; Is queue empty?
	beq.s	.updateTicks
	bsr	ProcessRemoveTileQueue

.updateTicks
	IFGT ENABLE_DEBUG_ENEMYCOLLISION
		bsr	HandleEnemyCollisionTick
	ENDC
	IFGT ENABLE_DEBUG_BOUNCE_REPT
		bsr	HandleBallCollisionTick
	ENDC

	subq.b	#1,BallspeedTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .exit

        clr.b	FrameTick
	subq.b	#1,GameTick

	bsr	TriggerUpdateBlinkBrick

	tst.b	InsanoState
	bpl	.checkUserintent
	bsr	BrickDropCountDown

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$000,$dff180
	ENDC

.checkUserintent
	tst.b	UserIntentState
	beq	.exit
	subq.b	#1,ChillCount
	bne	.exit
	clr.b	BallsLeft			; Fake game over to chill on next screen


.exit
	movem.l	(sp)+,d0-d7/a0-a6
.fastExit
	rts

TransitionToNextLevel:
	move.l	a6,-(sp)

	move.b	#NOT_RUNNING_STATE,GameState
	; TODO Fancy transition to next level

	lea	CUSTOM,a6			; Set up a6 for transition

	clr.b	FrameTick
	move.b	#SOFTLOCK_FRAMES,GameTick
	move.b  BallspeedFrameCount,BallspeedTick

.transition
	bsr	ClearGameArea
	bsr	ClearPowerup
	bsr	ClearActivePowerupEffects

	tst.b	UserIntentState			; Skip when chillin'?
	bgt	.drawDemo

	bsr	GameareaDrawNextLevel
	bsr	AwaitAllFirebuttonsReleased
.l2
	bsr	ProcessDirtyRowQueue
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.l2

	bsr	GameareaRestoreGameOver
	bra	.continue
.drawDemo
	bsr	GameareaDrawDemo

.continue
	bsr	RestorePlayerAreas
	bsr	ResetPlayers
	bsr	InitPlayerBobs
	bsr	InitialBlitPlayers
	bsr	ResetBalls
	bsr	MoveBall0ToOwner
	bsr	ResetDropClock
	bsr	ResetBricksAndTiles

	bsr     MoveShop			; Move to next spot
	move.b	#1,IsShopOpenForBusiness

	bsr	GenerateBricks
	bsr	InitGameareaForNextLevel

	IFGT	ENABLE_DEBUG_BRICKS
		move.b	#99,BrickDropMinutes

		lea	Ball0,a3
		clr.b	hIndex(a3)		; Turn animation ON

		move.w	hBallEffects(a3),d1
		bset.l	#BALLEFFECTBIT_BREACH,d1
		move.w	d1,hBallEffects(a3)

		move.l	AddBrickQueuePtr,a0
		bsr	AddDebugBricksAscending
		;bsr	AddDebugBricksDescending
		;bsr 	AddDebugBricksForCheckingVposWrap
		; bsr 	AddStaticDebugBricks
		; bsr 	AddPredefinedDebugBricks
	ENDIF
	IFGT	ENABLE_DEBUG_BRICKBUG1
		lea	Ball0,a3
		clr.b	hIndex(a3)		; Turn animation ON

		move.w	hBallEffects(a3),d1
		bset.l	#BALLEFFECTBIT_BREACH,d1
		move.w	d1,hBallEffects(a3)
	ENDIF

	bsr	DrawClockMinutes
	bsr	DrawClockSeconds
	bsr	DrawLevelCounter

	bsr     AwaitAllFirebuttonsReleased

	IFGT 	ENABLE_DEBUG_INSANO|ENABLE_DEBUG_BALL
		bsr	PwrStartInsanoballz
	ENDC
	IFGT	ENABLE_DEBUG_BALL
		move.b	#$ff,InsanoDrops
	ENDC
	IFGT	ENABLE_DEBUG_GLUE
		lea	Bat0,a0
		move.w	hBatEffects(a0),d0
		bset.l	#BATEFFECTBIT_GLUE,d0
		move.w	d0,hBatEffects(a0)

		move.w	#260*VC_FACTOR,d0
		move.w	#200*VC_FACTOR,d1
		move.w	#INITDEBUGBALLSPEEDX,d2
		move.w	#INITDEBUGBALLSPEEDY,d3
		lea	Ball0,a0
		bsr	OneshotReleaseBall
	ENDC
	IFGT	ENABLE_DEBUG_GUN
		lea	Bat0,a0
		move.w	hBatEffects(a0),d0
		bset.l	#1,d0
		move.w	d0,hBatEffects(a0)
		lea	Bat1,a0
		move.w	hBatEffects(a0),d0
		bset.l	#1,d0
		move.w	d0,hBatEffects(a0)
		lea	Bat2,a0
		move.w	hBatEffects(a0),d0
		bset.l	#1,d0
		move.w	d0,hBatEffects(a0)
		lea	Bat3,a0
		move.w	hBatEffects(a0),d0
		bset.l	#1,d0
		move.w	d0,hBatEffects(a0)
	ENDC
	IFGT	ENABLE_DEBUG_PLAYERS
		; move.w	#180*VC_FACTOR,d0 ; bad miss 1 blink
		; move.w	#194*VC_FACTOR,d1
		; move.w	#179*VC_FACTOR,d0 ; bad miss 1 blink
		; move.w	#194*VC_FACTOR,d1

		move.w	#185*VC_FACTOR,d0
		move.w	#194*VC_FACTOR,d1


		move.w	#INITDEBUGBALLSPEEDX,d2
		move.w	#INITDEBUGBALLSPEEDY,d3
		lea	Ball0,a0
		bsr	OneshotReleaseBall
	ENDC

	move.b	#RUNNING_STATE,GameState

	move.l	(sp)+,a6
	rts

InitDemoGame:
	move.b	#$ff,EnableSfx				; No sfx when chillin'
	move.b  #10,ChillCount
	move.l	Player0Enabled,Player0EnabledCopy	; Keep menu choices
	lea	Ball0,a0
	move.l	hPlayerBat(a0),BallOwnerCopy

	move.l	#Bat2,hPlayerBat(a0)			; Let bat2 be ball-owner.

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