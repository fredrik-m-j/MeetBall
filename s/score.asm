Player0Score:
        dc.l    1222
Player1Score:
        dc.l    3210
Player2Score:
        dc.l    9870
Player3Score:
        dc.l    22341

DirtyPlayer0Score:
	dc.b	$ff
DirtyPlayer1Score:
	dc.b	$ff
DirtyPlayer2Score:
	dc.b	$ff
DirtyPlayer3Score:
	dc.b	$ff


ScoreDigitMap:
	dc.l	0               ; Address to digit 0 in CHIP ram
	dc.l	0               ; Address to digit 1 in CHIP ram
	dc.l	0               ; Address to digit 2 in CHIP ram
	dc.l	0               ; Address to digit 3 in CHIP ram
	dc.l	0               ; Address to digit 4 in CHIP ram
	dc.l	0               ; Address to digit 5 in CHIP ram
	dc.l	0               ; Address to digit 6 in CHIP ram
	dc.l	0               ; Address to digit 7 in CHIP ram
	dc.l	0               ; Address to digit 8 in CHIP ram
	dc.l	0               ; Address to digit 9 in CHIP ram

; Initializes the DigitMap
InitScoreDigitMap:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#ScrBpl-2,d0

	lea	ScoreDigitMap,a0	; Set up digit bobs
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)+
	addi.l 	#(ScrBpl*7*4),d0
	move.l	d0,(a0)

	rts

ResetScores:
        clr.l  	Player0Score
	bsr	DrawPlayer0Score
        clr.l	Player1Score
	bsr	DrawPlayer1Score
        clr.l	Player2Score
	bsr	DrawPlayer2Score
        clr.l	Player3Score
	bsr	DrawPlayer3Score
        rts


; Blits to backing screen first to avoid thrashblits later.
; Can be optimized if Bat3 is not drawn
DrawPlayer0Score:
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*1*4)+36,a0		; Starting point: 4 bitplanes, Y = 1, X = 36th byte
	move.l	a0,a3
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr 	ClearBlitWords

	tst.b	Player0Enabled
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player0Score,d0
	bsr	Binary2Decimal
	move.l	#290,d3
	bsr	BlitScore
.draw
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*1*4)+36,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*1*4)+36,a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr	CopyRestoreGamearea

	rts

; Blits to backing screen first to avoid thrashblits later.
; Can be optimized if Bat2 is not drawn
DrawPlayer1Score:
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*249*4),a0		; Starting point: 4 bitplanes, Y = 249, X = 0 byte
	move.l	a0,a3
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr 	ClearBlitWords

	tst.b	Player1Enabled
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player1Score,d0
	bsr	Binary2Decimal
	moveq	#2,d3
	bsr	BlitScore
.draw
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*249*4),a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*249*4),a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr	CopyRestoreGamearea

	rts

; Blits to backing screen first to avoid thrashblits later.
DrawPlayer2Score:
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a3
	add.l   #(ScrBpl*249*4)+36,a3		; Starting point: 4 bitplanes, Y = 249, X = 36th byte
	bsr	ClearScoreArea

	tst.b	Player2Enabled
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player2Score,d0
	bsr	Binary2Decimal
	move.l	#290,d3
	bsr	BlitScore
.draw
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*249*4)+36,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*249*4)+36,a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr	CopyRestoreGamearea

	rts

; Blits to backing screen first to avoid thrashblits later.
DrawPlayer3Score:
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a3
	add.l   #(ScrBpl*1*4),a3		; Starting point: 4 bitplanes, Y = 1, X = 0 byte
	bsr	ClearScoreArea

	tst.b	Player3Enabled
	bmi.s	.draw

	moveq	#0,d0
	move.l	Player3Score,d0
	bsr	Binary2Decimal
	moveq	#2,d3
	bsr	BlitScore
.draw
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*1*4),a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*1*4),a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr	CopyRestoreGamearea

	rts

; Return address to tile given a pointer into the game area.
; In	a5 = pointer to tile code (byte)
; Out 	a1 = address to tile


; TODO: Harmonize - similar code exist
GetTileFromTileCode:
	moveq	#0,d0

	cmpi.b	#BRICK_2ND_BYTE,(a5)	; Hit last byte part of brick?
	beq.s	.hitLastBrickByte
	move.b	(a5),d0
	bra.s	.lookup

.hitLastBrickByte
	move.b	-1(a5),d0
.lookup
	lsl.l	#2,d0			; Convert .b to .l

	lea	TileMap,a1
	add.l	d0,a1
	move.l 	hAddress(a1),a1		; Lookup tile in tile map
	
	rts

; Checks if score-blitting is needed
ScoreUpdates:
	tst.b	DirtyPlayer0Score
	bmi.s	.checkPlayer1
	bsr	DrawPlayer0Score
.checkPlayer1
	tst.b	DirtyPlayer1Score
	bmi.s	.checkPlayer2
	bsr	DrawPlayer1Score
.checkPlayer2
	tst.b	DirtyPlayer2Score
	bmi.s	.checkPlayer3
	bsr	DrawPlayer2Score
