; Collision detection

; Retries are needed for edge cases.
CollisionRetries:      dc.b    -1
        even

; Collision-handling for moving objects.
CheckCollisions:
        movem.l d7/a3,-(sp)

        move.l  AllBalls,d7
        lea     AllBalls+hAllBallsBall0,a3

.ballLoop
        move.l  (a3)+,d0		        ; Any ball in this slot?
	beq.w   .doneBall

	move.l	d0,a2

        tst.l   hSprBobXCurrentSpeed(a2)        ; Ball stationary/glued?
        beq.w   .doneBall

        tst.b	Player0Enabled
	bmi	.isPlayer1Enabled
        lea     Bat0,a1
        bsr     CheckBallBoxCollision
        tst.b   d1
        bne     .isPlayer1Enabled

        bsr     VerticalBatCollision
        move.b  #AFTERBATHIT_COUNT,Player0AfterHitCount
        move.l  a2,Player0AfterHitBall
        bra     .otherCollisions

.isPlayer1Enabled
        tst.b	Player1Enabled
	bmi	.isPlayer2Enabled
        lea     Bat1,a1
        bsr     CheckBallBoxCollision
        tst.b   d1
        bne     .isPlayer2Enabled

        bsr     VerticalBatCollision
        move.b  #AFTERBATHIT_COUNT,Player1AfterHitCount
        move.l  a2,Player1AfterHitBall
        bra     .otherCollisions

.isPlayer2Enabled
        tst.b	Player2Enabled
	bmi	.isPlayer3Enabled
        lea     Bat2,a1
        bsr     CheckBallBoxCollision
        tst.b   d1
        bne     .isPlayer3Enabled

        bsr     HorizontalBatCollision
        move.b  #AFTERBATHIT_COUNT,Player2AfterHitCount
        move.l  a2,Player2AfterHitBall
        bra     .otherCollisions

.isPlayer3Enabled
        tst.b	Player3Enabled
	bmi	.otherCollisions
        lea     Bat3,a1
        bsr     CheckBallBoxCollision
        tst.b   d1
        bne     .otherCollisions

        bsr     HorizontalBatCollision
        move.b  #AFTERBATHIT_COUNT,Player3AfterHitCount
        move.l  a2,Player3AfterHitBall

.otherCollisions
        tst.l   hSprBobXCurrentSpeed(a2)        ; Was caught on batglue?
        beq     .doneBall

        move.b  #6,CollisionRetries            ; No point retrying after moving ball back > 7 times
.retry
        bsr     CheckBallToBrickCollision
        tst.b   d0
        beq.s   .ok
        bsr     MoveBallBack
        bra.s   .retry
.ok
        tst.b   IsShopOpenForBusiness
        bmi.s   .enemies
        bsr     CheckBallToShopCollision
.enemies
        tst.w   EnemyCount
        beq.w   .doneBall
        bsr     CheckBallToEnemiesCollision

.doneBall
        dbf    d7,.ballLoop


        tst.b   BulletCount
        beq.s   .powerup
        bsr     CheckBulletCollision
.powerup
	tst.l	Powerup
	beq.s	.exit
        bsr     CheckPowerupCollision
.exit
        movem.l (sp)+,d7/a3
        rts

; Checks for sprite/bob - bat collision.
; In:	a1 = adress to 2nd sprite/bob structure
; In:	a2 = adress to ball sprite/bob structure
; Out:  d1.b = Returns 0 if collision, -1 if not
CheckBallBoxCollision:
        movem.l d3/d5/d6,-(sp)

        moveq   #-1,d1                          ; Assume no collision

        move.w  hSprBobTopLeftXPos(a2),d0
        bpl     .xOk                            ; Ball leaving left side of screen?
        add.w   #(BallDiameter-3)*VC_FACTOR,d0
        bmi     .exit                           ; Ball too far off-screen
        move.w   #0,d0
