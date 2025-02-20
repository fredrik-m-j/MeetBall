; Ball logic

	include	'common.asm'

InitBalls:
	; Generic ball bob
	move.l	BobsBitmapbasePtr(a5),d0
	addi.l	#28,d0
	move.l	d0,d1
	addi.l	#RL_SIZE*(7+5)*4,d1

	lea		GenericBallBob,a0
	move.l	d0,hAddress(a0)
	move.l	d1,hSprBobMaskAddress(a0)

	; Set Ball0
	lea		AllBalls+hAllBallsBall0,a1
	lea		Ball0,a0
	move.l	a0,(a1)

	; ... and sprite pointers
	move.l	Copper_SPR0PTL(a5),hSpritePtr(a0)
	lea		Ball3,a0
	move.l	Copper_SPR1PTL(a5),hSpritePtr(a0)
	lea		Ball1,a0
	move.l	Copper_SPR2PTL(a5),hSpritePtr(a0)
	lea		Ball4,a0
	move.l	Copper_SPR3PTL(a5),hSpritePtr(a0)
	lea		Ball2,a0
	move.l	Copper_SPR4PTL(a5),hSpritePtr(a0)
	lea		Ball5,a0
	move.l	Copper_SPR5PTL(a5),hSpritePtr(a0)
	lea		Ball6,a0
	move.l	Copper_SPR6PTL(a5),hSpritePtr(a0)
	lea		Ball7,a0
	move.l	Copper_SPR7PTL(a5),hSpritePtr(a0)

	rts

; In:	a6 = address to CUSTOM $dff000
BallUpdates:
	lea		AllBalls,a1
	move.l	(a1)+,d7				; a1 = hAllBallsBall0

	move.l	d7,d6
	moveq	#0,d3
	move.b	#-1,BallsMovingFlag(a5)

.ballLoop
	move.l	(a1)+,a0
	tst.l	hSprBobXCurrentSpeed(a0)	; Stationary or glued?
	beq.w	.doneBall

	move.b	#0,BallsMovingFlag(a5)	; Ball(s) moving flag

	tst.b	GameTick(a5)
	bne.s	.update

	; Ball(s) are in motion but softlock-timer has run out
	add.w   #1*VC_FACTOR,hSprBobTopLeftXPos(a0)    ; Prevent soft-lock by moving ball a bit
	add.w   #2*VC_FACTOR,hSprBobTopLeftYPos(a0)
	add.w   #1*VC_FACTOR,hSprBobBottomRightXPos(a0)
	add.w   #2*VC_FACTOR,hSprBobBottomRightYPos(a0)
	move.b	#SOFTLOCK_FRAMES,GameTick(a5)	; Reset soft-lock timer
.update
; TopLeft
	move.w  hSprBobTopLeftXPos(a0),d0
	move.w  hSprBobTopLeftYPos(a0),d1
	add.w   hSprBobXCurrentSpeed(a0),d0     ; Update ball coordinates
	add.w   hSprBobYCurrentSpeed(a0),d1
	move.w  d0,hSprBobTopLeftXPos(a0)       ; Set the new coordinate values
	move.w  d1,hSprBobTopLeftYPos(a0)
; BottomRight
	add.w   #BALL_DIAMETER*VC_FACTOR,d0
	add.w   #BALL_DIAMETER*VC_FACTOR,d1
	move.w  d0,hSprBobBottomRightXPos(a0)   ; Set the new coordinate values
	move.w  d1,hSprBobBottomRightYPos(a0)

	; Ball moved off-screen?
	cmp.w   #DISP_WIDTH*VC_FACTOR+BALL_DIAMETER*VC_FACTOR,d0
	bhs		.lostBall
	cmp.w   #-BALL_DIAMETER*VC_FACTOR,d0
	ble		.lostBall
	cmp.w   #DISP_HEIGHT*VC_FACTOR+BALL_DIAMETER*VC_FACTOR,d1
	bhs		.lostBall
	cmp.w   #-BALL_DIAMETER*VC_FACTOR,hSprBobBottomRightYPos(a0)
	ble		.lostBall

	bra		.doneBall

.lostBall
	cmp.l	AllBalls,d3				; Lost all balls on GAMEAREA?
	beq		.subBallsLeft
	
	addq.b	#1,d3
	bsr		ResetBallStruct			; Reset sprite
	move.l	hAddress(a0),a2
	clr.l	hVStart(a2)				; Disarm sprite
	clr.l	-4(a1)					; Remove from AllBalls
	bra		.doneBall

.subBallsLeft
	subq.b	#1,BallsLeft(a5)
	move.l	hPlayerBat(a0),d0		; Let "ballowner" have next serve

	move.w	#SOFTLOCK_FRAMES<<8+ANTIBOREDOM_SEC,GameTick(a5)	; Reset soft-lock + boredom counters
	bsr		ResetBalls
	bsr		RestorePlayerAreas
	bsr		ClearProtectiveTiles
	bsr		ResetPlayers
	bsr		MoveBall0ToOwner
	bsr		DrawAvailableBalls
	bsr		ClearPowerup
	bsr		ClearActivePowerupEffects
	bsr		InitPlayerBobs
	bsr		InitialBlitPlayers
	bsr		ClearKeyboardFire
	bsr		AwaitAllFirebuttonsReleased
	bra		.exit

