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

	bsr	SetGenericBallBob		; This need to be set once - ever
	bsr	DrawAvailableBalls

	bsr	TransitionToNextLevel

	; BALL SPEED DEBUG
	; lea	Ball0,a0
	; move.w  BallSpeedLevel369,hBallXCurrentSpeed(a0)
	; neg.w	hBallXCurrentSpeed(a0)				; Ball moves away from bat
	; move.w  BallSpeedLevel123,hBallYCurrentSpeed(a0)
	; neg.w	hBallYCurrentSpeed(a0)
	; move.b	#$ff,BallZeroOnBat

	; bsr	IncreaseBallSpeedLevel

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


	; bra	.gameLoop



	move.b	FrameTick,d0		; Don't drop bricks every frame
	; and.b	#15,d0
	and.b	#1,d0
	bne.s	.checkLevelDone

	move.l	BrickQueuePtr,a0
	cmpa.l	#BrickQueue,a0		; Is queue empty?
	beq.s	.checkLevelDone
	bsr	ProcessBrickQueue

.checkLevelDone

; 	IFGT	ENABLE_DEBUG_BRICKS
; 	move.b	FrameTick,d0		; Don't remove bricks every frame
; 	and.b	#1,d0
; 	bne.s	.x

; 	move.l	BrickQueuePtr,a0
; 	cmpa.l	#BrickQueue,a0		; Is queue empty?
; 	bne.s	.x
; 	bsr	RemoveBrick
; .x
; 	ENDIF

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
	bsr	ResetBricks
	bsr	ResetBrickQueue

        move.l	#0,Spr_Bat0		; Disarm sprites
        move.l	#0,Spr_Bat1
        move.l	#0,Spr_Ball0

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
	bsr	ResetPlayers
	bsr	ResetBalls
	bsr	ResetDropClock
	bsr	GenerateBricks
	bsr	AddBricksToQueue
	bsr	ProcessBrickQueue	; Need at least 1 brick or the gameloop moves to next level
	bsr	DrawClockMinutes
	bsr	DrawClockSeconds
	bsr	DrawGameLevel

	rts