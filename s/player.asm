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
	move.w	#2,hSprBobYSpeed(a0)

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
	move.w	#2,hSprBobYSpeed(a0)

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
	move.w	#2,hSprBobXSpeed(a0)
	move.w	#20,hBobLeftXOffset(a0)
	move.w	#20,hBobRightXOffset(a0)

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
	move.w	#2,hSprBobXSpeed(a0)
	move.w	#20,hBobLeftXOffset(a0)
	move.w	#20,hBobRightXOffset(a0)

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

.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	beq.s	.joy2

	move.w	#KEY_LEFT,d0
	move.w	#KEY_RIGHT,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3				; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	lea	Bat2,a4
	bsr	UpdatePlayerHorizontalPos	; Process Joy2

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

.exit
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to sprite data
UpdatePlayerVerticalPos:
	cmpi.b	#JOY_NOTHING,d3
	beq.s	.clearSpeed

.up	btst.l	#JOY_UP_BIT,d3
	bne.s	.down
	
	cmpi.w	#24,hSprBobTopLeftYPos(a4)	; Reached the top?
	bls.w	.exit

	move.w	hSprBobYSpeed(a4),d0
	move.w  d0,hSprBobYCurrentSpeed(a4)
	subq.w  #2,hSprBobTopLeftYPos(a4)
	subq.w  #2,hSprBobBottomRightYPos(a4)
	bra.s	.exit
	
.down	btst.l	#JOY_DOWN_BIT,d3
	bne.s	.exit

	; Reached the bottom? -2 compensates for potential movement
	cmpi.w	#DISP_HEIGHT-24-2,hSprBobBottomRightYPos(a4)
	bhs.w	.exit

	move.w	hSprBobYSpeed(a4),d0
	move.w  d0,hSprBobYCurrentSpeed(a4)
	addq.w  #2,hSprBobTopLeftYPos(a4)
	addq.w  #2,hSprBobBottomRightYPos(a4)
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
	beq.s	.clearSpeed

.right	btst.l	#JOY_RIGHT_BIT,d7
	bne.s	.left
	
	; Reached the right? -2 compensates for potential movement
	cmpi.w	#DISP_WIDTH-32-2,hSprBobBottomRightXPos(a4)
	bhs.w	.exit

	move.w	hSprBobXSpeed(a4),d0
	move.w  d0,hSprBobXCurrentSpeed(a4)
	add.w  	d0,hSprBobTopLeftXPos(a4)
	add.w  	d0,hSprBobBottomRightXPos(a4)
	bra.s	.exit
	
.left  	btst.l	#JOY_LEFT_BIT,d7
	bne.s	.exit
	
	cmpi.w	#32,hSprBobTopLeftXPos(a4)	; Reached the left?
	bls.w	.exit

	move.w	hSprBobXSpeed(a4),d0
	neg.w	d0
	move.w  d0,hSprBobXCurrentSpeed(a4)
	add.w  	d0,hSprBobTopLeftXPos(a4)
	add.w  	d0,hSprBobBottomRightXPos(a4)
	bra.s	.exit

.clearSpeed
	move.w	#0,hSprBobXCurrentSpeed(a4)
.exit
	rts


; Releases Ball 0 from the Bat that has the serve.
CheckBallRelease:
	tst.b	BallZeroOnBat
	bne	.exit

	lea	Ball0,a0
	move.l	hBallPlayerBat(a0),a1
.checkPlayer0
	cmpa.l	#Bat0,a1
	bne.s	.checkPlayer1

	; Ball follows this bat
        move.w  hSprBobTopLeftXPos(a1),d0       	; Top left X pos
        sub.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1       	; Top left Y pos
        addi.w  #$f,d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hSprBobBottomRightYPos(a0)

	bsr	CheckPlayer0Fire
	tst.b	d0
	bne.s	.checkPlayer1

	move.l  hPlayerScore(a1),hPlayerScore(a0)		; Player0 gets score from ball collisions
	move.w  BallSpeedLevel369,hSprBobXCurrentSpeed(a0)
	neg.w	hSprBobXCurrentSpeed(a0)			; Ball moves away from bat
	move.w  BallSpeedLevel123,hSprBobYCurrentSpeed(a0)
	neg.w	hSprBobYCurrentSpeed(a0)
	bra	.ReleaseBall

.checkPlayer1
	cmpa.l	#Bat1,a1
	bne.s	.checkPlayer2

	; Ball follows this bat
        move.w  hSprBobBottomRightXPos(a1),d0       	; Top left X pos
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1       	; Top left Y pos
        addi.w  #$f,d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hSprBobBottomRightYPos(a0)

	bsr	CheckPlayer1Fire
	tst.b	d0
	bne.s	.checkPlayer2

	move.l  hPlayerScore(a1),hPlayerScore(a0)
	move.w	BallSpeedLevel369,hSprBobXCurrentSpeed(a0)
	move.w	BallSpeedLevel123,hSprBobYCurrentSpeed(a0)
	bra	.ReleaseBall

.checkPlayer2
	cmpa.l	#Bat2,a1
	bne.s	.checkPlayer3

	; Ball follows this bat
        move.w  hSprBobTopLeftXPos(a1),d0       	; Top left X pos
	add.w   hBobLeftXOffset(a1),d0
	addq.w	#3,d0
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1       	; Top left Y pos
        sub.w	hSprBobHeight(a0),d1
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hSprBobBottomRightYPos(a0)

	bsr	CheckPlayer2Fire
	tst.b	d0
	bne.s	.checkPlayer3

	move.l  hPlayerScore(a1),hPlayerScore(a0)
	move.w	BallSpeedLevel123,hSprBobXCurrentSpeed(a0)
	move.w	BallSpeedLevel369,hSprBobYCurrentSpeed(a0)
	neg.w	hSprBobYCurrentSpeed(a0)
	bra	.ReleaseBall

.checkPlayer3
	cmpa.l	#Bat3,a1
	bne.s	.exit

	; Ball follows this bat
        move.w  hSprBobTopLeftXPos(a1),d0       	; Top left X pos
	add.w   hBobLeftXOffset(a1),d0
	subq	#6,d0					; Adjust relative ball position
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  hSprBobBottomRightYPos(a1),d1       	; Top left Y pos
        move.w  d1,hSprBobTopLeftYPos(a0)
        add.w   hSprBobWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hSprBobHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hSprBobBottomRightYPos(a0)

	bsr	CheckPlayer3Fire
	tst.b	d0
	bne.s	.exit

	move.l  hPlayerScore(a1),hPlayerScore(a0)
	move.w	BallSpeedLevel123,hSprBobXCurrentSpeed(a0)
	neg.w	hSprBobXCurrentSpeed(a0)
	move.w	BallSpeedLevel369,hSprBobYCurrentSpeed(a0)

.ReleaseBall
	move.b	#$ff,BallZeroOnBat
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