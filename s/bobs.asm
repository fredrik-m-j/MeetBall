; Screen dimensions
bplSize	equ 	DISP_WIDTH*DISP_HEIGHT/8
ScrBpl	equ 	DISP_WIDTH/8

DrawBobs:
	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a0
	tst.w	hSprBobXCurrentSpeed(a0)
	beq.s	.isPlayer2Enabled

	bsr 	CookieBlitToScreen
.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea	Bat2,a0
	tst.w	hSprBobXCurrentSpeed(a0)
	beq.s	.isPlayer1Enabled

	bsr 	CookieBlitToScreen
.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea	Bat1,a0
	tst.w	hSprBobYCurrentSpeed(a0)
	beq.s	.isPlayer0Enabled

	bsr 	CookieBlitToScreen
.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea	Bat0,a0
	tst.w	hSprBobYCurrentSpeed(a0)
	beq.s	.exit

	bsr 	CookieBlitToScreen

.exit
	rts


ClearGameScreenPlayerBobs:
	lea	Bat0,a0
	add.l	#20,hAddress(a0)	; Ugly hack to use same routine for clearing
	lea 	HDL_BITMAP2_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#20,hAddress(a0)

	lea	Bat0,a0
	add.l	#20,hAddress(a0)	; Ugly hack to use same routine for clearing
	lea 	HDL_BITMAP2_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#20,hAddress(a0)

	lea	Bat2,a0
	add.l	#20,hAddress(a0)	; Ugly hack to use same routine for clearing
	lea 	HDL_BITMAP2_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#20,hAddress(a0)

	lea	Bat3,a0
	add.l	#20,hAddress(a0)	; Ugly hack to use same routine for clearing
	lea 	HDL_BITMAP2_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#20,hAddress(a0)

	rts

; Simple copyblit routine that expect same modulo from screen and bob.
; In:	a0 = address to bob struct to be blitted
; In:	a4 = address to destination screen
CopyBlitToScreen:
        lea 	CUSTOM,a6

	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	move.w	d1,d3			; Make a copy of X position in d3		
	lsr.w	#3,d1			; In which bitplane byte is this X position?

        move.l 	hAddress(a4),a4		; Set up blit destination in d0
	move.l 	hBitmapBody(a4),d0
	addi.l 	#8,d0			; +8 to get past BODY tag

	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
	move.w	hSprBobTopLeftYPos(a0),d5
	sub.w	hBobTopYOffset(a0),d5
	mulu.w	d5,d2
	
	add.l	d2,d0
	add.l	d1,d0			; Add calculated byte (x pos) to get blit Destination

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

; Cookie-cut blit routine.
; In:	a0 = address to bob struct to be blitted
CookieBlitToScreen:
        lea 	CUSTOM,a6

	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	move.w	d1,d3				; Make a copy of X position in d3		
	lsr.w	#3,d1				; In which bitplane byte is this X position?

        move.l 	GAMESCREEN_BITMAPBASE,d0	; Set up blit destination in d0
	move.l	#(ScrBpl*4),d2			; TODO dynamic handling of no. of bitplanes
	
	move.w	hSprBobTopLeftYPos(a0),d5
	sub.w	hBobTopYOffset(a0),d5
	mulu.w	d5,d2

	add.l	d2,d0
	add.l	d1,d0				; Add calculated byte (x pos) to get blit Destination

	move.l	GAMESCREEN_BITMAPBASE_BACK,d4	; Target the same for the background gfx in backing memory
	add.l	d2,d4
	add.l	d1,d4

	move.w 	d3,d1				; Set up SHIFT for A and B
	and.l	#$0000000F,d1			; Get remainder for X position
	move.l	d1,d2
	ror.l	#4,d1				; Put remainder in most significant nibble for BLTCONx to do SHIFT

	ror.w	#4,d2
	add.l	d2,d1				; Set same SHIFT for B

	WAITBLIT

	addi.l	#$0fca0000,d1			; X shift + cookie-cut minterm
	move.l 	d1,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l	hSprBobMaskAddress(a0),BLTAPTH(a6)
	move.l 	hAddress(a0),BLTBPTH(a6)
	move.l 	d4,BLTCPTH(a6)
	move.l 	d0,BLTDPTH(a6)

	move.w	hBobBlitModulo(a0),d0		; Gamescreen and bob&mask using same dimensions = same modulo
	move.w 	d0,BLTAMOD(a6)
	move.w 	d0,BLTBMOD(a6)
	move.w 	d0,BLTCMOD(a6)
	move.w 	d0,BLTDMOD(a6)

	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

        rts