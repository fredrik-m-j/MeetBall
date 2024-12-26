; Screen dimensions
bplSize		equ 	DISP_WIDTH*DISP_HEIGHT/8
ScrBpl		equ 	DISP_WIDTH/8
DEFAULT_MASK    equ     $ffffffff

PatternMask:	dc.l	0

; In:   a6 = address to CUSTOM dff000
InitBobs:
	bsr	InitTileMap
	bsr	InitScoreDigitMap
	bsr	InitClockDigitMap

	bsr	InitGenericBallBob
	bsr	InitBulletBob
	bsr	InitPlayerBobs
	bsr	InitEnemies
	bsr	InitShop

	rts

; In:   a6 = address to CUSTOM dff000
ClearBobs:
	tst.b	IsShopOpenForBusiness
	bmi.s	.enemyClear

	lea	ShopBob,a0
	bsr	CopyRestoreFromBobPosToScreen

.enemyClear
	move.w	EnemyCount,d7
	beq	.clearBullets

	subq.w	#1,d7
	lea	FreeEnemyStack,a4		; Restore gfx for all enemies
.enemyLoop
	move.l	(a4)+,a0
	bsr	CopyRestoreFromBobPosToScreen
	dbf	d7,.enemyLoop

.clearBullets
	; TODO - consider removing need for extra clear-blit
	moveq	#MaxBulletSlots-1,d7		; Blit gfx for all bullets
	lea	AllBullets,a4
.bulletLoop
	move.l	(a4)+,d0
	beq.s	.emptyBulletSlot

	move.l	d0,a0
	bsr 	CopyRestoreFromBobPosToScreen
.emptyBulletSlot
	dbf	d7,.bulletLoop

	rts

; In:	d0.b = Draws all if #1, or skips player bats if #0 (chill mode special).
DrawBobs:
	movem.l	d7/a3-a5,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_BACK,a4
	move.l	GAMESCREEN_BITMAPBASE,a5

	tst.b	d0
	beq	.isShopOpen

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a3
	tst.w	hSprBobXCurrentSpeed(a3)
	beq.s	.isPlayer2Enabled

	bsr 	CookieBlitToScreen

	move.l	#SpinBat3X,a0			; Any spin-lines to draw?
	tst.w	(a0)
	beq	.isPlayer2Enabled
	bsr	SpinlineXOr

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea	Bat2,a3
	tst.w	hSprBobXCurrentSpeed(a3)
	beq.s	.isPlayer1Enabled

	bsr 	CookieBlitToScreen

	move.l	#SpinBat2X,a0			; Any spin-lines to draw?
	tst.w	(a0)
	beq	.isPlayer1Enabled
	bsr	SpinlineXOr

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea	Bat1,a3
	tst.w	hSprBobYCurrentSpeed(a3)
	beq.s	.isPlayer0Enabled

	bsr 	CookieBlitToScreen

	move.l	#SpinBat1X,a0			; Any spin-lines to draw?
	tst.w	(a0)
	beq	.isPlayer0Enabled
	bsr	SpinlineXOr

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.isShopOpen

	lea	Bat0,a3
	tst.w	hSprBobYCurrentSpeed(a3)
	beq.s	.isShopOpen

	bsr 	CookieBlitToScreen

	move.l	#SpinBat0X,a0			; Any spin-lines to draw?
	tst.w	(a0)
	beq	.isShopOpen
	bsr	SpinlineXOr

.isShopOpen
	tst.b	IsShopOpenForBusiness
	bmi.s	.enemyAnim

	lea	ShopBob,a3
	move.l	GAMESCREEN_BITMAPBASE,a4
	bsr	BobAnim

.enemyAnim
	move.w	EnemyCount,d7
	beq	.drawBullets

	subq.w	#1,d7
	move.l	GAMESCREEN_BITMAPBASE,a4
	lea	FreeEnemyStack,a0		; Blit gfx for all enemies
.enemyLoop
	move.l	(a0)+,a3
	bsr	BobAnim
	dbf	d7,.enemyLoop

.drawBullets
	move.l	GAMESCREEN_BITMAPBASE_BACK,a4
	moveq	#MaxBulletSlots-1,d7		; Blit gfx for all bullets
	lea	AllBullets,a0
.bulletLoop					; TODO: consider using free bob stack
	move.l	(a0)+,d0
	beq.s	.emptyBulletSlot

	move.l	d0,a3
	bsr 	CookieBlitToScreen
.emptyBulletSlot
	dbf	d7,.bulletLoop

	movem.l	(sp)+,d7/a3-a5
	rts


