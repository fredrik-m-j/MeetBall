Enemy1Mask:		dc.l	0
Enemy1SpawnMask:	dc.l	0

; CREDITS
; Dan Salvato explains how you can use a stack in an efficient way here:
; See: https://youtu.be/lHQkpYhN0yU?t=15097
; Even for low number of items this is quite efficient.
InitEnemyStack:
 	lea	FreeEnemyStack,a0
	lea	EnemyStructs,a1

	move.w	MaxEnemySlots,d0
	moveq	#0,d1
.l
	move.l	a1,(a0)+
	add.l	#EnemyStructSize,a1
	addq.b	#1,d1
	cmp.b	d1,d0
	bne	.l

	rts


InitEnemies:
        ; Enemy 1
	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*14*4),d0
	move.l	BOBS_BITMAPBASE,Enemy1Mask
	addi.l 	#(ScrBpl*14*4)+(4*2),Enemy1Mask

	move.l	BOBS_BITMAPBASE,Enemy1SpawnMask
	addi.l 	#ScrBpl*14*4+(5*2),Enemy1SpawnMask

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

; In:	a6 = address to CUSTOM $dff000
ClearEnemies:
	move.l	d7,-(sp)

	move.w	EnemyCount,d7
	beq	.done

	subq.w	#1,d7
	lea	FreeEnemyStack,a1
.enemyLoop
	move.l	(a1)+,a0

	bsr	CopyRestoreFromBobPosToScreen

	CLEAR_ENEMYSTRUCT a0

 	dbf	d7,.enemyLoop

.done
	clr.w	EnemyCount
	move.l	#FreeEnemyStack,FreeEnemyStackPtr

	move.l	(sp)+,d7
	rts


EnemyUpdates:
	move.w	EnemyCount,d7
	beq	.exit

	move.w	#Enemy1BlitSize,d5	; Default blitsize
	
	; Check spawn-in
	moveq	#0,d0
	move.b	SpawnInCount,d0
	beq.s	.doUpdates

	add.b	d0,d0			; Get spawn-in blitsize
	lea	Enemy1BlitSizes,a0
	move.w	(a0,d0),d6

	move.b	FrameTick,d0		; Spawn more slowly
	and.b	#7,d0
	bne.s	.doUpdates
	subq.b	#1,SpawnInCount
	bne.s	.doUpdates

	bsr	SetSpawnedEnemies

.doUpdates
	subq.w	#1,d7
	move.l	FreeEnemyStackPtr,a3
	lea	FreeEnemyStack,a2
.enemyLoop
	move.l	(a2)+,a0

	cmpi.w	#eExploding,hEnemyState(a0)
	bne.s	.update
	cmpi.b	#ExplosionFrameCount,hIndex(a0)
	blo.s	.update

	lea 	CUSTOM,a6		; End of explosion anim - remove bob
	bsr     CopyRestoreFromBobPosToScreen

	move.l	-(a3),d0		; Exchange enemystruct-ptrs and POP
	move.l 	a0,(a3)			; a0 is now free to reuse
	move.l	d0,-4(a2)

	move.l	a3,FreeEnemyStackPtr
	CLEAR_ENEMYSTRUCT a0
	subq.w	#1,EnemyCount
	beq	.exit
	bra.s	.next

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

	move.w	(a1),d0
	add.w	d0,hSprBobTopLeftYPos(a0)
	add.w	d0,hSprBobBottomRightYPos(a0)

	cmpi.w	#eSpawning,hEnemyState(a0)
	bne.s	.next
	move.w	d6,hBobBlitSize(a0)
.next
	dbf	d7,.enemyLoop
.exit
        rts

SinEnemy:
	IFGT ENABLE_DEBUG_ENEMYCOLLISION
		dc.w 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	ELSE
		dc.w 	0,0,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,0,0
		dc.w 	0,0,1,1,2,2,2,2,2,2,2,2,1,1,0,0
	ENDC

; Add 1-8 enemies on gamescreen (up to MaxEnemySlots limit).
SpawnEnemies:
	IFGT	ENABLE_DEBUG_ENEMYCOLLISION
	rts
	ENDIF

	move.l	d7,-(sp)

	moveq	#0,d0
	jsr	RndB
	and.b	#%00000111,d0
	move.w	d0,d7
	IFGT	ENABLE_DEBUG_BRICKS
	move.w	#DEFAULT_MAXENEMIES,d7
	ENDIF
.addLoop
	bsr	AddEnemy
	dbf	d7,.addLoop

	bsr	SortEnemies
	move.b	#15,SpawnInCount

	move.l	(sp)+,d7
	rts

SetSpawnedEnemies:
	move.w	EnemyCount,d0
	beq	.done

	subq.w	#1,d0
	lea	FreeEnemyStack,a1
.enemyLoop
	move.l	(a1)+,a0

	cmpi.w	#eExploding,hEnemyState(a0)	; - not if they are exploding
	beq.s	.nextSlot

	move.l	#Enemy1AnimMap,hSpriteAnimMap(a0)
	move.w	#eSpawned,hEnemyState(a0)

.nextSlot
	dbf	d0,.enemyLoop
.done
	rts


SortEnemies:
	move.l	d7,-(sp)
.bubbleLoop
	move.w	EnemyCount,d7
	beq	.done

	cmp.w	#1,d7
	beq	.done

	subq.w	#2,d7
        moveq   #0,d0                           ; Clear the swap flag
        lea     FreeEnemyStack,a0
.swapLoop
        move.l  (a0)+,a1
        move.l  (a0),a2

	move.w	hSprBobTopLeftYPos(a2),d2
        cmp.w   hSprBobTopLeftYPos(a1),d2
        bhs.s   .sorted

        move.b  #1,d0
        move.l  a2,-4(a0)
        move.l  a1,(a0)
.sorted
        dbf     d7,.swapLoop

        tst.b   d0
        bne.s   .bubbleLoop
.done
	move.l	(sp)+,d7
	rts

; Adds enemy to list. Sorts on Y pos on insert.
AddEnemy:
	movem.l	d7/a3-a4,-(sp)

	move.w	MaxEnemySlots,d7
	cmp.w	EnemyCount,d7
	beq.w	.exit

	addq.w	#1,EnemyCount

	moveq	#0,d0
	jsr	RndB		; Random Y pos
	and.b	#%10011111,d0
	add.b	#34,d0
	move.w	d0,d1

	move.l	FreeEnemyStackPtr,a4
	move.l	(a4),a3

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


	addq.l	#4,FreeEnemyStackPtr
.exit
	movem.l	(sp)+,d7/a3-a4
        rts