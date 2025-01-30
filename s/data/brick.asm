NoVerticalPosWait:	dc.b	0	; Flag used by blinkbricks
	even

; ----- This is the tile map referencing tiles/bricks in an UNBROKEN BYTE SEQUENCE
TileMap:
	dc.l	0							; 0
	dc.l	GreyCol
	dc.l	GreenScore
	dc.l	RedScore
	dc.l	WhiteScore
	dc.l	BlueScore
	dc.l	DarkGreyCol
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
StaticBrickMap:
	dc.l	WhiteBrick					; $10
	dc.l	WhiteBrickD
	dc.l	WhiteBrickDD
	dc.l	OrangeBrick
	dc.l	CyanBrick
	dc.l	GreenBrick
	dc.l	DarkGreyRaisedBrick
	dc.l	LightGreyRaisedBrick
	dc.l	BrightRedRaisedBrick
	dc.l	BrightRedTopBrick
	dc.l	RedBrick
	dc.l	BlueBrick
	dc.l	PurpleBrick
	dc.l	YellowBrick
	dc.l	LightBlueRaisedBrick
	dc.l	RedRaisedBrick
	dc.l	DarkBlueRaisedBrick			; $20
	dc.l	BlueTopBrick
	dc.l	GoldBrick
	dc.l	B2
	dc.l	B3
	dc.l	B4
	dc.l	B5
	dc.l	B6
	dc.l	B7
	dc.l	B8
	dc.l	BeerDarkLeftSide
	dc.l	BeerHighlight
	dc.l	BeerMid
	dc.l	BeerRightSide
	dc.l	BeerDarkRightSide
	dc.l	BeerFoam
	dc.l	IndestructableGrey			; $30
StaticBrickMapEND:
RandomBricks:							; This holds pointers to generated bricks.
	REPT	MAX_RANDOMBRICKS
	dc.l	0							; Address to a brickstructure
										; $7a
	ENDR
; ----- END of tilemap UNBROKEN BYTE SEQUENCE


; ===== Single tiles 8x8 pixels =====
GreyCol:
	dc.l	-1							; BrickGfxPtr to bob in CHIP mem - not used
	dc.w	1							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800555					; BrickColorY0X0
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		
	dc.l	$01800555	
	dc.l	-1		

GreenScore:
	dc.l	-1							; BrickGfxPtr to bob in CHIP mem - not used
	dc.w	1							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800161					; BrickColorY0X0
	dc.l	-1
	dc.l	$01800161
	dc.l	-1
	dc.l	$01800161
	dc.l	-1
	dc.l	$01800161
	dc.l	-1
	dc.l	$01800161
	dc.l	-1
	dc.l	$01800161
	dc.l	-1
	dc.l	$01800161
	dc.l	-1
	dc.l	$01800030
	dc.l	-1

RedScore:
	dc.l	-1							; BrickGfxPtr to bob in CHIP mem - not used
	dc.w	1							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800611					; BrickColorY0X0
	dc.l	-1
	dc.l	$01800611
	dc.l	-1
	dc.l	$01800611
	dc.l	-1
	dc.l	$01800611
	dc.l	-1
	dc.l	$01800611
	dc.l	-1
	dc.l	$01800611
	dc.l	-1
	dc.l	$01800611
	dc.l	-1
	dc.l	$01800300
	dc.l	-1

WhiteScore:
	dc.l	-1							; BrickGfxPtr to bob in CHIP mem - not used
	dc.w	1							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800777					; BrickColorY0X0
	dc.l	-1
	dc.l	$01800777
	dc.l	-1
	dc.l	$01800777
	dc.l	-1
	dc.l	$01800777
	dc.l	-1
	dc.l	$01800777
	dc.l	-1
	dc.l	$01800777
	dc.l	-1
	dc.l	$01800777
	dc.l	-1
	dc.l	$01800444
	dc.l	-1

BlueScore:
	dc.l	-1							; BrickGfxPtr to bob in CHIP mem - not used
	dc.w	1							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800227					; BrickColorY0X0
	dc.l	-1
	dc.l	$01800227
	dc.l	-1
	dc.l	$01800227
	dc.l	-1
	dc.l	$01800227
	dc.l	-1
	dc.l	$01800227
	dc.l	-1
	dc.l	$01800227
	dc.l	-1
	dc.l	$01800227
	dc.l	-1
	dc.l	$01800114
	dc.l	-1