.checkPlayer3
	tst.b	DirtyPlayer3Score
	bmi.s	.exit
	bsr	DrawPlayer3Score
.exit
	move.l	#$ffffffff,DirtyPlayer0Score	; Set all as clean
	rts

; In:	a0 = Pointer to string
; In:	a3 = address to Destination BITMAPBASE
; In:	d0 = String length
; In:	d3.w = top left X position
BlitScore:
	tst.w	d0
	beq.w	.exit

	subq.b	#1,d0		; Loop correctly
.loop
	moveq	#0,d1
	move.b	(a0)+,d1
	subi.b	#$30,d1
	lsl.b	#2,d1		; We'll be adressing longwords in DigitMap

	lea	ScoreDigitMap,a2
	move.l	(a2,d1),a2

	bsr 	BlitDigit

	addq.w	#5,d3		; Next digit X position
	dbf	d0,.loop
.exit
	rts


; ; Blit-routine made for score digits.
; ; a2 = address to digit to be blitted
; ; d3.w = top left X position
; BlitDigitToBuffer:
;         lea 	CUSTOM,a6

; 	move.l	GAMESCREEN_BITMAPBASE,d1
; 	addi.l 	#(ScrBpl*210*4)+12,d1	; 12th byte in Buffer area


; 	IFEQ	ENABLE_DEBUG

; 	WAITBLIT a6

; 	move.l 	#$09f20000,BLTCON0(a6)		; Copy A->D minterm
; 	move.w 	#$ffff,BLTAFWM(a6)
; 	move.w 	#$ffff,BLTALWM(a6)
; 	move.w 	#ScrBpl-3,BLTAMOD(a6)		; Buffer and bob using same dimensions = same modulo
; 	move.w 	#ScrBpl-3,BLTDMOD(a6)
; 	move.l 	a2,BLTAPTH(a6)
; 	move.l 	d1,BLTDPTH(a6)

; 	move.w 	#(64*6*4)+2,BLTSIZE(a6)

; 	ENDC

; 	rts


; Blit-routine made for score digits.
; In:	a2 = address to digit to be blitted
; In:	a3 = address to Destination BITMAPBASE
; In:	d3.w = top left X position
BlitDigit:
	move.l	a3,a4			; Assume next blit destination remain the same
	move.l 	#DEFAULT_MASK,d2	; Assume single word blit

	move.w 	d3,d1
	and.l	#$0000000F,d1		; Get remainder for X position

	move.w	#ScrBpl-2,d5
	move.w 	#(64*6*4)+1,d6

	cmpi.b	#12,d1
	blo.s	.singleWordblit
	subq.w	#2,d5			; Need to blit across 2 words
	addq.w	#1,d6
	move.l 	#$ffff0000,d2		; Adjust mask
	addq.l	#2,a4			; Move Destination to next word

.singleWordblit
	ror.l	#4,d1			; Put remainder in most significant nibble for BLTCONx to do SHIFT

	lea 	CUSTOM,a6
	WAITBLIT a6

	addi.l	#$0dfc0000,d1		; X shift and fc A+B minterm - avoid blit over previous digit(s)
	move.l 	d1,BLTCON0(a6)
	move.l 	d2,BLTAFWM(a6)
	move.w 	d5,BLTAMOD(a6)		; Gamescreen and bob using same dimensions = same modulo
	move.w 	d5,BLTBMOD(a6)
	move.w 	d5,BLTDMOD(a6)
	move.l 	a2,BLTAPTH(a6)
	move.l 	a3,BLTBPTH(a6)
	move.l 	a3,BLTDPTH(a6)

	move.w 	d6,BLTSIZE(a6)

	move.l	a4,a3			; Set Destination address for next digit blit

	rts

; In:	a3 = Address to player score
SetDirtyScore:
	cmpa.l	#Player0Score,a3
	bne.s	.checkPlayer1
	clr.b	DirtyPlayer0Score
	bra.s	.exit
.checkPlayer1
	cmpa.l	#Player1Score,a3
	bne.s	.checkPlayer2
	clr.b	DirtyPlayer1Score
	bra.s	.exit
.checkPlayer2
	cmpa.l	#Player2Score,a3
	bne.s	.checkPlayer3
	clr.b	DirtyPlayer2Score
	bra.s	.exit
.checkPlayer3
	clr.b	DirtyPlayer3Score
.exit
	rts


AddInsanoscore:
	tst.b	Player0Enabled
	bmi.s	.isPlayer1Enabled

	addq.l	#4,Player0Score
	move.b	#0,DirtyPlayer0Score
.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer2Enabled

	addq.l	#4,Player1Score
	move.b	#0,DirtyPlayer1Score
.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer3Enabled

	addq.l	#4,Player2Score
	move.b	#0,DirtyPlayer2Score
.isPlayer3Enabled
	tst.b	Player3Enabled
	bmi.s	.done

	addq.l	#4,Player3Score
	move.b	#0,DirtyPlayer3Score
.done
	rts