; In:	a3 = address to bob struct to be blitted
; In:	a4 = address to background
; In:	a5 = address to blit Destination
; In:	a6 = address to CUSTOM $dff000
BobAnim:
	; move.l	d2,-(sp)	; Performance optimization

	; btst.b	#0,FrameTick	; Swap pixels every other frame
	; bne.s	.exit

	; Extra check
	; tst.b	hIndex(a3)		; Anything to animate?
	; bmi.s	.exit

	moveq	#0,d0
	move.b	hIndex(a3),d0
	move.b	d0,d2			; Save for later
	lsl.w	#3,d0			; Calculate offset
	move.l	hSpriteAnimMap(a3),a1
	add.l	d0,a1

	move.l	(a1)+,hAddress(a3)
	move.l	(a1),hSprBobMaskAddress(a3)

	; Because we cleared bobs earlier we can now cookieblit on top of everything.
	bsr 	CookieBlitToScreen

	cmp.b	hLastIndex(a3),d2
	bne.s	.incAnim

	clr.b	hIndex(a3)		; Reset anim
	bra.s	.exit
.incAnim
	addq.b	#1,hIndex(a3)
.exit
	; move.l	(sp)+,d2
	rts


; Simple clearblit routine
; In:	a3 = address to bob struct position to clear
; In:	a5 = address to destination screen
; In:	a6 = address to CUSTOM $dff000
ClearBlitToScreen:
	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a3),d1
	sub.w	hBobLeftXOffset(a3),d1
	lsr.w	#3,d1			; In which bitplane byte is this X position?

	move.w	hSprBobTopLeftYPos(a3),d0
	sub.w	hBobTopYOffset(a3),d0
	mulu.w	#(ScrBpl*4),d0

	add.w	d0,d1			; Offset
	add.l	a5,d1			; Destination

	WAITBLIT a6

	move.l 	#$01000000,BLTCON0(a6)
	move.l 	d1,BLTDPTH(a6)
	move.w 	hBobBlitDestModulo(a3),BLTDMOD(a6)

	move.w 	hBobBlitSize(a3),BLTSIZE(a6)

        rts

; Simple copyblit routine with 0 modulo in destination.
; In:	a0 = address to source
; In:	d0 = minterms/shift
; In:	d2 = source modulo
; In:	d3 = blitsize
; In:	a4 = address to destination
; In:	a6 = address to CUSTOM $dff000
CopyBlitToActiveBob:

	WAITBLIT a6

	move.l 	d0,BLTCON0(a6)			; minterms
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a4,BLTDPTH(a6)
	move.w 	d2,BLTAMOD(a6)
	move.w	#0,BLTDMOD(a6)

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
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	a1,BLTAPTH(a6)
	move.l 	a2,BLTDPTH(a6)
	move.w 	d2,BLTAMOD(a6)
	move.w	#0,BLTDMOD(a6)		; 2 bytes wide - blit 1 word / line

	move.w 	d3,BLTSIZE(a6)

        rts

; In:	a1 = address to source
; In:	a2 = address to destination
; In:	a3 = address to last blitmask word
; In:	d1.l = pixels to shift
; In:	d2 = source modulo
; In:	d3 = blitsize
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
; CopyBlitToScreen:
;         lea 	CUSTOM,a6

; 	moveq	#0,d1
; 	move.w 	hSprBobTopLeftXPos(a0),d1
; 	sub.w	hBobLeftXOffset(a0),d1
; 	move.w	d1,d3			; Make a copy of X position in d3		
; 	lsr.w	#3,d1			; In which bitplane byte is this X position?

; 	move.l	a4,d0

; 	move.l	#(ScrBpl*4),d2		; TODO dynamic handling of no. of bitplanes
; 	move.w	hSprBobTopLeftYPos(a0),d5
; 	sub.w	hBobTopYOffset(a0),d5
; 	mulu.w	d5,d2
	
; 	add.l	d2,d0
; 	add.l	d1,d0			; Add calculated byte (x pos) to get blit Destination

; 	move.w 	d3,d1
; 	and.l	#$0000000F,d1		; Get remainder for X position
; 	ror.l	#4,d1			; Put remainder in most significant nibble for BLTCONx to do SHIFT

; 	WAITBLIT a6

; 	addi.l	#$09f00000,d1		; minterms + X shift
; 	move.l 	d1,BLTCON0(a6)
; 	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
; 	move.l 	hAddress(a0),BLTAPTH(a6)
; 	move.l 	d0,BLTDPTH(a6)
; 	move.w 	hBobBlitSrcModulo(a0),BLTAMOD(a6)
; 	move.w 	hBobBlitDestModulo(a0),BLTDMOD(a6)

; 	move.w 	hBobBlitSize(a0),BLTSIZE(a6)

;         rts

