Player0Score:
        dc.w    12341
Player1Score:
        dc.w    3210
Player2Score:
        dc.w    9870
Player3Score:
        dc.w    22341

DirtyPlayer0Score
	dc.b	$ff
DirtyPlayer1Score
	dc.b	$ff
DirtyPlayer2Score
	dc.b	$ff
DirtyPlayer3Score
	dc.b	$ff


; In:	a0 = Target score bitplane area to be cleared
ClearScore:
	; move.l 	#0,0*40(a0)
        ; move.l  #0,1*40(a0)
        ; move.l  #0,2*40(a0)
        ; move.l  #0,3*40(a0)

	move.b 	#0,0*40+0(a0)
        move.b  #0,0*40+1(a0)
        move.b  #0,0*40+2(a0)
        move.b  #0,0*40+3(a0)

	move.b 	#0,1*40+0(a0)
        move.b  #0,1*40+1(a0)
        move.b  #0,1*40+2(a0)
        move.b  #0,1*40+3(a0)
	
	move.b 	#0,2*40+0(a0)
        move.b  #0,2*40+1(a0)
        move.b  #0,2*40+2(a0)
        move.b  #0,2*40+3(a0)

	move.b 	#0,3*40+0(a0)
        move.b  #0,3*40+1(a0)
        move.b  #0,3*40+2(a0)
        move.b  #0,3*40+3(a0)

	; move.l  #0,4*40(a0)
	; move.l 	#0,5*40(a0)
        ; move.l  #0,6*40(a0)
        ; move.l  #0,7*40(a0)

	move.b  #0,4*40+0(a0)
	move.b 	#0,4*40+1(a0)
        move.b  #0,4*40+2(a0)
        move.b  #0,4*40+3(a0)

	move.b  #0,5*40+0(a0)
	move.b 	#0,5*40+1(a0)
        move.b  #0,5*40+2(a0)
        move.b  #0,5*40+3(a0)

	move.b  #0,6*40+0(a0)
	move.b 	#0,6*40+1(a0)
        move.b  #0,6*40+2(a0)
        move.b  #0,6*40+3(a0)

	move.b  #0,7*40+0(a0)
	move.b 	#0,7*40+1(a0)
        move.b  #0,7*40+2(a0)
        move.b  #0,7*40+3(a0)

        ; move.l  #0,8*40(a0)
	; move.l  #0,9*40(a0)
	; move.l 	#0,10*40(a0)
        ; move.l  #0,11*40(a0)

        move.b  #0,8*40+0(a0)
	move.b  #0,8*40+1(a0)
	move.b 	#0,8*40+2(a0)
        move.b  #0,8*40+3(a0)

        move.b  #0,9*40+0(a0)
	move.b  #0,9*40+1(a0)
	move.b 	#0,9*40+2(a0)
        move.b  #0,9*40+3(a0)

        move.b  #0,10*40+0(a0)
	move.b  #0,10*40+1(a0)
	move.b 	#0,10*40+2(a0)
        move.b  #0,10*40+3(a0)

        move.b  #0,11*40+0(a0)
	move.b  #0,11*40+1(a0)
	move.b 	#0,11*40+2(a0)
        move.b  #0,11*40+3(a0)

        ; move.l  #0,12*40(a0)
        ; move.l  #0,13*40(a0)
	; move.l  #0,14*40(a0)
	; move.l  #0,15*40(a0)

        move.b  #0,12*40+0(a0)
        move.b  #0,12*40+1(a0)
	move.b  #0,12*40+2(a0)
	move.b  #0,12*40+3(a0)

        move.b  #0,13*40+0(a0)
        move.b  #0,13*40+1(a0)
	move.b  #0,13*40+2(a0)
	move.b  #0,13*40+3(a0)

        move.b  #0,14*40+0(a0)
        move.b  #0,14*40+1(a0)
	move.b  #0,14*40+2(a0)
	move.b  #0,14*40+3(a0)

        move.b  #0,15*40+0(a0)
        move.b  #0,15*40+1(a0)
	move.b  #0,15*40+2(a0)
	move.b  #0,15*40+3(a0)

        ; move.l  #0,16*40(a0)
        ; move.l  #0,17*40(a0)
	; move.l  #0,18*40(a0)
	; move.l  #0,19*40(a0)

        move.b  #0,16*40+0(a0)
        move.b  #0,16*40+1(a0)
	move.b  #0,16*40+2(a0)
	move.b  #0,16*40+3(a0)

        move.b  #0,17*40+0(a0)
        move.b  #0,17*40+1(a0)
	move.b  #0,17*40+2(a0)
	move.b  #0,17*40+3(a0)

        move.b  #0,18*40+0(a0)
        move.b  #0,18*40+1(a0)
	move.b  #0,18*40+2(a0)
	move.b  #0,18*40+3(a0)

        move.b  #0,19*40+0(a0)
        move.b  #0,19*40+1(a0)
	move.b  #0,19*40+2(a0)
	move.b  #0,19*40+3(a0)

        ; move.l  #0,20*40(a0)
        ; move.l  #0,21*40(a0)
	; move.l  #0,22*40(a0)
	; move.l  #0,23*40(a0)

        move.b  #0,20*40+0(a0)
        move.b  #0,20*40+1(a0)
	move.b  #0,20*40+2(a0)
	move.b  #0,20*40+3(a0)

        move.b  #0,21*40+0(a0)
        move.b  #0,21*40+1(a0)
	move.b  #0,21*40+2(a0)
	move.b  #0,21*40+3(a0)

        move.b  #0,22*40+0(a0)
        move.b  #0,22*40+1(a0)
	move.b  #0,22*40+2(a0)
	move.b  #0,22*40+3(a0)

        move.b  #0,23*40+0(a0)
        move.b  #0,23*40+1(a0)
	move.b  #0,23*40+2(a0)
	move.b  #0,23*40+3(a0)

	rts

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
	addi.l 	#ScrBpl*80*4,d0

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
        move.w  #0,Player0Score
	bsr	DrawPlayer0Score
        move.w  #0,Player1Score
	bsr	DrawPlayer1Score
        move.w  #0,Player2Score
	bsr	DrawPlayer2Score
        move.w  #0,Player3Score
	bsr	DrawPlayer3Score
        rts

