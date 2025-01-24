GameAreaDeletePtr:	dc.l	GAMEAREA+41*3+3

; Fills most of the screen with bricks from left to right
; In: a0 = Pointer to AddBrickQueue
AddDebugBricksAscending:
	moveq	#25,d4					; rowcount
	move.b	#RANDOMBRICKS_START,d0	; Random color bricks starting point

.rowLoop
	move.w	d4,d5
	mulu.w	#41,d5

	moveq	#17,d7					; brickcount
.colLoop
	move.b	d0,(a0)+
	move.b	#BRICK_2ND_BYTE,(a0)+

	move.w	d7,d6
	lsl.w	#1,d6					; d7 byte
	add.w	#41*3+1+2,d6
	; add.w	#41*4+1+2,d6
	add.w	d5,d6					; d5 row
	move.w	d6,(a0)+

	addq.b	#1,d0
	cmp.b	#MAX_RANDOMBRICKS,d0
	bne.s	.inRange
	move.b	#RANDOMBRICKS_START,d0
.inRange
	dbf		d7,.colLoop
	dbf		d4,.rowLoop

	move.l	a0,AddBrickQueuePtr(a5)
	rts

; Fills most of the screen with bricks from right to left
; In: a0 = Pointer to AddBrickQueue
AddDebugBricksDescending:
	moveq	#0,d4					; rowstart
	move.b	RANDOMBRICKS_START,d0	; Random color bricks starting point
.rowLoop
	cmpi.b	#25,d4
	beq.s	.done

	move.w	d4,d5
	mulu.w	#41,d5

	moveq	#0,d7
.colLoop
	cmpi.b	#18,d7
	beq.s	.columnsOnRowDone

	move.b	d0,(a0)+
	move.b	#BRICK_2ND_BYTE,(a0)+

	; move.w	#$36cd,(a0)+
	; move.w	#$21cd,(a0)+
	move.w	d7,d6
	lsl.w	#1,d6					; d7 byte
	add.w	#41*3+1+2,d6
	add.w	d5,d6					; d5 row
	move.w	d6,(a0)+

	addq.b	#1,d0
	cmp.b	#MAX_RANDOMBRICKS,d0
	bne.s	.inRange
	move.b	#$50,d0
.inRange
	; dbf	d7,.colLoop

	addq.b	#1,d7
	bra.s	.colLoop
.columnsOnRowDone
	addq.b	#1,d4
	bra.s	.rowLoop
.done
	move.l	a0,AddBrickQueuePtr(a5)
	rts

; Fills most of the screen with bricks from left to right
; Note: Simultaneous drops not supported.
; In: a0 = Pointer to AddBrickQueue
AddDebugBricksForCheckingVposWrap:
	move.l	#2,d4					; 3 rows
.l0
	move.w	d4,d5
	mulu.w	#41,d5

	moveq	#0,d7					; 1 column
.l1
	move.w	#$36cd,(a0)+
	; move.w	#$21cd,(a0)+
	move.w	d7,d6
	lsl.w	#1,d6					; d7 byte
	add.w	#41*25+1+2+2*17,d6		; 25 = 1 row above VPOS wrap row
	add.w	d5,d6					; d5 row
	move.w	d6,(a0)+
	dbf		d7,.l1
	dbf		d4,.l0

	move.l	a0,AddBrickQueuePtr(a5)
	rts

; Fills the queue with specified bricks
AddStaticDebugBricks:
	; move.l  #$30cd03ab,(a0)+	; Performace-checker brick

	move.l	#$3ecd038f,(a0)+
	move.l	#$3ecd0391,(a0)+
	move.l	#$34cd0255,(a0)+
	move.l	#$2ccd027c,(a0)+
	
	move.l	a0,AddBrickQueuePtr(a5)
	rts

; For displaying predefined bricks
AddPredefinedDebugBricks:
	move	#1,d4					; rowcount
	move.b	#STATICBRICKS_START,d0	; Predefined bricks starting point

.rowLoop
	move.w	d4,d5
	mulu.w	#41,d5

	moveq	#15,d7					; brickcount
.colLoop
	move.b	d0,(a0)+
	move.b	#BRICK_2ND_BYTE,(a0)+

	move.w	d7,d6
	lsl.w	#1,d6					; d7 byte
	add.w	#41*3+1+2,d6
	add.w	d5,d6					; d5 row
	move.w	d6,(a0)+

	addq.b	#1,d0
	; cmp.b	#MAX_RANDOMBRICKS,d0
	; bne.s	.inRange
	; move.b	#$50,d0
.inRange
	dbf		d7,.colLoop
	dbf		d4,.rowLoop

	move.l	a0,AddBrickQueuePtr(a5)
	rts