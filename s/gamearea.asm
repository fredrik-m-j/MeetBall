InitializePlayerAreas:
	lea	GAMEAREA,a0
;-------
.player0
	tst.b	Player0Enabled
	beq.s	.enablePlayer0ScoreArea
	bne.s	.disablePlayer0ScoreArea
.enablePlayer0ScoreArea
        move.l  #37,d0
	moveq	#$02,d1
        bsr     UpdateScoreArea

	moveq	#$00,d1
	bra.s	.updatePlayer0Area
.disablePlayer0ScoreArea
        move.l  #37,d0
	moveq	#$01,d1
        bsr     UpdateScoreArea
.updatePlayer0Area
	move.w	#25,d2
	move.w	d2,d0
	mulu.w	#41,d0
        add.w   #41*4-1,d0

        bsr     UpdateVerticalPlayerArea
;-------
.player1
	tst.b	Player1Enabled
	beq.s	.enablePlayer1ScoreArea
	bne.s	.disablePlayer1ScoreArea
.enablePlayer1ScoreArea
        move.l  #41*31+1,d0
	moveq	#$03,d1
        bsr     UpdateScoreArea

	moveq	#$00,d1
	bra.s	.updatePlayer1Area
.disablePlayer1ScoreArea
        move.l  #41*31+1,d0
	moveq	#$01,d1
        bsr     UpdateScoreArea
	
.updatePlayer1Area
	move.w	#25,d2
	move.w	d2,d0
	mulu.w	#41,d0
        add.w   #41*3+1,d0

        bsr     UpdateVerticalPlayerArea
;-------
.player2
	tst.b	Player2Enabled
	beq.s	.enablePlayer2ScoreArea
	bne.s	.disablePlayer2ScoreArea
.enablePlayer2ScoreArea
        move.l  #41*31+37,d0
	moveq	#$04,d1
        bsr     UpdateScoreArea

	moveq	#$00,d1
	bra.s	.updatePlayer2Area
.disablePlayer2ScoreArea
        move.l  #41*31+37,d0
	moveq	#$01,d1
        bsr     UpdateScoreArea
	
.updatePlayer2Area
	move.w	#31,d2
	move.w	#41*31+36,d0

        bsr     UpdateHorizontalPlayerArea

;-------
.player3
	tst.b	Player3Enabled
	beq.s	.enablePlayer3ScoreArea
	bne.s	.disablePlayer3ScoreArea
.enablePlayer3ScoreArea
        moveq   #1,d0
	moveq	#$05,d1
        bsr     UpdateScoreArea

	moveq	#$00,d1
	bra.s	.updatePlayer3Area
.disablePlayer3ScoreArea
        moveq   #1,d0
	moveq	#$01,d1
        bsr     UpdateScoreArea
	
.updatePlayer3Area
	move.w	#31,d2
	move.w	#36,d0

        bsr     UpdateHorizontalPlayerArea

.exit
	rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Offset to start of score area
; In:   d1.b = Tile code to set in score area
UpdateScoreArea:
	move.b	d1,(a0,d0)		; Enable Player 0 score area
	move.b	d1,1(a0,d0)
	move.b	d1,2(a0,d0)
	move.b	d1,3(a0,d0)

        rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d1.b = Tile code to set in player area
; In:   d2.w = Number of tiles to update
UpdateVerticalPlayerArea:
.playerLoop
	move.b	d1,(a0,d0)
	subi.w	#41,d0                  ; Stupidity - WHY can't I do "sub dx,dy" here???
	dbf	d2,.playerLoop

        rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d1.b = Tile code to set in player area
; In:   d2.w = Number of tiles to update
UpdateHorizontalPlayerArea:
.playerLoop
	move.b	d1,(a0,d0)
	subi.w	#1,d0
	dbf	d2,.playerLoop

        rts


; Appends COLOR00 changes given tile-definitions in GAMEAREA
DrawGamearea:
	lea 	END_COPPTR_GAME,a1
	move.l	hAddress(a1),a1		; The copper list to update

	lea	1+GAMEAREA,a0		; GAMEAREA has 1 initial byte because of logic reasons
	moveq	#0,d7
.rowLoop
	cmpi.b 	#32,d7
	beq.s 	.optimize
	
	bsr	DrawGameAreaRow

	addi.b 	#1,d7
	bra.s 	.rowLoop

.optimize
	move.l	#COPPERLIST_END,(a1)
	move.l	a1,END_COPPTR_GAME_TILES

	bsr	OptimizeCopperlist

        rts