.xOk
        lsr.w   #VC_POW,d0                      ; Translate to screen-coords

        cmp.w   #DISP_WIDTH-2,d0                ; Ball leaving right side of screen?
        bhs     .exit

        swap    d0
        move.w  hSprBobTopLeftYPos(a2),d0
        bpl     .yOk                            ; Ball leaving top of screen?
        add.w   #(BallDiameter-3)*VC_FACTOR,d0
        bmi     .exit                           ; Ball too far off-screen
        move.w   #0,d0
.yOk
        lsr.w   #VC_POW,d0                      ; Translate to screen-coords

        cmp.b   #DISP_HEIGHT-2,d0               ; Ball leaving bottom of screen?
        bhs     .exit

        move.l  hSprBobBottomRightXPos(a1),d3   ; Sprite/bob BottomRight x,y coord-pairs
        
        moveq   #0,d5
        add.w   hSprBobWidth(a2),d5
        add.w   hSprBobWidth(a1),d5
        neg.w   d5

        moveq   #0,d6
        add.w   hSprBobHeight(a2),d6
        add.w   hSprBobHeight(a1),d6
        neg.w   d6

        bsr     CheckBoundingBoxes
.exit
        movem.l (sp)+,d3/d5/d6
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
        lea	Powerup,a0

	tst.b	Player0Enabled
	bmi.s	.isPlayer1Enabled

        lea	Bat0,a1
        bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .isPlayer1Enabled
        clr.b	DirtyPlayer0Score
        bsr     CollectPowerup
        bra.s   .exit
.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat1,a1
        bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .isPlayer2Enabled
        clr.b	DirtyPlayer1Score
        bsr     CollectPowerup
        bra.s   .exit
.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer3Enabled

	lea	Bat2,a1
	bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .isPlayer3Enabled
        clr.b	DirtyPlayer2Score
        bsr     CollectPowerup
        bra.s   .exit
.isPlayer3Enabled
	tst.b	Player3Enabled
	bmi.s	.exit

	lea	Bat3,a1
	bsr     CheckBoxCollision
        tst.w   d1
        bne.s   .exit
        clr.b	DirtyPlayer3Score
        bsr     CollectPowerup
.exit
        rts


CheckBulletCollision:
        lea 	CUSTOM,a6
	moveq	#MaxBulletSlots-1,d7
	lea	AllBullets,a2
.bulletLoop
	move.l	(a2)+,d0
	beq.w	.nextBullet

	move.l	d0,a0
	
                move.w	EnemyCount,d6
                beq     .doneEnemies

                subq.w	#1,d6
                lea	FreeEnemyStack,a4
.enemyLoop
                move.l	(a4)+,a1

                cmpi.w  #eSpawned,hEnemyState(a1)
                bne.w   .noEnemyCollision

                bsr     CheckBoxCollision

                tst.w   d1
                bne.w   .noEnemyCollision

                move.l	hPlayerBat(a0),a3
                move.l	hPlayerScore(a3),a3
                move.l  hPlayerScore(a1),d0
                add.l	d0,(a3)			        ; add points
                bsr     SetDirtyScore

                bsr     CopyRestoreFromBobPosToScreen   ; Remove bullet
                clr.l   -4(a2)                          ; Remove from AllBullets
                CLEAR_BULLETSTRUCT a0
                subq.b	#1,BulletCount

                move.l  a1,a0
                bsr     CopyRestoreFromBobPosToScreen   ; Remove enemy from screen

                move.w  #eExploding,hEnemyState(a1)
                move.l  #ExplosionAnimMap,hSpriteAnimMap(a1)
                clr.b   hIndex(a1)
                move.b  #ExplosionFrameCount,hLastIndex(a1)

                lea	SFX_EXPLODE_STRUCT,a0
                jsr     PlaySample

                bra.s   .exit
.noEnemyCollision
                dbf     d6,.enemyLoop

