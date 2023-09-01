ResetBricks:
	move.l	#AddBrickQueue,AddBrickQueuePtr
	move.l	#DirtyRowQueue,DirtyRowQueuePtr

	move.l	#AllBricks,AllBricksPtr

	clr.l	BlinkBrick
	clr.l	BlinkBrickGameareaPtr
	clr.b	BlinkBrickRow
	clr.l	BlinkBrickGameareaRowstartPtr

	clr.w	BricksLeft
	rts

; Initializes the TileMap
InitTileMap:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*64*4),d0

        lea	WhiteBrick,a0
	move.l	d0,hAddress(a0)
        lea	WhiteBrickD,a0
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

	move.l	d0,IndestructableGrey
	move.l	d0,CLEAR_ANIM
	move.l	d0,GoldBrick

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
        lea	BrickAnim0,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickAnim1,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickAnim2,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickAnim3,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickAnim4,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*80*4),d0

        lea	BrickDropAnim0,a0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim1,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim2,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim3,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim4,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim5,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim6,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)
        lea	BrickDropAnim7,a0
	addq.l	#2,d0
	move.l	d0,hAddress(a0)

	rts

; Adds a random number of bricks around a random "cluster point" in GAMEAREA.
AddBricksToQueue:
	move.l	AddBrickQueuePtr,a0
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
	add.w	d0,d1			; Row found
	addq.w	#5,d1			; Add row margin

	; move.l	#12,d1		; DEBUG row

	mulu.w	#41,d1

	; Available GAMRAREA column positions
	; 33-7 = 26
	; #%11100	-> 0 to 28
	bsr	RndW			; Find random column in GAMEAREA
	and.w	#%11010,d0		; TODO: make it an even number - for now
 	addq.w	#1+6,d0			; Add column margin

	; move.l	#31,d0		; DEBUG col

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
	add.w	-(a2),d1		; Add cluster offset for next brick

	tst.b	(a1,d1.w)
	bne.s	.occupied

	btst	#0,d7
	beq.s	.addPredefinedBrick

	bsr	GetNextRandomBrickCode
	bra.s	.addToQueue
.addPredefinedBrick
	bsr	RndB
	and.b	#%00011111,d0		; 0 to 31 random predefined brick
	addi.b	#$20,d0			; Add offset to get a brick code

.addToQueue
	move.b	d0,(a0)+		; Brick code
	move.b	#BRICK_2ND_BYTE,(a0)+	; Continuation code
	move.w	d1,(a0)+		; Position in GAMEAREA

	move.l	#BrickDropAnim0,a4
	lea	(a1,d1.l),a5
	bsr	AddBrickAnim

.occupied
	move.w	d2,d1			; Restore cluster center
	dbf	d7,.addLoop

	move.l	a0,AddBrickQueuePtr	; Point to 1 beyond the last item

	cmpa.l	#AddBrickQueue,a0	; Cornercase - no available space for drop?
	beq.s	.done

	move.b	#1,IsDroppingBricks	; Give some time to animate
	bsr	SpawnEnemies
.done
	rts


; Gets next code (offset in TileMap) of random colored brick
; Out	= d0.b Next code.
GetNextRandomBrickCode:
	move.b	NextRandomBrickCode,d0
	addq.b	#1,NextRandomBrickCode

	cmp.b	#$50+MAX_RANDOMBRICKS,NextRandomBrickCode
	bne.s	.inRange
	move.b	#$50,NextRandomBrickCode
.inRange
	rts

ProcessAllAddBrickQueue:
.l
	move.l	AddBrickQueuePtr,a0
	lea	AddBrickQueue,a1
	cmpa.l	a0,a1
	beq.s	.exit

	bsr	ProcessAddBrickQueue
	bra.s	.l
.exit
	rts

