GameAreaDeletePtr:	dc.l	GAMEAREA+41*3+3

; Remove bricks from GAMEAREA
RemoveBrick:
	move.l	GameAreaDeletePtr,a5
	addq.l 	#3,GameAreaDeletePtr

	bsr	CheckRemoveBrick
	rts


; Fills most of the screen with bricks from left to right
; In: a0 = Pointer to brickqueue
AddDebugBricksAscending:
	move.l	#25,d4	; rowcount
.rowLoop
	move.w	d4,d5
	mulu.w	#41,d5

	move.l	#17,d7	; brickcount
.colLoop
		move.w	#$36cd,(a0)+
		; move.w	#$21cd,(a0)+
		move.w	d7,d6
		lsl.w	#1,d6		; d7 byte
		add.w	#41*3+1+2,d6
		; add.w	#41*4+1+2,d6
		add.w	d5,d6		; d5 row
		move.w	d6,(a0)+
		dbf	d7,.colLoop
	dbf	d4,.rowLoop

	move.l	a0,BrickQueuePtr
	rts

; Fills most of the screen with bricks from right to left
; In: a0 = Pointer to brickqueue
AddDebugBricksDescending:
	move.l	#0,d4	; rowstart
.rowLoop
	cmpi.b	#25,d4
	beq.s	.done

	move.w	d4,d5
	mulu.w	#41,d5

	move.l	#0,d7
.colLoop
		cmpi.b	#18,d7
		beq.s	.columnsOnRowDone

		move.w	#$36cd,(a0)+
		; move.w	#$21cd,(a0)+
		move.w	d7,d6
		lsl.w	#1,d6		; d7 byte
		add.w	#41*3+1+2,d6
		add.w	d5,d6		; d5 row
		move.w	d6,(a0)+
		
		addq.b	#1,d7
		bra.s	.colLoop
.columnsOnRowDone
	addq.b	#1,d4
	bra.s	.rowLoop
.done
	move.l	a0,BrickQueuePtr
	rts

; Fills most of the screen with bricks from left to right
; Note: Simultaneous drops not supported.
; In: a0 = Pointer to brickqueue
AddDebugBricksForCheckingVposWrap:
	move.l	#2,d4	; 3 rows
.l0
	move.w	d4,d5
	mulu.w	#41,d5

	move.l	#0,d7	; 1 column
.l1
		move.w	#$36cd,(a0)+
		; move.w	#$21cd,(a0)+
		move.w	d7,d6
		lsl.w	#1,d6		; d7 byte
		add.w	#41*25+1+2+2*17,d6	; 25 = 1 row above VPOS wrap row
		add.w	d5,d6		; d5 row
		move.w	d6,(a0)+
		dbf	d7,.l1
	dbf	d4,.l0

	move.l	a0,BrickQueuePtr
	rts

; Fills the queue with specified bricks
AddStaticDebugBricks:
	; move.l  #$30cd03ab,(a0)+	; Performace-checker brick

	; move.l  #$3bcd0366,(a0)+	; OK
	; move.l  #$2acd03b8,(a0)+	; NOK

	move.l  #$3ecd038f,(a0)+
	move.l  #$3ecd0391,(a0)+
	move.l  #$34cd0255,(a0)+
	move.l  #$2ccd027c,(a0)+
	; move.l  #$2acd02a7,(a0)+
	; move.l  #$3ecd027e,(a0)+
	; move.l  #$2ecd0134,(a0)+
	; move.l  #$35cd015f,(a0)+
	; move.l  #$3ecd0136,(a0)+
	; move.l  #$3dcd03a9,(a0)+
	; move.l  #$2ccd03a5,(a0)+
	; move.l  #$23cd03f7,(a0)+
	; move.l  #$3acd03d2,(a0)+
	; move.l  #$30cd03a7,(a0)+
	; move.l  #$28cd03ce,(a0)+
	; move.l  #$21cd03f9,(a0)+
	; move.l  #$3acd03d0,(a0)+
	; move.l  #$3dcd0111,(a0)+
	; move.l  #$2ccd010d,(a0)+
	; move.l  #$35cd013a,(a0)+
	; move.l  #$21cd010f,(a0)+
	; move.l  #$2acd0161,(a0)+
	; move.l  #$23cd0138,(a0)+
	; move.l  #$37cd0320,(a0)+
	; move.l  #$29cd034b,(a0)+
	; move.l  #$21cd0322,(a0)+
	; move.l  #$24cd018c,(a0)+
	; move.l  #$2ccd0188,(a0)+
	; move.l  #$23cd01b3,(a0)+
	; move.l  #$38cd018a,(a0)+
	; move.l  #$2dcd0228,(a0)+
	; move.l  #$37cd01fd,(a0)+
	; move.l  #$3fcd0224,(a0)+
	; move.l  #$2acd024f,(a0)+
	; move.l  #$2ccd0226,(a0)+
	; move.l  #$2bcd015d,(a0)+
	; move.l  #$32cd01af,(a0)+
	; move.l  #$2bcd0186,(a0)+
	; move.l  #$27cd01b1,(a0)+
	; move.l  #$39cd03c2,(a0)+
	; move.l  #$27cd0397,(a0)+
	; move.l  #$2fcd03be,(a0)+

	; move.l  #$32cd04ac,(a0)+
	
	; move.l  #$38cd03c0,(a0)+
	; move.l  #$39cd012a,(a0)+
	; move.l  #$27cd00ff,(a0)+
	; move.l  #$2fcd0126,(a0)+
	; move.l  #$32cd0151,(a0)+
	; move.l  #$38cd0128,(a0)+
	; move.l  #$2ecd0124,(a0)+
	; move.l  #$25cd014f,(a0)+
	; move.l  #$3ecd01a1,(a0)+
	; move.l  #$31cd01f3,(a0)+
	; move.l  #$2ecd01ce,(a0)+
	; move.l  #$25cd01a3,(a0)+
	; move.l  #$3fcd01ca,(a0)+
	; move.l  #$35cd01f5,(a0)+
	; move.l  #$2fcd01cc,(a0)+
	; move.l  #$3ecd025f,(a0)+
	; move.l  #$36cd0236,(a0)+
	; move.l  #$24cd0205,(a0)+
	; move.l  #$2ccd022c,(a0)+
	; move.l  #$35cd0257,(a0)+
	; move.l  #$3ecd022e,(a0)+
	; move.l  #$37cd0372,(a0)+
	; move.l  #$29cd039d,(a0)+
	; move.l  #$21cd0374,(a0)+
	; move.l  #$21cd02f5,(a0)+
	; move.l  #$38cd02f1,(a0)+
	; move.l  #$33cd0343,(a0)+
	; move.l  #$2acd031e,(a0)+
	; move.l  #$2ccd02f3,(a0)+
	; move.l  #$3ccd031a,(a0)+
	; move.l  #$35cd0345,(a0)+
	; move.l  #$32cd031c,(a0)+
	; move.l  #$33cd02e9,(a0)+
	; move.l  #$35cd033b,(a0)+
	; move.l  #$2bcd0316,(a0)+
	; move.l  #$25cd02eb,(a0)+
	; move.l  #$3acd0312,(a0)+
	; move.l  #$31cd033d,(a0)+
	; move.l  #$2bcd0314,(a0)+
	
	move.l	a0,BrickQueuePtr
	rts