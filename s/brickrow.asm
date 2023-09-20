; Draws/redraws a GAMAREA row.
; Reason: Updating the copperlist for the entire row is easier than
; modifying copperlist for a single brick.
; In	a5 = pointer to brick in GAMEAREA
DrawBrickGameAreaRow:
	move.l	a0,-(sp)

	bsr	GetAddressForCopperChanges
	bsr	UpdateCopperlist
	bsr	AddCopperJmp

	move.l	(sp)+,a0
        rts

; In:	a1 = Pointer into copper list (position after making changes for 1 GAMEAREA row).
; In:	d7 = GAMEAREA row that was updated
AddCopperJmp:
	move.l	d7,d1			; Lookup copperpointer into next GAMAREA row
	addq.w	#1,d1

	lsl	#3,d1			; Convert to 2*longword

	lea	GAMEAREA_ROWCOPPER,a2
	move.l	(a2,d1.l),d0
	beq.s	.setNewEnd		; This is the last GAMEAREA row

	cmp.l	d0,a1			; This GAMEAREA row has maxed out copperinstructions
	beq.s	.exit

	swap	d0

	move.w	#$84,(a1)+		; Write to COP2LC to jump to instructions for next GAMAREA row
	move.w	d0,(a1)+

	swap	d0

	move.w	#$86,(a1)+
	move.w	d0,(a1)+

	move.w	#$8a,(a1)+		; COPJMP2
	move.w	#$0,(a1)+

	bra.s	.exit
.setNewEnd
	move.l	#COPPERLIST_END,(a1)
	move.l	a1,END_COPPTR_GAME_TILES

.exit
	IFNE	ENABLE_BRICKRASTERMON
	move.w	#$fff,$dff180
	ENDC
	rts

; Finds the start position in copperlist where COLOR00 changes should be made from saved pointers.
; Also calculates other pointers and values needed later.
; Finds GAMEAREA row start
; In:	a5 = pointer to brick in GAMEAREA
; Out:	a0 = GAMEAREA row start address
; Out:	a1 = pointer into copperlist where COLOR00 changes should be made.
; Out:	a4 = Copy of GAMEAREA row start address
; Out:	d7 = GAMEAREA row that will be updated
GetAddressForCopperChanges:
	move.l	a5,d7
	sub.l	#GAMEAREA,d7		; Which GAMEAREA byte is it?

	add.l	d7,d7
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.l	d7,a2

	moveq	#0,d7
	moveq	#0,d3
	move.b	(a2)+,d3		; Col / X pos
	move.b	(a2),d7			; Row / Y pos

        move.l	a5,a1
        sub.l   d3,a1           	; Set address to first byte in the row
        				; Set up address to start of GAMEAREA row for loop later
	lea	(1,a1),a0		; OUT: +1 -> compensate for 1st empty byte on GAMEAREA row
	move.l	a0,a4			; OUT: Copy of GAMEAREA row start address


	move.l	d7,d3
	lsl	#3,d3			; Convert to 2*longword

	lea	GAMEAREA_ROWCOPPER,a1
	move.l	(a1,d3),a1

	rts

; Updates copperlist for the given GAMEAREA row.
; In:	a0 = GAMEAREA ROW pointer
; In:	a1 = pointer into copperlist where COLOR00 changes go
; In:	a4 = start of GAMEAREA ROW pointer (copy).
; In:	d7 = GAMEAREA row that will be updated
 UpdateCopperlist:
	IFNE	ENABLE_RASTERMONITOR
	move.w	#$444,$dff180
	ENDC

	lea	CopperUpdatesCache,a5
	moveq	#0,d2			; Relative rasterline 0-7

.nextRasterline
	cmpi.b	#8,d2
	beq.w	.done

	move.l	d2,d5			; d5 = offset into COLOR00 MOVEs in tilestruct for this rasterline
	lsl.w	#3,d5			; rasterline in d2 * 2 longwords per rasterline in tilestruct

	move.w	d7,d0
	lsl.w	#3,d0
        add.b   d2,d0
	addi.w	#FIRST_Y_POS,d0		; Rasterline to process

	move.w	d0,d4			; d4 = the position to wait for in copper list
	lsl.w	#8,d4			; move <yy> byte left

	addi.b	#FIRST_X_POS,d4		; Start from FIRST_X_POS
					; Bit 0 must be set to get an awaitable X position in copper list

	; PAL screen - check for Vertical Position wrap
	; If we arrived at a rasterline past the wrapping point - insert the magical WAIT.
        cmpi.w	#$ff+1,d0
        bne.s   .noWrap

	; Check cornercases when there isn't enough time for Vertical Position wrap WAIT, such as:
	; * Player 0 disabled - a wall to the far right
	; * Protective extra wall to the right - "insanoballz-wall"
	; This check might be inexact
	tst.l	41-4(a4)
	bne.s	.noWrap
					
	move.l	#WAIT_VERT_WRAP,(a1)+	; Insert VertPos WAIT to await end of line $ff
	move.l	#COPNOP<<16+$0,(a1)+	; Needed for real hardware. See https://eab.abime.net/showthread.php?p=896188
