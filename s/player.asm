ResetPlayers:
	; Override/set sprite colors - Sprite 0-1
	lea     CUSTOM+COLOR17,a6 
	move.w	#$151,(a6)+
	move.w	#$393,(a6)+
	move.w	#$8d8,(a6)
	; Override/set sprite colors - Sprite 4-5
	lea     CUSTOM+COLOR25,a6 
	move.w 	#$511,(a6)+ 
	move.w 	#$933,(a6)+ 
	move.w 	#$d88,(a6)

	lea	Bat0,a0
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
	moveq	#0,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#122,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#2,hSprBobYSpeed(a0)

	move.l	BOBS_BITMAPBASE,d1

	lea	Bat2,a0
	move.l	d1,hAddress(a0)
	add.l	#10,d1
	move.l	d1,hSprBobMaskAddress(a0)
	move.w	#160-20,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#248,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#2,hSprBobXSpeed(a0)

	move.l	BOBS_BITMAPBASE,d1
	
	lea	Bat3,a0
	addi.l	#ScrBpl*7*4,d1		; Y offset for Bat3 - TODO dynamic no. of bitplanes
	move.l	d1,hAddress(a0)
	add.l	#10,d1
	move.l	d1,hSprBobMaskAddress(a0)
	move.w	#160-20,d0
	move.w	d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w	d0,hSprBobBottomRightXPos(a0)
	move.w	#1,d0
	move.w	d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w	d0,hSprBobBottomRightYPos(a0)
	move.w	#2,hSprBobXSpeed(a0)

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	bsr     CookieBlitToScreen	; Do an initial blit of the bat

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.exit

	lea	Bat2,a0
	bsr     CookieBlitToScreen	; Do an initial blit of the bat
.exit
	rts

; Updates player positions based on joystick input.
; Checks for ball release.
PlayerUpdates:
	lea	CUSTOM+JOY1DAT,a5
	bsr	agdJoyDetectMovement
	lea	Bat0,a4
	bsr.s	UpdatePlayerVerticalPos

	lea	CUSTOM+JOY0DAT,a5
	bsr	agdJoyDetectMovement
	lea	Bat1,a4
	bsr.s	UpdatePlayerVerticalPos

	lea	CIAA+ciaprb,a5			; Get address to direction bits
	move.b	(a5),d3				; Unlike Joy0/1 these bits need no decoding
	lea	Bat2,a4
	bsr.w	UpdatePlayerHorizontalPos	; Process Joy2

	move.b	(a5),d3
	lsr.b	#4,d3
	lea	Bat3,a4
	bsr.s	UpdatePlayerHorizontalPos	; Process Joy3 in upper nibble

	bsr	CheckBallRelease
.exit
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to sprite data
UpdatePlayerVerticalPos:
	cmpi.w	#JOY_NOTHING,d3
	beq.s	.exit

.up	btst.l	#JOY_UP_BIT,d3
	bne.s	.down
	
	cmpi.w	#24,hSprBobTopLeftYPos(a4)	; Reached the top?
	bls.w	.exit

	subq.w  #2,hSprBobTopLeftYPos(a4)
	subq.w  #2,hSprBobBottomRightYPos(a4)
	bra.s	.exit
	
.down	btst.l	#JOY_DOWN_BIT,d3
	bne.s	.exit

	; Reached the bottom? -2 compensates for potential movement
	cmpi.w	#DISP_HEIGHT-24-2,hSprBobBottomRightYPos(a4)
	bhs.w	.exit

	addq.w  #2,hSprBobTopLeftYPos(a4)
	addq.w  #2,hSprBobBottomRightYPos(a4)
.exit
	rts

; Updates player position given joystick input.
; In:	d3 = Joystic direction bits
; In:	a4 = Adress to bat
UpdatePlayerHorizontalPos:
	cmpi.w	#JOY_NOTHING,d3
	beq.s	.clearSpeed

.right	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.left
	
	; Reached the right? -2 compensates for potential movement
	cmpi.w	#DISP_WIDTH-32-2,hSprBobBottomRightXPos(a4)
	bhs.w	.exit

	move.w	hSprBobXSpeed(a4),d0
	move.w  d0,hSprBobXCurrentSpeed(a4)
	add.w  	d0,hSprBobTopLeftXPos(a4)
	add.w  	d0,hSprBobBottomRightXPos(a4)
	bra.s	.exit
	
.left  	btst.l	#JOY_LEFT_BIT,d3
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
	beq.s	.moveBallToBat
	bne	.exit
.moveBallToBat

	lea	Ball0,a0
	move.l	hBallPlayerBat(a0),a1