.doneBall
	dbf		d7,.ballLoop

	tst.b	BallspeedTick(a5)		; Update speed?
	bne.s	.compactBallList

	move.b  BallspeedFrameCount(a5),BallspeedTick(a5)

	tst.b	BallsMovingFlag(a5)		; Any ball(s) moving?
	bne.s	.compactBallList
	bsr		IncreaseBallspeed

.compactBallList
	tst.b	d3						; Any lost extra balls?
	beq.s	.exit

	moveq	#8-1,d7					; TODO: Dynamic number of extra balls?
	move.l  #AllBalls+hAllBallsBall0,a0
	move.l  #AllBalls+hAllBallsBall1,a1
.compactLoop	    ; Compact the extra ball list
	move.l	(a1)+,d0

	tst.l	(a0)
	beq.s	.tryMove
	bne.s	.next
.tryMove
	tst.l	d0
	beq.s	.skip
	move.l	d0,(a0)
	clr.l	-4(a1)
.next
	addq.l	#4,a0
.skip
	dbf		d7,.compactLoop

	sub.b	d3,d6
	move.l	d6,AllBalls				; Update number of active balls

	tst.b	InsanoState(a5)
	bmi		.exit

	cmp.b	#2,d6
	bhi		.exit

	bsr		ReassignAndEndInsanoBallz

.exit
	rts


; Whatever balls are left from InsaonoBallz goes into Ball0-2 stucts.
; This might include disarming some of ballsprites 3-7.
ReassignAndEndInsanoBallz:
	movem.l	a2/a3,-(sp)

	lea		AllBalls+hAllBallsBall0,a3
	moveq	#2,d1
.l
	move.l	(a3)+,d0				; Slot empty?
	beq		.insanoOff

	cmp.l	#Ball0,d0				; Is slot occupied by ball 3-7?
	beq		.setColor
	cmp.l	#Ball1,d0
	beq		.setColor
	cmp.l	#Ball2,d0
	beq		.setColor

	lea		Ball0,a0	
	move.l	Ball0,a2				; Find available multiball - check sprite pointer
	tst.l	(a2)
	beq		.checkAvailableBall
	lea		Ball1,a0
	move.l	(a0),a2
	tst.l	(a2)
	beq		.checkAvailableBall
	lea		Ball2,a0
	move.l	(a0),a2
	tst.l	(a2)
	beq		.checkAvailableBall

	sub.l	a0,a0

.checkAvailableBall
	cmpa.l	#0,a0					; None available?
	beq		.insanoOff				; Should not happen

	move.l	a0,-4(a3)				; Set ballstruct address in AllBalls
	
	move.l	d0,a2					; Source
	move.l	a0,d0					; Keep destination
	REASGNBL	a2,a0
	move.l	hAddress(a0),a0			; Arm sprite -> this ball is non-available in next loop iterations
	move.l	hAddress(a2),a2
	move.l	(a2),(a0)
	clr.l	(a2)					; Disarm source sprite
.setColor
	move.l	d0,a0
	move.l	hPlayerBat(a0),a1
	bsr		SetBallColor

	dbf		d1,.l

.insanoOff
	move.b  #INSANOSTATE_INACTIVE,InsanoState(a5)

	movem.l	(sp)+,a2/a3
	rts      

; Checks and returns first ball whose sprite is disarmed (from Ball0-Ball2).
; Out:  a0 = unused multiball or $0
GetAvailableMultiball:
	lea		Ball0,a0
	move.l	(a0),a2
	tst.l	(a2)
	beq		.exit

	lea		Ball1,a0
	move.l	(a0),a2
	tst.l	(a2)
	beq		.exit

	lea		Ball2,a0
	move.l	(a0),a2
	tst.l	(a2)
	beq		.exit

	sub.l	a0,a0
.exit
	rts

; Used for resolving inconclusive collision detection.
; Moves ball back 1/8 th towards the coordinates (where ball was in previous frame).
; In:   a2 = address to ball structure
MoveBallBack:
	move.l	d2,-(sp)

	; X values
	move.w  hSprBobTopLeftXPos(a2),d0
	move.w  hSprBobBottomRightXPos(a2),d1

	move.w  hSprBobXCurrentSpeed(a2),d2
	bpl.s	.positiveX

	neg.w	d2
	lsr.w	#3,d2
	add.w	d2,d0
	add.w	d2,d1
	bra.s	.setX
.positiveX
	lsr.w	#3,d2
	sub.w	d2,d0
	sub.w	d2,d1
