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


        move.l  AllBalls,d7
        lea     AllBalls+4,a2

.ballLoop
        move.l  (a2)+,d0		        ; Any ball in this slot?
	beq.s   .doneBall

	move.l	d0,a0

        tst.l   hSprBobXCurrentSpeed(a0)        ; Ball stationary/glued?
        beq.s   .doneBall

        tst.b	Player0Enabled
	bmi.s	.isPlayer1Enabled
        lea     Bat0,a1
        bsr     CheckBoxCollision
        tst.w   d1
        beq.w   VerticalBatCollision

.isPlayer1Enabled
        tst.b	Player1Enabled
	bmi.s	.isPlayer2Enabled
        lea     Bat1,a1
        bsr     CheckBoxCollision
        tst.w   d1
        beq.w   VerticalBatCollision

.isPlayer2Enabled
        tst.b	Player2Enabled
	bmi.s	.isPlayer3Enabled
        lea     Bat2,a1
        bsr     CheckBoxCollision
        tst.w   d1
        beq.w   HorizontalBatCollision

.isPlayer3Enabled
        tst.b	Player3Enabled
	bmi.s	.otherCollisions
        lea     Bat3,a1
        bsr     CheckBoxCollision
        tst.w   d1
        beq.w   HorizontalBatCollision

.otherCollisions
        bsr     CheckBallToBrickCollision
        bsr     CheckBallToShopCollision
        bsr     CheckBallToEnemiesCollision

.doneBall
        dbf    d7,.ballLoop

        bsr     CheckBulletCollision
        bsr     CheckPowerupCollision
.exit
        rts

; Checks for sprite/bob - bat collision.
; In:	a0 = adress to 1st sprite/bob structure
; In:	a1 = adress to 2nd sprite/bob structure
; Out:  d1 = Returns 0 if collision
CheckBoxCollision:
        movem.l d3/d5/d6,-(sp)

        move.l  hSprBobTopLeftXPos(a0),d0       ; Sprite/bob TopLeft x,y coord-pairs
        move.l  hSprBobBottomRightXPos(a1),d3   ; Sprite/bob BottomRight x,y coord-pairs
        
        moveq   #0,d5
        add.w   hSprBobWidth(a0),d5
        add.w   hSprBobWidth(a1),d5
        neg.w   d5

        moveq   #0,d6
        add.w   hSprBobHeight(a0),d6
        add.w   hSprBobHeight(a1),d6
        neg.w   d6

        bsr     CheckBoundingBoxes

        movem.l (sp)+,d3/d5/d6
        rts

; Bat - Powerup checks
CheckPowerupCollision:
	tst.l	Powerup
	beq.w	.exit

        lea	Powerup,a0

	tst.b	Player0Enabled
	bmi.s	.isPlayer1Enabled

        lea	Bat0,a1
        bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .isPlayer1Enabled
        move.b	#0,DirtyPlayer0Score
        bsr     CollectPowerup
        bra.s   .exit
.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat1,a1
        bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .isPlayer2Enabled
        move.b	#0,DirtyPlayer1Score
        bsr     CollectPowerup
        bra.s   .exit
.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer3Enabled

	lea	Bat2,a1
	bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .isPlayer3Enabled
        move.b	#0,DirtyPlayer2Score
        bsr     CollectPowerup
        bra.s   .exit
.isPlayer3Enabled
	tst.b	Player3Enabled
	bmi.s	.exit

	lea	Bat3,a1
	bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .exit
        move.b	#0,DirtyPlayer3Score
        bsr     CollectPowerup
.exit
        rts


CheckBulletCollision:
	move.l	#MaxBulletSlots,d7
	subq.b	#1,d7
	lea	AllBullets,a2
.bulletLoop
	move.l	(a2)+,d0
	beq.w	.nextBullet

	move.l	d0,a0
	
                move.l	#MaxEnemySlots,d6
                subq.b	#1,d6
                lea	AllEnemies,a4
