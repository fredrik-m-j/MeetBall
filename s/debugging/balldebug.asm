; Set any start position and direction/speed.
ReleaseBallFromPosition:
	move.l	#16*VC_FACTOR,d0			; Starting X pos
	move.l	#48*VC_FACTOR,d1			; Starting Y pos
	move.l	#3*VC_FACTOR,d2				; Starting X speed
	move.l	#1*VC_FACTOR,d3				; Starting Y speed

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

; IncreaseBallspeed:
; 	lea	Ball0,a0
; 	move.w  BallSpeedLevel369,hSprBobXCurrentSpeed(a0)
; 	neg.w	hSprBobXCurrentSpeed(a0)			; Ball moves away from bat
; 	move.w  BallSpeedLevel123,hSprBobYCurrentSpeed(a0)
; 	neg.w	hSprBobYCurrentSpeed(a0)
; 	; move.b	#$ff,BallZeroOnBat

; 	bsr	IncreaseBallSpeedLevel
;         rts