.setX
	move.w  d0,hSprBobTopLeftXPos(a2)
	move.w  d1,hSprBobBottomRightXPos(a2)

	; Y values
	move.w  hSprBobTopLeftYPos(a2),d0
	move.w  hSprBobBottomRightYPos(a2),d1

	move.w  hSprBobYCurrentSpeed(a2),d2
	bpl.s	.positiveY

	neg.w	d2
	lsr.w	#3,d2
	add.w	d2,d0
	add.w	d2,d1
	bra.s	.setY
.positiveY
	lsr.w	#3,d2

	sub.w	d2,d0
	sub.w	d2,d1
.setY
	move.w  d0,hSprBobTopLeftYPos(a2)
	move.w  d1,hSprBobBottomRightYPos(a2)

	move.l	(sp)+,d2
	rts

ResetBalls:
	clr.l	Spr_Ball1				; Disarm other balls
	clr.l	Spr_Ball2
	clr.l	Spr_Ball3
	clr.l	Spr_Ball4
	clr.l	Spr_Ball5
	clr.l	Spr_Ball6
	clr.l	Spr_Ball7
	
	lea		Ball0,a0
	bsr		ResetBallStruct
	lea		Ball1,a0
	bsr		ResetBallStruct
	lea		Ball2,a0
	bsr		ResetBallStruct
	lea		Ball3,a0
	bsr		ResetBallStruct
	lea		Ball4,a0
	bsr		ResetBallStruct
	lea		Ball5,a0
	bsr		ResetBallStruct
	lea		Ball6,a0
	bsr		ResetBallStruct
	lea		Ball7,a0
	bsr		ResetBallStruct

.resetBallList
	lea		AllBalls,a0
	clr.l	(a0)+
	move.l	#Ball0,(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)

	lea		Ball0,a0				; Reset Ball0
	tst.l	hPlayerBat(a0)
	bne.s	.setBallColor

.findBallOwner
	lea		Ball1,a1
	move.l	hPlayerBat(a1),d0
	beq.s	.ball2

	move.l	d0,hPlayerBat(a0)		; Set ballowner for Ball0
	bra.s	.setBallColor
.ball2
	lea		Ball2,a1
	move.l  hPlayerBat(a1),hPlayerBat(a0)   ; Set ballowner for Ball0

.setBallColor
	move.l	hPlayerBat(a0),a1
	bsr		SetBallColor

	bsr		ResetBallspeeds

	rts

; Resets animated balls etc.
; In:	a0 = adress to ball struct
ResetBallStruct:
	cmpa.l	#Ball0,a0
	bne.s	.ball1
	move.l	#Spr_Ball0,Ball0
	bra		.continue
.ball1
	cmpa.l	#Ball1,a0
	bne.s	.ball2
	move.l	#Spr_Ball1,Ball1
	bra.s	.continue
.ball2
	cmpa.l	#Ball2,a0
	bne.s	.ball3
	move.l	#Spr_Ball2,Ball2
	bra.s	.continue
.ball3
	cmpa.l	#Ball3,a0
	bne.s	.ball4
	move.l	#Spr_Ball3,Ball3
	bra.s	.continue
.ball4
	cmpa.l	#Ball4,a0
	bne.s	.ball5
	move.l	#Spr_Ball4,Ball4
	bra.s	.continue
.ball5
	cmpa.l	#Ball5,a0
	bne.s	.ball6
	move.l	#Spr_Ball5,Ball5
	bra.s	.continue
.ball6
	cmpa.l	#Ball6,a0
	bne.s	.ball7
	move.l	#Spr_Ball6,Ball6
	bra.s	.continue
.ball7
	move.l	#Spr_Ball7,Ball7

.continue
	move.b	#-1,hIndex(a0)			; Animation OFF
	clr.l	hSprBobXCurrentSpeed(a0)	; Clear both X & Y speeds
	clr.w	hBallSpeedLevel(a0)
	clr.w	hBallEffects(a0)

	move.l	hSpritePtr(a0),a2

	move.l	hAddress(a0),d1
	move.w	d1,(a2)					; New sprite pointers
	swap	d1
	move.w	d1,4(a2)

	rts

; Override/set sprite colors
; In:	a0 = adress to ball
; In:	a1 = adress to bat that has accent colors
SetBallColor:
	move.l	a6,-(sp)

	cmpa.l	#Ball0,a0
	bne.s	.b1

	lea		CUSTOM+COLOR17,a6
	bra.s	.setColor
.b1
	cmpa.l	#Ball1,a0
	bne.s	.b2

	lea		CUSTOM+COLOR21,a6
	bra.s	.setColor
.b2
	lea		CUSTOM+COLOR25,a6

.setColor
	move.w  hSprBobAccentCol1(a1),(a6)+
	move.w  hSprBobAccentCol2(a1),(a6)+
	move.w	#$eee,(a6)

	move.l	(sp)+,a6
	rts

