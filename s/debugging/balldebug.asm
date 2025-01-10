ENEMYCOLLISIONCOUNT		equ	35
BALLCOLLISIONFRAMECOUNT	equ	30

	IFGT	ENABLE_DEBUG_PLAYERS
INITDEBUGBALLSTARTX		equ	200*VC_FACTOR	; 6,2 - negative X & Y ballspeeds
INITDEBUGBALLSTARTY		equ	230*VC_FACTOR
INITDEBUGBALLSPEEDX		equ	-2*DEFAULT_BALLSPEED
INITDEBUGBALLSPEEDY		equ	-2*DEFAULT_BALLSPEED
	ENDIF

	IFGT ENABLE_DEBUG_BOUNCE_REPT|ENABLE_DEBUG_GLUE|ENABLE_DEBUG_BALL
	; Testcase: Start insanoballz when ball travel toward top of screen
; INITDEBUGBALLSTARTX	equ	200*VC_FACTOR		; 2,6 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	200*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-6*DEFAULT_BALLSPEED

	; Testcase: Start insanoballz when ball travel toward top left corner
INITDEBUGBALLSTARTX		equ	70*VC_FACTOR	; 2,6 - negative Y ballspeed
INITDEBUGBALLSTARTY		equ	100*VC_FACTOR
INITDEBUGBALLSPEEDX		equ	-1*DEFAULT_BALLSPEED
INITDEBUGBALLSPEEDY		equ	-3*DEFAULT_BALLSPEED

	; Testcase: Bat0 from ABOVE LEFT - increment ball Y to test
; INITDEBUGBALLSTARTX	equ	275*VC_FACTOR		; 2,6
; INITDEBUGBALLSTARTY	equ	8*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	270*VC_FACTOR		; 4,4
; INITDEBUGBALLSTARTY	equ	75*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	250*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	equ	95*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	2*DEFAULT_BALLSPEED
	
	; Testcase: Bat0 from BELOW LEFT - increment ball Y to test
; INITDEBUGBALLSTARTX	equ	280*VC_FACTOR		; 2,6 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	190*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	270*VC_FACTOR		; 4,4 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	155*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	250*VC_FACTOR		; 6,2 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	135*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-2*DEFAULT_BALLSPEED

	; Testcase: Bat1 from ABOVE LEFT - increment ball X to test
; INITDEBUGBALLSTARTX	equ	118*VC_FACTOR		; 2,6
; INITDEBUGBALLSTARTY	equ	210*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	80*VC_FACTOR		; 4,4
; INITDEBUGBALLSTARTY	equ	200*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	80*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	equ	225*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	2*DEFAULT_BALLSPEED

	; Testcase: Bat1 from ABOVE RIGHT - increment ball X to test
; INITDEBUGBALLSTARTX	equ	144*VC_FACTOR		; 2,6 - negative X ballspeed
; INITDEBUGBALLSTARTY	equ	210*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	177*VC_FACTOR		; 4,4 - negative X ballspeed
; INITDEBUGBALLSTARTY	equ	200*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	205*VC_FACTOR		; 6,2 - negative X ballspeed
; INITDEBUGBALLSTARTY	equ	220*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	2*DEFAULT_BALLSPEED
	ENDC

; Testcase: Insanoballz insta-finish level
; INITDEBUGBALLSTARTX	equ	140*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	equ	80*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	3*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	1*DEFAULT_BALLSPEED

; From ABOVE LEFT
; INITDEBUGBALLSTARTX	equ	120*VC_FACTOR		; 2,6
; INITDEBUGBALLSTARTY	equ	50*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	75*VC_FACTOR		; 4,4
; INITDEBUGBALLSTARTY	equ	50*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	120*VC_FACTOR		; 6,2
; INITDEBUGBALLSTARTY	equ	70*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	2*DEFAULT_BALLSPEED

; From ABOVE RIGHT
; INITDEBUGBALLSTARTX	equ	155*VC_FACTOR		; 2,6 - negative X ballspeed
; INITDEBUGBALLSTARTY	equ	50*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	200*VC_FACTOR		; 4,4 - negative X ballspeed
; INITDEBUGBALLSTARTY	equ	35*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	200*VC_FACTOR		; 6,2 - negative X ballspeed
; INITDEBUGBALLSTARTY	equ	70*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	2*DEFAULT_BALLSPEED

; From BELOW LEFT
; INITDEBUGBALLSTARTX	equ	120*VC_FACTOR		; 2,6 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	155*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	75*VC_FACTOR		; 4,4 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	155*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	120*VC_FACTOR		; 6,2 - negative Y ballspeed
; INITDEBUGBALLSTARTY	equ	100*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-2*DEFAULT_BALLSPEED

; From BELOW RIGHT
; INITDEBUGBALLSTARTX	equ	160*VC_FACTOR		; 2,6 - negative X & Y ballspeeds
; INITDEBUGBALLSTARTY	equ	175*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-2*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-6*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	200*VC_FACTOR		; 4,4 - negative X & Y ballspeeds
; INITDEBUGBALLSTARTY	equ	175*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-4*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-4*DEFAULT_BALLSPEED

; INITDEBUGBALLSTARTX	equ	200*VC_FACTOR		; 6,2 - negative X & Y ballspeeds
; INITDEBUGBALLSTARTY	equ	100*VC_FACTOR
; INITDEBUGBALLSPEEDX	equ	-6*DEFAULT_BALLSPEED
; INITDEBUGBALLSPEEDY	equ	-2*DEFAULT_BALLSPEED

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
	add.w	#BallDiameter*VC_FACTOR,d0
	add.w	#BallDiameter*VC_FACTOR,d1
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
	add.w	#BallDiameter*VC_FACTOR,d0		; Translate to virtual pos
	add.w	#BallDiameter*VC_FACTOR,d1
	move.w  d0,hSprBobBottomRightXPos(a0)
	move.w  d1,hSprBobBottomRightYPos(a0)
	move.w  d2,hSprBobXCurrentSpeed(a0)
	move.w  d3,hSprBobYCurrentSpeed(a0)
	
	rts

SpawnDebugEnemy:
	bsr		AddEnemy

	move.l	FreeEnemyStack,a0
	
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

	tst.w	EnemyCount
	bne		.skip
	bsr		SpawnDebugEnemy
.skip
	add.w	#1*VC_FACTOR,DebugBallStartX
	; add.w	#1*VC_FACTOR,DebugBallStartY


	move.l	GAMESCREEN_BITMAPBASE,a0
	add.l	#(ScrBpl*0*4)+4,a0
	moveq	#ScrBpl-8,d0
	move.w	#(64*8*4)+4,d1
	bsr		ClearBlitWords			; Clear GAMESCREEN for vert bat

	lea		STRINGBUFFER,a1
	moveq	#0,d0
	move.w	DebugBallStartX,d0
	lsr.w	#VC_POW,d0
	jsr		Binary2Decimal

	COPYSTR	a0,a1

	move.l	GAMESCREEN_BITMAPBASE,a2
	add.l	#(ScrBpl*0*4)+4,a2
	moveq	#ScrBpl-4,d5
	move.w	#(64*8*4)+2,d6
	bsr		DrawStringBuffer

	lea		STRINGBUFFER,a1
	moveq	#0,d0
	move.w	DebugBallStartY,d0
	lsr.w	#VC_POW,d0
	jsr		Binary2Decimal

	COPYSTR	a0,a1

	move.l	GAMESCREEN_BITMAPBASE,a2
	add.l	#(ScrBpl*0*4)+8,a2
	moveq	#ScrBpl-4,d5
	move.w	#(64*8*4)+2,d6
	bsr		DrawStringBuffer


	lea		Ball0,a0
	move.w	DebugBallStartX,hSprBobTopLeftXPos(a0)
	move.w	DebugBallStartX,hSprBobBottomRightXPos(a0)
	add.w	#BallDiameter*VC_FACTOR,hSprBobBottomRightXPos(a0)
	move.w	DebugBallStartY,hSprBobTopLeftYPos(a0)
	move.w	DebugBallStartY,hSprBobBottomRightYPos(a0)
	add.w	#BallDiameter*VC_FACTOR,hSprBobBottomRightYPos(a0)

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
	add.w	#BallDiameter*VC_FACTOR,hSprBobBottomRightXPos(a0)
	move.w	DebugBallStartY,hSprBobTopLeftYPos(a0)
	move.w	DebugBallStartY,hSprBobBottomRightYPos(a0)
	add.w	#BallDiameter*VC_FACTOR,hSprBobBottomRightYPos(a0)

	move.w  #INITDEBUGBALLSPEEDX,hSprBobXCurrentSpeed(a0)
	move.w  #INITDEBUGBALLSPEEDY,hSprBobYCurrentSpeed(a0)

	movem.l	(sp)+,d0-d7/a0-a6
.done
	rts