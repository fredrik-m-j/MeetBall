; CREDITS
; Asset handling is based on Amiga Game Dev series.
; Author:	Graeme Cowie (Mcgeezer)
;               https://mcgeezer.itch.io
;		https://www.amigagamedev.com

; Resource Types Here
tAsset  		equ	0		; RNC Packed File handle
tRes			equ	1		; Memory Resource handle
tBitmap 		equ	2		; Bitmap handle
tPalette		equ	3		; Palette handle
tScreen 		equ	4		; Screen Buffer
tBob                    equ     5               ; Bob
tSprite                 equ     6               ; Hardware sprite

sizeStructRes		equ	16		; Size of assets and resource handle
sizeStructBitmap	equ	32		; Size of Bitmap handle
sizeStructPalette	equ	144		; 16 for header + 128 for palette

; Maximum Handles for each type
maxResourceStructs	equ	20		; Maximum number of structures
maxBitmapStructs	equ	4		; Maximum bitmap structures
maxPaletteStructs	equ	4		; Maximum palette structures

; Global structure offsets      | byte |
hAddress		equ	0		; Address of resource or asset in RAM
hSize			equ	4		; Length of resource or asset in RAM
hType			equ	8		; Resource type (see above)	
hIndex			equ	12		; Index of handle

; Bitmap structure offsets
hBitmapWidth		equ	16		; Word for Width in pixels
hBitmapHeight		equ	18		; Word for Height in pixels
hBitmapPlanes		equ	20		; Word for Bitplanes
hBitmapColours		equ	22		; Word number of colours in image
hBitmapModulo		equ	24		; Word for plane modulo
hBitmapScanLength	equ	26		; Word total length of a scan line
hBitmapBody		equ	28		; LongWord Body Pointer

; Palette structure offsets
hPalette		equ	16		; Start of palette words

; Copper structure offsets
hColor00		equ	20		; Start of COLOR00-COLOR31

; Sprite structure offsets
hVStart                 equ     0
hHStart                 equ     1
hVStop                  equ     2
hControlBits            equ     3

; ==== Sprites & Bobs ====
; Sprite & powerup structure offsets * SHARED * with bob structure offsets
hBallPlayerScore        equ     16
hBallPlayerBat          equ     20

hBallSpeedLevel         equ     48

; Powerup sprites
hPowerupPlayerScore     equ     16
hPowerupType            equ     20

; Bob structure offsets
hRESERVED_LONGWORD1     equ     16      ; Might come in handy
hSprBobMaskAddress      equ     20
hSprBobTopLeftXPos      equ     24
hSprBobTopLeftYPos      equ     26
hSprBobBottomRightXPos  equ     28
hSprBobBottomRightYPos  equ     30
hSprBobXCurrentSpeed    equ     32
hSprBobYCurrentSpeed    equ     34
hSprBobXSpeed           equ     36
hSprBobYSpeed           equ     38
hSprBobHeight           equ     40
hSprBobWidth            equ     42
hSprBobAccentCol1       equ     44
hSprBobAccentCol2       equ     46
hBobLeftXOffset         equ     48
hBobRightXOffset        equ     50
hBobTopYOffset          equ     52
hBobBottomYOffset       equ     54
hBobBlitModulo          equ     56
hBobBlitSize            equ     58

; Brick structure offsets
; hAddress to bob at 0
hBrickModulo            equ     4
hBrickBlitSize          equ     6
hBrickByteWidth         equ     8
hBrickPoints            equ     10 
hBrickColorY0X0         equ     12      ; A bunch of longwords with COLOR00 changes from here