; Picks the last item in brick queue and adds it to gamearea map.
; Then draws the brick to screen.
; In:	= a0 Address where AddBrickQueuePtr is pointing to
ProcessAddBrickQueue:
	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue
	move.l	d0,d1

	lea	GAMEAREA,a5
	lea	(a5,d0.w),a5		; Set address to target byte in Game area
	tst.b	(a5)
	bne.s	.clearItem		; Tile already occupied?

	swap	d0
	move.b	d0,1(a5)		; Set last brick code byte in Game area
	lsr.w	#8,d0			; (done in 2 steps for 68000 adressing compatibility)
	move.b	d0,(a5)			; Set first byte

	move.l	#BrickAnim0,a4
	bsr	ReplaceAnim		; Dropping-animation replaced by fresh-brick-animation

	cmpi.b	#INDESTRUCTABLEBRICK,(a5)
	beq.s	.indestructible

	move.l	AllBricksPtr,a1
	move.l	d1,(a1)+		; Copy to AllBricks
	move.l	a1,AllBricksPtr

	cmpa.l	#AllBricksEnd,a1
	bne.s	.ok
	move.l	#AllBricks,AllBricksPtr
.ok
	addq.w	#1,BricksLeft
.indestructible
	bsr	DrawBrickGameAreaRow

.clearItem
	clr.l	(a0)			; Clear queue item and update pointer position
	move.l	a0,AddBrickQueuePtr

	cmpa.l	#AddBrickQueue,a0	; Is queue empty now?
	bne.s	.sfx
	tst.l	BlinkBrick		; Already have one?
	bne.s	.sfx

	bsr	CreateBlinkBrick
.sfx
	lea	SFX_BRICKDROP_STRUCT,a0
	bsr     PlaySample

	rts

; Picks the last item(s) in tile queue and adds to GAMEAREA.
; Then puts an item in DirtyRowQueue for screen update.
; In:	= a0 Address where queue pointer is pointing to.
ProcessAddTileQueue:
	lea	AllBalls+hAllBallsBall0,a1
	move.l	(a1),a1

	move.w	hSprBobTopLeftYPos(a1),d0
	lsr.w	#VC_POW,d0		; To screen coord
	add.w	#BallDiameter/2,d0	; Compare with center ball
	lsr.w	#3,d0			; Row
	move.w	d0,d1


	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue

	swap	d0
	lsr.w	#8,d0			; What GAMEAREA row is it?

	cmp.w	d0,d1			; Risk of ball getting trapped?
	beq	.exit

	moveq	#0,d1
	move.b	d0,d1

        lea     GAMEAREA_ROW_LOOKUP,a2
        add.b   d1,d1
        add.b   d1,d1
        add.l   d1,a2			; Row pointer found

	move.l	DirtyRowQueuePtr,a1	; Add dirty row for later gfx update
	move.w	d0,(a1)+
	move.l	(a2),(a1)+
	move.l	a1,DirtyRowQueuePtr

	move.l	(a0),d1			; Get last item in queue
.rowLoop
	lea	GAMEAREA,a1
	lea	(a1,d1.w),a1		; Set address to target byte in Game area
	tst.b	(a1)
	bne.s	.clearItem		; Tile already occupied?

	swap	d1
	move.b	d1,(a1)			; Set tile byte in GAMEAREA

.clearItem
	clr.l	(a0)			; Clear queue item and update pointer position
	move.l	a0,AddTileQueuePtr

	cmpa.l	#AddTileQueue,a0	; Is queue empty?
	beq	.exit

	subq.l	#4,a0
	move.l	(a0),d1			; Get next last item in queue

	swap	d1
	ror.w	#8,d1			; What GAMEAREA row is it?

	cmp.b	d0,d1
	bne	.exit

	ror.w	#8,d1
	swap	d1

	bra	.rowLoop
.exit
	rts

; Picks the last item(s) in tile queue and removes from GAMEAREA.
; Then puts an item in DirtyRowQueue for screen update.
; In:	= a0 Address where queue pointer is pointing to.
ProcessRemoveTileQueue:
	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue

	swap	d0			; What GAMEAREA row is it?

	moveq	#0,d1
	move.b	d0,d1

        lea     GAMEAREA_ROW_LOOKUP,a2
        add.b   d1,d1
        add.b   d1,d1
        add.l   d1,a2			; Row pointer found

	move.l	DirtyRowQueuePtr,a1	; Add dirty row for later gfx update
	move.w	d0,(a1)+
	move.l	(a2),(a1)+
	move.l	a1,DirtyRowQueuePtr

	move.l	(a0),d1			; Get last item in queue
