InitGameareaRowCopper:
	lea 	END_COPPTR_GAME,a0
	move.l	hAddress(a0),d1		; Start of copper WAITs

	lea	GAMEAREA_ROWCOPPER,a1
	moveq	#32-1,d0
.l
	move.l	d1,(a1)+
	addq.l	#4,a1			; Skip rasterline bytecount
	add.l	#$540,d1
	dbf	d0,.l

	rts

ResetBricks:
	move.l	#AddBrickQueue,AddBrickQueuePtr
	move.l	#AllBricks,AllBricksPtr

	lea	AllBlinkBricks,a0
	REPT	MAXBLINKBRICKS
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	ENDR

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
	movem.l	a2-a6,-(sp)

	move.l	AddBrickQueuePtr,a6
	lea	GAMEAREA,a3
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

	tst.b	(a3,d1.w)
	bne.s	.occupied
	tst.b	1(a3,d1.w)		; A single-byte tile here?
	bne.s	.occupied

	move.b	NextRandomBrickCode,d0
	addq.b	#1,d0

	cmp.b	#$50+MAX_RANDOMBRICKS,d0
	bne.s	.inRange
	move.b	#$50,d0
.inRange
	move.b	d0,NextRandomBrickCode

	; btst	#0,d7
	; beq.s	.addPredefinedBrick

	; bsr	GetNextRandomBrickCode
	; bra.s	.addToQueue
; .addPredefinedBrick
; 	bsr	RndB
; 	and.b	#%00011111,d0		; 0 to 31 random predefined brick
; 	addi.b	#$20,d0			; Add offset to get a brick code

.addToQueue
	move.b	d0,(a6)+		; Brick code
	move.b	#BRICK_2ND_BYTE,(a6)+	; Continuation code
	move.w	d1,(a6)+		; Position in GAMEAREA

	move.l	#BrickDropAnim0,a4
	lea	(a3,d1.l),a5
	bsr	AddBrickAnim

.occupied
	move.w	d2,d1			; Restore cluster center
	dbf	d7,.addLoop

	move.l	a6,AddBrickQueuePtr	; Point to 1 beyond the last item

	cmpa.l	#AddBrickQueue,a6	; Cornercase - no available space for drop?
	beq.s	.done

	move.b	#1,IsDroppingBricks	; Give some time to animate
	bsr	SpawnEnemies
.done

	movem.l	(sp)+,a2-a6
	rts


ProcessAllAddBrickQueue:
	move.l	a2,-(sp)
.l
	move.l	AddBrickQueuePtr,a2
	cmpa.l	#AddBrickQueue,a2
	beq.s	.exit

	bsr	ProcessAddBrickQueue
	bra.s	.l
.exit
	move.l	(sp)+,a2
	rts

; Picks the last item in brick queue and adds it to gamearea map.
; In:	= a2 MODIFIED. Address where AddBrickQueuePtr is pointing to
ProcessAddBrickQueue:
	movem.l	d2/a4-a5,-(sp)

	subq.l	#4,a2
	move.l	(a2),d0			; Get last item in queue
	move.l	d0,d2

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
	move.l	d2,(a1)+		; Copy to AllBricks
	move.l	a1,AllBricksPtr

	cmpa.l	#AllBricksEnd,a1
	bne.s	.ok
	move.l	#AllBricks,AllBricksPtr
.ok
	addq.w	#1,BricksLeft
.indestructible
	bsr	GetRowColFromGameareaPtr
	move.l	DirtyRowBits,d0
	bset.l	d1,d0
	move.l	d0,DirtyRowBits

.clearItem
	clr.l	(a2)			; Clear queue item and update pointer position
	move.l	a2,AddBrickQueuePtr

	cmpa.l	#AddBrickQueue,a2	; Is queue empty now?
	bne.s	.sfx
	; tst.l	AllBlinkBricks		; Already have one?
	; bne.s	.sfx

	bsr	CreateBlinkBricks
