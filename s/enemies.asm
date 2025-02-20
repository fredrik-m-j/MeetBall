; CREDITS
; Dan Salvato explains how you can use a stack in an efficient way here:
; See: https://youtu.be/lHQkpYhN0yU?t=15097
; Even for low number of items this is quite efficient.
InitEnemies:
	lea		ENEMY_Stack(a5),a0
	lea		EnemyStructs,a1

	move.w	ENEMY_MaxSlots(a5),d0
	moveq	#0,d1
.l
	move.l	a1,(a0)+
	add.l	#ENEMY_STRUCTSIZE,a1
	addq.b	#1,d1
	cmp.b	d1,d0
	bne		.l

	rts

InitEnemyBobs:
    ; Enemy 1
	move.l	BobsBitmapbasePtr(a5),d0	; Init animation frames
	addi.l	#(RL_SIZE*14*4),d0
	move.l	BobsBitmapbasePtr(a5),ENEMY_1Mask(a5)
	addi.l 	#(RL_SIZE*14*4)+(4*2),ENEMY_1Mask(a5)

	move.l	BobsBitmapbasePtr(a5),ENEMY_1SpawnMask(a5)
	addi.l 	#RL_SIZE*14*4+(5*2),ENEMY_1SpawnMask(a5)

	lea		Enemy_1SpawnAnimMap(a5),a0
	movea.l	#Variables+ENEMY_1AnimMap,a1
	moveq	#3,d7
.enemyLoop
	move.l	d0,(a0)+
	move.l	d0,(a1)+
	move.l	ENEMY_1SpawnMask(a5),(a0)+
	move.l	ENEMY_1Mask(a5),(a1)+
	addq.l	#2,d0
	dbf		d7,.enemyLoop

	; Suctiondevice
	move.l	BobsBitmapbasePtr(a5),d0
	addi.l	#(RL_SIZE*42*4)+2,d0

	move.l	d0,ENEMY_SuckOffGfx(a5)
	addq.l	#2,d0
	move.l	d0,ENEMY_SuckOnGfx(a5)
	addq.l	#2,d0
	move.l	d0,ENEMY_SuckMask(a5)
	addq.l	#2,d0
	move.l	d0,ENEMY_SuckSpawnMask(a5)

	movea.l	#Variables+ENEMY_SuckSpawnAnimMap,a1
	move.l	ENEMY_SuckOffGfx(a5),BobAnimGfx(a1)
	move.l	ENEMY_SuckSpawnMask(a5),BobAnimMask(a1)

	; Explosion
	move.l	BobsBitmapbasePtr(a5),d0	; Init animation frames
	addi.l	#(RL_SIZE*205*4),d0
	move.l	d0,d1
	addi.l	#(7*2),d1

	lea		ExplosionAnimMap(a5),a0
	moveq	#(ENEMY_EXPLOSIONCOUNT/2)-1,d7
.explosionLoop
	move.l	d0,(a0)+				; Gfx
	move.l	d1,(a0)+				; Mask
	move.l	d0,(a0)+				; Gfx	- twice because it's a short animation
	move.l	d1,(a0)+				; Mask
	addq.l	#2,d0
	addq.l	#2,d1
	dbf		d7,.explosionLoop

	rts

; In:	a6 = address to CUSTOM $dff000
ClearEnemies:
	move.l	d7,-(sp)

	move.w	ENEMY_Count(a5),d7
	beq		.done

	subq.w	#1,d7
	lea		ENEMY_Stack(a5),a1
.enemyLoop
	move.l	(a1)+,a0

	bsr	CopyRestoreFromBobPosToScreen

	CLRENEMY	a0

	dbf		d7,.enemyLoop

.done
	clr.w	ENEMY_Count(a5)
	move.l	#Variables+ENEMY_Stack,ENEMY_StackPtr(a5)

	move.l	(sp)+,d7
	rts


; Updates position and updates blitsize during spawn-in.
; In:	a0 = address to enemy struct.
EnemyUpdate:
	tst.l	hSprBobXCurrentSpeed(a0)
	beq.s	.checkSpawning			; No movement

	moveq	#0,d0
	move.b	hMoveIndex(a0),d0
	bne.s	.sub

	move.b	hMoveLastIndex(a0),hMoveIndex(a0)
	bra.s	.move
.sub
	subq.b	#1,hMoveIndex(a0)
.move
	add.w	d0,d0

	lea		(SinEnemy,pc,d0),a1

	move.w	(a1),d0
	add.w	d0,hSprBobTopLeftYPos(a0)
	add.w	d0,hSprBobBottomRightYPos(a0)

.checkSpawning
	cmpi.w	#ENEMYSTATE_SPAWNING,hEnemyState(a0)
	bne.s	.exit

	moveq	#0,d0
	move.b	ENEMY_SpawnCount(a5),d0
	add.b	d0,d0					; Get spawn-in blitsize
	lea		Enemy1BlitSizes,a1
	move.w	(a1,d0.w),hBobBlitSize(a0)
.exit
	rts

SinEnemy:
	IFD		ENABLE_DEBUG_ENEMYCOLLISION
		dc.w 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		dc.w 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	ELSE
		dc.w 	0,0,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,0,0
		dc.w 	0,0,1,1,2,2,2,2,2,2,2,2,1,1,0,0
	ENDIF

; Add 1-8 enemies on gamescreen (up to MaxSlots limit).
SpawnEnemies:
	IFD		ENABLE_DEBUG_ENEMYCOLLISION
	rts
	ENDIF

	move.l	d7,-(sp)

	moveq	#0,d0
	jsr		RndB
	and.b	#%00000111,d0
	move.w	d0,d7
	IFD		ENABLE_DEBUG_BRICKS
	move.w	#ENEMIES_DEFAULTMAX,d7
	sub.w	ENEMY_Count(a5),d7
	ENDIF