.rowLoop
	lea	GAMEAREA,a1
	lea	(a1,d1.w),a1		; Set address to target byte in Game area
	clr.b	(a1)			; Remove tile byte in GAMEAREA

	clr.l	(a0)			; Clear queue item and update pointer position
	move.l	a0,RemoveTileQueuePtr

	cmpa.l	#RemoveTileQueue,a0	; Is queue empty?
	beq	.exit

	subq.l	#4,a0
	move.l	(a0),d1			; Get next last item in queue

	swap	d1
	cmp.b	d0,d1
	bne	.exit

	swap	d1

	bra	.rowLoop
.exit
	rts

; Updates copperlist for dirty GAMEAREA row.
; In:	a0 = Address where DirtyRowQueuePtr is pointing to
ProcessDirtyRowQueue:
	subq.l	#6,a0			; Set pointer to last item in queue and clear below

	move.w	(a0),d7			; Load registers
	clr.w	(a0)
	
	move.l	2(a0),a4
	clr.l	2(a0)
	
	move.l	a0,DirtyRowQueuePtr	; Done copying from queue - update pointer

	move.l	a4,a0

	moveq	#0,d0
	move.b	d7,d0
	add.b	d0,d0
	add.b	d0,d0
	lea	GAMEAREA_ROWCOPPERPTRS,a1
	move.l	(a1,d0),a1

	bsr	UpdateCopperlist
	bsr	AddCopperJmp
	rts


; Translates GAMEAREA byte into X,Y for restoring background
; In:	a5 = pointer to first brick-byte in game area (the background area to be restored).
RestoreBackgroundGfx:
	move.l	a5,d0
	sub.l	#GAMEAREA,d0		; Which GAMEAREA byte is it?

	add.l	d0,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a0
	add.l	d0,a0

	moveq	#0,d0
	moveq	#0,d3
	move.b	(a0)+,d3		; X pos byte
	subq.b	#1,d3			; Compensate for empty first byte in GAMEAREA
	move.b	(a0),d0			; Y pos byte
	lsl.b	#3,d0			; The row translates to what Y pos?


	movem.l	d6/a6,-(SP)

	mulu.w	#(ScrBpl*4),d0		; TODO dynamic handling of no. of bitplanes
	add.l	d3,d0			; Add byte (x pos) to longword (y pos)
	add.l	d0,a1

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a3
	lea	(a3,d0.l),a3

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6	; Set up destination
	lea	(a6,d0.l),a6
	bsr	CopyBrickGraphics

	move.l 	GAMESCREEN_BITMAPBASE,a6	; Set up destination
	lea	(a6,d0.l),a6
	bsr	CopyBrickGraphics

	movem.l	(SP)+,d6/a6

	rts

; If the given tile is a brick and destructible then it is removed from game area.
; Makes a new blinking brick if hitting one.
; In:   a0 = address to ball structure (for powerup direction & score)
; In:	a5 = pointer to game area tile (byte)
CheckBrickHit:
	movem.l	d0-d7/a0-a6,-(sp)

	cmpi.b	#$20,(a5)		; Is this tile a brick?
	blo	.bounce
	cmpi.b	#BRICK_2ND_BYTE,(a5)	; Hit a last byte part of brick?
	bne.s	.checkBrick
	subq.l	#1,a5

.checkBrick
	cmpi.b	#INDESTRUCTABLEBRICK,(a5)
	bne.s	.destructable
	move.l	#BrickAnim0,a4
	bsr	AddBrickAnim

	lea	SFX_BOUNCEMETAL_STRUCT,a0
	bsr     PlaySample
	bra.s	.exit