.enemyLoop
                move.l	(a4)+,d0
                beq.w	.noEnemyCollision

                move.l  d0,a1
                bsr     CheckBoxCollision

                tst.w   d1
                bne.w   .noEnemyCollision

                move.l	hPlayerBat(a0),a3
                move.l	hPlayerScore(a3),a3
                move.l  hPlayerScore(a1),d0
                add.l	d0,(a3)			        ; add points
                move.l	#0,DirtyPlayer0Score            ; lazy - set all score-bytes to dirty

                bsr     CopyRestoreFromBobPosToScreen   ; Remove bullet
                move.l  #0,-4(a2)                       ; Remove from AllBullets
                CLEAR_BULLETSTRUCT a0
                subq.b	#1,BulletCount

                move.l  a1,a0
                bsr     CopyRestoreFromBobPosToScreen   ; Remove enemy from screen
                move.l  #0,-4(a4)                       ; Remove from AllEnemies
                subq.b	#1,EnemyCount
                CLEAR_ENEMYSTRUCT a1

                lea	SFX_EXPLODE_STRUCT,a0
                bsr     PlaySample

                bra.s   .exit
.noEnemyCollision
                dbf     d6,.enemyLoop

        moveq   #0,d0                           ; Bullet to GAMEAREA check
        moveq   #0,d1

        move.w  hSprBobTopLeftYPos(a0),d1       ; What GAMEAREA row?
        lsr.w   #3,d1
        lea     GAMEAREA_ROW_LOOKUP,a5
        add.b   d1,d1
        add.b   d1,d1
        add.l   d1,a5
        move.l  (a5),a5                         ; Row found

        move.w  hSprBobTopLeftXPos(a0),d0       ; What GAMEAREA column?
        lsr.w   #3,d0
        add.l   d0,a5                           ; Byte found

        tst.b   (a5)                            ; Collision?
        beq.s   .nextBullet

        bsr     CheckBrickHit

        bsr     CopyRestoreFromBobPosToScreen   ; *something* was hit - remove bullet
        move.l  #0,-4(a2)                       ; Remove from AllBullets
        CLEAR_BULLETSTRUCT a0
        subq.b	#1,BulletCount

.nextBullet
	dbf	d7,.bulletLoop
.exit
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
        tst.w   hSprBobXCurrentSpeed(a0)
        bmi.s   .movingLeft
.movingRight
        move.w  hSprBobBottomRightXPos(a0),d0
        move.w  d0,d2
        subq    #3,d2                           ; Where is ball x middle?
        bra.s   .checkYMovement
.movingLeft
        move.w  hSprBobTopLeftXPos(a0),d0
        move.w  d0,d2
        addq    #3,d2                           ; Where is ball x middle?

.checkYMovement
        tst.w   hSprBobYCurrentSpeed(a0)
        bmi.s   .movingUp
.movingDown
        move.w  hSprBobBottomRightYPos(a0),d1
        move.w  d1,d3
        subq    #3,d3                           ; Where is ball y middle?
        bra.s   .checkForCollision
.movingUp
        move.w  hSprBobTopLeftYPos(a0),d1
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
        bsr     CheckBrickHit                   ; X collision confirmed!

        tst.b   (a5)                            ; Was it removed?
        bne.s   .bounceX
        move.w	hBallEffects(a0),d0
	and.b	#BallBreachEffect,d0
        bne.s   .yCollision

.bounceX
        neg.w   hSprBobXCurrentSpeed(a0)        ; Let's bounce!
        bmi.s   .subRemainderX
.addRemainderX
        and.w   #$0007,d5                       ; Get X remainder "ball in brick"
        beq.s   .yCollision

        moveq   #7,d0
        sub.w   d5,d0
        add.w   d0,d0                           ; Double remainder so that it looks like ball bounced on brick surface
        add.w   d0,hSprBobTopLeftXPos(a0)
        add.w   d0,hSprBobBottomRightXPos(a0)
        bra.s   .yCollision
.subRemainderX
        and.w   #$0007,d5                       ; Get X remainder "ball in brick"
        beq.s   .yCollision
        
        add.w   d5,d5                           ; Double remainder so that it looks like ball bounced on brick surface
        sub.w   d5,hSprBobTopLeftXPos(a0)
        sub.w   d5,hSprBobBottomRightXPos(a0)