DarkGreyCol:
	dc.l	-1							; BrickGfxPtr to bob in CHIP mem - not used
	dc.w	1							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800333					; BrickColorY0X0
	dc.l	-1
	dc.l	$01800333
	dc.l	-1
	dc.l	$01800333
	dc.l	-1
	dc.l	$01800333
	dc.l	-1
	dc.l	$01800333
	dc.l	-1
	dc.l	$01800333
	dc.l	-1
	dc.l	$01800333
	dc.l	-1
	dc.l	$01800333
	dc.l	-1

; ===== Bricks 16x8 pixels =====
WhiteBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	1							; BrickPoints
	dc.l	$01800fff					; BrickColorY0X0
	dc.l	$01800ddf
	dc.l	$01800fff
	dc.l	$01800ddf
	dc.l	$01800fff
	dc.l	$01800ddf
	dc.l	$01800fff
	dc.l	$01800ddf
	dc.l	$01800eee
	dc.l	$01800cce
	dc.l	$01800eee
	dc.l	$01800cce
	dc.l	$01800eee
	dc.l	$01800cce
	dc.l	$01800217
	dc.l	$01800217

WhiteBrickD:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800bbb					; BrickColorY0X0
	dc.l	$0180099b
	dc.l	$01800bbb
	dc.l	$0180099b
	dc.l	$01800bbb
	dc.l	$0180099b
	dc.l	$01800bbb
	dc.l	$0180099b
	dc.l	$01800aaa
	dc.l	$0180088a
	dc.l	$01800aaa
	dc.l	$0180088a
	dc.l	$01800aaa
	dc.l	$0180088a
	dc.l	$01800217
	dc.l	$01800217

WhiteBrickDD:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800777					; BrickColorY0X0
	dc.l	$01800557
	dc.l	$01800777
	dc.l	$01800557
	dc.l	$01800777
	dc.l	$01800557
	dc.l	$01800777
	dc.l	$01800557
	dc.l	$01800666
	dc.l	$01800556
	dc.l	$01800666
	dc.l	$01800556
	dc.l	$01800666
	dc.l	$01800556
	dc.l	$01800217
	dc.l	$01800217

OrangeBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800fa0					; BrickColorY0X0
	dc.l	$01800d82
	dc.l	$01800fa0
	dc.l	$01800d82
	dc.l	$01800fa0
	dc.l	$01800d82
	dc.l	$01800fa0
	dc.l	$01800d82
	dc.l	$01800e90
	dc.l	$01800c72
	dc.l	$01800e90
	dc.l	$01800c72
	dc.l	$01800e90
	dc.l	$01800c72
	dc.l	$01800217
	dc.l	$01800217

CyanBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$018000ff					; BrickColorY0X0
	dc.l	$018000df
	dc.l	$018000ff
	dc.l	$018000df
	dc.l	$018000ff
	dc.l	$018000df
	dc.l	$018000ff
	dc.l	$018000df
	dc.l	$018000ee
	dc.l	$018000cf
	dc.l	$018000ee
	dc.l	$018000cf
	dc.l	$018000ee
	dc.l	$018000cf
	dc.l	$01800217
	dc.l	$01800217

GreenBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$018000f0					; BrickColorY0X0
	dc.l	$018000d2
	dc.l	$018000f0
	dc.l	$018000d2
	dc.l	$018000f0
	dc.l	$018000d2
	dc.l	$018000f0
	dc.l	$018000d2
	dc.l	$018000e0
	dc.l	$018000c2
	dc.l	$018000e0
	dc.l	$018000c2
	dc.l	$018000e0
	dc.l	$018000c2
	dc.l	$01800217
	dc.l	$01800217

DarkGreyRaisedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800877					; BrickColorY0X0
	dc.l	$01800877
	dc.l	$01800888
	dc.l	$01800888
	dc.l	$01800988
	dc.l	$01800988
	dc.l	$01800999
	dc.l	$01800999
	dc.l	$01800667
	dc.l	$01800667
	dc.l	$01800555
	dc.l	$01800555
	dc.l	$01800445
	dc.l	$01800445
	dc.l	$01800217
	dc.l	$01800217

LightGreyRaisedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800bbb					; BrickColorY0X0
	dc.l	$01800bbb
	dc.l	$01800cbb
	dc.l	$01800cbb
	dc.l	$01800ccc
	dc.l	$01800ccc
	dc.l	$01800ddd
	dc.l	$01800ddd
	dc.l	$01800bbc
	dc.l	$01800bbc
	dc.l	$01800aaa
	dc.l	$01800aaa
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$01800217
	dc.l	$01800217

BrightRedRaisedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem
	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800a00					; BrickColorY0X0
	dc.l	$01800a00
	dc.l	$01800a00
	dc.l	$01800a00
	dc.l	$01800a00
	dc.l	$01800a00
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800700
	dc.l	$01800217
	dc.l	$01800217

BrightRedTopBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800e00					; BrickColorY0X0
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800900
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800e00
	dc.l	$01800d00
	dc.l	$01800d00
	dc.l	$01800217
	dc.l	$01800217

RedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800f00					; BrickColorY0X0
	dc.l	$01800d02
	dc.l	$01800f00
	dc.l	$01800d02
	dc.l	$01800f00
	dc.l	$01800d02
	dc.l	$01800f00
	dc.l	$01800d02
	dc.l	$01800e00
	dc.l	$01800b03
	dc.l	$01800e00
	dc.l	$01800b03
	dc.l	$01800e00
	dc.l	$01800b03
	dc.l	$01800217
	dc.l	$01800217

BlueBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180005f					; BrickColorY0X0
	dc.l	$0180004f
	dc.l	$0180005f
	dc.l	$0180004f
	dc.l	$0180005f
	dc.l	$0180004f
	dc.l	$0180005f
	dc.l	$0180004f
	dc.l	$0180004e
	dc.l	$0180003e
	dc.l	$0180004e
	dc.l	$0180003e
	dc.l	$0180004e
	dc.l	$0180003e
	dc.l	$01800217
	dc.l	$01800217

PurpleBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800f0f					; BrickColorY0X0
	dc.l	$01800d0f
	dc.l	$01800f0f
	dc.l	$01800d0f
	dc.l	$01800f0f
	dc.l	$01800d0f
	dc.l	$01800f0f
	dc.l	$01800d0f
	dc.l	$01800e0f
	dc.l	$01800c0e
	dc.l	$01800e0f
	dc.l	$01800c0e
	dc.l	$01800e0f
	dc.l	$01800c0e
	dc.l	$01800217
	dc.l	$01800217

YellowBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800ff0					; BrickColorY0X0
	dc.l	$01800dd2
	dc.l	$01800ff0
	dc.l	$01800dd2
	dc.l	$01800ff0
	dc.l	$01800dd2
	dc.l	$01800ff0
	dc.l	$01800dd2
	dc.l	$01800ee0
	dc.l	$01800cc3
	dc.l	$01800ee0
	dc.l	$01800cc3
	dc.l	$01800ee0
	dc.l	$01800cc3
	dc.l	$01800217
	dc.l	$01800217

LightBlueRaisedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180066d					; BrickColorY0X0
	dc.l	$0180066d
	dc.l	$0180066d
	dc.l	$0180066d
	dc.l	$0180066d
	dc.l	$0180066d
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$0180033b
	dc.l	$01800217
	dc.l	$01800217

RedRaisedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800611					; BrickColorY0X0
	dc.l	$01800611
	dc.l	$01800711
	dc.l	$01800711
	dc.l	$01800811
	dc.l	$01800811
	dc.l	$01800911
	dc.l	$01800911
	dc.l	$01800711
	dc.l	$01800711
	dc.l	$01800601
	dc.l	$01800601
	dc.l	$01800511
	dc.l	$01800511
	dc.l	$01800217
	dc.l	$01800217

DarkBlueRaisedBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800118					; BrickColorY0X0
	dc.l	$01800118
	dc.l	$01800118
	dc.l	$01800118
	dc.l	$01800118
	dc.l	$01800118
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800117
	dc.l	$01800017
	dc.l	$01800017

BlueTopBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

GoldBrick:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800fca					; BrickColorY0X0
	dc.l	$01800fc5
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fa0
	dc.l	$01800fca
	dc.l	$01800fcc
	dc.l	$01800630
	dc.l	$01800530