.destructable
	move.l	hPlayerBat(a0),a3
	move.l	hPlayerScore(a3),a3
	; move.l  hBrickPoints(a1),d0	; Use hBrickPoints instead???
	add.l	#1,(a3)			; add point
	bsr     SetDirtyScore

	clr.b	(a5)			; Remove primary collision brick byte from game area
	clr.b	1(a5)			; Clear last brick byte from game area

	bsr     CheckAddPowerup

	lea	SFX_BRICKSMASH_STRUCT,a0
	bsr     PlaySample

	subq.w	#1,BricksLeft

	bsr	GetAddressForCopperChanges	; TODO: optimize? We have a lookuptable for GAMEAREA rows

	move.l	#DirtyRowQueue,a2
	move.l	DirtyRowQueuePtr,a3
.findDirtyRowLoop

	cmpa.l	a2,a3			; End of queue?
	beq.s	.addDirtyRow

	move.w	(a2)+,d6
	sub.w	d7,d6
	beq.s	.markedAsDirty		; Already marked as dirty

	addq.l	#4,a2
	bra.s	.findDirtyRowLoop

.addDirtyRow
	move.w	d7,(a3)+
	move.l	a0,(a3)+
	move.l	a3,DirtyRowQueuePtr	; Point to 1 beyond the last item

.markedAsDirty
	bsr	RestoreBackgroundGfx

	cmp.l	BlinkBrickGameareaPtr,a5	; Removed blinking brick?
	bne.s	.exit
	tst.w	BricksLeft
	beq.s	.exit

	bsr	CreateBlinkBrick
	
	bra.s	.exit
.bounce
	lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
.exit
	movem.l	(sp)+,d0-d7/a0-a6
	rts


CreateBlinkBrick:
	lea	AllBricks,a0
	lea	GAMEAREA,a1
.findBlinkLoop
	move.l	(a0)+,d0
	beq.s	.findBlinkLoop

	move.b	(a1,d0.w),d1
	beq.s	.notFound

	subq.l	#4,a0
	move.b	d1,(a0)		; Update brickcode since AllBricks is left dirty between levels

	move.l	a0,BlinkBrick
	bsr	StoreBlinkBrickRow
	bsr	InitBlinkColors

	bra.s	.exit
.notFound
	clr.l	-4(a0)
	bra.s	.findBlinkLoop
.exit
	rts


; Restores game screen and resets brick counter.
RemoveAllBricks:
	lea	GAMEAREA,a0

	move.w	#41*32-1,d7
.restoreLoop
	move.b	(a0)+,d0
	beq.s	.noRestore
	move.l	a0,a5
	bsr	RemoveBrick
.noRestore
	dbf	d7,.restoreLoop
	rts

; If the given tile is a brick then it is removed from game area.
; In:	a5 = pointer to game area tile (byte)
RemoveBrick:
	movem.l	d0-d7/a0-a6,-(sp)

	cmpi.b	#$20,(a5)	; Is this tile a brick?
	blo.s	.exit
	cmpi.b	#$ff,(a5)	; Hit a Continued (last byte) part of brick?
	bne.s	.clearBrickInGameArea
	subq.l	#1,a5
.clearBrickInGameArea
	clr.b	(a5)		; Remove primary collision brick byte from game area
	clr.b	1(a5)		; Remove last brick byte from game area

	bsr	RestoreBackgroundGfx
	bsr	DrawBrickGameAreaRow
.exit
	movem.l	(sp)+,d0-d7/a0-a6
	rts


