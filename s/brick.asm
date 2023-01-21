
MAXBRICKROWS	equ	28		; TODO: Adjust later - lower the max brick count
MAXBRICKCOLS	equ	18
MAXBRICKS	equ	MAXBRICKCOLS*MAXBRICKROWS

BrickQueue:
	REPT	MAXBRICKS
		dc.w	0		; Brick code byte - word is used to simplify coding
		dc.w	0		; Position in GAMEAREA - i.e. number of bytes from the start of GAMEAREA table
	ENDR

BrickQueuePtr:	dc.l	BrickQueue	; NOTE: When bricks in queue -> points to adress +1
BricksLeft:	dc.w	0


ResetBrickQueue:
	move.l	#BrickQueue,BrickQueuePtr
	rts

; Initializes the TileMap
SetBobsInTileMap:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*64*4),d0

        lea	WhiteBrick,a0
	move.l	d0,hAddress(a0)
        lea	WhiteBrickD,a0
	move.l	d0,hAddress(a0)



        lea	B1,a0
	move.l	d0,hAddress(a0)
        lea	B2,a0
	move.l	d0,hAddress(a0)
        lea	B3,a0
	move.l	d0,hAddress(a0)
        lea	B4,a0
	move.l	d0,hAddress(a0)
        lea	B5,a0
	move.l	d0,hAddress(a0)
        lea	B6,a0
	move.l	d0,hAddress(a0)
        lea	B7,a0
	move.l	d0,hAddress(a0)
        lea	B8,a0
	move.l	d0,hAddress(a0)
        lea	B9,a0
	move.l	d0,hAddress(a0)
        lea	B10,a0
	move.l	d0,hAddress(a0)
        lea	B11,a0
	move.l	d0,hAddress(a0)
        lea	B12,a0
	move.l	d0,hAddress(a0)
        lea	B13,a0
	move.l	d0,hAddress(a0)
        lea	B14,a0
	move.l	d0,hAddress(a0)




        lea	OrangeBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	CyanBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
	
        lea	GreenBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	WhiteBrickDD,a0
	move.l	d0,hAddress(a0)


        lea	DarkGreyRaisedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	LightGreyRaisedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrightRedRaisedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrightRedTopBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)

	addi.l 	#(ScrBpl*8*4)-16,d0	; Next row in tile sheet - 8 px down, 16 bytes back
        lea	RedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BlueBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	PurpleBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	YellowBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)

        lea	LightBlueRaisedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	RedRaisedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	DarkBlueRaisedBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BlueTopBrick,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)

	rts

; Adds a random number of bricks around a random "cluster point" in GAMEAREA.
AddBricksToQueue:
	move.l	BrickQueuePtr,a0
	lea	GAMEAREA,a1
	lea	ClusterOffsets,a2

	IFEQ	ENABLE_DEBUG_BRICKS
	; Find a random "cluster point" in GAMEAREA

	; Available GAMRAREA row positions
	; 26-5 = 21
	; #%1111	-> 0 to 15
	; #%110		-> 0 to 6
	; Starting from row #4
	bsr	RndW			; Find random row in GAMEAREA
	and.w	#%1101111,d0

	moveq	#0,d1
	move.w	d0,d1
	and.w	#%1111,d1		; 0 to 15
	lsr.w	#4,d0			; 0 to 6
	add.w	d0,d1			; Row found
	add.w	#5,d1			; Add row margin

	mulu.w	#41,d1

	; Available GAMRAREA column positions
	; 33-7 = 26
	; #%11100	-> 0 to 28
	bsr	RndW			; Find random column in GAMEAREA
	and.w	#%11010,d0		; TODO: make it an even number - for now
 	addi.w	#1+6,d0			; Add column margin

	add.w	d0,d1			; Column found
	move.w	d1,d2			; Copy "cluster point"

	bsr	RndB
	and.b	#%00000111,d0
	moveq	#1,d7			; Add 2 bricks minimum
	add.b	d0,d7			; Random number of bricks to add

	lsl.b	#1,d7			; Pick ClusterOffsets in reverse order (due to draw routine issues)
	add.l	d7,a2
	add.l	#2,a2			; Adjust for word pre-decrement
	lsr.b	#1,d7
	
.addLoop
	; bsr	RndB
	; and.b	#%01111111,d0		; 0 to 31 random type of brick
	; addi.b	#$20,d0			; Add offset to get a brick code

	add.w	-(a2),d1		; Add cluster offset for next brick

	tst.b	(a1,d1.w)
	bne.s	.occupied

	bsr	GetNextRandomBrickCode
	move.b	d0,(a0)+		; Brick code
	move.b	#$cd,(a0)+		; Continuation code
	move.w	d1,(a0)+		; Position in GAMEAREA