.addLoop
	bsr		AddEnemy
	dbf		d7,.addLoop

	bsr		SortEnemies
	move.b	#15,ENEMY_SpawnCount(a5)

	move.l	(sp)+,d7
	rts

SetSpawnedEnemies:
	move.w	ENEMY_Count(a5),d0
	beq		.done

	movem.l	a2-a4,-(sp)

	subq.w	#1,d0
	lea		ENEMY_Stack(a5),a1
.enemyLoop
	move.l	(a1)+,a0

	tst.w	hEnemyState(a0)			; ENEMYSTATE_SPAWNING?
	bne.s	.nextSlot

	move.w	#ENEMYSTATE_SPAWNED,hEnemyState(a0)

	; Check what type spawned
	cmp.l	#Variables+ENEMY_SuckSpawnAnimMap,hSpriteAnimMap(a0)
	beq.s	.sucker
	move.l	#Variables+ENEMY_1AnimMap,hSpriteAnimMap(a0)
	bra.s	.nextSlot
.sucker 
	clr.l	hSpriteAnimMap(a0)
	; Reset mask - BobAnim has updated it during spawn.
	move.l	ENEMY_SuckMask(a5),hSprBobMaskAddress(a0)

	move.l	GAMESCREEN_Ptr(a5),a2	; Blit the sucker
	exg		a0,a3
	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	d0,-(sp)
	bsr		CookieBlitToScreen
									; TODO: copy to BACK? Will be overwritten?
	move.l	(sp)+,d0

.nextSlot
	dbf		d0,.enemyLoop

	movem.l	(sp)+,a2-a4
.done
	rts


SortEnemies:
	move.l	d7,-(sp)
.bubbleLoop
	move.w	ENEMY_Count(a5),d7
	beq		.done

	cmp.w	#1,d7
	beq		.done

	subq.w	#2,d7
	moveq	#0,d0					; Clear the swap flag
	lea		ENEMY_Stack(a5),a0
.swapLoop
	move.l	(a0)+,a1
	move.l	(a0),a2

	move.w	hSprBobTopLeftYPos(a2),d2
	cmp.w	hSprBobTopLeftYPos(a1),d2
	bhs.s	.sorted

	move.b	#1,d0
	move.l	a2,-4(a0)
	move.l	a1,(a0)
.sorted
	dbf		d7,.swapLoop

	tst.b	d0
	bne.s	.bubbleLoop
.done
	move.l	(sp)+,d7
	rts

; Adds enemy to list.
AddEnemy:
	IFGT	ENABLE_ENEMIES
	movem.l	d7/a3-a4,-(sp)

	move.w	ENEMY_MaxSlots(a5),d7
	cmp.w	ENEMY_Count(a5),d7
	beq.w	.exit

	addq.w	#1,ENEMY_Count(a5)

	moveq	#0,d0
	jsr		RndB					; Random Y pos
	and.b	#%10011111,d0
	add.b	#34,d0
	move.w	d0,d1

	move.l	ENEMY_StackPtr(a5),a4
	move.l	(a4),a3

	moveq	#0,d0
	jsr		RndB
	add.w	#31,d0

	move.l	#Variables+Enemy_1SpawnAnimMap,hSpriteAnimMap(a3)
	move.w	#ENEMYSTATE_SPAWNING,hEnemyState(a3)

	move.w	d0,hSprBobTopLeftXPos(a3)
	add.w	hSprBobWidth(a3),d0
	move.w	d0,hSprBobBottomRightXPos(a3)
	move.w	d1,hSprBobTopLeftYPos(a3)
	add.w	hSprBobHeight(a3),d1
	move.w	d1,hSprBobBottomRightYPos(a3)
	move.w	#1,hSprBobXCurrentSpeed(a3)	; Dummy speed - this enemy moves during animation

	and.b	#%00011111,d0
	move.b	d0,hMoveIndex(a3)
	move.b	#3,hLastIndex(a3)


	addq.l	#4,ENEMY_StackPtr(a5)
.exit
	movem.l	(sp)+,d7/a3-a4
	ENDIF
	rts

; Adds enemy to list.
; In:	= d0.w X
; In:	= d1.w Y
AddSuckerEnemy:
	IFGT	ENABLE_ENEMIES
	movem.l	d7/a3-a4,-(sp)

	move.w	ENEMY_MaxSlots(a5),d7
	cmp.w	ENEMY_Count(a5),d7
	beq.w	.exit

	addq.w	#1,ENEMY_Count(a5)

	move.l	ENEMY_StackPtr(a5),a4
	move.l	(a4),a3

	move.l	ENEMY_SuckOffGfx(a5),(a3)		; Pointer to Gfx in CHIP
	move.l	#Variables+ENEMY_SuckSpawnAnimMap,hSpriteAnimMap(a3)
	move.w	#ENEMYSTATE_SPAWNING,hEnemyState(a3)

	move.l	#$00100010,hSprBobHeight(a3)	; Set height+width
	move.w	d0,hSprBobTopLeftXPos(a3)
	add.w	hSprBobWidth(a3),d0
	move.w	d0,hSprBobBottomRightXPos(a3)
	move.w	d1,hSprBobTopLeftYPos(a3)
	add.w	hSprBobHeight(a3),d1
	move.w	d1,hSprBobBottomRightYPos(a3)

	clr.b	hMoveIndex(a3)

	addq.l	#4,ENEMY_StackPtr(a5)
	move.b	#15,ENEMY_SpawnCount(a5)
.exit
	movem.l	(sp)+,d7/a3-a4
	ENDIF
	rts