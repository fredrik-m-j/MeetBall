; Relative Y positions and their bounce functions
; See BAT_VERT_DEFAULTHEIGHT
VerticalBatZones:
	dc.l	3,VertBounceVeryExtraUp
	dc.l	8,VertBounceExtraUp
	dc.l	16,VertBounceUp			; Middle of bat
	dc.l	22,VertBounceDown
	dc.l	30,VertBounceExtraDown
	dc.l	0,VertBounceVeryExtraDown
; Extra wide bat -> BAT_VERT_DEFAULTHEIGHT + 12px. From 33 to 45.
VerticalExtBatZones:
	dc.l	4,VertBounceVeryExtraUp
	dc.l	10,VertBounceExtraUp
	dc.l	23,VertBounceUp			; Middle of bat
	dc.l	35,VertBounceDown
	dc.l	41,VertBounceExtraDown
	dc.l	0,VertBounceVeryExtraDown

; Relative X positions and their bounce functions
; See BAT_HORIZ_DEFAULTWIDTH
HorizBatZones:
	dc.l	3,HorizBounceVeryExtraLeft
	dc.l	9,HorizBounceExtraLeft
	dc.l	21,HorizBounceLeft		; Middle of bat
	dc.l	34,HorizBounceRight
	dc.l	40,HorizBounceExtraRight
	dc.l	0,HorizBounceVeryExtraRight
; Extra wide bat -> BAT_HORIZ_DEFAULTWIDTH + 15px. From 41 to 56.
HorizExtBatZones:
	dc.l	4,HorizBounceVeryExtraLeft
	dc.l	11,HorizBounceExtraLeft
	dc.l	29,HorizBounceLeft		; Middle of bat
	dc.l	48,HorizBounceRight
	dc.l	55,HorizBounceExtraRight
	dc.l	0,HorizBounceVeryExtraRight

ResetPlayers:
	lea		Bat0,a0
	clr.l	hSize(a0)
	move.w	#BAT_VERT_DEFAULTHEIGHT,hSprBobHeight(a0)
	move.w	#312,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#DISP_HEIGHT/2-BAT_VERT_DEFAULTHEIGHT/2,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	clr.w	hSprBobYCurrentSpeed(a0)
	move.w	#BatDefaultSpeed,hSprBobYSpeed(a0)
	move.l	#VerticalBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	lea		Bat1,a0
	clr.l	hSize(a0)
	move.w	#BAT_VERT_DEFAULTHEIGHT,hSprBobHeight(a0)
	moveq	#1,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#DISP_HEIGHT/2-BAT_VERT_DEFAULTHEIGHT/2,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	clr.w	hSprBobYCurrentSpeed(a0)
	move.w	#BatDefaultSpeed,hSprBobYSpeed(a0)
	move.l	#VerticalBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	lea		Bat2,a0
	clr.l	hSize(a0)
	move.w	#BAT_HORIZ_DEFAULTWIDTH,hSprBobWidth(a0)
	move.w	#DISP_WIDTH/2-BAT_HORIZ_DEFAULTWIDTH/2,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	#BAT_HORIZ_DEFAULTWIDTH,d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#248,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	clr.w	hSprBobXCurrentSpeed(a0)
	move.w	#BatDefaultSpeed,hSprBobXSpeed(a0)
	; move.w	#32+1,hBobLeftXOffset(a0) ; +1 to get cleaner extended bat
	move.w	#32,hBobLeftXOffset(a0)
	move.w	#20-1,hBobRightXOffset(a0); -1 to get cleaner extended bat
	move.l	#HorizBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	lea		Bat3,a0
	clr.l	hSize(a0)
	move.w	#BAT_HORIZ_DEFAULTWIDTH,hSprBobWidth(a0)
	move.w	#DISP_WIDTH/2-BAT_HORIZ_DEFAULTWIDTH/2,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	#BAT_HORIZ_DEFAULTWIDTH,d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#1,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	clr.w	hSprBobXCurrentSpeed(a0)
	move.w	#BatDefaultSpeed,hSprBobXSpeed(a0)
	move.w	#32+1,hBobLeftXOffset(a0) ; +1 to get cleaner extended bat
	move.w	#20-1,hBobRightXOffset(a0); -1 to get cleaner extended bat
	move.l	#HorizBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	rts

