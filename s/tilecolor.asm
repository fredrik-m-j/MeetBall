; In:	a2 = address to brick
SetRandomBaseColorOnBrick:
        move.l	d0,-(SP)
	
        bsr	RndW			; Create random color
	and.w	#$0fff,d0

        move.w  d0,hTileCopperColorY0X0(a2)

        move.l	(SP)+,d0
        rts


; Overly complicated way to have more colors in bricks
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick
; In:	d2.b = relative rasterline 0-7 being drawn
WriteRandomTileColor:
	cmpi.b	#3,d2				; Assuming classic horizontal brick orientation
	bls.s	.upperTileColor
	bhi.s	.lowerTileColor

.upperTileColor
; First colorword
	move.w	#COLOR00,(a1)+	; Set color for next 8 pixels
	move.w	hTileCopperColorY0X0(a2),(a1)+


	cmpi.b	#$20,(a0)	; Brick or tile?
	blo	.checkEnding

; Second colorword
	move.w	#COLOR00,(a1)+

	move.b	hTileCopperColorY0X0(a2),d5
	beq.s	.utGreen
	sub.b	#1,d5
.utGreen
	move.b	d5,(a1)+	; Write R component

	move.b	1+hTileCopperColorY0X0(a2),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	beq.s	.doneUpperTile
	sub.b	#1,d5
.doneUpperTile
 	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1+hTileCopperColorY0X0(a2),d5
	and.b	#$0f,d5
	or.b	d6,d5

	move.b	d5,(a1)+	; Write BG components

	bra	.checkEnding

	
.lowerTileColor
; First colorword
	move.w	#COLOR00,(a1)+

	cmpi.b	#$20,(a0)	; Brick or tile?
	blo	.useDefaultColor

	move.b	hTileCopperColorY0X0(a2),d5
	sub.b	#2,d5
	bpl.s	.ltGreen
	moveq	#0,d5
.ltGreen
	move.b	d5,(a1)+	; Write R component

	move.b	1+hTileCopperColorY0X0(a2),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	sub.b	#2,d5
	bpl.s	.ltBlue
	
	moveq	#0,d5
.ltBlue
 	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1+hTileCopperColorY0X0(a2),d5
	and.b	#$0f,d5
	sub.b	#2,d5
	bpl.s	.combine
	
	moveq	#0,d5
.combine
	or.b	d6,d5

	move.b	d5,(a1)+	; Write BG components

; Second colorword
	move.w	#COLOR00,(a1)+

	move.b	hTileCopperColorY0X0(a2),d5
	sub.b	#3,d5
	bpl.s	.ltGreen2
	moveq	#0,d5
.ltGreen2
	move.b	d5,(a1)+	; Write R component

	move.b	1+hTileCopperColorY0X0(a2),d5
	and.b	#$f0,d5
	lsr.b	#4,d5
	sub.b	#3,d5
	bpl.s	.ltBlue2
	
	moveq	#0,d5
.ltBlue2
 	move.b	d5,d6
	lsl.b	#4,d6

	move.b	1+hTileCopperColorY0X0(a2),d5
	and.b	#$0f,d5
	sub.b	#2,d5
	bpl.s	.combine2
	
	moveq	#0,d5
.combine2
	or.b	d6,d5

	move.b	d5,(a1)+	; Write BG components

	bra.s	.checkEnding

.useDefaultColor
	move.w	hTileCopperColorY0X0(a2),(a1)+

.checkEnding

	cmpi.w	#2,hTileByteWidth(a2)
	bne.s	.checkNextSingleTile

	tst.b	2(a0)
	beq.s	.resetToBlack

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	move.w	#COLOR00,(a1)+	; Reset to black when next position is empty
	move.w	#$0000,(a1)+
.exit
	rts


; Use colors from the brick.dat spec
; In:	a0 = current game area ROW pointer
; In:	a1 = pointer into copper list
; In:	a2 = address to brick
; In:	d2.b = relative rasterline 0-7 being drawn
WriteTileColor:
	move.w	#COLOR00,(a1)+

	moveq	#0,d5		; Calculate color offset
	move.b	d2,d5
	lsl.w	#2,d5
	addi.b 	#hTileCopperColorY0X0,d5

	move.w	(a2,d5),(a1)+	; Set color in copperlist

	cmpi.w	#2,hTileByteWidth(a2)
	bne.s	.checkNextSingleTile

	move.w	#COLOR00,(a1)+	; Set color for next 8 pixels
	move.w	2(a2,d5),(a1)+	; Set color in copperlist
	
	; addq	#1,a6

	tst.b	2(a0)
	beq.s	.resetToBlack

.checkNextSingleTile
	tst.b	1(a0)
	bne.s	.exit

.resetToBlack
	move.w	#COLOR00,(a1)+	; Reset to black when next position is empty
	move.w	#$0000,(a1)+

.exit
        rts