.doneEnemies
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

        movem.l a0/a2,-(sp)                     ; TODO: Make all sprbob-blitting be done with a2 as input
        move.l  a0,a2
        bsr     CheckBrickHit
        movem.l (sp)+,a0/a2

        bsr     CopyRestoreFromBobPosToScreen   ; *something* was hit - remove bullet
        clr.l   -4(a2)                          ; Remove from AllBullets
        CLEAR_BULLETSTRUCT a0
        subq.b	#1,BulletCount

.nextBullet
	dbf	d7,.bulletLoop
.exit
        rts

; Checks collision with brick based on "foremost" screen coordinates where ball is moving.
; In:   a2 = address to ball structure
; Out:  d0 = Negative if collision was inconclusive
CheckBallToBrickCollision:
        movem.l d2-d4/a3-a4,-(sp)

        moveq   #0,d0
        moveq   #0,d1
        moveq   #0,d2                           ; Precaution
        moveq   #0,d3
        moveq   #0,d4

.checkXMovement
        tst.w   hSprBobXCurrentSpeed(a2)
        bmi.s   .movingLeft
.movingRight
        move.w  hSprBobBottomRightXPos(a2),d0
        lsr.w   #VC_POW,d0                      ; Translate to screen-coord
        move.w  d0,d2
        subq.w  #3,d2                           ; Where is ball x middle?
        bra.s   .checkYMovement
.movingLeft
        move.w  hSprBobTopLeftXPos(a2),d0       ; Leaving GAMEAREA?
        bmi.w   .exit
        lsr.w   #VC_POW,d0                      ; Translate to screen-coord
        move.w  d0,d2
        addq.w  #3,d2                           ; Where is ball x middle?

.checkYMovement
        tst.w   hSprBobYCurrentSpeed(a2)
        bmi.s   .movingUp
.movingDown
        move.w  hSprBobBottomRightYPos(a2),d1
        lsr.w   #VC_POW,d1                      ; Translate to screen-coord
        move.w  d1,d3
        subq.w  #3,d3                           ; Where is ball y middle?
        bra.s   .checkForCollision
.movingUp
        move.w  hSprBobTopLeftYPos(a2),d1       ; Leaving GAMEAREA?
        bmi.w   .exit
        lsr.w   #VC_POW,d1                      ; Translate to screen-coord
        move.w  d1,d3
        addq.w  #3,d3                           ; Where is ball y middle?

.checkForCollision
        move.w  d0,d5                           ; Save x,y coordinates for later
        bmi.w   .exit                           ; Outside GAMEAREA
        move.w  d1,d6
        bmi.w   .exit                           ; Outside GAMEAREA

        lsr.w   #3,d0                           ; Which game area column is extreme ball x?
        lsr.w   #3,d2                           ; Which game area column is middle ball x?
        lsr.w   #3,d1                           ; Which game area row is extreme ball y?
        lsr.w   #3,d3                           ; Which game area row is middle ball y?

        ; Lookup middle Y tile
        move.w  d3,d4                           ; Lookup middle Y row
        add.b   d4,d4
        add.b   d4,d4
        lea     GAMEAREA_ROW_LOOKUP,a3
        add.l   d4,a3
        move.l  (a3),a3                         ; Row found
        add.l   d0,a3                           ; # Add extreme x

        ; Lookup middle X tile
        move.w  d1,d4                           ; # Find row of extreme Y
        add.b   d4,d4
        add.b   d4,d4
        lea     GAMEAREA_ROW_LOOKUP,a4
        add.l   d4,a4
        move.l  (a4),a4                         ; Row found
        add.l   d2,a4                           ; Add middle X

        tst.b   (a3)
        bne.s   .checkHispeedCollision
        tst.b   (a4)
        bne.s   .checkHispeedCollision

        bra   .exit

.checkHispeedCollision                          ; Edgecase: Hispeed collision
        tst.b   (a3)                            ; Inconclusive collision in both sample points?
        beq.w   .collision
        tst.b   (a4)
        beq.w   .collision

        tst.b   CollisionRetries
        bmi.s   .resolveHispeed
        subq.b  #1,CollisionRetries

        moveq   #-1,d0                          ; INCONCLUSIVE
        bra     .fastExit