InitPlayerBobs:
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+30,d1		; line 30 - offsets

	lea		Bat0SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.l	#$09f00000,d0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea		Bat0ActiveBob,a4
	bsr		CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+32,d1		; line 30 - offsets

	move.l	d1,Bat0SourceBobMask
	move.l	d1,a0
	move.l	#$09f00000,d0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea		Bat0ActiveBobMask,a4
	bsr		CopyBlitToActiveBob

	lea		Bat0,a1
	move.l	#Bat0ActiveBob,hAddress(a1)
	add.l	#2*4*12,hAddress(a1)
	move.l	#Bat0ActiveBobMask,hSprBobMaskAddress(a1)
	add.l	#2*4*12,hSprBobMaskAddress(a1)
	move.w	#(64*(33+BatVertMargin+BatVertMargin)*4)+1,hBobBlitSize(a1)

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+34,d1		; line 30 - offsets

	lea		Bat1SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea		Bat1ActiveBob,a4
	move.l	#$09f00000,d0
	bsr		CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+36,d1		; line 30 - offsets

	move.l	d1,Bat1SourceBobMask
	move.l	d1,a0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea		Bat1ActiveBobMask,a4
	move.l	#$09f00000,d0
	bsr		CopyBlitToActiveBob

	lea		Bat1,a1
	move.l	#Bat1ActiveBob,hAddress(a1)
	add.l	#2*4*12,hAddress(a1)
	move.l	#Bat1ActiveBobMask,hSprBobMaskAddress(a1)
	add.l	#2*4*12,hSprBobMaskAddress(a1)
	move.w	#(64*(33+BatVertMargin+BatVertMargin)*4)+1,hBobBlitSize(a1)


	move.l	BOBS_BITMAPBASE,d1

	lea		Bat2SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.l	#$19f01000,d0			; +1 to get cleaner extended bat
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea		Bat2ActiveBob,a4
	bsr		CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	add.l	#BatHorizByteWidth,d1

	move.l	d1,Bat2SourceBobMask
	move.l	d1,a0
	move.l	#$19f01000,d0			; +1 to get cleaner extended bat
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea		Bat2ActiveBobMask,a4
	bsr		CopyBlitToActiveBob

	lea		Bat2,a1
	move.l	#Bat2ActiveBob,hAddress(a1)
	move.l	#Bat2ActiveBobMask,hSprBobMaskAddress(a1)


	move.l	BOBS_BITMAPBASE,d1
	addi.l	#ScrBpl*7*4,d1

	lea		Bat3SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.l	#$19f01000,d0			; +1 to get cleaner extended bat
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea		Bat3ActiveBob,a4
	bsr		CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	addi.l	#ScrBpl*7*4+BatHorizByteWidth,d1

	move.l	d1,Bat3SourceBobMask
	move.l	d1,a0
	move.l	#$19f01000,d0			; +1 to get cleaner extended bat
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea		Bat3ActiveBobMask,a4
	bsr		CopyBlitToActiveBob

	lea		Bat3,a1
	move.l	#Bat3ActiveBob,hAddress(a1)
	move.l	#Bat3ActiveBobMask,hSprBobMaskAddress(a1)

	rts


; In:	a6 = address to CUSTOM $dff000
RestorePlayerAreas:
	move.l	d3,-(sp)

	tst.b	Player0Enabled
	bmi.s	.player1
	move.l	#DEFAULT_MASK,d3
	bsr		RestoreBat0Area
.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	move.l	#DEFAULT_MASK,d3
	bsr		RestoreBat1Area
.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	bsr		RestoreBat2Area
.player3
	tst.b	Player3Enabled
	bmi.s	.done
	bsr		RestoreBat3Area
.done
	move.l	(sp)+,d3
	rts

; Out:	d0.w	= Number of players
SetPlayerCount:
	moveq	#0,d0

	tst.b	Player0Enabled
	bmi.s	.player1
	addq.w	#1,d0
.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	addq.w	#1,d0
.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	addq.w	#1,d0
.player3
	tst.b	Player3Enabled
	bmi.s	.done
	addq.w	#1,d0
.done
	move.w	d0,PlayerCount

	rts

; Try to make the score and shop items balanced for the player(s).
BalanceScoring:
	moveq	#0,d0
	move.w	PlayerCount,d0

	; Balance scores for hitting bricks
	lea		RandomBrickStructs,a0	; Adjust points for hitting random bricks
	move.l	#MAX_RANDOMBRICKS,d1
	subq.w	#1,d1
.randomBrickLoop
	move.l	d0,hBrickPoints(a0)
	add.l	#BRICKSTRUCTSIZE,a0
	dbf		d1,.randomBrickLoop

	lea		StaticBrickMap,a0		; Adjust points for hitting static bricks
.staticBrickLoop
	move.l	(a0)+,a1
	cmpa.l	#StaticBrickMapEND,a0
	beq		.enemyScoring

	move.l	d0,hBrickPoints(a1)		; Includes IndestructableGrey, but that gets filtered out in CheckBrickHit
	bra		.staticBrickLoop

.enemyScoring
	lea		EnemyStructs,a0
	move.w	#ENEMIES_DEFAULTMAX,d1
	subq.w	#1,d1
.enemyLoop
	move.l	d0,hPlayerScore(a0)
	add.l	#ENEMY_STRUCTSIZE,a0
	dbf		d1,.enemyLoop

	moveq	#0,d1
	; Balance powerups
	move.l	#PWR_EXTRAPOINTS_BASEVALUE,d1
	mulu.w	d0,d1
	move.l	d1,PwrExtraPointsValue(a5)

	; Balance shop items
	move.l	#ExtraBallBaseValue,d1
	divs.w	d0,d1
	ext.l	d1
	lea		ItemExtraBall,a0
	move.l	d1,hItemValue0(a0)

	move.l	#StealBaseValue,d1
	divu.w	d0,d1
	lea		ItemStealFromPlayer0,a0
	move.l	d1,hItemValue0(a0)
	lea		ItemStealFromPlayer1,a0
	move.l	d1,hItemValue0(a0)
	lea		ItemStealFromPlayer2,a0
	move.l	d1,hItemValue0(a0)
	lea		ItemStealFromPlayer3,a0
	move.l	d1,hItemValue0(a0)

	move.l	#ExtraPtsSmallBaseValue,d1
	mulu.w	d0,d1
	lea		ItemExtraPointsSmall,a0
	move.l	d1,hItemValue0(a0)

	move.l	#ExtraPtsBigBaseValue,d1
	mulu.w	d0,d1
	lea		ItemExtraPointsBig,a0
	move.l	d1,hItemValue0(a0)

	rts