; In:   a3 = Source (planar)
; In:   a6 = Destination game screen
CopyBrickGraphics:
	move.w  0*40(a3),0*40(a6)
        move.w  1*40(a3),1*40(a6)
        move.w  2*40(a3),2*40(a6)
        move.w  3*40(a3),3*40(a6)

	move.w  4*40(a3),4*40(a6)
        move.w  5*40(a3),5*40(a6)
        move.w  6*40(a3),6*40(a6)
        move.w  7*40(a3),7*40(a6)

	move.w  8*40(a3),8*40(a6)
        move.w  9*40(a3),9*40(a6)
        move.w  10*40(a3),10*40(a6)
        move.w  11*40(a3),11*40(a6)

	move.w  12*40(a3),12*40(a6)
        move.w  13*40(a3),13*40(a6)
        move.w  14*40(a3),14*40(a6)
        move.w  15*40(a3),15*40(a6)

	move.w  16*40(a3),16*40(a6)
        move.w  17*40(a3),17*40(a6)
        move.w  18*40(a3),18*40(a6)
        move.w  19*40(a3),19*40(a6)

	move.w  20*40(a3),20*40(a6)
        move.w  21*40(a3),21*40(a6)
        move.w  22*40(a3),22*40(a6)
        move.w  23*40(a3),23*40(a6)

	move.w  24*40(a3),24*40(a6)
        move.w  25*40(a3),25*40(a6)
        move.w  26*40(a3),26*40(a6)
        move.w  27*40(a3),27*40(a6)

	move.w  28*40(a3),28*40(a6)
        move.w  29*40(a3),29*40(a6)
        move.w  30*40(a3),30*40(a6)
        move.w  31*40(a3),31*40(a6)

        rts


; Generates brick-stuctures with random colors
GenerateBricks:
	lea	RandomBricks,a0
	lea	RandomBrickStructs,a1

	move.l	#MAX_RANDOMBRICKS-1,d7
.brickLoop
	move.l	a1,(a0)+

	bsr	RndW				; Random base color
	and.w	#$0fff,d0
	move.w	d0,RandomColor
	lea	RandomColor,a6

	move.l	BOBS_BITMAPBASE,d1

	cmpi.w	#$8aa,d0
	blo.s	.OneDarker
	addi.l 	#(ScrBpl*64*4+16),d1
	bra.s	.setBob
.OneDarker
; 	cmpi.w	#$999,d0
; 	blo.s	.TwoDarker
; 	addi.l 	#(ScrBpl*64*4+18),d1
; 	bra.s	.setBob
; .TwoDarker
; 	cmpi.w	#$888,d0
; 	blo.s	.ThreeDarker
; 	addi.l 	#(ScrBpl*64*4+20),d1
; 	bra.s	.setBob
; .ThreeDarker
	addi.l 	#(ScrBpl*64*4+18),d1
.setBob
	move.l	d1,hAddress(a1)			; Set address to brick-gfx
	add.l	#hBrickColorY0X0,a1		; Then target color instructions


	moveq	#0,d2				; Iterate over rasterlines
.rl
		cmpi.b	#8,d2
		beq.w	.doneBrick

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
		subq.b	#1,d5
.utGreen
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5
		beq.s	.doneUpperTile
		subq.b	#1,d5
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

		cmpi.b	#7,d2
		bne.s	.subNormalLtRed
		subq.b	#7,d5
		bpl.s	.ltGreen
		moveq	#0,d5
.subNormalLtRed
		subq.b	#2,d5
		bpl.s	.ltGreen
		moveq	#0,d5
.ltGreen
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5

		cmpi.b	#7,d2
		bne.s	.subNormalLtGreen
		subq.b	#7,d5
		bpl.s	.ltBlue
.subNormalLtGreen
		subq.b	#2,d5
		bpl.s	.ltBlue

		moveq	#0,d5
.ltBlue
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5

		cmpi.b	#7,d2
		bne.s	.subNormalLtBlue
		subq.b	#6,d5
		bpl.s	.combine

.subNormalLtBlue
		subq.b	#1,d5
		bpl.s	.combine

		moveq	#0,d5
.combine
		or.b	d6,d5

		move.b	d5,(a1)+	; Write BG components

	; Second colorword
		move.w	#COLOR00,(a1)+

		move.b	(a6),d5

		cmpi.b	#7,d2
		bne.s	.subNormalLtRed2
		subq.b	#8,d5
		bpl.s	.ltGreen2

.subNormalLtRed2
		subq.b	#3,d5
		bpl.s	.ltGreen2
		moveq	#0,d5
.ltGreen2
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5

		cmpi.b	#7,d2
		bne.s	.subNormalLtGreen2
		subq.b	#8,d5
		bpl.s	.ltBlue2

