; NOTE: this has become a rather complex way of manipulating the copperlist.

CopperlistBlitQueue:
	REPT	15
		dc.l	0		; SOURCE address
		dc.l	0		; DESTINATION address
		dc.w	0		; Bytes to copy
	ENDR
BlitQueuePtr:
	dc.l	CopperlistBlitQueue
BlitQueueEndPtr:
	dc.l	0

MAX_BLITSIZE	equ	$1000


; Draws/redraws GAMAREA row with the new brick in it.
; Reason: Updating the copperlist for the entire row is easier than
; modifying copperlist for a single brick.
; In	a5 = pointer to new brick in GAMEAREA
DrawBrickGameAreaRow:
	move.l	a0,-(sp)

	bsr	GetAddressForCopperChanges

	moveq	#0,d4
	moveq	#0,d2			; Rasterline 0-7
.loop
	cmpi.b 	#8,d2
	beq.s 	.doneGameAreaRowDraw

	bsr	UpdateCopperlistForRasterLine

	addq.b 	#1,d2
        bra.s 	.loop
.doneGameAreaRowDraw

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


	; move.w	#$fff,$dff180

	move.l	(sp)+,a0
        rts




; ; Draws/redraws GAMAREA row with the new brick in it.
; ; Reason: Updating the copperlist for the entire row is easier than
; ; modifying copperlist for a single brick.
; ; In	a5 = pointer to new brick in GAMEAREA
; DrawGameAreaRowWithNewBrick:
; 	move.l	a0,-(sp)

; 	bsr	GetAddressForCopperChanges
; 	bsr	SaveCopperPtr

; .modifyCopperlist

; 	bsr	CalculateCopperlistSizeChange

;         tst.b   d0              	; Need to extend copperlist size?
;         beq   .draw

; .extendCopperList

; 	bsr	GetAddressForCopyBack

; 	; move.l	#COPPTR_GAME_SCRAP,a2
; 	; move.l	hAddress(a2),d4		; Out of address registers - use data register

; 	lea 	END_COPPTR_GAME_TILES,a2
; 	move.l	hAddress(a2),a2

; 	move.l	a2,d3			; Calculate bytes to copy
; 	sub.l	a3,d3

; 	sub.l	d0,d3			; (treat the top bytes separately)

; 	move.l	a2,d1			; Source A in d1 = final word of Copperlist
; 	addq.l	#2,d1			; Target lower word

; 	move.l	a2,d4			
; 	add.l	d0,d4			; Destination D = bottom of copperlist + new bytes needed

; 	move.l  d4,END_COPPTR_GAME_TILES	; Set pointer to new end of copperlist
; 	add.l	#2,d4			; Then target lower word for blitting

	
; 	move.l	COPPTR_GAME_SCRAP,d6
; 	move.l	d6,d5
; 	add.l	d0,d5
; 	subq.l	#2,d5			; Target lower word

; 	move.l	a3,a6
; 	add.l	d0,a6
; 	addq.l	#2,a6			; Target lower word

; 	; Add a first copy of bytes that are at risk of being overwritten by .draw
; 	move.l	#CopperlistBlitQueue,a2
; 	move.l	a6,(a2)+		; Source A = last (bottom of top-end) copyback in copperlist
; 	move.l	d5,(a2)+		; Destination D = bottom of scrap
; 	move.w	d0,(a2)+

; 	moveq	#0,d6
; .fillBlitQueue
; 	cmpi.w	#MAX_BLITSIZE,d3	; Check remaining bytes
; 	bmi.s	.normalSize

; 	move.w	#MAX_BLITSIZE,d6	; Max blit size (in our case)
; 	bra.s	.createQueueItem
; .normalSize
; 	move.w	d3,d6

; .createQueueItem
; 	move.l	d1,(a2)+
; 	move.l	d4,(a2)+
; 	move.w	d6,(a2)+

; 	sub.l	d6,d1			; A and D pointers move up in the copperlist
; 	sub.l	d6,d4
; 	sub.w	d6,d3			; Subtract to get remaining bytes
; 	beq.s	.queueCreated
; 	bra.s	.fillBlitQueue

