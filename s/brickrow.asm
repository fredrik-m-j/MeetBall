; In:	a1 = Pointer into copper list (position after making changes for 1 GAMEAREA row).
; In:	d7 = GAMEAREA row that was updated
AddCopperJmp:
	cmp.b		#$1f,d7
	beq			.setNewEnd			; This is the last GAMEAREA row

	move.l		d7,d1				; Lookup copperpointer into next GAMAREA row
	addq.w		#1,d1

	lsl			#3,d1				; Convert to 2*longword

	lea			GameAreaRowCopper,a2
	move.l		(a2,d1.l),d0

	cmp.l		d0,a1				; This GAMEAREA row has maxed out copperinstructions
	beq.s		.exit

	swap		d0

	cmp.l		#WAIT_VERT_WRAP,(a1)	; Special case: empty GAMEAREA row having PAL await end of line $ff
	bne			.noWrapFound
	addq.l		#4+4,a1				; Keep the WAIT_VERT_WRAP + COPNOP

.noWrapFound
	move.w		#$84,(a1)+			; Write to COP2LC to jump to instructions for next GAMAREA row
	move.w		d0,(a1)+

	swap		d0

	move.w		#$86,(a1)+
	move.w		d0,(a1)+

	move.w		#$8a,(a1)+			; COPJMP2
	move.w		#$0,(a1)+

	bra.s		.exit
.setNewEnd
	move.l		#COPPERLIST_END,(a1)
	addq.l		#4,a1

.exit
	IFD			ENABLE_BRICKRASTERMON
	move.w		#$fff,$dff180
	ENDIF
	rts


; ---- NOT placed in Variables because of optimized brickrendering
PlayerCount:	
	dc.w		1

CopperUpdatesCachePtr:
	REPT		40
	dc.w		0					; Copper WAIT,COLOR00 instruction or NOTHING flags
	dc.l		0					; References to all tilestructs on a GAMEAREA row
	ENDR
; ---- 

; Updates copperlist for the given GAMEAREA row.
; There are two types of entries to this routine:
; 1. Dirty GAMEAREA row need to be drawn/redrawn
; 2. Dirty GAMEAREA row need to be drawn/redrawn from where it was abandoned (running out of frame time)
;
; In:	a0 = GAMEAREA ROW pointer
; In:	a1 = pointer into copperlist where COLOR00 changes go
; In:	a4 = start of GAMEAREA ROW pointer (copy).
; In:	d2 = 0 if starting from the top - next abandoned rasterline otherwise.
; In:	d7 = GAMEAREA row that will be updated
UpdateDirtyCopperlist:
	movem.l		d3-d6/a3,-(sp)

	IFD			ENABLE_RASTERMONITOR
	move.w		#$444,$dff180
	ENDIF

 	lea			CopperUpdatesCachePtr(pc),a5

.nextRasterline
	move.l		d2,d5				; d5 = offset into COLOR00 MOVEs in tilestruct for this rasterline
	lsl.w		#3,d5				; rasterline in d2 * 2 longwords per rasterline in tilestruct

	move.w		d7,d0
	lsl.w		#3,d0
	add.b		d2,d0
	addi.w		#FIRST_Y_POS,d0		; Rasterline to process

	move.w		d0,d4				; d4 = the position to wait for in copper list
	lsl.w		#8,d4				; move <yy> byte left

	move.b		#FIRST_X_POS,d4		; Start from FIRST_X_POS
	; Bit 0 must be set to get an awaitable X position in copper list
	; This is faster but will it work on all 68k CPUs?
	; move.b	d0,-(sp)
	; move.w	(sp)+,d4
	; move.b	#FIRST_X_POS,d4

	; PAL screen - check for Vertical Position wrap
	; If we arrived at a rasterline past the wrapping point - insert the magical WAIT.
	cmpi.w		#$ff+1,d0
	bne.s		.noWrap

	clr.b		NoVerticalPosWait	; Reset flag - assume there is no time for WAIT_VERT_WRAP

	; Check cornercases when there isn't enough time for Vertical Position wrap WAIT, such as:
	; * Protective extra wall to the right - "insanoballz-wall" (GAMAREAROW+38)
	tst.b		41-3(a4)
	bne.s		.noWrap

	; * Brick at GAMAREAROW+37 - WAIT is too much, add only COPNOP for correct results
	tst.b		41-4(a4)
	beq			.wrap
	move.l		#COPNOP<<16+$0,(a1)+
	bra			.noWrap

