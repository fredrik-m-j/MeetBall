InitScores:
	move.l	#$ffffffff,DirtyPlayer0Score(a5)	; Set all as clean	
	rts

; Initializes the DigitMap
InitScoreDigitMap:
	move.l	BobsBitmapbasePtr(a5),d0
	addi.l	#RL_SIZE-2,d0

	lea		ScoreDigitMap,a0		; Set up digit bobs
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)+
	addi.l	#(RL_SIZE*7*4),d0
	move.l	d0,(a0)

	rts

; Sets all player scores to 0 and markes enabled player scores as dirty.
; Dirty scores will be drawn to screen in the gameloop.
ResetScores:
	move.l	a3,-(sp)

	clr.l	Player0Score(a5)
	tst.b	Player0Enabled(a5)
	bmi		.p1
	lea		Player0Score(a5),a3
	bsr		SetDirtyScore
.p1
	clr.l	Player1Score(a5)
	tst.b	Player1Enabled(a5)
	bmi		.p2
	lea		Player1Score(a5),a3
	bsr		SetDirtyScore
.p2
	clr.l	Player2Score(a5)
	tst.b	Player2Enabled(a5)
	bmi		.p3
	lea		Player2Score(a5),a3
	bsr		SetDirtyScore
.p3
	clr.l	Player3Score(a5)
	tst.b	Player3Enabled(a5)
	bmi		.exit
	lea		Player3Score(a5),a3
	bsr		SetDirtyScore
.exit
	move.l	(sp)+,a3
	rts


; Blits to backing screen first to avoid thrashblits later.
; Can be optimized if Bat3 is not drawn
; In:	a6 = address to CUSTOM $dff000
DrawPlayer0Score:
	move.l 	GAMESCREEN_BackPtr(a5),a0
	add.l	#(RL_SIZE*1*4)+36,a0	; Starting point: 4 bitplanes, Y = 1, X = 36th byte
	move.l	a0,a3
	moveq	#RL_SIZE-4,d0
	move.w	#(64*6*4)+2,d1
	bsr		ClearBlitWords

	tst.b	Player0Enabled(a5)		; TODO consider removing this test
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player0Score(a5),d0
	bsr		Binary2Decimal
	move.l	#290,d3
	bsr		BlitScore
.draw
	move.l 	GAMESCREEN_BackPtr(a5),a0
	add.l	#(RL_SIZE*1*4)+36,a0
	move.l	GAMESCREEN_Ptr(a5),a1
	add.l	#(RL_SIZE*1*4)+36,a1
	moveq	#RL_SIZE-4,d1
	move.w	#(64*6*4)+2,d2
	bsr		CopyRestoreGamearea

	rts

; Blits to backing screen first to avoid thrashblits later.
; Can be optimized if Bat2 is not drawn
; In:	a6 = address to CUSTOM $dff000
DrawPlayer1Score:
	move.l 	GAMESCREEN_BackPtr(a5),a0
	add.l	#(RL_SIZE*249*4),a0		; Starting point: 4 bitplanes, Y = 249, X = 0 byte
	move.l	a0,a3
	moveq	#RL_SIZE-4,d0
	move.w	#(64*6*4)+2,d1
	bsr		ClearBlitWords

	tst.b	Player1Enabled(a5)
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player1Score(a5),d0
	bsr		Binary2Decimal
	moveq	#2,d3
	bsr		BlitScore
.draw
	move.l 	GAMESCREEN_BackPtr(a5),a0
	add.l	#(RL_SIZE*249*4),a0
	move.l	GAMESCREEN_Ptr(a5),a1
	add.l	#(RL_SIZE*249*4),a1
	moveq	#RL_SIZE-4,d1
	move.w	#(64*6*4)+2,d2
	bsr		CopyRestoreGamearea

	rts

; Blits to backing screen first to avoid thrashblits later.
; In:	a6 = address to CUSTOM $dff000
DrawPlayer2Score:
	move.l 	GAMESCREEN_BackPtr(a5),a3
	add.l	#(RL_SIZE*249*4)+36,a3	; Starting point: 4 bitplanes, Y = 249, X = 36th byte
	bsr		ClearScoreArea

	tst.b	Player2Enabled(a5)
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player2Score(a5),d0
	bsr		Binary2Decimal
	move.l	#290,d3
	bsr		BlitScore
.draw
	move.l 	GAMESCREEN_BackPtr(a5),a0
	add.l	#(RL_SIZE*249*4)+36,a0
	move.l	GAMESCREEN_Ptr(a5),a1
	add.l	#(RL_SIZE*249*4)+36,a1
	moveq	#RL_SIZE-4,d1
	move.w	#(64*6*4)+2,d2
	bsr		CopyRestoreGamearea

	rts

; Blits to backing screen first to avoid thrashblits later.
; In:	a6 = address to CUSTOM $dff000
DrawPlayer3Score:
	move.l 	GAMESCREEN_BackPtr(a5),a3
	add.l	#(RL_SIZE*1*4),a3		; Starting point: 4 bitplanes, Y = 1, X = 0 byte
	bsr		ClearScoreArea

	tst.b	Player3Enabled(a5)
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player3Score(a5),d0
	bsr		Binary2Decimal
	moveq	#2,d3
	bsr		BlitScore