.subNormalLtGreen2
		subq.b	#3,d5
		bpl.s	.ltBlue2

		moveq	#0,d5
.ltBlue2
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5

		cmpi.b	#7,d2
		bne.s	.subNormalLtBlue2
		subq.b	#7,d5
		bpl.s	.combine2

.subNormalLtBlue2
		subq.b	#2,d5
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


; Set up animation in a free slot.
; In:	a4 = Address to first anim frame bob struct
; In:	a5 = Pointer to game area tile (byte)
AddBrickAnim:
	movem.l	d0-d1/d7/a1/a4,-(sp)

	lea	AnimBricks,a1
	moveq	#MAXANIMBRICKS*3-1,d7	; *3 because structsize is 3 longwords
.l
	move.l	(a1)+,d0
	beq.s	.freeAnimslot
	dbf	d7,.l
	bra.s	.exit			; No slot available
.freeAnimslot
	addq.b	#1,AnimBricksCount

	subq.l	#4,a1
	bsr	GetCoordsFromGameareaPtr
	move.l	a4,(a1)+
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a5,(a1)
.exit
	movem.l	(sp)+,d0-d1/d7/a1/a4
	rts

; Replaces an existing brickanimation.
; In:	a4 = Address to first anim frame bob struct
; In:	a5 = Pointer to game area tile (byte)
ReplaceAnim:
	lea	AnimBricks,a1
	moveq	#MAXANIMBRICKS-1,d7
.l1
	cmpa.l	2*4(a1),a5
	beq	.replaceAnim
	add.l	#3*4,a1			; Next struct

	dbf	d7,.l1

	; Didn't find replacement, so add a new animation (happens when debug flags are set)
	bsr	AddBrickAnim
	bra	.exit

.replaceAnim
	move.l	a4,(a1)
.exit
	rts

; Brick/brickdrop animation.
BrickAnim:
	tst.b	AnimBricksCount
	beq.w	.exit

	moveq	#0,d2
	moveq	#0,d3
	lea	AnimBricks,a1
	lea	AnimBricksEnd,a5
.l
	cmpa.l	a1,a5
	beq.s	.exit

	move.l	(a1)+,d6
	beq.s	.l

	move.l	d6,a2
	move.w	(a1)+,d2
	move.w	(a1)+,d3
	move.l	(a1)+,a3

	cmpi.l	#tBrickDropBob,hType(a2)	; Done dropping?
	beq.s	.checkBrickDrop
.checkBrick
	tst.b	(a3)				; Brick still there?
	beq.s	.clearAnimBrick			; Cornercase: hitting bricks as they get dropped
	bra.s	.drawFrame
.checkBrickDrop
	move.l	AddBrickQueuePtr,a0
	cmpa.l	#AddBrickQueue,a0		; Is queue empty?
        beq	.clearAnimBrick

.drawFrame
	move.w	d2,hSprBobTopLeftXPos(a2)	; Brickanimstruct is reused - set coords
	move.w	d3,hSprBobTopLeftYPos(a2)

	bsr	DrawNewBrickGfxToGameScreen

	move.l	hNextAnimStruct(a2),d6		; Done animating this brick?
	beq.s	.restoreBrickGfx

	move.l	d6,-12(a1)
	bra.s	.l

.restoreBrickGfx
	moveq	#0,d1
	move.b	(a3),d1
	add.w	d1,d1			; Convert .b to .l
	add.w	d1,d1
	lea	TileMap,a3
	move.l	(a3,d1.l),a2		; Lookup in tile map

	bsr	DrawNewBrickGfxToGameScreen

.clearAnimBrick
	clr.l	-12(a1)
	clr.l	-8(a1)
	clr.l	-4(a1)
	subq.b	#1,AnimBricksCount
	beq.s	.exit

	bra.s	.l
.exit
	rts

; Clear brick animation slots and restore background.
ResetBrickAnim:
	lea	AnimBricks,a4
