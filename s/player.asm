; Relative Y positions and their bounce functions
VerticalBatZones:
	dc.l	4,VertBounceVeryExtraUp
	dc.l	9,VertBounceExtraUp
	dc.l	14,VertBounceUp
	dc.l	18,VertBounceNeutral
	dc.l	23,VertBounceDown
	dc.l	28,VertBounceExtraDown
	dc.l	0,VertBounceVeryExtraDown
; Extra wide bat
VerticalExtBatZones:
	dc.l	4,VertBounceVeryExtraUp
	dc.l	11,VertBounceExtraUp
	dc.l	21,VertBounceUp
	dc.l	23,VertBounceNeutral
	dc.l	31,VertBounceDown
	dc.l	42,VertBounceExtraDown
	dc.l	0,VertBounceVeryExtraDown
; Relative X positions and their bounce functions
HorizBatZones:
	dc.l	5,HorizBounceVeryExtraLeft
	dc.l	10,HorizBounceExtraLeft
	dc.l	18,HorizBounceLeft
	dc.l	22,HorizBounceNeutral
	dc.l	30,HorizBounceRight
	dc.l	35,HorizBounceExtraRight
	dc.l	0,HorizBounceVeryExtraRight
; Extra wide bat
HorizExtBatZones:
	dc.l	5,HorizBounceVeryExtraLeft
	dc.l	13,HorizBounceExtraLeft
	dc.l	26,HorizBounceLeft
	dc.l	28,HorizBounceNeutral
	dc.l	38,HorizBounceRight
	dc.l	50,HorizBounceExtraRight
	dc.l	0,HorizBounceVeryExtraRight

ResetPlayers:
	lea	Bat0,a0
	clr.l	hSize(a0)
	move.w	#33,hSprBobHeight(a0)
	move.w	#311,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#122,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#BatDefaultSpeed,hSprBobYSpeed(a0)
	move.l	#VerticalBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	lea	Bat1,a0
	clr.l	hSize(a0)
	move.w	#33,hSprBobHeight(a0)
	moveq	#0,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#122,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#BatDefaultSpeed,hSprBobYSpeed(a0)
	move.l	#VerticalBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	lea	Bat2,a0
	clr.l	hSize(a0)
	move.w	#41,hSprBobWidth(a0)
	move.w	#140,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#248,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#BatDefaultSpeed,hSprBobXSpeed(a0)
	move.w	#32,hBobLeftXOffset(a0)
	move.w	#20,hBobRightXOffset(a0)
	move.l	#HorizBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	lea	Bat3,a0
	clr.l	hSize(a0)
	move.w	#41,hSprBobWidth(a0)
	move.w	#140,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#1,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#BatDefaultSpeed,hSprBobXSpeed(a0)
	move.w	#32,hBobLeftXOffset(a0)
	move.w	#20,hBobRightXOffset(a0)
	move.l	#HorizBatZones,hFunctionlistAddress(a0)
	clr.w	hBatEffects(a0)
	clr.w	hBatGunCooldown(a0)

	rts