.resolveHispeed
        ; Multiple attempts was made - ball is probably coming in diagonally
        move.l  a3,a5
        bsr     CheckBrickHit

        tst.b   (a5)                            ; Was it removed?
        bne.s   .hispeedBounce
        move.w	hBallEffects(a2),d0
	and.b	#BallBreachEffect,d0
        bne.s   .hispeedCollisionExit
.hispeedBounce
	neg.w   hSprBobXCurrentSpeed(a2)        ; Actual *corner* case let's bounce diagonally!
        neg.w   hSprBobYCurrentSpeed(a2)

        ; Also move X and Y 1 pixel towards middle of screen
        cmp.w   #DISP_WIDTH*VC_FACTOR/2,hSprBobTopLeftXPos(a2)
        blo     .moveToPosX
        sub.w   #1*VC_FACTOR,hSprBobTopLeftXPos(a2)
        bra     .hispeedMoveToCenterY
.moveToPosX
        add.w   #1*VC_FACTOR,hSprBobTopLeftXPos(a2)
.hispeedMoveToCenterY
        cmp.w   #DISP_HEIGHT*VC_FACTOR/2,hSprBobTopLeftYPos(a2)
        blo     .moveToPosY
        sub.w   #1*VC_FACTOR,hSprBobTopLeftYPos(a2)
        bra     .exit                           ; Consider it resolved
.moveToPosY
        add.w   #1*VC_FACTOR,hSprBobTopLeftYPos(a2)
        bra     .exit                           ; Consider it resolved

.hispeedCollisionExit
        bra     .fastExit

.collision
        tst.b   (a3)                            ; Extreme X, Middle Y collided?
        beq.s   .yCollision

        move.l  a3,a5
        bsr     CheckBrickHit                   ; X collision confirmed!

        tst.b   (a5)                            ; Was it removed?
        bne.s   .bounceX
        move.w	hBallEffects(a2),d0
	and.b	#BallBreachEffect,d0
        bne.s   .yCollision

.bounceX
        neg.w   hSprBobXCurrentSpeed(a2)        ; Let's bounce!
        bmi.s   .subRemainderX
.addRemainderX
        and.w   #$0007,d5                       ; Get X remainder "ball in brick"
        beq.s   .yCollision

        moveq   #7,d0
        sub.w   d5,d0
        add.w   d0,d0                           ; Double remainder so that it looks like ball bounced on brick surface
        lsl.w   #VC_POW,d0                      ; Translate to virtual coord
        add.w   d0,hSprBobTopLeftXPos(a2)
        add.w   d0,hSprBobBottomRightXPos(a2)
        bra.s   .yCollision
.subRemainderX
        and.w   #$0007,d5                       ; Get X remainder "ball in brick"
        beq.s   .yCollision
        
        add.w   d5,d5                           ; Double remainder so that it looks like ball bounced on brick surface
        lsl.w   #VC_POW,d5                      ; Translate to virtual coord
        sub.w   d5,hSprBobTopLeftXPos(a2)
        sub.w   d5,hSprBobBottomRightXPos(a2)

.yCollision
        tst.b   (a4)                            ; Middle X, Extreme Y collided?
	beq.s   .exit

        move.l  a4,a5
        bsr     CheckBrickHit                   ; Y collision confirmed!

        tst.b   (a5)                            ; Was it removed?
        bne.s   .bounceY
        move.w	hBallEffects(a2),d0
	and.b	#BallBreachEffect,d0
        bne.s   .exit

.bounceY
	neg.w   hSprBobYCurrentSpeed(a2)        ; Let's bounce!
        bmi.s   .subRemainderY
.addRemainderY
        and.w   #$0007,d6                       ; Get Y remainder "ball in brick"
        beq.s   .exit

        moveq   #7,d0
        sub.w   d6,d0
        add.w   d0,d0                           ; Double remainder so that it looks like ball bounced on brick surface
        lsl.w   #VC_POW,d0                      ; Translate to virtual coord
        add.w   d0,hSprBobTopLeftYPos(a2)
        add.w   d0,hSprBobBottomRightYPos(a2)
        bra.s   .exit