; In:	a6 = address to CUSTOM $dff000
InitialBlitPlayers:
	movem.l	a2-a4,-(sp)

	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2

	tst.b	UserIntentState(a5)
	bgt		.exit

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea		Bat3,a3
	bsr		CookieBlitToScreen

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea		Bat2,a3
	bsr		CookieBlitToScreen

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea		Bat1,a3
	bsr		CookieBlitToScreen

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea		Bat0,a3
	bsr		CookieBlitToScreen

.exit
	movem.l	(sp)+,a2-a4
	rts

; Updates player positions based on joystick or keyboard input.
; Checks for ball release.
PlayerUpdates:
	; Performance optimization - skip M68k ABI calling convention

	moveq	#0,d6

	tst.b	Player0Enabled
	bmi.s	.player1

	lea		CUSTOM+JOY1DAT,a2
	bsr		agdJoyDetectMovement

	lea		Bat0,a4
	bsr		UpdatePlayerVerticalPos
	
	bsr		GunCooldown

	move.b	Player0AfterHitCount,d6
	beq		.checkPlayer0Fire
	subq.b	#1,Player0AfterHitCount

.checkPlayer0Fire
	bsr		CheckPlayer0Fire
	tst.b	d0
	bne.s	.player1
	bsr		CheckBallRelease
	bsr		CheckFireGun
	
	tst.b	d6
	beq		.player1
	bsr		CheckPlayer0Spin
.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	beq.s	.joy0

	move.w	#Player1KeyUp,d0
	move.w	#Player1KeyDown,d1
	bsr		DetectUpDown
	bra.s	.updatePlayer1

.joy0
	lea		CUSTOM+JOY0DAT,a2
	bsr		agdJoyDetectMovement
.updatePlayer1
	lea		Bat1,a4
	bsr		UpdatePlayerVerticalPos

	bsr		GunCooldown

	move.b	Player1AfterHitCount,d6
	beq		.checkPlayer1Fire
	subq.b	#1,Player1AfterHitCount

.checkPlayer1Fire
	bsr		CheckPlayer1Fire
	tst.b	d0
	bne.s	.player2
	bsr		CheckBallRelease
	bsr		CheckFireGun

	tst.b	d6
	beq		.player2
	bsr		CheckPlayer1Spin

.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	beq.s	.joy2

	move.w	#Player2KeyLeft,d0
	move.w	#Player2KeyRight,d1
	bsr		DetectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	lea		Bat2,a4
	bsr		UpdatePlayerHorizontalPos	; Process Joy2

	bsr		GunCooldown

	move.b	Player2AfterHitCount,d6
	beq		.checkPlayer2Fire
	subq.b	#1,Player2AfterHitCount

.checkPlayer2Fire
	bsr		CheckPlayer2Fire
	tst.b	d0
	bne.s	.player3
	bsr		CheckBallRelease
	bsr		CheckFireGun

	tst.b	d6
	beq		.player3
	bsr		CheckPlayer2Spin

.player3
	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	move.w	#Player3KeyLeft,d0
	move.w	#Player3KeyRight,d1
	bsr		DetectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	lea		Bat3,a4
	bsr		UpdatePlayerHorizontalPos	; Process Joy3 in upper nibble

	bsr		GunCooldown

	move.b	Player3AfterHitCount,d6
	beq		.checkPlayer3Fire
	subq.b	#1,Player3AfterHitCount

.checkPlayer3Fire
	bsr		CheckPlayer3Fire
	tst.b	d0
	bne.s	.exit
	bsr		CheckBallRelease
	bsr		CheckFireGun

	tst.b	d6
	beq		.exit
	bsr		CheckPlayer3Spin
.exit
	rts


CpuUpdates:
	IFND	ENABLE_DEBUG_PLAYERS
	lea		Bat0,a4
	bsr		CpuVerticalUpdate

	move.b	Player0AfterHitCount,d6
	beq		.cpuPlayer1
	subq.b	#1,Player0AfterHitCount
	move.b	#JOY_DOWN,d3			; Let player 0 demonstrate spin
	bsr		CheckPlayer0Spin
.cpuPlayer1
	ENDIF

	lea		Bat1,a4
	bsr		CpuVerticalUpdate
	lea		Bat2,a4
	bsr		CpuHorizontalUpdate
	lea		Bat3,a4
	bsr		CpuHorizontalUpdate
	rts

; In:	a4 = Adress to bat struct
CpuVerticalUpdate:
	move.l  #AllBalls+hAllBallsBall0,a0
	move.l	(a0),a0
	move.w	hSprBobTopLeftYPos(a0),d0
	lsr.w	#VC_POW,d0				; Translate to screen coords

	move.w	hSprBobHeight(a4),d1	; Try to catch at middle of bat
	lsr.w	d1
	sub.w	#1,d1
	sub.w	d1,d0

	move.w	d0,hSprBobTopLeftYPos(a4)
	add.w	hSprBobHeight(a4),d0
	move.w	d0,hSprBobBottomRightYPos(a4)

	move.w	#24,d3					; Reached the top?
	sub.w	hSprBobTopLeftYPos(a4),d3
	bpl.s	.setTop

	move.w	#DISP_HEIGHT-24,d3		; Reached the bottom?
	sub.w	hSprBobBottomRightYPos(a4),d3
	bls.s	.setBottom

	bra		.exit

.setTop
	move.w	#24,d1
	move.w	d1,hSprBobTopLeftYPos(a4)
	add.w	hSprBobHeight(a4),d1
	move.w	d1,hSprBobBottomRightYPos(a4)
	bra.s	.exit