InitPlayerBobs:
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+30,d1		; line 30 - offsets

	lea	Bat0SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea	Bat0ActiveBob,a4
	bsr	CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+32,d1		; line 30 - offsets

	move.l	d1,Bat0SourceBobMask
	move.l	d1,a0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea	Bat0ActiveBobMask,a4
	bsr	CopyBlitToActiveBob

	lea	Bat0,a1
	move.l	#Bat0ActiveBob,hAddress(a1)
	add.l	#2*4*12,hAddress(a1)
	move.l	#Bat0ActiveBobMask,hSprBobMaskAddress(a1)
	add.l	#2*4*12,hSprBobMaskAddress(a1)
	move.w	#(64*(33+BatVertMargin+BatVertMargin)*4)+1,hBobBlitSize(a1)

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+34,d1		; line 30 - offsets

	lea	Bat1SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea	Bat1ActiveBob,a4
	bsr	CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(29-BatVertMargin-12)*4)+36,d1		; line 30 - offsets

	move.l	d1,Bat1SourceBobMask
	move.l	d1,a0
	move.w	#BatVertScreenModulo,d2
	move.w	#VerticalBatBlitSize,d3
	lea	Bat1ActiveBobMask,a4
	bsr	CopyBlitToActiveBob

	lea	Bat1,a1
	move.l	#Bat1ActiveBob,hAddress(a1)
	add.l	#2*4*12,hAddress(a1)
	move.l	#Bat1ActiveBobMask,hSprBobMaskAddress(a1)
	add.l	#2*4*12,hSprBobMaskAddress(a1)
	move.w	#(64*(33+BatVertMargin+BatVertMargin)*4)+1,hBobBlitSize(a1)


	move.l	BOBS_BITMAPBASE,d1

	lea	Bat2SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea	Bat2ActiveBob,a4
	bsr	CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	add.l	#BatHorizByteWidth,d1

	move.l	d1,Bat2SourceBobMask
	move.l	d1,a0
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea	Bat2ActiveBobMask,a4
	bsr	CopyBlitToActiveBob

	lea	Bat2,a1
	move.l	#Bat2ActiveBob,hAddress(a1)
	move.l	#Bat2ActiveBobMask,hSprBobMaskAddress(a1)


	move.l	BOBS_BITMAPBASE,d1
	addi.l	#ScrBpl*7*4,d1					; line 7

	lea	Bat3SourceBob,a0
	move.l	d1,(a0)
	move.l	d1,a0
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea	Bat3ActiveBob,a4
	bsr	CopyBlitToActiveBob

	move.l	BOBS_BITMAPBASE,d1
	addi.l	#ScrBpl*7*4+BatHorizByteWidth,d1		; line 7

	move.l	d1,Bat3SourceBobMask
	move.l	d1,a0
	move.w	#BatHorizScreenModulo,d2
	move.w	#HorizontalBatBlitSize,d3
	lea	Bat3ActiveBobMask,a4
	bsr	CopyBlitToActiveBob

	lea	Bat3,a1
	move.l	#Bat3ActiveBob,hAddress(a1)
	move.l	#Bat3ActiveBobMask,hSprBobMaskAddress(a1)

	rts


RestorePlayerAreas:
	tst.b	Player0Enabled
	bmi.s	.player1
	bsr	RestoreBat0Area
.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	bsr	RestoreBat1Area
.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	bsr	RestoreBat2Area
.player3
	tst.b	Player3Enabled
	bmi.s	.done
	bsr	RestoreBat3Area
.done
	rts


InitialBlitPlayers:
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a0
	bsr     CookieBlitToScreen

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea	Bat2,a0
	bsr     CookieBlitToScreen

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea	Bat1,a0
	bsr     CookieBlitToScreen

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea	Bat0,a0
	bsr     CookieBlitToScreen

.exit
	rts

; Updates player positions based on joystick or keyboard input.
; Checks for ball release.
PlayerUpdates:
	tst.b	Player0Enabled
	bmi.s	.player1

	lea	CUSTOM+JOY1DAT,a5
	bsr	agdJoyDetectMovement

	lea	Bat0,a4
	bsr	UpdatePlayerVerticalPos
	
	bsr	GunCooldown

	bsr	CheckPlayer0Fire
	tst.b	d0
	bne.s	.player1
	bsr	CheckBallRelease
	bsr	CheckFireGun

.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	beq.s	.joy0

	move.w	#Player1KeyUp,d0
	move.w	#Player1KeyDown,d1
	bsr	detectUpDown
	bra.s	.updatePlayer1

.joy0
	lea	CUSTOM+JOY0DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer1
	lea	Bat1,a4
	bsr	UpdatePlayerVerticalPos

	bsr	GunCooldown

	bsr	CheckPlayer1Fire
	tst.b	d0
	bne.s	.player2
	bsr	CheckBallRelease
	bsr	CheckFireGun

.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	beq.s	.joy2

	move.w	#Player2KeyLeft,d0
	move.w	#Player2KeyRight,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	lea	Bat2,a4
	bsr	UpdatePlayerHorizontalPos	; Process Joy2

	bsr	GunCooldown

	bsr	CheckPlayer2Fire
	tst.b	d0
	bne.s	.player3
	bsr	CheckBallRelease
	bsr	CheckFireGun

