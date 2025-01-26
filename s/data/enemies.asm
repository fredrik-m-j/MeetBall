Enemy1BlitSizes:
	dc.w	ENEMY1_BLITSIZE
	dc.w	(64*15*4)+2
	dc.w	(64*14*4)+2
	dc.w	(64*13*4)+2
	dc.w	(64*12*4)+2
	dc.w	(64*11*4)+2
	dc.w	(64*10*4)+2
	dc.w	(64*9*4)+2
	dc.w	(64*8*4)+2
	dc.w	(64*7*4)+2
	dc.w	(64*6*4)+2
	dc.w	(64*5*4)+2
	dc.w	(64*4*4)+2
	dc.w	(64*3*4)+2
	dc.w	(64*2*4)+2
	dc.w	(64*1*4)+2

; sizeof struct 72 byte
EnemyStructs:
	REPT	ENEMIES_DEFAULTMAX
	dc.l	0							; hAddress
	dc.l	0							; hSpriteAnimMap
	dc.l	tBob						; hType
	dc.b	0							; hIndex - offset into animation map
	dc.b	3							; hLastIndex
	dc.b	0							; hMoveIndex
	dc.b	ENEMY_SINMAX				; hMoveLastIndex
	dc.l	0							; hPlayerScore
	dc.l	0							; hPlayerBat
	dc.l	0							; hSprBobMaskAddress
	dc.l	$ffff0000					; hBobBlitMasks

	dc.w	0							; hSprBobTopLeftXPos
	dc.w	0							; hSprBobTopLeftYPos
	dc.w	0							; hSprBobBottomRightXPos
	dc.w	0							; hSprBobBottomRightYPos
	dc.w	1							; hSprBobXCurrentSpeed
	dc.w	1							; hSprBobYCurrentSpeed
	dc.w	1							; hSprBobXSpeed
	dc.w	1							; hSprBobYSpeed
	dc.w	16							; hSprBobHeight
	dc.w	11							; hSprBobWidth
	dc.w	0							; hSprBobAccentCol1
	dc.w	0							; hSprBobAccentCol2
	dc.w	0							; hBobLeftXOffset
	dc.w	0							; hBobRightXOffset
	dc.w	0							; hBobTopYOffset
	dc.w	0							; hBobBottomYOffset
	dc.w	ENEMY1_MODULO				; hBobBlitSrcModulo
	dc.w	ENEMY1_MODULO				; hBobBlitDestModulo
	dc.w	ENEMY1_BLITSIZE				; hBobBlitSize

	dc.w	ENEMYSTATE_DEAD				; hEnemyState

	ENDR