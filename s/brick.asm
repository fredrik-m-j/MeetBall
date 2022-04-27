BricksLeft:	dc.w	0

BrickQueuePtr:	dc.l	BrickQueue
BrickQueue:
	REPT	50
		dc.w	0	; Brick code byte - word is used to simplify coding
		dc.w	0	; Byte number (position) in Game area
	ENDR

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
	add.w	d0,d1

	mulu.w	#41,d1			; Row found
	addi.w	#41*5,d1		; Add row margin

	; Available GAMRAREA column positions
	; 33-7 = 26
	; #%11100	-> 0 to 28
	bsr	RndW			; Find random column in GAMEAREA
	and.w	#%11010,d0		; TODO: Cookie-cut blit - for now make it an even number
 
	add.w	d0,d1			; Column found
	addi.w	#1+6,d1			; Add column margin

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
	bsr	RndB

	and.b	#%00011111,d0		; 0 to 31 random type of brick
	addi.b	#$20,d0			; Add offset to get a brick code

	add.w	-(a2),d1		; Add cluster offset for next brick

	tst.b	(a1,d1.w)
	bne.s	.occupied

	move.b	d0,(a0)+		; Brick code
	move.b	#$cd,(a0)+		; Continuation code
	move.w	d1,(a0)+		; Position in GAMEAREA
	move.l	a0,BrickQueuePtr

.occupied
	move.w	d2,d1			; Restore cluster center
	dbf	d7,.addLoop


	IFGT	ENABLE_DEBUG_BRICKS
	bsr	AddDebugBricks
	ENDIF

	rts

; Picks the last item in brick queue and adds it to gamearea map.
; Then draws the brick to screen.
ProcessBrickQueue:
	move.l	BrickQueuePtr,a0
	cmpa.l	#BrickQueue,a0		; Is queue empty?
	beq.s	.exit

	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue

	lea	GAMEAREA,a5
	lea	(a5,d0.w),a5		; Set address to target byte in Game area
	tst.b	(a5)
	bne.s	.clearItem		; Tile already occupied?

	lea	COLOR_TABLE,a6
	lea	(a6,d0.w),a6
	lea	(a6,d0.w),a6		; Set address to target word in color table

	swap	d0
	move.b	d0,1(a5)		; Set last brick code byte in Game area
	lsr.w	#8,d0			; (done in 2 steps for 68000 adressing compatibility)
	move.b	d0,(a5)			; Set first byte

        bsr	RndW			; Create random color
	and.w	#$0fff,d0

	move.w	d0,(a6)

	addq.w	#1,BricksLeft

	bsr	DrawGameAreaRowWithNewBrick

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


; Specialized blit-routine for bricks that does 2 blits.
; 1 Blit for storing background gfx in scrap area and 1 blit for brick-drawing.
; In:	a2 = address to brick structure to be blitted
; In:	d0.l = current Y position / rasterline
; In:	d3.b = current X position byte
BlitTileToGameScreen:
	tst.l	hAddress(a2)		; Anything to blit?
	bmi.w	.exit

	movem.l	d0/d3/d5-d6/a5-a6,-(SP)

        lea 	CUSTOM,a6

	move.l 	GAMESCREEN_BITMAPBASE,d5; Set up blit source/destination
	move.l	d0,d6
	subi.w	#FIRST_Y_POS,d6
	mulu.w	#(ScrBpl*4),d6		; TODO dynamic handling of no. of bitplanes
	add.b	d3,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,d5

	lea	BLITSCRAPPTR,a5
	move.l	hAddress(a5),a5
	lea	(a5,d6.l),a5

	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)		; Simple copy blit with no shift
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	d5,BLTAPTH(a6)
	move.l 	a5,BLTDPTH(a6)
	move.w 	hTileBlitModulo(a2),BLTAMOD(a6)	; Gamescreen,scrap and bob using same dimensions = same modulo
	move.w 	hTileBlitModulo(a2),BLTDMOD(a6)

	move.w 	hTileBlitSize(a2),BLTSIZE(a6)

	WAITBLIT

	move.l 	hAddress(a2),BLTAPTH(a6)
	move.l 	d5,BLTDPTH(a6)
	move.w 	hTileBlitModulo(a2),BLTAMOD(a6)	; Gamescreen,scrap and bob using same dimensions = same modulo
	move.w 	hTileBlitModulo(a2),BLTDMOD(a6)

	move.w 	hTileBlitSize(a2),BLTSIZE(a6)

	movem.l	(SP)+,d0/d3/d5-d6/a5-a6