.player3
	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	move.w	#Player3KeyLeft,d0
	move.w	#Player3KeyRight,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	lea	Bat3,a4
	bsr	UpdatePlayerHorizontalPos	; Process Joy3 in upper nibble

	bsr	GunCooldown

	bsr	CheckPlayer3Fire
	tst.b	d0
	bne.s	.exit
	bsr	CheckBallRelease
	bsr	CheckFireGun
.exit
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat struct
UpdatePlayerVerticalPos:
	cmpi.b	#JOY_NOTHING,d3
	bne.s	.checkUpDown

	move.w	hSprBobYCurrentSpeed(a4),d0	; Check slowdown
	beq.w	.exit
	bmi.s	.neg
	subq.w	#1,d0
	bra.s	.downConfirmed
.neg
	addq.w	#1,d0
	bra.s	.upConfirmed

.checkUpDown
	move.w	hSprBobYSpeed(a4),d0
.up	btst.l	#JOY_UP_BIT,d3
	bne.s	.down

	neg.w	d0

.upConfirmed	
	move.w	#24,d1				; Reached the top?
	sub.w	hSprBobTopLeftYPos(a4),d1
	bpl.s	.setTop
	
	bra.s	.update

.down	btst.l	#JOY_DOWN_BIT,d3
	bne.s	.exit

.downConfirmed
	move.w	#DISP_HEIGHT-24,d1		; Reached the bottom?
	sub.w	hSprBobBottomRightYPos(a4),d1
	bls.s	.setBottom
.update
	move.w	d0,hSprBobYCurrentSpeed(a4)
	add.w	d0,hSprBobTopLeftYPos(a4)
	add.w	d0,hSprBobBottomRightYPos(a4)

	lea     AllBalls+4,a1
.glueBallLoop
        move.l  (a1)+,d7		        ; Found ball?
	beq.w   .exit
	move.l	d7,a0

	tst.l   hSprBobXCurrentSpeed(a0)        ; Stationary?
	bne.s	.glueBallLoop
	cmpa.l	hPlayerBat(a0),a4		; ... on this bat?
	bne.s	.glueBallLoop

	add.w	d0,hSprBobTopLeftYPos(a0)	; ... then follow this bat.
	add.w	d0,hSprBobBottomRightYPos(a0)

	bra.s	.glueBallLoop

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
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat
UpdatePlayerHorizontalPos:
	move.b	d3,d7
	and.b	#$0f,d7
	bne.s	.checkLeftRight

	move.w	hSprBobXCurrentSpeed(a4),d0	; Check slowdown
	beq.w	.exit
	bmi.s	.neg
	subq.w	#1,d0
	bra.s	.rightConfirmed
.neg
	addq.w	#1,d0
	bra.s	.leftConfirmed

.checkLeftRight
	move.w	hSprBobXSpeed(a4),d0
.right	btst.l	#JOY_RIGHT_BIT,d7
	bne.s	.left

.rightConfirmed
	move.w	#DISP_WIDTH-32,d1		; Reached the right?
	sub.w	hSprBobBottomRightXPos(a4),d1
	bls.s	.setRight
	bra.s	.update
	
.left  	btst.l	#JOY_LEFT_BIT,d7
	bne.s	.exit

	neg.w	d0

.leftConfirmed
	move.w	#32,d1
	sub.w	hSprBobTopLeftXPos(a4),d1	; Reached the left?
	bpl.w	.setLeft

.update
	move.w	d0,hSprBobXCurrentSpeed(a4)
	add.w	d0,hSprBobTopLeftXPos(a4)
	add.w	d0,hSprBobBottomRightXPos(a4)

	lea     AllBalls+4,a1
.glueBallLoop
        move.l  (a1)+,d7		        ; Found ball?
	beq.w   .exit
	move.l	d7,a0

	tst.l   hSprBobXCurrentSpeed(a0)        ; Stationary?
	bne.s	.glueBallLoop
	cmpa.l	hPlayerBat(a0),a4		; ... on this bat?
	bne.s	.glueBallLoop

	add.w	d0,hSprBobTopLeftXPos(a0)	; ... then follow this bat.
	add.w	d0,hSprBobBottomRightXPos(a0)

	bra.s	.glueBallLoop

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
	rts

