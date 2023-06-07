	section	GameData, data_p

	include 's/brick.dat'
	include 's/brickdrop.dat'
	include 's/powerup.dat'
	include	's/shop.dat'
	include	's/enemies.dat'
	include	's/hiscore.dat'

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

FrameTick:      dc.b    0
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

;---------------------------------
; - This is the frame loop      
;=================================
.gameLoop
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .checkGameOver
        move.b  #0,FrameTick
	bsr	BrickDropCountDown
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$fff,$dff180
	ENDC

.checkGameOver
	tst.b	BallsLeft
	beq	.gameOver
	tst.b	KEYARRAY+KEY_ESCAPE	; ESC -> end game
	bne	.gameOver

	; WAITLASTLINE d0

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC

	bsr	PlayerUpdates
	bsr	BallUpdates
	bsr	EnemyUpdates

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC

	bsr	CheckCollisions
	
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$55f,$dff180
	ENDC

	WAITLASTLINE d0
	bsr	DrawSprites
	bsr	ClearBobs
	bsr	DrawBobs

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
	beq.s	.oddFrame
	tst.b	IsDroppingBricks
	bge.s	.oddFrame
	bsr	ProcessAddBrickQueue

.oddFrame
	bsr	ShopUpdates
	bsr	ScoreUpdates
	bsr	BrickAnim
	move.l	DirtyRowQueuePtr,a0
	cmpa.l	#DirtyRowQueue,a0		; Is queue empty?
	beq.s	.checkLevelDone
	bsr	ProcessDirtyRowQueue

.checkLevelDone

	IFGT	ENABLE_DEBUG_BRICKS
	; bsr	CheckRemoveDebugBrick
	ENDIF

	tst.w	BricksLeft
	bne.s	.stayOnSameLevel

	addi.w	#1,LevelCount
	bsr	TransitionToNextLevel

.stayOnSameLevel
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$000,$dff180
	ENDC

	; move.w	#$f00,$dff180

	bra	.gameLoop
	
.gameOver
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

TransitionToNextLevel:
	; TODO Fancy transition to next level
	bsr	ClearGameArea
	bsr	RestorePlayerAreas
	bsr	ResetPlayers
	bsr     InitPlayerBobs
	bsr	InitialBlitPlayers
	bsr	ResetBalls
	bsr	MoveBall0ToOwner
	bsr	ResetDropClock
	bsr	ResetBrickQueues
	bsr	ClearPowerup
	bsr	ClearActivePowerupEffects

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

	rts