; .queueCreated
; 	; Last copy - bytes that are at risk of being overwritten by .draw
; 	move.l	d5,(a2)+		; Source A = bottom of scraparea
; 	move.l	d4,(a2)+		; Destination D = last (bottom of top-end) copyback in copperlist
; 	move.w	d0,(a2)+

; 	move.l	#CopperlistBlitQueue,BlitQueuePtr
; 	move.l	a2,BlitQueueEndPtr	; Store end of queue (points to last item +1)


;  	move.l 	#$09f00002,CUSTOM+BLTCON0	; Copy A->D minterm, descending mode
;  	move.w 	#$ffff,CUSTOM+BLTAFWM
;  	move.w 	#$ffff,CUSTOM+BLTALWM
;  	move.w 	#0,CUSTOM+BLTAMOD		; NO modulo for simple mem copy
;  	move.w 	#0,CUSTOM+BLTDMOD

; .draw
; 	move.l	a1,a3			; Keep insertion pointer
; 	move.l	d0,-(sp)

; 	moveq	#0,d4
; 	moveq	#0,d2			; Rasterline 0-7
; .loop
; 	cmpi.b 	#8,d2
; 	beq.s 	.doneGameAreaRowDraw

; 	btst	#6,CUSTOM+DMACONR
; 	bne.s	.blitterBusy

; 	bsr	ProcessBlitQueue

; .blitterBusy
; 	bsr	UpdateCopperlistForRasterLine

; 	addq.b 	#1,d2
;         bra.s 	.loop
; .doneGameAreaRowDraw

; 	move.l	(sp)+,d0
; 	; Copperlist increased?
; 	beq.s	.done
; 	bsr	UpdateGameareaCopperPts

; .done
; 	moveq	#$2,d1
; 	bsr	ProcessCompleteBlitQueue
; 	WAITBLIT

; 	move.w	#$fff,$dff180


; 	move.l	(sp)+,a0
;         rts


; Copies *all* longwords in queue (descending) using blitter up to 4096 (0x1000) bytes at a time.
;In:	d1 = ascending/decending (first byte of BLTCON0)
ProcessCompleteBlitQueue:
	movem.l	d3/a5,-(sp)

	; move.w	#%0000000010000000,DMACON(a6) 	; Disable copper DMA

	lea 	CUSTOM,a6

	move.l 	#$09f00000,d3
	add.b	d1,d3

 	move.l 	d3,BLTCON0(a6)		; Copy A->D minterm, and ascending/decending mode
 	move.w 	#$ffff,BLTAFWM(a6)
 	move.w 	#$ffff,BLTALWM(a6)
 	move.w 	#0,BLTAMOD(a6)		; NO modulo for simple mem copy
 	move.w 	#0,BLTDMOD(a6)

	move.l	BlitQueuePtr,a5
.loop
	cmpa.l	BlitQueueEndPtr,a5	; Is queue empty?
	beq.s	.exit

	moveq.l	#0,d3
	move.w 8(a5),d3			; Fetch no of bytes from queue
					; Calculate blitsize
	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
	add.b	#%10,d3			; Set blit "width" to 2 words

	WAITBLIT
 	move.l 	(a5),BLTAPTH(a6)
 	move.l 	4(a5),BLTDPTH(a6)
 	move.w 	d3,BLTSIZE(a6)

	add.l	#4+4+2,a5		; Advance the queue pointer

	bra.s	.loop

.exit
	; move.w	#%1000000010000000,DMACON(a6) 	; Enable copper DMA

	movem.l	(sp)+,d3/a5
	rts

; Copies longwords (descending) using blitter up to 4096 (0x1000) bytes at a time.
ProcessBlitQueue:
	movem.l	d3/a5,-(sp)

	move.l	BlitQueuePtr,a5
	cmpa.l	BlitQueueEndPtr,a5	; Is queue empty?
	beq.s	.exit

	move.w 8(a5),d3			; Fetch no of bytes from queue
					; Calculate blitsize
	lsl.l	#6-2,d3			; Bitshift size up to "height" bits of BLTSIZE and convert to longwords (hence -2)
	add.b	#%10,d3			; Set blit "width" to 2 words

	; move.w	#%0000000010000000,DMACON(a6) 	; Disable copper DMA

	lea 	CUSTOM,a6
	WAITBLIT
 	move.l 	(a5),BLTAPTH(a6)
 	move.l 	4(a5),BLTDPTH(a6)
 	move.w 	d3,BLTSIZE(a6)

	addi.l	#4+4+2,BlitQueuePtr	; Advance the pointer
	; move.w	#%1000000010000000,DMACON(a6) 	; Enable copper DMA