; In:	a4 = Adress to bat struct
CheckBallRelease:
	lea     AllBalls+4,a1
.glueBallLoop
        move.l  (a1)+,d7		        ; Found ball?
	beq.s   .exit
	move.l	d7,a0

	tst.l   hSprBobXCurrentSpeed(a0)        ; Stationary?
	bne.s	.glueBallLoop
	cmpa.l	hPlayerBat(a0),a4		; ... on this bat?
	bne.s	.glueBallLoop

	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)	; ... then release it.
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)

	bra.s	.glueBallLoop
.exit
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
        beq.s   .exit

	tst.w	hBatGunCooldown(a4)
	bne.s	.exit

	bsr	AddBullet

	lea	SFX_SHOT_STRUCT,a0
	bsr     PlaySample
.exit
	rts

; Draws current game level on gamescreen & backing screen
DrawLevelCounter:
	move.l 	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1

	add.l   #(ScrBpl*18*4),a0		; Starting point: 4 bitplanes, Y = 16, X = 1st byte
	add.l	#(ScrBpl*18*4),a1
	move.l 	a1,a3				; Keep for digitblits

	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr	CopyRestoreGamearea

	move.w	LevelCount,d0
	bsr	Binary2Decimal

	moveq	#9,d3
	bsr	BlitScore

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	move.l 	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*18*4),a0		; Starting point: 4 bitplanes, Y = 16, X = 1st byte
	add.l	#(ScrBpl*18*4),a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*6*4)+2,d2
	bsr	CopyRestoreGamearea

	rts


AwaitAllFirebuttonsReleased:
.l1
        bsr     CheckFirebuttons        ; Await firebutton release
	tst.b	d0
        beq.s   .l1
	rts

; Out:	d0.l = Zero if firebutton pressed, JOY_NOTHING if not.
CheckFirebuttons:
	bsr	CheckPlayer0Fire
	tst.b	d0
	beq.s	.done
	bsr	CheckPlayer1Fire
	tst.b	d0
	beq.s	.done
	bsr	CheckPlayer2Fire
	tst.b	d0
	beq.s	.done
	bsr	CheckPlayer3Fire
.done
	rts

; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer0Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player0Enabled
	bmi.s	.exit
	beq.s	.joy1

	tst.b	KEYARRAY+KEY_RIGHTSHIFT
	beq	.exit
	clr.b	KEYARRAY+KEY_RIGHTSHIFT		; Clear keydown
	bra.s	.player0Fire
.joy1
	btst	#7,CIAA				; Joy1 button0 pressed?
	bne.s	.exit

.player0Fire
	moveq	#0,d0
.exit
	rts

; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer1Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player1Enabled
	bmi.s	.exit
	beq.s	.joy0

	tst.b	KEYARRAY+Player1KeyFire
	beq	.exit
	clr.b	KEYARRAY+Player1KeyFire		; Clear keydown
	bra.s	.player1Fire
.joy0
	btst	#6,CIAA				; Joy0 button0 pressed?
	bne.s	.exit

.player1Fire
	moveq	#0,d0
.exit
	rts


; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer2Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player2Enabled
	bmi.s	.exit
	beq.s	.joy2

	tst.b	KEYARRAY+Player2KeyFire
	beq	.exit
	clr.b	KEYARRAY+Player2KeyFire		; Clear keydown
	bra.s	.player2Fire
.joy2
	btst.b	#JOY2_FIRE0_BIT,CIAB+ciapra
	bne.s	.exit

.player2Fire
	moveq	#0,d0
.exit
	rts

; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer3Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	tst.b	KEYARRAY+Player3KeyFire
	beq	.exit
	clr.b	KEYARRAY+Player3KeyFire		; Clear keydown
	bra.s	.player3Fire
.joy3
	btst.b	#JOY3_FIRE0_BIT,CIAB+ciapra
	bne.s	.exit

.player3Fire
	moveq	#0,d0
.exit
	rts