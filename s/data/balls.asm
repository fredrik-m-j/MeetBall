; No multiplexing - use 3 maps
Breachball0Map:
	dc.l	Spr_Ball0Anim0   ; Address to anim index 0 in CHIP ram
	dc.l	Spr_Ball0Anim1   ; Address to anim index 1 in CHIP ram
	dc.l	Spr_Ball0Anim2   ; Address to anim index 2 in CHIP ram
	dc.l	Spr_Ball0Anim3   ; Address to anim index 3 in CHIP ram
	dc.l	Spr_Ball0Anim4   ; Address to anim index 4 in CHIP ram
	dc.l	Spr_Ball0Anim5   ; Address to anim index 5 in CHIP ram
	dc.l	Spr_Ball0Anim6   ; Address to anim index 6 in CHIP ram
	dc.l	Spr_Ball0Anim7   ; Address to anim index 7 in CHIP ram
Breachball1Map:
	dc.l	Spr_Ball1Anim0   ; Address to anim index 0 in CHIP ram
	dc.l	Spr_Ball1Anim1   ; Address to anim index 1 in CHIP ram
	dc.l	Spr_Ball1Anim2   ; Address to anim index 2 in CHIP ram
	dc.l	Spr_Ball1Anim3   ; Address to anim index 3 in CHIP ram
	dc.l	Spr_Ball1Anim4   ; Address to anim index 4 in CHIP ram
	dc.l	Spr_Ball1Anim5   ; Address to anim index 5 in CHIP ram
	dc.l	Spr_Ball1Anim6   ; Address to anim index 6 in CHIP ram
	dc.l	Spr_Ball1Anim7   ; Address to anim index 7 in CHIP ram
Breachball2Map:
	dc.l	Spr_Ball2Anim0   ; Address to anim index 0 in CHIP ram
	dc.l	Spr_Ball2Anim1   ; Address to anim index 1 in CHIP ram
	dc.l	Spr_Ball2Anim2   ; Address to anim index 2 in CHIP ram
	dc.l	Spr_Ball2Anim3   ; Address to anim index 3 in CHIP ram
	dc.l	Spr_Ball2Anim4   ; Address to anim index 4 in CHIP ram
	dc.l	Spr_Ball2Anim5   ; Address to anim index 5 in CHIP ram
	dc.l	Spr_Ball2Anim6   ; Address to anim index 6 in CHIP ram
	dc.l	Spr_Ball2Anim7   ; Address to anim index 7 in CHIP ram


GenericBallBob:  
	dc.l	0		; hAddress
	dc.l	-1      	; hSpriteAnimMap - not used
	dc.l	tBob		; hType
	dc.b	-1		; hIndex - offset into animation map
        dc.b    -1              ; hLastIndex - not used
	dc.b    -1             	; hMoveIndex - not used
	dc.b    -1              ; hMoveLastIndex - not used
	dc.l	-1	      	; hPlayerScore - not used
	dc.l	-1		; hPlayerBat - not used
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0	        ; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	7		; hSprBobHeight
	dc.w	7		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	BALL_MODULO	; hBobBlitSrcModulo
	dc.w	BALL_MODULO	; hBobBlitDestModulo
	dc.w	BALL_BLITSIZE     ; hBobBlitSize

Ball0:
	dc.l	Spr_Ball0	; hAddress
	dc.l	Breachball0Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	0               ; hSprBobTopLeftXPos
        dc.w	0               ; hSprBobTopLeftYPos
        dc.w	7               ; hSprBobBottomRightXPos
        dc.w	7               ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects

; Insano
Ball3:
	dc.l	Spr_Ball3	; hAddress
	dc.l	Breachball0Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	0               ; hSprBobTopLeftXPos
        dc.w	0               ; hSprBobTopLeftYPos
        dc.w	7               ; hSprBobBottomRightXPos
        dc.w	7               ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects


Ball1:
	dc.l	Spr_Ball1	; hAddress
	dc.l	Breachball1Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	100             ; hSprBobTopLeftXPos
        dc.w	100             ; hSprBobTopLeftYPos
        dc.w	107             ; hSprBobBottomRightXPos
        dc.w	107             ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects

; Insano
Ball4:
	dc.l	Spr_Ball4	; hAddress
	dc.l	Breachball1Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	100             ; hSprBobTopLeftXPos
        dc.w	100             ; hSprBobTopLeftYPos
        dc.w	107             ; hSprBobBottomRightXPos
        dc.w	107             ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects

Ball2:
	dc.l	Spr_Ball2       ; hAddress
	dc.l	Breachball2Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	150             ; hSprBobTopLeftXPos
        dc.w	150             ; hSprBobTopLeftYPos
        dc.w	157             ; hSprBobBottomRightXPos
        dc.w	157             ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects

; Insano
Ball5:
	dc.l	Spr_Ball5       ; hAddress
	dc.l	Breachball2Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	150             ; hSprBobTopLeftXPos
        dc.w	150             ; hSprBobTopLeftYPos
        dc.w	157             ; hSprBobBottomRightXPos
        dc.w	157             ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects

; Insano
Ball6:
	dc.l	Spr_Ball6       ; hAddress
	dc.l	Breachball2Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	150             ; hSprBobTopLeftXPos
        dc.w	150             ; hSprBobTopLeftYPos
        dc.w	157             ; hSprBobBottomRightXPos
        dc.w	157             ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects

; Insano
Ball7:
	dc.l	Spr_Ball7       ; hAddress
	dc.l	Breachball2Map  ; hSpriteAnimMap
	dc.l	tSprite		; hType
	dc.b	-1		; hIndex offset into animation map. -1 = ANIMATION OFF
        dc.b    7		; hLastIndex
        dc.b    -1              ; hMoveIndex - not used
        dc.b    -1              ; hMoveLastIndex - not used
        dc.l	0       	; hSpritePtr address into copperlist
        dc.l    0               ; hPlayerBat
        dc.l    -1              ; hSprBobMaskAddress - not used
        dc.l    -1              ; hBobBlitMasks - not used

        dc.w	150             ; hSprBobTopLeftXPos
        dc.w	150             ; hSprBobTopLeftYPos
        dc.w	157             ; hSprBobBottomRightXPos
        dc.w	157             ; hSprBobBottomRightYPos
        dc.w    0               ; hSprBobXCurrentSpeed
        dc.w    0               ; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
        dc.w	BALL_DIAMETER    ; hSprBobHeight
        dc.w	BALL_DIAMETER    ; hSprBobWidth
        dc.w    0               ; hSprBobAccentCol1
        dc.w    0               ; hSprBobAccentCol2
        dc.w    0               ; hBallSpeedLevel
        dc.w    0               ; hBallEffects