.sfx
	lea	SFX_BRICKDROP_STRUCT,a0
	bsr     PlaySample

	movem.l	(sp)+,d2/a4-a5
	rts

; Picks the last item(s) in tile queue and adds to GAMEAREA.
; Then puts an item in DirtyRowQueue for screen update.
; Also checks if Ball0 is at risk of getting trapped when adding tiles.
; In:	= a0 Address where queue pointer is pointing to.
ProcessAddTileQueue:
	move.l	d2,-(sp)

	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue

	swap	d0
	lsr.w	#8,d0			; What GAMEAREA row is it?

	moveq	#0,d1
	move.b	d0,d1

	move.l	DirtyRowBits,d2
	bset.l	d1,d2
	move.l	d2,DirtyRowBits

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

	cmp.b	d0,d1			; Still on same GAMEAREA row?
	bne	.exit

	ror.w	#8,d1
	swap	d1

	bra	.rowLoop
.exit
	move.l	(sp)+,d2
	rts

; Picks the last item(s) in tile queue and removes from GAMEAREA.
; Then puts an item in DirtyRowQueue for screen update.
; In:	= a0 Address where queue pointer is pointing to.
ProcessRemoveTileQueue:
	move.l	d2,-(sp)

	subq.l	#4,a0
	move.l	(a0),d0			; Get last item in queue

	swap	d0			; What GAMEAREA row is it?

	moveq	#0,d1
	move.b	d0,d1

	move.l	DirtyRowBits,d2
	bset.l	d1,d2
	move.l	d2,DirtyRowBits

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
	move.l	(sp)+,d2
	rts

ProcessAllDirtyRowQueue:
	tst.l	DirtyRowBits
	beq	.exit			; Stack empty?
.l
	bsr	ProcessDirtyRowQueue
	tst.l	DirtyRowBits
	bne	.l
.exit
	rts

; Updates copperlist for dirty GAMEAREA row.
ProcessDirtyRowQueue:
	movem.l	a2-a5/d2/d7,-(sp)

	move.l	DirtyRowBits,d0

	moveq	#32-1,d7
.findRow
	bclr.l	d7,d0
	bne	.found
	dbf	d7,.findRow

	bra	.notDirty			; Just in case
.found
	move.l	d0,DirtyRowBits

	move.l	d7,d0

        lea     GAMEAREA_ROW_LOOKUP,a4
        add.b   d0,d0
        add.b   d0,d0
	move.l	(a4,d0.w),a4		; Row pointer found


	move.l	a4,a0

	add.b   d0,d0
	lea	GAMEAREA_ROWCOPPER,a2
	move.l	(a2,d0.w),a1

	bsr	UpdateDirtyCopperlist
	bsr	AddCopperJmp

.notDirty
	movem.l	(sp)+,a2-a5/d2/d7
	rts


; Translates GAMEAREA byte into X,Y for restoring background
; In:	a5 = pointer to first brick-byte in game area (the background area to be restored).
RestoreBackgroundGfx:
	movem.l	a3/a6,-(sp)

	move.l	a5,d0
	sub.l	#GAMEAREA,d0		; Which GAMEAREA byte is it?

	add.l	d0,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a0
	add.l	d0,a0

	moveq	#0,d0
	moveq	#0,d1
	move.b	(a0)+,d1		; X pos byte
	subq.b	#1,d1			; Compensate for empty first byte in GAMEAREA
	move.b	(a0),d0			; Y pos byte
	lsl.b	#3,d0			; The row translates to what Y pos?

	mulu.w	#(ScrBpl*4),d0		; TODO dynamic handling of no. of bitplanes
	add.l	d1,d0			; Add byte (x pos) to longword (y pos)
	add.l	d0,a1

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a3
	lea	(a3,d0.l),a3

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6	; Set up destination
	lea	(a6,d0.l),a6
	bsr	CopyBrickGraphics

	move.l 	GAMESCREEN_BITMAPBASE,a6	; Set up destination
	lea	(a6,d0.l),a6
	bsr	CopyBrickGraphics

	movem.l	(sp)+,a3/a6

	rts

