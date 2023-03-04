FrameTick:      dc.b    0
        even

StartNewGame:
	; Initialize game
	move.b  #INIT_BALLCOUNT,BallsLeft
	move.w	#1,LevelCount
	bsr	ResetScores

	move.l	COPPTR_GAME,a1

	IFEQ	ENABLE_DEBUG_GAMECOPPER
	bsr	LoadCopper
	ELSE
	bsr 	LoadDebugCopperlist
.l	bra	.l
	ENDC
	
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

	WAITFRAME

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC

	bsr	PlayerUpdates
	bsr	CheckBallRelease
	bsr	BallUpdates
	bsr	ScoreUpdates

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC

	bsr	CheckCollisions
	
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$55f,$dff180
	ENDC

	bsr	DrawSprites

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$00f,$dff180
	ENDC

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
	bsr	ProcessAddBrickQueue

.oddFrame
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

	; bsr	WaitLastLine
	; move.w	#$f00,$dff180


	bra	.gameLoop
	
.gameOver
	bsr	ClearGameScreenPlayerBobs
	bsr	ClearActivePowerupEffects
	bsr	InitPlayerBobs
	bsr	ResetBricks
	bsr	OptimizeCopperlist
	bsr	ResetBrickQueues

	bsr	ClearPowerup		; Disarm sprites
	bsr	DisarmAllSprites

.stopAudio
	bsr 	StopAudio		; Just in case any sfx is being played
	move.l	HDL_MUSICMOD_2,a0
        bsr	PlayTune

.gameOverLoop
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.gameOverLoop

	move.l	#50,d7
.loop:
	WAITFRAME
        bsr	WaitLastLine
	dbf	d7,.loop

	bsr 	StopAudio

        rts


TransitionToNextLevel:
	; TODO Fancy transition to next level
	bsr	ClearGameScreenPlayerBobs
	bsr	ResetPlayers
	bsr     InitPlayerBobs
	bsr	InitialBlitPlayers
	bsr	ResetBall0
	bsr	ResetDropClock
	bsr	GenerateBricks
	bsr	OptimizeCopperlist
	bsr	ResetBrickQueues
	bsr	AddBricksToQueue
	bsr	ProcessAddBrickQueue	; Need at least 1 brick or the gameloop moves to next level
	bsr	DrawClockMinutes
	bsr	DrawClockSeconds
	bsr	DrawLevelCounter
	bsr	ClearPowerup
	bsr	ClearActivePowerupEffects

	rts