.subRemainderY
        and.w   #$0007,d6                       ; Get Y remainder "ball in brick"
        beq.s   .exit

        add.w   d6,d6                           ; Double remainder so that it looks like ball bounced on brick surface
        lsl.w   #VC_POW,d6                      ; Translate to virtual coord
        sub.w   d6,hSprBobTopLeftYPos(a2)
        sub.w   d6,hSprBobBottomRightYPos(a2)

.exit
        moveq   #0,d0
.fastExit
        movem.l (sp)+,d2-d4/a3-a4
        rts

; In:   a2 = address to ball structure
CheckBallToShopCollision:
        lea     ShopBob,a1
        bsr     CheckBallBoxCollision

        tst.b   d1
        bne     .exit

        move.l  a2,ShopCustomerBall
        move.b  #SHOPPING_STATE,GameState
        ; Shoploop executes from gameloop to let the VBL interrupt finish current frame
.exit
        rts

; In:   a2 = address to ball structure
CheckBallToEnemiesCollision:
        movem.l d2-d3/d7/a3-a4,-(sp)

	move.w	EnemyCount,d7
        beq     .done

	subq.w	#1,d7
	lea	FreeEnemyStack,a4
.enemyLoop
	move.l	(a4)+,a1

        cmpi.w  #eSpawned,hEnemyState(a1)
        bne     .nextEnemy

        bsr     CheckBallBoxCollision

        tst.b   d1
        bne     .nextEnemy

        exg     a0,a1
        bsr     CopyRestoreFromBobPosToScreen   ; Remove enemy from screen
        exg     a0,a1

        move.w	hBallEffects(a2),d0
	and.b	#BallBreachEffect,d0            ; Should ball bounce on enemy?
        bne     .updateScore

        move.l  hSprBobXCurrentSpeed(a2),d0

        tst.w   d0                              ; Y, Ball from above?
        bmi     .fromBelow
        swap    d0
        tst.w   d0                              ; X, Ball from above left?
        bmi     .fromAboveRight
        ; Ball from ABOVE LEFT - Compare ball bottom-right with enemy top-left

        move.l  hSprBobBottomRightXPos(a2),d0   ; Fetch ball position X.w,Y.w
        move.w  d0,d1
        lsr.w   #VC_POW,d1                      ; Y, Translate to screen coord
        swap    d0
        lsr.w   #VC_POW,d0                      ; X, Translate to screen coord

        move.l  hSprBobTopLeftXPos(a1),d2       ; Fetch enemy position X.w,Y.w
        move.w  d2,d3
        swap    d2

        sub.w   d2,d0
        sub.w   d3,d1

        bra     .checkBounce
.fromAboveRight
        ; Compare ball bottom-left with enemy top-right

        move.l  hSprBobBottomRightXPos(a2),d0   ; Fetch ball position X.w,Y.w
        move.w  d0,d1
        lsr.w   #VC_POW,d1                      ; Y, Translate to screen coord
        swap    d0
        lsr.w   #VC_POW,d0                      ; X, Translate to screen coord
        subq.w  #BallDiameter,d0

        move.w  hSprBobBottomRightXPos(a1),d2   ; Fetch enemy position
        move.w  hSprBobTopLeftYPos(a1),d3

        sub.w   d2,d0
        neg.w   d0
        sub.w   d3,d1

        bra     .checkBounce



.fromBelow
        swap    d0
        tst.w   d0                              ; X, Ball from below left?
        bmi     .fromBelowRight
        ; Ball from BELOW LEFT - Compare ball top-right with enemy bottom-left

        move.w  hSprBobBottomRightXPos(a2),d0
        move.w  hSprBobTopLeftYPos(a2),d1
        lsr.w   #VC_POW,d0                      ; X, Translate to screen coord
        lsr.w   #VC_POW,d1                      ; Y, Translate to screen coord

        move.w  hSprBobTopLeftXPos(a1),d2       ; Fetch enemy position
        move.w  hSprBobBottomRightYPos(a1),d3

        sub.w   d2,d0
        sub.w   d3,d1
        neg.w   d1

        bra     .checkBounce