.exit

	movem.l	(sp)+,d3/a5
	rts

; Find out how many longwords, if any, need to be inserted into copperlist.
; In:	a5 = pointer to new/deleted brick in GAMEAREA
; Out:	d0.b = number of bytes to be added/removed from copperlist, if any.
CalculateCopperlistSizeChange:
        ; Assume the brick is NOT adjacent to any other
        ; -> 4 longwords * for 8 rasterlines needed
	; 1st longword: Copper WAIT instruction
	; 2nd longword: COLOR00 for first 8 pixels
	; 3rd longword: COLOR00 for last 8 pixels
	; 4th longword: Reset COLOR00 to black
        move.l  #4*4*8,d0

        tst.b   -2(a5)          ; Adjacent tile(s) to the far left? (time enough for WAIT?)
        beq.s   .noAdjacentFarLeftTile
        sub.b   #1*4*8,d0
.noAdjacentFarLeftTile
	tst.b   -1(a5)          ; Adjacent tile(s) to the left? (time enough for WAIT?)
	beq.s   .noAdjacentLeftTile
        sub.b   #1*4*8,d0

.noAdjacentLeftTile
        tst.b   2(a5)           ; Adjacent tile to the right? (time enough for reset to black?)
        beq.s   .noAdjacentRightTile
        sub.b   #2*4*8,d0
.noAdjacentRightTile
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
	move.b	(a2)+,d3		; Row / X pos
	move.b	(a2),d7			; Col / Y pos

        ; Find previous GAMEAREA tile on one of the previous GAMEAREA row(s).
        move.l	a5,a1
        sub.l   d3,a1           	; Set address to first byte in the row
        				; Set up address to start of GAMEAREA row for loop later
	lea	(1,a1),a0		; OUT: +1 -> compensate for 1st empty byte on GAMEAREA row
	move.l	a0,a4			; OUT: Copy of GAMEAREA row start address


	move.l	d7,d3

	add.w	d3,d3			; Convert to longword
	add.w	d3,d3

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	add.l	d3,a2

	move.l	(a2),a1
	tst.l	(a1)
	bne.s	.found			; Found pointer to COLOR00 changes on current row

.loop
	move.l	(a2)+,a1		; Fetch address to next row's first WAIT instruction
	tst.l	(a1)
	bne.s	.found
	bra.s	.loop

.found
	cmpi.b	#26,d7			; Adding new brick below row 26 (where VPOS wrap is)?
	bhi.s	.done
.handleWrap
	move.l	-(a1),d3
	cmpi.l	#WAIT_VERT_WRAP,d3	; Preserve the wrap, or rewrite it if row = 26
	beq.s	.done

	addq.l	#4,a1			; No wrap was found
.done
	rts


; Finds the position in copperlist from where COLOR00 changes should be preserved.
; I.e. the color changes on rows below the current one.
; In:	a5 = pointer to brick in GAMEAREA
; In:	a1 = pointer to insertion point in copperlist
; In:	d7 = GAMEAREA row that will be updated
; Out:	a3 = pointer into copperlist from where the following copper instructions should be kept
GetAddressForCopyBack:
	move.l	d7,d3
	addq.w	#1,d3			; Start checking from next GAMEAREA row
	add.w	d3,d3			; Convert to longword
	add.w	d3,d3

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	add.l	d3,a2

.loop
	move.l	(a2)+,a3		; Fetch address to this rows' first WAIT instruction
	tst.l	(a3)
	bne.s	.checkWrap
	bra.s	.loop			; Check next GAMEAREA row