.yCollision
        tst.b   (a4)                            ; Middle X, Extreme Y collided?
	beq.s   .exit

        move.l  a4,a5
        bsr     CheckBrickHit                   ; Y collision confirmed!

        tst.b   (a5)                            ; Was it removed?
        bne.s   .bounceY
        move.w	hBallEffects(a0),d0
	and.b	#BallBreachEffect,d0
        bne.s   .exit

.bounceY
	neg.w   hSprBobYCurrentSpeed(a0)        ; Let's bounce!
        bmi.s   .subRemainderY
.addRemainderY
        and.w   #$0007,d6                       ; Get Y remainder "ball in brick"
        beq.s   .exit

        moveq   #7,d0
        sub.w   d6,d0
        add.w   d0,d0                           ; Double remainder so that it looks like ball bounced on brick surface
        add.w   d0,hSprBobTopLeftYPos(a0)
        add.w   d0,hSprBobBottomRightYPos(a0)
        bra.s   .exit
.subRemainderY
        and.w   #$0007,d6                       ; Get Y remainder "ball in brick"
        beq.s   .exit

        add.w   d6,d6                           ; Double remainder so that it looks like ball bounced on brick surface
        sub.w   d6,hSprBobTopLeftYPos(a0)
        sub.w   d6,hSprBobBottomRightYPos(a0)

.exit
        rts

; In:   a0 = address to ball structure
CheckBallToShopCollision:
        tst.b   IsShopOpenForBusiness
        bmi.s   .exit

        lea     ShopBob,a1
        bsr     CheckBoxCollision

        tst.w   d1
        bne.w   .exit

        movem.l	d0-d7/a0-a6,-(sp)               ; Shoppingtime - preserve all registers

        bsr     CreateShopPool
        bsr     EnterShop
        
        lea	ShopBob,a0                      ; Close the shop
	bsr	CopyRestoreFromBobPosToScreen
        move.b  #-1,IsShopOpenForBusiness
        bsr     MoveShop

        movem.l	(sp)+,d0-d7/a0-a6
.exit
        rts

; In:   a0 = address to ball structure
CheckBallToEnemiesCollision:
        move.l  d7,-(sp)

	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a4
.enemyLoop
	move.l	(a4)+,d0
	beq.w	.emptySlot

        move.l  d0,a1
        bsr     CheckBoxCollision

        tst.w   d1
        bne.w   .noCollision

        exg     a0,a1
        bsr     CopyRestoreFromBobPosToScreen
        exg     a0,a1


        tst.w   hSprBobYCurrentSpeed(a0)
        bmi.s   .checkBelow

        move.w  hSprBobTopLeftYPos(a0),d0       ; From above?
        addq.w  #3,d0                           ; Use middle of ball in comparisons
        cmp.w   hSprBobTopLeftYPos(a1),d0
        bls.s   .bounceY
        bra.s   .checkSides
.checkBelow
        move.w  hSprBobBottomRightYPos(a0),d0   ; From below?
        subq.w  #3,d0
        cmp.w   hSprBobBottomRightYPos(a1),d0
        bhs.s   .bounceY
        bra.s   .checkSides
.bounceY
        neg.w   hSprBobYCurrentSpeed(a0)        ; Let's bounce!
.checkSides
        tst.w   hSprBobXCurrentSpeed(a0)
        bpl.s   .checkRight

        move.w  hSprBobTopLeftXPos(a0),d0       ; From left?
        addq.w  #3,d0
        cmp.w   hSprBobBottomRightXPos(a1),d0
        bhs.s   .bounceX
        bra.s   .updateScore
.checkRight
        move.w  hSprBobBottomRightXPos(a0),d0   ; From right?
        subq.w  #3,d0
        cmp.w   hSprBobTopLeftXPos(a1),d0
        bls.s   .bounceX
        bra.s   .updateScore
.bounceX
        neg.w   hSprBobXCurrentSpeed(a0)        ; Let's bounce!


