; Draws/redraws GAMAREA row with the new brick in it.
; Reason: Updating the copperlist for the entire row is easier than
; modifying copperlist for a single brick.
; In	a5 = pointer to new brick in GAMEAREA
DrawGameAreaRowWithNewBrick:
	move.l	a0,-(sp)

        ; Find last of previous row's COLOR00 changes (might be several rows away)
        ; OR find Vertical Position wrap (PAL screen)
        ; Copperlist WILL contain $ffdffffe because of routine "DrawGameAreaRow"
	; OR $ffd?ffffe if Player0 is disabled and there is no time for a WAIT

	bsr	GetAddressForCopperChanges

        cmpi.b	#27,d7
        blo.s   .modifyCopperlist 	; Must consider Vertical Position wrap?

        ; Is a Vertical Position wrap next?
        cmpi.l	#$ffdffffe,(a1)
        bne.s   .modifyCopperlist
        add.l   #4,a1			; Preserve existing Vertical Position wrap.
.modifyCopperlist

	bsr	CalculateCopperlistSizeChange

        tst.b   d0              	; Need to extend copperlist size?
        beq.s   .draw
.extendCopperList
	lea 	END_COPPTR_GAME_TILES,a2
	move.l	hAddress(a2),a2
        addq.l	#4,a2           	; +4 due to pre-decrement below
	lea 	END_COPPTR_GAME_TILES,a3
	move.l	hAddress(a3),a3
	add.l	d0,a3	        	; Need to insert d0 bytes in copperlist
        move.l  a3,END_COPPTR_GAME_TILES        ; Set pointer to new end of copperlist
        addq.l	#4,a3           	; +4 due to pre-decrement below
.extendCopperlistLoop
	move.l	-(a2),-(a3)
	cmpa.l	a2,a1
	bne.s	.extendCopperlistLoop

.draw
	moveq	#0,d2			; Rasterline 0-7
.loop
	cmpi.b 	#8,d2
	beq.s 	.done
	
        bsr	UpdateCopperlistForRasterLine
	
	addq.b 	#1,d2
        bra.s 	.loop
.done
	move.l	(sp)+,a0
        rts


; Find out how many longwords, if any, need to be inserted into copperlist.
; In:	a5 = pointer to new/deleted brick in GAMEAREA
; Out:	d0.b = number of bytes to be added/removed from copperlist, if any.
CalculateCopperlistSizeChange:
        ; Assume the brick is NOT adjacent to any other
        ; -> 4 longwords * for 8 rasterlines needed
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

; Finds the position after COLOR00 changes for previous tile, on previous GAMEAREA row.
; Finds GAMEAREA row start
; In:	a5 = pointer to brick in GAMEAREA
; Out:	a0 = GAMEAREA row start address
; Out:	a1 = pointer into copperlist where COLOR00 changes should be made.
GetAddressForCopperChanges:
	move.l	a5,d7
	sub.l	#GAMEAREA,d7		; Which GAMEAREA byte is it?

	lsl.l	#1,d7
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.l	d7,a2

	moveq	#0,d7
	moveq	#0,d3
	move.b	(a2)+,d3
	move.b	(a2),d7

        ; Find previous GAMEAREA tile on one of the previous GAMEAREA row(s).
        move.l	a5,a1
        sub.l   d3,a1           	; Set address to first byte in the row
        				; Set up address to start of GAMEAREA row for loop later
	lea	(1,a1),a0		; +1 -> compensate for 1st empty byte on GAMEAREA row
	move.l	a0,a4			; OUT: Copy of GAMEAREA row start address

.findPreviousTileLoop
	move.b	-(a1),d0
	beq.s	.findPreviousTileLoop

	cmpi.b	#$cd,d0			; Hit a Continued (last byte) part of brick?
	bne.s	.findLastRasterLineWaitForPreviousTile
	subq.l	#1,a1			; Point to start of brick that could have a wait

