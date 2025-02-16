; In:	a6 = address to CUSTOM $dff000
InitBobs:
	bsr		InitTileMap
	bsr		InitScoreDigitMap
	bsr		InitClock

	bsr		InitBulletBob
	bsr		InitPlayerBobs
	bsr		InitEnemyBobs
	bsr		InitShop

	rts

; In:	a6 = address to CUSTOM $dff000
ClearBobs:
	tst.b	IsShopOpenForBusiness(a5)
	bmi.s	.enemyClear

	lea		ShopBob,a0
	bsr		CopyRestoreFromBobPosToScreen

	cmp.b	#2,IsShopOpenForBusiness(a5)	; Try to utilize CPU+fastram during blit
	bne		.shopUpdates
	move.b	#-1,IsShopOpenForBusiness(a5)	; Closed now
	bra		.enemyClear

.shopUpdates
	bsr		ShopUpdates

.enemyClear
	move.w	ENEMY_Count(a5),d7
	beq		.exit

	; Check spawn-in for all enemies
	moveq	#0,d0
	move.b	ENEMY_SpawnCount(a5),d0
	beq.s	.checkDead

	move.b	FrameTick(a5),d0		; Spawn more slowly
	and.b	#7,d0
	bne.s	.checkDead
	subq.b	#1,ENEMY_SpawnCount(a5)
	bne.s	.checkDead

	bsr		SetSpawnedEnemies
.checkDead
	; Check if any enemy reached its end-of-life and can be reused
	subq.w	#1,d7
	move.l	ENEMY_StackPtr(a5),a3
	lea		ENEMY_Stack(a5),a4
.deadEnemyLoop
	move.l	(a4)+,a0

	cmpi.b	#ENEMY_EXPLOSIONCOUNT,hIndex(a0)
	blo.s	.nextCheckDead

	; Enemy done exploding - lifecycle ends here
	bsr     CopyRestoreFromBobPosToScreen

	move.l	-(a3),d0				; Exchange enemystruct-ptrs and POP
	move.l	a0,(a3)					; a0 is now free to reuse
	move.l	d0,-4(a4)

	move.l	a3,ENEMY_StackPtr(a5)

	CLRENEMY	a0
	subq.w	#1,ENEMY_Count(a5)
	beq		.exit
	
.nextCheckDead
	dbf		d7,.deadEnemyLoop

	; Clear bobs and update positions
	move.w	ENEMY_Count(a5),d7
	subq.w	#1,d7
	lea		ENEMY_Stack(a5),a4		; Restore gfx for all enemies
.enemyLoop
	move.l	(a4)+,a0

	tst.l	hSpriteAnimMap(a0)
	beq.s	.next

.clearEnemyBob
	bsr		CopyRestoreFromBobPosToScreen
	bsr		EnemyUpdate				; Try to utilize CPU+fastram during blit
.next
	dbf		d7,.enemyLoop

.exit
	rts

; In:	d0.b = Draws all if #1, or skips player bats if #0 (chill mode special).
; In:	a6 = address to CUSTOM $dff000
DrawBobs:
	; Performance optimization - minimize M68k ABI calling convention
	; movem.l	d3-d7/a2-a4,-(sp)

	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2

	tst.b	d0
	beq		.drawBullets

	tst.b	Player3Enabled(a5)
	bmi.s	.isPlayer2Enabled

	lea		Bat3,a3
	tst.w	hSprBobXCurrentSpeed(a3)
	beq.s	.isPlayer2Enabled

	bsr		CookieBlitToScreen
.isPlayer2Enabled
	tst.b	Player2Enabled(a5)
	bmi.s	.isPlayer1Enabled

	lea		Bat2,a3
	tst.w	hSprBobXCurrentSpeed(a3)
	beq.s	.isPlayer1Enabled

	bsr		CookieBlitToScreen
.isPlayer1Enabled
	tst.b	Player1Enabled(a5)
	bmi.s	.isPlayer0Enabled

	lea		Bat1,a3
	tst.w	hSprBobYCurrentSpeed(a3)
	beq.s	.isPlayer0Enabled

	bsr		CookieBlitToScreen
.isPlayer0Enabled
	tst.b	Player0Enabled(a5)
	bmi.s	.drawBullets

	lea		Bat0,a3
	tst.w	hSprBobYCurrentSpeed(a3)
	beq.s	.drawBullets

	bsr		CookieBlitToScreen


