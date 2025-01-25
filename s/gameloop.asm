	section	GameData, data_p

	include	's/brick.dat'
	include	's/brickdrop.dat'
	include	's/powerup.dat'
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

	IFD		ENABLE_DEBUG_GAMEAREA
	include	'Level/debug_empty.dat'
	include	'Level/debug_issue1.dat'
	ENDIF

	section	GameCode, code_p

	include	's/brick.asm'
	include	's/brickrow.dat'
	include	's/brickrow.asm'
	include	's/brickdrop.asm'
	include	's/tilecolor.asm'
	include	's/collision.asm'
	include	's/powerup.asm'
	include	's/shop.asm'
	include	's/enemies.asm'
	include	's/bullet.asm'

RestoreBackingScreen:
	move.l  GAMESCREEN_PristinePtr(a5),a0
	move.l  GAMESCREEN_BackPtr(a5),a1
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2
	bsr		CopyRestoreGamearea

	add.l	#(ScrBpl*255*4),a0		; Restore last line with CPU
	add.l	#(ScrBpl*255*4),a1
	move.w	#ScrBpl-1,d0
.l
	move.b	ScrBpl*0(a0),ScrBpl*0(a1)
	move.b	ScrBpl*1(a0),ScrBpl*1(a1)
	move.b	ScrBpl*2(a0),ScrBpl*2(a1)
	move.b	ScrBpl*3(a0),ScrBpl*3(a1)
	addq.l	#1,a0
	addq.l	#1,a1
	dbf		d0,.l

	rts

; In:	a6 = address to CUSTOM $dff000
StartNewGame:
	bsr		RestoreGamescreen

	tst.b	UserIntentState(a5)
	beq		.initNormalGame

	bsr		InitDemoGame

	; Initialize game
.initNormalGame
	bsr		DisarmAllSprites
	bsr		RestoreBackingScreen

	IFEQ	ENABLE_USERINTENT		; DEBUG
	move.l	#-1,Player0Enabled		; Disable all
	lea		Ball0,a0

	; move.l	#Bat0,hPlayerBat(a0)
	; move.b	#CONTROL_JOYSTICK,Player0Enabled
	; move.l	#Bat1,hPlayerBat(a0)
	; move.b	#CONTROL_KEYBOARD,Player1Enabled
	move.l	#Bat2,hPlayerBat(a0)
	move.b	#CONTROL_KEYBOARD,Player2Enabled
	; move.l	#Bat3,hPlayerBat(a0)
	; move.b	#CONTROL_KEYBOARD,Player3Enabled
	bsr		ResetBalls
	ENDIF

	lea		Copper_GAME,a1
	jsr		LoadCopper

	move.b  #INIT_BALLCOUNT,BallsLeft(a5)
	move.w	#1,LevelCount(a5)
	move.b  BallspeedFrameCount(a5),BallspeedFrameCountCopy(a5)

	bsr		SetPlayerCount
	move.w	#ENEMIES_DEFAULTMAX,d1
	sub.w	d0,d1
	lsr.w	d0
	sub.w	d0,d1
	move.w	d1,ENEMY_MaxSlots(a5)	; Balance difficulty and blitter load

	bsr		BalanceScoring

	bsr		ResetScores

	WAITBLIT						; Make sure entire GAMESCREEN is blitted
	bsr		InitializePlayerAreas
	bsr		RegenerateGameareaCopperlist
	bsr		DrawAvailableBalls
	bsr		TransitionToNextLevel

	IFD		ENABLE_BALLRELEASE
	; lea	Bat2,a1
	; bsr	PwrStartWideBat
	bsr		ReleaseBallFromPosition
	ENDIF

; Frame updates are done in vertical blank interrupt when GameState is STATE_RUNNING.
.gameLoop
	tst.b	BallsLeft(a5)
	beq		.gameOver
	tst.b	KeyArray+KEY_ESCAPE		; ESC -> end game
	bne		.checkIntent

	cmp.b	#STATE_SHOPPING,GameState(a5)
	bne.s	.checkBricks
	bsr		GoShopping