.l
	cmp.l	#AnimBricksEnd,a4
	bhs.s	.exit

	move.l	(a4)+,d6
	beq.s	.empty

	addq.l	#4,a4				; Skip to GAMEAREA byte

	move.l	d6,a0
	cmpi.l	#tBrickDropBob,hType(a0)
	bne.s	.clearAnim

.clearLoopedAnim
	move.l	(a4),a5
	bsr	RestoreBackgroundGfx
.clearAnim
	addq.l	#4,a4				; Move to next struct
	clr.l	-12(a4)
	clr.l	-8(a4)
	clr.l	-4(a4)

	bra.s	.l
.empty
	clr.l	(a4)+				; Clear potential trash in struct
	clr.l	(a4)+
	bra.s	.l
.exit
	clr.b	AnimBricksCount
	rts

; NOTE: Critical area? There was a strange bug here before when testing if GAMEAREA 
; actually had a brick present where BlinkBrickGameareaPtr is pointing to.
; It seemed to immediately leave VBLANK interrupt when doing tst.l (a0)
; Perhaps testing a longword on an odd address?
TriggerUpdateBlinkBrick:

	cmp.l	#BlinkOffBrick,BlinkBrickStruct
	bne.s	.turnBlinkOff

	move.l	BlinkOnBrickPtr,BlinkBrickStruct
	bra.s	.findDirtyRow
.turnBlinkOff
	move.l	#BlinkOffBrick,BlinkBrickStruct

.findDirtyRow
	moveq	#0,d7
	move.b	BlinkBrickRow,d7

	move.l	#DirtyRowQueue,a2
	move.l	DirtyRowQueuePtr,a3
.findDirtyRowLoop

	cmpa.l	a2,a3			; End of queue?
	beq.s	.addDirtyRow

	move.w	(a2)+,d6
	sub.w	d7,d6
	beq.s	.exit			; Already marked as dirty

	addq.l	#4,a2
	bra.s	.findDirtyRowLoop

.addDirtyRow
	move.w	d7,(a3)+
	move.l	BlinkBrickGameareaRowstartPtr,(a3)+
	move.l	a3,DirtyRowQueuePtr	; Point to 1 beyond the last item

.exit
	rts

; Store BlinkBrickRow and BlinkBrickGameareaRowstartPtr to be added to dirty queue later.
StoreBlinkBrickRow:
	move.l	BlinkBrick,a0
	moveq	#0,d1
	move.w	2(a0),d1
	move.l	d1,d7

	add.w	d7,d7
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.l	d7,a2

	moveq	#0,d3
	move.b	(a2)+,d3		; Col / X pos
	move.b	(a2),BlinkBrickRow	; Row / Y pos

	lea	GAMEAREA,a0
	add.l	d1,a0
	move.l	a0,BlinkBrickGameareaPtr
	sub.l   d3,a0
	addq.l	#1,a0			; Compensate for 1st empty byte on GAMEAREA row
	move.l	a0,BlinkBrickGameareaRowstartPtr

	rts

InitBlinkColors:
	move.l	BlinkBrick,a0
	moveq	#0,d2
	move.b	(a0),d2

	add.w	d2,d2			; Convert .b to .l
	add.w	d2,d2
	lea	TileMap,a2
	move.l	(a2,d2.l),a2		; Lookup in tile map

	move.l	a2,BlinkOnBrickPtr

	lea	(hBrickColorY0X0,a2),a2
	lea	BlinkOffBrick,a3
	add.l	#hBrickColorY0X0,a3

	; Calculate colors for off
	moveq	#16-1,d7
.l2
	addq.l	#2,a2			; Skip COLOR00 instruction
	addq.l	#2,a3

	move.b	(a2)+,d0		; Modify Red
	lsr.b	d0
	move.b	d0,(a3)+

	move.b	(a2),d0			; Modify Green
	lsr.b	#5,d0
	lsl.b	#4,d0

	move.b	(a2)+,d2		; Modify Blue
	and.b	#$0f,d2

	lsr.b	d2
	or.b	d2,d0

	move.b	d0,(a3)+

	dbf	d7,.l2

	rts