; If the given tile is a brick and destructible then it is removed from game area.
; Makes a new blinking brick if hitting one.
; In:   a2 = address to ball/bullet structure (for powerup direction & score)
; In:	a5 = pointer to game area tile (byte)
CheckBrickHit:
	movem.l	d2/d6/d7/a3-a4,-(sp)

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
	bra	.exit

.destructable
	tst.b	InsanoState
	bmi	.normalScore

	bsr	AddInsanoscore
	bra	.removeFromGamearea
.normalScore
	move.l	hPlayerBat(a2),a3
	move.l	hPlayerScore(a3),a3
	; move.l  hBrickPoints(a1),d0	; Use hBrickPoints instead???
	addq.l	#1,(a3)			; add point
	bsr     SetDirtyScore

.removeFromGamearea
	clr.b	(a5)			; Remove primary collision brick byte from game area
	clr.b	1(a5)			; Clear last brick byte from game area

	lea	SFX_BRICKSMASH_STRUCT,a0
	bsr     PlaySample

.addDirtyRow
	bsr	GetRowColFromGameareaPtr

	move.l	DirtyRowBits,d0
	bset.l	d1,d0
	move.l	d0,DirtyRowBits

.markedAsDirty
	bsr	RestoreBackgroundGfx

	subq.w	#1,BricksLeft		; Level clear?
	beq	.bounce

	lea	AllBlinkBricks,a1
	move.w	PlayerCount,d7
	move.w	d7,d2
	subq.w	#1,d7
.blinkLoop
	cmp.l	hBlinkBrickGameareaPtr(a1),a5	; Hit blinking brick?
	beq	.removeBlinkBrick

	add.l	#ALLBLINKBRICKSSIZE,a1
	dbf	d7,.blinkLoop

	bra	.exit

.removeBlinkBrick
	clr.l	hBlinkBrick(a1)			; Clear vital parts
	clr.l	hBlinkBrickGameareaPtr(a1)

	bsr     CheckAddPowerup

	cmp.w	BricksLeft,d2			; Can add another blinkbrick?
	bhi.w	.exit

	bsr	CreateBlinkBricks
	bra	.exit
.bounce
	lea	SFX_BOUNCE_STRUCT,a0
	bsr     PlaySample
.exit
	movem.l	(sp)+,d2/d6/d7/a3-a4
	rts


CreateBlinkBricks:
	movem.l	d2/d7/a2-a3,-(sp)

	lea	AllBlinkBricks,a2
	moveq	#0,d2				; BlinkOff struct offset
	lea	BlinkOnBrickPtrs,a3		; BlinkOn ptr address
	move.w	PlayerCount,d7
	subq.w	#1,d7
.l
	tst.l	hBlinkBrick(a2)			; Slot available?
	bne	.next

	bsr	FindBlinkBrickAsc
	cmpa.l	#0,a0
	beq	.exit


	; Needed?
	; move.b	d1,(a0)				; Update brickcode since AllBricks is left dirty between levels



	move.l	a0,hBlinkBrick(a2)		; Then store it

	bsr	StoreBlinkBrickRow
	bsr	InitBlinkColors

	clr.l	hBlinkBrickCopperPtr(a2)	; Force 1 GAMEAREA row redraw

.next
	add.l	#ALLBLINKBRICKSSIZE,a2
	add.w	#BLINKOFFSTRUCTSIZE,d2
	add.l	#4,a3
	dbf	d7,.l
.exit
	movem.l	(sp)+,d2/d7/a2-a3
	rts

; Out:	a0 = address to brick or $0 if none available.
; Out:	d1.b = brick code
FindBlinkBrickAsc:
	movem.l	d7/a2,-(sp)

	lea	AllBricks,a0
	lea	GAMEAREA,a1
.findBlinkLoop
	cmp.l	AllBricksPtr,a0
	beq	.noneAvailable
	move.l	(a0)+,d0
	beq	.findBlinkLoop

	move.b	(a1,d0.w),d1
	beq	.notFound
	bne	.checkCandidate
.notFound
	clr.l	-4(a0)				; Cleanup
	bra	.findBlinkLoop

.checkCandidate
	lea	AllBlinkBricks,a2		; Iterate over blinkbricks
	moveq	#MAXBLINKBRICKS-1,d7
	move.l	a0,d0
	subq.l	#4,d0
.candidateLoop
	cmp.l	hBlinkBrick(a2),d0		; Already a BlinkBrick?
	beq	.findBlinkLoop
	add.l	#ALLBLINKBRICKSSIZE,a2
	dbf	d7,.candidateLoop

	subq.l	#4,a0				; Adjust for post-increment
	bra	.exit				; Candidate is good

.noneAvailable
	sub.l	a0,a0
.exit
	movem.l	(sp)+,d7/a2

	rts


; If the given tile is a brick then it is removed from game area.
; In:	a5 = pointer to game area tile (byte)
RemoveBrick:

	cmpi.b	#$20,(a5)	; Is this tile a brick?
	blo.s	.exit
	cmpi.b	#$ff,(a5)	; Hit a Continued (last byte) part of brick?
	bne.s	.clearBrickInGameArea
	subq.l	#1,a5
.clearBrickInGameArea
	clr.b	(a5)		; Remove primary collision brick byte from game area
	clr.b	1(a5)		; Remove last brick byte from game area

	bsr	RestoreBackgroundGfx

	bsr	GetRowColFromGameareaPtr

	move.l	DirtyRowBits,d0
	bset.l	d1,d0
	move.l	d0,DirtyRowBits
.exit
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

	moveq	#0,d3
	move.l	#MAX_RANDOMBRICKS-1,d7
.brickLoop
	move.l	a1,(a0)+

	subq.b	#1,d3
	bmi	.newRandom

	sub.l	#$0111,d4			; Use previous random base color, but darker
	bmi	.newRandom			; Too dark?

	move.w	d4,RandomColor

	bra	.generate
.newRandom
	moveq	#5,d3				; Create x bricks with same base color

	bsr	RndW				; Random base color
	and.l	#$0fff,d0
	move.l	d0,d4
	move.w	d0,RandomColor

.generate
	lea	RandomColor,a6
	move.l	BOBS_BITMAPBASE,d1

	cmpi.w	#$8aa,d0
	blo	.OneDarker
	addi.l 	#(ScrBpl*64*4+16),d1
	bra	.setBob
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
		beq	.doneBrick

.drawCalculatedColors
		cmpi.b	#3,d2			; Assuming classic horizontal brick orientation
		bls	.upperBrickColor
		bhi	.lowerBrickColor

.upperBrickColor
	; First colorword
		move.w	#COLOR00,(a1)+		; Set color for next 8 pixels
		move.w	(a6),(a1)+

	; Second colorword
		move.w	#COLOR00,(a1)+

		move.b	(a6),d5
		beq	.utGreen
		subq.b	#1,d5
.utGreen
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5
		beq	.doneUpperTile
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
		bne	.subNormalLtRed
		subq.b	#7,d5
		bpl	.ltGreen
		moveq	#0,d5
.subNormalLtRed
		subq.b	#2,d5
		bpl	.ltGreen
		moveq	#0,d5
.ltGreen
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5

		cmpi.b	#7,d2
		bne	.subNormalLtGreen
		subq.b	#7,d5
		bpl	.ltBlue
.subNormalLtGreen
		subq.b	#2,d5
		bpl	.ltBlue

		moveq	#0,d5
.ltBlue
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5

		cmpi.b	#7,d2
		bne	.subNormalLtBlue
		subq.b	#6,d5
		bpl	.combine

.subNormalLtBlue
		subq.b	#1,d5
		bpl	.combine

		moveq	#0,d5
.combine
		or.b	d6,d5

		move.b	d5,(a1)+	; Write BG components

	; Second colorword
		move.w	#COLOR00,(a1)+

		move.b	(a6),d5

		cmpi.b	#7,d2
		bne	.subNormalLtRed2
		subq.b	#8,d5
		bpl	.ltGreen2

.subNormalLtRed2
		subq.b	#3,d5
		bpl	.ltGreen2
		moveq	#0,d5
.ltGreen2
		move.b	d5,(a1)+	; Write R component

		move.b	1(a6),d5
		and.b	#$f0,d5
		lsr.b	#4,d5

		cmpi.b	#7,d2
		bne	.subNormalLtGreen2
		subq.b	#8,d5
		bpl	.ltBlue2

.subNormalLtGreen2
		subq.b	#3,d5
		bpl	.ltBlue2

		moveq	#0,d5
.ltBlue2
		move.b	d5,d6
		lsl.b	#4,d6

		move.b	1(a6),d5
		and.b	#$0f,d5

		cmpi.b	#7,d2
		bne	.subNormalLtBlue2
		subq.b	#7,d5
		bpl	.combine2

.subNormalLtBlue2
		subq.b	#2,d5
		bpl	.combine2

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
	lea	AnimBricks,a1
	moveq	#MAXANIMBRICKS*3-1,d1	; *3 because structsize is 3 longwords
.l
	move.l	(a1)+,d0
	beq.s	.freeAnimslot
	dbf	d1,.l
	
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
	rts

; Replaces an existing brickanimation.
; In:	a4 = Address to first anim frame bob struct
; In:	a5 = Pointer to game area tile (byte)
ReplaceAnim:
	lea	AnimBricks,a1
	moveq	#MAXANIMBRICKS-1,d0
.l1
	cmpa.l	2*4(a1),a5
	beq	.replaceAnim
	add.l	#3*4,a1			; Next struct

	dbf	d0,.l1

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


TriggerUpdateBlinkBrick:
	; movem.l	d2-d4/d7/a2-a5,-(sp)

	lea	AllBlinkBricks,a2
	lea	BlinkOnBrickPtrs,a4
	move.l	#BlinkOffBricks,d4
	move.w	PlayerCount,d7
	subq.w	#1,d7
.l
	tst.l	hBlinkBrick(a2)			; Slot has blinkbrick?
	beq	.next

	move.l	hBlinkBrickGameareaPtr(a2),a5
	tst.b	(a5)
	bne	.proceed
						; Bug? No brick to be found.
	clr.l	hBlinkBrick(a2)			; Clear vital parts
	clr.l	hBlinkBrickGameareaPtr(a2)
	bra	.next
.proceed
	tst.l	hBlinkBrickCopperPtr(a2)
	beq	.addDirtyRow			; No copperpointer = must redraw blinkbrick row

	move.l	(a4),d0
	cmp.l	hBlinkBrickStruct(a2),d0	; Currently ON?
	beq.s	.turnBlinkOff

	move.l	d0,hBlinkBrickStruct(a2)
	bra.s	.updateNow
.turnBlinkOff
	move.l	d4,hBlinkBrickStruct(a2)

.updateNow
	IFGT	ENABLE_RASTERMONITOR
	move.w	#$f0f,$dff180
	ENDC

	move.l	hBlinkBrickGameareaPtr(a2),a5
	bsr	GetRowColFromGameareaPtr

	lsl.w	#3,d1			; Convert row to 2*longword
	move.w	d1,d3			; This also happens to be Y pixels
	addi.w	#FIRST_Y_POS,d3		; Rasterline to process

	lea	GAMEAREA_ROWCOPPER,a0
	move.l	4(a0,d1.w),d0
	subq.l	#4+4,d0			; Calculate "rasterline modulo" by subtracting 2 COLOR00 instructions

	move.l	hBlinkBrickCopperPtr(a2),a1

	move.l	hBlinkBrickStruct(a2),a0
	add.l	#hBrickColorY0X0,a0
	moveq	#8-1,d2			; Relative rasterline 0-7
