NoVerticalPosWait:	dc.b	0	; Flag used by blinkbricks
	even


RandomBrickStructs:
	REPT	MAX_RANDOMBRICKS
		dc.l	-1
		dc.w	-1
		dc.w	-1
		dc.w	2		; hBrickByteWidth
		dc.l	1		; hBrickPoints
		dc.l	0		; hBrickColorY0X0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
	ENDR

; ----- This is the tile map referencing tiles/bricks in an UNBROKEN BYTE SEQUENCE
TileMap:
		dc.l	0		; 0
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
		dc.l	WhiteBrick	; $10
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
		dc.l	DarkBlueRaisedBrick	; $20
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

		dc.l	IndestructableGrey	; $30
StaticBrickMapEND:

; This holds pointers to generated bricks.
RandomBricks:
	REPT	MAX_RANDOMBRICKS
		dc.l	0		; Address to a brickstructure
	ENDR

; ----- END of tilemap UNBROKEN BYTE SEQUENCE


; ===== Single tiles 8x8 pixels =====
GreyCol:
	dc.l	-1		; hAddress to bob in CHIP mem - not used
	dc.w	-1		; hBrickModulo - not used
	dc.w	-1		; hBrickBlitSize - not used
	dc.w	1		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800555	; hBrickColorY0X0
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
	dc.l	-1		; hAddress to bob in CHIP mem - not used
	dc.w	-1		; hBrickModulo - not used
	dc.w	-1		; hBrickBlitSize - not used
	dc.w	1		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800161	; hBrickColorY0X0
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
	dc.l	-1		; hAddress to bob in CHIP mem - not used
	dc.w	-1		; hBrickModulo - not used
	dc.w	-1		; hBrickBlitSize - not used
	dc.w	1		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800611	; hBrickColorY0X0
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
	dc.l	-1		; hAddress to bob in CHIP mem - not used
	dc.w	-1		; hBrickModulo - not used
	dc.w	-1		; hBrickBlitSize - not used
	dc.w	1		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800777	; hBrickColorY0X0
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
	dc.l	-1		; hAddress to bob in CHIP mem - not used
	dc.w	-1		; hBrickModulo - not used
	dc.w	-1		; hBrickBlitSize - not used
	dc.w	1		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800227	; hBrickColorY0X0
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
	dc.l	-1		; hAddress to bob in CHIP mem - not used
	dc.w	-1		; hBrickModulo - not used
	dc.w	-1		; hBrickBlitSize - not used
	dc.w	1		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800333	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	1		; hBrickPoints
	dc.l	$01800fff	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800bbb	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800777	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800fa0	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$018000ff	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$018000f0	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800877	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800bbb	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800a00	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800e00	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800f00	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180005f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800f0f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800ff0	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180066d	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800611	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800118	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800fca	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180044f	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800c62	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800fe7	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800fb0	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800fb0	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800e80	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hTilePoints
	dc.l	$01800cbb	; hBrickColorY0X0
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
	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$0180099a	; hBrickColorY0X0
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
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	BrickAnim1	; hNextAnimStruct - Address to next anim structure or 0 if no more anim.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickAnim1:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	BrickAnim2	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickAnim2:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	BrickAnim3	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickAnim3:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	BrickAnim4	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickAnim4:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	CLEAR_ANIM	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
;----------

BrickDropAnim0:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim1	; hNextAnimStruct - Address to next anim structure or 0 if no more anim.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickDropAnim1:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim2	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickDropAnim2:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim3	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickDropAnim3:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim4	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize
BrickDropAnim4:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim5	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize

BrickDropAnim5:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim6	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize

BrickDropAnim6:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim7	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize

BrickDropAnim7:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBrickDropBob	; hType
	dc.l	BrickDropAnim0	; hNextAnimStruct - Address to next anim structure or CLEAR_ANIM.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize

;-------




CLEAR_ANIM:
	dc.l	0		; hAddress
	dc.l	0		; hSize +/- height/width
	dc.l	tBob		; hType
	dc.l	0		; hNextAnimStruct - Address to next anim structure or 0 if no more anim.
	dc.l	0		; hPlayerScore
	dc.l	0		; hPlayerBat
	dc.l	0		; hSprBobMaskAddress
	dc.l	DEFAULT_MASK	; hBobBlitMasks

	dc.w	0		; hSprBobTopLeftXPos
	dc.w	0		; hSprBobTopLeftYPos
	dc.w	0		; hSprBobBottomRightXPos
	dc.w	0		; hSprBobBottomRightYPos
	dc.w    0		; hSprBobXCurrentSpeed
	dc.w    0		; hSprBobYCurrentSpeed
	dc.w    0		; hSprBobXSpeed
	dc.w    0		; hSprBobYSpeed
	dc.w	8		; hSprBobHeight
	dc.w	16		; hSprBobWidth
	dc.w	0		; hSprBobAccentCol1
	dc.w 	0		; hSprBobAccentCol2
	dc.w	0		; hBobLeftXOffset
	dc.w	0		; hBobRightXOffset
	dc.w	0		; hBobTopYOffset
	dc.w	0		; hBobBottomYOffset
	dc.w	RL_SIZE-2	; hBobBlitSrcModulo
	dc.w	RL_SIZE-2	; hBobBlitDestModulo
	dc.w	(64*8*4)+1	; hBobBlitSize


BlinkOffBricks:
	REPT	MAXBLINKBRICKS

	dc.l	0		; hAddress to bob in CHIP mem
	dc.w	RL_SIZE-2	; hBrickModulo - [16px] 16 bits / 8 = 2 bytes to blit per line
	dc.w	(64*8*4)+1	; hBrickBlitSize - 8 lines, 1 words to blit horizontally
	dc.w	2		; hBrickByteWidth
	dc.l	0		; hBrickPoints
	dc.l	$01800000	; hBrickColorY0X0
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000
	dc.l	$01800000

	ENDR