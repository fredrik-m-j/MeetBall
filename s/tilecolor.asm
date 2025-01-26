; Overly complicated way to have more colors in bricks
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick
; In:	d2.b = relative rasterline 0-7 being drawn
WriteRibbedBrickColor:
	cmpi.b	#7,d2
	bne.s	.drawCalculatedColors

	move.l	#COLOR00<<16+$217,(a1)+	; Set shadow color
	move.l	#COLOR00<<16+$217,(a1)+
	bra		.checkEnding
	
.drawCalculatedColors
	bsr		LookupBrickColorWord

	btst	#0,d2					; Assuming classic horizontal brick orientation
	bls.s	.evenTileColor
	bhi.s	.oddTileColor

.evenTileColor
; First colorword
	move.w	#COLOR00,(a1)+			; Set color for next 8 pixels
	move.w	(a6),(a1)+


	cmpi.b	#STATICBRICKS_START,(a0)	; Brick or tile?
	blo		.checkEnding

; Second colorword
	move.w	#COLOR00,(a1)+

	move.b	(a6),d5
	addq.b	#1,d5
	cmpi.b	#$f,d5
	bls.s	.utGreen
	move.b	#$f,d5
.utGreen
	move.b	d5,(a1)+				; Write R component

	move.b	1(a6),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	beq.s	.doneUpperTile
	subq.b	#1,d5
.doneUpperTile
	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1(a6),d5
	and.b	#$0f,d5
	or.b	d6,d5

	move.b	d5,(a1)+				; Write BG components

	bra		.checkEnding

	
.oddTileColor
; First colorword
	move.w	#COLOR00,(a1)+

	cmpi.b	#STATICBRICKS_START,(a0)	; Brick or tile?
	blo		.useDefaultColor

	move.b	(a6),d5
	subq.b	#2,d5
	bpl.s	.ltGreen
	moveq	#0,d5
.ltGreen
	move.b	d5,(a1)+				; Write R component

	move.b	1(a6),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	subq.b	#2,d5
	bpl.s	.ltBlue
	
	moveq	#0,d5
.ltBlue
	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1(a6),d5
	and.b	#$0f,d5
	subq.b	#2,d5
	bpl.s	.combine
	
	moveq	#0,d5
.combine
	or.b	d6,d5

	move.b	d5,(a1)+				; Write BG components

; Second colorword
	move.w	#COLOR00,(a1)+

	move.b	(a6),d5
	subq.b	#3,d5
	bpl.s	.ltGreen2
	moveq	#0,d5
.ltGreen2
	move.b	d5,(a1)+				; Write R component

	move.b	1(a6),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	subq.b	#3,d5
	bpl.s	.ltBlue2
	
	moveq	#0,d5
.ltBlue2
	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1(a6),d5
	and.b	#$0f,d5
	subq.b	#2,d5
	bpl.s	.combine2
	
	moveq	#0,d5
.combine2
	or.b	d6,d5

	move.b	d5,(a1)+				; Write BG components

	bra.s	.checkEnding

.useDefaultColor
	move.w	(a6),(a1)+

.checkEnding

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.checkNextSingleTile

	tst.b	2(a0)
	beq.s	.resetToBlack

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
.exit
	rts


; Overly complicated way to have more colors in bricks
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick
; In:	d2.b = relative rasterline 0-7 being drawn
WriteDiamondBrickColor:
	cmpi.b	#7,d2
	bne.s	.drawCalculatedColors

	move.l	#COLOR00<<16+$217,(a1)+	; Set shadow color
	move.l	#COLOR00<<16+$217,(a1)+
	
	bra		.checkEnding

.drawCalculatedColors
	bsr		LookupBrickColorWord

	cmpi.b	#3,d2					; Assuming classic horizontal brick orientation
	bls.s	.upperTileColor
	bhi.s	.lowerTileColor

.upperTileColor
; First colorword
	move.w	#COLOR00,(a1)+			; Set color for next 8 pixels
	move.w	(a6),(a1)+

	cmpi.b	#STATICBRICKS_START,(a0)	; Brick or tile?
	blo		.checkEnding

; Second colorword
	move.w	#COLOR00,(a1)+

	move.b	(a6),d5
	beq.s	.utGreen
	subq.b	#1,d5
.utGreen
	move.b	d5,(a1)+				; Write R component

	move.b	1(a6),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	beq.s	.doneUpperTile
	subq.b	#1,d5
.doneUpperTile
	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1(a6),d5
	and.b	#$0f,d5
	or.b	d6,d5

	move.b	d5,(a1)+				; Write BG components

	bra		.checkEnding

	
.lowerTileColor
; First colorword
	move.w	#COLOR00,(a1)+

	cmpi.b	#STATICBRICKS_START,(a0)	; Brick or tile?
	blo		.useDefaultColor

	move.b	(a6),d5
	subq.b	#2,d5
	bpl.s	.ltGreen
	moveq	#0,d5
.ltGreen
	move.b	d5,(a1)+				; Write R component

	move.b	1(a6),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	subq.b	#2,d5
	bpl.s	.ltBlue
	
	moveq	#0,d5
.ltBlue
	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1(a6),d5
	and.b	#$0f,d5
	subq.b	#2,d5
	bpl.s	.combine
	
	moveq	#0,d5
.combine
	or.b	d6,d5

	move.b	d5,(a1)+				; Write BG components

; Second colorword
	move.w	#COLOR00,(a1)+

	move.b	(a6),d5
	subq.b	#3,d5
	bpl.s	.ltGreen2
	moveq	#0,d5
.ltGreen2
	move.b	d5,(a1)+				; Write R component

	move.b	1(a6),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	subq.b	#3,d5
	bpl.s	.ltBlue2
	
	moveq	#0,d5
.ltBlue2
	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1(a6),d5
	and.b	#$0f,d5
	subq.b	#2,d5
	bpl.s	.combine2
	
	moveq	#0,d5
.combine2
	or.b	d6,d5

	move.b	d5,(a1)+				; Write BG components

	bra.s	.checkEnding

.useDefaultColor
	move.w	(a6),(a1)+

.checkEnding

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.checkNextSingleTile

	tst.b	2(a0)
	beq.s	.resetToBlack

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
.exit
	rts


; Use colors from the brick.asm static specification.
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick
; In:	d2.b = relative rasterline 0-7 being drawn
WriteTileColor:
	move.w	#COLOR00,(a1)+

	moveq	#0,d5					; Calculate color offset
	move.b	d2,d5
	add.w	d5,d5
	add.w	d5,d5
	addi.b	#hBrickColorY0X0,d5

	move.w	(a2,d5),(a1)+			; Set color in copperlist

	cmpi.w	#2,hBrickByteWidth(a2)
	bne.s	.checkNextSingleTile

	move.w	#COLOR00,(a1)+			; Set color for next 8 pixels
	move.w	2(a2,d5),(a1)+			; Set color in copperlist
	
	tst.b	2(a0)
	beq.s	.resetToBlack

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	move.l	#COLOR00<<16+$0,(a1)+	; Reset to black when next position is empty
.exit
	rts

; In:	a0 = current game area ROW pointer
; Out:	a6 = corresponding color word pointer
LookupBrickColorWord:
	lea		ColorTable,a6
	move.l	a0,d6
	sub.l	#GAMEAREA,d6			; What gamearea byte is it?
	add.l	d6,a6					; ... point to corresponding color word
	add.l	d6,a6
	rts