; Ball logic

BallUpdates:
        move.l  AllBalls,d7
        move.l  d7,d6
        lea     AllBalls+hAllBallsBall0,a1
        moveq   #0,d3
        moveq   #-1,d5

.ballLoop
        move.l  (a1)+,d0		        ; Any ball in this slot?
	beq.w   .doneBall
	move.l	d0,a0
        tst.l   hSprBobXCurrentSpeed(a0)        ; Stationary or glued?
        beq.w   .doneBall

        moveq   #0,d5                           ; Ball(s) moving flag

	tst.b	GameTick
	bne.s	.update

        ; Ball(s) are in motion but softlock-timer has run out
        add.w   #1*VC_FACTOR,hSprBobTopLeftXPos(a0)    ; Prevent soft-lock by moving ball a bit
        add.w   #2*VC_FACTOR,hSprBobTopLeftYPos(a0)
        add.w   #1*VC_FACTOR,hSprBobBottomRightXPos(a0)
        add.w   #2*VC_FACTOR,hSprBobBottomRightYPos(a0)
        move.b	#SOFTLOCK_FRAMES,GameTick       ; Reset soft-lock timer
.update
; TopLeft
        move.w  hSprBobTopLeftXPos(a0),d0
        move.w  hSprBobTopLeftYPos(a0),d1
        add.w   hSprBobXCurrentSpeed(a0),d0     ; Update ball coordinates
        add.w   hSprBobYCurrentSpeed(a0),d1
        move.w  d0,hSprBobTopLeftXPos(a0)       ; Set the new coordinate values
        move.w  d1,hSprBobTopLeftYPos(a0)
; BottomRight
        move.w  hSprBobBottomRightXPos(a0),d0
        move.w  hSprBobBottomRightYPos(a0),d1
        add.w   hSprBobXCurrentSpeed(a0),d0
        add.w   hSprBobYCurrentSpeed(a0),d1
        move.w  d0,hSprBobBottomRightXPos(a0)   ; Set the new coordinate values
        move.w  d1,hSprBobBottomRightYPos(a0)

        ; Ball moved off-screen?
        cmp.w   #DISP_WIDTH*VC_FACTOR+BallDiameter*VC_FACTOR,d0
        bhs.s   .lostBall
        cmp.w   #-BallDiameter*VC_FACTOR,d0
        ble.s   .lostBall
        cmp.w   #DISP_HEIGHT*VC_FACTOR+BallDiameter*VC_FACTOR,d1
        bhs.s   .lostBall
        cmp.w   #-BallDiameter*VC_FACTOR,hSprBobBottomRightYPos(a0)
        ble.s   .lostBall
        bra.s   .doneBall

.lostBall
        cmp.l   AllBalls,d3                     ; Lost all balls on GAMEAREA?
        beq.s   .subBallsLeft
        
        addq.b  #1,d3
        bsr     ResetBallStruct                 ; Reset sprite
        move.l  hAddress(a0),a2
        clr.l   hVStart(a2)                     ; Disarm sprite
        clr.l   -4(a1)                          ; Remove from AllBalls
        bra.s   .doneBall

.subBallsLeft
        subq.b  #1,BallsLeft
        move.l  hPlayerBat(a0),d0               ; Let "ballowner" have next serve

        bsr     ResetBalls
        bsr	RestorePlayerAreas
        bsr     ResetTileQueues
        bsr     ResetPlayers
        bsr     MoveBall0ToOwner
        bsr	DrawAvailableBalls
        bsr     ClearPowerup
        bsr     ClearActivePowerupEffects
        bsr     InitPlayerBobs
        bsr	InitialBlitPlayers
        bsr	AwaitAllFirebuttonsReleased
        bra.s   .exit

.doneBall
        dbf     d7,.ballLoop

        tst.b   BallspeedTick                   ; Update speed?
        bne.s   .compactBallList

        move.b  BallspeedFrameCount,BallspeedTick

        tst.b   d5                              ; Any ball(s) moving?
        bne.s   .compactBallList
        bsr     IncreaseBallspeed

.compactBallList
        tst.b   d3                              ; Any lost extra balls?
        beq.s   .exit

        moveq   #8-1,d7                         ; TODO: Dynamic number of extra balls?
        move.l  #AllBalls+hAllBallsBall0,a0
        move.l  #AllBalls+hAllBallsBall1,a1
