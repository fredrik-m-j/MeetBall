; Set any start position and direction/speed.
ReleaseBallFromPosition:
	move.l	#16*VC_FACTOR,d0			; Starting X pos
	move.l	#48*VC_FACTOR,d1			; Starting Y pos

	; move.w  #80,BallspeedBase
	bsr	ResetBallspeeds

	move.w	BallSpeedLevel369,d2			; Starting X speed
	move.w	BallSpeedLevel123,d3			; Starting Y speed

	lea	Ball0,a0
	move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  d1,hSprBobTopLeftYPos(a0)
	add.w	#BallDiameter*VC_FACTOR,d0
	add.w	#BallDiameter*VC_FACTOR,d1
	move.w  d0,hSprBobBottomRightXPos(a0)
        move.w  d1,hSprBobBottomRightYPos(a0)
	move.w  d2,hSprBobXCurrentSpeed(a0)
	move.w  d3,hSprBobYCurrentSpeed(a0)

        ; Adjust Bat0
	; lea	Bat0,a0
	; ; move.w	hSprBobTopLeftXPos(a0),d1
	; move.l	#24,d0
	; move.w	d0,hSprBobTopLeftYPos(a0)
	; add.w	hSprBobHeight(a0),d0
	; move.w	d0,hSprBobBottomRightYPos(a0)
        rts