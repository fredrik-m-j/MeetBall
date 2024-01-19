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
	IFGT ENABLE_DEBUG_ENEMYCOLLISSION
	include	'Level/debug_issue1.dat'
	ENDC

	IFGT ENABLE_DEBUG_BRICKBUG1
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

BallspeedTick:		dc.b	0
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
	bsr	OptimizeCopperlist
	bsr	DrawAvailableBalls
	bsr	TransitionToNextLevel

	IFGT	ENABLE_DEBUG_BALL
	bsr	ReleaseBallFromPosition
	ENDIF
	IFGT	ENABLE_DEBUG_ENEMYCOLLISSION
	bsr	ReleaseBallFromPosition
	ENDIF

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
	bsr	ResetBricks
	; bsr	InitFreeDirtyRowStack
	; bsr	OptimizeCopperlist
	bsr	ResetTileQueues
	bsr	ClearActivePowerupEffects
	bsr	InitPlayerBobs

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

	tst.b   AttractState			; Try to do other stuff while clearing
        bmi.s   .playerUpdates
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

	cmp.b	#FIRST_Y_POS-1,$dff006		; Check VHPOSR
	blo	.checkLowLoad
	moveq	#1,d0				; High load
	move.l	d0,-(sp)			; NOTE: sneaky use of d0 on stack
	bra	.doneLoadCheck
.checkLowLoad
	moveq	#0,d0
	move.b	$dff005,d0			; Check LSB of VPOSR
	move.l	d0,-(sp)			; 1 = vertical most significant bit is set (high load)

.doneLoadCheck

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$fff,$dff180
	ENDC

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

.evenFrame
	btst	#0,FrameTick			; Even out the load
	bne.s	.oddFrame

	tst.l	DirtyRowBits
	beq	.skipDirtyRow			; Is stack empty?
	cmp.b	#$e0,$dff006			; Check for extreme load
	bhi	.skipDirtyRow
	bsr	ProcessDirtyRowQueue
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
	bsr	ShopUpdates
	bsr	SpriteAnim
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
	IFGT ENABLE_DEBUG_ENEMYCOLLISSION
	bsr	HandleEnemyCollissionTick
	ENDC

	subq.b	#1,BallspeedTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .spriteCheck

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
	bmi	.spriteCheck
	subq.b	#1,AttractCount
	bne	.spriteCheck
	clr.b	BallsLeft			; Fake game over

.spriteCheck
	move.l	(sp)+,d0
	bne	.drawSprites

.awaitSpriteDraw				; In the rare case we get here early
	cmp.b	#FIRST_Y_POS-1,$dff006		; Check VHPOSR
	blo.b	.awaitSpriteDraw

.drawSprites
	bsr	DrawSprites

.exit
	movem.l	(sp)+,d0-d7/a0-a6
.fastExit
	rts

TransitionToNextLevel:
	move.b	#NOT_RUNNING_STATE,GameState
	; TODO Fancy transition to next level

	clr.b	FrameTick
	move.b	#SOFTLOCK_FRAMES,GameTick
	move.b  BallspeedFrameCount,BallspeedTick

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
		clr.b	hIndex(a3)			; Turn animation ON

		move.w	hBallEffects(a3),d1
		bset.l	#BALLEFFECTBIT_BREACH,d1
		move.w	d1,hBallEffects(a3)
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
	IFGT	ENABLE_DEBUG_GLUE
		lea	Bat0,a0
		move.w	hBatEffects(a0),d0
		bset.l	#BATEFFECTBIT_GLUE,d0
		move.w	d0,hBatEffects(a0)

		move.w	#290*VC_FACTOR,d0
		move.w	#220*VC_FACTOR,d1
		move.w	#INITDEBUGBALLSPEEDX,d2
		move.w	#-INITDEBUGBALLSPEEDY,d3
		lea	Ball0,a0
		bsr	OneshotReleaseBall
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