.wrap
	move.l		#WAIT_VERT_WRAP,(a1)+	; Insert VertPos WAIT to await end of line $ff
	move.l		#COPNOP<<16+$0,(a1)+	; Needed for real hardware. See https://eab.abime.net/showthread.php?p=896188
	move.b		#-1,NoVerticalPosWait	; Set flag for blinkbricks on this GAMEAREA row
.noWrap

	; Applicable when rasterline = 0 (when creating cache)
	; d0 is used to calculate rasterline bytes = 1 rasterline worth of copperinstructions
	move.l		a1,d0

	moveq		#40-1,d3			; GAMEAREA byte 0-40
.nextTileLoop
	moveq		#0,d1
	move.b		(a0),d1				; Find next tile that need COLOR00 changes
	beq.s		.noDraw
	cmp.b		#WALL_BYTE,d1		; Is CPU-drawn tile? (reducing copper DMA-time)
	bne.s		.update
.noDraw
	addq.l		#1,a0
	addq.b		#4,d4				; Move the corresponding to 8px forward in X pos
	dbf			d3,.nextTileLoop
	bra			.doneRasterline

.update
	tst.b		d2					; Cached data? (cached if relative rasterline >0)
	beq.s		.cacheDataForTile
	
;==============================================================================
;	Avoiding bsr/rts because this is executed up to 40*7 times
;	BEGIN 	SET COPPER INSTRUCTIONS - using the cache created in code block below
	move.w		(a5)+,d0			; Check flags in cache
	beq			.addBlackColor00Cached
	bmi			.setTileColorCached

	move.w		d4,(a1)+
	move.w		#$fffe,(a1)+
	bra			.setTileColorCached
.addBlackColor00Cached
	move.l		#COLOR00<<16+$0,(a1)+
.setTileColorCached
	move.l		(a5)+,a2			; Fetch tile struct from cache

	cmpi.b		#1,BrickByteWidth(a2)
	beq.s		.singleByteTileCached

	move.l		BrickColorY0X0(a2,d5.w),(a1)+
	move.l		4+BrickColorY0X0(a2,d5.w),(a1)+

	addq.l		#2,a0
	addq.b		#8,d4				; Move the corresponding to 16px forward in X pos	
	subq.b		#1,d3				; Already processed *2* bytes - iterate one further in GAMEAREA row

	move.b		(a0),d1
	beq.s		.peekIsEmptyCache
	cmp.b		#WALL_BYTE,d1
	beq.s		.peekIsEmptyCache
	bne.s		.doneCopperWithCache

.singleByteTileCached
	move.l		BrickColorY0X0(a2,d5.w),(a1)+

	addq.l		#1,a0
	addq.b		#4,d4				; Move the corresponding to 8px forward in X pos
	
	move.b		(a0),d1
	beq.s		.peekIsEmptyCache
	cmp.b		#WALL_BYTE,d1
	bne.s		.doneCopperWithCache
.peekIsEmptyCache
	move.l		#COLOR00<<16+$0,(a1)+	; Reset to black when next position has no brick

.doneCopperWithCache
;	END	SET COPPER INSTRUCTIONS - using cache
;==============================================================================

	dbf			d3,.nextTileLoop
	bra			.doneRasterline


.cacheDataForTile
;==============================================================================
;	Avoiding any bsr/rts because this is executed up to 40*1 times
;	BEGIN 	CREATE CACHE + SET COPPER INSTRUCTIONS (relative rasterline 0)

	move.l		a4,d6				; Check if there is time enough for a copper WAIT instruction
	cmp.l		d6,a0				; There is always time enough for leftmost tile 0
	beq.s		.addWaitFlag

	addq		#1,d6
	cmp.l		d6,a0				; Cornercase: there might be time enough for tile 1
	bne.s		.regularCheck

	move.l		a0,a3

	tst.b		-1(a3)
	beq.s		.c1
	cmp.b		#WALL_BYTE,-1(a3)
	beq.s		.c1					; Treat all WALL_BYTE as if they don't exist (since they are drawn by CPU)
	bne.s		.noTime
