; Screen dimensions
bplSize	equ 	DISP_WIDTH*DISP_HEIGHT/8
ScrBpl	equ 	DISP_WIDTH/8

DrawBobs:
	movem.l	d0-d3/a6,-(SP)
	
	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a0
	tst.w	hSprBobXCurrentSpeed(a0)
	beq.s	.isPlayer2Enabled

	lea 	HDL_BITMAP2_DAT,a4
	bsr 	CopyBlitToScreen
.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.exit

	lea	Bat2,a0
	tst.w	hSprBobXCurrentSpeed(a0)
	beq.s	.exit

	lea 	HDL_BITMAP2_DAT,a4
	bsr 	CopyBlitToScreen

.exit
	movem.l	(SP)+,d0-d3/a6
	rts


ClearGameScreenPlayerBobs:
	lea	Bat2,a0
	add.l	#10,hAddress(a0)
	lea 	HDL_BITMAP2_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#10,hAddress(a0)

	lea	Bat3,a0
	add.l	#10,hAddress(a0)
	lea 	HDL_BITMAP2_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#10,hAddress(a0)

	rts

; Simple copyblit routine that expect same modulo from screen and bob.
; In:	a0 = address to bob struct to be blitted
; In:	a4 = address to destination screen
CopyBlitToScreen:
        lea 	CUSTOM,a6

	moveq.l	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	move.w	d1,d3			; Make a copy of X position in d3		
	lsr.w	#3,d1			; In which bitplane byte is this X position?

        move.l 	hAddress(a4),a4		; Set up blit destination in d0
	move.l 	hBitmapBody(a4),d0
	addi.l 	#8,d0			; +8 to get past BODY tag

	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
	mulu.w	hSprBobTopLeftYPos(a0),d2
	sub.w	hBobTopYOffset(a0),d2
	add.l	d2,d0

	add.b	d1,d0			; Add calculated byte (x pos) to get blit Destination

	move.w 	d3,d1
	and.l	#$0000000F,d1		; Get remainder for X position
	ror.l	#4,d1			; Put remainder in most significant nibble for BLTCONx to do SHIFT

	WAITBLIT

	addi.l	#$09f00000,d1		; minterms + X shift
	move.l 	d1,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	hAddress(a0),BLTAPTH(a6)
	move.l 	d0,BLTDPTH(a6)
	move.w 	hBobBlitModulo(a0),BLTAMOD(a6)	; Gamescreen and bob using same dimensions = same modulo
	move.w 	hBobBlitModulo(a0),BLTDMOD(a6)

	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

        rts