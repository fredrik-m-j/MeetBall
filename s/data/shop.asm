ShopBob:
	dc.l	0			; hAddress
	dc.l	ShopAnimMap	; hSpriteAnimMap
	dc.l	tBob		; hType
	dc.b	0			; hIndex - offset into animation map
	dc.b    24			; hLastIndex
	dc.b    -1			; hMoveIndex - not used
	dc.b    -1			; hMoveLastIndex - not used
	dc.l	2	      	; hPlayerScore
	dc.l	0			; hPlayerBat - not used
	dc.l	0			; hSprBobMaskAddress
	dc.l	$ffff0000	; hBobBlitMasks

	dc.w	210			; hSprBobTopLeftXPos
	dc.w	110			; hSprBobTopLeftYPos
	dc.w	210+12		; hSprBobBottomRightXPos
	dc.w	110+12		; hSprBobBottomRightYPos
	dc.w    1			; hSprBobXCurrentSpeed
	dc.w    1			; hSprBobYCurrentSpeed
	dc.w    1	        ; hSprBobXSpeed
	dc.w    1			; hSprBobYSpeed
	dc.w	12			; hSprBobHeight
	dc.w	12			; hSprBobWidth
	dc.w	0			; hSprBobAccentCol1
	dc.w 	0			; hSprBobAccentCol2
	dc.w	10			; hBobLeftXOffset	- Offsets for better collistions
	dc.w	10			; hBobRightXOffset
	dc.w	5			; hBobTopYOffset
	dc.w	5			; hBobBottomYOffset
	dc.w	SHOP_MODULO	; hBobBlitSrcModulo
	dc.w	SHOP_MODULO	; hBobBlitDestModulo
	dc.w	SHOP_BLITSIZE   	; hBobBlitSize

AnderBob:
	dc.l	0			; hAddress
	dc.l	-1			; hSpriteAnimMap - not used
	dc.l	tBob		; hType
	dc.b	-1			; hIndex - not used
	dc.b    -1			; hLastIndex - not used
	dc.b    -1			; hMoveIndex - not used
	dc.b    -1			; hMoveLastIndex - not used
	dc.l	-1	      	; hPlayerScore - not used
	dc.l	-1			; hPlayerBat - not used
	dc.l	0			; hSprBobMaskAddress
	dc.l	$ffff0000	; hBobBlitMasks

	dc.w	0			; hSprBobTopLeftXPos
	dc.w	0			; hSprBobTopLeftYPos
	dc.w	0			; hSprBobBottomRightXPos
	dc.w	0			; hSprBobBottomRightYPos
	dc.w    0			; hSprBobXCurrentSpeed
	dc.w    0			; hSprBobYCurrentSpeed
	dc.w    0			; hSprBobXSpeed
	dc.w    0			; hSprBobYSpeed
	dc.w	25			; hSprBobHeight
	dc.w	31			; hSprBobWidth
	dc.w	0			; hSprBobAccentCol1
	dc.w 	0			; hSprBobAccentCol2
	dc.w	0			; hBobLeftXOffset	- Offsets for better collistions
	dc.w	1			; hBobRightXOffset
	dc.w	0			; hBobTopYOffset
	dc.w	0			; hBobBottomYOffset
	dc.w	SHOPKEEP_MODULO	; hBobBlitSrcModulo
	dc.w	SHOPKEEP_MODULO	; hBobBlitDestModulo
	dc.w	SHOPKEEP_BLITSIZE   ; hBobBlitSize
MonBob:
	dc.l	0			; hAddress
	dc.l	-1			; hSpriteAnimMap - not used
	dc.l	tBob		; hType
	dc.b	-1			; hIndex - not used
	dc.b    -1			; hLastIndex - not used
	dc.b    -1			; hMoveIndex - not used
	dc.b    -1			; hMoveLastIndex - not used
	dc.l	-1	      	; hPlayerScore - not used
	dc.l	-1			; hPlayerBat - not used
	dc.l	0			; hSprBobMaskAddress
	dc.l	$ffff0000	; hBobBlitMasks

	dc.w	0			; hSprBobTopLeftXPos
	dc.w	0			; hSprBobTopLeftYPos
	dc.w	0			; hSprBobBottomRightXPos
	dc.w	0			; hSprBobBottomRightYPos
	dc.w    0			; hSprBobXCurrentSpeed
	dc.w    0			; hSprBobYCurrentSpeed
	dc.w    0			; hSprBobXSpeed
	dc.w    0			; hSprBobYSpeed
	dc.w	25			; hSprBobHeight
	dc.w	31			; hSprBobWidth
	dc.w	0			; hSprBobAccentCol1
	dc.w 	0			; hSprBobAccentCol2
	dc.w	0			; hBobLeftXOffset
	dc.w	0			; hBobRightXOffset
	dc.w	0			; hBobTopYOffset
	dc.w	0			; hBobBottomYOffset
	dc.w	SHOPKEEP_MODULO	; hBobBlitSrcModulo
	dc.w	SHOPKEEP_MODULO	; hBobBlitDestModulo
	dc.w	SHOPKEEP_BLITSIZE   ; hBobBlitSize