OptimizeCopperlist:
	lea	1+GAMEAREA,a0		; GAMEAREA has 1 initial byte because of logic reasons
	moveq	#0,d7
.optimizeRowLoop
	cmpi.b 	#32,d7
	beq.s 	.done

	move.l	a0,a5
	bsr	DrawBrickGameAreaRow	; This routine draws the GAMEAREA with COPJMP2 to execute less copper instructions in total

	lea	(40+1,a0),a0		; Set game area pointer on next row 
	addi.b 	#1,d7
	bra.s 	.optimizeRowLoop
.done
	rts


; Iterates over raster lines to populate the huge copperlist.
; NOTE: This routine doesn't do a good job - it doesn't have to. The purpose is to allocate 
; enough bytes per GAMEAREA row in the copperlist for all possible COLOR00 instructions.
; In:	a0 = game area pointer.
; In:	d7 = the row to draw.
; In:	a1 = the copper list to be modified.
DrawGameAreaRow:
	move.w	d7,d0
	add.w	d0,d0			; Convert to longword
	add.w	d0,d0

	lea	GAMEAREA_ROWCOPPERPTRS,a2
	move.l	a1,(a2,d0.l)		; Set the address to first WAIT instruction


	add.w	d0,d0
	addi.w	#FIRST_Y_POS,d0		; First rasterline for this game area row to process

	moveq	#0,d2			; Rasterline 0-7 in current game area row
.loop
	cmpi.b 	#8,d2
	beq.s 	.done

	bsr	DrawForRasterLine
	
	addq.b 	#1,d2
	addq.w	#1,d0			; update rasterline

	lea	(-40,a0),a0		; Reset pointer to start of game area row
	bra.s 	.loop
.done
	lea	(40+1,a0),a0		; Set game area pointer on next row 
.exit
	rts


; Draws line updating gamescreen copper list and copies tile/brick gfx every row 0.
; In:	a0 = game area pointer
; In:	a1 = address to end of copper list
; In:	d0.w = rasterline for which to update COLOR00
; In:	d2.b = line 0-7 being drawn
DrawForRasterLine:
	move.w	d0,d4		; d4 = the position to wait for in copper list
	lsl.w	#8,d4
	addi.b	#FIRST_X_POS,d4	; Start from FIRST_X_POS
				; Bit 0 must be set to get an awaitable X position in copper list
	moveq	#0,d3
.loop
	cmpi.b	#40,d3
	bge.s 	.done

	moveq	#0,d1
	move.b	(a0),d1		; Any tile here?
	bne.b	.drawTile

	move.l	#COLOR00<<16+$0,(a1)+	; Set black
	bra.s	.nextByte

.drawTile
	add.l	d1,d1		; Convert .b to .l
	add.l	d1,d1
	lea	TileMap,a2
	add.l	d1,a2		; Lookup in tile map
	move.l 	hAddress(a2),a2

	bsr	SetCopperForTileLine

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.nextByte
	
	addq.l	#1,a0		; Skip over a byte in this iteration
	addq.b	#1,d3		
	addq.b	#4,d4

.nextByte
	addq.l	#1,a0
	addq.b	#1,d3
	addq.b	#4,d4		; Move the corresponding to 8px forward in X pos
	bra.s	.loop
.done
	rts


; Updates game copper list with CORLOR00 updates for 1 tile.
; In:	a0 = game area pointer
; In:	a1 = address to end of copper list
; In:	a2 = address to brick
; In:	d2.b = line 0-7 being drawn
; In:	d4.w = raster position to wait for
SetCopperForTileLine:
	; Time to wait ?
	tst.b	-1(a0)
	bne.s	.skipCopperWait
	tst.b	d3
	bne.s	.skipCopperWait

	move.w	d4,(a1)+	; Wait for this position
	move.w	#$fffe,(a1)+
.skipCopperWait
	moveq	#0,d5		; Calculate color offset
	move.b	d2,d5
	lsl.w	#3,d5		; rasterline in d2 * 2 longwords per rasterline in brickstruct
	addi.b 	#hBrickColorY0X0,d5

	move.l	(a2,d5),(a1)+

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.checkNextSingleTile

	move.l	4(a2,d5),(a1)+	; Set color for next 8 pixels

	addq.b	#4,d3
	move.l	hBrickColorY0X0(a3,d3.w),(a1)+

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	tst.b	d3
	beq.s	.exit
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black if last tile

.exit
	rts