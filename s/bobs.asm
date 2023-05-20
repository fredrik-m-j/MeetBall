; Screen dimensions
bplSize	equ 	DISP_WIDTH*DISP_HEIGHT/8
ScrBpl	equ 	DISP_WIDTH/8

ClearBobs:
	tst.b	IsShopOpenForBusiness
	bmi.s	.enemyClear

	lea	ShopBob,a0
	bsr	CopyRestoreFromBobPosToScreen
.enemyClear
	move.l	#MaxEnemySlots,d7		; Restore gfx for all enemies
	subq.b	#1,d7
	lea	AllEnemies,a4
.enemyLoop1
	move.l	(a4)+,d0
	beq.s	.emptySlot1
	move.l	d0,a0
	bsr	CopyRestoreFromBobPosToScreen
.emptySlot1
	dbf	d7,.enemyLoop1

	rts


DrawBobs:
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2

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
	bmi.s	.isShopOpen

	lea	Bat0,a0
	tst.w	hSprBobYCurrentSpeed(a0)
	beq.s	.isShopOpen

	bsr 	CookieBlitToScreen

.isShopOpen
	tst.b	IsShopOpenForBusiness
	bmi.s	.enemyAnim

	lea	ShopBob,a0
	bsr	BobAnim

.enemyAnim
	move.l	#MaxEnemySlots,d7		; Blit gfx for all enemies
	subq.b	#1,d7
	lea	AllEnemies,a4
.enemyLoop
	move.l	(a4)+,d0
	beq.s	.emptySlot
	move.l	d0,a0
	bsr	BobAnim
.emptySlot
	dbf	d7,.enemyLoop

	rts


; In:	a0 = bob handle
BobAnim:
	; btst.b	#0,FrameTick		; Swap pixels every other frame
	; bne.s	.exit
	tst.b	hIndex(a0)		; Anything to animate?
	bmi.s	.exit

	moveq	#0,d0
	move.b  hIndex(a0),d0
.anim
	lsl.l	#3,d0			; Calculate offset
	move.l	hSpriteAnimMap(a0),a3

	move.l	(a3,d0.l),hAddress(a0)
	addq.l	#4,d0
	move.l	(a3,d0.l),hSprBobMaskAddress(a0)

	; Because we cleared bobs earlier we can now cookieblit on top of everything.
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	bsr 	CookieBlitToScreen

	move.b  hIndex(a0),d0
	cmp.b	hLastIndex(a0),d0
	bne.s	.incAnim

	move.b  #0,hIndex(a0)		; Reset anim
	bra.s	.exit
.incAnim
	addq.w	#1,d0
	move.b	d0,hIndex(a0)
.exit
	rts


; Simple clearblit routine
; In:	a0 = address to bob struct position to clear
; In:	a2 = address to destination screen
ClearBlitToScreen:
        lea 	CUSTOM,a6

	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	lsr.w	#3,d1			; In which bitplane byte is this X position?

	move.l 	a2,d0

	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
	move.w	hSprBobTopLeftYPos(a0),d5
	sub.w	hBobTopYOffset(a0),d5
	mulu.w	d5,d2
	
	add.l	d2,d0
	add.l	d1,d0			; Add calculated byte (x pos) to get blit Destination

	WAITBLIT a6

	move.l 	#$01000000,BLTCON0(a6)
	move.l 	d0,BLTDPTH(a6)
	move.w 	hBobBlitDestModulo(a0),BLTDMOD(a6)

	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

        rts

; Simple copyblit routine with 0 modulo in destination.
; In:	a0 = address to source
; In:	d2 = source modulo
; In:	a4 = address to destination
; In:	d3 = blitsize
CopyBlitToActiveBob:
        lea 	CUSTOM,a6

	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)			; minterms
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a4,BLTDPTH(a6)
	move.w 	d2,BLTAMOD(a6)
	move.w 	#0,BLTDMOD(a6)

	move.w 	d3,BLTSIZE(a6)

        rts

; Copyblit for vertical resizing.
; In:	a1 = address to source
; In:	a2 = address to destination
; In:	d2 = source modulo
; In:	d3 = blitsize
BatExtendVerticalBlitToActiveBob:
        lea 	CUSTOM,a6

	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	a1,BLTAPTH(a6)
	move.l 	a2,BLTDPTH(a6)
	move.w 	d2,BLTAMOD(a6)
	move.w 	#0,BLTDMOD(a6)		; 2 bytes wide - blit 1 word / line

	move.w 	d3,BLTSIZE(a6)

        rts

BatExtendHorizontalBlitToActiveBob:
        lea 	CUSTOM,a6
	move.l	d1,d0
	addi.l	#$09f00000,d0		; minterms + X shift

	WAITBLIT a6

	move.l 	d0,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	(a3),BLTALWM(a6)
	move.l 	a1,BLTAPTH(a6)
	move.l 	a2,BLTDPTH(a6)
	move.w 	d2,BLTAMOD(a6)
	move.w 	#BatHorizByteWidth-4,BLTDMOD(a6)	; blit 2 word / line

	move.w 	d3,BLTSIZE(a6)

        rts