.findLastRasterLineWaitForPreviousTile
        move.l  a1,d0
        sub.l   #GAMEAREA+1,d0    	; Previous GAMEAREA byte. +1 -> compensate for 1st empty byte on the row

	lsl.l	#1,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.l	d0,a2

	moveq	#0,d0
	move.w	#$fffe,d0		; We'll be looking for a copper WAIT
        swap	d0

	move.b	(a2),d3			; X pos
	move.b	1(a2),d0		; Y pos

	lsl.w	#3,d0			; *8 -> convert to number of rasterlines
	addi.w	#FIRST_Y_POS+7,d0	; +7 -> last rasterline for previous tile.

	lsl.w	#8,d0			; Move yy byte

	move.l	d0,d6			; Create search-pattern
	rol.l	#8,d6			; $fffe<yy>00 -> $fe<yy>00ff
	rol.l	#8,d6			; $<yy>00fffe

	lsl.b	#2,d3			; 1*4 advances the corresponding to 8 pixels.
	add.b	d3,d0			; Add xx byte
	addi.b	#FIRST_X_POS,d0
	swap	d0			; Now we know the WAIT we're looking for

	lea	END_COPPTR_GAME_TILES,a2
	lea	END_COPPTR_GAME,a1
	move.l	hAddress(a1),a1
.findLastWaitForPreviousTile
	move.l	(a1)+,d1
	cmp.l	d1,d0			; Looking for $<yy><xx> fffe
	beq.s	.findResetColorOOLoop	; EXACT WAIT found!
	
	and.l	#$ff00ffff,d1		; Looking for a WAIT on the same row
	cmp.l	d6,d1			; Compare against search-pattern
	bne.s	.checkForEndOfCopperlist
	move.l	a1,a3			; Keep inexact WAIT

.checkForEndOfCopperlist
	cmpa.l	hAddress(a2),a1
	bne.s	.findLastWaitForPreviousTile

.inexactMatch
	; Let's pray that there is always an inexact match when no exact was found!
	move.l	a3,a1

	; Find relative rasterline 7 COLOR00 reset for previous tile/brick
.findResetColorOOLoop
	cmpi.l	#$01800000,(a1)+
	bne.s	.findResetColorOOLoop

	rts

; Draws/redraws GAMAREA row with one less brick in it.
; Reason: Updating the copperlist for the entire row is easier than
; modifying copperlist for a single brick.
; In	a5 = pointer to deleted brick in GAMEAREA
DrawGameAreaRowWithDeletedBrick:
        ; Find last of previous row's COLOR00 changes (might be several rows away)
        ; OR find Vertical Position wrap (PAL screen)
        ; Copperlist WILL contain $ffdffffe somewhere because of routine "DrawGameAreaRow"
      
        bsr	GetAddressForCopperChanges

        cmpi.b	#27,d7
        blo.s   .modifyCopperlist       ; Must consider Vertical Position wrap?

        ; Is a Vertical Position wrap next?
        cmpi.l	#$ffdffffe,(a1)
        bne.s   .modifyCopperlist
        add.l   #4,a1           	; Preserve existing Vertical Position wrap.
.modifyCopperlist

	bsr	CalculateCopperlistSizeChange

        tst.b   d0              ; Need to reduce copperlist size?
        beq.s   .draw
.reduceCopperList
	move.l 	a1,a2
	add.l	d0,a2	        ; Need to remove d0 bytes in copperlist
	move.l 	a1,a3
.reduceCopperlistLoop
	move.l	(a2)+,(a3)+
	cmpi.l	#$fffffffe,(a2)
	bne.s	.reduceCopperlistLoop

	move.l	(a2),(a3)			; One final move to copy end of copperlist
	move.l  a3,END_COPPTR_GAME_TILES	; Set pointer to new end of copperlist

.draw
	moveq	#0,d2		; Rasterline 0-7
