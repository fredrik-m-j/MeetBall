InitEnemies:
        ; Enemy 1
	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*29*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*29*4)+(4*2),d1         ; Same mask for all frames

        lea	Enemy1AnimMap,a0
	moveq	#3,d7
.loop
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#2,d0
	dbf	d7,.loop

        rts

ClearAllEnemies:
	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a1
.enemyLoop
	move.l	(a1)+,d0
	beq.s	.emptySlot

	move.l	d0,a0
	bsr	CopyRestoreFromBobPosToScreen

	move.w	#0,hSprBobTopLeftXPos(a0)
	move.w	#0,hSprBobBottomRightXPos(a0)
	move.w	#0,hSprBobTopLeftYPos(a0)
	move.w	#0,hSprBobBottomRightYPos(a0)

	move.l	#0,-4(a1)

.emptySlot
	dbf	d7,.enemyLoop
	move.b	#0,EnemyCount
	rts



SinEnemy:
	dc.w 	0,0,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,0,0
	dc.w 	0,0,1,1,2,2,2,2,2,2,2,2,1,1,0,0

EnemyUpdates:
	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a6
.enemyLoop
	move.l	(a6)+,d0
	beq.s	.nextSlot
	move.l	d0,a0

	moveq	#0,d0
	move.b	hMoveIndex(a0),d0
	bne.s	.sub

	move.b	hMoveLastIndex(a0),hMoveIndex(a0)
	bra.s	.move
.sub
	subi.b	#1,hMoveIndex(a0)
.move
	add.w	d0,d0

	lea	(SinEnemy,pc,d0),a1

	move.w	(a1),d6
	add.w	d6,hSprBobTopLeftYPos(a0)
	add.w	d6,hSprBobBottomRightYPos(a0)

.nextSlot
	dbf	d7,.enemyLoop


.exit
        rts

; Add 1-8 enemies on gamescreen (up to MaxEnemySlots limit).
SpawnEnemies:
	; TODO: Spawn properly
	moveq	#0,d0
	bsr	RndB
	and.b	#%00000111,d0
	move.l	d0,d7
.addLoop
	bsr	AddEnemy
	dbf	d7,.addLoop

	rts


; Adds enemy to list. Sorts on Y pos on insert.
AddEnemy:
	movem.l	d7/a3-a4,-(sp)

	cmp.b	#MaxEnemySlots,EnemyCount
	beq.w	.exit

	addi.b	#1,EnemyCount

	moveq	#0,d0
	bsr	RndB		; Random Y pos
	and.b	#%10011111,d0
	add.b	#34,d0
	move.w	d0,d1

	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a4
.findLoop
	move.l	(a4)+,d0
	beq.s	.emptySlot

	move.l	d0,a0
	cmp.w	hSprBobTopLeftYPos(a0),d1
	bmi.s	.insertSlot

	dbf	d7,.findLoop

	bra.s	.exit		; No available slot

.insertSlot
	lea	AllEnemies,a1
	move.l	#MaxEnemySlots*4,d0	; TODO: +4 or not?
	add.l	d0,a1

	move.l	a1,a0
	sub.l	#4,a0
.insertLoop
	cmpa.l	a1,a4
	beq.s	.emptySlot

	move.l	-(a0),-(a1)
	bra.s	.insertLoop

.emptySlot
	lea	EnemyStructs,a3
	sub.l	#EnemyStructSize,a3
.freeStructLoop
	add.l	#EnemyStructSize,a3
	tst.w	hSprBobTopLeftXPos(a3)
	bne.s	.freeStructLoop

	moveq	#0,d0
	bsr	RndB
	add.w	#31,d0

	move.w	d0,hSprBobTopLeftXPos(a3)
	add.w	hSprBobWidth(a3),d0
	move.w	d0,hSprBobBottomRightXPos(a3)
	move.w	d1,hSprBobTopLeftYPos(a3)
	add.w	hSprBobHeight(a3),d1
	move.w	d1,hSprBobBottomRightYPos(a3)

	and.b	#%00011111,d0
	move.b	d0,hMoveIndex(a3)

	move.l	a3,-4(a4)
.exit
	movem.l	(sp)+,d7/a3-a4
        rts