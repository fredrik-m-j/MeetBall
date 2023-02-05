; Draws/redraws a GAMAREA row.
; Reason: Updating the copperlist for the entire row is easier than
; modifying copperlist for a single brick.
; In	a5 = pointer to brick in GAMEAREA
DrawBrickGameAreaRow:
	move.l	a0,-(sp)

	bsr	GetAddressForCopperChanges
	bsr	UpdateCopperlist

	move.l	d7,d1			; Lookup copperpointer into next GAMAREA row
	addq.w	#1,d1

	add.w	d1,d1			; Convert to longword
	add.w	d1,d1

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	add.l	d1,a2
	move.l	(a2),d0

	swap	d0

	move.w	#$84,(a1)+	; Write to COP2LC to jump to instructions for next GAMAREA row
	move.w	d0,(a1)+

	swap	d0

	move.w	#$86,(a1)+
	move.w	d0,(a1)+

	move.w	#$8a,(a1)+	; COPJMP2
	move.w	#$0,(a1)+

	IFNE	ENABLE_BRICKRASTERMON
	move.w	#$fff,$dff180
	ENDC
	move.l	(sp)+,a0
        rts


; Updates the GAMEAREA copperlist pointers for GAMEAREA rows below this one.
; In:	a3 = pointer into copperlist where instructions were added or removed
; In:	d0.b = Size of copperlist extension in bytes - CAN BE NEGATIVE
; In:	d7 = GAMEAREA row that will be updated
UpdateGameareaCopperPts:
	addq.w	#1,d7			; Start updating from next GAMEAREA row
	move.l	d7,d1

	add.w	d7,d7			; Convert to longword
	add.w	d7,d7

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	add.l	d7,a2

.loop
	cmpi.b	#32,d1			; Is last GAMEAREA row?
	beq.s	.done

	move.l	(a2)+,d2		; Fetch address to this rows' first WAIT instruction
	beq.s	.noCopperPtr

	add.l	d0,d2
	move.l	d2,-4(a2)

.noCopperPtr
	addq.b	#1,d1
	bra.s	.loop

.done
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

        ; Find previous GAMEAREA tile on one of the previous GAMEAREA row(s).
        move.l	a5,a1
        sub.l   d3,a1           	; Set address to first byte in the row
        				; Set up address to start of GAMEAREA row for loop later
	lea	(1,a1),a0		; OUT: +1 -> compensate for 1st empty byte on GAMEAREA row
	move.l	a0,a4			; OUT: Copy of GAMEAREA row start address


	move.l	d7,d3
	add.w	d3,d3			; Convert to longword
	add.w	d3,d3

	lea	GAMEAREA_ROWCOPPERPTRS,a1
	move.l	(a1,d3),a1

	rts


; In:	a0 = game area ROW pointer
; In:	a1 = pointer into copperlist where COLOR00 changes go
; In:	a4 = start of game area ROW pointer.
; In:	a5 = pointer to brick in GAMEAREA.
; In:	d7 = GAMEAREA row that will be updated
 UpdateCopperlist:
	moveq	#0,d2			; Relative rasterline 0-7
.nextRasterline
	cmpi.b	#8,d2
	beq.s	.done

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
        cmpi.w	#$100,d0
        bne.s   .noWrap
	tst.b	Player0Enabled		; Special case: not enough time for WAIT
	bne.s	.noWrap
	move.l	#WAIT_VERT_WRAP,(a1)+	; Insert VertPos WAIT to await end of line $ff
.noWrap

	moveq	#0,d3           	; GAMEAREA byte 0-40
.loop
	cmpi.b	#40,d3
	bge.s 	.doneRasterline

	moveq	#0,d1
	move.b	(a0),d1			; Find next tile that need COLOR00 changes
	beq.b	.nextByte

	add.l	d1,d1			; Convert .b to .l
	add.l	d1,d1
	lea	TileMap,a2
	add.l	d1,a2			; Lookup in tile map
	move.l 	hAddress(a2),a2


	cmpa.l	a0,a5			; Is this a new brick?
	bne.s	.copperUpdates
	tst.b	d2			; Is it relative rasterline 0?
	bne.s	.copperUpdates

	bsr	DrawNewBrickGfxToGameScreen