.c1
	tst.b		-3(a3)
	beq.s		.regularCheck
	cmp.b		#WALL_BYTE,-3(a3)
	beq.s		.regularCheck
	bne.s		.addWaitFlag

.regularCheck
	move.l		a0,a3

	tst.b		-(a3)
	beq.s		.c2
	cmp.b		#WALL_BYTE,(a3)
	beq.s		.c2					; Treat all WALL_BYTE as if they don't exist (since they are drawn by CPU)
	bne.s		.noTime
.c2
	tst.b		-(a3)
	beq.s		.c3
	cmp.b		#WALL_BYTE,(a3)
	beq.s		.c3
	bne.s		.noTime
.c3
	tst.b		-(a3)
	beq.s		.addWaitFlag
	cmp.b		#WALL_BYTE,(a3)
	bne.s		.addBlackColor00Flag	; It's a brick/tile


.addWaitFlag
	move.w		#1,(a5)+

	move.w		d4,(a1)+
	move.w		#$fffe,(a1)+
	bra.s		.cacheTilestruct

.addBlackColor00Flag
	move.w		#0,(a5)+

	move.l		#COLOR00<<16+$0,(a1)+
	bra.s		.cacheTilestruct

.noTime
	move.w		#-1,(a5)+


.cacheTilestruct
	move.l		d7,-(sp)			; Running low on registers to use

	lea			AllBlinkBricks,a2
	move.w		PlayerCount(pc),d7
	subq.w		#1,d7
.blinkLoop
	cmp.l		hBlinkBrickGameareaPtr(a2),a0
	beq.s		.blinkBrick
	add.l		#AllBlinkBricksStruct_SizeOf,a2
	dbf			d7,.blinkLoop

	bra			.notBlinkBrick
.blinkBrick
	move.l		a5,-(sp)			; Running low on registers to use
	
	move.l		a1,d7				; Calculate byte offset into temp
	sub.l		#Copper_GAME_Temp,d7
	lea			Variables,a5
	add.l		TargetRowCopperPtr(a5),d7

	move.l		(sp)+,a5

	move.l		d7,hBlinkBrickCopperPtr(a2)	; Save address to first blinkbrick copper instruction
	move.l		hBlinkBrickStruct(a2),a2
	move.l		a2,(a5)+			; Add to cache
	bra.s		.cacheCreated
.notBlinkBrick
	add.w		d1,d1				; Convert .b to .l
	add.w		d1,d1
	lea			TileMap,a2
	move.l		(a2,d1.l),a2		; Lookup in tile map
	move.l		a2,(a5)+			; Add to cache
.cacheCreated
	move.l		(sp)+,d7


	cmpi.b		#1,BrickByteWidth(a2)
	beq.s		.singleByteTile

	move.l		BrickColorY0X0(a2),(a1)+
	move.l		4+BrickColorY0X0(a2),(a1)+

	addq.l		#2,a0
	addq.b		#8,d4				; Move the corresponding to 16px forward in X pos	
	subq.b		#1,d3				; Already processed *2* bytes - iterate one further in GAMEAREA row

	move.b		(a0),d1
	beq.s		.peekIsEmpty
	cmp.b		#WALL_BYTE,d1
	beq.s		.peekIsEmpty
	bne.s		.doneCopper

.singleByteTile
	move.l		BrickColorY0X0(a2),(a1)+

	addq.l		#1,a0
	addq.b		#4,d4				; Move the corresponding to 8px forward in X pos

	move.b		(a0),d1
	beq.s		.peekIsEmpty
	cmp.b		#WALL_BYTE,d1
	bne.s		.doneCopper