.compactLoop                                    ; Compact the extra ball list
        move.l  (a1)+,d0

        tst.l   (a0)
        beq.s   .tryMove
        bne.s   .next
.tryMove
        tst.l   d0
        beq.s   .skip
        move.l  d0,(a0)
        clr.l   -4(a1)
.next
        addq.l  #4,a0
.skip
        dbf     d7,.compactLoop

        sub.l   d3,d6
        move.l  d6,AllBalls                     ; Update number of active balls

        tst.b   InsanoState
        bmi     .exit

        cmp.b   #2,d6
        bhi     .exit

        bsr     ReassignAndEndInsanoBallz

.exit
        rts


; Whatever balls are left from InsaonoBallz goes into Ball0-2 stucts.
; This might include disarming some of ballsprites 3-7.
ReassignAndEndInsanoBallz:
        lea     AllBalls+hAllBallsBall0,a1
        move.l  (a1),a1

        cmpa.l  #Ball0,a1                       ; Is first slot occupied by ball 3-7?
        beq     .checkAllBallsBall1
        cmpa.l  #Ball1,a1
        beq     .checkAllBallsBall1
        cmpa.l  #Ball2,a1
        beq     .checkAllBallsBall1

        bsr     GetAvailableMultiball
        cmpa.l  #0,a0                           ; None available?
        beq     .insanoOff

        move.l  a0,AllBalls+hAllBallsBall0

        REASSIGN_BALL a1,a0
        move.l  hAddress(a0),a0                 ; Arm sprite -> non-available from here on out
        move.l  hAddress(a1),a1
        move.l  (a1),(a0)
        clr.l   (a1)                            ; Disarm source sprite

.checkAllBallsBall1
        lea     AllBalls+hAllBallsBall1,a1
        tst.l   (a1)                            ; Any ball in this slot?
        beq     .insanoOff
        move.l  (a1),a1
        
        cmpa.l  #Ball0,a1                       ; Is this slot occupied by ball 3-7?
        beq     .checkAllBallsBall2
        cmpa.l  #Ball1,a1
        beq     .checkAllBallsBall2
        cmpa.l  #Ball2,a1
        beq     .checkAllBallsBall2

        bsr     GetAvailableMultiball
        cmpa.l  #0,a0                           ; None available?
        beq     .insanoOff

        move.l  a0,AllBalls+hAllBallsBall1

        REASSIGN_BALL a1,a0
        move.l  hAddress(a0),a0                 ; Arm sprite -> non-available from here on out
        move.l  hAddress(a1),a1
        move.l  (a1),(a0)
        clr.l   (a1)                            ; Disarm source sprite

.checkAllBallsBall2
        lea     AllBalls+hAllBallsBall2,a1
        tst.l   (a1)
        beq     .insanoOff
        move.l  (a1),a1

        cmpa.l  #Ball0,a1                       ; Is this slot occupied by ball 3-7?
        beq     .insanoOff
        cmpa.l  #Ball1,a1
        beq     .insanoOff
        cmpa.l  #Ball2,a1
        beq     .insanoOff

        bsr     GetAvailableMultiball
        cmpa.l  #0,a0                           ; None available?
        beq     .insanoOff

        move.l  a0,AllBalls+hAllBallsBall2

        REASSIGN_BALL a1,a0
        move.l  hAddress(a0),a0                 ; Arm sprite
        move.l  hAddress(a1),a1
        move.l  (a1),(a0)
        clr.l   (a1)                            ; Disarm source sprite

.insanoOff
        move.b  #INACTIVE_STATE,InsanoState

        rts

; Checks and returns first ball whose sprite is disarmed.
; Out:  a0 = unused multiball or $0
GetAvailableMultiball:
        lea     Ball0,a0
        move.l  (a0),a2
        tst.l   (a2)
        beq     .exit

        lea     Ball1,a0
        move.l  (a0),a2
        tst.l   (a2)
        beq     .exit

        lea     Ball2,a0
        move.l  (a0),a2
        tst.l   (a2)
        beq     .exit

        sub.l   a0,a0
.exit
        rts

; Used for resolving inconclusive collision detection.
; Moves ball back 1/8 th towards the coordinates (where ball was in previous frame).
; In:   a0 = address to ball structure
MoveBallBack:
        ; X values
        move.w  hSprBobTopLeftXPos(a0),d0
        move.w  hSprBobBottomRightXPos(a0),d1

        move.w  hSprBobXCurrentSpeed(a0),d2
        bpl.s   .positiveX

        neg.w   d2
        lsr.w   #3,d2
        add.w   d2,d0
        add.w   d2,d1
        bra.s   .setX
.positiveX
        lsr.w   #3,d2
        sub.w   d2,d0
        sub.w   d2,d1
.setX
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  d1,hSprBobBottomRightXPos(a0)

        ; Y values
        move.w  hSprBobTopLeftYPos(a0),d0
        move.w  hSprBobBottomRightYPos(a0),d1

        move.w  hSprBobYCurrentSpeed(a0),d2
        bpl.s   .positiveY

        neg.w   d2
        lsr.w   #3,d2
        add.w   d2,d0
        add.w   d2,d1
        bra.s   .setY
.positiveY
        lsr.w   #3,d2

        sub.w   d2,d0
        sub.w   d2,d1
.setY
        move.w  d0,hSprBobTopLeftYPos(a0)
        move.w  d1,hSprBobBottomRightYPos(a0)

        rts

ResetBalls:
	clr.l	Spr_Ball1    ; Disarm other balls
	clr.l	Spr_Ball2
        clr.l	Spr_Ball3
        clr.l	Spr_Ball4
        clr.l	Spr_Ball5
        clr.l	Spr_Ball6
        clr.l	Spr_Ball7
        
        lea     Ball0,a0
        bsr     ResetBallStruct
        lea     Ball1,a0
        bsr     ResetBallStruct
        lea     Ball2,a0
        bsr     ResetBallStruct
        lea     Ball3,a0
        bsr     ResetBallStruct
        lea     Ball4,a0
        bsr     ResetBallStruct
        lea     Ball5,a0
        bsr     ResetBallStruct
        lea     Ball6,a0
        bsr     ResetBallStruct
        lea     Ball7,a0
        bsr     ResetBallStruct

.resetBallList
        lea     AllBalls,a0
        clr.l   (a0)+
        move.l  #Ball0,(a0)+
        clr.l   (a0)+
        clr.l   (a0)+
        clr.l   (a0)+
        clr.l   (a0)+
        clr.l   (a0)+
        clr.l   (a0)+
        clr.l   (a0)

        lea     Ball0,a0        ; Reset Ball0
        tst.l   hPlayerBat(a0)
        bne.s   .setBallColor

.findBallOwner
        lea     Ball1,a1
        move.l  hPlayerBat(a1),d0
        beq.s   .ball2

        move.l  d0,hPlayerBat(a0)   ; Set ballowner for Ball0
        bra.s   .setBallColor
.ball2
        lea     Ball2,a1
        move.l  hPlayerBat(a1),hPlayerBat(a0)   ; Set ballowner for Ball0

.setBallColor
        move.l  hPlayerBat(a0),a1
        bsr     SetBallColor

        bsr     ResetBallspeeds

        rts

; Resets animated balls etc.
; In:	a0 = adress to ball struct
ResetBallStruct:
        cmpa.l  #Ball0,a0
        bne.s   .ball1
        move.l  #Spr_Ball0,Ball0
        bra     .continue
.ball1
        cmpa.l  #Ball1,a0
        bne.s   .ball2
        move.l  #Spr_Ball1,Ball1
        bra.s   .continue
.ball2
        cmpa.l  #Ball2,a0
        bne.s   .ball3
        move.l  #Spr_Ball2,Ball2
        bra.s   .continue
.ball3
        cmpa.l  #Ball3,a0
        bne.s   .ball4
        move.l  #Spr_Ball3,Ball3
        bra.s   .continue
.ball4
        cmpa.l  #Ball4,a0
        bne.s   .ball5
        move.l  #Spr_Ball4,Ball4
        bra.s   .continue
.ball5
        cmpa.l  #Ball5,a0
        bne.s   .ball6
        move.l  #Spr_Ball5,Ball5
        bra.s   .continue
.ball6
        cmpa.l  #Ball6,a0
        bne.s   .ball7
        move.l  #Spr_Ball6,Ball6
        bra.s   .continue
.ball7
        move.l  #Spr_Ball7,Ball7

.continue
        move.b  #-1,hIndex(a0)          ; Animation OFF
        clr.l   hSprBobXCurrentSpeed(a0); Clear both X & Y speeds
        clr.w   hBallSpeedLevel(a0)
        clr.w   hBallEffects(a0)

	move.l	hSpritePtr(a0),a2
	move.l	(a2),a2

	move.l	hAddress(a0),d1
	move.w	d1,(a2)			; New sprite pointers
	swap	d1
	move.w	d1,4(a2)

        rts

; Override/set sprite colors
; In:	a0 = adress to ball
; In:	a1 = adress to bat that has accent colors
SetBallColor:
        cmpa.l  #Ball0,a0
        bne.s   .b1

        lea     CUSTOM+COLOR17,a6
        bra.s   .setColor
.b1
        cmpa.l  #Ball1,a0
        bne.s   .b2

        lea     CUSTOM+COLOR21,a6
        bra.s   .setColor
.b2
        lea     CUSTOM+COLOR25,a6

.setColor
        move.w  hSprBobAccentCol1(a1),(a6)+
        move.w  hSprBobAccentCol2(a1),(a6)+
        move.w	#$eee,(a6)

        rts

; Sets accent color on all balls given the bat/ballowner.
; In:	a1 = adress to bat
Set3BallColor:
        lea     CUSTOM+COLOR17,a6
        move.w  hSprBobAccentCol1(a1),(a6)+
        move.w  hSprBobAccentCol2(a1),(a6)+
        move.w	#$eee,(a6)
        lea     CUSTOM+COLOR21,a6
        move.w  hSprBobAccentCol1(a1),(a6)+
        move.w  hSprBobAccentCol2(a1),(a6)+
        move.w	#$eee,(a6)
        lea     CUSTOM+COLOR25,a6
        move.w  hSprBobAccentCol1(a1),(a6)+
        move.w  hSprBobAccentCol2(a1),(a6)+
        move.w	#$eee,(a6)

        rts

InitGenericBallBob:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#ScrBpl*4+28,d0

        move.l  d0,GenericBallBob

        rts

; Draws the balls that are available to player(s) of this game.
; Draws to backing screen first to avoid thrashblits later.
DrawAvailableBalls:
        move.l 	GAMESCREEN_BITMAPBASE_BACK,a2
        add.l   #(ScrBpl*9*4)+1,a2      ; Starting point: 4 bitplanes, Y = 9, X = 1st byte
        move.l	a2,a3

        move.l  GenericBallBob,a1
        
        moveq   #0,d7
.loop
        addq.b  #1,d7
        cmp.b   BallsLeft,d7
        blo.s   .drawGenericBall

.drawClear
        move.l 	BOBS_BITMAPBASE,a1
        add.l   #(ScrBpl*4*248),a1
.drawGenericBall
        bsr     DrawGenericBall
        addq.l  #1,a2

        cmp.b   #8,d7                   ; Draw up to 8 extra balls
        bne.s   .loop

	move.l	a3,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*9*4)+1,a1
	moveq	#ScrBpl-10,d1
	move.w	#(64*7*4)+5,d2
	bsr	CopyRestoreGamearea

        rts

; In:   a1 = Source ball (planar) or 0 bits for clearing
; In:   a2 = Destination game screen
DrawGenericBall:
        move.b  0*40(a1),0*40(a2)
        move.b  1*40(a1),1*40(a2)
        move.b  2*40(a1),2*40(a2)
        move.b  3*40(a1),3*40(a2)

	move.b  4*40(a1),4*40(a2)
        move.b  5*40(a1),5*40(a2)
        move.b  6*40(a1),6*40(a2)
        move.b  7*40(a1),7*40(a2)

	move.b  8*40(a1),8*40(a2)
        move.b  9*40(a1),9*40(a2)
        move.b  10*40(a1),10*40(a2)
        move.b  11*40(a1),11*40(a2)

	move.b  12*40(a1),12*40(a2)
        move.b  13*40(a1),13*40(a2)
        move.b  14*40(a1),14*40(a2)
        move.b  15*40(a1),15*40(a2)

	move.b  16*40(a1),16*40(a2)
        move.b  17*40(a1),17*40(a2)
        move.b  18*40(a1),18*40(a2)
        move.b  19*40(a1),19*40(a2)
        
	move.b  20*40(a1),20*40(a2)
        move.b  21*40(a1),21*40(a2)
        move.b  22*40(a1),22*40(a2)
        move.b  23*40(a1),23*40(a2)

	; move.b  24*40(a1),24*40(a2)
        ; move.b  25*40(a1),25*40(a2)
        ; move.b  26*40(a1),26*40(a2)
        ; move.b  27*40(a1),27*40(a2)

        rts