; Sets accent color on all balls given the bat/ballowner.
; In:	a1 = adress to bat
Set3BallColor:
	lea		CUSTOM+COLOR17,a6
	move.w  hSprBobAccentCol1(a1),(a6)+
	move.w  hSprBobAccentCol2(a1),(a6)+
	move.w	#$eee,(a6)
	lea		CUSTOM+COLOR21,a6
	move.w  hSprBobAccentCol1(a1),(a6)+
	move.w  hSprBobAccentCol2(a1),(a6)+
	move.w	#$eee,(a6)
	lea		CUSTOM+COLOR25,a6
	move.w  hSprBobAccentCol1(a1),(a6)+
	move.w  hSprBobAccentCol2(a1),(a6)+
	move.w	#$eee,(a6)

	rts

; Draws the balls that are available to player(s) of this game.
; In:	a6 = address to CUSTOM $dff000
DrawAvailableBalls:
	movem.l	d2/d7/a3-a4,-(sp)

	move.l 	GAMESCREEN_PristinePtr(a5),a0       ; Clear balls
	add.l	#(RL_SIZE*10*4),a0
	move.l	GAMESCREEN_Ptr(a5),a1
	add.l	#(RL_SIZE*10*4),a1
	moveq	#RL_SIZE-10,d1
	move.w	#(64*7*4)+5,d2
	bsr		CopyRestoreGamearea


	lea		GAMEAREA,a0				; Terrible! Redraw default top left wall - was just overwritten
	moveq	#41+1,d0
	moveq	#1,d2
	WAITBLIT
	bsr		VerticalFillPlayerArea

	moveq	#0,d7					; (dbf is word-sized)
	move.b	BallsLeft(a5),d7
	subq.b	#2,d7					; Any spares left?
	bmi		.skip

	move.l	GAMESCREEN_Ptr(a5),a4	; Blit spares
	movea.l	a4,a2
	lea		GenericBallBob,a3
	move.w  #9,hSprBobTopLeftXPos(a3)
	move.w  #10,hSprBobTopLeftYPos(a3)
.loop
	bsr		CookieBlitToScreen
	add.w	#8,hSprBobTopLeftXPos(a3)
	dbf		d7,.loop


	tst.b	InsanoState(a5)			; Overwrote protective walls?
	bmi		.skip
	cmp.b   #INSANOSTATE_PHAZE101OUT,InsanoState(a5)
	beq		.skip

	moveq	#6-1,d0
.loop2
	move.l	GAMESCREEN_Ptr(a5),a0
	add.l	#(RL_SIZE*8*4)+4,a0
	add.l	d0,a0
	CPUCLR88	a0

	dbf		d0,.loop2

.skip
	move.l	GAMESCREEN_Ptr(a5),a0	; Copy to back
	add.l	#(RL_SIZE*10*4),a0
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l	#(RL_SIZE*10*4),a1
	moveq	#RL_SIZE-10,d1
	move.w	#(64*7*4)+5,d2
	bsr		CopyRestoreGamearea

	movem.l	(sp)+,d2/d7/a3-a4
	rts

ResetBallspeeds:
	move.w	BallspeedBase(a5),d0
	move.w	d0,BallSpeedx1(a5)
	add.w	BallspeedBase(a5),d0
	move.w	d0,BallSpeedx2(a5)
	add.w	BallspeedBase(a5),d0
	move.w	d0,BallSpeedx3(a5)
	rts

; Increases current speed of all balls.
IncreaseBallspeed:
	movem.l	d2/d4/d6,-(sp)

	move.w	BallSpeedx1(a5),d1
	cmp.w	#BALL_MAXSPEED,d1		; Are we getting into buggy territory?
	bhi.s	.resetRampup			; At max - no need to try this as often
	move.w	BallSpeedx2(a5),d2

	lea		AllBalls,a1
	move.l	(a1)+,d6				; a1 = hAllBallsBall0
.ballLoop
	move.l	(a1)+,a0

	move.l  hSprBobXCurrentSpeed(a0),d4
	beq		.doneBall				; Glued?
	bsr		IncreaseBallspeedXY
	
	move.w  d4,hSprBobYCurrentSpeed(a0)
	move.w	d4,hSprBobYSpeed(a0)
	swap	d4
	move.w  d4,hSprBobXCurrentSpeed(a0)
	move.w	d4,hSprBobXSpeed(a0)

.doneBall
	dbf		d6,.ballLoop

	addq.w	#1,BallSpeedx1(a5)
	addq.w	#2,BallSpeedx2(a5)
	addq.w	#3,BallSpeedx3(a5)
	bra		.exit

.resetRampup
	move.b  BallspeedFrameCountCopy(a5),BallspeedFrameCount(a5)
.exit
	movem.l	(sp)+,d2/d4/d6
	rts