.setBottom
	move.w	#DISP_HEIGHT-24,d1
	move.w	d1,hSprBobBottomRightYPos(a4)
	sub.w	hSprBobHeight(a4),d1
	move.w	d1,hSprBobTopLeftYPos(a4)

.exit
	bsr		CheckBallRelease
	bsr		CheckFireGun
	move.w	#4,hSprBobYCurrentSpeed(a4)	; Fake speed to get redraw
	rts

; In:	a4 = Adress to bat struct
CpuHorizontalUpdate:
	move.l  #AllBalls+hAllBallsBall0,a0
	move.l	(a0),a0
	move.w	hSprBobTopLeftXPos(a0),d0
	lsr.w	#VC_POW,d0				; Translate to screen coords

	move.w	hSprBobWidth(a4),d1		; Try to catch at middle of bat
	lsr.w	d1
	sub.w	#1,d1
	sub.w	d1,d0

	move.w	d0,hSprBobTopLeftXPos(a4)
	add.w	hSprBobWidth(a4),d0
	move.w	d0,hSprBobBottomRightXPos(a4)

	move.w	#DISP_WIDTH-32,d1		; Reached the right?
	sub.w	hSprBobBottomRightXPos(a4),d1
	bls.s	.setRight

	move.w	#32,d1
	sub.w	hSprBobTopLeftXPos(a4),d1	; Reached the left?
	bpl.w	.setLeft

	bra		.exit

.setRight
	move.w	#DISP_WIDTH-32,d1
	move.w	d1,hSprBobBottomRightXPos(a4)
	sub.w	hSprBobWidth(a4),d1
	move.w	d1,hSprBobTopLeftXPos(a4)
	bra.s	.exit
.setLeft
	move.w	#32,d1
	move.w	d1,hSprBobTopLeftXPos(a4)
	add.w	hSprBobWidth(a4),d1
	move.w	d1,hSprBobBottomRightXPos(a4)
.exit
	bsr		CheckBallRelease
	bsr		CheckFireGun
	move.w	#4,hSprBobXCurrentSpeed(a4)	; Fake speed to get redraw
	rts


; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat struct
UpdatePlayerVerticalPos:
	cmpi.b	#JOY_NOTHING,d3
	bne		.checkUpDown

	move.w	hSprBobYCurrentSpeed(a4),d0	; Check slowdown
	beq		.exit
	bmi		.neg
	subq.w	#1,d0
	bra		.downConfirmed
.neg
	addq.w	#1,d0
	bra		.upConfirmed

.checkUpDown
	move.w	hSprBobYSpeed(a4),d0
.up	btst.l	#JOY_UP_BIT,d3
	bne		.down

	neg.w	d0

.upConfirmed	
	move.w	#24,d1					; Reached the top?
	sub.w	hSprBobTopLeftYPos(a4),d1
	bpl		.setTop
	
	bra		.update

.down	btst.l	#JOY_DOWN_BIT,d3
	bne		.exit

.downConfirmed
	move.w	#DISP_HEIGHT-24,d1		; Reached the bottom?
	sub.w	hSprBobBottomRightYPos(a4),d1
	bls		.setBottom
.update
	move.w	d0,hSprBobYCurrentSpeed(a4)
	add.w	d0,hSprBobTopLeftYPos(a4)
	add.w	d0,hSprBobBottomRightYPos(a4)

	bsr		CheckVerticalPlayerMove

	bra		.exit

.setTop
	move.w	#24,d1
	move.w	d1,hSprBobTopLeftYPos(a4)
	add.w	hSprBobHeight(a4),d1
	move.w	d1,hSprBobBottomRightYPos(a4)
	bra		.exit
.setBottom
	move.w	#DISP_HEIGHT-24,d1
	move.w	d1,hSprBobBottomRightYPos(a4)
	sub.w	hSprBobHeight(a4),d1
	move.w	d1,hSprBobTopLeftYPos(a4)
.exit
	rts

; Moving bat could have consequences.
; In:	d0.w = Bat current speed
; In:	a4 = Address to bat
CheckVerticalPlayerMove:
	movem.l	d2-d3/d7/a2,-(sp)

	lsl.w	#VC_POW,d0				; Translate to virtual coords
	lea		AllBalls+hAllBallsBall0,a1
.ballLoop
	move.l	(a1)+,d7				; Found ball?
	beq		.exit
	move.l	d7,a0

	tst.l	hSprBobXCurrentSpeed(a0)	; Stationary?
	bne		.ballLoop
	cmpa.l	hPlayerBat(a0),a4		; ... on this bat?
	bne		.ballLoop

	add.w	d0,hSprBobTopLeftYPos(a0)	; ... then follow this bat.
	add.w	d0,hSprBobBottomRightYPos(a0)

	; Ball getting sqashed? Check upper wall first.
	
	moveq	#0,d1
	moveq	#0,d2
	move.l	hSprBobTopLeftXPos(a0),d3	; Keep ball X & Y
	move.w	d3,d2
	swap	d3
	move.w	d3,d1
	bpl		.xOk					; Ball leaving right side of screen?
	move.w	#0,d1
	move.w	#0,d3
.xOk

	lsr.w	#VC_POW,d1				; To screen coord + GAMEAREA column
	lsr.w	#VC_POW,d2				; To screen coord + GAMEAREA row
	add.w	#3,d1					; Middle ball X

	lsr.w	#3,d1					; To GAMEAREA column
	lsr.w	#3,d2					; To GAMEAREA row

	cmp.b	#40-1,d1				; Check upper bound
	bls		.upperBoundOk
	moveq	#40-1,d1
