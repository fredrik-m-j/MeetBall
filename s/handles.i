; CREDITS
; Asset handling is based on Amiga Game Dev series.
; Author:	Graeme Cowie (Mcgeezer)
;               https://mcgeezer.itch.io
;		https://www.amigagamedev.com

; Resource Types Here
tAsset							=	0	; RNC Packed File handle
tRes							=	1	; Memory Resource handle
tBitmap							=	2	; Bitmap handle
tPalette						=	3	; Palette handle
tScreen							=	4	; Screen Buffer
tBob							=	5	; Bob
tSprite							=	6	; Hardware sprite
tBrickDropBob					=	7	; Specialized Bob

sizeStructRes					=	16	; Size of assets and resource handle
sizeStructBitmap				=	32	; Size of Bitmap handle
sizeStructPalette				=	144	; 16 for header + 128 for palette

; Maximum Handles for each type
maxResourceStructs				=	20	; Maximum number of structures
maxBitmapStructs				=	4	; Maximum bitmap structures
maxPaletteStructs				=	4	; Maximum palette structures

; Global structure offsets      | byte |
hAddress						=	0	; Address of resource or asset in RAM
hSize							=	4	; Length of resource or asset in RAM
hType							=	8	; Resource type (see above)	
hIndex							=	12	; Index of handle
hLastIndex						=	13	; Last index value
hMoveIndex						=	14	; Movement index value
hMoveLastIndex					=	15	; Last movement index value

; Bitmap structure offsets
hBitmapWidth					=	16	; Word for Width in pixels
hBitmapHeight					=	18	; Word for Height in pixels
hBitmapPlanes					=	20	; Word for Bitplanes
hBitmapColours					=	22	; Word number of colours in image
hBitmapModulo					=	24	; Word for plane modulo
hBitmapScanLength				=	26	; Word total length of a scan line
hBitmapBody						=	28	; LongWord Body Pointer

; Palette structure offsets
hPalette						=	16	; Start of palette words

; Copper structure offsets
hColor00						=	20	; Start of COLOR00-COLOR31

; Sprite structure offsets
hVStart							=	0
hHStart							=	1
hVStop							=	2
hControlBits					=	3

; AllBalls structure offsets
hAllBallsActive					=	0
hAllBallsBall0					=	4
hAllBallsBall1					=	8
hAllBallsBall2					=	12
hAllBallsBall3					=	16
hAllBallsBall4					=	20
hAllBallsBall5					=	24
hAllBallsBall6					=	28
hAllBallsBall7					=	32

; ==== Sprites & Bobs ====
; Sprite & powerup structure offsets * SHARED * with bob structure offsets
hSpriteAnimMap					=	4
hNextAnimStruct					=	12
hSpritePtr						=	16
hPlayerScore					=	16
hPlayerBat						=	20

hBallSpeedLevel					=	52
hBallEffects					=	54

; Powerup sprites
hPowerupRoutine					=	24

; Bob structure offsets
hFunctionlistAddress			=	12

hSprBobMaskAddress				=	24
hBobBlitMasks					=	28

hSprBobTopLeftXPos				=	32
hSprBobTopLeftYPos				=	34
hSprBobBottomRightXPos			=	36
hSprBobBottomRightYPos			=	38
hSprBobXCurrentSpeed			=	40
hSprBobYCurrentSpeed			=	42
hSprBobXSpeed					=	44
hSprBobYSpeed					=	46
hSprBobHeight					=	48
hSprBobWidth					=	50
hSprBobAccentCol1				=	52
hSprBobAccentCol2				=	54
hBobLeftXOffset					=	56
hBobRightXOffset				=	58
hBobTopYOffset					=	60
hBobBottomYOffset				=	62
hBobBlitSrcModulo				=	64
hBobBlitDestModulo				=	66
hBobBlitSize					=	68

; Bat handles
hBatEffects						=	70
hBatGunCooldown					=	72

; Brick structure offsets
; hAddress to bob at 0
hBrickModulo					=	4
hBrickBlitSize					=	6
hBrickByteWidth					=	8
hBrickPoints					=	10 
hBrickColorY0X0					=	14	; A bunch of longwords with COLOR00 changes from here


; Shop handles
hItemDescription0				=	0
hItemDescription1				=	6
hItemDescription2				=	12
hItemDescription3				=	18
hItemValue0						=	24
hItemValue1						=	28
hItemValidFunction				=	34
hItemFunction					=	38

; Enemy handles
hEnemyState						=	70

; Enemystates
eDead							=	-1
eSpawning						=	0
eSpawned						=	1
eExploding						=	2

; Blinkbricks
hBlinkBrick						=	0
hBlinkBrickGameareaPtr			=	4
hBlinkBrickCopperPtr			=	8
hBlinkBrickStruct				=	12
hBlinkBrickGameareaRowstartPtr	=	16