DrawPlayer0Score:
	move.l 	GAMESCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*4*1)+36,a0		; Starting point: 4 bitplanes, Y = 1, X = 36th byte
	bsr	ClearScore
	
	tst.b	Player0Enabled
	bne.s	.exit

	moveq	#0,d0
	move.w	Player0Score,d0
	bsr	Binary2Decimal
	move.l	#290,d3
	moveq	#1,d4
	bsr	BlitScore

	move.b	$ff,DirtyPlayer0Score
.exit
	rts

DrawPlayer1Score:
	move.l 	GAMESCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*4*249),a0		; Starting point: 4 bitplanes, Y = 249, X = 0 byte
	bsr	ClearScore

	tst.b	Player1Enabled
	bne.s	.exit

	moveq	#0,d0
	move.w	Player1Score,d0
	bsr	Binary2Decimal
	moveq	#2,d3
	move.l	#249,d4				; Use .l to prevent trash in upper bytes
	bsr	BlitScore

	move.b	$ff,DirtyPlayer1Score
.exit
	rts

DrawPlayer2Score:
	move.l 	GAMESCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*4*249)+36,a0		; Starting point: 4 bitplanes, Y = 249, X = 36th byte
	bsr	ClearScore

	tst.b	Player2Enabled
	bne.s	.exit

	moveq	#0,d0
	move.w	Player2Score,d0
	bsr	Binary2Decimal
	move.l	#290,d3
	move.l	#249,d4
	bsr	BlitScore

	move.b	$ff,DirtyPlayer2Score
.exit
	rts

DrawPlayer3Score:
	move.l 	GAMESCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*4*1),a0		; Starting point: 4 bitplanes, Y = 1, X = 0 byte
	bsr	ClearScore

	tst.b	Player3Enabled
	bne.s	.exit

	moveq	#0,d0
	move.w	Player3Score,d0
	bsr	Binary2Decimal
	moveq	#2,d3
	moveq	#1,d4
	bsr	BlitScore

	move.b	$ff,DirtyPlayer3Score
.exit
	rts