.noWrap

	moveq	#0,d0			; Used rasterline bytes = 1 rasterline worth of copperinstructions
					; Only counted for relative rasterline 0
	moveq	#40-1,d3           	; GAMEAREA byte 0-40
.nextTileLoop
	moveq	#0,d1
	move.b	(a0),d1			; Find next tile that need COLOR00 changes
	bne.s	.update

	addq.l	#1,a0
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos
	dbf	d3,.nextTileLoop
	bra	.doneRasterline

.update
	tst.b	d2			; Cached data? (cached if relative rasterline >0)
	beq.s	.cacheDataForTile
	
;==============================================================================
;	Avoiding bsr/rts because this is executed up to 40*7 times
;	BEGIN 	SET COPPER INSTRUCTIONS - using cache
	move.w	(a5)+,d0		; Check flags in cache
	beq	.addBlackColor00Cached
	bmi	.setTileColorCached

	move.w	d4,(a1)+
	move.w	#$fffe,(a1)+
	bra	.setTileColorCached
.addBlackColor00Cached
	move.l	#COLOR00<<16+$0,(a1)+
.setTileColorCached
	move.l	(a5)+,a2		; Fetch tile struct from cache

	cmpi.w	#2,hBrickByteWidth(a2)
	beq.s	.twoByteTileCached

	move.l	hBrickColorY0X0(a2,d5.w),(a1)+

	addq.l	#1,a0
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos
	
	tst.b	(a0)
	bne.s	.doneCopperWithCache
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty

	bra	.doneCopperWithCache

.twoByteTileCached
	move.l	hBrickColorY0X0(a2,d5.w),(a1)+
	move.l	4+hBrickColorY0X0(a2,d5.w),(a1)+

	addq.l	#2,a0
	addq.b	#8,d4			; Move the corresponding to 16px forward in X pos	
	subq.b	#1,d3			; Already processed *2* bytes - iterate one further in GAMEAREA row

	tst.b	(a0)
	bne.s	.doneCopperWithCache
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty

.doneCopperWithCache
;	END	SET COPPER INSTRUCTIONS - using cache
;==============================================================================

	dbf	d3,.nextTileLoop
	bra	.doneRasterline


.cacheDataForTile
;==============================================================================
;	Avoiding any bsr/rts because this is executed up to 40*1 times
;	BEGIN 	CREATE CACHE + SET COPPER INSTRUCTIONS (relative rasterline 0)

	move.l	a4,d6		; Check if there is time enough for a copper WAIT instruction
	cmp.l	d6,a0		; There is always time enough for leftmost tile 0
	beq.s	.addWaitFlag

	addq	#1,d6
	cmp.l	d6,a0		; Cornercase: there might be time enough for tile 1
	bne.s	.regularCheck

	move.l	a0,a3

	tst.b	-1(a3)
	bne.s	.noTime
	tst.b	-3(a3)
	bne.s	.addWaitFlag

.regularCheck
	move.l	a0,a3

	tst.b	-(a3)
	bne.s	.noTime
	tst.b	-(a3)
	bne.s	.noTime
	tst.b	-(a3)
	bne.s	.addBlackColor00Flag

.addWaitFlag
	move.w	#1,(a5)+

	move.w	d4,(a1)+
	move.w	#$fffe,(a1)+
	addq.w	#4,d0
	bra.s	.cacheTilestruct
.addBlackColor00Flag
	move.w	#0,(a5)+

	move.l	#COLOR00<<16+$0,(a1)+
	addq.w	#4,d0
	bra.s	.cacheTilestruct
.noTime
	move.w	#-1,(a5)+


.cacheTilestruct
	cmp.l	BlinkBrickGameareaPtr,a0
	bne.s	.notBlinkBrick
	
	move.l	a1,BlinkBrickCopperPtr	; Save address to first blinkbrick copper instruction
	move.l	BlinkBrickStruct,a2
	move.l	a2,(a5)+		; Add to cache
	bra.s	.cacheCreated
.notBlinkBrick
	add.w	d1,d1			; Convert .b to .l
	add.w	d1,d1
	lea	TileMap,a2
	move.l	(a2,d1.l),a2		; Lookup in tile map
	move.l	a2,(a5)+		; Add to cache

.cacheCreated

	cmpi.w	#2,hBrickByteWidth(a2)
	beq.s	.twoByteTile

	move.l	hBrickColorY0X0(a2),(a1)+
	addq.w	#4,d0

	addq.l	#1,a0
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos
	
	tst.b	(a0)
	bne.s	.doneCopper
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
	addq.w	#4,d0
	bra	.doneCopper