.drawBullets
	; Draw bullets before the others to avoid some blit-thrashing
	tst.b	BulletCount(a5)
	beq		.drawShop

	move.l	GAMESCREEN_BackPtr(a5),a4
	moveq	#BULLET_MAXSLOTS-1,d7
	lea		AllBullets,a0
.bulletLoop					; TODO: consider using free bob stack
	move.l	(a0)+,d0
	beq.s	.nextBulletSlot

	move.l	d0,a3
	bsr		CookieBlitToScreen
.nextBulletSlot
	dbf		d7,.bulletLoop


.drawShop
	tst.b	IsShopOpenForBusiness(a5)
	bmi.s	.drawEnemies

	lea		ShopBob,a3
	bsr		BobAnim

	; Try to utilize CPU+fastram during blit
	lea		AllBalls,a3
	move.l	(a3)+,d4				; a3 = hAllBallsBall0
.shopBallLoop
	move.l	(a3)+,a2
	tst.l	hSprBobXCurrentSpeed(a2)
	beq.s	.nextBallSlot

	bsr		CheckBallToShopCollision
.nextBallSlot
	dbf		d4,.shopBallLoop

	move.l	GAMESCREEN_Ptr(a5),a2	; Restore


.drawEnemies
	move.w	ENEMY_Count(a5),d7
	beq		.exit

	subq.w	#1,d7
	move.l	GAMESCREEN_Ptr(a5),a4
	lea		ENEMY_Stack(a5),a0		; Blit gfx for all enemies
.enemyLoop
	move.l	(a0)+,a3
	tst.l	hSpriteAnimMap(a3)
	beq.s	.doneAnim

	move.l	GAMESCREEN_Ptr(a5),a2	; Restore since last iteration
	bsr		BobAnim

.doneAnim
	; Try to utilize CPU+fastram during blit
	exg		a3,a1

	cmpi.w  #ENEMYSTATE_SPAWNED,hEnemyState(a1)	; Spawning in or out/exploding?
	bne		.noColl

	lea		AllBalls,a3
	move.l	(a3)+,d4				; a3 = hAllBallsBall0
.ballLoop
	move.l	(a3)+,a2

	tst.l	hSprBobXCurrentSpeed(a2)	; Ball stationary/glued?
	beq		.doneBall

	tst.l	hSprBobXCurrentSpeed(a1)	; Enemy stationary?
	beq		.checkSucker

	bsr		CheckBallBoxCollision
	tst.b	d1
	bne		.doneBall
	move.l	a0,-(sp)
	bsr		DoBallEnemyCollision
	move.l	(sp)+,a0
.checkSucker
	bsr		CheckBallSuckerCollision
	tst.b	d1
	bne		.doneBall
	move.l	(a1),d1					; Turn on suctiondevice?
	sub.l	ENEMY_SuckOffGfx(a5),d1
	bne.s	.doSuck
	move.l	ENEMY_SuckOnGfx(a5),(a1)

	move.l	GAMESCREEN_Ptr(a5),a2
	exg		a1,a3
	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	a1,-(sp)
	bsr		CookieBlitToScreen
	move.l	(sp)+,a1
	exg		a1,a3

.doSuck

.doneBall
	dbf		d4,.ballLoop
.noColl

	dbf		d7,.enemyLoop

.exit
	; movem.l	(sp)+,d3-d7/a2-a4
	rts


; In:	a2 = address to blit Destination
; In:	a3 = address to bob struct to be blitted
; In:	a4 = address to background
; In:	a6 = address to CUSTOM $dff000
BobAnim:
	; move.l	d2,-(sp)	; Performance optimization

	; btst.b	#0,FrameTick(a5)	; Swap pixels every other frame
	; bne.s	.exit

	; Extra check
	; tst.b	hIndex(a3)		; Anything to animate?
	; bmi.s	.exit

	moveq	#0,d0
	move.b	hIndex(a3),d0
	move.b	d0,d2					; Save for later
	lsl.w	#3,d0					; Calculate offset
	move.l	hSpriteAnimMap(a3),a1
	add.l	d0,a1

	move.l	(a1)+,(a3)				; hAddress(a3)
	move.l	(a1),hSprBobMaskAddress(a3)

	; Because we cleared bobs earlier we can now cookieblit on top of everything.
	bsr		CookieBlitToScreen

	cmp.b	hLastIndex(a3),d2
	bne.s	.incAnim

	clr.b	hIndex(a3)				; Reset anim
	bra.s	.exit
.incAnim
	addq.b	#1,hIndex(a3)
.exit
	; move.l	(sp)+,d2
	rts