.fromBelowRight
        ; Compare ball top-left with enemy bottom-right

        move.w  hSprBobTopLeftXPos(a2),d0
        move.w  hSprBobTopLeftYPos(a2),d1
        lsr.w   #VC_POW,d0                      ; X, Translate to screen coord
        lsr.w   #VC_POW,d1                      ; Y, Translate to screen coord

        move.w  hSprBobBottomRightXPos(a1),d2   ; Fetch enemy position
        move.w  hSprBobBottomRightYPos(a1),d3

        sub.w   d2,d0
        neg.w   d0
        sub.w   d3,d1
        neg.w   d1

.checkBounce
        ;       X  Y                            ; Which axis has least distance?
        cmp.w   d0,d1
        bhi     .bounceX
        blo     .bounceY

        neg.w   hSprBobYCurrentSpeed(a2)        ; same distance - bounce both X & Y
.bounceX
        neg.w   hSprBobXCurrentSpeed(a2)        ; X, Let's bounce!
        bra     .updateScore
.bounceY
        neg.w   hSprBobYCurrentSpeed(a2)        ; Y, Let's bounce!


.updateScore
	tst.b	InsanoState
	bmi	.normalScore

        bsr     AddInsanoscore
	bra	.explode
.normalScore
	move.l	hPlayerBat(a2),a3       ; TODO: Possibly replace a3 with a0???
	move.l	hPlayerScore(a3),a3
        move.l  hPlayerScore(a1),d0
	add.l	d0,(a3)			; add points
        bsr     SetDirtyScore

.explode
        move.w  #eExploding,hEnemyState(a1)
        move.l  #ExplosionAnimMap,hSpriteAnimMap(a1)
        clr.b   hIndex(a1)
        move.b  #ExplosionFrameCount,hLastIndex(a1)

        lea	SFX_EXPLODE_STRUCT,a0
	jsr     PlaySample

        bra     .done                   ; Assume max 1 collision per frame

.nextEnemy
	dbf	d7,.enemyLoop
.done
        movem.l (sp)+,d2-d3/d7/a3-a4

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
; Out:  d1.b = Returns 0 if collision, -1 if not
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


; In:	a2 = adress to ball
; In:	a1 = adress to bat
VerticalBatCollision:
        move.l  a2,a0   ; Work with ball in a0

        moveq   #3,d1                           ; Use ball centre Y pos in comparisons

        move.w  hSprBobTopLeftYPos(a0),d0
        lsr.w   #VC_POW,d0                      ; Translate to screen-coords
        add.w   d0,d1                           ; Calculate relative Y pos
        sub.w   hSprBobTopLeftYPos(a1),d1

        lea     hFunctionlistAddress(a1),a2
        move.l  (a2),a2
.batZoneLoop
        move.l  (a2)+,d0
        beq.s   .foundZone

        cmp.b   d0,d1
        ble.s   .foundZone
        addq.l  #4,a2
        bra.s   .batZoneLoop
.foundZone
        move.l  (a2),a2
        jsr	(a2)                            ; Bouncefunction

.checkBallPos
        tst.b   d1                              ; Don't compensate bat-edge collisions
        bmi.s   .sfx
        cmp.b   hSprBobHeight(a1),d1
        bgt.s   .sfx

        cmp.l   #Bat0,a1
        bne.s   .bat1

        move.w  hSprBobBottomRightXPos(a0),d1   ; Check for any excess speed/"ball inside bat"
        lsr.w   #VC_POW,d1                      ; Translate to screen-coords
        sub.w   hSprBobTopLeftXPos(a1),d1       ; Any excess is a positive number
        beq.s   .sfx
        lsl.w   #VC_POW,d0                      ; Translate to virtual coords
        sub.w   d1,hSprBobTopLeftXPos(a0)       ; New X position with compensation for excess speed
        sub.w   d1,hSprBobBottomRightXPos(a0)