.exit
        rts


; Blit-routine made for tile/game area.
; In:	d0.l = current Y position / rasterline
; In:	d3.b = current X position byte
BlitRestoreGameScreen:
        lea 	CUSTOM,a6

	move.l 	GAMESCREEN_BITMAPBASE,d5; Set up blit destination
	move.l	d0,d6
	subi.w	#FIRST_Y_POS,d6
	mulu.w	#(ScrBpl*4),d6		; TODO dynamic handling of no. of bitplanes
	add.b	d3,d6			; Add byte (x pos) to longword (y pos)
	add.l	d6,d5

	lea	BLITSCRAPPTR,a5
	move.l	hAddress(a5),a5
	lea	(a5,d6.l),a5

	lea	WhiteBrick,a2		; Use any brick to get modulo

	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)		; Simple copy blit with no shift
	move.w 	#$ffff,BLTAFWM(a6)
	move.w 	#$ffff,BLTALWM(a6)
	move.l 	a5,BLTAPTH(a6)
	move.l 	d5,BLTDPTH(a6)
	move.w 	hTileBlitModulo(a2),BLTAMOD(a6)	; Gamescreen and scrap using same dimensions = same modulo
	move.w 	hTileBlitModulo(a2),BLTDMOD(a6)

	move.w 	hTileBlitSize(a2),BLTSIZE(a6)
.exit
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

	bsr	DrawGameAreaRowWithDeletedBrick
	bsr	BlitRestoreBrick

	subq.w	#1,BricksLeft
	bra.s	.exit
.nonBrick
	lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
.exit
	movem.l	(SP)+,d0-d7/a0-a6
	rts


; Translates GAMEAREA byte into blittable X,Y for restoring background
; In:	a5 = pointer to first brick-byte in game area (the background area to be restored).
BlitRestoreBrick:
	move.l	a5,d0
	sub.l	#GAMEAREA,d0	; Which GAMEAREA byte is it?
	divu	#41,d0		; What GAMEAREA row?

	swap	d0
	moveq	#0,d3
	move.w	d0,d3		; Keep remainder X pos byte
	subq	#1,d3		; Compensate for empty first byte in GAMEAREA
	swap	d0

	and.l	#$0000ffff,d0
	lsl.b	#3,d0		; The row translates to what Y pos?
	addi.w	#FIRST_Y_POS,d0	; ... and exact raster line

	bsr	BlitRestoreGameScreen

	rts

; Restores game screen and resets brick counter.
; Any remaining bricks have their scrap area blitted to game screen.
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


AddDebugBricks:

; LEFT to RIGHT
; 	move.l	#1,d4
; .l0
; 	move.w	d4,d5
; 	mulu.w	#41,d5

; 		move.l	#17,d7
; .l1
; 		move.w	#$36cd,(a0)+
; 		move.w	d7,d6
; 		lsl.w	#1,d6		; d7 byte
; 		add.w	#41*6+1+2,d6
; 		add.w	d5,d6		; d5 row
; 		move.w	d6,(a0)+
; 		dbf	d7,.l1
; 	dbf	d4,.l0

; RIGHT to LEFT
	move.l	#1,d4
.l0
	move.w	d4,d5
	mulu.w	#41,d5

		move.l	#0,d7
.l1
		; move.w	#$36cd,(a0)+
		move.w	#$20cd,(a0)+
		move.w	d7,d6
		lsl.w	#1,d6		; d7 byte
		add.w	#41*3+1+2,d6
		add.w	d5,d6		; d5 row
		move.w	d6,(a0)+

		addq	#1,d7
		; cmpi.b	#18,d7
		cmpi.b	#1,d7
		blo.s	.l1
		
	dbf	d4,.l0


	move.l	a0,BrickQueuePtr

	rts