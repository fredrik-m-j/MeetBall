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
.enemyLoop
	move.l	d0,(a0)+
	move.l	d0,(a1)+
	move.l	Enemy1SpawnMask,(a0)+
	move.l	Enemy1Mask,(a1)+
	addq.l	#2,d0
	dbf	d7,.enemyLoop

	; Explosion
	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*205*4),d0
	move.l	d0,d1
	addi.l 	#(7*2),d1

        lea	ExplosionAnimMap,a0
	moveq	#(ExplosionFrameCount/2)-1,d7
.explosionLoop
	move.l	d0,(a0)+			; Gfx
	move.l	d1,(a0)+			; Mask
	move.l	d0,(a0)+			; Gfx	- twice because it's a short animation
	move.l	d1,(a0)+			; Mask
	addq.l	#2,d0
	addq.l	#2,d1
	dbf	d7,.explosionLoop

        rts

ClearAllEnemies:
	move.l	#MaxEnemySlots-1,d7
	lea	AllEnemies,a1
.enemyLoop
	move.l	(a1)+,d0
	beq.s	.emptySlot

	move.l	d0,a0
	bsr	CopyRestoreFromBobPosToScreen

	CLEAR_ENEMYSTRUCT a0

	clr.l	-4(a1)

.emptySlot
	dbf	d7,.enemyLoop
	clr.b	EnemyCount
	rts


EnemyUpdates:
	move.w	Enemy1BlitSizes,d5	; Figure out blitsize
	moveq	#0,d0
	move.b	SpawnInCount,d0
	beq.s	.doUpdates

	add.b	d0,d0			; Get spawn-in blitsize
	lea	Enemy1BlitSizes,a0
	move.w	(a0,d0),d5

	move.b	FrameTick,d0		; Spawn more slowly
	and.b	#7,d0
	bne.s	.doUpdates
	subq.b	#1,SpawnInCount

.doUpdates
	move.l	#MaxEnemySlots-1,d7
	lea	AllEnemies,a2
.enemyLoop
	move.l	(a2)+,d0
	beq.s	.nextSlot
	move.l	d0,a0

	cmpi.w	#eExploding,hEnemyState(a0)
	bne.s	.update
	cmpi.b	#ExplosionFrameCount,hIndex(a0)
	blo.s	.update

	bsr	ResetExplodingEnemy
	bra.s	.nextSlot

.update
	moveq	#0,d0
	move.b	hMoveIndex(a0),d0
	bne.s	.sub

	move.b	hMoveLastIndex(a0),hMoveIndex(a0)
	bra.s	.move
.sub
	subq.b	#1,hMoveIndex(a0)
.move
	add.w	d0,d0

	lea	(SinEnemy,pc,d0),a1

	move.w	(a1),d6
	add.w	d6,hSprBobTopLeftYPos(a0)
	add.w	d6,hSprBobBottomRightYPos(a0)

	cmpi.w	#eSpawning,hEnemyState(a0)
	bne.s	.nextSlot
	move.w	d5,hBobBlitSize(a0)
.nextSlot
	dbf	d7,.enemyLoop
.exit
        rts

SinEnemy:
	dc.w 	0,0,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,0,0
	dc.w 	0,0,1,1,2,2,2,2,2,2,2,2,1,1,0,0


; Add 1-8 enemies on gamescreen (up to MaxEnemySlots limit).
SpawnEnemies:
	moveq	#0,d0
	jsr	RndB
	and.b	#%00000111,d0
	move.l	d0,d7
.addLoop
	bsr	AddEnemy
	dbf	d7,.addLoop

	bsr	CompactEnemyList
	bsr	SortEnemies
	move.b	#15,SpawnInCount

	rts

SetSpawnedEnemies:
	move.l	#MaxEnemySlots-1,d7
	lea	AllEnemies,a1
.enemyLoop
	move.l	(a1)+,d0
	beq.s	.nextSlot

	move.l	d0,a0
	cmpi.w	#eExploding,hEnemyState(a0)	; - not if they are exploding
	beq.s	.nextSlot

	move.l	#Enemy1AnimMap,hSpriteAnimMap(a0)
	move.w	#eSpawned,hEnemyState(a0)

.nextSlot
	dbf	d7,.enemyLoop
	rts

CompactEnemyList:
        lea     AllEnemies,a0
	lea     AllEnemies,a1
	addq.l	#4,a1

	move.l	#MaxEnemySlots-2,d7
.compactLoop                                    ; Compact the extra ball list
        move.l  (a1)+,d0

        tst.l   (a0)
        beq.s   .tryMove
        bne.s   .next
.tryMove
        tst.l   d0
        beq.s   .skip
        move.l  d0,(a0)
        clr.l	-4(a1)
.next
        addq.l  #4,a0
.skip
        dbf     d7,.compactLoop
	rts

SortEnemies:
.bubbleLoop
        lea     AllEnemies,a0

	move.l	#MaxEnemySlots-2,d7
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

	move.l	#MaxEnemySlots-1,d7
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
; 	subq.l	#4,a0
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


; In:	a0 = address to enemy struct
; In:	a2 = address into AllEnemies +4
ResetExplodingEnemy:
	bsr     CopyRestoreFromBobPosToScreen

	clr.l  	-4(a2)		; Remove from AllEnemies
	subq.b	#1,EnemyCount
	CLEAR_ENEMYSTRUCT a0
	
	rts