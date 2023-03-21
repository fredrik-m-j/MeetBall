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
	move.l	#0,hSize(a0)
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
	move.w	#0,hBatEffects(a0)

	lea	Bat1,a0
	move.l	#0,hSize(a0)
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
	move.w	#0,hBatEffects(a0)

	lea	Bat2,a0
	move.l	#0,hSize(a0)
	move.w	#40,hSprBobWidth(a0)
	move.w	#140,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#248,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#BatDefaultSpeed,hSprBobXSpeed(a0)
	move.w	#20,hBobLeftXOffset(a0)
	move.w	#20,hBobRightXOffset(a0)
	move.l	#HorizBatZones,hFunctionlistAddress(a0)
	move.w	#0,hBatEffects(a0)

	lea	Bat3,a0
	move.l	#0,hSize(a0)
	move.w	#40,hSprBobWidth(a0)
	move.w	#140,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#1,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#BatDefaultSpeed,hSprBobXSpeed(a0)
	move.w	#20,hBobLeftXOffset(a0)
	move.w	#20,hBobRightXOffset(a0)
	move.l	#HorizBatZones,hFunctionlistAddress(a0)
	move.w	#0,hBatEffects(a0)

	rts

InitialBlitPlayers:
	move.l	GAMESCREEN_BITMAPBASE,a1
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
	beq.s	.joy1

	move.w	#KEY_UP,d0
	move.w	#KEY_DOWN,d1
	bsr	detectUpDown
	bra.s	.updatePlayer0
.joy1
	lea	CUSTOM+JOY1DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer0
	lea	Bat0,a4
	bsr	UpdatePlayerVerticalPos

	bsr	CheckPlayer0Fire
	tst.b	d0
	bne.s	.player1
	bsr	CheckBallRelease

.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	beq.s	.joy0

	move.w	#KEY_W,d0
	move.w	#KEY_S,d1
	bsr	detectUpDown
	bra.s	.updatePlayer1

.joy0
	lea	CUSTOM+JOY0DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer1
	lea	Bat1,a4
	bsr	UpdatePlayerVerticalPos

	bsr	CheckPlayer1Fire
	tst.b	d0
	bne.s	.player2
	bsr	CheckBallRelease

.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	beq.s	.joy2

	move.w	#KEY_LEFT,d0
	move.w	#KEY_RIGHT,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	lea	Bat2,a4
	bsr	UpdatePlayerHorizontalPos	; Process Joy2

	bsr	CheckPlayer2Fire
	tst.b	d0
	bne.s	.player3
	bsr	CheckBallRelease

.player3
	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	move.w	#KEY_A,d0
	move.w	#KEY_D,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	lea	Bat3,a4
	bsr	UpdatePlayerHorizontalPos	; Process Joy3 in upper nibble

	bsr	CheckPlayer3Fire
	tst.b	d0
	bne.s	.exit
	bsr	CheckBallRelease
.exit
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat struct
UpdatePlayerVerticalPos:
	cmpi.b	#JOY_NOTHING,d3
	beq.w	.clearSpeed

	move.w	hSprBobYSpeed(a4),d0
.up	btst.l	#JOY_UP_BIT,d3
	bne.s	.down
	
	move.w	#24,d1			; Reached the top?
	sub.w	hSprBobTopLeftYPos(a4),d1
	bpl.s	.setTop
	
	neg.w	d0
	bra.s	.update

.down	btst.l	#JOY_DOWN_BIT,d3
	bne.s	.exit

	move.w	#DISP_HEIGHT-24,d1	; Reached the bottom?
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
	cmpa.l	hBallPlayerBat(a0),a4		; ... on this bat?
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
	bra.s	.exit
.clearSpeed
	move.w	#0,hSprBobYCurrentSpeed(a4)
.exit
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat
UpdatePlayerHorizontalPos:
	move.b	d3,d7
	and.b	#$0f,d7
	cmpi.b	#$0f,d7
	beq.w	.clearSpeed

	move.w	hSprBobXSpeed(a4),d0
.right	btst.l	#JOY_RIGHT_BIT,d7
	bne.s	.left

	move.w	#DISP_WIDTH-32,d1		; Reached the right?
	sub.w	hSprBobBottomRightXPos(a4),d1
	bls.s	.setRight
	bra.s	.update
	
.left  	btst.l	#JOY_LEFT_BIT,d7
	bne.s	.exit
	
	move.w	#32,d1
	sub.w	hSprBobTopLeftXPos(a4),d1	; Reached the left?
	bpl.w	.setLeft

	neg.w	d0
.update
	move.w	hSprBobXSpeed(a4),hSprBobXCurrentSpeed(a4)
	add.w	d0,hSprBobTopLeftXPos(a4)
	add.w	d0,hSprBobBottomRightXPos(a4)

	lea     AllBalls+4,a1
.glueBallLoop
        move.l  (a1)+,d7		        ; Found ball?
	beq.w   .exit
	move.l	d7,a0

	tst.l   hSprBobXCurrentSpeed(a0)        ; Stationary?
	bne.s	.glueBallLoop
	cmpa.l	hBallPlayerBat(a0),a4		; ... on this bat?
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
	bra.s	.exit
.clearSpeed
	move.w	#0,hSprBobXCurrentSpeed(a4)
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
	cmpa.l	hBallPlayerBat(a0),a4		; ... on this bat?
	bne.s	.glueBallLoop

	move.w	hSprBobXSpeed(a0),hSprBobXCurrentSpeed(a0)	; ... then release it.
	move.w	hSprBobYSpeed(a0),hSprBobYCurrentSpeed(a0)

	bra.s	.glueBallLoop
.exit
	rts


; Draws current game level on gamescreen
DrawLevelCounter:
	move.l 	GAMESCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*4*16)+1,a0		; Starting point: 4 bitplanes, Y = 16, X = 1st byte
	bsr	ClearScore			; TODO: Replace with clear-blit - Clears A LOT

	moveq	#0,d0
	move.w	LevelCount,d0
	bsr	Binary2Decimal
	moveq	#9,d3
	moveq	#16,d4
	bsr	BlitScore

	rts


; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckPlayer0Fire:
	move.b	#JOY_NOTHING,d0

	tst.b	Player0Enabled
	bmi.s	.exit
	beq.s	.joy1

	tst.b	KEYARRAY+KEY_RIGHTSHIFT
	beq	.exit
	move.b	#0,KEYARRAY+KEY_RIGHTSHIFT	; Clear keydown
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

	tst.b	KEYARRAY+KEY_LEFTSHIFT
	beq	.exit
	move.b	#0,KEYARRAY+KEY_LEFTSHIFT	; Clear keydown
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

	tst.b	KEYARRAY+KEY_RIGHTAMIGA
	beq	.exit
	move.b	#0,KEYARRAY+KEY_RIGHTAMIGA	; Clear keydown
	bra.s	.player2Fire
.joy2
	; move.b	CIAB+ciapra,d3
	; btst.l	#JOY2_FIRE0_BIT,d3		; Firebutton 0 pressed?
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

	tst.b	KEYARRAY+KEY_LEFTAMIGA
	beq	.exit
	move.b	#0,KEYARRAY+KEY_LEFTAMIGA	; Clear keydown
	bra.s	.player3Fire
.joy3
	; move.b	CIAB+ciapra,d3
	; btst.l	#JOY3_FIRE0_BIT,d3	; Firebutton 0 pressed?

	btst.b	#JOY3_FIRE0_BIT,CIAB+ciapra
	bne.s	.exit

.player3Fire
	moveq	#0,d0
.exit
	rts