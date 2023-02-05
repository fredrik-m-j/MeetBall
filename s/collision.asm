; Collision detection

CheckCollisions:
; .vBlank	move.l	$dff004,d0	        ; Wait for vertical blank before checking collisions
; 	and.l	#$1ff00,d0
; 	cmp.l	#303<<8,d0
; 	bne.b	.vBlank

        ; lea	CUSTOM,a0
	; move.w	CLXDAT(a0),d0           ; Reading CLXDAT bit causes its clearing
	; btst.l	#9,d0                   ; - it is better to copy it to d0 and do the tests on d0
        ; beq.s	.noSpriteCollision

        tst.b   BallZeroOnBat
        beq.s   .exit

        move.l  AllBalls,d7
        lea     AllBalls+4,a2

.ballLoop
        move.l  (a2)+,d0		; Any ball in this slot?
	beq.s   .doneBall

	move.l	d0,a0

        tst.b	Player0Enabled
	bmi.s	.isPlayer1Enabled
        lea.l   Bat0,a1
        bsr     CheckBat
        tst.w   d1
        beq.w   Bat0Collision

.isPlayer1Enabled
        tst.b	Player1Enabled
	bmi.s	.isPlayer2Enabled
        lea.l   Bat1,a1
        bsr     CheckBat
        tst.w   d1
        beq.w   Bat1Collision

.isPlayer2Enabled
        tst.b	Player2Enabled
	bmi.s	.isPlayer3Enabled
        lea.l   Bat2,a1
        bsr     CheckBat
        tst.w   d1
        beq.w   Bat2Collision

.isPlayer3Enabled
        tst.b	Player3Enabled
	bmi.s	.otherCollisions
        lea.l   Bat3,a1
        bsr     CheckBat
        tst.w   d1
        beq.w   Bat3Collision

.otherCollisions
        bsr     CheckBallToBrickCollision

.doneBall
        dbf    d7,.ballLoop

.exit
        rts

; Checks for ball-bat collision.
; In:	a0 = adress to ball
; In:	a1 = adress to bat
; Out:  d1 = Returns 0 if collision
CheckBat:
        move.l  hBallTopLeftXPos(a0),d0         ; Ball TopLeft x,y coord-pairs
        move.l  hSprBobBottomRightXPos(a1),d3   ; Bat BottomRight x,y coord-pairs
        
        moveq #0,d5
        add.w   hBallWidth(a0),d5
        add.w   hSprBobWidth(a1),d5
        neg.w   d5

        moveq #0,d6
        add.w   hBallHeight(a0),d6
        add.w   hSprBobHeight(a1),d6
        neg.w   d6

        bsr     CheckBoundingBoxes

        rts


; Checks collision with brick based on "foremost" screen coordinates where ball is moving.
; In:   a0 = address to ball structure
CheckBallToBrickCollision:
        moveq   #0,d0
        moveq   #0,d1
        moveq   #0,d2                           ; Precaution
        moveq   #0,d3
        moveq   #0,d4

.checkXMovement
        tst.w   hBallXCurrentSpeed(a0)
        bmi.s   .movingLeft
.movingRight
        move.w  hBallBottomRightXPos(a0),d0
        move.w  d0,d2
        subq    #3,d2                           ; Where is ball x middle?
        bra.s   .checkYMovement
.movingLeft
        move.w  hBallTopLeftXPos(a0),d0
        move.w  d0,d2
        addq    #3,d2                           ; Where is ball x middle?

.checkYMovement
        tst.w   hBallYCurrentSpeed(a0)
        bmi.s   .movingUp
.movingDown
        move.w  hBallBottomRightYPos(a0),d1
        move.w  d1,d3
        subq    #3,d3                           ; Where is ball y middle?
        bra.s   .checkForCollision
.movingUp
        move.w  hBallTopLeftYPos(a0),d1
        move.w  d1,d3
        addq    #3,d3                           ; Where is ball y middle?

.checkForCollision
        move.w  d0,d5                           ; Save x,y coordinates for later
        bmi.w   .exit                           ; Outside GAMEAREA
        move.w  d1,d6
        bmi.w   .exit                           ; Outside GAMEAREA

        lsr.w   #3,d0                           ; Which game area column is extreme ball x?
        lsr.w   #3,d2                           ; Which game area column is middle ball x?
        lsr.w   #3,d1                           ; Which game area row is extreme ball y?
        lsr.w   #3,d3                           ; Which game area row is middle ball y?

        move.w  d3,d4                           ; Lookup middle Y tile
        mulu.w  #41,d4                          ; 41 bytes in each game area row
        add.w   d0,d4
        lea	1+GAMEAREA,a3                   ; +1 to skip empty column 0
        add.l   d4,a3

        move.w  d1,d4                           ; Lookup middle X tile
        mulu.w  #41,d4
        add.w   d2,d4
        lea	1+GAMEAREA,a4
        add.l   d4,a4

        tst.b   (a3)
        bne.s   .xCollision
        tst.b   (a4)
        bne.s   .xCollision

        bra   .exit