.upperBoundOk
	lea		GAMEAREA_ROW_LOOKUP,a2
	add.b	d2,d2
	add.b	d2,d2
	add.l	d2,a2
	move.l	(a2),a2					; Row found

	add.l	d1,a2					; Byte found

	tst.b	(a2)					; Collision?
	beq		.checkLowerWall

	move.w	#3*VC_FACTOR,d3			; For better looks - adjust Y
	add.w	d3,hSprBobTopLeftYPos(a0)
	add.w	d3,hSprBobBottomRightYPos(a0)

	bra		.moveBallX

.checkLowerWall
	swap	d3						; Restore Y
	move.w	d3,d2
	lsr.w	#VC_POW,d2				; To screen coord
	add.w	#BALL_DIAMETER,d2		; Bottom ball
	lsr.w	#3,d2					; To GAMEAREA row

	lea		GAMEAREA_ROW_LOOKUP,a2
	add.b	d2,d2
	add.b	d2,d2
	add.l	d2,a2
	move.l	(a2),a2					; Row found

	add.l	d1,a2					; Byte found

	tst.b	(a2)					; Collision?
	beq		.ballLoop


	move.w	#3*VC_FACTOR,d3			; For better looks - adjust Y
	sub.w	d3,hSprBobTopLeftYPos(a0)
	sub.w	d3,hSprBobBottomRightYPos(a0)

.moveBallX
	cmpa.l	#Bat0,a4				; Set new ball X
	bne		.player1
	move.w	#305,d3
	bra		.moveBallAtLower
.player1
	move.w	#8,d3
.moveBallAtLower
	lsl.w	#VC_POW,d3				; Translate to virtual coords
	move.w	d3,hSprBobTopLeftXPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,d3
	move.w	d3,hSprBobBottomRightXPos(a0)

	bra		.ballLoop
.exit
	movem.l	(sp)+,d2-d3/d7/a2
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat
UpdatePlayerHorizontalPos:
	cmpi.b	#JOY_NOTHING,d3
	bne		.something

	move.w	hSprBobXCurrentSpeed(a4),d0	; Check slowdown
	beq		.exit
	bmi		.neg
	subq.w	#1,d0
	bra		.rightConfirmed
.neg
	addq.w	#1,d0
	bra		.leftConfirmed

.something
	move.b	d3,d7
	and.b	#$0f,d7

	move.w	hSprBobXSpeed(a4),d0
.right	btst.l	#JOY_RIGHT_BIT,d7
	bne		.left

.rightConfirmed
	move.w	#DISP_WIDTH-32,d1		; Reached the right?
	sub.w	hSprBobBottomRightXPos(a4),d1
	bls		.setRight
	bra		.update
	
.left  	btst.l	#JOY_LEFT_BIT,d7
	bne.s	.exit

	neg.w	d0

.leftConfirmed
	move.w	#32,d1
	sub.w	hSprBobTopLeftXPos(a4),d1	; Reached the left?
	bpl		.setLeft

.update
	move.w	d0,hSprBobXCurrentSpeed(a4)
	add.w	d0,hSprBobTopLeftXPos(a4)
	add.w	d0,hSprBobBottomRightXPos(a4)

	bsr		CheckHorizontalPlayerMove

	bra		.exit

.setRight
	move.w	#DISP_WIDTH-32,d1
	move.w	d1,hSprBobBottomRightXPos(a4)
	sub.w	hSprBobWidth(a4),d1
	move.w	d1,hSprBobTopLeftXPos(a4)
	bra		.exit
.setLeft
	move.w	#32,d1
	move.w	d1,hSprBobTopLeftXPos(a4)
	add.w	hSprBobWidth(a4),d1
	move.w	d1,hSprBobBottomRightXPos(a4)

.exit
	rts


; Moving bat could have consequences.
; In:	d0.w = Bat current speed
; In:	a4 = Address to bat
CheckHorizontalPlayerMove:
	movem.l	d2-d3/d7/a2,-(sp)

	lsl.w	#VC_POW,d0				; Translate to virtual coords
	lea		AllBalls+hAllBallsBall0,a1
.ballLoop
	move.l	(a1)+,d7				; Found ball?
	beq		.exit
	move.l	d7,a0

	tst.l	hSprBobXCurrentSpeed(a0)	; Stationary?
	bne		.ballLoop
	cmpa.l	hPlayerBat(a0),a4		; ... on this bat?
	bne		.ballLoop

	add.w	d0,hSprBobTopLeftXPos(a0)	; ... then follow this bat.
	add.w	d0,hSprBobBottomRightXPos(a0)


	; Ball getting sqashed? Check left wall first.
	
	moveq	#0,d1
	moveq	#0,d2
	move.l	hSprBobTopLeftXPos(a0),d3	; Keep ball X & Y
	move.w	d3,d2
	bpl		.yOk					; Ball leaving top of screen?
	move.w	#0,d2
	move.w	#0,d3
.yOk
	swap	d3
	move.w	d3,d1

	lsr.w	#VC_POW,d1				; To screen coord + GAMEAREA column
	lsr.w	#VC_POW,d2				; To screen coord + GAMEAREA row
	add.w	#3,d2					; Middle ball Y

	lsr.w	#3,d1					; To GAMEAREA column
	lsr.w	#3,d2					; To GAMEAREA row

	cmp.b	#$1f,d2					; Check upper bound
	bls		.upperBoundOk
	moveq	#$1f,d2