.checkBricks
	tst.w	BricksLeft(a5)
	bne.s	.gameLoop

	addq.w	#1,LevelCount(a5)
	bsr		TransitionToNextLevel

	bra		.gameLoop

.checkIntent
	tst.b	UserIntentState(a5)
	beq		.gameOver				; Playing then ragequit?

	move.b	#USERINTENT_QUIT,UserIntentState(a5)

.gameOver
	move.b	#STATE_NOT_RUNNING,GameState(a5)

	move.l	#LevelTable,LevelPtr(a5)
	bsr		ClearGameArea
	bsr		RegenerateGameareaCopperlist
	bsr		RestorePlayerAreas
	bsr		ResetBricksAndTiles
	bsr		ClearActivePowerupEffects
	bsr		InitPlayerBobs

	bsr		ClearPowerup			; Disarm sprites
	bsr		DisarmAllSprites

	tst.b	UserIntentState(a5)
	beq		.stopAudio
	bra		.chillOrNewGameIntent

.stopAudio
	jsr		StopAudio				; Just in case any sfx is being played
	move.l	HDL_MUSICMOD_2,a0
	jsr		PlayTune

	bsr		GameareaDrawGameOver

.gameOverLoop
	bsr		ProcessDirtyRowQueue
	bsr		CheckFirebuttons
	tst.b	d0
	bne.s	.gameOverLoop

	lea		Copper_GAME,a0
	lea		hColor00(a0),a0

	move.l	a0,-(sp)

	jsr		SimpleFadeOut
	bsr		GameareaRestoreGameOver
	bsr		ShowHiscorescreen

	move.l	(sp)+,a0
	jsr		ResetFadePalette
	bra		.exit

.chillOrNewGameIntent
	move.l	Player0EnabledCopy,Player0Enabled	; Restore control choices
	lea		Ball0,a0
	move.l	BallOwnerCopy(a5),hPlayerBat(a0)
	clr.b	EnableSfx(a5)
	bsr		GameareaRestoreDemo
.exit
	rts

; --------------------------------
; Runs on vertical blank interrupt
; --------------------------------
UpdateFrame:
	IFD		ENABLE_RASTERMONITOR
	move.w	#$800,$dff180
	ENDIF
	IFD		ENABLE_DEBUG_PWR
	bsr		DebugCheckAddPowerup
	ENDIF

	; Spin-line clearing - before clearing bobs
	move.l	#SpinBat0X,a0
	tst.w	(a0)
	beq		.checkBat1SpinClear
	bsr		SpinlineXOr
	clr.l	(a0)+					; Line removed clear variables
	clr.l	(a0)
.checkBat1SpinClear
	move.l	#SpinBat1X,a0
	tst.w	(a0)
	beq		.checkBat2SpinClear
	bsr		SpinlineXOr
	clr.l	(a0)+
	clr.l	(a0)
.checkBat2SpinClear
	move.l	#SpinBat2X,a0
	tst.w	(a0)
	beq		.checkBat3SpinClear
	bsr		SpinlineXOr
	clr.l	(a0)+
	clr.l	(a0)
.checkBat3SpinClear
	move.l	#SpinBat3X,a0
	tst.w	(a0)
	beq		.noLineClear
	bsr		SpinlineXOr
	clr.l	(a0)+
	clr.l	(a0)
.noLineClear

	bsr		ClearBobs


	tst.b	UserIntentState(a5)		; Try to do other stuff while clearing
	beq		.playerUpdates

	bsr		CpuUpdates
	bsr		CheckAllPossibleFirebuttons
	tst.b	d0
	bne		.bulletUpdates

	clr.b	BallsLeft(a5)			; Fake game over
	move.b	#USERINTENT_NEW_GAME,UserIntentState(a5)
	bra		.exit

.playerUpdates
	IFD		ENABLE_DEBUG_PLAYERS
	bsr		CpuUpdates
	ENDIF

	bsr		PlayerUpdates