.twoByteTile
	move.l	hBrickColorY0X0(a2),(a1)+
	move.l	4+hBrickColorY0X0(a2),(a1)+
	addq.w	#4+4,d0

	addq.l	#2,a0
	addq.b	#8,d4			; Move the corresponding to 16px forward in X pos	
	subq.b	#1,d3			; Already processed *2* bytes - iterate one further in GAMEAREA row

	tst.b	(a0)
	bne.s	.doneCopper
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
	addq.w	#4,d0
.doneCopper
;	END 	CREATE CACHE + SET COPPER INSTRUCTIONS (relative rasterline 0)
;==============================================================================

	dbf	d3,.nextTileLoop


.doneRasterline
	move.l	a4,a0			; Reset game area ROW pointer
	lea	CopperUpdatesCache,a5

	tst.b	d2
	bne	.notFirstRasterline

	lsl	#3,d7			; Save the rasterline bytecount
	lea	GAMEAREA_ROWCOPPER,a6
	move.l	d0,4(a6,d7)
	lsr	#3,d7
.notFirstRasterline

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$080,$dff180
	ENDC

	addq.b	#1,d2
	bra.w	.nextRasterline
.done

	IFNE	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC
        rts


; Brick-drawing.
; In:	a2 = address to brick structure to be drawn
; In:	d2.w = X pos
; In:	d3.w = Y pos
DrawNewBrickGfxToGameScreen:
	tst.b	hAddress(a2)		; Anything to copy?
	bmi.w	.exit

	movem.l	d2/d6/a3/a6,-(SP)
	
	lsr.w	#3,d2

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6	; Set up destination
	move.l	d3,d6
	mulu.w	#(ScrBpl*4),d6		; TODO: dynamic handling of no. of bitplanes if needed
	add.l	d2,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,a6

	move.l	hAddress(a2),a3
	bsr	CopyBrickGraphics

	move.l 	GAMESCREEN_BITMAPBASE,a6	; Set up destination
	add.l	d6,a6
	bsr	CopyBrickGraphics

	movem.l	(SP)+,d2/d6/a3/a6
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

; MAX_BLITSIZE	equ	$1000

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
; 					; Calculate blitsize
; 	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
; 	add.b	#%10,d3			; Set blit "width" to 2 words

; 	WAITBLIT a6
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
; 					; Calculate blitsize
; 	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
; 	add.b	#%10,d3			; Set blit "width" to 2 words

; 	; move.w	#%0000000010000000,DMACON(a6) 	; Disable copper DMA

; 	lea 	CUSTOM,a6
; 	WAITBLIT a6
;  	move.l 	(a5),BLTAPTH(a6)
;  	move.l 	4(a5),BLTDPTH(a6)
;  	move.w 	d3,BLTSIZE(a6)

; 	addi.l	#4+4+2,BlitQueuePtr	; Advance the pointer
; 	; move.w	#%1000000010000000,DMACON(a6) 	; Enable copper DMA
; .exit

; 	movem.l	(sp)+,d3/a5
; 	rts


; ; Sets CORLOR00 MOVE instruction(s) and WAIT (if needed) into copperlist for current rasterline.
; ; Covers 1 tile/brick. Tiles can be 1 byte (8px) or 2 bytes (16px) in GAMEAREA.
; ; First, a WAIT or black COLOR00 *might* be inserted depending existence of any previous tile(s).
; ; Then, colors from tilestruct are copied.
; ; Finally, black COLOR00 is inserted if next GAMEAREA byte is empty.
; ; In:	a0 = current GAMEAREA ROW pointer
; ; In:	a1 = pointer into copper list
; ; In:	a5 = CopperUpdatesCache
; ; In:	d5.w = offset into color-words
; ; In:	d4.w = raster position to wait for
; SetCopperInstructions:
; 	move.w	(a5)+,d0		; Check flags in cache
; 	beq	.addBlackColor00
; 	bmi	.setTileColor

; 	move.w	d4,(a1)+
; 	move.w	#$fffe,(a1)+
; 	bra	.setTileColor
; .addBlackColor00
; 	move.l	#COLOR00<<16+$0,(a1)+
; .setTileColor
; 	move.l	(a5)+,a2		; Fetch tile struct from cache

; 	cmpi.w	#2,hBrickByteWidth(a2)
; 	beq.s	.twoByteTile

; 	move.l	hBrickColorY0X0(a2,d5.w),(a1)+

; 	addq.l	#1,a0
; 	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos
	
; 	tst.b	(a0)
; 	bne.s	.exit1
; 	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
; .exit1
; 	rts

; .twoByteTile
; 	move.l	hBrickColorY0X0(a2,d5.w),(a1)+
; 	move.l	4+hBrickColorY0X0(a2,d5.w),(a1)+

; 	addq.l	#2,a0
; 	addq.b	#8,d4			; Move the corresponding to 16px forward in X pos	
; 	subq.b	#1,d3			; Already processed *2* bytes - iterate one further in GAMEAREA row

; 	tst.b	(a0)
; 	bne.s	.exit2
; 	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
; .exit2
; 	rts