ResetBallspeeds:
        move.w  BallspeedBase,d0
        move.w  d0,BallSpeedx1
        add.w   BallspeedBase,d0
        move.w  d0,BallSpeedx2
        add.w   BallspeedBase,d0
        move.w  d0,BallSpeedx3
        rts

; Increases current speed of all balls.
IncreaseBallspeed:
        movem.l d1/d2,-(sp)

        move.w  BallSpeedx1,d1
        cmp.w   #MaxBallSpeedWithOkCollissionDetection,d1       ; Are we getting into buggy territory?
        bhi.s   .resetRampup                                    ; At max - no need to try this as often
        move.w  BallSpeedx2,d2

        move.l  AllBalls,d6
        lea     AllBalls+hAllBallsBall0,a1

.ballLoop
        move.l  (a1)+,d0		        ; Any ball in this slot?
	beq.w   .doneBall
	move.l	d0,a0

        move.w  hSprBobXCurrentSpeed(a0),d4
        bsr     IncreaseBallspeedXY
        move.w  d4,hSprBobXCurrentSpeed(a0)
        move.w  d4,hSprBobXSpeed(a0)

        move.w  hSprBobYCurrentSpeed(a0),d4
        bsr     IncreaseBallspeedXY
        move.w  d4,hSprBobYCurrentSpeed(a0)
        move.w  d4,hSprBobYSpeed(a0)
.doneBall
        dbf     d6,.ballLoop

        addq.w   #1,BallSpeedx1
        addq.w   #2,BallSpeedx2
        addq.w   #3,BallSpeedx3
        bra     .exit

.resetRampup
        move.b  BallspeedFrameCountCopy,BallspeedFrameCount
.exit
        movem.l (sp)+,d1/d2
        rts

; Decreases current speed of all balls.
DecreaseBallspeed:
        movem.l d1/d2,-(sp)

        move.w  BallSpeedx1,d1
        cmp.w   #MIN_BALLSPEED,d1
        blo.s   .exit
        move.w  BallSpeedx2,d2

        move.l  AllBalls,d6
        lea     AllBalls+hAllBallsBall0,a1

.ballLoop
        move.l  (a1)+,d0		        ; Any ball in this slot?
	beq.w   .doneBall
	move.l	d0,a0

        move.w  hSprBobXCurrentSpeed(a0),d4
        bsr     DecreaseBallspeedXY
        move.w  d4,hSprBobXCurrentSpeed(a0)
        move.w  d4,hSprBobXSpeed(a0)

        move.w  hSprBobYCurrentSpeed(a0),d4
        bsr     DecreaseBallspeedXY
        move.w  d4,hSprBobYCurrentSpeed(a0)
        move.w  d4,hSprBobYSpeed(a0)
.doneBall
        dbf     d6,.ballLoop

        subq.w  #3,BallSpeedx1
        subq.w  #6,BallSpeedx2
        sub.w   #9,BallSpeedx3
.exit
        movem.l (sp)+,d1/d2
        rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.w = X or Y speed
; Out:	d4.w = Updated value for X or Y speed
IncreaseBallspeedXY:
        tst.w   d4
        bmi.s   .negative

        bsr     GetIncreasedSpeedXY
        bra.s   .done
.negative
        neg.w   d4
        bsr     GetIncreasedSpeedXY
        neg.w   d4
.done
        rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.w = X or Y speed
; Out:	d4.w = Updated value for X or Y speed
DecreaseBallspeedXY:
        tst.w   d4
        bmi.s   .negative

        bsr     GetDecreasedSpeedXY
        bra.s   .done
.negative
        neg.w   d4
        bsr     GetDecreasedSpeedXY
        neg.w   d4
.done
        rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.w = X or Y speed
; Out:	d4.w = Updated value for X or Y speed
GetIncreasedSpeedXY:
        cmp.w   d4,d1
        bne.s   .try2
        addq.w  #1,d4
        bra.s   .done