.checkWrap
	cmpi.b	#26,d7			; Adding new brick below row 26 (where VPOS wrap is)?
	bhi.s	.done

	move.l	-(a3),d3
	cmpi.l	#WAIT_VERT_WRAP,d3
	beq.s	.done			; Preserve the wrap, or rewrite it if row = 26

	addq.l	#4,a3
.done
	subq	#4,a3			; Include one more longword to get correct blit size
	rts



; ; Draws/redraws GAMAREA row with one less brick in it.
; ; Reason: Updating the copperlist for the entire row is easier than
; ; modifying copperlist for a single brick.
; ; In	a5 = pointer to deleted brick in GAMEAREA
; DrawGameAreaRowWithDeletedBrick:

;         bsr	GetAddressForCopperChanges
; 	bsr	CalculateCopperlistSizeChange

;         tst.b   d0              	; Need to reduce copperlist size?
;         beq.s   .draw
; .reduceCopperlist

; 	bsr	GetAddressForCopperRemainder

; 	lea 	END_COPPTR_GAME_TILES,a2
; 	move.l	hAddress(a2),a2

; 	move.l	a2,d3			; Calculate bytes to copy "up"
; 	sub.l	a3,d3

; 	move.l	a3,d1			; Source A in d1 = first word of next GAMEAREA Copperlist instruction to keep

; 	move.l	a3,d4			
; 	sub.l	d0,d4			; Destination D = first word of next GAMEAREA minus removed bytes


; 	moveq	#0,d6
; 	move.l	#CopperlistBlitQueue,a2
; .fillBlitQueue
; 	cmpi.w	#MAX_BLITSIZE,d3	; Check remaining bytes
; 	bmi.s	.normalSize

; 	move.w	#MAX_BLITSIZE,d6	; Max blit size (in our case)
; 	bra.s	.createQueueItem
; .normalSize
; 	move.w	d3,d6

; .createQueueItem
; 	move.l	d1,(a2)+
; 	move.l	d4,(a2)+
; 	move.w	d6,(a2)+

; 	add.l	d6,d1			; A and D pointers move down in the copperlist
; 	add.l	d6,d4
; 	sub.w	d6,d3			; Subtract to get remaining bytes
; 	beq.s	.queueCreated
; 	bra.s	.fillBlitQueue

; .queueCreated
; 	move.l	#CopperlistBlitQueue,BlitQueuePtr
; 	move.l	a2,BlitQueueEndPtr	; Store end of queue (points to last item +1)


;  	move.l 	#$09f00000,CUSTOM+BLTCON0	; Copy A->D minterm, ascending mode
;  	move.w 	#$ffff,CUSTOM+BLTAFWM
;  	move.w 	#$ffff,CUSTOM+BLTALWM
;  	move.w 	#0,CUSTOM+BLTAMOD		; NO modulo for simple mem copy
;  	move.w 	#0,CUSTOM+BLTDMOD


; .draw
; 	move.l	a1,a3				; Keep deletion pointer
; 	move.l	d0,-(sp)

; 	moveq	#0,d4
; 	moveq	#0,d2				; Rasterline 0-7
; .loop
; 	cmpi.b 	#8,d2
; 	beq.s 	.doneGameAreaRowDraw

; 	btst	#6,CUSTOM+DMACONR
; 	bne.s	.blitterBusy

; 	bsr	ProcessBlitQueue

; .blitterBusy
;         bsr	UpdateCopperlistForRasterLine
	
; 	addq.b 	#1,d2
;         bra.s 	.loop
; .doneGameAreaRowDraw

; 	move.l	(sp)+,d0

; 	sub.l  	d0,END_COPPTR_GAME_TILES	; Set end of copperlist
; 	move.l	END_COPPTR_GAME_TILES,a2
; 	move.l	#COPPERLIST_END,(a2)

; 	moveq	#$0,d1
; 	bsr	ProcessCompleteBlitQueue
; 	WAITBLIT


; 	move.w	#$fff,$dff180



; 	lea	GAMEAREA_ROWCOPPERPTRS,a0	; This GAMEAREA row has no COLOR00 instructions?
; 	move.l	d7,d1
; 	add.l	d1,d1				; Convert to longword
; 	add.l	d1,d1