.peekIsEmpty
	move.l		#COLOR00<<16+$0,(a1)+	; Reset to black when next position has no brick

.doneCopper
;	END 	CREATE CACHE + SET COPPER INSTRUCTIONS (relative rasterline 0)
;==============================================================================

	dbf			d3,.nextTileLoop


.doneRasterline
	move.l		a4,a0				; Reset game area ROW pointer
	lea		CopperUpdatesCachePtr(pc),a5; Reset cache pointer

	; NOTE: the following is INCORRECT:
	; Remaining rasterlines must be processed to catch any vertical position wrap
	; tst.l	(a5)			; Nothing was cached?
	; beq	.exit			; No need to continue

	tst.b		d2
	bne			.notFirstRasterline

	lsl			#3,d7				; Save the rasterline bytecount
	move.l		a0,-(sp)

	move.l		a1,d1
	sub.l		d0,d1	
	lea			GameAreaRowCopper,a0
	move.l		d1,4(a0,d7)

	move.l		(sp)+,a0
	lsr			#3,d7
.notFirstRasterline

	IFD			ENABLE_RASTERMONITOR
	move.w		#$080,$dff180
	ENDIF

	addq.b		#1,d2

	cmpi.b		#8,d2
	beq			.onComplete

	tst.b		CUSTOM+VPOSR+1		; Check for extreme load - passed vertical wrap?
	beq			.nextRasterline
	cmp.b		#$0b,$dff006		; Need to abandon?
	bhi			.abandon

	bra.w		.nextRasterline

.abandon
	lea			Variables,a5
	move.l		a1,AbandonedRowCopperPtr(a5)	; Save essential addresses and values
	move.l		a4,AbandonedGameareaRowPtr(a5)
	move.b		d7,AbandonedGameareaRow(a5)
	move.w		d2,AbandonedNextRasterline(a5)
	bra			.exit

.onComplete
	bsr			AddCopperJmp

	lea			Variables,a5

	move.l		a1,d2
	sub.l		#Copper_GAME_Temp,d2	; Byte sizeof copper-instructions
									; Calculate blitsize
	lsl.w		#6-2,d2				; Bitshift size up to "height" bits of BLTSIZE & convert .b to .l (hence -2)
	add.b		#%10,d2				; Set blit "width" to .l

	lea			Copper_GAME_Temp,a0	; Source
	move.l		TargetRowCopperPtr(a5),a1	; Destination
	moveq		#DEFAULT_MASK,d0
	moveq		#0,d1				; No modulo

	tst.b		AllowUglyUpdate(a5)
	beq			.copyCopperinstructions
.await1								; Make sure we update copperlist later than most bricks appear
	tst.b		CUSTOM+VPOSR+1		; Passed vertical wrap?
	beq.s		.await1
.copyCopperinstructions
	bsr			CopyBlit

	clr.l		CopperUpdatesCachePtr
	move.l		DirtyRowBitsOnCompletion(a5),DirtyRowBits(a5)

.exit
	IFD			ENABLE_RASTERMONITOR
	move.w		#$0f0,$dff180
	ENDIF

	movem.l		(sp)+,d3-d6/a3
	rts


; Brick-drawing.
; In:	a2 = address to brick structure to be drawn
; In:	d2.w = X pos
; In:	d3.w = Y pos
DrawNewBrickGfxToGameScreen:
	tst.b		BrickGfxPtr(a2)		; Anything to copy?
	bmi.w		.exit

	movem.l		d2/d6/a2-a3,-(sp)
	
	lsr.w		#3,d2

	move.l		GAMESCREEN_BackPtr(a5),a3; Set up destination
	move.l		d3,d6
	mulu.w		#(RL_SIZE*4),d6		; TODO: dynamic handling of no. of bitplanes if needed
	add.l		d2,d6				; Add byte (x pos) to longword (y pos)
	add.l		d6,a3

	move.l		BrickGfxPtr(a2),a2
	CPUCPY168	a2,a3
	move.l		GAMESCREEN_Ptr(a5),a3	; Set up destination
	add.l		d6,a3
	CPUCPY168	a2,a3

	; Little faster but less flexible - can't blit on "byte basis" without shift+masking
	; move.l 	GAMESCREEN_BackPtr(a5),a1	; Set up destination
	; move.l	d3,d6
	; mulu.w	#(RL_SIZE*4),d6			; TODO: dynamic handling of no. of bitplanes if needed
	; add.l	d2,d6					; Add byte (x pos) to longword (y pos)
	; add.l	d6,a1

	; moveq	#DEFAULT_MASK,d0
	; moveq	#RL_SIZE-2,d1
	; move.l	BrickGfxPtr(a2),a0
	; bsr		CopyBlit

	; move.l	GAMESCREEN_Ptr(a5),a1	; Set up destination
	; add.l	d6,a1
	; bsr		CopyBlit

	movem.l		(sp)+,d2/d6/a2-a3