.try2
        cmp.w   d4,d2
        bne.s   .do3
        addq.w  #2,d4
        bra.s   .done
.do3
        addq.w  #3,d4
.done
        rts

; In:	d1.w = speedcomponent 1
; In:	d2.w = speedcomponent 2
; In:	d4.w = X or Y speed
; Out:	d4.w = Updated value for X or Y speed
GetDecreasedSpeedXY:
        cmp.w   d4,d1
        bne.s   .try2
        subq.w  #3,d4
        bra.s   .done
.try2
        cmp.w   d4,d2
        bne.s   .do3
        subq.w  #6,d4
        bra.s   .done
.do3
        sub.w   #9,d4
.done
        rts


MoveBall0ToOwner:
        lea	Ball0,a0
	move.l	hPlayerBat(a0),a1

	cmpa.l	#Bat0,a1
	bne.s	.bat1

	move.w  BallSpeedx3,hSprBobXSpeed(a0)	; Set speed, awaiting release
	neg.w	hSprBobXSpeed(a0)
	move.w  BallSpeedx1,hSprBobYSpeed(a0)
	neg.w	hSprBobYSpeed(a0)

        move.w  hSprBobTopLeftXPos(a1),d0
        sub.w   #BallDiameter,d0
        lsl.w   #VC_POW,d0                              ; Translate to virtual coords
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1
        addi.w  #$d,d1
        lsl.w   #VC_POW,d1                              ; Translate to virtual coords
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d1
        move.w  d1,hSprBobBottomRightYPos(a0)

.bat1
	cmpa.l	#Bat1,a1
	bne.s	.bat2

	move.w	BallSpeedx3,hSprBobXSpeed(a0)	; Set speed, awaiting release
	move.w	BallSpeedx1,hSprBobYSpeed(a0)

        move.w  hSprBobBottomRightXPos(a1),d0
        lsl.w   #VC_POW,d0                              ; Translate to virtual coords
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1
        addi.w  #$f,d1
        lsl.w   #VC_POW,d1                              ; Translate to virtual coords
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d1
        move.w  d1,hSprBobBottomRightYPos(a0)
.bat2
	cmpa.l	#Bat2,a1
	bne.s	.bat3

        move.w	BallSpeedx1,hSprBobXSpeed(a0)	; Set speed, awaiting release
	move.w	BallSpeedx3,hSprBobYSpeed(a0)
	neg.w	hSprBobYSpeed(a0)

        move.w  hSprBobTopLeftXPos(a1),d0
        move.w  hSprBobWidth(a1),d1
        lsr.w   d1
        add.w   d1,d0
        lsl.w   #VC_POW,d0                              ; Translate to virtual coords
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1
        sub.w   #BallDiameter,d1
        lsl.w   #VC_POW,d1                              ; Translate to virtual coords
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d1
        move.w  d1,hSprBobBottomRightYPos(a0)
.bat3
	cmpa.l	#Bat3,a1
	bne.s	.exit

	move.w	BallSpeedx1,hSprBobXSpeed(a0)	; Set speed, awaiting release
	neg.w	hSprBobXSpeed(a0)
	move.w	BallSpeedx3,hSprBobYSpeed(a0)

        move.w  hSprBobTopLeftXPos(a1),d0
        move.w  hSprBobWidth(a1),d1
        lsr.w   d1
        add.w   d1,d0
	subq.w	#6,d0					; Adjust relative ball position
        lsl.w   #VC_POW,d0                              ; Translate to virtual coords
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobBottomRightYPos(a1),d1
        lsl.w   #VC_POW,d1                              ; Translate to virtual coords
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   #BallDiameter*VC_FACTOR,d1
        move.w  d1,hSprBobBottomRightYPos(a0)
.exit
        rts