.occupied
	move.w	d2,d1			; Restore cluster center
	dbf	d7,.addLoop

	move.l	a0,BrickQueuePtr	; Point to 1 beyond the last item
	ENDIF

	IFGT	ENABLE_DEBUG_BRICKS
	move.b	#99,BrickDropMinutes
	
	bsr	AddDebugBricksAscending
	;bsr	AddDebugBricksDescending
	;bsr 	AddDebugBricksForCheckingVposWrap
	;bsr 	AddStaticDebugBricks
	ENDIF

	rts

; Gets next code (offset in TileMap) of random colored brick
; Out	= d0.b Next code.
GetNextRandomBrickCode:
	move.b	NextRandomBrickCode,d0
	addi.b	#1,NextRandomBrickCode

	cmp.b	#$50+MAX_RANDOMBRICKS,NextRandomBrickCode
	bne.s	.inRange
	move.b	#$50,NextRandomBrickCode
.inRange
	rts


; Picks the last item in brick queue and adds it to gamearea map.
; Then draws the brick to screen.
; In:	= a0 Address where BrickQueuePtr is pointing to
ProcessBrickQueue:
	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue

	lea	GAMEAREA,a5
	lea	(a5,d0.w),a5		; Set address to target byte in Game area
	tst.b	(a5)
	bne.s	.clearItem		; Tile already occupied?

	swap	d0
	move.b	d0,1(a5)		; Set last brick code byte in Game area
	lsr.w	#8,d0			; (done in 2 steps for 68000 adressing compatibility)
	move.b	d0,(a5)			; Set first byte

	addq.w	#1,BricksLeft
	bsr	DrawBrickGameAreaRow

.clearItem
	move.l	#0,(a0)			; Clear queue item and update pointer position
	move.l	a0,BrickQueuePtr
.exit
	rts


; Return address to tile given a pointer into the game area.
; In	a5 = pointer to tile code (byte)
; Out 	a1 = address to tile
GetTileFromTileCode:
	moveq	#0,d0

	cmpi.b	#$cd,(a5)		; Hit a Continued (last byte) part of brick?
	beq.s	.hitLastBrickByte
	move.b	(a5),d0
	bra.s	.lookup

.hitLastBrickByte
	move.b	-1(a5),d0
.lookup
	lsl.l	#2,d0			; Convert .b to .l

	lea	TileMap,a1
	add.l	d0,a1
	move.l 	hAddress(a1),a1		; Lookup tile in tile map
	
	rts


; Translates GAMEAREA byte into X,Y for restoring background
; In:	a5 = pointer to first brick-byte in game area (the background area to be restored).
RestoreBackgroundGfx:
	move.l	a5,d0
	sub.l	#GAMEAREA,d0	; Which GAMEAREA byte is it?

	add.l	d0,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a0
	add.l	d0,a0

	move.b	(a0)+,d3	; X pos byte
	subq	#1,d3		; Compensate for empty first byte in GAMEAREA
	moveq	#0,d0
	move.b	(a0),d0		; Y pos byte
	lsl.b	#3,d0		; The row translates to what Y pos?

	move.l 	GAMESCREEN_BITMAPBASE,a6; Set up source/destination
	move.l	d0,d6
	mulu.w	#(ScrBpl*4),d6		; TODO dynamic handling of no. of bitplanes
	add.l	d3,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,a6

	move.l	SCRAPPTR_BITMAPBASE,a5
	lea	hAddress(a5),a5
	lea	(a5,d6.l),a5

	bsr	CopyBrickGraphics

	rts

; If the given tile is a brick then it is removed from game area.
; In:	a5 = pointer to game area tile (byte)
CheckRemoveBrick:
	movem.l	d0-d7/a0-a6,-(SP)

	cmpi.b	#$20,(a5)	; Is this tile a brick?
	blo.s	.nonBrick

	cmpi.b	#$cd,(a5)	; Hit a Continued (last byte) part of brick?
	bne.s	.clearBrickInGameArea
	subq.l	#1,a5

.clearBrickInGameArea
	move.b	#0,(a5)		; Remove primary collision brick byte from game area
	move.b	#0,1(a5)	; Remove last brick byte from game area

	lea	SFX_BRICKSMASH_STRUCT,a0
	bsr     PlaySample

	bsr	DrawBrickGameAreaRow
	bsr	RestoreBackgroundGfx

	subq.w	#1,BricksLeft
	bra.s	.exit
.nonBrick
	lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
.exit
	movem.l	(SP)+,d0-d7/a0-a6
	rts

; Restores game screen and resets brick counter.
; Any remaining bricks have their scrap area copied to game screen.
ResetBricks:
	lea	GAMEAREA,a0

	move.w	#41*32-1,d7
.restoreLoop
	move.b	(a0)+,d0
	beq.s	.noRestore
	move.l	a0,a5
	bsr.s	CheckRemoveBrick