; Decreases current speed of all balls.
DecreaseBallspeed:
	movem.l	d1/d2,-(sp)

	move.w	BallSpeedx1(a5),d1
	cmp.w	#MIN_BALLSPEED,d1
	blo.s	.exit
	move.w	BallSpeedx2(a5),d2

	lea		AllBalls,a1
	move.l	(a1)+,d6				; a1 = hAllBallsBall0
.ballLoop
	move.l	(a1)+,a0

	move.w  hSprBobXCurrentSpeed(a0),d4
	beq		.decY					; Glued?
	bsr		DecreaseBallspeedXY
	move.w  d4,hSprBobXCurrentSpeed(a0)
	move.w	d4,hSprBobXSpeed(a0)
.decY
	move.w  hSprBobYCurrentSpeed(a0),d4
	beq		.doneBall				; Glued?
	bsr		DecreaseBallspeedXY
	move.w  d4,hSprBobYCurrentSpeed(a0)
	move.w	d4,hSprBobYSpeed(a0)
.doneBall
	dbf		d6,.ballLoop

	subq.w	#3,BallSpeedx1(a5)
	subq.w	#6,BallSpeedx2(a5)
	sub.w	#9,BallSpeedx3(a5)
.exit
	movem.l	(sp)+,d1/d2
	rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.l = X.w and Y.w speeds
; Out:	d4.l = Updated values for X and Y speeds
IncreaseBallspeedXY:
	moveq	#-1,d0
.start
	tst.w	d4
	bmi.s	.negative

	cmp.w	d4,d1
	bne		.tryPos2
	addq.w	#1,d4
	bra		.done
.tryPos2
	cmp.w	d4,d2
	bne		.doPos3
	addq.w	#2,d4
	bra		.done
.doPos3
	addq.w	#3,d4
	bra		.done

.negative
	neg.w	d4

	cmp.w	d4,d1
	bne		.try2
	addq.w	#1,d4
	bra		.doneNeg
.try2
	cmp.w	d4,d2
	bne		.do3
	addq.w	#2,d4
	bra		.doneNeg
.do3
	addq.w	#3,d4
.doneNeg

	neg.w	d4
.done
	
	swap	d4

	tst.b	d0
	beq		.doneDone
	clr.b	d0
	bra		.start

.doneDone
	rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.w = X or Y speed
; Out:	d4.w = Updated value for X or Y speed
DecreaseBallspeedXY:
	tst.w	d4
	bmi.s	.negative

	bsr		GetDecreasedSpeedXY
	bra.s	.done
.negative
	neg.w	d4
	bsr		GetDecreasedSpeedXY
	neg.w	d4
.done
	rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.w = X or Y speed
; Out:	d4.w = Updated value for X or Y speed
GetDecreasedSpeedXY:
	cmp.w	d4,d1
	bne.s	.try2
	subq.w	#3,d4
	bra.s	.done
.try2
	cmp.w	d4,d2
	bne.s	.do3
	subq.w	#6,d4
	bra.s	.done
.do3
	sub.w	#9,d4
.done
	rts


MoveBall0ToOwner:
	lea		Ball0,a0
	move.l	hPlayerBat(a0),a1

	cmpa.l	#Bat0,a1
	bne.s	.bat1

	move.w  BallSpeedx3(a5),hSprBobXSpeed(a0)	; Set speed, awaiting release
	neg.w	hSprBobXSpeed(a0)
	move.w	BallSpeedx1(a5),hSprBobYSpeed(a0)
	neg.w	hSprBobYSpeed(a0)

	move.w  hSprBobTopLeftXPos(a1),d0
	subq.w	#BALL_DIAMETER,d0
	lsl.w	#VC_POW,d0				; Translate to virtual coords
	move.w  d0,hSprBobTopLeftXPos(a0)
	move.w  hSprBobTopLeftYPos(a1),d1
	addi.w	#$d,d1
	lsl.w	#VC_POW,d1				; Translate to virtual coords
	move.w  d1,hSprBobTopLeftYPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d0
	move.w  d0,hSprBobBottomRightXPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d1
	move.w  d1,hSprBobBottomRightYPos(a0)

.bat1
	cmpa.l	#Bat1,a1
	bne.s	.bat2

	move.w	BallSpeedx3(a5),hSprBobXSpeed(a0)	; Set speed, awaiting release
	move.w	BallSpeedx1(a5),hSprBobYSpeed(a0)

	move.w  hSprBobBottomRightXPos(a1),d0
	lsl.w	#VC_POW,d0				; Translate to virtual coords
	move.w  d0,hSprBobTopLeftXPos(a0)
	move.w  hSprBobTopLeftYPos(a1),d1
	addi.w	#$f,d1
	lsl.w	#VC_POW,d1				; Translate to virtual coords
	move.w  d1,hSprBobTopLeftYPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d0
	move.w  d0,hSprBobBottomRightXPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d1
	move.w  d1,hSprBobBottomRightYPos(a0)