; Simple clearblit routine
; In:	a2 = address to destination screen
; In:	a3 = address to bob struct position to clear
; In:	a6 = address to CUSTOM $dff000
ClearBlitToScreen:
	moveq	#0,d1
	move.w 	hSprBobTopLeftXPos(a3),d1
	sub.w	hBobLeftXOffset(a3),d1
	lsr.w	#3,d1					; In which bitplane byte is this X position?

	move.w	hSprBobTopLeftYPos(a3),d0
	sub.w	hBobTopYOffset(a3),d0
	mulu.w	#(RL_SIZE*4),d0

	add.w	d0,d1					; Offset
	add.l	a2,d1					; Destination

	WAITBLIT

	move.l	#$01000000,BLTCON0(a6)
	move.l	d1,BLTDPTH(a6)
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

	WAITBLIT

	move.l	d0,BLTCON0(a6)			; minterms
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a4,BLTDPTH(a6)
	move.w	d2,BLTAMOD(a6)
	move.w	#0,BLTDMOD(a6)

	move.w	d3,BLTSIZE(a6)

	rts

; Copyblit for vertical resizing.
; In:	a1 = address to source
; In:	a2 = address to destination
; In:	d2 = source modulo
; In:	d3 = blitsize
BatExtendVerticalBlitToActiveBob:
	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a1,BLTAPTH(a6)
	move.l	a2,BLTDPTH(a6)
	move.w	d2,BLTAMOD(a6)
	move.w	#0,BLTDMOD(a6)			; 2 bytes wide - blit 1 word / line

	move.w	d3,BLTSIZE(a6)

	rts

; In:	a1 = address to source
; In:	a2 = address to destination
; In:	a3 = address to last blitmask word
; In:	d1.l = pixels to shift
; In:	d2 = source modulo
; In:	d3 = blitsize
BatExtendHorizontalBlitToActiveBob:
	move.l	d1,d0
	addi.l	#$09f00000,d0			; minterms + X shift

	WAITBLIT

	move.l	d0,BLTCON0(a6)
	move.w	#$ffff,BLTAFWM(a6)
	move.w	(a3),BLTALWM(a6)
	move.l	a1,BLTAPTH(a6)
	move.l	a2,BLTDPTH(a6)
	move.w	d2,BLTAMOD(a6)
	move.w 	#BAT_HORIZONTAL_BYTEWIDTH-4,BLTDMOD(a6)	; blit 2 word / line

	move.w	d3,BLTSIZE(a6)

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

; 	move.l	#(RL_SIZE*4),d2		; TODO dynamic handling of no. of bitplanes
; 	move.w	hSprBobTopLeftYPos(a0),d5
; 	sub.w	hBobTopYOffset(a0),d5
; 	mulu.w	d5,d2
	
; 	add.l	d2,d0
; 	add.l	d1,d0			; Add calculated byte (x pos) to get blit Destination

; 	move.w 	d3,d1
; 	and.l	#$0000000F,d1		; Get remainder for X position
; 	ror.l	#4,d1			; Put remainder in most significant nibble for BLTCONx to do SHIFT

; 	WAITBLIT

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
; In:	a6 = address to CUSTOM $dff000
CopyRestoreGamearea:
        
	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	d1,BLTAMOD(a6)			; Using screen modulo for Source/Destination
	move.w	d1,BLTDMOD(a6)

	move.w	d2,BLTSIZE(a6)

	rts

; In:   a0 = Source
; In:   a1 = Destination to restore
; In:   d1.w = Modulo
; In:   d2.w = Blit size
; In:	d3.l = First- & last-word masks
; In:	a6 = address to CUSTOM $dff000
CopyRestoreGameareaMasked:
        
	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l	d3,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	d1,BLTAMOD(a6)			; Using screen modulo for Source/Destination
	move.w	d1,BLTDMOD(a6)

	move.w	d2,BLTSIZE(a6)

	rts

; In:   a0 = Source
; In:   a1 = Destination to restore
; In:   d0.l = First and Last word mask
; In:   d1.w = Modulo
; In:   d2.w = Blit size
CopyBlit:
	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l	d0,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	d1,BLTAMOD(a6)			; Using screen modulo for Source/Destination
	move.w	d1,BLTDMOD(a6)

	move.w	d2,BLTSIZE(a6)

	rts


; In:   a2 = Destination to fill
; In:	a6 = address to CUSTOM $dff000
; In:   d1.w = Modulo
; In:   d2.w = Blit size
FillBoxBlit:
	WAITBLIT

	move.l	#$01000014,BLTCON0(a6)	; fill carry + Exclusive fill. Use D
	move.l	a2,BLTDPTH(a6)
	move.w	d1,BLTDMOD(a6)

	move.w	d2,BLTSIZE(a6)

	rts