.xCollision
        tst.b   (a3)                            ; Extreme X, Middle Y collided?
        beq.s   .yCollision

        move.l  a3,a5
        bsr     UpdatePlayerTileScore           ; X collision confirmed!
        bsr     CheckRemoveBrick

        neg.w   hBallXCurrentSpeed(a0)          ; Let's bounce!
        bmi.s   .subRemainderX
.addRemainderX
        and.w   #$0007,d5                       ; Get X remainder "ball in brick"
        beq.s   .yCollision

        moveq   #7,d0
        sub.w   d5,d0
        add.w   d0,d0                           ; Double remainder so that it looks like ball bounced on brick surface
        add.w   d0,hBallTopLeftXPos(a0)
        add.w   d0,hBallBottomRightXPos(a0)
        bra.s   .yCollision
.subRemainderX
        and.w   #$0007,d5                       ; Get X remainder "ball in brick"
        beq.s   .yCollision
        
        add.w   d5,d5                           ; Double remainder so that it looks like ball bounced on brick surface
        sub.w   d5,hBallTopLeftXPos(a0)
        sub.w   d5,hBallBottomRightXPos(a0)

.yCollision
        tst.b   (a4)                            ; Middle X, Extreme Y collided?
	beq.s   .exit

        move.l  a4,a5
        bsr     UpdatePlayerTileScore           ; Y collision confirmed!
        bsr     CheckRemoveBrick

	neg.w   hBallYCurrentSpeed(a0)          ; Let's bounce!
        bmi.s   .subRemainderY
.addRemainderY
        and.w   #$0007,d6                       ; Get Y remainder "ball in brick"
        beq.s   .exit

        moveq   #7,d0
        sub.w   d6,d0
        add.w   d0,d0                           ; Double remainder so that it looks like ball bounced on brick surface
        add.w   d0,hBallTopLeftYPos(a0)
        add.w   d0,hBallBottomRightYPos(a0)
        bra.s   .exit
.subRemainderY
        and.w   #$0007,d6                       ; Get Y remainder "ball in brick"
        beq.s   .exit

        add.w   d6,d6                           ; Double remainder so that it looks like ball bounced on brick surface
        sub.w   d6,hBallTopLeftYPos(a0)
        sub.w   d6,hBallBottomRightYPos(a0)

.exit
        rts

; CREDITS
; Collision checking using bounding boxes
; Author:	John Girvin (nivrig)
;               https://nivrig.com
;		https://gist.github.com/johngirvin/75da8854aa91052e08956e9e558f2dca
; 68000 2xCMP AABB check between box A and B
; December 2021 vgn: Some fixes and modifications to suit my needs.
;
; In:	d0 = ax,ay      x,y coordinates of top-left of A
; In:	d3 = bx,by      x,y coordinates of bottom-right of B
; In:	d5 = -(aw+bw)   -(A width + B width)
; In:	d6 =-(ah+bh)   -(A height + B height)
; Out:  d1 = Returns 0 if collision
CheckBoundingBoxes:
        moveq   #-1,d1          ;assume no collision

        sub.w   d3,d0           ;d0=ay-by
        cmp.w   d6,d0           ;cmp #-(ah+bh)
        bls     .cd_done        ;Skip if Y out of range

        swap    d0
        swap    d3

        sub.w   d3,d0           ;Get ax-bx in d0
        cmp.w   d5,d0           ;cmp #-(aw+bw)
        bls     .cd_done        ;Skip if X out of range
        
        moveq   #0,d1
.cd_done
        rts


; In:	a0 = adress to ball
; In:	a1 = adress to bat
Bat0Collision:
        move.w  hBallHeight(a0),d0
        lsr.w   #1,d0                           ; Use ball centre Y pos in comarisons
        add.w   hBallTopLeftYPos(a0),d0
        sub.w   hSprBobTopLeftYPos(a1),d0

        cmpi.b  #14,d0
        ble.s   .bounceUp
        cmpi.b  #18,d0
        bhi.s   .bounceDown
        bra     .bounceNeutral

.bounceUp
        cmpi.b  #4,d0
        ble.s   .veryExtraUp
        cmpi.b  #9,d0
        ble.s   .extraUp
        ; Fall through to .up
