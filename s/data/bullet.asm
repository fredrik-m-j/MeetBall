; sizeof struct 17.l + 1.w
BulletStructs:
	REPT    BULLET_MAXSLOTS

		dc.l	0		; hAddress
		dc.l	0		; hSize +/- height/width
		dc.l	tBob		; hType
		dc.l	-1		; hFunctionlistAddress - not used
		dc.l	0		; hPlayerScore
		dc.l	0		; hPlayerBat
		dc.l	0		; hSprBobMaskAddress
		dc.l	$7c000000	; hBobBlitMasks

		dc.w	0		; hSprBobTopLeftXPos
		dc.w	0		; hSprBobTopLeftYPos
		dc.w	0		; hSprBobBottomRightXPos
		dc.w	0		; hSprBobBottomRightYPos
		dc.w    0		; hSprBobXCurrentSpeed
		dc.w    0		; hSprBobYCurrentSpeed
		dc.w    0		; hSprBobXSpeed
		dc.w    0		; hSprBobYSpeed
		dc.w	5		; hSprBobHeight
		dc.w	5		; hSprBobWidth
		dc.w	0		; hSprBobAccentCol1
		dc.w 	0		; hSprBobAccentCol2
		dc.w	2		; hBobLeftXOffset
		dc.w	0		; hBobRightXOffset
		dc.w	5		; hBobTopYOffset
		dc.w	0		; hBobBottomYOffset
		dc.w	RL_SIZE-4	; hBobBlitSrcModulo
		dc.w	RL_SIZE-4	; hBobBlitDestModulo
		dc.w	(64*(5+5+5)*4)+2; hBobBlitSize

	ENDR