.noRestore
	dbf	d7,.restoreLoop

	move.w	#0,BricksLeft

	rts

; In:   a5 = Source (planar)
; In:   a6 = Destination game screen
CopyBrickGraphics:
	move.w  0*40(a5),0*40(a6)
        move.w  1*40(a5),1*40(a6)
        move.w  2*40(a5),2*40(a6)
        move.w  3*40(a5),3*40(a6)

	move.w  4*40(a5),4*40(a6)
        move.w  5*40(a5),5*40(a6)
        move.w  6*40(a5),6*40(a6)
        move.w  7*40(a5),7*40(a6)

	move.w  8*40(a5),8*40(a6)
        move.w  9*40(a5),9*40(a6)
        move.w  10*40(a5),10*40(a6)
        move.w  11*40(a5),11*40(a6)

	move.w  12*40(a5),12*40(a6)
        move.w  13*40(a5),13*40(a6)
        move.w  14*40(a5),14*40(a6)
        move.w  15*40(a5),15*40(a6)

	move.w  16*40(a5),16*40(a6)
        move.w  17*40(a5),17*40(a6)
        move.w  18*40(a5),18*40(a6)
        move.w  19*40(a5),19*40(a6)
        
	move.w  20*40(a5),20*40(a6)
        move.w  21*40(a5),21*40(a6)
        move.w  22*40(a5),22*40(a6)
        move.w  23*40(a5),23*40(a6)

	move.w  24*40(a5),24*40(a6)
        move.w  25*40(a5),25*40(a6)
        move.w  26*40(a5),26*40(a6)
        move.w  27*40(a5),27*40(a6)

	move.w  28*40(a5),28*40(a6)
        move.w  29*40(a5),29*40(a6)
        move.w  30*40(a5),30*40(a6)
        move.w  31*40(a5),31*40(a6)

        rts


; Generates brick-stuctures with random colors
GenerateBricks:
	lea	RandomBricks,a0
	lea	RandomBrickStructs,a1

	move.l	#MAX_RANDOMBRICKS-1,d7
.brickLoop
	move.l	a1,(a0)+

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*64*4),d0
	move.l	d0,(a1)				; Set address to brick-gfx
	add.l	#hBrickColorY0X0,a1		; Then target color instructions

	bsr	RndW				; Random base color
	and.w	#$0fff,d0
	move.w	d0,RandomColor
	lea	RandomColor,a6

	moveq.l	#0,d2				; Iterate over rasterlines
.rl
		cmpi.b	#8,d2
		beq.w	.doneBrick

		cmpi.b	#7,d2
		bne.s	.drawCalculatedColors

		move.l	#COLOR00<<16+$217,(a1)+	; Set shadow color
		move.l	#COLOR00<<16+$217,(a1)+
		
		bra	.doneRl

.drawCalculatedColors
		cmpi.b	#3,d2			; Assuming classic horizontal brick orientation
		bls.s	.upperBrickColor
		bhi.s	.lowerBrickColor

.upperBrickColor
	; First colorword
		move.w	#COLOR00,(a1)+		; Set color for next 8 pixels
		move.w	(a6),(a1)+

	; Second colorword
		move.w	#COLOR00,(a1)+

		move.b	(a6),d5
		beq.s	.utGreen
		sub.b	#1,d5
.utGreen
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5
		beq.s	.doneUpperTile
		sub.b	#1,d5
.doneUpperTile
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5
		or.b	d6,d5

		move.b	d5,(a1)+	; Write BG components


	bra	.doneRl

		
.lowerBrickColor
	; First colorword
		move.w	#COLOR00,(a1)+


		move.b	(a6),d5
		sub.b	#2,d5
		bpl.s	.ltGreen
		moveq	#0,d5
.ltGreen
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5
		sub.b	#2,d5
		bpl.s	.ltBlue
		
		moveq	#0,d5
.ltBlue
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5
		sub.b	#2,d5
		bpl.s	.combine
		
		moveq	#0,d5
.combine
		or.b	d6,d5

		move.b	d5,(a1)+	; Write BG components

	; Second colorword
		move.w	#COLOR00,(a1)+

		move.b	(a6),d5
		sub.b	#3,d5
		bpl.s	.ltGreen2
		moveq	#0,d5
.ltGreen2
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5
		sub.b	#3,d5
		bpl.s	.ltBlue2
		
		moveq	#0,d5
.ltBlue2
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5
		sub.b	#2,d5
		bpl.s	.combine2
		
		moveq	#0,d5
.combine2
		or.b	d6,d5

		move.b	d5,(a1)+	; Write BG components

.doneRl
		addq.b	#1,d2
		bra	.rl
	
.doneBrick
	dbf	d7,.brickLoop

	rts