.updateScore
	move.l	hPlayerBat(a0),a3
	move.l	hPlayerScore(a3),a3
        move.l  hPlayerScore(a1),d0
	add.l	d0,(a3)			; add points
        move.l	#0,DirtyPlayer0Score    ; lazy - set all score-bytes to dirty

        CLEAR_ENEMYSTRUCT a1
        move.l  #0,-4(a4)               ; Remove from AllEnemies
        subi.b	#1,EnemyCount

        move.l  a0,-(sp)
        lea	SFX_EXPLODE_STRUCT,a0
	bsr     PlaySample
        move.l  (sp)+,a0

.noCollision
.emptySlot
	dbf	d7,.enemyLoop

        move.l  (sp)+,d7

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
VerticalBatCollision:
        move.w  hSprBobHeight(a0),d3
        lsr.w   #1,d3                           ; Use ball centre Y pos in comarisons
        add.w   hSprBobTopLeftYPos(a0),d3       ; Calculate relative Y pos
        sub.w   hSprBobTopLeftYPos(a1),d3

        lea     hFunctionlistAddress(a1),a2
        move.l  (a2),a2
.batZoneLoop
        move.l  (a2)+,d0
        beq.s   .foundZone

        cmp.b   d0,d3
        ble.s   .foundZone
        addq.l  #4,a2
        bra.s   .batZoneLoop
.foundZone
        move.l  (a2),a2
        jsr	(a2)                            ; Bouncefunction

.checkBallPos
        tst.b   d3                              ; Don't compensate bat-edge collisions
        bmi.s   .updateBall
        cmp.b   hSprBobHeight(a1),d3
        bgt.s   .updateBall

        cmp.l   #Bat0,a1
        bne.s   .bat1

        move.w  hSprBobBottomRightXPos(a0),d3   ; Check for any excess speed/"ball inside bat"
        sub.w   hSprBobTopLeftXPos(a1),d3       ; Any excess is a positive number
        beq.s   .updateBall
        sub.w   d3,hSprBobTopLeftXPos(a0)       ; New X position with compensation for excess speed
        sub.w   d3,hSprBobBottomRightXPos(a0)
.bat1
        move.w  hSprBobBottomRightXPos(a1),d3   ; Check for any excess speed/"ball inside bat"
        sub.w   hSprBobTopLeftXPos(a0),d3       ; Any excess is a positive number
        beq     .updateBall
        add.w   d3,hSprBobTopLeftXPos(a0)       ; New X position with compensation for excess speed
        add.w   d3,hSprBobBottomRightXPos(a0)

.updateBall
        bsr     SetBallColor
        move.l  a1,hPlayerBat(a0)               ; Update ballowner

        move.l	a0,-(sp)
        lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
        move.l	(sp)+,a0

.checkGlue
	move.w	hBatEffects(a1),d0
	and.b	#BatGlueEffect,d0
        beq.s   .exit

        move.w  hSprBobXCurrentSpeed(a0),hSprBobXSpeed(a0)      ; Store for later ball release
        move.w  hSprBobYCurrentSpeed(a0),hSprBobYSpeed(a0)
        move.w  #0,hSprBobXCurrentSpeed(a0)
        move.w  #0,hSprBobYCurrentSpeed(a0)
.exit
        rts

; In:	a0 = adress to ball
; In:	a1 = adress to bat
VertBounceVeryExtraUp:
        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d3
.setX
        move.w  d3,hSprBobXCurrentSpeed(a0)
        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
VertBounceExtraUp:
        lea     BallSpeedLevel246,a2
        bsr     LookupBallSpeedForLevel

        neg.w   d3
        move.w  d3,hSprBobYCurrentSpeed(a0)

        cmp.l   #Bat1,a1
        bne.s   .setX
        neg.w   d3
.setX
        move.w  d3,hSprBobXCurrentSpeed(a0)
        rts
VertBounceUp:
        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d3
.setX
        move.w  d3,hSprBobXCurrentSpeed(a0)

        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel
        neg.w   d3
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
VertBounceNeutral:
        neg.w   hSprBobXCurrentSpeed(a0)
        rts
VertBounceDown:
        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d3
.setX
        move.w  d3,hSprBobXCurrentSpeed(a0)

        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
VertBounceExtraDown:
        lea     BallSpeedLevel246,a2
        bsr     LookupBallSpeedForLevel
        move.w  d3,hSprBobYCurrentSpeed(a0)

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d3
.setX
        move.w  d3,hSprBobXCurrentSpeed(a0)
        rts
