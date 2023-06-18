Enemy1Mask:		dc.l	0
Enemy1SpawnMask:	dc.l	0

InitEnemies:
        ; Enemy 1
	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*31*4),d0
	move.l	BOBS_BITMAPBASE,Enemy1Mask
	addi.l 	#(ScrBpl*31*4)+(4*2),Enemy1Mask

	move.l	BOBS_BITMAPBASE,Enemy1SpawnMask
	addi.l 	#ScrBpl*31*4+(5*2),Enemy1SpawnMask

        lea	Enemy1SpawnAnimMap,a0
	lea	Enemy1AnimMap,a1
	moveq	#3,d7
.loop
	move.l	d0,(a0)+
	move.l	d0,(a1)+
	move.l	Enemy1SpawnMask,(a0)+
	move.l	Enemy1Mask,(a1)+
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

	CLEAR_ENEMYSTRUCT a0

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
	moveq	#0,d0
	bsr	RndB
	and.b	#%00000111,d0
	move.l	d0,d7
.addLoop
	bsr	AddEnemy
	dbf	d7,.addLoop

	bsr	CompactEnemyList
	bsr	SortEnemies

	rts

SetSpawnedEnemies:
	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a1
.enemyLoop
	move.l	(a1)+,d0
	beq.s	.emptySlot

	move.l	d0,a0
	move.l	#Enemy1AnimMap,hSpriteAnimMap(a0)
	move.w	#eSpawned,hEnemyState(a0)

.emptySlot
	dbf	d7,.enemyLoop
	rts

CompactEnemyList:
        lea     AllEnemies,a0
	lea     AllEnemies,a1
	addq.l	#4,a1

	move.l	#MaxEnemySlots,d7
	subq.b	#2,d7
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
        dbf     d7,.compactLoop
	rts

SortEnemies:
.bubbleLoop
        lea     AllEnemies,a0

	move.l	#MaxEnemySlots,d7
	subq.b	#2,d7
        moveq   #0,d0                           ; Swap flag
.swapLoop
        move.l  (a0)+,a1
        move.l  (a0),d2
	beq.s	.sorted

	move.l	d2,a2

	move.w	hSprBobTopLeftYPos(a2),d2
        cmp.b   hSprBobTopLeftYPos(a1),d2
        bhs.s   .sorted

        move.b  #1,d0
        move.l  a2,-4(a0)
        move.l  a1,(a0)
.sorted
        dbf     d7,.swapLoop

        tst.b   d0
        bne.s   .bubbleLoop
.done
	rts

; Adds enemy to list. Sorts on Y pos on insert.
AddEnemy:
	movem.l	d7/a3-a4,-(sp)

	cmp.b	#MaxEnemySlots,EnemyCount
	beq.w	.exit

	addq.b	#1,EnemyCount

	moveq	#0,d0
	jsr	RndB		; Random Y pos
	and.b	#%10011111,d0
	add.b	#34,d0
	move.w	d0,d1

	move.l	#MaxEnemySlots,d7
	subq.b	#1,d7
	lea	AllEnemies,a4
.findLoop
	move.l	(a4)+,d0
	beq.s	.emptySlot

	; move.l	d0,a0				; INCORRECT! The insert logic is buggy - crashes
	; cmp.w	hSprBobTopLeftYPos(a0),d1
	; bmi.s	.insertSlot

	dbf	d7,.findLoop

	bra.s	.exit		; No available slot

; .insertSlot						; INCORRECT! The insert logic is buggy - crashes
; 	lea	AllEnemies,a1
; 	move.l	#MaxEnemySlots*4,d0
; 	add.l	d0,a1

; 	move.l	a1,a0
; 	sub.l	#4,a0
; .insertLoop
; 	cmpa.l	a1,a4
; 	beq.s	.emptySlot

; 	move.l	-(a0),-(a1)
; 	bra.s	.insertLoop

.emptySlot
	lea	EnemyStructs,a3
	sub.l	#EnemyStructSize,a3
.freeStructLoop
	add.l	#EnemyStructSize,a3
	tst.w	hSprBobTopLeftXPos(a3)
	bne.s	.freeStructLoop

	moveq	#0,d0
	jsr	RndB
	add.w	#31,d0

	move.l	#Enemy1SpawnAnimMap,hSpriteAnimMap(a3)
	move.w	#eSpawning,hEnemyState(a3)

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