.upperBoundOk
	lea		GAMEAREA_ROW_LOOKUP,a2
	add.b	d2,d2
	add.b	d2,d2
	add.l	d2,a2
	move.l	(a2),a2					; Row found

	add.l	d1,a2					; Byte found

	tst.b	(a2)					; Collision?
	beq		.checkRightWall

	move.w	#2*VC_FACTOR,d3			; For better looks - adjust X
	add.w	d3,hSprBobTopLeftXPos(a0)
	add.w	d3,hSprBobBottomRightXPos(a0)

	bra		.moveBallY

.checkRightWall
	sub.l	d1,a2					; Still on same row

	move.w	d3,d1					; Restore X
	lsr.w	#VC_POW,d1				; To screen coord
	add.w	#BALL_DIAMETER,d1		; Right side of ball
	lsr.w	#3,d1					; To GAMEAREA row

	add.l	d1,a2					; Byte found

	tst.b	(a2)					; Collision?
	beq		.ballLoop


	move.w	#4*VC_FACTOR,d3			; For better looks - adjust X
	sub.w	d3,hSprBobTopLeftXPos(a0)
	sub.w	d3,hSprBobBottomRightXPos(a0)

.moveBallY
	cmpa.l	#Bat2,a4				; Set new ball Y
	bne		.player3
	move.w	#255-8-7,d3
	bra		.moveBallAtUpper
.player3
	move.w	#8,d3
.moveBallAtUpper
	lsl.w	#VC_POW,d3				; Translate to virtual coords
	move.w	d3,hSprBobTopLeftYPos(a0)
	add.w	#BALL_DIAMETER*VC_FACTOR,d3
	move.w	d3,hSprBobBottomRightYPos(a0)

	bra		.ballLoop
.exit
	movem.l	(sp)+,d2-d3/d7/a2
	rts


; In:	a4 = Adress to bat struct
CheckBallRelease:
	move.l	d7,-(sp)

	lea		AllBalls+hAllBallsBall0,a1
.glueBallLoop
	move.l	(a1)+,d7				; Found ball?
	beq.s	.exit
	move.l	d7,a0

	tst.l	hSprBobXCurrentSpeed(a0)	; Stationary?
	bne.s	.glueBallLoop
	cmpa.l	hPlayerBat(a0),a4		; ... on this bat?
	bne.s	.glueBallLoop

	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)	; ... then release it.
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)

	bra.s	.glueBallLoop
.exit
	move.l	(sp)+,d7
	rts

; In:	a4 = Adress to bat struct
GunCooldown:
	tst.w	hBatGunCooldown(a4)
	beq.s	.exit
	subq.w	#1,hBatGunCooldown(a4)
.exit
	rts

; In:	a4 = Adress to bat struct
CheckFireGun:
	move.w	hBatEffects(a4),d0
	and.b	#BatGunEffect,d0
	beq.s	.exit

	tst.w	hBatGunCooldown(a4)
	bne.s	.exit

	bsr		AddBullet

	lea		SFX_SHOT_STRUCT,a0
	bsr		PlaySample
.exit
	rts

; Draws current game level on gamescreen & backing screen
DrawLevelCounter:
	move.l	a2,-(sp)

	lea		THISLEVEL_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	move.w	LevelCount,d0
	bsr		Binary2Decimal
	subq.l	#1,a1					; Overwrite nulltermination
	COPYSTR	a0,a1

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l   #(ScrBpl*17*4)+1+ScrBpl,a2
	bsr		DrawStringBufferSimple

	move.l 	GAMESCREEN_BackPtr(a5),a2
	add.l   #(ScrBpl*17*4)+1+ScrBpl,a2
	bsr		DrawStringBufferSimple

	move.l	(sp)+,a2
	rts

; Out:	d0.b = Zero if firebutton pressed, JOY_NOTHING if not.
CheckAllPossibleFirebuttons:
	move.b	#JOY_NOTHING,d0

	tst.b	KEYARRAY+KEY_RIGHTSHIFT	; Player 0
	bne		.fire
	btst	#7,CIAA					; Joy1 button0 pressed?
	beq		.fire

	tst.b	KEYARRAY+Player1KeyFire	; Player 1
	bne		.fire
	btst	#6,CIAA					; Joy0 button0 pressed?
	beq		.fire

	tst.b	KEYARRAY+Player2KeyFire	; Player 2
	bne		.fire
	btst.b	#JOY2_FIRE0_BIT,CIAB+ciapra
	beq		.fire

	tst.b	KEYARRAY+Player3KeyFire
	bne		.fire
	btst.b	#JOY3_FIRE0_BIT,CIAB+ciapra
	beq		.fire

	bra		.exit
.fire
	moveq	#0,d0
.exit
	rts

; Awaits configured player buttons.
AwaitAllFirebuttonsReleased:
.l1
	bsr		CheckFirebuttons		; Await firebutton release
	tst.b	d0
	beq.s	.l1
	rts

; Checks configured player buttons.
; Out:	d0.b = Zero if firebutton pressed, JOY_NOTHING if not.
CheckFirebuttons:
	bsr		CheckPlayer0Fire
	tst.b	d0
	beq.s	.done
	bsr		CheckPlayer1Fire
	tst.b	d0
	beq.s	.done
	bsr		CheckPlayer2Fire
	tst.b	d0
	beq.s	.done
	bsr		CheckPlayer3Fire
.done
	rts

; Checks configured player button.
; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer0Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player0Enabled
	bmi.s	.exit
	btst	#7,CIAA					; Joy1 button0 pressed?
	bne.s	.exit