.bat2
	cmpa.l	#Bat2,a1
	bne.s	.bat3

	move.w	BallSpeedx1(a5),hSprBobXSpeed(a0)	; Set speed, awaiting release
	move.w	BallSpeedx3(a5),hSprBobYSpeed(a0)
	neg.w	hSprBobYSpeed(a0)

	move.w  hSprBobTopLeftXPos(a1),d0
	move.w	hSprBobWidth(a1),d1
	lsr.w	d1
	add.w	d1,d0
	lsl.w	#VC_POW,d0				; Translate to virtual coords
	move.w  d0,hSprBobTopLeftXPos(a0)
	move.w  hSprBobTopLeftYPos(a1),d1
	subq.w	#BALL_DIAMETER,d1
	lsl.w	#VC_POW,d1				; Translate to virtual coords
	move.w  d1,hSprBobTopLeftYPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d0
	move.w  d0,hSprBobBottomRightXPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d1
	move.w  d1,hSprBobBottomRightYPos(a0)
.bat3
	cmpa.l	#Bat3,a1
	bne.s	.exit

	move.w	BallSpeedx1(a5),hSprBobXSpeed(a0)   ; Set speed, awaiting release
	neg.w	hSprBobXSpeed(a0)
	move.w	BallSpeedx3(a5),hSprBobYSpeed(a0)

	move.w  hSprBobTopLeftXPos(a1),d0
	move.w	hSprBobWidth(a1),d1
	lsr.w	d1
	add.w	d1,d0
	subq.w	#6,d0					; Adjust relative ball position
	lsl.w	#VC_POW,d0				; Translate to virtual coords
	move.w  d0,hSprBobTopLeftXPos(a0)
	move.w  hSprBobBottomRightYPos(a1),d1
	lsl.w	#VC_POW,d1				; Translate to virtual coords
	move.w  d1,hSprBobTopLeftYPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d0
	move.w  d0,hSprBobBottomRightXPos(a0)
	add.w   #BALL_DIAMETER*VC_FACTOR,d1
	move.w  d1,hSprBobBottomRightYPos(a0)
.exit
	clr.b	Paused(a5)

	rts


Insanoballz:
	tst.b	InsanoState(a5)
	bne		.insano

	; Check if ball is too close to borders (possibly leading to ball-trapped-in-wall)

	; bsr     IsBallNearScreenEdge
	; tst.b   d0
	; beq     .exit

	bsr		DecreaseBallspeed

	move.w	BallSpeedx1(a5),d1
	cmp.w	#MIN_BALLSPEED,d1
	bhi		.exit

	; Reached min ball speed - set neutral ball color for all sprites
	lea		CUSTOM+COLOR17,a6
	move.w	#$444,(a6)+
	move.w	#$999,(a6)+
	move.w	#$fff,(a6)
	lea		CUSTOM+COLOR21,a6
	move.w	#$444,(a6)+
	move.w	#$999,(a6)+
	move.w	#$fff,(a6)
	lea		CUSTOM+COLOR25,a6
	move.w	#$444,(a6)+
	move.w	#$999,(a6)+
	move.w	#$fff,(a6)
	lea		CUSTOM+COLOR29,a6 
	move.w	#$444,(a6)+
	move.w	#$999,(a6)+
	move.w	#$fff,(a6)

	move.l  AllBalls+hAllBallsBall0,a2

	cmpa.l	#Ball0,a2
	beq		.populateAllBalls

	; Reassign active ball to Ball0
	lea		Ball0,a0
	REASGNBL	a2,a0

