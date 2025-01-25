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
	
; Table for extending vertical bat
BatVertBlitSizes:
	dc.w	(64*(11+BAT_VERTICALMARGIN)*4)+1,(64*(33+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1	; Original 33+margins lines, 1 word to blit horizontally
	dc.w	(64*(12+BAT_VERTICALMARGIN)*4)+1,(64*(34+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(13+BAT_VERTICALMARGIN)*4)+1,(64*(35+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(14+BAT_VERTICALMARGIN)*4)+1,(64*(36+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(15+BAT_VERTICALMARGIN)*4)+1,(64*(37+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(16+BAT_VERTICALMARGIN)*4)+1,(64*(38+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(17+BAT_VERTICALMARGIN)*4)+1,(64*(39+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(18+BAT_VERTICALMARGIN)*4)+1,(64*(40+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(19+BAT_VERTICALMARGIN)*4)+1,(64*(41+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(20+BAT_VERTICALMARGIN)*4)+1,(64*(42+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(21+BAT_VERTICALMARGIN)*4)+1,(64*(43+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(22+BAT_VERTICALMARGIN)*4)+1,(64*(44+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(23+BAT_VERTICALMARGIN)*4)+1,(64*(45+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
	dc.w	(64*(24+BAT_VERTICALMARGIN)*4)+1,(64*(46+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1


BatHorizExtendMaskTable:
	dc.w	$ffff
	dc.w	$fffe
	dc.w	$fffc
	dc.w	$fff8
	dc.w	$fff0
	dc.w	$ffe0
	dc.w	$ffc0
	dc.w	$ff80
	dc.w	$ff00
	dc.w	$fe00
	dc.w	$fc00
	dc.w	$f800
	dc.w	$f000
	dc.w	$e000
	dc.w	$c000
	dc.w	$8000


Bat0:
	dc.l	0			; hAddress
	dc.l	0			; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	VerticalBatZones	; hFunctionlistAddress - bounce routines
	dc.l	0			; hPlayerScore
	dc.l	0			; hPlayerBat
	dc.l	0			; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0			; hSprBobTopLeftXPos
	dc.w	0			; hSprBobTopLeftYPos
	dc.w	0			; hSprBobBottomRightXPos
	dc.w	0			; hSprBobBottomRightYPos
	dc.w    0			; hSprBobXCurrentSpeed
	dc.w    0			; hSprBobYCurrentSpeed
	dc.w    0			; hSprBobXSpeed
	dc.w    BAT_DEFAULTSPEED			; hSprBobYSpeed
	dc.w	BAT_VERT_DEFAULTHEIGHT	; hSprBobHeight
	dc.w	7			; hSprBobWidth
	dc.w	$151		; hSprBobAccentCol1
	dc.w 	$393		; hSprBobAccentCol2
	dc.w	0			; hBobLeftXOffset
	dc.w	0			; hBobRightXOffset
	dc.w	BAT_VERTICALMARGIN		; hBobTopYOffset
	dc.w	BAT_VERTICALMARGIN		; hBobBottomYOffset
	dc.w	0			; hBobBlitSrcModulo
	dc.w	BAT_VERTICAL_MODULO	; hBobBlitDestModulo
	dc.w	(64*(BAT_VERT_DEFAULTHEIGHT+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1	; hBobBlitSize
	dc.w	0			; hBatEffects
	dc.w	0			; hBatGunCooldown

Bat1:
	dc.l	0			; hAddress
	dc.l	0			; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	VerticalBatZones	; hFunctionlistAddress - bounce routines
	dc.l	0			; hPlayerScore
	dc.l	0			; hPlayerBat
	dc.l	0			; hSprBobMaskAddress
	dc.l	DEFAULT_MASK		; hBobBlitMasks

	dc.w	0			; hSprBobTopLeftXPos
	dc.w	0			; hSprBobTopLeftYPos
	dc.w	0			; hSprBobBottomRightXPos
	dc.w	0			; hSprBobBottomRightYPos
	dc.w    0			; hSprBobXCurrentSpeed
	dc.w    0			; hSprBobYCurrentSpeed
	dc.w    0			; hSprBobXSpeed
	dc.w    BAT_DEFAULTSPEED		; hSprBobYSpeed
	dc.w	BAT_VERT_DEFAULTHEIGHT	; hSprBobHeight
	dc.w	7			; hSprBobWidth
	dc.w	$933		; hSprBobAccentCol1
	dc.w 	$d88		; hSprBobAccentCol2
	dc.w	0			; hBobLeftXOffset
	dc.w	0			; hBobRightXOffset
	dc.w	BAT_VERTICALMARGIN		; hBobTopYOffset
	dc.w	BAT_VERTICALMARGIN		; hBobBottomYOffset
	dc.w	0			; hBobBlitSrcModulo
	dc.w	BAT_VERTICAL_MODULO	; hBobBlitDestModulo
	dc.w	(64*(BAT_VERT_DEFAULTHEIGHT+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1	; hBobBlitSize
	dc.w	0			; hBatEffects
	dc.w	0			; hBatGunCooldown

Bat2:
	dc.l	0			; hAddress
	dc.l	0			; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	HorizBatZones		; hFunctionlistAddress - bounce routines
	dc.l	0			; hPlayerScore
	dc.l	0			; hPlayerBat
	dc.l	0			; hSprBobMaskAddress
	dc.l	DEFAULT_MASK		; hBobBlitMasks

	dc.w	140			; hSprBobTopLeftXPos
	dc.w	244			; hSprBobTopLeftYPos
	dc.w	140+41		; hSprBobBottomRightXPos
	dc.w	244+7		; hSprBobBottomRightYPos
	dc.w    0			; hSprBobXCurrentSpeed
	dc.w    0			; hSprBobYCurrentSpeed
	dc.w    BAT_DEFAULTSPEED		; hSprBobXSpeed
	dc.w    0			; hSprBobYSpeed
	dc.w	7			; hSprBobHeight
	dc.w	BAT_HORIZ_DEFAULTWIDTH	; hSprBobWidth
	dc.w	$666		; hSprBobAccentCol1
	dc.w 	$bbb		; hSprBobAccentCol2
	;	dc.w	32+1			; hBobLeftXOffset, +1 to get cleaner extended bat
	dc.w	BAT_HORIZ_LEFT_OFFSET	; hBobLeftXOffset, (Add +1 to get cleaner extended bat - but incorrect draw)
	dc.w	20-1		; hBobRightXOffset,-1 to get cleaner extended bat
	dc.w	0			; hBobTopYOffset
	dc.w	0			; hBobBottomYOffset
	dc.w	0			; hBobBlitSrcModulo
	dc.w	BAT_HORIZONTAL_MODULO	; hBobBlitDestModulo
	dc.w	BAT_HORIZONTAL_BLITSIZE	; hBobBlitSize
	dc.w	0			; hBatEffects
	dc.w	0			; hBatGunCooldown

Bat3:
	dc.l	0			; hAddress
	dc.l	0			; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	HorizBatZones		; hFunctionlistAddress - bounce routines
	dc.l	0			; hPlayerScore
	dc.l	0			; hPlayerBat
	dc.l	0			; hSprBobMaskAddress
	dc.l	DEFAULT_MASK		; hBobBlitMasks
	
	dc.w	140			; hSprBobTopLeftXPos
	dc.w	2			; hSprBobTopLeftYPos
	dc.w	140+41		; hSprBobBottomRightXPos
	dc.w	2+7			; hSprBobBottomRightYPos
	dc.w    0			; hSprBobXCurrentSpeed
	dc.w    0			; hSprBobYCurrentSpeed
	dc.w    BAT_DEFAULTSPEED		; hSprBobXSpeed
	dc.w    0			; hSprBobYSpeed
	dc.w	7			; hSprBobHeight
	dc.w	BAT_HORIZ_DEFAULTWIDTH	; hSprBobWidth
	dc.w	$339		; hSprBobAccentCol1
	dc.w 	$88d		; hSprBobAccentCol2
	;	dc.w	32+1			; hBobLeftXOffset, +1 to get cleaner extended bat
	dc.w	BAT_HORIZ_LEFT_OFFSET	; hBobLeftXOffset, (Add +1 to get cleaner extended bat - but incorrect draw)
	dc.w	20-1		; hBobRightXOffset,-1 to get cleaner extended bat
	dc.w	0			; hBobTopYOffset
	dc.w	0			; hBobBottomYOffset
	dc.w	0			; hBobBlitSrcModulo
	dc.w	BAT_HORIZONTAL_MODULO	; hBobBlitDestModulo
	dc.w	BAT_HORIZONTAL_BLITSIZE	; hBobBlitSize
	dc.w	0			; hBatEffects
	dc.w	0			; hBatGunCooldown