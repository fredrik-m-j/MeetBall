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
	move.l	#0,-4(a1)

.emptySlot
	dbf	d7,.enemyLoop
	rts


SinEnemyCountMax	equ	31
SinEnemyCount:	dc.w	SinEnemyCountMax
SinEnemy:
	dc.w 	0,0,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,0,0
	dc.w 	0,0,1,1,2,2,2,2,2,2,2,2,1,1,0,0

EnemyUpdates:
	move.w	SinEnemyCount,d0
	add.w	d0,d0

	lea	(SinEnemy,pc,d0),a1

	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a6
.enemyLoop
	move.l	(a6)+,d0
	beq.s	.emptySlot

	move.l	d0,a0
	move.w	(a1),d6
	add.w	hSprBobTopLeftYPos(a0),d6
	move.w	d6,hSprBobTopLeftYPos(a0)
	move.w	(a1),d6
	add.w	hSprBobBottomRightYPos(a0),d6
	move.w	d6,hSprBobBottomRightYPos(a0)

.emptySlot
	dbf	d7,.enemyLoop

	tst.w	SinEnemyCount
	bne.s	.sub
	move.w	#SinEnemyCountMax,SinEnemyCount
	bra.s	.exit
.sub
	sub.w	#1,SinEnemyCount
.exit
        rts


AddEnemy:
	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a4
.findLoop
	move.l	(a4)+,d0
	beq.s	.emptySlot
	dbf	d7,.findLoop

	bra.s	.exit		; No available slot
.emptySlot
	mulu.w	#EnemyStructSize,d7

	moveq	#0,d0
	bsr	RndB
	add.w	#31,d0

	lea	EnemyStructs,a3
	add.l	d7,a3
	move.w	d0,hSprBobTopLeftXPos(a3)
	add.w	hSprBobWidth(a3),d0
	move.w	d0,hSprBobBottomRightXPos(a3)
	move.l	a3,-4(a4)
.exit
        rts