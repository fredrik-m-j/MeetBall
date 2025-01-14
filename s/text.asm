GameareaDrawGameOver:
	move.l	a2,-(sp)
	
	move.l	GAMESCREEN_BITMAPBASE,a0
	add.l	#GAMEOVER_DEST,a0
	moveq	#GAMEOVER_MODULO,d0
	move.w	#GAMEOVER_BLITSIZE,d1

	bsr		ClearBlitWords

	lea		GAMEOVER_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	move.l	GAMESCREEN_BITMAPBASE,a2
	add.l	#GAMEOVER_TEXTDEST,a2
	WAITBLIT
	bsr		DrawStringBufferSimple

	move.l	(sp)+,a2
	rts

GameareaDrawDemo:
	move.l	a2,-(sp)

	lea		DEMO_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	move.l	GAMESCREEN_BITMAPBASE,a2
	add.l	#DEMO_DEST+ScrBpl,a2
	bsr		DrawStringBufferSimple

	move.l	(sp)+,a2
	rts

; In:	a6 = address to CUSTOM $dff000
GameareaDrawNextLevel:
	movem.l	a2,-(sp)

	move.l	GAMESCREEN_BITMAPBASE,a0
	add.l	#GAMEOVER_DEST,a0
	moveq	#GAMEOVER_MODULO,d0
	move.w	#GAMEOVER_BLITSIZE,d1

	bsr		ClearBlitWords

	lea		LEVEL_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	moveq	#0,d0
	move.w	LevelCount,d0
	jsr		Binary2Decimal

	move.b	#" ",-1(a1)
	COPYSTR	a0,a1

	move.l	GAMESCREEN_BITMAPBASE,a2
	add.l	#LEVEL_TEXTDEST,a2
	WAITBLIT
	bsr		DrawStringBufferSimple

	movem.l	(sp)+,a2
	rts

GameareaRestoreGameOver:
	move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	add.l	#GAMEOVER_DEST,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l	#GAMEOVER_DEST,a1
	moveq	#GAMEOVER_MODULO,d1
	move.w	#GAMEOVER_BLITSIZE,d2

	bsr		CopyRestoreGamearea
	rts
GameareaRestoreDemo:
	move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	add.l	#DEMO_DEST,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l	#DEMO_DEST,a1
	moveq	#DEMO_MODULO,d1
	move.w	#(64*8*4)+4,d2

	bsr		CopyRestoreGamearea
	rts


; Before calling - fill the STRINGBUFFER (nullterminated).
; Plots characters to 1 bitplane from FONT on 8px boundaries.
; In:   a2 = Start Destination (4 bitplanes) - modified
DrawStringBufferSimple:
	lea		STRINGBUFFER,a1
	moveq	#0,d1
.l1
	move.b	(a1)+,d1
	beq		.exit

	subi.b	#$20,d1					; Convert to FONT position

	lea		FONT,a0
	add.l	d1,a0

	move.b	0*64(a0),0*40(a2)
	move.b	1*64(a0),4*40(a2)
	move.b	2*64(a0),8*40(a2)
	move.b	3*64(a0),12*40(a2)
	move.b	4*64(a0),16*40(a2)
	move.b	5*64(a0),20*40(a2)
	move.b	6*64(a0),24*40(a2)
	move.b	7*64(a0),28*40(a2)

	addq	#1,a2

	bra		.l1
.exit
	rts


; Before calling - fill the STRINGBUFFER (nullterminated).
; Plots 6px wide characters to 1 bitplane from FONT.
; In:   a2 = Start Destination (4 bitplanes)
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
; TODO: this is very sloooow...
; In:	a6 = address to CUSTOM $dff000
DrawStringBuffer:
	lea		STRINGBUFFER,a1
.l1
	move.b	(a1)+,d1
	bne.s	.l1
	subq.l	#1,a1

	moveq	#0,d1
.l2
	lea		FONT,a0
	move.b	-(a1),d1
	
	subi.b	#$20,d1
	add.l	d1,a0

	WAITBLIT						; Make sure shifting is done before adding next char
	bsr		DrawSinglePlaneChar

	cmpa.l	#STRINGBUFFER,a1
	beq.s	.exit

	moveq	#6,d0
	bsr		BlitShiftRight

	bra.s	.l2
.exit
	rts

; In:   a2 = Start Destination (4 bitplanes)
; In:   a3 = End Destination (Last byte of the blit area - descending blit)
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
; In:	a6 = address to CUSTOM $dff000
DrawStringBufferRightAligned:
	lea		STRINGBUFFER,a1

	moveq	#0,d1