; 	add.l	d1,a0

; 	move.l	a1,d1
; 	sub.l	a3,d1
; ; NOTE cmp.b was not enough - is .w really enough?
; 	cmp.w	#4+4,d1				; (+4 = a1 is post-incremented, also +4 for potential VPOS wait)
; 	bhi.s	.updateSubsequentialPtrs

; 	move.l	#0,(a0)				; Clear the pointer

; .updateSubsequentialPtrs
; 	tst.b	d0
; 	beq.s	.done				; No size change

; 	neg.l	d0
; 	bsr	UpdateGameareaCopperPts
; .done
;         rts

; Gets the address for all the copper instructions that must be moved up when removing brick.
; In:	d7.b = GAMEAREA row
; Out:	a3 = Address to first copper instruction to move (which is the Source for the blit).
GetAddressForCopperRemainder:
	move.l	d7,d1
	addq.w	#1,d1

	add.w	d1,d1			; Convert to longword
	add.w	d1,d1

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	add.l	d1,a2

.loop
	move.l	(a2)+,a3		; Fetch address to this rows' first WAIT instruction
	tst.l	(a3)
	bne.s	.done
	bra.s	.loop			; Check next GAMEAREA row

.done
	rts


; In:	a0 = game area ROW pointer
; In:	a1 = pointer into copperlist where COLOR00 changes go
; In:	a5 = pointer to new/removed brick in GAMEAREA
; In:	d2.b = relative rasterline 0-7 being drawn
; In:	d7.l =  Upper word: GAMEAREA byte 
;               Lower word: GAMEAREA row
 UpdateCopperlistForRasterLine:
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
	bge.s 	.done

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

	cmpi.w	#2,hTileByteWidth(a2)
	bne.s	.nextByte
	
	addq.l	#1,a0			; Skip over a byte in this iteration
	addq.b	#1,d3		
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos

.nextByte
	addq.l	#1,a0
	addq.b	#1,d3
	addq.b	#4,d4			; Move the corresponding to 8px forward in X pos
	
	bra.s	.loop
.done
        lea	(-40,a0),a0		; Reset game area ROW pointer
        rts


; Saves the copperptr to the first copper instruction for specified GAMEAREA row.
; In:	a1 = pointer into copperlist where COLOR00 changes go
; In:	d7.b = GAMEAREA row
SaveCopperPtr:
	moveq 	#0,d5
	move.b	d7,d5
	add.b	d5,d5			; Convert to longwords
	add.b	d5,d5

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	add.l	d5,a2
	move.l	a1,(a2)

	rts



; Updates game copper list with CORLOR00 updates.
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick
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

	cmpi.b	#$32,(a0)
	blo.s	.regularBrick

	cmpi.b	#$3a,(a0)
	blo.s	.diamondBrick

	bsr	WriteRibbedBrickColor
	bra.s	.exit
.diamondBrick
	bsr	WriteDiamondBrickColor
	bra.s	.exit
.regularBrick
	bsr	WriteTileColor
.exit
	rts



; 1 memory copy for storing background gfx in scrap area + another for brick-drawing.
; In:	a2 = address to brick structure to be drawn
; In:	d0.w = current Y position / rasterline
; In:	d3.b = current X position byte
DrawNewBrickGfxToGameScreen:
	tst.l	hAddress(a2)		; Anything to copy?
	bmi.w	.exit

	movem.l	d6/a5-a6,-(SP)

	move.l 	GAMESCREEN_BITMAPBASE,a5; Set up source/destination
	move.l	d0,d6
	subi.w	#FIRST_Y_POS,d6
	mulu.w	#(ScrBpl*4),d6		; TODO: dynamic handling of no. of bitplanes if needed
	add.l	d3,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,a5

	move.l	SCRAPPTR_BITMAPBASE,a6
	lea	hAddress(a6),a6
	lea	(a6,d6.l),a6

	bsr	CopyBrickGraphics

	move.l	a5,a6
	move.l	hAddress(a2),a5
	bsr	CopyBrickGraphics

	movem.l	(SP)+,d6/a5-a6
.exit
	rts