; Simple copyblit routine.
; In:	a0 = address to bob struct to be blitted
; In:	a4 = address to destination screen
CopyBlitToScreen:
        lea 	CUSTOM,a6

	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	move.w	d1,d3			; Make a copy of X position in d3		
	lsr.w	#3,d1			; In which bitplane byte is this X position?

	move.l	a4,d0

	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
	move.w	hSprBobTopLeftYPos(a0),d5
	sub.w	hBobTopYOffset(a0),d5
	mulu.w	d5,d2
	
	add.l	d2,d0
	add.l	d1,d0			; Add calculated byte (x pos) to get blit Destination

	move.w 	d3,d1
	and.l	#$0000000F,d1		; Get remainder for X position
	ror.l	#4,d1			; Put remainder in most significant nibble for BLTCONx to do SHIFT

	WAITBLIT a6

	addi.l	#$09f00000,d1		; minterms + X shift
	move.l 	d1,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	hAddress(a0),BLTAPTH(a6)
	move.l 	d0,BLTDPTH(a6)
	move.w 	hBobBlitSrcModulo(a0),BLTAMOD(a6)
	move.w 	hBobBlitDestModulo(a0),BLTDMOD(a6)

	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

        rts

; In:   a0 = Source
; In:   a1 = Destination to restore
; In:   d1.w = Modulo
; In:   d2.w = Blit size
CopyRestoreGamearea:
        lea 	CUSTOM,a6
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l 	#$ffffffff,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	d1,BLTAMOD(a6)		; Using screen modulo for Source/Destination
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)

        rts


; In:   a1 = Destination to fill
; In:   d1.w = Modulo
; In:   d2.w = Blit size
FillBoxBlit:
	lea 	CUSTOM,a6
        
	WAITBLIT a6

	move.l 	#$01000014,BLTCON0(a6)		; fill carry + Exclusive fill. Use D
	move.l 	a1,BLTDPTH(a6)
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)

	rts


; Simple copyblit routine.
; In:	a0 = address to bob struct marking the area to be restored
CopyRestoreFromBobPosToScreen:
        lea 	CUSTOM,a6

	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	move.w	d1,d3			; Make a copy of X position in d3		
	lsr.w	#3,d1			; In which bitplane byte is this X position?

	move.l	GAMESCREEN_BITMAPBASE,d0
	move.l	GAMESCREEN_BITMAPBASE_BACK,d4

	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
	move.w	hSprBobTopLeftYPos(a0),d5
	sub.w	hBobTopYOffset(a0),d5
	mulu.w	d5,d2
	
	add.l	d2,d4			; Add calculated byte (x pos) to get blit Source
	add.l	d1,d4

	add.l	d2,d0
	add.l	d1,d0			; Add calculated byte (x pos) to get blit Destination

	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	d4,BLTAPTH(a6)
	move.l 	d0,BLTDPTH(a6)
	move.w 	hBobBlitDestModulo(a0),BLTAMOD(a6)	; Using screen modulo for Source/Destination
	move.w 	hBobBlitDestModulo(a0),BLTDMOD(a6)

	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

        rts


; Cookie-cut blit routine.
; In:	a0 = address to bob struct to be blitted
; In:	a1 = address to background
; In:	a2 = address to blit Destination
CookieBlitToScreen:
	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	bmi.s	.outOfBounds			; Prevent bad blits

	move.w	d1,d3				; Make a copy of X position in d3		
	lsr.w	#3,d1				; In which bitplane byte is this X position?

        move.l 	a2,d0				; Destination
	move.l	#(ScrBpl*4),d2			; TODO dynamic handling of no. of bitplanes
	
	move.w	hSprBobTopLeftYPos(a0),d5
	sub.w	hBobTopYOffset(a0),d5
	mulu.w	d5,d2

	add.l	d2,d0
	add.l	d1,d0				; Add calculated byte (x pos) to get blit Destination

	move.l	a1,d4				; Background gfx
	add.l	d2,d4
	add.l	d1,d4

	move.w 	d3,d1				; Set up SHIFT for A and B
	and.l	#$0000000F,d1			; Get remainder for X position
	add.w	d1,d1
	add.w	d1,d1
	lea	(BltConLookUp,pc,d1),a5

	lea	CUSTOM,a6

	WAITBLIT a6

	move.l 	(a5),BLTCON0(a6)
	move.l 	hBobBlitMasks(a0),BLTAFWM(a6)
	move.l	hSprBobMaskAddress(a0),BLTAPTH(a6)
	move.l 	hAddress(a0),BLTBPTH(a6)
	move.l 	d4,BLTCPTH(a6)
	move.l 	d0,BLTDPTH(a6)

	move.w	hBobBlitSrcModulo(a0),d0
	move.w	hBobBlitDestModulo(a0),d1
	move.w 	d0,BLTAMOD(a6)
	move.w 	d0,BLTBMOD(a6)
	move.w 	d1,BLTCMOD(a6)
	move.w 	d1,BLTDMOD(a6)

	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

.outOfBounds
        rts

; CREDITS
; X shifts + cookie-cut minterm
; djh0ffman - Knightmare
; https://github.com/djh0ffman/KnightmareAmiga
BltConLookUp:
	dc.l	$0fca0000
	dc.l	$1fca1000
	dc.l	$2fca2000
	dc.l	$3fca3000
	dc.l	$4fca4000
	dc.l	$5fca5000
	dc.l	$6fca6000
	dc.l	$7fca7000
	dc.l	$8fca8000
	dc.l	$9fca9000
	dc.l	$afcaa000
	dc.l	$bfcab000
	dc.l	$cfcac000
	dc.l	$dfcad000
	dc.l	$efcae000
	dc.l	$ffcaf000