.up
        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallXCurrentSpeed(a0)

        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallYCurrentSpeed(a0)
        bra     .checkBallPos
.extraUp
        lea     BallSpeedLevel246,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallXCurrentSpeed(a0)
        move.w  d3,hBallYCurrentSpeed(a0)
        bra     .checkBallPos
.veryExtraUp
        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallXCurrentSpeed(a0)
        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceDown
        cmpi.b  #28,d0
        bge.s   .veryExtraDown
        cmpi.b  #23,d0
        bge.s   .extraDown
        ; Fall through to .down
.down
        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallXCurrentSpeed(a0)

        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel
        move.w  d3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraDown
        lea     BallSpeedLevel246,a2
        bsr     LookupBallSpeedForLevel
        move.w  d3,hBallYCurrentSpeed(a0)
        neg.w   d3
        move.w  d3,hBallXCurrentSpeed(a0)
        
        bra.s   .checkBallPos
.veryExtraDown
        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hBallXCurrentSpeed(a0)

        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel
        move.w  d3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceNeutral
        neg.w   hBallXCurrentSpeed(a0)

.checkBallPos
        tst.b   d0                              ; Don't compensate bat-edge collisions
        bmi.s   .exit
        cmpi.b  #33,d0
        bgt.s   .exit

        move.w  hBallBottomRightXPos(a0),d0     ; Check for any excess speed/"ball inside bat"
        sub.w   hSprBobTopLeftXPos(a1),d0       ; Any excess is a positive number
        beq     .exit

        sub.w   d0,hBallTopLeftXPos(a0)         ; New X position with compensation for excess speed
        sub.w   d0,hBallBottomRightXPos(a0)
.exit
        bsr     SetBallColor
        move.l  a1,hBallPlayerBat(a0)
        move.l  #Player0Score,hBallPlayerScore(a0)      ; Player0 gets score from ball collisions

        move.l	a0,-(sp)
        lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
        move.l	(sp)+,a0

        rts

; In:	a0 = adress to ball
; In:	a1 = adress to bat
Bat1Collision:
        move.w  hBallHeight(a0),d0
        lsr.w   #1,d0                           ; Use ball centre Y pos in comarisons
        add.w   hBallTopLeftYPos(a0),d0
        sub.w   hSprBobTopLeftYPos(a1),d0

        cmpi.b  #14,d0
        ble.s   .bounceUp
        cmpi.b  #18,d0
        bhi.s   .bounceDown
        bra.s   .bounceNeutral

.bounceUp
        cmpi.b  #4,d0
        ble.s   .veryExtraUp
        cmpi.b  #9,d0
        ble.s   .extraUp
        ; Fall through to .up
.up
        move.w  #3,hBallXCurrentSpeed(a0)
        move.w  #-1,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraUp
        move.w  #2,hBallXCurrentSpeed(a0)
        move.w  #-2,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.veryExtraUp
        move.w  #1,hBallXCurrentSpeed(a0)
        move.w  #-3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceDown
        cmpi.b  #28,d0
        bge.s   .veryExtraDown
        cmpi.b  #23,d0
        bge.s   .extraDown
        ; Fall through to .down
.down
        move.w  #3,hBallXCurrentSpeed(a0)
        move.w  #1,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraDown
        move.w  #2,hBallXCurrentSpeed(a0)
        move.w  #2,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.veryExtraDown
        move.w  #1,hBallXCurrentSpeed(a0)
        move.w  #3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceNeutral
        neg.w   hBallXCurrentSpeed(a0)

.checkBallPos
        tst.b   d0                              ; Don't compensate bat-edge collisions
        bmi.s   .exit
        cmpi.b  #33,d0
        bgt.s   .exit

        move.w  hSprBobBottomRightXPos(a1),d0   ; Check for any excess speed/"ball inside bat"
        sub.w   hBallTopLeftXPos(a0),d0         ; Any excess is a positive number
        beq     .exit

        add.w   d0,hBallTopLeftXPos(a0)         ; New X position with compensation for excess speed
        add.w   d0,hBallBottomRightXPos(a0)
.exit
        bsr     SetBallColor
        move.l  a1,hBallPlayerBat(a0)
        move.l  #Player1Score,hBallPlayerScore(a0)      ; Player1 gets score from ball collisions

        move.l	a0,-(SP)
        lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
        move.l	(SP)+,a0

        rts


; In:	a0 = adress to ball
; In:	a1 = adress to bat
Bat2Collision:
        move.w  hBallWidth(a0),d0
        lsr.w   #1,d0                           ; Use ball centre X pos in comarisons
        add.w   hBallTopLeftXPos(a0),d0
        sub.w   hSprBobTopLeftXPos(a1),d0

        cmpi.b  #18,d0
        ble.s   .bounceLeft
        cmpi.b  #22,d0
        bhi.s   .bounceRight
        bra.s   .bounceNeutral