.l2
	lea		FONT,a0
	move.b	(a1)+,d1
	beq.s	.exit
	
	subi.b	#$20,d1
	add.l	d1,a0

	WAITBLIT						; Make sure shifting is done before adding next char

	bsr		DrawSinglePlaneChar

	moveq	#6,d0
	exg		a3,a2
	bsr		BlitShiftLeft
	exg		a2,a3

	bra.s	.l2
.exit
	rts


; In:   a2 = Destination (4 bitplanes)
; In:	a6 = address to CUSTOM $dff000
; In:   d0.l = Number of pixels to shift
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
BlitShiftRight:
	ror.l	#4,d0					; Put remainder in most significant nibble for BLTCONx to do SHIFT
	addi.l	#$09f00000,d0			; Copy with X shift

	WAITBLIT

	move.l	d0,BLTCON0(a6) 
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.w	d5,BLTAMOD(a6)
	move.w	d5,BLTDMOD(a6)
	move.l	a2,BLTAPTH(a6)
	move.l	a2,BLTDPTH(a6)

	move.w	d6,BLTSIZE(a6)

	rts

; In:   a2 = Destination (4 bitplanes)
; In:	a6 = address to CUSTOM $dff000
; In:   d0.l = Number of pixels to shift
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
BlitShiftLeft:
	ror.l	#4,d0					; Put remainder in most significant nibble for BLTCONx to do SHIFT
	bset	#1,d0					; Use descending mode
	addi.l	#$09f00000,d0			; Copy with X shift

	WAITBLIT

	move.l	d0,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.w	d5,BLTAMOD(a6)
	move.w	d5,BLTDMOD(a6)
	move.l	a2,BLTAPTH(a6)
	move.l	a2,BLTDPTH(a6)

	move.w	d6,BLTSIZE(a6)

	rts

; In:	a0 = Address to source char (1 bitplane)
; In:   a2 = Destination (4 bitplanes)
DrawSinglePlaneChar:
	move.b	0*64(a0),d2
	or.b	d2,0*40(a2)

	move.b	1*64(a0),d2
	or.b	d2,4*40(a2)

	move.b	2*64(a0),d2
	or.b	d2,8*40(a2)

	move.b	3*64(a0),d2
	or.b	d2,12*40(a2)

	move.b	4*64(a0),d2
	or.b	d2,16*40(a2)

	move.b	5*64(a0),d2
	or.b	d2,20*40(a2)

	move.b	6*64(a0),d2
	or.b	d2,24*40(a2)

	move.b	7*64(a0),d2
	or.b	d2,28*40(a2)

	; move.b  0*64(a0),0*40(a2)
	; move.b  1*64(a0),4*40(a2)
	; move.b  2*64(a0),8*40(a2)
	; move.b  3*64(a0),12*40(a2)

	; move.b  4*64(a0),16*40(a2)
	; move.b  5*64(a0),20*40(a2)
	; move.b  6*64(a0),24*40(a2)
	; move.b  7*64(a0),28*40(a2)

	rts


; In:   a0 = Destination to clear
; In:	a6 = address to CUSTOM $dff000
; In:   d0.w = Destination modulo
; In:   d1.w = Blit size
ClearBlitWords:      
	WAITBLIT

	move.l	#$01000000,BLTCON0(a6)
	move.l	a0,BLTDPTH(a6)
	move.w	d0,BLTDMOD(a6)

	move.w	d1,BLTSIZE(a6)
	rts

; In:   a3 = Score area on GAMESCREEN to clear (top left).
ClearScoreArea:
	clr.l	0*40(a3)
	clr.l	1*40(a3)
	clr.l	2*40(a3)
	; clr.l   3*40(a3)      - bitplane not used

	clr.l	4*40(a3)
	clr.l	5*40(a3)
	clr.l	6*40(a3)
	; clr.l   7*40(a3)

	clr.l	8*40(a3)
	clr.l	9*40(a3)
	clr.l	10*40(a3)
	; clr.l   11*40(a3)

	clr.l	12*40(a3)
	clr.l	13*40(a3)
	clr.l	14*40(a3)
	; clr.l   15*40(a3)

	clr.l	16*40(a3)
	clr.l	17*40(a3)
	clr.l	18*40(a3)
	; clr.l   19*40(a3)

	clr.l	20*40(a3)
	clr.l	21*40(a3)
	clr.l	22*40(a3)
	; clr.l   23*40(a3)

	rts