.bat1
        move.w  hSprBobBottomRightXPos(a1),d1   ; Check for any excess speed/"ball inside bat"
        lsl.w   #VC_POW,d1                      ; Translate to virtual coords
        sub.w   hSprBobTopLeftXPos(a0),d1       ; Any excess is a positive number
        beq     .sfx
        add.w   d1,hSprBobTopLeftXPos(a0)       ; New X position with compensation for excess speed
        add.w   d1,hSprBobBottomRightXPos(a0)

.sfx
        move.l	a0,-(sp)
        lea	SFX_BOUNCE_STRUCT,a0
	jsr     PlaySample
        move.l	(sp)+,a0

.checkGlue
	move.w	hBatEffects(a1),d0
	and.b	#BatGlueEffect,d0
        beq.s   .ballOwner

        move.l  hSprBobXCurrentSpeed(a0),hSprBobXSpeed(a0)      ; Store X + Y for later ball release
        clr.l   hSprBobXCurrentSpeed(a0)                        ; Clear X + Y speeds
.ballOwner
	cmp.l	#2,AllBalls		        ; Insano?
	bhi	.exit

        bsr     SetBallColor
        move.l  a1,hPlayerBat(a0)               ; Update ballowner
.exit
        move.b	#SOFTLOCK_FRAMES,GameTick                       ; Reset soft-lock counter

        move.l  a0,a2   ; restore ball
        rts

; In:	a0 = adress to ball
; In:	a1 = adress to bat
VertBounceVeryExtraUp:
        move.w  BallSpeedx1,d1

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d1
.setX
        move.w  d1,hSprBobXCurrentSpeed(a0)
        move.w  BallSpeedx3,d1
        neg.w   d1
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
VertBounceExtraUp:
        move.w  BallSpeedx2,d1
        neg.w   d1
        move.w  d1,hSprBobYCurrentSpeed(a0)

        cmp.l   #Bat1,a1
        bne.s   .setX
        neg.w   d1
.setX
        move.w  d1,hSprBobXCurrentSpeed(a0)
        rts
VertBounceUp:
        move.w  BallSpeedx3,d1
        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d1
.setX
        move.w  d1,hSprBobXCurrentSpeed(a0)

        move.w  BallSpeedx1,d1
        neg.w   d1
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
VertBounceDown:
        move.w  BallSpeedx3,d1

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d1
.setX
        move.w  d1,hSprBobXCurrentSpeed(a0)

        move.w  BallSpeedx1,hSprBobYCurrentSpeed(a0)
        rts
VertBounceExtraDown:
        move.w  BallSpeedx2,d1
        move.w  d1,hSprBobYCurrentSpeed(a0)

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d1
.setX
        move.w  d1,hSprBobXCurrentSpeed(a0)
        rts
VertBounceVeryExtraDown:
        move.w  BallSpeedx1,d1

        cmp.l   #Bat0,a1
        bne.s   .setX
        neg.w   d1
.setX
        move.w  d1,hSprBobXCurrentSpeed(a0)

        move.w  BallSpeedx3,hSprBobYCurrentSpeed(a0)
        rts


; In:	a1 = adress to bat
; In:	a2 = adress to ball
HorizontalBatCollision:
        move.l  a2,a0

        moveq   #3,d1                           ; Use ball centre X pos in comparisons

        move.w  hSprBobTopLeftXPos(a0),d0
        lsr.w   #VC_POW,d0                      ; Translate to screen-coords
        add.w   d0,d1                           ; Calculate relative X pos
        sub.w   hSprBobTopLeftXPos(a1),d1

        lea     hFunctionlistAddress(a1),a2
        move.l  (a2),a2