.draw
	move.l 	GAMESCREEN_BackPtr(a5),a0
	add.l	#(RL_SIZE*1*4),a0
	move.l	GAMESCREEN_Ptr(a5),a1
	add.l	#(RL_SIZE*1*4),a1
	moveq	#RL_SIZE-4,d1
	move.w	#(64*6*4)+2,d2
	bsr		CopyRestoreGamearea

	rts


; Checks if score-blitting is needed
ScoreUpdates:
	tst.b	DirtyPlayer0Score(a5)
	bmi.s	.checkPlayer1
	bsr		DrawPlayer0Score
.checkPlayer1
	tst.b	DirtyPlayer1Score(a5)
	bmi.s	.checkPlayer2
	bsr		DrawPlayer1Score
.checkPlayer2
	tst.b	DirtyPlayer2Score(a5)
	bmi.s	.checkPlayer3
	bsr		DrawPlayer2Score
.checkPlayer3
	tst.b	DirtyPlayer3Score(a5)
	bmi.s	.exit
	bsr		DrawPlayer3Score
.exit
	move.l	#$ffffffff,DirtyPlayer0Score(a5)	; Set all as clean
	rts

; In:	a0 = Pointer to string
; In:	a3 = address to Destination BITMAPBASE
; In:	d0 = String length
; In:	d3.w = top left X position
BlitScore:
	tst.w	d0
	beq.w	.exit

	subq.b	#1,d0					; Loop correctly
.loop
	moveq	#0,d1
	move.b	(a0)+,d1
	subi.b	#$30,d1
	lsl.b	#2,d1					; We'll be adressing longwords in DigitMap

	lea		ScoreDigitMap,a2
	move.l	(a2,d1),a2

	bsr		BlitDigit

	addq.w	#5,d3					; Next digit X position
	dbf		d0,.loop
.exit
	rts


; ; Blit-routine made for score digits.
; ; a2 = address to digit to be blitted
; ; d3.w = top left X position
; ; In:	a6 = address to CUSTOM $dff000
; BlitDigitToBuffer:
; 	move.l	GAMESCREEN_Ptr(a5),d1
; 	addi.l 	#(RL_SIZE*210*4)+12,d1	; 12th byte in Buffer area


; 	IFEQ	ENABLE_DEBUG

; 	WAITBLIT

; 	move.l 	#$09f20000,BLTCON0(a6)		; Copy A->D minterm
; 	move.w 	#$ffff,BLTAFWM(a6)
; 	move.w 	#$ffff,BLTALWM(a6)
; 	move.w 	#RL_SIZE-3,BLTAMOD(a6)		; Buffer and bob using same dimensions = same modulo
; 	move.w 	#RL_SIZE-3,BLTDMOD(a6)
; 	move.l 	a2,BLTAPTH(a6)
; 	move.l 	d1,BLTDPTH(a6)

; 	move.w 	#(64*6*4)+2,BLTSIZE(a6)

; 	ENDIF

; 	rts


; Blit-routine made for score digits.
; In:	a2 = address to digit to be blitted
; In:	a3 = address to Destination BITMAPBASE
; In:	d3.w = top left X position
BlitDigit:
	move.l	a3,a4					; Assume next blit destination remain the same
	moveq	#DEFAULT_MASK,d2		; Assume single word blit

	move.w	d3,d1
	and.l	#$0000000F,d1			; Get remainder for X position

	move.w	#RL_SIZE-2,d5
	move.w	#(64*6*4)+1,d6

	cmpi.b	#12,d1
	blo.s	.singleWordblit
	subq.w	#2,d5					; Need to blit across 2 words
	addq.w	#1,d6
	move.l	#$ffff0000,d2			; Adjust mask
	addq.l	#2,a4					; Move Destination to next word

.singleWordblit
	ror.l	#4,d1					; Put remainder in most significant nibble for BLTCONx to do SHIFT

	WAITBLIT

	addi.l	#$0dfc0000,d1			; X shift and fc A+B minterm - avoid blit over previous digit(s)
	move.l	d1,BLTCON0(a6)
	move.l	d2,BLTAFWM(a6)
	move.w	d5,BLTAMOD(a6)			; Gamescreen and bob using same dimensions = same modulo
	move.w	d5,BLTBMOD(a6)
	move.w	d5,BLTDMOD(a6)
	move.l	a2,BLTAPTH(a6)
	move.l	a3,BLTBPTH(a6)
	move.l	a3,BLTDPTH(a6)

	move.w	d6,BLTSIZE(a6)

	move.l	a4,a3					; Set Destination address for next digit blit

	rts

; In:	a3 = Address to player score
SetDirtyScore:
	cmpa.l	#Variables+Player0Score,a3
	bne.s	.checkPlayer1
	clr.b	DirtyPlayer0Score(a5)
	bra.s	.exit
.checkPlayer1
	cmpa.l	#Variables+Player1Score,a3
	bne.s	.checkPlayer2
	clr.b	DirtyPlayer1Score(a5)
	bra.s	.exit
.checkPlayer2
	cmpa.l	#Variables+Player2Score,a3
	bne.s	.checkPlayer3
	clr.b	DirtyPlayer2Score(a5)
	bra.s	.exit
.checkPlayer3
	clr.b	DirtyPlayer3Score(a5)
.exit
	rts