ShopTopLeftPos:
	dc.w	270,220
	dc.w	32,220
	dc.w	270,25
	dc.w	32,25
	dc.l	0

ShopItems:
	dc.l	OutOfStock
	dc.l	ItemExtraBall
	dc.l	ItemExtraPointsSmall
	dc.l	ItemExtraPointsBig
	dc.l	ItemStealFromPlayer0
	dc.l	ItemStealFromPlayer1
	dc.l	ItemStealFromPlayer2
	dc.l	ItemStealFromPlayer3
	dc.l	0


; There must be an item description 0 and a validation function (score requirement).
; NOTE: some hItemValue0 are updated in BalanceScoring routine.
OutOfStock:
	dc.b    "OUT",0,0,0			; hItemDescription0
	dc.b	"OF",0,0,0,0		; hItemDescription1
	dc.b	"STOCK",0			; hItemDescription2
	dcb.b	6,0					; <spare>
	dc.l	0					; hItemValue0
	dc.b	" ",0,0,0,0,0		; hItemValue1
	dc.l	CanAlways			; hItemValidFunction
	dc.l	ShopNothing			; hItemFunction
ItemExtraBall:
	dc.b    "EXTRA",0			; hItemDescription0
	dc.b	"BALL",0,0			; hItemDescription1
	dcb.b	12,0				; <spare>
	dc.l	SHOPITEM_BALL_BASEVALUE	; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanShopExtraBall	; hItemValidFunction
	dc.l	ShopExtraBall		; hItemFunction
ItemExtraPointsSmall:
	dc.b    "EXTRA",0			; hItemDescription0
	dc.b	"SCORE",0			; hItemDescription1
	dcb.b	12,0				; <spare>
	dc.l	SHOPITEM_POINTS_BASEVALUE	; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanAlways			; hItemValidFunction
	dc.l	ShopExtraPointsSmall	; hItemFunction
ItemExtraPointsBig:
	dc.b    "EXTRA",0			; hItemDescription0
	dc.b	"SCORE",0			; hItemDescription1
	dcb.b	12,0				; <spare>
	dc.l	SHOPITEM_BIGPOINTS_BASEVALUE	; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanAlways			; hItemValidFunction
	dc.l	ShopExtraPointsBig	; hItemFunction
ItemStealFromPlayer0:
	dc.b    "STEAL",0			; hItemDescription0
	dc.b	"FROM",0,0			; hItemDescription1
	dc.b	"GREEN",0			; hItemDescription2
	dcb.b	6,0					; <spare>
	dc.l	SHOPITEM_STEAL_BASEVALUE		; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanShopStealFromPlayer0	; hItemValidFunction
	dc.l	ShopStealFromPlayer0	; hItemFunction
ItemStealFromPlayer1:
	dc.b    "STEAL",0			; hItemDescription0
	dc.b	"FROM",0,0			; hItemDescription1
	dc.b	"RED",0,0,0			; hItemDescription2
	dcb.b	6,0					; <spare>
	dc.l	SHOPITEM_STEAL_BASEVALUE		; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanShopStealFromPlayer1	; hItemValidFunction
	dc.l	ShopStealFromPlayer1	; hItemFunction
ItemStealFromPlayer2:
	dc.b    "STEAL",0			; hItemDescription0
	dc.b	"FROM",0,0			; hItemDescription1
	dc.b	"WHITE",0			; hItemDescription2
	dcb.b	6,0					; <spare>
	dc.l	SHOPITEM_STEAL_BASEVALUE		; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanShopStealFromPlayer2	; hItemValidFunction
	dc.l	ShopStealFromPlayer2	; hItemFunction
ItemStealFromPlayer3:
	dc.b    "STEAL",0			; hItemDescription0
	dc.b	"FROM",0,0			; hItemDescription1
	dc.b	"BLUE",0,0			; hItemDescription2
	dcb.b	6,0					; <spare>
	dc.l	SHOPITEM_STEAL_BASEVALUE		; hItemValue0
	dc.b	"PTS",0,0,0			; hItemValue1
	dc.l	CanShopStealFromPlayer3	; hItemValidFunction
	dc.l	ShopStealFromPlayer3	; hItemFunction