.copperUpdates
	bsr	UpdateCopperlistForTileLine

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.nextByte

	addq.l	#1,a0			; Skip over a byte in this iteration
	addq.b	#1,d3
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos

.nextByte
	addq.l	#1,a0
	addq.b	#1,d3
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos

	bra.s	.loop
.doneRasterline
        lea	(-40,a0),a0		; Reset game area ROW pointer

	addq.b	#1,d2
	bra.s	.nextRasterline
.done
        rts


; Updates game copper list with CORLOR00 updates.
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick struct
; In:	a4 = start of game area ROW pointer
; In:	a6 = address to potential color fade
; In:	d0.b = rasterline being drawn
; In:	d2.b = relative rasterline 0-7 being drawn
; In:	d4.w = raster position to wait for
UpdateCopperlistForTileLine:

	; Check if there is time enough for a copper WAIT instruction
	cmpa.l	a0,a4		; There is always time enough for tile 0
	beq.s	.addWait

	tst.b	-1(a0)
	bne.s	.doneCopperWait
	tst.b	-2(a0)
	bne.s	.doneCopperWait
	tst.b	-3(a0)
	bne.s	.addBlackColor00

.addWait
	move.w	d4,(a1)+	; Wait for this position unless previous tile also needed color change
	move.w	#$fffe,(a1)+	; If previous tile needed color change then there is not enough time for a wait
	bra.s	.doneCopperWait

.addBlackColor00
	move.l	#COLOR00<<16+$0,(a1)+	; No time for WAIT - just add 1 black COLOR00

.doneCopperWait
	moveq	#1,d5
	move.b	d2,d5
	lsl.w	#3,d5			; rasterline in d2 * 2 longwords per rasterline in brickstruct

	move.l	hBrickColorY0X0(a2,d5.w),(a1)+

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.checkNextSingleTile

	move.l	4+hBrickColorY0X0(a2,d5.w),(a1)+

	tst.b	2(a0)
	beq.s	.resetToBlack

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
.exit
	rts



; 1 memory copy for storing background gfx in scrap area + another for brick-drawing.
; In:	a2 = address to brick structure to be drawn
; In:	d0.w = current Y position / rasterline
; In:	d3.b = current X position byte
DrawNewBrickGfxToGameScreen:
	tst.l	hAddress(a2)		; Anything to copy?
	bmi.w	.exit

	move.l 	GAMESCREEN_BITMAPBASE,a3; Set up source/destination
	move.l	d0,d6
	subi.w	#FIRST_Y_POS,d6
	mulu.w	#(ScrBpl*4),d6		; TODO: dynamic handling of no. of bitplanes if needed
	add.l	d3,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,a3

	move.l	a3,a6
	move.l	hAddress(a2),a3
	bsr	CopyBrickGraphics
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
;  	move.w 	#0,BLTAMOD(a6)		; NO modulo for simple mem copy
;  	move.w 	#0,BLTDMOD(a6)

; 	move.l	BlitQueuePtr,a5
; .loop
; 	cmpa.l	BlitQueueEndPtr,a5	; Is queue empty?
; 	beq.s	.exit

; 	moveq	#0,d3
; 	move.w 8(a5),d3			; Fetch no of bytes from queue
; 					; Calculate blitsize
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
; 					; Calculate blitsize
; 	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
; 	add.b	#%10,d3			; Set blit "width" to 2 words

; 	; move.w	#%0000000010000000,DMACON(a6) 	; Disable copper DMA

; 	lea 	CUSTOM,a6
; 	WAITBLIT
;  	move.l 	(a5),BLTAPTH(a6)
;  	move.l 	4(a5),BLTDPTH(a6)
;  	move.w 	d3,BLTSIZE(a6)

; 	addi.l	#4+4+2,BlitQueuePtr	; Advance the pointer
; 	; move.w	#%1000000010000000,DMACON(a6) 	; Enable copper DMA
; .exit

; 	movem.l	(sp)+,d3/a5
; 	rts