.loop
	cmpi.b 	#8,d2
	beq.s 	.done
	
        bsr	UpdateCopperlistForRasterLine
	
	addq.b 	#1,d2
        bra.s 	.loop
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
	cmpi.l	#$ffdbfffe,-(3*4)(a1)	; Special case: Player0 disabled - not enough time for WAIT
	beq.s	.noWrap
	move.l	#$ffdffffe,(a1)+	; Insert VertPos WAIT to await end of line $ff
.noWrap

	moveq	#0,d3           	; GAMEAREA byte 0-40
.loop
	cmpi.b	#40,d3
	bge.s 	.done

	moveq	#0,d1
	move.b	(a0),d1			; Find next tile that need COLOR00 changes
	beq.b	.nextByte

	lsl.l	#2,d1			; Convert .b to .l
	lea	TileMap,a2
	add.l	d1,a2			; Lookup in tile map
	move.l 	hAddress(a2),a2


	cmpa.l	a0,a5			; Is this a new brick?
	bne.s	.copperUpdates
	tst.b	d2			; Is it relative rasterline 0?
	bne.s	.copperUpdates

	bsr	BlitNewBrickToGameScreen

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



; Specialized blit-routine for bricks that does 2 blits.
; 1 Blit for storing background gfx in scrap area and 1 blit for brick-drawing.
; In:	a2 = address to brick structure to be blitted
; In:	d0.w = current Y position / rasterline
; In:	d3.b = current X position byte
BlitNewBrickToGameScreen:
	tst.l	hAddress(a2)		; Anything to blit?
	bmi.w	.exit

	; movem.l	d0/d3/d5-d6/a5-a6,-(SP)

	; lea 	GAMESCREEN_BITMAPBASE,a5; Set up blit source/destination
	; move.l	d0,d6
	; subi.w	#FIRST_Y_POS,d6
	; mulu.w	#(ScrBpl*4),d6		; TODO dynamic handling of no. of bitplanes
	; add.l	d3,d6			; Add byte (x pos) to longword (y pos)
	; add.l	d6,a5

	; lea	BLITSCRAPPTR,a6
	; move.l	hAddress(a6),a6
	; lea	(a6,d6.l),a6


	; ; In:   a5 = Source (planar)
	; ; In:   a6 = Destination
	; bsr	CopyBrickGraphics

	; move.l	a5,a6
	; move.l	hAddress(a2),a5
	; bsr	CopyBrickGraphics

	; movem.l	(SP)+,d0/d3/d5-d6/a5-a6


	movem.l	d0/d3/d6/a4-a6,-(SP)
	
        lea 	CUSTOM,a6

	move.l 	GAMESCREEN_BITMAPBASE,a4; Set up blit source/destination
	move.l	d0,d6
	subi.w	#FIRST_Y_POS,d6
	mulu.w	#(ScrBpl*4),d6		; TODO dynamic handling of no. of bitplanes
	add.b	d3,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,a4

	lea	BLITSCRAPPTR,a5
	move.l	hAddress(a5),a5
	lea	(a5,d6.l),a5

	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)		; Simple copy blit with no shift
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	a4,BLTAPTH(a6)
	move.l 	a5,BLTDPTH(a6)
	move.w 	hTileBlitModulo(a2),BLTAMOD(a6)	; Gamescreen,scrap and bob using same dimensions = same modulo
	move.w 	hTileBlitModulo(a2),BLTDMOD(a6)

	move.w 	hTileBlitSize(a2),BLTSIZE(a6)

	WAITBLIT

	move.l 	hAddress(a2),BLTAPTH(a6)
	move.l 	a4,BLTDPTH(a6)
	move.w 	hTileBlitModulo(a2),BLTAMOD(a6)	; Gamescreen,scrap and bob using same dimensions = same modulo
	move.w 	hTileBlitModulo(a2),BLTDMOD(a6)

	move.w 	hTileBlitSize(a2),BLTSIZE(a6)

	movem.l	(SP)+,d0/d3/d6/a4-a6
.exit
	rts