; Simple copyblit routine.
; In:	a0 = address to bob struct marking the area to be restored
; In:	a6 = address to CUSTOM $dff000
CopyRestoreFromBobPosToScreen:
	moveq	#0,d0
	moveq	#0,d1

	move.w 	hSprBobTopLeftXPos(a0),d1
	sub.w	hBobLeftXOffset(a0),d1
	bmi.s	.outOfBounds			; Prevent bad blits
	lsr.w	#3,d1					; In which bitplane byte is this X position?

	move.w	hSprBobTopLeftYPos(a0),d0
	sub.w	hBobTopYOffset(a0),d0
	mulu.w	#(RL_SIZE*4),d0

	add.l	d0,d1					; Offset into gfx is now calculated

	move.l	GAMESCREEN_BackPtr(a5),d0
	add.l	d1,d0					; Add offset to get blit Source

	add.l	GAMESCREEN_Ptr(a5),d1	; Add offset to get blit Destination

	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	d0,BLTAPTH(a6)
	move.l	d1,BLTDPTH(a6)

	move.w	hBobBlitDestModulo(a0),d0
	move.w	d0,BLTAMOD(a6)			; Using screen modulo for Source/Destination
	move.w	d0,BLTDMOD(a6)
	move.w 	hBobBlitSize(a0),BLTSIZE(a6)
	
.outOfBounds
	rts


; Cookie-cut blit routine.
; In:	a2 = address to blit Destination
; In:	a3 = address to bob struct to be blitted
; In:	a4 = address to background
; In:	a6 = address to CUSTOM $dff000
CookieBlitToScreen:
	moveq	#0,d0
	moveq	#0,d1

	move.w 	hSprBobTopLeftXPos(a3),d0
	sub.w	hBobLeftXOffset(a3),d0
	bmi.s	.outOfBounds			; Prevent bad blits

	move.w	d0,d1					; Calculate SHIFT for A and B
	and.w	#$000F,d1				; Get remainder for X position
	add.w	d1,d1
	add.w	d1,d1
	lea		(BltConLookUp,pc,d1),a1

	lsr.w	#3,d0					; In which bitplane byte is this X position?

	move.w	hSprBobTopLeftYPos(a3),d1
	sub.w	hBobTopYOffset(a3),d1
	mulu.w	#(RL_SIZE*4),d1

	add.w	d0,d1					; Add calculated byte (x pos) to get offset

	move.l	a4,d0					; Background gfx
	add.l	d1,d0

	add.l	a2,d1					; Destination

	WAITBLIT

	move.l	(a1),BLTCON0(a6)
	move.l 	hBobBlitMasks(a3),BLTAFWM(a6)
	move.l	hSprBobMaskAddress(a3),BLTAPTH(a6)
	move.l	(a3),BLTBPTH(a6)		; hAddress(a3)
	move.l	d0,BLTCPTH(a6)
	move.l	d1,BLTDPTH(a6)

	move.w	hBobBlitSrcModulo(a3),d0
	move.w	hBobBlitDestModulo(a3),d1
	move.w	d0,BLTAMOD(a6)
	move.w	d0,BLTBMOD(a6)
	move.w	d1,BLTCMOD(a6)
	move.w	d1,BLTDMOD(a6)

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

; Cookie-cut blit routine for brick gfx.
; In:	d0.l = BLTCON0 and BLTCON1
; In:	a2 = address to blit Destination
; In:	a3 = address to brick struct
; In:	a4 = address to background
; In:	a6 = address to CUSTOM $dff000
CookieBlitBrickToScreen:
	WAITBLIT

	move.l	d0,BLTCON0(a6)
	move.l	#$ffff0000,BLTAFWM(a6)
	move.l	BrickMaskPtr(a5),BLTAPTH(a6)
	move.l	BrickGfxPtr(a3),BLTBPTH(a6)
	move.l	a4,BLTCPTH(a6)
	move.l	a2,BLTDPTH(a6)

	moveq	#RL_SIZE-4,d2
	; sub.b	BrickByteWidth(a3),d2	; TODO: How to handle mix of brick- and animbrick-structs?

	move.w	d2,BLTAMOD(a6)			; Same modulo
	move.w	d2,BLTBMOD(a6)
	move.w	d2,BLTCMOD(a6)
	move.w	d2,BLTDMOD(a6)

	move.w	#(64*8*4)+2,BLTSIZE(a6)

	rts