.player0Fire
	moveq	#0,d0
.exit
	rts

; Checks configured player button.
; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer1Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player1Enabled
	bmi.s	.exit
	beq.s	.joy0

	tst.b	KEYARRAY+Player1KeyFire
	beq		.exit
	bra.s	.player1Fire
.joy0
	btst	#6,CIAA					; Joy0 button0 pressed?
	bne.s	.exit

.player1Fire
	moveq	#0,d0
.exit
	rts

; Checks configured player button.
; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer2Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player2Enabled
	bmi.s	.exit
	beq.s	.joy2
 
	tst.b	KEYARRAY+Player2KeyFire
	beq		.exit
	bra.s	.player2Fire
.joy2
	btst.b	#JOY2_FIRE0_BIT,CIAB+ciapra
	bne.s	.exit

.player2Fire
	moveq	#0,d0
.exit
	rts

; Checks configured player button.
; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer3Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	tst.b	KEYARRAY+Player3KeyFire
	beq		.exit
	bra.s	.player3Fire
.joy3
	btst.b	#JOY3_FIRE0_BIT,CIAB+ciapra
	bne.s	.exit

.player3Fire
	moveq	#0,d0
.exit
	rts

; In:	d3 = Joystick direction bits
; In:	d6.b = Framecount for spin - THRASHED
; In:	a4 = Adress to bat struct
CheckPlayer0Spin:
	cmpi.b	#JOY_NOTHING,d3
	beq		.done

	lsr.b	#2,d6
	move.l	Player0AfterHitBall,a0	; a0 is a ball that bounced off of Bat0

.up	btst.l	#JOY_UP_BIT,d3
	bne		.down

	move.w	hSprBobTopLeftXPos(a0),d2	; Spin ball upwards
	lsr.w	#VC_POW,d2
	add.w	#BALL_DIAMETER/2,d2
	move.w	hSprBobBottomRightYPos(a0),d3	; "Grab" ball from bottom
	lsr.w	#VC_POW,d3

	sub.w	d6,hSprBobYCurrentSpeed(a0)
	bmi		.ballUpJoyUp
	sub.w	d6,hSprBobXCurrentSpeed(a0)
	bra		.saveLineCoords
.ballUpJoyUp
	add.w	d6,hSprBobXCurrentSpeed(a0)
	bra		.saveLineCoords

.down
	move.w	hSprBobTopLeftXPos(a0),d2	; Spin ball downwards
	lsr.w	#VC_POW,d2
	add.w	#BALL_DIAMETER/2,d2
	move.w	hSprBobTopLeftYPos(a0),d3	; "Grab" ball from top
	lsr.w	#VC_POW,d3

	add.w	d6,hSprBobYCurrentSpeed(a0)
	bmi		.ballUpJoyDown
	add.w	d6,hSprBobXCurrentSpeed(a0)
	bra		.saveLineCoords
.ballUpJoyDown
	sub.w	d6,hSprBobXCurrentSpeed(a0)

.saveLineCoords
	move.w	hSprBobTopLeftXPos(a4),d0	; Let "grabpoint" be middle of bat
	move.w	hSprBobHeight(a4),d1
	lsr.w	d1						; Half of bat-height
	add.w	hSprBobTopLeftYPos(a4),d1

	move.w	d0,SpinBat0X
	move.w	d1,SpinBat0Y
	move.w	d2,SpinBat0BallX
	move.w	d3,SpinBat0BallY

.done
	rts

; In:	d3.b = Joystick direction bits
; In:	d6.b = Framecount for spin - THRASHED
; In:	a4 = Adress to bat struct
CheckPlayer1Spin:
	cmpi.b	#JOY_NOTHING,d3
	beq		.done

	lsr.b	#2,d6
	move.l	Player1AfterHitBall,a0	; a0 is a ball that bounced off of Bat1

.up	btst.l	#JOY_UP_BIT,d3
	bne		.down

	move.w	hSprBobBottomRightXPos(a0),d2	; Spin ball upwards
	lsr.w	#VC_POW,d2
	sub.w	#BALL_DIAMETER/2,d2
	bpl		.validUpX				; Check for negative value
	moveq	#0,d2
.validUpX
	move.w	hSprBobBottomRightYPos(a0),d3	; "Grab" ball from bottom
	lsr.w	#VC_POW,d3

	sub.w	d6,hSprBobYCurrentSpeed(a0)
	bmi		.ballUpJoyUp
	add.w	d6,hSprBobXCurrentSpeed(a0)
	bra		.saveLineCoords
.ballUpJoyUp
	sub.w	d6,hSprBobXCurrentSpeed(a0)
	bra		.saveLineCoords

.down
	move.w	hSprBobBottomRightXPos(a0),d2	; Spin ball downwards
	lsr.w	#VC_POW,d2
	sub.w	#BALL_DIAMETER/2,d2
	bpl		.validDownX				; Check for negative value
	moveq	#0,d2
.validDownX
	move.w	hSprBobTopLeftYPos(a0),d3	; "Grab" ball from top
	lsr.w	#VC_POW,d3

	add.w	d6,hSprBobYCurrentSpeed(a0)
	bmi		.ballUpJoyDown
	sub.w	d6,hSprBobXCurrentSpeed(a0)
	bra		.saveLineCoords
.ballUpJoyDown
	add.w	d6,hSprBobXCurrentSpeed(a0)