.batZoneLoop
        move.l  (a2)+,d0
        beq.s   .foundZone

        cmp.b   d0,d1
        ble.s   .foundZone
        addq.l  #4,a2
        bra.s   .batZoneLoop
.foundZone
        move.l  (a2),a2
        jsr	(a2)                            ; Bouncefunction

.checkBallPos
        tst.b   d1                              ; Don't compensate bat-edge collisions
        bmi.s   .sfx
        cmp.b   hSprBobWidth(a1),d1
        bgt.s   .sfx

        cmp.l   #Bat2,a1
        bne.s   .bat3

        move.w  hSprBobBottomRightYPos(a0),d1   ; Check for any excess speed/"ball inside bat"
        lsr.w   #VC_POW,d1                      ; Translate to screen-coords
        sub.w   hSprBobTopLeftYPos(a1),d1       ; Any excess is a positive number
        beq     .sfx
        lsl.w   #VC_POW,d1                      ; Translate to virtual coords
        sub.w   d1,hSprBobTopLeftYPos(a0)       ; New Y position with compensation for excess speed
        sub.w   d1,hSprBobBottomRightYPos(a0)
.bat3
        move.w  hSprBobBottomRightYPos(a1),d1   ; Check for any excess speed/"ball inside bat"
        lsl.w   #VC_POW,d1                      ; Translate to virtual coords
        sub.w   hSprBobTopLeftYPos(a0),d1       ; Any excess is a positive number
        beq     .sfx
        add.w   d1,hSprBobTopLeftYPos(a0)       ; New Y position with compensation for excess speed
        add.w   d1,hSprBobBottomRightYPos(a0)

.sfx
        move.l	a0,-(sp)
        lea	SFX_BOUNCE_STRUCT,a0
	jsr     PlaySample
        move.l	(sp)+,a0

.checkGlue
	move.w	hBatEffects(a1),d0
	and.b	#BatGlueEffect,d0
        beq.s   .ballOwner

        move.l  hSprBobXCurrentSpeed(a0),hSprBobXSpeed(a0)      ; Store X + Y for later ball release
        clr.l   hSprBobXCurrentSpeed(a0)                        ; Clear X + Y speeds

.ballOwner
	cmp.l	#2,AllBalls		        ; Insano?
	bhi	.exit

        bsr     SetBallColor
        move.l  a1,hPlayerBat(a0)               ; Update ballowner

.exit
        move.b	#SOFTLOCK_FRAMES,GameTick                       ; Reset soft-lock counter
        move.l  a0,a2
        rts

; In:	a0 = adress to ball
; In:	a1 = adress to bat
HorizBounceVeryExtraLeft:
        move.w  BallSpeedx3,d1

        neg.w   d1
        move.w  d1,hSprBobXCurrentSpeed(a0)

        move.w  BallSpeedx1,d1

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d1
.setY
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceExtraLeft:
        move.w  BallSpeedx2,d1

        neg.w   d1
        move.w  d1,hSprBobXCurrentSpeed(a0)

        cmp.l   #Bat3,a1
        bne.s   .setY
        neg.w   d1
.setY
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceLeft:
        move.w  BallSpeedx1,d1

        neg.w   d1
        move.w  d1,hSprBobXCurrentSpeed(a0)

        move.w  BallSpeedx3,d1

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d1
.setY
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceRight:
        move.w  BallSpeedx1,hSprBobXCurrentSpeed(a0)
        move.w  BallSpeedx3,d1

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d1
.setY
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceExtraRight:
        move.w  BallSpeedx2,d1
        move.w  d1,hSprBobXCurrentSpeed(a0)

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d1
.setY
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts
HorizBounceVeryExtraRight:
        move.w  BallSpeedx3,hSprBobXCurrentSpeed(a0)
        move.w  BallSpeedx1,d1

        cmp.l   #Bat2,a1
        bne.s   .setY
        neg.w   d1
.setY
        move.w  d1,hSprBobYCurrentSpeed(a0)
        rts