Insanoballz:
        tst.b	InsanoState
        bne     .insano

        ; Check if ball is too close to borders (possibly leading to ball-trapped-in-wall)
        lea	AllBalls+hAllBallsBall0,a2
	move.l	(a2),a2

        bsr     IsBallNearScreenEdge
        tst.b   d0
        beq     .exit

        bsr     DecreaseBallspeed

        move.w  BallSpeedx1,d1
        cmp.w   #MIN_BALLSPEED,d1
        bhi     .exit

        ; Reached min ball speed - set neutral ball color for all sprites
        lea     CUSTOM+COLOR17,a6
        move.w  #$444,(a6)+
        move.w  #$999,(a6)+
        move.w	#$fff,(a6)
        lea     CUSTOM+COLOR21,a6
        move.w  #$444,(a6)+
        move.w  #$999,(a6)+
        move.w	#$fff,(a6)
        lea     CUSTOM+COLOR25,a6
        move.w  #$444,(a6)+
        move.w  #$999,(a6)+
        move.w	#$fff,(a6)
	lea     CUSTOM+COLOR29,a6 
        move.w  #$444,(a6)+
        move.w  #$999,(a6)+
        move.w	#$fff,(a6)

        cmpa.l  #Ball0,a2
        beq     .populateAllBalls

        ; Reassign active ball to Ball0
        lea     Ball0,a0
        REASSIGN_BALL a2,a0

.populateAllBalls
        ; Add more balls
	lea	Ball0,a0
	lea	Ball1,a1
	lea	Ball2,a2
        lea	Ball3,a3

	lea	AllBalls,a6
	move.l	#8-1,hAllBallsActive(a6)
	move.l	a0,hAllBallsBall0(a6)
	move.l	a1,hAllBallsBall1(a6)
	move.l	a2,hAllBallsBall2(a6)
        move.l	a3,hAllBallsBall3(a6)
        move.l  #Ball4,hAllBallsBall4(a6)
        move.l  #Ball5,hAllBallsBall5(a6)
        move.l  #Ball6,hAllBallsBall6(a6)
        move.l  #Ball7,hAllBallsBall7(a6)

        move.l  a0,a6                           ; Copy Ball0

        move.l  hPlayerBat(a6),d0
	move.l	d0,hPlayerBat(a0)               ; Set ballowner
	move.l	d0,hPlayerBat(a1)
	move.l	d0,hPlayerBat(a2)
        move.l	d0,hPlayerBat(a3)
        lea	Ball4,a0
	lea	Ball5,a1
	lea	Ball6,a2
        lea	Ball7,a3
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
	lea	Ball0,a0
	lea	Ball1,a1
	lea	Ball2,a2
        lea	Ball3,a3
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
        move.w  BallSpeedx1,d1
        move.w  BallSpeedx2,d2
        move.w  BallSpeedx3,d3
        move.w  d1,d4
        move.w  d2,d5
        move.w  d3,d6
        neg.w   d4
        neg.w   d5
        neg.w   d6

        move.w  d1,hSprBobXCurrentSpeed(a0)     ; /     A lot upwards to the right
        move.w  d6,hSprBobYCurrentSpeed(a0)
        move.w  d3,hSprBobXCurrentSpeed(a1)     ; -/    Little upwards to the right
        move.w  d4,hSprBobYCurrentSpeed(a1)
        move.w  d3,hSprBobXCurrentSpeed(a2)     ; -\    Little downwards to the right
        move.w  d1,hSprBobYCurrentSpeed(a2)
        move.w  d1,hSprBobXCurrentSpeed(a3)     ; \     A lot downwards to the right
        move.w  d3,hSprBobYCurrentSpeed(a3)
        move.w  d1,hSprBobXSpeed(a0)
        move.w  d6,hSprBobYSpeed(a0)
        move.w  d3,hSprBobXSpeed(a1)
        move.w  d4,hSprBobYSpeed(a1)
        move.w  d3,hSprBobXSpeed(a2)
        move.w  d1,hSprBobYSpeed(a2)
        move.w  d1,hSprBobXSpeed(a3)
        move.w  d3,hSprBobYSpeed(a3)
        lea	Ball4,a0
	lea	Ball5,a1
	lea	Ball6,a2
        lea	Ball7,a3
        move.w  d4,hSprBobXCurrentSpeed(a0)     ; /     A lot downwards to the left
        move.w  d3,hSprBobYCurrentSpeed(a0)
        move.w  d6,hSprBobXCurrentSpeed(a1)     ; /-    Little downwards to the left
        move.w  d1,hSprBobYCurrentSpeed(a1)
        move.w  d6,hSprBobXCurrentSpeed(a2)     ; \-    Little upwards to the left
        move.w  d4,hSprBobYCurrentSpeed(a2)
        move.w  d4,hSprBobXCurrentSpeed(a3)     ; \     A lot upwards to the left
        move.w  d6,hSprBobYCurrentSpeed(a3)
        move.w  d4,hSprBobXSpeed(a0)
        move.w  d3,hSprBobYSpeed(a0)
        move.w  d6,hSprBobXSpeed(a1)
        move.w  d1,hSprBobYSpeed(a1)
        move.w  d6,hSprBobXSpeed(a2)
        move.w  d4,hSprBobYSpeed(a2)
        move.w  d4,hSprBobXSpeed(a3)
        move.w  d6,hSprBobYSpeed(a3)

        move.l	Copper_SPR7PTL,a2               ; Set sprite pointers for ball 7
	move.l	#Spr_Ball7,d1
	move.w	d1,(a2)+
	swap	d1
	move.w	d1,(a2)

        ; Make balls accellerate quickly up to max
        move.b  #1,BallspeedFrameCount
        move.b  #INSANO_STATE,InsanoState

