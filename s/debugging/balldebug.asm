ENEMYCOLLISIONCOUNT		=	35
BALLCOLLISIONFRAMECOUNT	=	30

	IFD		ENABLE_DEBUG_PLAYERS
INITDEBUGBALLSTARTX		=	200*VC_FACTOR	; 6,2 - negative X & Y ballspeeds
INITDEBUGBALLSTARTY		=	230*VC_FACTOR
INITDEBUGBALLSPEEDX		=	-2*DEFAULT_BALLSPEED
INITDEBUGBALLSPEEDY		=	-2*DEFAULT_BALLSPEED
	ENDIF

	IFD		ENABLE_TESTCASES
	; Testcase: Start insanoballz when ball travel toward top of screen
; INITDEBUGBALLSTARTX	=	200*VC_FACTOR		; 2,6 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	200*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-6*DEFAULT_BALLSPEED

	; Testcase: Start insanoballz when ball travel toward top left corner
INITDEBUGBALLSTARTX		=	70*VC_FACTOR	; 2,6 - negative Y ballspeed
INITDEBUGBALLSTARTY		=	100*VC_FACTOR
INITDEBUGBALLSPEEDX		=	-1*DEFAULT_BALLSPEED
INITDEBUGBALLSPEEDY		=	-3*DEFAULT_BALLSPEED

	; Testcase: Bat0 from ABOVE LEFT - increment ball Y to test
; INITDEBUGBALLSTARTX	=	275*VC_FACTOR		; 2,6
; INITDEBUGBALLSTARTY	=	8*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	270*VC_FACTOR		; 4,4
; INITDEBUGBALLSTARTY	=	75*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	250*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	=	95*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	2*DEFAULT_BALLSPEED
	
	; Testcase: Bat0 from BELOW LEFT - increment ball Y to test
; INITDEBUGBALLSTARTX	=	280*VC_FACTOR		; 2,6 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	190*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	270*VC_FACTOR		; 4,4 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	155*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	250*VC_FACTOR		; 6,2 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	135*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-2*DEFAULT_BALLSPEED

	; Testcase: Bat1 from ABOVE LEFT - increment ball X to test
; INITDEBUGBALLSTARTX	=	118*VC_FACTOR		; 2,6
; INITDEBUGBALLSTARTY	=	210*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	80*VC_FACTOR		; 4,4
; INITDEBUGBALLSTARTY	=	200*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	80*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	=	225*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	2*DEFAULT_BALLSPEED

	; Testcase: Bat1 from ABOVE RIGHT - increment ball X to test
; INITDEBUGBALLSTARTX	=	144*VC_FACTOR		; 2,6 - negative X ballspeed
; INITDEBUGBALLSTARTY	=	210*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	177*VC_FACTOR		; 4,4 - negative X ballspeed
; INITDEBUGBALLSTARTY	=	200*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	205*VC_FACTOR		; 6,2 - negative X ballspeed
; INITDEBUGBALLSTARTY	=	220*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	2*DEFAULT_BALLSPEED
	ENDIF

; Testcase: Insanoballz insta-finish level
; INITDEBUGBALLSTARTX	=	140*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	=	80*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	3*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	1*DEFAULT_BALLSPEED

; From ABOVE LEFT
; INITDEBUGBALLSTARTX	=	120*VC_FACTOR		; 2,6
; INITDEBUGBALLSTARTY	=	50*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	75*VC_FACTOR		; 4,4
; INITDEBUGBALLSTARTY	=	50*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	120*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	=	70*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	2*DEFAULT_BALLSPEED

; From ABOVE RIGHT
; INITDEBUGBALLSTARTX	=	155*VC_FACTOR		; 2,6 - negative X ballspeed
; INITDEBUGBALLSTARTY	=	50*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	200*VC_FACTOR		; 4,4 - negative X ballspeed
; INITDEBUGBALLSTARTY	=	35*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	200*VC_FACTOR		; 6,2 - negative X ballspeed
; INITDEBUGBALLSTARTY	=	70*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	2*DEFAULT_BALLSPEED

; From BELOW LEFT
; INITDEBUGBALLSTARTX	=	120*VC_FACTOR		; 2,6 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	155*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	75*VC_FACTOR		; 4,4 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	155*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	120*VC_FACTOR		; 6,2 - negative Y ballspeed
; INITDEBUGBALLSTARTY	=	100*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-2*DEFAULT_BALLSPEED

; From BELOW RIGHT
; INITDEBUGBALLSTARTX	=	160*VC_FACTOR		; 2,6 - negative X & Y ballspeeds
; INITDEBUGBALLSTARTY	=	175*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	200*VC_FACTOR		; 4,4 - negative X & Y ballspeeds
; INITDEBUGBALLSTARTY	=	175*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	=	200*VC_FACTOR		; 6,2 - negative X & Y ballspeeds
; INITDEBUGBALLSTARTY	=	100*VC_FACTOR
; INITDEBUGBALLSPEEDX	=	-6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	=	-2*DEFAULT_BALLSPEED

EnemyCollisionTick:	dc.w	1
BallCollisionTick:	dc.w	1
DebugBallStartX:	dc.w	INITDEBUGBALLSTARTX
DebugBallStartY:	dc.w	INITDEBUGBALLSTARTY