.populateAllBalls
	; Add more balls
	lea		Ball0,a0
	lea		Ball1,a1
	lea		Ball2,a2
	lea		Ball3,a3

	lea		AllBalls,a6
	move.l	#8-1,hAllBallsActive(a6)
	move.l	a0,hAllBallsBall0(a6)
	move.l	a1,hAllBallsBall1(a6)
	move.l	a2,hAllBallsBall2(a6)
	move.l	a3,hAllBallsBall3(a6)
	move.l  #Ball4,hAllBallsBall4(a6)
	move.l  #Ball5,hAllBallsBall5(a6)
	move.l  #Ball6,hAllBallsBall6(a6)
	move.l  #Ball7,hAllBallsBall7(a6)

	move.l	a0,a6					; Copy Ball0

	move.l	hPlayerBat(a6),d0
	move.l	d0,hPlayerBat(a0)		; Set ballowner
	move.l	d0,hPlayerBat(a1)
	move.l	d0,hPlayerBat(a2)
	move.l	d0,hPlayerBat(a3)
	lea		Ball4,a0
	lea		Ball5,a1
	lea		Ball6,a2
	lea		Ball7,a3
	move.l	d0,hPlayerBat(a0)
	move.l	d0,hPlayerBat(a1)
	move.l	d0,hPlayerBat(a2)
	move.l	d0,hPlayerBat(a3)

	; Make all extra balls start from the position of the original one
	move.l	hSprBobTopLeftXPos(a6),d1	; Copy Top X,Y position of active ball
	move.l	d1,hSprBobTopLeftXPos(a0)
	move.l	d1,hSprBobTopLeftXPos(a1)
	move.l	d1,hSprBobTopLeftXPos(a2)
	move.l	d1,hSprBobTopLeftXPos(a3)
	move.l	hSprBobBottomRightXPos(a6),d1	; Copy Bottom X,Y position
	move.l	d1,hSprBobBottomRightXPos(a0)
	move.l	d1,hSprBobBottomRightXPos(a1)
	move.l	d1,hSprBobBottomRightXPos(a2)
	move.l	d1,hSprBobBottomRightXPos(a3)
	lea		Ball0,a0
	lea		Ball1,a1
	lea		Ball2,a2
	lea		Ball3,a3
	move.l	hSprBobTopLeftXPos(a6),d1	; Copy Top X,Y position of active ball
	move.l	d1,hSprBobTopLeftXPos(a0)
	move.l	d1,hSprBobTopLeftXPos(a1)
	move.l	d1,hSprBobTopLeftXPos(a2)
	move.l	d1,hSprBobTopLeftXPos(a3)
	move.l	hSprBobBottomRightXPos(a6),d1	; Copy Bottom X,Y position
	move.l	d1,hSprBobBottomRightXPos(a0)
	move.l	d1,hSprBobBottomRightXPos(a1)
	move.l	d1,hSprBobBottomRightXPos(a2)
	move.l	d1,hSprBobBottomRightXPos(a3)

	; Let all balls move in all possible directions
	move.w	BallSpeedx1(a5),d1
	move.w	BallSpeedx2(a5),d2
	move.w	BallSpeedx3(a5),d3
	move.w	d1,d4
	move.w	d2,d5
	move.w	d3,d6
	neg.w	d4
	neg.w	d5
	neg.w	d6

	move.w  d1,hSprBobXCurrentSpeed(a0)     ; /     A lot upwards to the right
	move.w  d6,hSprBobYCurrentSpeed(a0)
	move.w  d3,hSprBobXCurrentSpeed(a1)     ; -/    Little upwards to the right
	move.w  d4,hSprBobYCurrentSpeed(a1)
	move.w  d3,hSprBobXCurrentSpeed(a2)     ; -\    Little downwards to the right
	move.w  d1,hSprBobYCurrentSpeed(a2)
	move.w  d1,hSprBobXCurrentSpeed(a3)     ; \     A lot downwards to the right
	move.w  d3,hSprBobYCurrentSpeed(a3)
	move.w	d1,hSprBobXSpeed(a0)
	move.w	d6,hSprBobYSpeed(a0)
	move.w	d3,hSprBobXSpeed(a1)
	move.w	d4,hSprBobYSpeed(a1)
	move.w	d3,hSprBobXSpeed(a2)
	move.w	d1,hSprBobYSpeed(a2)
	move.w	d1,hSprBobXSpeed(a3)
	move.w	d3,hSprBobYSpeed(a3)
	lea		Ball4,a0
	lea		Ball5,a1
	lea		Ball6,a2
	lea		Ball7,a3
	move.w  d4,hSprBobXCurrentSpeed(a0)     ; /     A lot downwards to the left
	move.w  d3,hSprBobYCurrentSpeed(a0)
	move.w  d6,hSprBobXCurrentSpeed(a1)     ; /-    Little downwards to the left
	move.w  d1,hSprBobYCurrentSpeed(a1)
	move.w  d6,hSprBobXCurrentSpeed(a2)     ; \-    Little upwards to the left
	move.w  d4,hSprBobYCurrentSpeed(a2)
	move.w  d4,hSprBobXCurrentSpeed(a3)     ; \     A lot upwards to the left
	move.w  d6,hSprBobYCurrentSpeed(a3)
	move.w	d4,hSprBobXSpeed(a0)
	move.w	d3,hSprBobYSpeed(a0)
	move.w	d6,hSprBobXSpeed(a1)
	move.w	d1,hSprBobYSpeed(a1)
	move.w	d6,hSprBobXSpeed(a2)
	move.w	d4,hSprBobYSpeed(a2)
	move.w	d4,hSprBobXSpeed(a3)
	move.w	d6,hSprBobYSpeed(a3)

	move.l	Copper_SPR7PTL(a5),a2	; Set sprite pointers for ball 7
	move.l	#Spr_Ball7,d1
	move.w	d1,(a2)
	swap	d1
	move.w	d1,4(a2)

	; Make balls accellerate quickly up to max
	move.b	#1,BallspeedFrameCount(a5)
	move.b  #INSANOSTATE_RUNNING,InsanoState(a5)
	bra		.exit

.insano
	cmp.b	#INSANOSTATE_RESETTING,InsanoState(a5)
	beq		.resetting

	move.b	#-1,IsDroppingBricks(a5)	; Let previously added bricks drop now
	
	subq.b	#1,InsanoTick(a5)
	bne		.exit

	move.b	#9,InsanoTick(a5)
	subq.b	#1,InsanoDrops(a5)
	beq		.reset

	bsr		AddBricksToQueue
	move.b	#0,IsDroppingBricks(a5)	; Animate drop for a few frames
	move.b	#5,ENEMY_SpawnCount(a5)
	
	bra		.exit

