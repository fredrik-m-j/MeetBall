; Ball logic

BallUpdates:
        move.l  AllBalls,d6
        lea     AllBalls+4,a1
        moveq   #0,d3

.ballLoop
        move.l  (a1)+,d0		        ; Any ball in this slot?
	beq.w   .doneBall
	move.l	d0,a0
        tst.l   hSprBobXCurrentSpeed(a0)        ; Stationary or glued?
        beq.w   .doneBall

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

        cmp.w   #DISP_WIDTH+BallDiameter,d0     ; Ball moved off-screen?
        bhs.s   .lostBall
        cmp.w   #-BallDiameter,d0
        ble.s   .lostBall
        cmp.w   #DISP_HEIGHT+BallDiameter,d1
        bhs.s   .lostBall
        cmp.w   #-BallDiameter,hSprBobBottomRightYPos(a0)
        ble.s   .lostBall
        bra.s   .doneBall

.lostBall
        cmp.l   AllBalls,d3                     ; Lost all balls on GAMEAREA?
        beq.s   .subBallsLeft
        
        addq.b  #1,d3
        bsr     ResetBallStruct                 ; Reset & disarm sprite
        move.l  hAddress(a0),a2
        move.l  #0,hVStart(a2)
        move.l  #0,hPlayerBat(a0)           ; Remove owner
        move.l  #0,-4(a1)
        bra.s   .doneBall

.subBallsLeft
        subi.b  #1,BallsLeft
        move.l  hPlayerBat(a0),d0           ; Let "ballowner" have next serve

        bsr     ResetBalls
        bsr	RestorePlayerAreas
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
        dbf     d6,.ballLoop

        ; Compact ball list
        tst.b   d3                              ; Any lost extra balls?
        beq.s   .exit

        moveq   #3-2,d6                         ; TODO: Dynamic number of extra balls?
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
        move.l  #0,-4(a1)
.next
        addq.l  #4,a0
.skip
        dbf     d6,.compactLoop

        sub.l   d3,AllBalls

.exit
        rts


ResetBalls:
	move.l	#0,Spr_Ball1    ; Disarm other balls
	move.l	#0,Spr_Ball2
        
        lea     Ball0,a0
        bsr     ResetBallStruct
        lea     Ball1,a0
        bsr     ResetBallStruct
        lea     Ball2,a0
        bsr     ResetBallStruct

.resetBallList
        lea     AllBalls,a0
        move.l  #0,(a0)+
        move.l  #Ball0,(a0)+
        move.l  #0,(a0)+
        move.l  #0,(a0)

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

        rts

; In:	a0 = adress to ball struct
ResetBallStruct:
        cmpa.l  #Ball0,a0
        bne.s   .ball1
        move.l  #Spr_Ball0,Ball0
        bra.s   .continue
.ball1
        cmpa.l  #Ball1,a0
        bne.s   .ball2
        move.l  #Spr_Ball1,Ball1
        bra.s   .continue
.ball2
        move.l  #Spr_Ball2,Ball2

.continue
        move.b  #-1,hIndex(a0)          ; Animation OFF
        move.w  #0,hSprBobXCurrentSpeed(a0)
        move.w  #0,hSprBobYCurrentSpeed(a0)
        move.w  #0,hBallSpeedLevel(a0)
        move.w  #0,hBallEffects(a0)

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

; In:	a1 = adress to bat
SetAllBallColor:
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
        addq    #1,a2

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

; Increases ball speed
IncreaseBallSpeedLevel:
        move.l  AllBalls,d6
        lea     AllBalls+4,a1
.ballLoop
        move.l  (a1)+,d0		        ; Any ball in this slot?
        beq.w   .doneBall

        move.l	d0,a0

        move.w  hBallSpeedLevel(a0),d2          ; Reached max speed?
        cmp.w   #MaxBallSpeedLevel,d2
        beq.s   .doneBall

        ; tst.b   BallZeroOnBat
        ; beq.s   .exit

        addq.w  #1,d2
        move.w  d2,hBallSpeedLevel(a0)

        lsl.w   #1,d2                           ; Word addressing in subroutine
        ; X component
        move.w  hSprBobXCurrentSpeed(a0),d0
        bsr     GetNextSpeedForSpeedComponent
        move.w  d3,hSprBobXCurrentSpeed(a0)
        ; Y component
        move.w  hSprBobYCurrentSpeed(a0),d0
        bsr     GetNextSpeedForSpeedComponent
        move.w  d3,hSprBobYCurrentSpeed(a0)

.doneBall
        dbf     d6,.ballLoop

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


MoveBall0ToOwner:
        lea	Ball0,a0
	move.l	hPlayerBat(a0),a1

	cmpa.l	#Bat0,a1
	bne.s	.bat1

	move.w  BallSpeedLevel369,hSprBobXSpeed(a0)	; Set speed, awaiting release
	neg.w	hSprBobXSpeed(a0)
	move.w  BallSpeedLevel123,hSprBobYSpeed(a0)
	neg.w	hSprBobYSpeed(a0)

        move.w  hSprBobTopLeftXPos(a1),d0
        sub.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1
        addi.w  #$d,d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1
        move.w  d1,hSprBobBottomRightYPos(a0)

.bat1
	cmpa.l	#Bat1,a1
	bne.s	.bat2

	move.w	BallSpeedLevel369,hSprBobXSpeed(a0)	; Set speed, awaiting release
	move.w	BallSpeedLevel123,hSprBobYSpeed(a0)

        move.w  hSprBobBottomRightXPos(a1),d0
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1
        addi.w  #$f,d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1
        move.w  d1,hSprBobBottomRightYPos(a0)
.bat2
	cmpa.l	#Bat2,a1
	bne.s	.bat3

        move.w	BallSpeedLevel123,hSprBobXSpeed(a0)	; Set speed, awaiting release
	move.w	BallSpeedLevel369,hSprBobYSpeed(a0)
	neg.w	hSprBobYSpeed(a0)

        move.w  hSprBobTopLeftXPos(a1),d0
        move.w  hSprBobWidth(a1),d1
        lsr.w   d1
        add.w  d1,d0
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1
        sub.w	hSprBobHeight(a0),d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1
        move.w  d1,hSprBobBottomRightYPos(a0)
.bat3
	cmpa.l	#Bat3,a1
	bne.s	.exit

	move.w	BallSpeedLevel123,hSprBobXSpeed(a0)	; Set speed, awaiting release
	neg.w	hSprBobXSpeed(a0)
	move.w	BallSpeedLevel369,hSprBobYSpeed(a0)

        move.w  hSprBobTopLeftXPos(a1),d0
        move.w  hSprBobWidth(a1),d1
        lsr.w   d1
        add.w  d1,d0
	subq	#6,d0					; Adjust relative ball position
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobBottomRightYPos(a1),d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1
        move.w  d1,hSprBobBottomRightYPos(a0)
.exit
        rts