; In:   a0 = Source
; In:   a1 = Destination to restore
; In:   d1.w = Modulo
; In:   d2.w = Blit size
; In:   a6 = address to CUSTOM dff000
CopyRestoreGamearea:
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	d1,BLTAMOD(a6)		; Using screen modulo for Source/Destination
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)

        rts

; In:   a0 = Source
; In:   a1 = Destination to restore
; In:   d1.w = Modulo
; In:   d2.w = Blit size
; In:	d3.l = First- & last-word masks
; In:   a6 = address to CUSTOM dff000
CopyRestoreGameareaMasked:
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l	d3,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	d1,BLTAMOD(a6)		; Using screen modulo for Source/Destination
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)

        rts

; In:   a0 = Source
; In:   a1 = Destination to restore
; In:   d0.l = First and Last word mask
; In:   d1.w = Modulo
; In:   d2.w = Blit size
CopyBlit:
        lea 	CUSTOM,a6
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l 	d0,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	d1,BLTAMOD(a6)		; Using screen modulo for Source/Destination
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)

        rts


; In:   a5 = Destination to fill
; In:	a6 = address to CUSTOM $dff000
; In:   d1.w = Modulo
; In:   d2.w = Blit size
FillBoxBlit:
	WAITBLIT a6

	move.l 	#$01000014,BLTCON0(a6)		; fill carry + Exclusive fill. Use D
	move.l 	a5,BLTDPTH(a6)
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)

	rts


; Simple copyblit routine.
; In:	a0 = address to bob struct marking the area to be restored
; In:	a6 = address to CUSTOM $dff000
CopyRestoreFromBobPosToScreen:
	moveq	#0,d0
	moveq	#0,d1

	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	bmi.s	.outOfBounds		; Prevent bad blits
	lsr.w	#3,d1			; In which bitplane byte is this X position?

	move.w	hSprBobTopLeftYPos(a0),d0
	sub.w	hBobTopYOffset(a0),d0
	mulu.w	#(ScrBpl*4),d0

	add.l	d0,d1			; Offset into gfx is now calculated

	move.l	GAMESCREEN_BITMAPBASE_BACK,d0
	add.l	d1,d0			; Add offset to get blit Source

	add.l	GAMESCREEN_BITMAPBASE,d1; Add offset to get blit Destination

	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	d0,BLTAPTH(a6)
	move.l 	d1,BLTDPTH(a6)

	move.w	hBobBlitDestModulo(a0),d0
	move.w 	d0,BLTAMOD(a6)		; Using screen modulo for Source/Destination
	move.w 	d0,BLTDMOD(a6)
	move.w 	hBobBlitSize(a0),BLTSIZE(a6)
	
.outOfBounds
        rts


; Cookie-cut blit routine.
; In:	a3 = address to bob struct to be blitted
; In:	a4 = address to background
; In:	a5 = address to blit Destination
; In:	a6 = address to CUSTOM $dff000
CookieBlitToScreen:
	moveq	#0,d0
	moveq	#0,d1

	move.w 	hSprBobTopLeftXPos(a3),d0
	sub.w	hBobLeftXOffset(a3),d0
	bmi.s	.outOfBounds			; Prevent bad blits

	move.w 	d0,d1				; Calculate SHIFT for A and B
	and.w	#$000F,d1			; Get remainder for X position
	add.w	d1,d1
	add.w	d1,d1
	lea	(BltConLookUp,pc,d1),a1

	lsr.w	#3,d0				; In which bitplane byte is this X position?

	move.w	hSprBobTopLeftYPos(a3),d1
	sub.w	hBobTopYOffset(a3),d1
	mulu.w	#(ScrBpl*4),d1

	add.w	d0,d1				; Add calculated byte (x pos) to get offset

	move.l	a4,d0				; Background gfx
	add.l	d1,d0

	add.l 	a5,d1				; Destination

	WAITBLIT a6

	move.l 	(a1),BLTCON0(a6)
	move.l 	hBobBlitMasks(a3),BLTAFWM(a6)
	move.l	hSprBobMaskAddress(a3),BLTAPTH(a6)
	move.l 	hAddress(a3),BLTBPTH(a6)
	move.l 	d0,BLTCPTH(a6)
	move.l 	d1,BLTDPTH(a6)

	move.w	hBobBlitSrcModulo(a3),d0
	move.w	hBobBlitDestModulo(a3),d1
	move.w 	d0,BLTAMOD(a6)
	move.w 	d0,BLTBMOD(a6)
	move.w 	d1,BLTCMOD(a6)
	move.w 	d1,BLTDMOD(a6)

	move.w 	hBobBlitSize(a3),BLTSIZE(a6)

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