.saveLineCoords
	move.w	hSprBobBottomRightXPos(a4),d0	; Let "grabpoint" be middle of bat
	move.w	hSprBobHeight(a4),d1
	lsr.w	d1						; Half of bat-height
	add.w	hSprBobTopLeftYPos(a4),d1

	move.w	d0,SpinBat1X
	move.w	d1,SpinBat1Y
	move.w	d2,SpinBat1BallX
	move.w	d3,SpinBat1BallY

.done
	rts

; In:	d3 = Joystick direction bits
; In:	d6.b = Framecount for spin - THRASHED
; In:	a4 = Adress to bat struct
CheckPlayer2Spin:
	cmpi.b	#JOY_NOTHING,d3
	beq		.done

	lsr.b	#2,d6
	move.l	Player2AfterHitBall,a0	; a0 is a ball that bounced off of Bat2

.left	btst.l	#JOY_LEFT_BIT,d3
	bne		.right

	move.w	hSprBobBottomRightXPos(a0),d2	; "Grab" ball from right side
	lsr.w	#VC_POW,d2
	move.w	hSprBobBottomRightYPos(a0),d3	; Spin ball leftwards
	lsr.w	#VC_POW,d3
	sub.w	#BALL_DIAMETER/2,d3

	sub.w	d6,hSprBobXCurrentSpeed(a0)
	bmi		.ballLeftJoyLeft
	sub.w	d6,hSprBobYCurrentSpeed(a0)
	bra		.saveLineCoords
.ballLeftJoyLeft
	add.w	d6,hSprBobYCurrentSpeed(a0)
	bra		.saveLineCoords

.right
	move.w	hSprBobTopLeftXPos(a0),d2	; "Grab" ball from left side
	lsr.w	#VC_POW,d2
	move.w	hSprBobBottomRightYPos(a0),d3	; Spin ball rightwards
	lsr.w	#VC_POW,d3
	sub.w	#BALL_DIAMETER/2,d3

	add.w	d6,hSprBobXCurrentSpeed(a0)
	bmi		.ballLeftJoyRight
	add.w	d6,hSprBobYCurrentSpeed(a0)
	bra		.saveLineCoords
.ballLeftJoyRight
	sub.w	d6,hSprBobYCurrentSpeed(a0)

.saveLineCoords
	move.w	hSprBobWidth(a4),d0		; Let "grabpoint" be middle of bat
	lsr.w	d0						; Half of bat-width
	add.w	hSprBobTopLeftXPos(a4),d0
	move.w	hSprBobTopLeftYPos(a4),d1

	move.w	d0,SpinBat2X
	move.w	d1,SpinBat2Y
	move.w	d2,SpinBat2BallX
	move.w	d3,SpinBat2BallY

.done
	rts

; In:	d3 = Joystick direction bits
; In:	d6.b = Framecount for spin - THRASHED
; In:	a4 = Adress to bat struct
CheckPlayer3Spin:
	cmpi.b	#JOY_NOTHING,d3
	beq		.done

	lsr.b	#2,d6
	move.l	Player3AfterHitBall,a0	; a0 is a ball that bounced off of Bat3

.left	btst.l	#JOY_LEFT_BIT,d3
	bne		.right

	move.w	hSprBobBottomRightXPos(a0),d2	; "Grab" ball from right side
	lsr.w	#VC_POW,d2
	move.w	hSprBobBottomRightYPos(a0),d3	; Spin ball leftwards
	lsr.w	#VC_POW,d3
	sub.w	#BALL_DIAMETER/2,d3
	bpl		.validLeftY				; Check for negative value
	moveq	#0,d3
.validLeftY

	sub.w	d6,hSprBobXCurrentSpeed(a0)
	bmi		.ballLeftJoyLeft
	add.w	d6,hSprBobYCurrentSpeed(a0)
	bra		.saveLineCoords
.ballLeftJoyLeft
	sub.w	d6,hSprBobYCurrentSpeed(a0)
	bra		.saveLineCoords

.right
	move.w	hSprBobTopLeftXPos(a0),d2	; "Grab" ball from left side
	lsr.w	#VC_POW,d2
	move.w	hSprBobBottomRightYPos(a0),d3	; Spin ball rightwards
	lsr.w	#VC_POW,d3
	sub.w	#BALL_DIAMETER/2,d3
	bpl		.validRightY			; Check for negative value
	moveq	#0,d3
.validRightY
	
	add.w	d6,hSprBobXCurrentSpeed(a0)
	bmi		.ballLeftJoyRight
	sub.w	d6,hSprBobYCurrentSpeed(a0)
	bra		.saveLineCoords
.ballLeftJoyRight
	add.w	d6,hSprBobYCurrentSpeed(a0)

.saveLineCoords
	move.w	hSprBobWidth(a4),d0		; Let "grabpoint" be middle of bat
	lsr.w	d0						; Half of bat-width
	add.w	hSprBobTopLeftXPos(a4),d0
	move.w	hSprBobBottomRightYPos(a4),d1

	move.w	d0,SpinBat3X
	move.w	d1,SpinBat3Y
	move.w	d2,SpinBat3BallX
	move.w	d3,SpinBat3BallY

.done
	rts

; Clear previously drawn line using XOR.
; In:	a0 = Address to line coordinates between bat and ball
; In:	a6 = address to CUSTOM $dff000
SpinlineXOr:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3

	move.l	a0,-(sp)				; Preserve for easy clearing of coords later

	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	move.w	(a0),d3

	move.l	GAMESCREEN_Ptr(a5),a0
	add.l	#ScrBpl,a0
	move.l	#ScrBpl*4,d4			; Bitplane width
	bsr		SimplelineXor

	move.l	(sp)+,a0

	rts