.insano
        cmp.b   #RESET_STATE,InsanoState
        beq     .resetting

        move.b  #-1,IsDroppingBricks    ; Let previously added bricks drop now
        
        subq.b  #1,InsanoTick
        bne     .exit

        move.b  #9,InsanoTick
        subq.b  #1,InsanoDrops
        beq     .reset

        bsr     AddBricksToQueue
        move.b  #0,IsDroppingBricks     ; Animate drop for a few frames
        move.b	#5,SpawnInCount
        
        bra     .exit

.reset
        move.b  #RESET_STATE,InsanoState
.resetting
        bsr     DecreaseBallspeed        

        move.w  BallSpeedx1,d1    ; Slowdown to level-start speed
        cmp.w   BallspeedBase,d1
        bhi     .exit

        move.b  #-1,IsDroppingBricks    ; One final drop

        bsr     RemoveProtectiveTiles

        move.b  BallspeedFrameCountCopy,BallspeedFrameCount
        move.b  #DEFAULT_INSANODROPS,InsanoDrops

        move.b  #PHAZE101OUT_STATE,InsanoState

.exit
        rts

RemoveProtectiveTiles:
	move.l	RemoveTileQueuePtr,a0

	moveq	#1,d2
	move.w	#1*41+1+4,d1		; Start from 1st row + 4 right
	moveq	#32-1,d7
.removeTopHorizLoop
	move.w	d2,(a0)+		; Row
	move.w	d1,(a0)+		; Position in GAMEAREA
	addq.w	#1,d1
	dbf	d7,.removeTopHorizLoop

	moveq	#3,d2
	move.w	#3*41+1+1,d1		; Start from 3rd row +1 right
	moveq	#26-1,d7
.removeVerticalLoop
					; Left tile
	move.w	d2,(a0)+		; Row
	move.w	d1,(a0)+		; Position in GAMEAREA

	add.w	#37,d1			; Right tile
	move.w	d2,(a0)+		; Row
	move.w	d1,(a0)+		; Position in GAMEAREA
	
	addq.w	#1,d2			; Next row
	addq.w	#4,d1
	dbf	d7,.removeVerticalLoop

	moveq	#30,d2
	move.w	#30*41+1+4,d1		; Start from 30th row + 4 right
	moveq	#32-1,d7
.removeBottomHorizLoop
	move.w	d2,(a0)+		; Row
	move.w	d1,(a0)+		; Position in GAMEAREA
	addq.w	#1,d1
	dbf	d7,.removeBottomHorizLoop

	move.l	a0,RemoveTileQueuePtr	; Update pointer

        rts

; Checks if ball is near screen edge (~45 pixels - disregarding center of ball).
; In:	a2 = Address to a ball to be tested
; Out:	d0.b = 0 if near, -1 if not near screen edge.
IsBallNearScreenEdge:
	move.l	hSprBobTopLeftXPos(a2),d0
        cmp.w   #(DISP_HEIGHT-45)*VC_FACTOR,d0  ; Too close to bottom?
        bhi     .true
        cmp.w   #45*VC_FACTOR,d0                ; Too close to top?
        blo     .true
        swap    d0
        cmp.w   #(DISP_WIDTH-45)*VC_FACTOR,d0   ; Too close to right?
        bhi     .true
        cmp.w   #45*VC_FACTOR,d0                ; Too close to left?
        blo     .true

        move.b  #-1,d0
        rts
.true    
        move.b  #0,d0
        rts