.checkPlayer0
	cmpa.l	#Bat0,a1
	bne.s	.checkPlayer1

	; Ball follows this bat
        move.w  hSprBobTopLeftXPos(a1),d0       	; Top left X pos
        sub.w   hBallWidth(a0),d0
        move.w  d0,hBallTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1       	; Top left Y pos
        addi.w  #$f,d1
        move.w  d1,hBallTopLeftYPos(a0)
        add.w   hBallWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hBallHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hBallBottomRightYPos(a0)

	bsr	Joy1DetectFire
	btst.l	#JOY1_FIRE0_BIT,d3			; Joy1 Fire0 pressed?
	bne.s	.checkPlayer1

	move.l  #Player0Score,hBallPlayerScore(a0)		; Player0 gets score from ball collisions
	move.w  BallSpeedLevel369,hBallXCurrentSpeed(a0)
	neg.w	hBallXCurrentSpeed(a0)				; Ball moves away from bat
	move.w  BallSpeedLevel123,hBallYCurrentSpeed(a0)
	neg.w	hBallYCurrentSpeed(a0)
	bra	.ReleaseBall
.checkPlayer1
	cmpa.l	#Bat1,a1
	bne.s	.checkPlayer2

	; Ball follows this bat
        move.w  hSprBobBottomRightXPos(a1),d0       	; Top left X pos
        move.w  d0,hBallTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1       	; Top left Y pos
        addi.w  #$f,d1
        move.w  d1,hBallTopLeftYPos(a0)
        add.w   hBallWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hBallHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hBallBottomRightYPos(a0)

	bsr	Joy0DetectFire
	btst.l	#JOY0_FIRE0_BIT,d3
	bne.s	.checkPlayer2

	move.l  #Player1Score,hBallPlayerScore(a0)
	move.w	BallSpeedLevel369,hBallXCurrentSpeed(a0)
	move.w	BallSpeedLevel123,hBallYCurrentSpeed(a0)
	bra	.ReleaseBall
.checkPlayer2
	cmpa.l	#Bat2,a1
	bne.s	.checkPlayer3

	; Ball follows this bat
        move.w  hSprBobTopLeftXPos(a1),d0       	; Top left X pos
	add.w   hBobLeftXOffset(a1),d0
	addq.w	#3,d0
        move.w  d0,hBallTopLeftXPos(a0)
        move.w  hSprBobTopLeftYPos(a1),d1       	; Top left Y pos
        sub.w	hBallHeight(a0),d1
        move.w  d1,hBallTopLeftYPos(a0)
        add.w   hBallWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hBallHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hBallBottomRightYPos(a0)

	bsr	Joy2DetectFire
	btst.l	#JOY2_FIRE0_BIT,d3
	bne.s	.checkPlayer3

	move.l  #Player2Score,hBallPlayerScore(a0)
	move.w	BallSpeedLevel123,hBallXCurrentSpeed(a0)
	move.w	BallSpeedLevel369,hBallYCurrentSpeed(a0)
	neg.w	hBallYCurrentSpeed(a0)
	bra	.ReleaseBall
.checkPlayer3
	cmpa.l	#Bat3,a1
	bne.s	.exit

	; Ball follows this bat
        move.w  hSprBobTopLeftXPos(a1),d0       	; Top left X pos
	add.w   hBobLeftXOffset(a1),d0
	subq	#6,d0					; Adjust relative ball position
        move.w  d0,hBallTopLeftXPos(a0)
        move.w  hSprBobBottomRightYPos(a1),d1       	; Top left Y pos
        move.w  d1,hBallTopLeftYPos(a0)
        add.w   hBallWidth(a0),d0               	; Bottom right X pos
        move.w  d0,hSprBobBottomRightXPos(a0)
        add.w   hBallHeight(a0),d1              	; Bottom right Y pos
        move.w  d1,hBallBottomRightYPos(a0)

	bsr	Joy3DetectFire
	btst.l	#JOY3_FIRE0_BIT,d3
	bne.s	.exit

	move.l  #Player3Score,hBallPlayerScore(a0)
	move.w	BallSpeedLevel123,hBallXCurrentSpeed(a0)
	neg.w	hBallXCurrentSpeed(a0)
	move.w	BallSpeedLevel369,hBallYCurrentSpeed(a0)

.ReleaseBall
	move.b	#$ff,BallZeroOnBat
.exit
	rts


; Draws current game level on gamescreen
DrawGameLevel:
	move.l 	GAMESCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*4*18)+1,a0		; Starting point: 4 bitplanes, Y = 18, X = 1st byte
	bsr	ClearScore			; Clear A LOT

	moveq	#0,d0
	move.w	LevelCount,d0
	bsr	Binary2Decimal
	moveq	#9,d3
	moveq	#18,d4
	bsr	BlitScore

	rts