.reset
	move.b	#INSANOSTATE_RESETTING,InsanoState(a5)
.resetting
	bsr		DecreaseBallspeed	

	move.w	BallSpeedx1(a5),d1		; Slowdown to level-start speed
	cmp.w	BallspeedBase(a5),d1
	bhi		.exit

	move.b	#-1,IsDroppingBricks(a5)	; One final drop

	bsr		RemoveProtectiveTiles

	move.b  BallspeedFrameCountCopy(a5),BallspeedFrameCount(a5)
	move.b  #DEFAULT_INSANODROPS,InsanoDrops(a5)
	move.b	#INSANOTICKS,InsanoTick(a5)

	move.b  #INSANOSTATE_PHAZE101OUT,InsanoState(a5)
	move.b	#-1,Paused(a5)			; Unpause

.exit
	rts

; Clears all protective tiles immediately from GAMEAREA.
; Resets tile queue pointers. Sets dirty-row bits for redraw.
ClearProtectiveTiles:
	movem.l	d7,-(sp)

	lea		GAMEAREA,a1

	moveq	#1,d0
	move.w	#1*41+1+4,d1			; Start from 1st row + 4 right
	moveq	#32-1,d7
.removeTopHorizLoop
	clr.b	(a1,d1.w)				; Clear GAMEAREA
	addq.w	#1,d1
	dbf		d7,.removeTopHorizLoop

	moveq	#3,d0
	move.w	#3*41+1+1,d1			; Start from 3rd row +1 right
	moveq	#26-1,d7
.removeVerticalLoop
	clr.b	(a1,d1.w)				; Clear left tile in GAMEAREA
	add.w	#37,d1					; Right tile
	clr.b	(a1,d1.w)				; Clear right tile in GAMEAREA
	
	addq.w	#1,d0					; Next row
	addq.w	#4,d1
	dbf		d7,.removeVerticalLoop

	moveq	#30,d0
	move.w	#30*41+1+4,d1			; Start from 30th row + 4 right
	moveq	#32-1,d7
.removeBottomHorizLoop
	clr.b	(a1,d1.w)				; Clear GAMEAREA
	addq.w	#1,d1
	dbf		d7,.removeBottomHorizLoop

	move.l	(sp)+,d7
	rts

; Puts all protective tiles in queue to be removed.
RemoveProtectiveTiles:
	move.l	RemoveTileQueuePtr(a5),a0

	moveq	#1,d2
	move.w	#1*41+1+4,d1			; Start from 1st row + 4 right
	moveq	#32-1,d7
.removeTopHorizLoop
	move.w	d2,(a0)+				; Row
	move.w	d1,(a0)+				; Position in GAMEAREA
	addq.w	#1,d1
	dbf		d7,.removeTopHorizLoop

	moveq	#3,d2
	move.w	#3*41+1+1,d1			; Start from 3rd row +1 right
	moveq	#26-1,d7
.removeVerticalLoop
	; Left tile
	move.w	d2,(a0)+				; Row
	move.w	d1,(a0)+				; Position in GAMEAREA

	add.w	#37,d1					; Right tile
	move.w	d2,(a0)+				; Row
	move.w	d1,(a0)+				; Position in GAMEAREA
	
	addq.w	#1,d2					; Next row
	addq.w	#4,d1
	dbf		d7,.removeVerticalLoop

	moveq	#30,d2
	move.w	#30*41+1+4,d1			; Start from 30th row + 4 right
	moveq	#32-1,d7
.removeBottomHorizLoop
	move.w	d2,(a0)+				; Row
	move.w	d1,(a0)+				; Position in GAMEAREA
	addq.w	#1,d1
	dbf		d7,.removeBottomHorizLoop

	move.l	a0,RemoveTileQueuePtr(a5)	; Update pointer

	rts

; Checks if ball is near screen edge (~45 pixels - disregarding center of ball).
; In:	a2 = Address to a ball to be tested
; Out:	d0.b = 0 if near, -1 if not near screen edge.
IsBallNearScreenEdge:
	move.l	hSprBobTopLeftXPos(a2),d0
	cmp.w   #(DISP_HEIGHT-45)*VC_FACTOR,d0  ; Too close to bottom?
	bhi		.true
	cmp.w	#45*VC_FACTOR,d0		; Too close to top?
	blo		.true
	swap	d0
	cmp.w   #(DISP_WIDTH-45)*VC_FACTOR,d0   ; Too close to right?
	bhi		.true
	cmp.w	#45*VC_FACTOR,d0		; Too close to left?
	blo		.true

	move.b	#-1,d0
	rts
.true    
	move.b	#0,d0
	rts