.bulletUpdates

	bsr		BulletUpdates
	moveq	#1,d0
	bsr		DrawBobs

	bsr		PowerupUpdates
	bsr		BallUpdates

	IFD		ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDIF

	IFD		ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDIF

	bsr		CheckCollisions

	; Spin-line drawing - after bullet-clear & possibly bat-redraw in collision checks
	move.l	#SpinBat0X,a0
	tst.w	(a0)
	beq		.checkBat1SpinDraw
	bsr		SpinlineXOr
.checkBat1SpinDraw
	move.l	#SpinBat1X,a0
	tst.w	(a0)
	beq		.checkBat2SpinDraw
	bsr		SpinlineXOr
.checkBat2SpinDraw
	move.l	#SpinBat2X,a0
	tst.w	(a0)
	beq		.checkBat3SpinDraw
	bsr		SpinlineXOr
.checkBat3SpinDraw
	move.l	#SpinBat3X,a0
	tst.w	(a0)
	beq		.doneLineDraw
	bsr		SpinlineXOr
.doneLineDraw

	IFD		ENABLE_RASTERMONITOR
	move.w	#$55f,$dff180
	ENDIF

	IFD		ENABLE_RASTERMONITOR
	move.w	#$fff,$dff180
	ENDIF

	tst.l	DirtyRowBits(a5)
	beq		.frameTick				; Is stack empty?
	tst.b	CUSTOM+VPOSR+1			; Check for extreme load - passed vertical wrap?
	beq		.doDirtyRow
	cmp.b	#$0a,$dff006			; Check for extreme load
	bhi		.frameTick
.doDirtyRow
	bsr		ProcessDirtyRowQueue

.frameTick
	tst.b	CUSTOM+VPOSR+1			; Check for extreme load - passed vertical wrap?
	beq		.t
	cmp.b	#$20,$dff006			; Check for extreme load
	bhi		.updateTicks			; ABANDON any further work this frame
.t
	move.b	FrameTick(a5),d0
	cmp.b	#25,d0
	bne		.4th
	bsr		TriggerUpdateBlinkBrick
.4th
	and.b	#3,d0					; Some updates every 4th frame
	bne.s	.evenFrame
	bsr		ScoreUpdates
	tst.b	InsanoState(a5)
	bmi		.evenFrame
	cmp.b	#INSANOSTATE_PHAZE101OUT,InsanoState(a5)
	beq		.evenFrame
	bsr		Insanoballz

	tst.b	CUSTOM+VPOSR+1			; Check for extreme load - passed vertical wrap?
	beq		.t2
	cmp.b	#$30,$dff006			; Check for extreme load
	bhi		.updateTicks			; ABANDON any further work this frame
.t2

.evenFrame
	btst	#0,FrameTick(a5)		; Even out the load
	bne.s	.oddFrame

.skipDirtyRow
	move.l	AddBrickQueuePtr(a5),a2
	cmpa.l	#AddBrickQueue,a2		; Is queue empty?
	beq.s	.checkBatWidening
	tst.b	IsDroppingBricks
	bge.s	.checkBatWidening
	bsr		ProcessAddBrickQueue
.checkBatWidening
	tst.b	WideBatCounter(a5)
	beq.s	.updateTicks
	move.l	WideningRoutine(a5),a0
	jsr		(a0)
	subq.b	#1,WideBatCounter(a5)
	bne.s	.updateTicks

	move.l	WideningBat(a5),a0
	cmp.l	#PwrWidenHoriz,WideningRoutine(a5)
	bne.s	.vertWidening
	move.l	#HorizExtBatZones,hFunctionlistAddress(a0)
	bra.s	.updateTicks
.vertWidening
	move.l	#VerticalExtBatZones,hFunctionlistAddress(a0)

	bra.s	.updateTicks

.oddFrame
	bsr		BrickAnim
.checkTileQueues
	move.l	AddTileQueuePtr(a5),a0
	cmpa.l	#AddTileQueue,a0		; Is queue empty?
	beq.s	.removeTileQ
	tst.b	InsanoState(a5)			; Don't add protective border during slowdown
	beq		.removeTileQ
	bsr		ProcessAddTileQueue
