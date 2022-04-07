; Ball logic

BallUpdates:
        lea     Ball0,a0
        move.w  hBallTopLeftXPos(a0),d0
        move.w  hBallTopLeftYPos(a0),d1

; Ball moved off-screen?
        cmp.w   #DISP_WIDTH,d0
        bhs.w   .lostBall
        cmp.w   #0,d0
        bls.w   .lostBall
        cmp.w   #DISP_HEIGHT-BallDiameter,d1
        bhs.w   .lostBall
        cmp.w   #0,hBallBottomRightYPos(a0)
        bls.w   .lostBall
        
        bra.s   .ballInPlay
.lostBall
; TODO: add logic for multiball
        subi.b  #1,BallsLeft
        bsr	DrawAvailableBalls
        bsr     ResetBalls

.ballInPlay
        tst.b   BallZeroOnBat
        beq.s   .exit

.moveBall
; TopLeft
        add.w   hBallXCurrentSpeed(a0),d0        ; Update ball coordinates
        add.w   hBallYCurrentSpeed(a0),d1
        move.w  d0,hBallTopLeftXPos(a0)          ; Set the new coordinate values
        move.w  d1,hBallTopLeftYPos(a0)
; BottomRight
        move.w  hBallBottomRightXPos(a0),d0
        move.w  hBallBottomRightYPos(a0),d1
        add.w   hBallXCurrentSpeed(a0),d0
        add.w   hBallYCurrentSpeed(a0),d1
        move.w  d0,hBallBottomRightXPos(a0)      ; Set the new coordinate values
        move.w  d1,hBallBottomRightYPos(a0)
.exit
        rts


ResetBalls:
        lea     Ball0,a0

        move.b  #0,BallZeroOnBat
        move.w  #0,hBallXCurrentSpeed(a0)
        move.w  #0,hBallYCurrentSpeed(a0)
        move.w  #0,hBallSpeedLevel(a0)

        tst.l   hBallPlayerBat(a0)
        bne.s   .setBallColor

        move.l  #Bat0,hBallPlayerBat(a0)
.setBallColor
        move.l  hBallPlayerBat(a0),a1
        bsr     SetBallColor

        rts

; Override/set sprite colors - Sprite 2-3
; In:	a1 = adress to bat that has accent colors
SetBallColor:
        lea     CUSTOM+COLOR21,a6               ; Update ball color
        move.w  hSprBobAccentCol1(a1),(a6)+
        move.w  hSprBobAccentCol2(a1),(a6)+
        move.w	#$eee,(a6)

        rts


SetGenericBallBob:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#ScrBpl*24*4+3,d0

        move.l  d0,GenericBallBob

        rts

; Draws the balls that are available to player(s) of this game.
DrawAvailableBalls:
        move.l 	GAMESCREEN_BITMAPBASE,a2
        add.l   #(ScrBpl*4*9)+1,a2     ; Starting point: 4 bitplanes, Y = 9, X = 1st byte

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
        addq    #1,a2

        cmp.b   #5,d7
        bne.s   .loop

        rts

; In:   a1 = Source ball (planar) or 0 bits for clearing
; In:   a2 = Destination game screen
DrawGenericBall:
        move.b  0*40(a1),0*40(a2)
        move.b  1*40(a1),1*40(a2)
        move.b  2*40(a1),2*40(a2)
        ; move.b  3*40(a1),3*40(a2)

	move.b  4*40(a1),4*40(a2)
        move.b  5*40(a1),5*40(a2)
        move.b  6*40(a1),6*40(a2)
        ; move.b  7*40(a1),7*40(a2)

	move.b  8*40(a1),8*40(a2)
        move.b  9*40(a1),9*40(a2)
        move.b  10*40(a1),10*40(a2)
        ; move.b  11*40(a1),11*40(a2)

	move.b  12*40(a1),12*40(a2)
        move.b  13*40(a1),13*40(a2)
        move.b  14*40(a1),14*40(a2)
        ; move.b  15*40(a1),15*40(a2)

	move.b  16*40(a1),16*40(a2)
        move.b  17*40(a1),17*40(a2)
        move.b  18*40(a1),18*40(a2)
        ; move.b  19*40(a1),19*40(a2)
        
	move.b  20*40(a1),20*40(a2)
        move.b  21*40(a1),21*40(a2)
        move.b  22*40(a1),22*40(a2)
        ; move.b  23*40(a1),23*40(a2)

	move.b  24*40(a1),24*40(a2)
        move.b  25*40(a1),25*40(a2)
        move.b  26*40(a1),26*40(a2)
        ; move.b  27*40(a1),27*40(a2)

        rts

; Increases ball speed
IncreaseBallSpeedLevel:
        lea     Ball0,a0

        move.w  hBallSpeedLevel(a0),d2          ; Reached max speed?
        cmp.w   #MaxBallSpeedLevel,d2
        beq.s   .exit

        tst.b   BallZeroOnBat
        beq.s   .exit

        addq.w  #1,d2
        move.w  d2,hBallSpeedLevel(a0)

        lsl.w   #1,d2                           ; Word addressing in subroutine
        ; X component
        move.w  hBallXCurrentSpeed(a0),d0
        bsr     GetNextSpeedForSpeedComponent
        move.w  d3,hBallXCurrentSpeed(a0)
        ; Y component
        move.w  hBallYCurrentSpeed(a0),d0
        bsr     GetNextSpeedForSpeedComponent
        move.w  d3,hBallYCurrentSpeed(a0)
.exit
        rts


; In:   d0.w = Current speed component (X or Y)
; In:   d2.w = BallSpeedLevel * 2 (word addressing)
; Out:  d3.w = Next speed
GetNextSpeedForSpeedComponent:
        lea     BallSpeedLevel123,a1
        bsr     GetNextBallSpeed
        tst.w   d3
        beq.s   .tryLevel246
        bne.s   .exit
        
.tryLevel246
        lea     BallSpeedLevel246,a1
        bsr     GetNextBallSpeed
        tst.w   d3
        beq.s   .tryLevel369
        bne.s   .exit

.tryLevel369
        lea     BallSpeedLevel369,a1
        bsr     GetNextBallSpeed
        tst.w   d3
        beq.s   .programmingError
        bne.s   .exit

; TODO Remove this when routine is proven to work as expected.
.programmingError
        moveq   #1,d3   ; Should never end up here - have a dummy value

.exit
        rts


; In:   a1 = Address to SpeedLevel table
; In:   d0.w = Current speed component (X or Y)
; In:   d2.w = BallSpeedLevel * 2 (word addressing)
; Out:  d3.w = Next speed or 0 if not found
GetNextBallSpeed:
        move.w  d0,d1
        bpl.s   .alreadyPositive
        neg.w   d1

.alreadyPositive
        move.w  (-2,a1,d2.w),d3         ; Look for current speed
        cmp.w   d3,d1
        beq.s   .found

        moveq   #0,d3
        bra.s   .exit
.found
        move.w  (a1,d2.w),d3

        tst.w   d0                        ; Keep negative speed negative
        bpl.s   .exit
        neg.w   d3
.exit
        rts

; Returns the X or Y speed component for the given speed level and speed table.
; In:	a0 = adress to ball
; In:   a2 = Address to SpeedLevel table
; Out:  d3.w = Speed component
LookupBallSpeedForLevel
        move.w  hBallSpeedLevel(a0),d2
        lsl.w   #1,d2                           ; Word addressing

        move.w  (a2,d2.w),d3

        rts