.exit
	rts



; CopperlistBlitQueue:
; 	REPT	15
; 		dc.l	0		; SOURCE address
; 		dc.l	0		; DESTINATION address
; 		dc.w	0		; Bytes to copy
; 	ENDR
; BlitQueuePtr:
; 	dc.l	CopperlistBlitQueue
; BlitQueueEndPtr:
; 	dc.l	0

; MAX_BLITSIZE	=	$1000

; ; Copies *all* longwords in queue (descending) using blitter up to 4096 (0x1000) bytes at a time.
; ;In:	d1 = ascending/decending (first byte of BLTCON0)
; ProcessCompleteBlitQueue:
; 	movem.l	d3/a5,-(sp)

; 	; move.w	#%0000000010000000,DMACON(a6) 	; Disable copper DMA

; 	lea 	CUSTOM,a6

; 	move.l 	#$09f00000,d3
; 	add.b	d1,d3

;  	move.l 	d3,BLTCON0(a6)		; Copy A->D minterm, and ascending/decending mode
;  	move.w 	#$ffff,BLTAFWM(a6)
;  	move.w 	#$ffff,BLTALWM(a6)
;  	move.w	#0,BLTAMOD(a6)		; NO modulo for simple mem copy
;  	move.w	#0,BLTDMOD(a6)

; 	move.l	BlitQueuePtr,a5
; .loop
; 	cmpa.l	BlitQueueEndPtr,a5	; Is queue empty?
; 	beq.s	.exit

; 	moveq	#0,d3
; 	move.w 8(a5),d3			; Fetch no of bytes from queue
; 	; Calculate blitsize
; 	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
; 	add.b	#%10,d3			; Set blit "width" to 2 words

; 	WAITBLIT
;  	move.l 	(a5),BLTAPTH(a6)
;  	move.l 	4(a5),BLTDPTH(a6)
;  	move.w 	d3,BLTSIZE(a6)

; 	add.l	#4+4+2,a5		; Advance the queue pointer

; 	bra.s	.loop

; .exit
; 	; move.w	#%1000000010000000,DMACON(a6) 	; Enable copper DMA

; 	movem.l	(sp)+,d3/a5
; 	rts

; ; Copies longwords (descending) using blitter up to 4096 (0x1000) bytes at a time.
; ProcessBlitQueue:
; 	movem.l	d3/a5,-(sp)

; 	move.l	BlitQueuePtr,a5
; 	cmpa.l	BlitQueueEndPtr,a5	; Is queue empty?
; 	beq.s	.exit

; 	move.w 8(a5),d3			; Fetch no of bytes from queue
; 	; Calculate blitsize
; 	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
; 	add.b	#%10,d3			; Set blit "width" to 2 words

; 	; move.w	#%0000000010000000,DMACON(a6) 	; Disable copper DMA

; 	WAITBLIT
;  	move.l 	(a5),BLTAPTH(a6)
;  	move.l 	4(a5),BLTDPTH(a6)
;  	move.w 	d3,BLTSIZE(a6)

; 	addi.l	#4+4+2,BlitQueuePtr	; Advance the pointer
; 	; move.w	#%1000000010000000,DMACON(a6) 	; Enable copper DMA
; .exit

; 	movem.l	(sp)+,d3/a5
; 	rts