.removeTileQ
	move.l	RemoveTileQueuePtr(a5),a0
	cmpa.l	#RemoveTileQueue,a0		; Is queue empty?
	beq.s	.updateTicks
	bsr		ProcessRemoveTileQueue

.updateTicks
	IFD		ENABLE_DEBUG_ENEMYCOLLISION
	bsr		HandleEnemyCollisionTick
	ENDIF
	IFD		ENABLE_DEBUG_BOUNCE_REPT
	bsr		HandleBallCollisionTick
	ENDIF

	subq.b	#1,BallspeedTick(a5)
	addq.b	#1,FrameTick(a5)
	cmpi.b	#50,FrameTick(a5)
	bne.s	.exit

	clr.b	FrameTick(a5)
	subq.b	#1,GameTick(a5)

	bsr		TriggerUpdateBlinkBrick

	tst.b	InsanoState(a5)
	bpl		.checkUserintent
	bsr		BrickDropCountDown

	IFD		ENABLE_RASTERMONITOR
	move.w	#$000,$dff180
	ENDIF

.checkUserintent
	tst.b	UserIntentState(a5)
	beq		.exit
	subq.b	#1,ChillCount(a5)
	bne		.exit
	clr.b	BallsLeft(a5)			; Fake game over to chill on next screen

.exit

	rts

TransitionToNextLevel:
	move.b	#STATE_NOT_RUNNING,GameState(a5)
	; TODO Fancy transition to next level

	clr.b	FrameTick(a5)
	move.b	#SOFTLOCK_FRAMES,GameTick(a5)
	move.b  BallspeedFrameCount(a5),BallspeedTick(a5)

.transition
	bsr		ClearGameArea
	bsr		ClearPowerup
	bsr		ClearActivePowerupEffects

	tst.b	UserIntentState(a5)		; Skip when chillin'?
	bgt		.drawDemo

	bsr		GameareaDrawNextLevel
	bsr		AwaitAllFirebuttonsReleased
.l2
	bsr		ProcessDirtyRowQueue
	bsr		CheckFirebuttons
	tst.b	d0
	bne.s	.l2

	bsr		GameareaRestoreGameOver
	bra		.continue
.drawDemo
	bsr		GameareaDrawDemo