; Give points to player
; In:   a0 = address to ball structure
; In:	a5 = pointer to game area tile (byte)
UpdatePlayerTileScore:
	movem.l	a0-a1,-(SP)

	bsr	GetTileFromTileCode

	move.w	hBrickPoints(a1),d0
	beq.s	.exit			; No points for this tile

	move.l	hBallPlayerScore(a0),a0
	add.w	d0,(a0)			; add points

	cmpa.l	#Player0Score,a0
	bne.s	.checkPlayer1
	move.b	#0,DirtyPlayer0Score
	bra.s	.exit
.checkPlayer1
	cmpa.l	#Player1Score,a0
	bne.s	.checkPlayer2
	move.b	#0,DirtyPlayer1Score
	bra.s	.exit
.checkPlayer2
	cmpa.l	#Player2Score,a0
	bne.s	.checkPlayer3
	move.b	#0,DirtyPlayer2Score
	bra.s	.exit
.checkPlayer3
	move.b	#0,DirtyPlayer3Score

.exit
	movem.l	(SP)+,a0-a1
	rts

; Return address to tile given a pointer into the game area.
; In	a5 = pointer to tile code (byte)
; Out 	a1 = address to tile
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
	bne.s	.checkPlayer1
	bsr	DrawPlayer0Score
.checkPlayer1
	tst.b	DirtyPlayer1Score
	bne.s	.checkPlayer2
	bsr	DrawPlayer1Score
.checkPlayer2
	tst.b	DirtyPlayer2Score
	bne.s	.checkPlayer3
	bsr	DrawPlayer2Score
.checkPlayer3
	tst.b	DirtyPlayer3Score
	bne.s	.exit
	bsr	DrawPlayer3Score
.exit
	rts

; In:	a0 = Pointer to string
; In:	d0 = String length
; In:	d3.w = top left X position
; In:	d4.b = top left Y position
BlitScore:
	tst.w	d0
	beq.s	.exit

	subq.b	#1,d0		; Loop correctly
.loop
	moveq	#0,d1
	move.b	(a0)+,d1
	subi.b	#$30,d1
	lsl.b	#2,d1		; We'll be adressing longwords in DigitMap

	lea	ScoreDigitMap,a2
	move.l	(a2,d1),a2

	bsr 	BlitDigit

	addq.w	#5,d3		; Next digit position
	dbf	d0,.loop
.exit
	rts


; ; Blit-routine made for score digits.
; ; a2 = address to digit to be blitted
; ; d3.w = top left X position
; ; d4.b = top left Y position
; BlitDigitToBuffer:
;         lea 	CUSTOM,a6

; 	move.l	GAMESCREEN_BITMAPBASE,d1
; 	addi.l 	#(ScrBpl*210*4)+12,d1	; 12th byte in Buffer area


; 	IFEQ	ENABLE_DEBUG

; 	WAITBLIT

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
; In:	d3.w = top left X position
; In:	d4.b = top left Y position
BlitDigit:
	move.w	d3,d1			; Make a copy of X position
	lsr.w	#3,d1			; In which bitplane byte is this X position?

	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
	mulu.w	d4,d2
	add.l	GAMESCREEN_BITMAPBASE,d2; Add Destination base to start of Y
	add.b	d1,d2			; Add calculated byte (X pos) to get Destination

	move.w 	d3,d1
	and.l	#$0000000F,d1		; Get remainder for X position

	move.w	#ScrBpl-1,d5
	move.w 	#(64*6*4)+1,d6

	cmpi.b	#12,d1
	blo.s	.singleWordblit
	subq.w	#3,d5			; Need to blit across 2 words
	addq.w	#1,d6

.singleWordblit
	ror.l	#4,d1			; Put remainder in most significant nibble for BLTCONx to do SHIFT

	lea 	CUSTOM,a6
	WAITBLIT

	addi.l	#$0dfc0000,d1		; X shift and fc A+B minterm - avoid blit over previous digit(s)
	move.l 	d1,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.w 	d5,BLTAMOD(a6)		; Gamescreen and bob using same dimensions = same modulo
	move.w 	d5,BLTBMOD(a6)
	move.w 	d5,BLTDMOD(a6)
	move.l 	a2,BLTAPTH(a6)
	move.l 	d2,BLTBPTH(a6)
	move.l 	d2,BLTDPTH(a6)

	move.w 	d6,BLTSIZE(a6)

	rts