.bounceLeft
        cmpi.b  #5,d0
        ble.s   .veryExtraLeft
        cmpi.b  #10,d0
        ble.s   .extraLeft
        ; Fall through to .left
.left
        move.w  #-1,hBallXCurrentSpeed(a0)
        move.w  #-3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraLeft
        move.w  #-2,hBallXCurrentSpeed(a0)
        move.w  #-2,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.veryExtraLeft
        move.w  #-3,hBallXCurrentSpeed(a0)
        move.w  #-1,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceRight
        cmpi.b  #35,d0
        bge.s   .veryExtraRight
        cmpi.b  #30,d0
        bge.s   .extraRight
        ; Fall through to .right
.right
        move.w  #1,hBallXCurrentSpeed(a0)
        move.w  #-3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraRight
        move.w  #2,hBallXCurrentSpeed(a0)
        move.w  #-2,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.veryExtraRight
        move.w  #3,hBallXCurrentSpeed(a0)
        move.w  #-1,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceNeutral
        neg.w   hBallYCurrentSpeed(a0)

.checkBallPos
        tst.b   d0                              ; Don't compensate bat-edge collisions
        bmi.s   .exit
        cmpi.b  #40,d0
        bgt.s   .exit

        move.w  hBallBottomRightYPos(a0),d0     ; Check for any excess speed/"ball inside bat"
        sub.w   hSprBobTopLeftYPos(a1),d0       ; Any excess is a positive number
        beq     .exit

        sub.w   d0,hBallTopLeftYPos(a0)         ; New Y position with compensation for excess speed
        sub.w   d0,hBallBottomRightYPos(a0)
.exit
        bsr     SetBallColor
        move.l  a1,hBallPlayerBat(a0)
        move.l  #Player2Score,hBallPlayerScore(a0)      ; Player2 gets score from ball collisions

        move.l	a0,-(SP)
        lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
        move.l	(SP)+,a0

        rts


; In:	a0 = adress to ball
; In:	a1 = adress to bat
Bat3Collision:
        move.w  hBallWidth(a0),d0
        lsr.w   #1,d0                           ; Use ball centre X pos in comarisons
        add.w   hBallTopLeftXPos(a0),d0
        sub.w   hSprBobTopLeftXPos(a1),d0

        cmpi.b  #18,d0
        ble.s   .bounceLeft
        cmpi.b  #22,d0
        bhi.s   .bounceRight
        bra.s   .bounceNeutral

.bounceLeft
        cmpi.b  #5,d0
        ble.s   .veryExtraLeft
        cmpi.b  #10,d0
        ble.s   .extraLeft
        ; Fall through to .left
.left
        move.w  #-1,hBallXCurrentSpeed(a0)
        move.w  #3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraLeft
        move.w  #-2,hBallXCurrentSpeed(a0)
        move.w  #2,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.veryExtraLeft
        move.w  #-3,hBallXCurrentSpeed(a0)
        move.w  #1,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceRight
        cmpi.b  #35,d0
        bge.s   .veryExtraRight
        cmpi.b  #30,d0
        bge.s   .extraRight
        ; Fall through to .right
.right
        move.w  #1,hBallXCurrentSpeed(a0)
        move.w  #3,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.extraRight
        move.w  #2,hBallXCurrentSpeed(a0)
        move.w  #2,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos
.veryExtraRight
        move.w  #3,hBallXCurrentSpeed(a0)
        move.w  #1,hBallYCurrentSpeed(a0)
        bra.s   .checkBallPos

.bounceNeutral
        neg.w   hBallYCurrentSpeed(a0)

.checkBallPos
        tst.b   d0                              ; Don't compensate bat-edge collisions
        bmi.s   .exit
        cmpi.b  #40,d0
        bgt.s   .exit

        move.w  hSprBobBottomRightYPos(a1),d0   ; Check for any excess speed/"ball inside bat"
        sub.w   hBallTopLeftYPos(a0),d0         ; Any excess is a positive number
        beq     .exit

        add.w   d0,hBallTopLeftYPos(a0)         ; New Y position with compensation for excess speed
        add.w   d0,hBallBottomRightYPos(a0)
.exit
        bsr     SetBallColor
        move.l  a1,hBallPlayerBat(a0)
        move.l  #Player3Score,hBallPlayerScore(a0)      ; Player3 gets score from ball collisions

        move.l	a0,-(SP)
        lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
        move.l	(SP)+,a0

        rts