.continue
	bsr		RestorePlayerAreas
	bsr		ResetPlayers
	bsr		InitPlayerBobs
	bsr		InitialBlitPlayers
	bsr		ResetBalls
	bsr		MoveBall0ToOwner
	lea		Ball0,a2
	bsr		MoveBallSprite
	bsr		ResetDropClock
	bsr		ResetBricksAndTiles

	bsr		MoveShop				; Move to next spot
	move.b	#1,IsShopOpenForBusiness

	bsr		GenerateBricks
	bsr		InitGameareaForNextLevel

	IFD		ENABLE_DEBUG_BRICKS
	move.b	#99,BrickDropMinutes(a5)

	lea		Ball0,a3
	clr.b	hIndex(a3)				; Turn animation ON

	move.w	hBallEffects(a3),d1
	bset.l	#BALLEFFECTBIT_BREACH,d1
	move.w	d1,hBallEffects(a3)

	move.l	AddBrickQueuePtr(a5),a0
	bsr		AddDebugBricksAscending
	;bsr	AddDebugBricksDescending
	;bsr 	AddDebugBricksForCheckingVposWrap
	; bsr 	AddStaticDebugBricks
	; bsr 	AddPredefinedDebugBricks
	ENDIF

	bsr		DrawClockMinutes
	bsr		DrawClockSeconds
	bsr		DrawLevelCounter

	bsr		AwaitAllFirebuttonsReleased

	IFD		ENABLE_INSANO
	bsr		PwrStartInsanoballz
	ENDIF
	IFD		ENABLE_DEBUG_BALL
	move.b	#$ff,InsanoDrops(a5)
	ENDIF
	IFD		ENABLE_DEBUG_GLUE
	bsr		DebugGlueBats

	; lea		Ball0,a0
	; move.w	#-2*VC_FACTOR,d0
	; ; move.w	#109*VC_FACTOR,d1
	; move.w	#(109+BAT_VERT_DEFAULTHEIGHT+BALL_DIAMETER)*VC_FACTOR,d1
	; move.w	#INITDEBUGBALLSPEEDX,d2
	; move.w	#INITDEBUGBALLSPEEDY,d3

	; move.w  d0,hSprBobTopLeftXPos(a0)
	; move.w  d1,hSprBobTopLeftYPos(a0)
	; add.w	#BALL_DIAMETER*VC_FACTOR,d0		; Translate to virtual pos
	; add.w	#BALL_DIAMETER*VC_FACTOR,d1
	; move.w  d0,hSprBobBottomRightXPos(a0)
	; move.w  d1,hSprBobBottomRightYPos(a0)
	; move.w  d2,hSprBobXCurrentSpeed(a0)
	; move.w  d3,hSprBobYCurrentSpeed(a0)

	move.w	#260*VC_FACTOR,d0
	move.w	#200*VC_FACTOR,d1
	move.w	#INITDEBUGBALLSPEEDX,d2
	move.w	#INITDEBUGBALLSPEEDY,d3
	lea		Ball0,a0
	bsr		OneshotReleaseBall
	ENDIF
	IFD		ENABLE_DEBUG_GUN
	lea		Bat0,a0
	move.w	hBatEffects(a0),d0
	bset.l	#1,d0
	move.w	d0,hBatEffects(a0)
	lea		Bat1,a0
	move.w	hBatEffects(a0),d0
	bset.l	#1,d0
	move.w	d0,hBatEffects(a0)
	lea		Bat2,a0
	move.w	hBatEffects(a0),d0
	bset.l	#1,d0
	move.w	d0,hBatEffects(a0)
	lea		Bat3,a0
	move.w	hBatEffects(a0),d0
	bset.l	#1,d0
	move.w	d0,hBatEffects(a0)
	ENDIF
	IFD		ENABLE_DEBUG_PLAYERS
	; move.w	#180*VC_FACTOR,d0 ; bad miss 1 blink
	; move.w	#194*VC_FACTOR,d1
	; move.w	#179*VC_FACTOR,d0 ; bad miss 1 blink
	; move.w	#194*VC_FACTOR,d1

	move.w	#185*VC_FACTOR,d0
	move.w	#194*VC_FACTOR,d1

	move.w	#INITDEBUGBALLSPEEDX,d2
	move.w	#INITDEBUGBALLSPEEDY,d3
	lea		Ball0,a0
	bsr		OneshotReleaseBall
	ENDIF

	move.b	#STATE_RUNNING,GameState(a5)
	rts

InitDemoGame:
	move.b	#$ff,EnableSfx(a5)		; No sfx when chillin'
	move.b	#10,ChillCount(a5)
	move.l	Player0Enabled,Player0EnabledCopy	; Keep menu choices
	lea		Ball0,a0
	move.l	hPlayerBat(a0),BallOwnerCopy(a5)

	move.l	#Bat2,hPlayerBat(a0)	; Let bat2 be ball-owner.

	; Enable all players, but respect selected controls on menuscreen
	; to be able to check for fire using keyboard or joystick.
	tst.b	Player0Enabled
	bpl		.player1
	move.b	#CONTROL_JOYSTICK,Player0Enabled
.player1
	tst.b	Player1Enabled
	bpl		.player2
	move.b	#CONTROL_JOYSTICK,Player1Enabled
.player2
	tst.b	Player2Enabled
	bpl		.player3
	move.b	#CONTROL_JOYSTICK,Player2Enabled
.player3
	tst.b	Player3Enabled
	bpl		.forceBatDraw
	move.b	#CONTROL_JOYSTICK,Player3Enabled

.forceBatDraw
	lea		Bat0,a0
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)
	lea		Bat1,a0
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)
	lea		Bat2,a0
	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)
	lea		Bat3,a0
	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)

	rts