; Set any start position and direction/speed.
ReleaseBallFromPosition:
	bsr		ResetBallspeeds

	move.w	#INITDEBUGBALLSTARTX,d0	; Starting X pos
	move.w	#INITDEBUGBALLSTARTY,d1	; Starting Y pos
	move.w	#INITDEBUGBALLSPEEDX,d2	; Starting X speed
	move.w	#INITDEBUGBALLSPEEDY,d3	; Starting Y speed

	move.w	#INITDEBUGBALLSTARTX,DebugBallStartX
	move.w	#INITDEBUGBALLSTARTY,DebugBallStartY

	lea		Ball0,a0
	move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  d1,hSprBobTopLeftYPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,d0
	add.w	#BALL_DIAMETER*VC_FACTOR,d1
	move.w  d0,hSprBobBottomRightXPos(a0)
        move.w  d1,hSprBobBottomRightYPos(a0)
	move.w  d2,hSprBobXCurrentSpeed(a0)
	move.w  d3,hSprBobYCurrentSpeed(a0)

        ; Adjust Bat0
	; lea	Bat0,a0
	; ; move.w	hSprBobTopLeftXPos(a0),d1
	; move.l	#24,d0
	; move.w	d0,hSprBobTopLeftYPos(a0)
	; add.w	hSprBobHeight(a0),d0
	; move.w	d0,hSprBobBottomRightYPos(a0)
	rts

; Macro that release ball at a given position and speed
; In:   = d0.w starting X position
; In:   = d1.w starting Y position
; In:   = d2.w starting X speed
; In:   = d3.w starting Y speed
; In:   = a0 address to ball
OneshotReleaseBall:
	move.w  d0,hSprBobTopLeftXPos(a0)
	move.w  d1,hSprBobTopLeftYPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,d0		; Translate to virtual pos
	add.w	#BALL_DIAMETER*VC_FACTOR,d1
	move.w  d0,hSprBobBottomRightXPos(a0)
	move.w  d1,hSprBobBottomRightYPos(a0)
	move.w  d2,hSprBobXCurrentSpeed(a0)
	move.w  d3,hSprBobYCurrentSpeed(a0)
	
	rts

SpawnDebugEnemy:
	bsr		AddEnemy

	move.l	ENEMY_Stack(a5),a0
	
	move.w	#150,d0					; Starting X pos
	move.w	#100,d1					; Starting Y pos

	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	d1,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d1
	move.w	d1,hSprBobBottomRightYPos(a0)
	
	bsr		SetSpawnedEnemies

	rts

HandleEnemyCollisionTick:
	subq.w	#1,EnemyCollisionTick
	bne		.done

	movem.l	d0-d7/a0-a6,-(sp)

	move.w	#ENEMYCOLLISIONCOUNT,EnemyCollisionTick

	tst.w	ENEMY_Count(a5)
	bne		.skip
	bsr		SpawnDebugEnemy
.skip
	add.w	#1*VC_FACTOR,DebugBallStartX
	; add.w	#1*VC_FACTOR,DebugBallStartY


	move.l	GAMESCREEN_Ptr(a5),a0
	add.l	#(ScrBpl*0*4)+4,a0
	moveq	#ScrBpl-8,d0
	move.w	#(64*8*4)+4,d1
	bsr		ClearBlitWords			; Clear GAMESCREEN for vert bat

	lea		StringBuffer,a1
	moveq	#0,d0
	move.w	DebugBallStartX,d0
	lsr.w	#VC_POW,d0
	jsr		Binary2Decimal

	COPYSTR	a0,a1

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l	#(ScrBpl*0*4)+4,a2
	moveq	#ScrBpl-4,d5
	move.w	#(64*8*4)+2,d6
	bsr		DrawStringBuffer

	lea		StringBuffer,a1
	moveq	#0,d0
	move.w	DebugBallStartY,d0
	lsr.w	#VC_POW,d0
	jsr		Binary2Decimal

	COPYSTR	a0,a1

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l	#(ScrBpl*0*4)+8,a2
	moveq	#ScrBpl-4,d5
	move.w	#(64*8*4)+2,d6
	bsr		DrawStringBuffer


	lea		Ball0,a0
	move.w	DebugBallStartX,hSprBobTopLeftXPos(a0)
	move.w	DebugBallStartX,hSprBobBottomRightXPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,hSprBobBottomRightXPos(a0)
	move.w	DebugBallStartY,hSprBobTopLeftYPos(a0)
	move.w	DebugBallStartY,hSprBobBottomRightYPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,hSprBobBottomRightYPos(a0)

	move.w  #INITDEBUGBALLSPEEDX,hSprBobXCurrentSpeed(a0)
	move.w  #INITDEBUGBALLSPEEDY,hSprBobYCurrentSpeed(a0)

	movem.l	(sp)+,d0-d7/a0-a6
.done
	rts

HandleBallCollisionTick:
	subq.w	#1,BallCollisionTick
	bne		.done

	movem.l	d0-d7/a0-a6,-(sp)

	move.w	#BALLCOLLISIONFRAMECOUNT,BallCollisionTick

	add.w	#1*VC_FACTOR,DebugBallStartX		; Move 1 px
	; add.w	#1*VC_FACTOR,DebugBallStartY		; Move 1 px

	lea		Ball0,a0
	move.w	DebugBallStartX,hSprBobTopLeftXPos(a0)
	move.w	DebugBallStartX,hSprBobBottomRightXPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,hSprBobBottomRightXPos(a0)
	move.w	DebugBallStartY,hSprBobTopLeftYPos(a0)
	move.w	DebugBallStartY,hSprBobBottomRightYPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,hSprBobBottomRightYPos(a0)

	move.w  #INITDEBUGBALLSPEEDX,hSprBobXCurrentSpeed(a0)
	move.w  #INITDEBUGBALLSPEEDY,hSprBobYCurrentSpeed(a0)

	movem.l	(sp)+,d0-d7/a0-a6
.done
	rts