VertBounceVeryExtraDown:
        lea     BallSpeedLevel123,a2
        bsr     LookupBallSpeedForLevel

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d3
.setX
        move.w  d3,hSprBobXCurrentSpeed(a0)

        lea     BallSpeedLevel369,a2
        bsr     LookupBallSpeedForLevel
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts


; In:	a0 = adress to ball
; In:	a1 = adress to bat
HorizontalBatCollision:
        move.w  hSprBobWidth(a0),d3
        lsr.w   #1,d3                           ; Use ball centre X pos in comparisons
        add.w   hSprBobTopLeftXPos(a0),d3
        sub.w   hSprBobTopLeftXPos(a1),d3

        lea     hFunctionlistAddress(a1),a2
        move.l  (a2),a2
.batZoneLoop
        move.l  (a2)+,d0
        beq.s   .foundZone

        cmp.b   d0,d3
        ble.s   .foundZone
        addq.l  #4,a2
        bra.s   .batZoneLoop
.foundZone
        move.l  (a2),a2
        jsr	(a2)                            ; Bouncefunction

.checkBallPos
        tst.b   d3                              ; Don't compensate bat-edge collisions
        bmi.s   .updateBall
        cmp.b   hSprBobWidth(a1),d3
        bgt.s   .updateBall

        cmp.l   #Bat2,a1
        bne.s   .bat3

        move.w  hSprBobBottomRightYPos(a0),d3   ; Check for any excess speed/"ball inside bat"
        sub.w   hSprBobTopLeftYPos(a1),d3       ; Any excess is a positive number
        beq     .updateBall
        sub.w   d3,hSprBobTopLeftYPos(a0)       ; New Y position with compensation for excess speed
        sub.w   d3,hSprBobBottomRightYPos(a0)
.bat3
        move.w  hSprBobBottomRightYPos(a1),d3   ; Check for any excess speed/"ball inside bat"
        sub.w   hSprBobTopLeftYPos(a0),d3       ; Any excess is a positive number
        beq     .updateBall
        add.w   d3,hSprBobTopLeftYPos(a0)       ; New Y position with compensation for excess speed
        add.w   d3,hSprBobBottomRightYPos(a0)

.updateBall
        bsr     SetBallColor
        move.l  a1,hPlayerBat(a0)               ; Update ballowner

        move.l	a0,-(sp)
        lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
        move.l	(sp)+,a0

.checkGlue
	move.w	hBatEffects(a1),d0
	and.b	#BatGlueEffect,d0
        beq.s   .exit

        move.w  hSprBobXCurrentSpeed(a0),hSprBobXSpeed(a0)      ; Store for later ball release
        move.w  hSprBobYCurrentSpeed(a0),hSprBobYSpeed(a0)
        move.w  #0,hSprBobXCurrentSpeed(a0)
        move.w  #0,hSprBobYCurrentSpeed(a0)
.exit
        rts

; In:	a0 = adress to ball
; In:	a1 = adress to bat
HorizBounceVeryExtraLeft:
        move.w  #-3,hSprBobXCurrentSpeed(a0)
        moveq   #1,d3

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d3
.setY
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceExtraLeft:
        move.w  #-2,hSprBobXCurrentSpeed(a0)
        moveq   #2,d3

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d3
.setY
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceLeft:
        move.w  #-1,hSprBobXCurrentSpeed(a0)
        moveq   #3,d3

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d3
.setY
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceNeutral:
        neg.w   hSprBobYCurrentSpeed(a0)
        rts
HorizBounceRight:
        move.w  #1,hSprBobXCurrentSpeed(a0)
        moveq   #3,d3

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d3
.setY
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceExtraRight:
        move.w  #2,hSprBobXCurrentSpeed(a0)
        moveq   #2,d3

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d3
.setY
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceVeryExtraRight:
        move.w  #3,hSprBobXCurrentSpeed(a0)
        moveq   #1,d3

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d3
.setY
        move.w  d3,hSprBobYCurrentSpeed(a0)
        rts