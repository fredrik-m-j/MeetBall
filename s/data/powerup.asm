PowerupTable:
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz
;	dc.l	PwrStartInsanoballz

	dc.l	PwrExtraPoints
	dc.l	PwrStartWideBat
	dc.l	PwrStartWideBat
	dc.l	PwrIncreaseBatspeed
	dc.l	PwrIncreaseBatspeed
	dc.l	PwrIncreaseBatspeed
	dc.l	PwrGun
	dc.l	PwrGun
	dc.l	PwrStartMultiball
	dc.l	PwrStartMultiball
	dc.l	PwrStartGluebat
	dc.l	PwrStartGluebat
	dc.l	PwrStartBreachball
	dc.l	PwrStartBreachball
	dc.l	PwrStartInsanoballz
	dc.l	PwrStartInsanoballz

Powerup:
	dc.l	0               ; hAddress
	dc.l	PowerupMap		; hSpriteAnimMap
	dc.l	tSprite			; hType
	dc.b	0				; hIndex offset into animation map
	dc.b	LASTPOWERUPINDEX; hLastIndex
	dc.b    -1              ; hMoveIndex - not used
	dc.b    -1              ; hMoveLastIndex - not used
	dc.l	0				; hSpritePtr address into copperlist
	dc.l    0               ; hPlayerBat
	dc.l    0               ; hPowerupRoutine
	dc.l	-1				; hBobBlitMasks - not used

	dc.w	0				; hSprBobTopLeftXPos
	dc.w	0				; hSprBobTopLeftYPos
	dc.w	0				; hSprBobBottomRightXPos
	dc.w	0				; hSprBobBottomRightYPos
	dc.w    0				; hSprBobXCurrentSpeed
	dc.w    0				; hSprBobYCurrentSpeed
	dc.w    0				; hSprBobXSpeed
	dc.w    0				; hSprBobYSpeed
	dc.w	11				; hSprBobHeight
	dc.w	11				; hSprBobWidth
	dc.w	-1				; hSprBobAccentCol1 - not used
	dc.w 	-1				; hSprBobAccentCol2 - not used

PowerupMap:
	dc.l	Spr_Powerup0        ; Address to anim index 0 in CHIP ram
	dc.l	Spr_Powerup1        ; Address to anim index 1 in CHIP ram
	dc.l	Spr_Powerup2        ; Address to anim index 2 in CHIP ram
	dc.l	Spr_Powerup3        ; Address to anim index 3 in CHIP ram
	dc.l	Spr_Powerup4        ; Address to anim index 4 in CHIP ram
	dc.l	Spr_Powerup5        ; Address to anim index 5 in CHIP ram
	dc.l	Spr_Powerup6        ; Address to anim index 6 in CHIP ram
	dc.l	Spr_Powerup7        ; Address to anim index 7 in CHIP ram
	dc.l	Spr_Powerup8        ; Address to anim index 8 in CHIP ram
PowerupMapEND: