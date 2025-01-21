InitGameareaRowCopper:
	lea			END_COPPTR_GAME,a0
	move.l		hAddress(a0),d1		; Start of copper WAITs

	lea			GAMEAREA_ROWCOPPER,a1
	moveq		#32-1,d0
.l
	move.l		d1,(a1)+
	addq.l		#4,a1				; Skip rasterline bytecount
	add.l		#$540,d1
	dbf			d0,.l

	rts

ResetBricksAndTiles:
	; Reset queues
	move.l		#AddBrickQueue,AddBrickQueuePtr
	move.l		#AllBricks,AllBricksPtr
	move.l		#AddTileQueue,AddTileQueuePtr
	move.l		#RemoveTileQueue,RemoveTileQueuePtr

	lea			AllBlinkBricks,a0
	REPT		MAXBLINKBRICKS
	clr.l		(a0)+
	clr.l		(a0)+
	clr.l		(a0)+
	clr.l		(a0)+
	clr.l		(a0)+
	ENDR

	clr.w		BricksLeft
	rts

; Initializes the TileMap
InitTileMap:
	move.l		BOBS_BITMAPBASE,d0
	addi.l		#(ScrBpl*56*4),d0	; Empty
	
	; Bricks that don't have gfx
	lea			BeerFoam,a0
	move.l		d0,hAddress(a0)
	lea			BeerDarkLeftSide,a0
	move.l		d0,hAddress(a0)
	lea			BeerHighlight,a0
	move.l		d0,hAddress(a0)
	lea			BeerMid,a0
	move.l		d0,hAddress(a0)
	lea			BeerRightSide,a0
	move.l		d0,hAddress(a0)
	lea			BeerDarkRightSide,a0
	move.l		d0,hAddress(a0)

	; Bricks that have gfx
	move.l		BOBS_BITMAPBASE,d0
	addi.l		#(ScrBpl*64*4),d0

	lea			WhiteBrick,a0
	move.l		d0,hAddress(a0)
	lea			WhiteBrickD,a0
	move.l		d0,hAddress(a0)


	lea			B2,a0
	move.l		d0,hAddress(a0)
	lea			B3,a0
	move.l		d0,hAddress(a0)
	lea			B4,a0
	move.l		d0,hAddress(a0)
	lea			B5,a0
	move.l		d0,hAddress(a0)
	lea			B6,a0
	move.l		d0,hAddress(a0)
	lea			B7,a0
	move.l		d0,hAddress(a0)
	lea			B8,a0
	move.l		d0,hAddress(a0)


	lea			OrangeBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			CyanBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)

	lea			GreenBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			WhiteBrickDD,a0
	move.l		d0,hAddress(a0)

	lea			DarkGreyRaisedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			LightGreyRaisedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrightRedRaisedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrightRedTopBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)

	addi.l		#(ScrBpl*8*4)-16,d0	; Next row in tile sheet - 8 px down, 16 bytes back
	lea			RedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BlueBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)

	move.l		d0,IndestructableGrey
	move.l		d0,CLEAR_ANIM
	move.l		d0,GoldBrick

	lea			PurpleBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			YellowBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)

	lea			LightBlueRaisedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			RedRaisedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			DarkBlueRaisedBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BlueTopBrick,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickAnim0,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickAnim1,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickAnim2,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickAnim3,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickAnim4,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)

	move.l		BOBS_BITMAPBASE,d0
	addi.l		#(ScrBpl*80*4),d0

	lea			BrickDropAnim0,a0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim1,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim2,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim3,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim4,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim5,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim6,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)
	lea			BrickDropAnim7,a0
	addq.l		#2,d0
	move.l		d0,hAddress(a0)

	rts

; Adds a random number of bricks around a random "cluster point" in GAMEAREA.
AddBricksToQueue:
	movem.l		d2/d7/a2-a4,-(sp)

	move.l		AddBrickQueuePtr,a0
	lea			GAMEAREA,a1
	lea			ClusterOffsets,a2

	; Find a random "cluster point" in GAMEAREA

	; Available GAMRAREA row positions
	; 26-5 = 21
	; #%1111	-> 0 to 15
	; #%110		-> 0 to 6
	; Starting from row #4
	bsr			RndW				; Find random row in GAMEAREA
	and.w		#%1101111,d0

	moveq		#0,d1
	move.w		d0,d1
	and.w		#%1111,d1			; 0 to 15
	lsr.w		#4,d0				; 0 to 6
	add.w		d0,d1				; Row found
	addq.w		#5,d1				; Add row margin

	; move.l	#12,d1		; DEBUG row

	mulu.w		#41,d1

	; Available GAMRAREA column positions
	; 33-7 = 26
	; #%11100	-> 0 to 28
	bsr			RndW				; Find random column in GAMEAREA
	and.w		#%11010,d0			; TODO: make it an even number - for now
	addq.w		#1+6,d0				; Add column margin

	; move.l	#31,d0		; DEBUG col

	add.w		d0,d1				; Column found
	move.w		d1,d2				; Copy "cluster point"

	bsr			RndB
	and.b		#%00000111,d0
	moveq		#1,d7				; Add 2 bricks minimum
	add.b		d0,d7				; Random number of bricks to add

	lsl.b		#1,d7				; Pick ClusterOffsets in reverse order (due to draw routine issues)
	add.l		d7,a2
	add.l		#2,a2				; Adjust for word pre-decrement
	lsr.b		#1,d7
	
.addLoop
	add.w		-(a2),d1			; Add cluster offset for next brick

	tst.b		(a1,d1.w)
	bne.s		.occupied
	tst.b		1(a1,d1.w)			; A single-byte tile here?
	bne.s		.occupied

	move.b		NextRandomBrickCode,d0
	addq.b		#1,d0

	cmp.b		#RANDOMBRICKS_START+MAX_RANDOMBRICKS,d0
	bne.s		.inRange
	move.b		#RANDOMBRICKS_START,d0
.inRange
	move.b		d0,NextRandomBrickCode

	; btst	#0,d7
	; beq.s	.addPredefinedBrick

	; bsr	GetNextRandomBrickCode
	; bra.s	.addToQueue
; .addPredefinedBrick
; 	bsr	RndB
; 	and.b	#%00011111,d0		; 0 to 31 random predefined brick
; 	addi.b	#STATICBRICKS_START,d0			; Add offset to get a brick code

.addToQueue
	move.b		d0,(a0)+			; Brick code
	move.b		#BRICK_2ND_BYTE,(a0)+	; Continuation code
	move.w		d1,(a0)+			; Position in GAMEAREA

	move.l		#BrickDropAnim0,a4
	lea			(a1,d1.l),a3
	movem.l		a0-a1,-(sp)
	bsr			AddBrickAnim
	movem.l		(sp)+,a0-a1

.occupied
	move.w		d2,d1				; Restore cluster center
	dbf			d7,.addLoop

	move.l		a0,AddBrickQueuePtr	; Point to 1 beyond the last item

	cmpa.l		#AddBrickQueue,a0	; Cornercase - no available space for drop?
	beq.s		.done

	move.b		#1,IsDroppingBricks	; Give some time to animate

	tst.b		CUSTOM+VPOSR+1		; Check for extreme load - passed vertical wrap?
	beq			.t
	cmp.b		#$2a,$dff006		; Check for extreme load
	bhi			.done				; Don't add more enemies this time
.t
	bsr			SpawnEnemies
.done

	movem.l		(sp)+,d2/d7/a2-a4
	rts


ProcessAllAddBrickQueue:
	move.l		a2,-(sp)
.l
	move.l		AddBrickQueuePtr,a2
	cmpa.l		#AddBrickQueue,a2
	beq.s		.exit

	bsr			ProcessAddBrickQueue
	bra.s		.l
.exit
	move.l		(sp)+,a2
	rts

; Picks the last item in brick queue and adds it to gamearea map.
; In:	= a2 MODIFIED. Address where AddBrickQueuePtr is pointing to
ProcessAddBrickQueue:
	movem.l		d2/a3-a4,-(sp)

	subq.l		#4,a2
	move.l		(a2),d0				; Get last item in queue
	move.l		d0,d2

	lea			GAMEAREA,a3
	lea			(a3,d0.w),a3		; Set address to target byte in Game area
	tst.b		(a3)
	bne			.clearItem			; Tile already occupied?

	tst.l		CopperUpdatesCachePtr	; In the middle of drawing a GAMEAREA row?
	beq			.updateGamearea

	move.l		d0,-(sp)
	bsr			GetRowColFromGameareaPtr
	move.l		(sp)+,d0

	cmp.w		AbandonedGameareaRow(a5),d1
	bne			.updateGamearea

	clr.w		AbandonedNextRasterline(a5)	; Reset values to redraw of entire GAMEAREA row
	move.l		AbandonedInitialRowCopperPtr(a5),AbandonedRowCopperPtr(a5)

.updateGamearea
	swap		d0
	move.b		d0,1(a3)			; Set last brick code byte in Game area
	lsr.w		#8,d0				; (done in 2 steps for 68000 adressing compatibility)
	move.b		d0,(a3)				; Set first byte

	move.l		#BrickAnim0,a4
	bsr			ReplaceAnim			; Dropping-animation replaced by fresh-brick-animation

	cmpi.b		#INDESTRUCTABLEBRICK,(a3)
	beq.s		.indestructible

	move.l		AllBricksPtr,a1
	move.l		d2,(a1)+			; Copy to AllBricks
	move.l		a1,AllBricksPtr

	cmpa.l		#AllBricksEnd,a1
	bne.s		.ok
	move.l		#AllBricks,AllBricksPtr
.ok
	addq.w		#1,BricksLeft
.indestructible
	bsr			GetRowColFromGameareaPtr
	move.l		DirtyRowBits,d0
	bset.l		d1,d0
	move.l		d0,DirtyRowBits

.clearItem
	clr.l		(a2)				; Clear queue item and update pointer position
	move.l		a2,AddBrickQueuePtr

	cmpa.l		#AddBrickQueue,a2	; Is queue empty now?
	bne.s		.sfx
	; tst.l	AllBlinkBricks		; Already have one?
	; bne.s	.sfx

	bsr			CreateBlinkBricks
.sfx
	lea			SFX_BRICKDROP_STRUCT,a0
	bsr			PlaySample

	movem.l		(sp)+,d2/a3-a4
	rts


; Processes all added tiles for 1 GAMEAREA row.
; Picks the last item(s) in tile queue and adds to GAMEAREA.
; Puts an item in DirtyRowQueue for copper/screen update later.
; Clears any gfx obstructing the tiles.
; Also checks if Ball0 is at risk of getting trapped when adding tiles.
; In:	= a0 Address where queue pointer is pointing to.
ProcessAddTileQueue:
	movem.l		d2-d3/a2-a3,-(sp)

	subq.l		#4,a0
	move.l		(a0),d0				; Get last item in queue

	swap		d0
	lsr.w		#8,d0				; What GAMEAREA row is it?

	moveq		#0,d1
	move.b		d0,d1

	move.l		DirtyRowBits,d2
	bset.l		d1,d2
	move.l		d2,DirtyRowBits

	move.l		(a0),d1				; Get last item in queue
.rowLoop
	lea			GAMEAREA,a1
	lea			(a1,d1.w),a1		; Set address to target byte in Game area
	tst.b		(a1)
	bne			.clearQueueItem		; Tile already occupied?

	; Clear any obstructing gfx
	cmp.b		#$4c,d1
	beq			.updateGamearea		; Don't clear the clock gfx
	cmp.b		#$4d,d1
	beq			.updateGamearea		; Don't clear the clock gfx

	add.w		d1,d1
	lea			GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.w		d1,a2

	moveq		#0,d3
	moveq		#0,d1
	move.b		(a2)+,d1			; X pos byte
	subq.b		#1,d1				; Compensate for empty first byte in GAMEAREA
	move.b		(a2),d3				; Y pos byte
	lsl.b		#3,d3				; The row translates to what Y pos?

	mulu.w		#(ScrBpl*4),d3		; TODO dynamic handling of no. of bitplanes
	add.l		d1,d3				; Add byte (x pos) to longword (y pos)

	move.l 		GAMESCREEN_BackPtr(a5),a3
	add.l		d3,a3
	CPUCLR88	a3

	move.l		GAMESCREEN_Ptr(a5),a3
	add.l		d3,a3
	CPUCLR88	a3

.updateGamearea
	move.l		(a0),d1				; Get last item in queue
	swap		d1
	move.b		d1,(a1)				; Set tile byte in GAMEAREA

.clearQueueItem
	clr.l		(a0)				; Clear item and update pointer position
	move.l		a0,AddTileQueuePtr

	cmpa.l		#AddTileQueue,a0	; Is queue empty?
	beq			.exit

	subq.l		#4,a0
	move.l		(a0),d1				; Get next last item in queue

	swap		d1
	ror.w		#8,d1				; What GAMEAREA row is it?

	cmp.b		d0,d1				; Still on same GAMEAREA row?
	bne			.exit

	ror.w		#8,d1
	swap		d1

	bra			.rowLoop
.exit
	movem.l		(sp)+,d2-d3/a2-a3
	rts

; Processes all added tiles for 1 GAMEAREA row.
; Picks the last item(s) in tile queue and removes from GAMEAREA.
; Then puts an item in DirtyRowQueue for copper/screen update.
; Restores gfx.
; In:	= a0 Address where queue pointer is pointing to.
ProcessRemoveTileQueue:
	movem.l		d2-d3/a2-a4,-(sp)

	subq.l		#4,a0
	move.l		(a0),d0				; Get last item in queue

	swap		d0					; What GAMEAREA row is it?

	moveq		#0,d1
	move.b		d0,d1

	move.l		DirtyRowBits,d2
	bset.l		d1,d2
	move.l		d2,DirtyRowBits

	move.l		(a0),d1				; Get last item in queue
.rowLoop
	lea			GAMEAREA,a1
	lea			(a1,d1.w),a1		; Set address to target byte in Game area
	clr.b		(a1)				; Remove tile byte in GAMEAREA

	; Restore gfx
	cmp.b		#$4c,d1
	beq			.clearQueueItem		; Don't restore the clock gfx
	cmp.b		#$4d,d1
	beq			.clearQueueItem		; Don't restore the clock gfx


	add.w		d1,d1
	lea			GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.w		d1,a2

	moveq		#0,d3
	moveq		#0,d1
	move.b		(a2)+,d1			; X pos byte
	subq.b		#1,d1				; Compensate for empty first byte in GAMEAREA
	move.b		(a2),d3				; Y pos byte
	lsl.b		#3,d3				; The row translates to what Y pos?

	mulu.w		#(ScrBpl*4),d3		; TODO dynamic handling of no. of bitplanes
	add.l		d1,d3				; Add byte (x pos) to longword (y pos)

	move.l 		GAMESCREEN_PristinePtr(a5),a3
	add.l		d3,a3

	move.l 		GAMESCREEN_BackPtr(a5),a4
	add.l		d3,a4
	CPUCPY88	a3,a4

	move.l		GAMESCREEN_Ptr(a5),a4
	add.l		d3,a4
	CPUCPY88	a3,a4


.clearQueueItem
	clr.l		(a0)				; Clear item and update pointer position
	move.l		a0,RemoveTileQueuePtr

	cmpa.l		#RemoveTileQueue,a0	; Is queue empty?
	beq			.checkInsano

	subq.l		#4,a0
	move.l		(a0),d1				; Get next last item in queue

	swap		d1
	cmp.b		d0,d1
	bne			.checkInsano

	swap		d1

	bra			.rowLoop
.checkInsano
	cmp.b	#INSANOSTATE_PHAZE101OUT,InsanoState(a5)
	bne			.exit
	cmp.b		#1,d0				; First row?
	bne			.exit
	cmp.b		#3+1,BallsLeft		; >3 spare balls?
	bls			.exit

	bsr			DrawAvailableBalls

.exit
	movem.l		(sp)+,d2-d3/a2-a4
	rts

; NOTE: Don't call when gamestate is RUNNING
ProcessAllDirtyRowQueue:
	tst.l		DirtyRowBits
	beq			.exit				; Stack empty?
.l
	tst.b		CUSTOM+VPOSR+1		; Check for extreme load
	beq			.go
	cmp.b		#$30,$dff006		; Push it over the safer limit in ProcessDirtyRowQueue
	blo			.go
	WAITVBL							; Make sure there is time to abandon processing
.go
	bsr			ProcessDirtyRowQueue
	tst.l		DirtyRowBits
	bne			.l
.exit
	rts

; Updates copperlist for dirty GAMEAREA row.
ProcessDirtyRowQueue:
	movem.l		a2-a5/d2/d7,-(sp)

	tst.l		CopperUpdatesCachePtr	; Resume (or restart) abandoned updates?
	beq			.startUpdate

	move.l		AbandonedRowCopperPtr(a5),a1
	move.l		AbandonedGameareaRowPtr(a5),a4
	moveq		#0,d7
	move.w		AbandonedGameareaRow(a5),d7
	moveq		#0,d2
	move.w		AbandonedNextRasterline(a5),d2

	bra			.updateCopperlist

.startUpdate
	move.l		DirtyRowBits,d0

	moveq		#32-1,d7
.findRow
	bclr.l		d7,d0
	bne			.found
	dbf			d7,.findRow

	bra			.notDirty			; Just in case
.found
	move.l		d0,DirtyRowBitsOnCompletion

	move.l		d7,d0

	lea			GAMEAREA_ROW_LOOKUP,a4
	add.b		d0,d0
	add.b		d0,d0
	move.l		(a4,d0.w),a4		; Row pointer found

	add.b		d0,d0
	lea			GAMEAREA_ROWCOPPER,a2
	move.l		(a2,d0.w),a1
	move.l		a1,AbandonedInitialRowCopperPtr(a5)
	moveq		#0,d2
.updateCopperlist
	move.l		a4,a0				; Make a copy for easier processing

	bsr			UpdateDirtyCopperlist
	bsr			AddCopperJmp

.notDirty
	movem.l		(sp)+,a2-a5/d2/d7
	rts


; Translates GAMEAREA byte into X,Y for restoring background
; In:	a3 = pointer to first brick-byte in game area (the background area to be restored).
RestoreBackgroundGfx:
	movem.l		a2-a3,-(sp)

	move.l		a3,d0
	sub.l		#GAMEAREA,d0		; Which GAMEAREA byte is it?

	add.l		d0,d0
	lea			GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a0
	add.l		d0,a0

	moveq		#0,d0
	moveq		#0,d1
	move.b		(a0)+,d1			; X pos byte
	subq.b		#1,d1				; Compensate for empty first byte in GAMEAREA
	move.b		(a0),d0				; Y pos byte
	lsl.b		#3,d0				; The row translates to what Y pos?

	mulu.w		#(ScrBpl*4),d0		; TODO dynamic handling of no. of bitplanes
	add.l		d1,d0				; Add byte (x pos) to longword (y pos)
	add.l		d0,a1

	move.l		GAMESCREEN_PristinePtr(a5),a2
	lea			(a2,d0.l),a2

	move.l 		GAMESCREEN_BackPtr(a5),a3	; Set up destination
	lea			(a3,d0.l),a3
	CPUCPY168	a2,a3
	move.l		GAMESCREEN_Ptr(a5),a3	; Set up destination
	lea			(a3,d0.l),a3
	CPUCPY168	a2,a3

	movem.l		(sp)+,a2-a3

	rts

; If the given tile is a brick and destructible then it is removed from game area.
; Makes a new blinking brick if hitting one.
; In:   a2 = address to ball/bullet structure (for powerup direction & score)
; In:	a3 = pointer to game area tile (byte) - THRASHED! (can be -1 byte on return)
CheckBrickHit:
	movem.l		d2/d6/d7/a3-a4,-(sp)

	cmpi.b		#WALL_BYTE,(a3)
	beq			.bounce
	cmpi.b		#STATICBRICKS_START,(a3)	; Is this a tile?
	blo			.bounce
	cmpi.b		#BRICK_2ND_BYTE,(a3)	; Hit a last byte part of brick?
	bne.s		.checkBrick
	subq.l		#1,a3

.checkBrick
    cmpi.b  	#INDESTRUCTABLEBRICK,(a3)
	bne.s		.addScore
	move.l		#BrickAnim0,a4
	bsr			AddBrickAnim

	lea			SFX_BOUNCEMETAL_STRUCT,a0
	bsr			PlaySample
	bra			.exit

.addScore
	moveq		#0,d0
	move.b		(a3),d0				; Convert .b to .l
	add.w		d0,d0
	add.w		d0,d0

	lea			TileMap,a0
	add.l		d0,a0
	move.l		hAddress(a0),a0		; Lookup brick in tile map
	move.l		hBrickPoints(a0),d0

	tst.b		InsanoState(a5)
	bmi			.normalScore

	lsl.w		d0					; Double score for every player when Insanoballz
	ALLSCORE	d0
	bra			.removeFromGamearea

.normalScore
	move.l		a3,-(sp)
	move.l		hPlayerBat(a2),a3
	move.l		hPlayerScore(a3),a3
	add.l		d0,(a3)				; add point(s)
	bsr			SetDirtyScore
	move.l		(sp)+,a3

.removeFromGamearea
	clr.b		(a3)				; Remove primary collision brick byte from game area
	clr.b		1(a3)				; Clear last brick byte from game area

	lea			SFX_BRICKSMASH_STRUCT,a0
	bsr			PlaySample

.addDirtyRow
	tst.l		CopperUpdatesCachePtr	; In the middle of drawing a GAMEAREA row?
	beq			.noRedraw

	bsr			GetRowColFromGameareaPtr
	cmp.w		AbandonedGameareaRow(a5),d1
	bne			.noRedraw

	clr.w		AbandonedNextRasterline(a5)	; Reset values to redraw of entire GAMEAREA row
    move.l  	AbandonedInitialRowCopperPtr(a5),AbandonedRowCopperPtr(a5)

.noRedraw
	bsr			GetRowColFromGameareaPtr

	move.l		DirtyRowBits,d0
	bset.l		d1,d0
	move.l		d0,DirtyRowBits

.markedAsDirty
	bsr			RestoreBackgroundGfx

	subq.w		#1,BricksLeft		; Level clear?
	beq			.bounce

	lea			AllBlinkBricks,a0
	move.w		PlayerCount,d7
	move.w		d7,d2
	subq.w		#1,d7
.blinkLoop
    cmp.l   	hBlinkBrickGameareaPtr(a0),a3   ; Hit blinking brick?
	beq			.removeBlinkBrick

	add.l		#ALLBLINKBRICKSSIZE,a0
	dbf			d7,.blinkLoop

	bra			.exit

.removeBlinkBrick
	clr.l		hBlinkBrick(a0)		; Clear vital parts
    clr.l   	hBlinkBrickGameareaPtr(a0)

	bsr			CheckAddPowerup

	cmp.w		BricksLeft,d2		; Can add another blinkbrick?
	bhi.w		.exit

	bsr			CreateBlinkBricks
	bra			.exit
.bounce
	lea			SFX_BOUNCE_STRUCT,a0
	bsr			PlaySample
.exit
	movem.l		(sp)+,d2/d6/d7/a3-a4
	rts


CreateBlinkBricks:
	movem.l		d2/d7/a2-a3,-(sp)

	lea			AllBlinkBricks,a2
	moveq		#0,d2				; BlinkOff struct offset
	lea			BlinkOnBrickPtrs,a3	; BlinkOn ptr address
	move.w		PlayerCount,d7
	subq.w		#1,d7
.l
	tst.l		hBlinkBrick(a2)		; Slot available?
	bne			.next

	bsr			FindBlinkBrickAsc
	cmpa.l		#0,a0
	beq			.exit


	; Needed?
	; move.b	d1,(a0)				; Update brickcode since AllBricks is left dirty between levels



	move.l		a0,hBlinkBrick(a2)	; Then store it

	bsr			StoreBlinkBrickRow
	bsr			InitBlinkColors

	clr.l		hBlinkBrickCopperPtr(a2)	; Force 1 GAMEAREA row redraw

.next
	add.l		#ALLBLINKBRICKSSIZE,a2
	add.w		#BLINKOFFSTRUCTSIZE,d2
	add.l		#4,a3
	dbf			d7,.l
.exit
	movem.l		(sp)+,d2/d7/a2-a3
	rts

; Out:	a0 = address to brick or $0 if none available.
; Out:	d1.b = brick code
FindBlinkBrickAsc:
	movem.l		d7/a2,-(sp)

	lea			AllBricks,a0
	lea			GAMEAREA,a1
.findBlinkLoop
	cmp.l		AllBricksPtr,a0
	beq			.noneAvailable
	move.l		(a0)+,d0
	beq			.findBlinkLoop

	move.b		(a1,d0.w),d1
	beq			.notFound
	bne			.checkCandidate
.notFound
	clr.l		-4(a0)				; Cleanup
	bra			.findBlinkLoop

.checkCandidate
	lea			AllBlinkBricks,a2	; Iterate over blinkbricks
	moveq		#MAXBLINKBRICKS-1,d7
	move.l		a0,d0
	subq.l		#4,d0
.candidateLoop
	cmp.l		hBlinkBrick(a2),d0	; Already a BlinkBrick?
	beq			.findBlinkLoop
	add.l		#ALLBLINKBRICKSSIZE,a2
	dbf			d7,.candidateLoop

	subq.l		#4,a0				; Adjust for post-increment
	bra			.exit				; Candidate is good

.noneAvailable
	sub.l		a0,a0
.exit
	movem.l		(sp)+,d7/a2

	rts


; Clear GAMEAREA and restore background.
; In:	a3 = pointer to game area tile (byte) - THRASHED (can be -1 byte on return)
RemoveBrick:
	cmpi.b		#STATICBRICKS_START,(a3)	; Is this tile a brick?
	blo.s		.clearTileInGameArea
	cmpi.b		#BRICK_2ND_BYTE,(a3)
	bne.s		.clearBrickInGameArea
	subq.l		#1,a3
.clearBrickInGameArea
	clr.b		(a3)				; Remove primary collision brick byte from game area
	clr.b		1(a3)				; Remove last brick byte from game area

	bsr			RestoreBackgroundGfx
	bra			.setDirtyRow
.clearTileInGameArea
	clr.b		(a3)				; Clear tile

	bsr			GetCoordsFromGameareaPtr
	lsr.w		#3,d0				; Convert to byte
	mulu.w		#(ScrBpl*4),d1		; TODO dynamic handling of no. of bitplanes
	add.l		d0,d1				; Add byte (x pos) to longword (y pos)
	
	move.l 		GAMESCREEN_PristinePtr(a5),a0
	add.l		d1,a0

	move.l 		GAMESCREEN_BackPtr(a5),a1
	add.l		d1,a1
	CPUCPY88	a0,a1

	move.l		GAMESCREEN_Ptr(a5),a1
	add.l		d1,a1
	CPUCPY88	a0,a1

.setDirtyRow
	bsr			GetRowColFromGameareaPtr

	move.l		DirtyRowBits,d0
	bset.l		d1,d0
	move.l		d0,DirtyRowBits

	rts


; Generates brick-stuctures with random colors
GenerateBricks:
	movem.l		d2-d7/a2,-(sp)

	lea			RandomBricks,a0
	lea			RandomBrickStructs,a1

	moveq		#0,d3
	move.l		#MAX_RANDOMBRICKS-1,d7
.brickLoop
	move.l		a1,(a0)+

	subq.b		#1,d3
	bmi			.newRandom

	sub.l		#$0111,d4			; Use previous random base color, but darker
	bmi			.newRandom			; Too dark?

	move.w		d4,RandomColor

	bra			.generate
.newRandom
	moveq		#5,d3				; Create x bricks with same base color

	bsr			RndW				; Random base color
	and.l		#$0fff,d0
	move.l		d0,d4
	move.w		d0,RandomColor

.generate
	lea			RandomColor,a2
	move.l		BOBS_BITMAPBASE,d1

	cmpi.w		#$8aa,d0
	blo			.OneDarker
	addi.l		#(ScrBpl*64*4+16),d1
	bra			.setBob
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
	addi.l		#(ScrBpl*64*4+18),d1
.setBob
	move.l		d1,hAddress(a1)		; Set address to brick-gfx
	add.l		#hBrickColorY0X0,a1	; Then target color instructions


	moveq		#0,d2				; Iterate over rasterlines
.rl
	cmpi.b		#8,d2
	beq			.doneBrick

.drawCalculatedColors
	cmpi.b		#3,d2				; Assuming classic horizontal brick orientation
	bls			.upperBrickColor
	bhi			.lowerBrickColor

.upperBrickColor
	; First colorword
	move.w		#COLOR00,(a1)+		; Set color for next 8 pixels
	move.w		(a2),(a1)+

	; Second colorword
	move.w		#COLOR00,(a1)+

	move.b		(a2),d5
	beq			.utGreen
	subq.b		#1,d5
.utGreen
	move.b		d5,(a1)+			; Write R component

	move.b		1(a2),d5
	and.b		#$f0,d5
	lsr.b		#4,d5
	beq			.doneUpperTile
	subq.b		#1,d5
.doneUpperTile
	move.b		d5,d6
	lsl.b		#4,d6

	move.b		1(a2),d5
	and.b		#$0f,d5
	or.b		d6,d5

	move.b		d5,(a1)+			; Write BG components


	bra			.doneRl


.lowerBrickColor
	; First colorword
	move.w		#COLOR00,(a1)+


	move.b		(a2),d5

	cmpi.b		#7,d2
	bne			.subNormalLtRed
	subq.b		#7,d5
	bpl			.ltGreen
	moveq		#0,d5
.subNormalLtRed
	subq.b		#2,d5
	bpl			.ltGreen
	moveq		#0,d5
.ltGreen
	move.b		d5,(a1)+			; Write R component

	move.b		1(a2),d5
	and.b		#$f0,d5
	lsr.b		#4,d5

	cmpi.b		#7,d2
	bne			.subNormalLtGreen
	subq.b		#7,d5
	bpl			.ltBlue
.subNormalLtGreen
	subq.b		#2,d5
	bpl			.ltBlue

	moveq		#0,d5
.ltBlue
	move.b		d5,d6
	lsl.b		#4,d6

	move.b		1(a2),d5
	and.b		#$0f,d5

	cmpi.b		#7,d2
	bne			.subNormalLtBlue
	subq.b		#6,d5
	bpl			.combine

.subNormalLtBlue
	subq.b		#1,d5
	bpl			.combine

	moveq		#0,d5
.combine
	or.b		d6,d5

	move.b		d5,(a1)+			; Write BG components

	; Second colorword
	move.w		#COLOR00,(a1)+

	move.b		(a2),d5

	cmpi.b		#7,d2
	bne			.subNormalLtRed2
	subq.b		#8,d5
	bpl			.ltGreen2

.subNormalLtRed2
	subq.b		#3,d5
	bpl			.ltGreen2
	moveq		#0,d5
.ltGreen2
	move.b		d5,(a1)+			; Write R component

	move.b		1(a2),d5
	and.b		#$f0,d5
	lsr.b		#4,d5

	cmpi.b		#7,d2
	bne			.subNormalLtGreen2
	subq.b		#8,d5
	bpl			.ltBlue2

.subNormalLtGreen2
	subq.b		#3,d5
	bpl			.ltBlue2

	moveq		#0,d5
.ltBlue2
	move.b		d5,d6
	lsl.b		#4,d6

	move.b		1(a2),d5
	and.b		#$0f,d5

	cmpi.b		#7,d2
	bne			.subNormalLtBlue2
	subq.b		#7,d5
	bpl			.combine2

.subNormalLtBlue2
	subq.b		#2,d5
	bpl			.combine2

	moveq		#0,d5
.combine2
	or.b		d6,d5

	move.b		d5,(a1)+			; Write BG components

.doneRl
	addq.b		#1,d2
	bra			.rl

.doneBrick
	dbf			d7,.brickLoop

	movem.l		(sp)+,d2-d7/a2
	rts


; Set up animation in a free slot.
; In:	a3 = Pointer to game area tile (byte)
; In:	a4 = Address to first anim frame bob struct
AddBrickAnim:
	lea			AnimBricks,a1
	moveq		#MAXANIMBRICKS*3-1,d1	; *3 because structsize is 3 longwords
.l
	move.l		(a1)+,d0
	beq.s		.freeAnimslot
	dbf			d1,.l
	
	bra.s		.exit				; No slot available

.freeAnimslot
	addq.b		#1,AnimBricksCount

	subq.l		#4,a1
	bsr			GetCoordsFromGameareaPtr
	move.l		a4,(a1)+
	move.w		d0,(a1)+
	move.w		d1,(a1)+
	move.l		a3,(a1)+

	; lsr.w	#3,d0			; Calculate bitmap offset once ???
	; mulu.w	#(ScrBpl*4),d1		; TODO: dynamic handling of no. of bitplanes if needed
	; add.l	d0,d1			; Add byte (x pos) to longword (y pos)

	; move.l	d1,(a1)

.exit
	rts

; Replaces an existing brickanimation.
; In:	a3 = Pointer to game area tile (byte)
; In:	a4 = Address to first anim frame bob struct
ReplaceAnim:
	lea			AnimBricks,a1
	moveq		#MAXANIMBRICKS-1,d0
.l1
	cmpa.l		2*4(a1),a3
	beq			.replaceAnim
	add.l		#3*4,a1				; Next struct

	dbf			d0,.l1

	; Didn't find replacement, so add a new animation (happens when debug flags are set)
	bsr			AddBrickAnim
	bra			.exit

.replaceAnim
	move.l		a4,(a1)
.exit
	rts

; Brick/brickdrop animation.
BrickAnim:
	; Performance optimization - minimize M68k ABI calling convention

	moveq		#0,d0
	move.b		AnimBricksCount,d0
	beq			.fastExit

	move.l		a4,-(sp)

	subq.b		#1,d0

	moveq		#0,d2
	moveq		#0,d3
	lea			AnimBricks,a1
	lea			AnimBricksEnd,a4
.l
	cmpa.l		a1,a4
	beq			.exit

	move.l		(a1)+,d6
	beq			.l

	move.l		d6,a2
	move.w		(a1)+,d2
	move.w		(a1)+,d3
	move.l		(a1)+,a3

	cmpi.l		#tBrickDropBob,hType(a2)	; Done dropping?
	beq			.checkBrickDrop
.checkBrick
	tst.b		(a3)				; Brick still there?
	beq			.clearAnimBrick		; Cornercase: hitting bricks as they get dropped
	bra			.drawFrame
.checkBrickDrop
	move.l		AddBrickQueuePtr,a0
	cmpa.l		#AddBrickQueue,a0	; Is queue empty?
	beq			.clearAnimBrick

.drawFrame
	move.w		d2,hSprBobTopLeftXPos(a2)	; Brickanimstruct is reused - set coords
	move.w		d3,hSprBobTopLeftYPos(a2)

	bsr			DrawNewBrickGfxToGameScreen

	move.l		hNextAnimStruct(a2),d6	; Done animating this brick?
	beq			.restoreBrickGfx

	move.l		d6,-12(a1)

	dbf			d0,.l
	bra			.exit

.restoreBrickGfx
	moveq		#0,d1
	move.b		(a3),d1
	add.w		d1,d1				; Convert .b to .l
	add.w		d1,d1
	lea			TileMap,a3
	move.l		(a3,d1.l),a2		; Lookup in tile map

	bsr			DrawNewBrickGfxToGameScreen

.clearAnimBrick
	clr.l		-12(a1)
	clr.l		-8(a1)
	clr.l		-4(a1)
	subq.b		#1,AnimBricksCount
	beq			.exit

	dbf			d0,.l
.exit
	move.l		(sp)+,a4
.fastExit
	rts

; Clear brick animation slots and restore background.
ResetBrickAnim:
	movem.l		d6/a3-a4,-(sp)

	lea			AnimBricks,a4
.l
	cmp.l		#AnimBricksEnd,a4
	bhs.s		.exit

	move.l		(a4)+,d6
	beq.s		.empty

	addq.l		#4,a4				; Skip to GAMEAREA byte

	move.l		d6,a0
	cmpi.l		#tBrickDropBob,hType(a0)
	bne.s		.clearAnim

.clearLoopedAnim
	move.l		(a4),a3
	bsr			RestoreBackgroundGfx
.clearAnim
	addq.l		#4,a4				; Move to next struct
	clr.l		-12(a4)
	clr.l		-8(a4)
	clr.l		-4(a4)

	bra.s		.l
.empty
	clr.l		(a4)+				; Clear potential trash in struct
	clr.l		(a4)+
	bra.s		.l
.exit
	clr.b		AnimBricksCount

	movem.l		(sp)+,d6/a3-a4
	rts


TriggerUpdateBlinkBrick:
	; Performance optimization - skip M68k ABI calling convention
	; movem.l	d2-d4/d7/a2-a5,-(sp)

	lea			AllBlinkBricks,a2
	lea			BlinkOnBrickPtrs,a4
	move.l		#BlinkOffBricks,d4
	move.w		PlayerCount,d7
	subq.w		#1,d7
.l
	tst.l		hBlinkBrick(a2)		; Slot has blinkbrick?
	beq			.next

	move.l		hBlinkBrickGameareaPtr(a2),a3
	tst.b		(a3)
	bne			.proceed
						; Bug? No brick to be found.
	clr.l		hBlinkBrick(a2)		; Clear vital parts
	clr.l		hBlinkBrickGameareaPtr(a2)
	bra			.next
.proceed
	tst.l		hBlinkBrickCopperPtr(a2)
	beq			.addDirtyRow		; No copperpointer = must redraw blinkbrick row

	move.l		(a4),d0
	cmp.l		hBlinkBrickStruct(a2),d0	; Currently ON?
	beq.s		.turnBlinkOff

	move.l		d0,hBlinkBrickStruct(a2)
	bra.s		.updateNow
.turnBlinkOff
	move.l		d4,hBlinkBrickStruct(a2)

.updateNow
	IFD			ENABLE_RASTERMONITOR
	move.w		#$f0f,$dff180
	ENDIF

	move.l		hBlinkBrickGameareaPtr(a2),a3
	bsr			GetRowColFromGameareaPtr

	lsl.w		#3,d1				; Convert row to 2*longword
	move.w		d1,d3				; This also happens to be Y pixels
	addi.w		#FIRST_Y_POS,d3		; Rasterline to process

	lea			GAMEAREA_ROWCOPPER,a0
	move.l		4(a0,d1.w),d0
	subq.l		#4+4,d0				; Calculate "rasterline modulo" by subtracting 2 COLOR00 instructions

	move.l		hBlinkBrickCopperPtr(a2),a1

	move.l		hBlinkBrickStruct(a2),a0
	add.l		#hBrickColorY0X0,a0
	moveq		#8-1,d2				; Relative rasterline 0-7
.nextRasterline
	cmpi.w		#$ff+1,d3			; PAL vertpos wrap?
	bne			.noWrap
	tst.b		NoVerticalPosWait
	beq			.noWrap				; There was no time for vertpos wrap
	addq.l		#4+4,a1				; Skip size of PAL vertpos wrap + copnop
.noWrap
	move.l		(a0)+,(a1)+
	move.l		(a0)+,(a1)+

	add.l		d0,a1				; Go to copperinstructions for next relative rasterline
	addq.w		#1,d3
	dbf			d2,.nextRasterline

	IFD			ENABLE_RASTERMONITOR
	move.w		#$0f0,$dff180
	ENDIF

	bra			.next
.addDirtyRow
	move.l		hBlinkBrickGameareaPtr(a2),a3
	bsr			GetRowColFromGameareaPtr

	move.l		DirtyRowBits,d0
	bset.l		d1,d0
	move.l		d0,DirtyRowBits
.next
	add.l		#BLINKOFFSTRUCTSIZE,d4
	addq.l		#4,a4
	add.l		#ALLBLINKBRICKSSIZE,a2
	dbf			d7,.l

	; movem.l	(sp)+,d2-d4/d7/a2-a5
	rts

; Store BlinkBrickGameareaRowstartPtr to be added to dirty queue later.
; In:	a0 = address to new blinkbrick
; In:	a2 = address into AllBlinkBricks
; In:	d2.w = BlinkOff struct offset
StoreBlinkBrickRow:
	move.l		a3,-(sp)

	moveq		#0,d1
	move.w		2(a0),d1
	move.l		d1,d0

	add.w		d0,d0
	lea			GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a1
	add.l		d0,a1

	moveq		#0,d3
	move.b		(a1),d3				; Col / X pos

	lea			GAMEAREA,a0
	add.l		d1,a0
	move.l		a0,hBlinkBrickGameareaPtr(a2)
	sub.l		d3,a0
	addq.l		#1,a0				; Compensate for 1st empty byte on GAMEAREA row

	move.l		a0,hBlinkBrickGameareaRowstartPtr(a2)

	lea			BlinkOffBricks,a3
	add.l		d2,a3
	move.l		a3,hBlinkBrickStruct(a2)

	move.l		(sp)+,a3
	rts

; In:	a2 = address into AllBlinkBricks
; In:	a3 = address to BlinkOn struct
; In:	d2.w = BlinkOff struct offset
InitBlinkColors:
	move.l		d7,-(sp)

	move.l		hBlinkBrick(a2),a0
	moveq		#0,d0
	move.b		(a0),d0

	add.w		d0,d0				; Convert .b to .l
	add.w		d0,d0
	lea			TileMap,a0
	move.l		(a0,d0.l),a0		; Lookup in tile map

	move.l		a0,(a3)

	lea			(hBrickColorY0X0,a0),a0

	lea			BlinkOffBricks,a1
	add.l		d2,a1
	add.l		#hBrickColorY0X0,a1

	; Calculate colors for off
	moveq		#16-1,d7
.l2
	addq.l		#2,a0				; Skip COLOR00 instruction
	addq.l		#2,a1

	move.b		(a0)+,d0			; Modify Red
	lsr.b		d0
	move.b		d0,(a1)+

	move.b		(a0),d0				; Modify Green
	lsr.b		#5,d0
	lsl.b		#4,d0

	move.b		(a0)+,d1			; Modify Blue
	and.b		#$0f,d1

	lsr.b		d1
	or.b		d1,d0

	move.b		d0,(a1)+

	dbf			d7,.l2

	move.l		(sp)+,d7
	rts