InitBulletBob:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#ScrBpl*1*4+28,d0
        move.l  d0,d1
        addi.l 	#ScrBpl*6*4,d1

	moveq	#MaxBulletSlots-1,d7
	lea	BulletStructs,a0
.bulletLoop
        move.l	d0,hAddress(a0)
	move.l	d1,hSprBobMaskAddress(a0)

        add.l	#BulletStructSize,a0
	dbf	d7,.bulletLoop
	
	rts

; In:	a4 = Adress to bat struct
AddBullet:
        cmp.b	#MaxBulletSlots,BulletCount
	beq.w	.exit

        addq.b	#1,BulletCount

	moveq	#MaxBulletSlots-1,d7
	lea	AllBullets,a0
.findLoop
	move.l	(a0)+,d0
	beq.s	.emptySlot
	dbf	d7,.findLoop

	bra.w	.exit		        ; No available slot
        
.emptySlot
	lea	BulletStructs,a1
	sub.l	#BulletStructSize,a1
.freeStructLoop
	add.l	#BulletStructSize,a1
	tst.l	hSprBobXCurrentSpeed(a1)
	bne.s	.freeStructLoop         ; This *should* not loop forever

        move.l	a1,-4(a0)               ; Set reference in AllBullets
	move.l	a4,hPlayerBat(a1)	; ... and reference to bat in BulletStruct

        cmpa.l  #Bat0,a4
        bne.s   .player1

	move.w	hSprBobTopLeftXPos(a4),d0
	sub.w	#1,d0
	move.w	d0,hSprBobBottomRightXPos(a1)
	subq.w	#5,d0
	move.w	d0,hSprBobTopLeftXPos(a1)

	move.w	hSprBobHeight(a4),d0
	lsr.w	#1,d0
	subq.w	#2,d0
	add.w	hSprBobTopLeftYPos(a4),d0
	move.w	d0,hSprBobTopLeftYPos(a1)
	addq.w	#5,d0
	move.w	d0,hSprBobBottomRightYPos(a1)

	move.w	#-4,hSprBobXCurrentSpeed(a1)
        bra.w   .done
.player1
        cmpa.l  #Bat1,a4
        bne.s   .player2

	move.w	hSprBobBottomRightXPos(a4),d0
	addq.w	#1,d0
	move.w	d0,hSprBobTopLeftXPos(a1)
	addq.w	#5,d0
	move.w	d0,hSprBobBottomRightXPos(a1)

	move.w	hSprBobHeight(a4),d0
	lsr.w	#1,d0
	subq.w	#2,d0
	add.w	hSprBobTopLeftYPos(a4),d0
	move.w	d0,hSprBobTopLeftYPos(a1)
	addq.w	#5,d0
	move.w	d0,hSprBobBottomRightYPos(a1)

	move.w	#4,hSprBobXCurrentSpeed(a1)
        bra.w   .done
.player2
        cmpa.l  #Bat2,a4
        bne.s   .player3

	move.w	hSprBobWidth(a4),d0
	lsr.w	#1,d0
	subq.w	#2,d0
	add.w	hSprBobTopLeftXPos(a4),d0
	move.w	d0,hSprBobTopLeftXPos(a1)
	addq.w	#5,d0
	move.w	d0,hSprBobBottomRightXPos(a1)

	move.w	hSprBobTopLeftYPos(a4),d0
	sub.w	#1,d0
	move.w	d0,hSprBobBottomRightYPos(a1)
	subq.w	#5,d0
	move.w	d0,hSprBobTopLeftYPos(a1)

	move.w	#-4,hSprBobYCurrentSpeed(a1)
        bra.s   .done
.player3
	move.w	hSprBobWidth(a4),d0
	lsr.w	#1,d0
	subq.w	#2,d0
	add.w	hSprBobTopLeftXPos(a4),d0
	move.w	d0,hSprBobTopLeftXPos(a1)
	addq.w	#5,d0
	move.w	d0,hSprBobBottomRightXPos(a1)

	move.w	hSprBobBottomRightYPos(a4),d0
	addq.w	#1,d0
	move.w	d0,hSprBobTopLeftYPos(a1)
	addq.w	#5,d0
	move.w	d0,hSprBobBottomRightYPos(a1)

	move.w	#4,hSprBobYCurrentSpeed(a1)
.done
	move.w	#35,hBatGunCooldown(a4)
.exit
        rts

; Update bullet coordinates, or remove bullet if leaving screen.
BulletUpdates:
	moveq	#MaxBulletSlots-1,d7
	lea	AllBullets,a4
.bulletLoop
	move.l	(a4)+,d0
	beq.w	.nextBullet

	move.l	d0,a0

	move.w	hSprBobXCurrentSpeed(a0),d1
	beq.s	.checkY
        bmi.s   .checkLeft

        move.w  hSprBobTopLeftXPos(a0),d0
        add.w   d1,d0
        cmpi.w  #319,d0
        bhi.s   .bulletOffScreen

        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobBottomRightXPos(a0),d0
        add.w   d1,d0
        move.w  d0,hSprBobBottomRightXPos(a0)

        bra.s   .nextBullet
.checkLeft
        move.w  hSprBobTopLeftXPos(a0),d0
        add.w   d1,d0
	bmi.s	.bulletOffScreen
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobBottomRightXPos(a0),d0
        add.w   d1,d0
        move.w  d0,hSprBobBottomRightXPos(a0)

        bra.s   .nextBullet

.checkY
	move.w	hSprBobYCurrentSpeed(a0),d1
	beq.s	.nextBullet
        bmi.s   .checkTop

        move.w  hSprBobTopLeftYPos(a0),d0
        add.w   d1,d0
        cmpi.w  #255,d0
        bhi.s   .bulletOffScreen

        move.w  d0,hSprBobTopLeftYPos(a0)
        move.w  hSprBobBottomRightYPos(a0),d0
        add.w   d1,d0
        move.w  d0,hSprBobBottomRightYPos(a0)

        bra.s   .nextBullet
.checkTop
        move.w  hSprBobTopLeftYPos(a0),d0
        add.w   d1,d0
	bmi.s	.bulletOffScreen
        move.w  d0,hSprBobTopLeftYPos(a0)
        move.w  hSprBobBottomRightYPos(a0),d0
        add.w   d1,d0
        move.w  d0,hSprBobBottomRightYPos(a0)

	bra.s	.nextBullet
.bulletOffScreen
	bsr     CopyRestoreFromBobPosToScreen
        CLEAR_BULLETSTRUCT a0
	clr.l	-4(a4)                       ; Remove from AllBullets
        subq.b	#1,BulletCount

.nextBullet
	dbf	d7,.bulletLoop

	rts