B2:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

B3:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

B4:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

B5:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

B6:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

B7:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

B8:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180044f					; BrickColorY0X0
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$0180044f
	dc.l	$01800217
	dc.l	$01800217

BeerDarkLeftSide:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800c62					; BrickColorY0X0
	dc.l	$01800fa0
	dc.l	$01800c52
	dc.l	$01800fa0
	dc.l	$01800c62
	dc.l	$01800fa0
	dc.l	$01800c52
	dc.l	$01800fa0
	dc.l	$01800c62
	dc.l	$01800fa0
	dc.l	$01800c52
	dc.l	$01800fa0
	dc.l	$01800c62
	dc.l	$01800fa0
	dc.l	$01800c42
	dc.l	$01800f90

BeerHighlight:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800fe7					; BrickColorY0X0
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fe7
	dc.l	$01800fd7
	dc.l	$01800fd7

BeerMid:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800fb0					; BrickColorY0X0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fb0
	dc.l	$01800fa0
	dc.l	$01800fa0

BeerRightSide:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800fb0					; BrickColorY0X0
	dc.l	$01800f90
	dc.l	$01800fa0
	dc.l	$01800f80
	dc.l	$01800fb0
	dc.l	$01800f90
	dc.l	$01800fa0
	dc.l	$01800f80
	dc.l	$01800fb0
	dc.l	$01800f90
	dc.l	$01800fa0
	dc.l	$01800f80
	dc.l	$01800fb0
	dc.l	$01800f90
	dc.l	$01800fa0
	dc.l	$01800f80

BeerDarkRightSide:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$01800e80					; BrickColorY0X0
	dc.l	$01800d60
	dc.l	$01800e70
	dc.l	$01800c50
	dc.l	$01800e80
	dc.l	$01800d60
	dc.l	$01800e70
	dc.l	$01800c50
	dc.l	$01800e80
	dc.l	$01800d60
	dc.l	$01800e70
	dc.l	$01800c50
	dc.l	$01800e80
	dc.l	$01800d60
	dc.l	$01800e70
	dc.l	$01800c50

BeerFoam:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; hTilePoints
	dc.l	$01800cbb					; BrickColorY0X0
	dc.l	$01800cbb
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800fee
	dc.l	$01800c72
	dc.l	$01800c72

IndestructableGrey:
	dc.l	0							; BrickGfxPtr to bob in CHIP mem


	dc.w	2							; BrickByteWidth
	dc.l	0							; BrickPoints
	dc.l	$0180099a					; BrickColorY0X0
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$0180099a
	dc.l	$01800334
	dc.l	$01800334

BrickAnim0:
	dc.l	0							; BrickGfxPtr
	dc.w	tBob						; AnimType
	dc.l	BrickAnim1					; NextAnimPtr - Address to next anim structure or 0 if no more anim.
BrickAnim1:
	dc.l	0							; BrickGfxPtr
	dc.w	tBob						; AnimType
	dc.l	BrickAnim2					; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickAnim2:
	dc.l	0							; BrickGfxPtr
	dc.w	tBob						; AnimType
	dc.l	BrickAnim3					; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickAnim3:
	dc.l	0							; BrickGfxPtr
	dc.w	tBob						; AnimType
	dc.l	BrickAnim4					; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickAnim4:
	dc.l	0							; BrickGfxPtr
	dc.w	tBob						; AnimType
	dc.l	CLEAR_ANIM					; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
;----------

; This one loops
BrickDropAnim0:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim1				; NextAnimPtr - Address to next anim structure or 0 if no more anim.
BrickDropAnim1:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim2				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickDropAnim2:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim3				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickDropAnim3:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim4				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickDropAnim4:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim5				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickDropAnim5:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim6				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickDropAnim6:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim7				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
BrickDropAnim7:
	dc.l	0							; BrickGfxPtr
	dc.w	tBrickDropBob				; AnimType
	dc.l	BrickDropAnim0				; NextAnimPtr - Address to next anim structure or CLEAR_ANIM.
;-------

CLEAR_ANIM:
	dc.l	0							; BrickGfxPtr
	dc.w	tBob						; AnimType
	dc.l	0							; NULL NextAnimPtr