.nextRasterline
        cmpi.w	#$ff+1,d3		; PAL vertpos wrap?
        bne	.noWrap
	tst.b	NoVerticalPosWait
	beq	.noWrap			; There was no time for vertpos wrap
	addq.l	#4+4,a1			; Skip size of PAL vertpos wrap + copnop
.noWrap
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+

	add.l	d0,a1			; Go to copperinstructions for next relative rasterline
	addq.w	#1,d3
	dbf	d2,.nextRasterline

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$0f0,$dff180
	ENDC

	bra	.next
.addDirtyRow
	move.l	hBlinkBrickGameareaPtr(a2),a5
	bsr	GetRowColFromGameareaPtr

	move.l	DirtyRowBits,d0
	bset.l	d1,d0
	move.l	d0,DirtyRowBits
.next
	add.l	#BLINKOFFSTRUCTSIZE,d4
	addq.l	#4,a4
	add.l	#ALLBLINKBRICKSSIZE,a2
	dbf	d7,.l

	; movem.l	(sp)+,d2-d4/d7/a2-a5
	rts

; Store BlinkBrickGameareaRowstartPtr to be added to dirty queue later.
; In:	a0 = address to new blinkbrick
; In:	a2 = address into AllBlinkBricks
; In:	d2.w = BlinkOff struct offset
StoreBlinkBrickRow:
	move.l	a3,-(sp)

	moveq	#0,d1
	move.w	2(a0),d1
	move.l	d1,d0

	add.w	d0,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a1
	add.l	d0,a1

	moveq	#0,d3
	move.b	(a1),d3		; Col / X pos

	lea	GAMEAREA,a0
	add.l	d1,a0
	move.l	a0,hBlinkBrickGameareaPtr(a2)
	sub.l   d3,a0
	addq.l	#1,a0			; Compensate for 1st empty byte on GAMEAREA row

	move.l	a0,hBlinkBrickGameareaRowstartPtr(a2)

	lea	BlinkOffBricks,a3
	add.l	d2,a3
	move.l	a3,hBlinkBrickStruct(a2)

	move.l	(sp)+,a3
	rts

; In:	a2 = address into AllBlinkBricks
; In:	a3 = address to BlinkOn struct
; In:	d2.w = BlinkOff struct offset
InitBlinkColors:
	move.l	d7,-(sp)

	move.l	hBlinkBrick(a2),a0
	moveq	#0,d0
	move.b	(a0),d0

	add.w	d0,d0			; Convert .b to .l
	add.w	d0,d0
	lea	TileMap,a0
	move.l	(a0,d0.l),a0		; Lookup in tile map

	move.l	a0,(a3)

	lea	(hBrickColorY0X0,a0),a0

	lea	BlinkOffBricks,a1
	add.l	d2,a1
	add.l	#hBrickColorY0X0,a1

	; Calculate colors for off
	moveq	#16-1,d7
.l2
	addq.l	#2,a0			; Skip COLOR00 instruction
	addq.l	#2,a1

	move.b	(a0)+,d0		; Modify Red
	lsr.b	d0
	move.b	d0,(a1)+

	move.b	(a0),d0			; Modify Green
	lsr.b	#5,d0
	lsl.b	#4,d0

	move.b	(a0)+,d1		; Modify Blue
	and.b	#$0f,d1

	lsr.b	d1
	or.b	d1,d0

	move.b	d0,(a1)+

	dbf	d7,.l2

	move.l	(sp)+,d7
	rts