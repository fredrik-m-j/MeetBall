InitializePlayerAreas:
	movem.l	d2-d3/a6,-(sp)

	lea	GAMEAREA,a0
	lea 	CUSTOM,a6
;-------
.player0
	moveq	#41*1+40,d0			; Default top right wall
	moveq	#1,d2
	bsr	VerticalFillPlayerArea

	move.w	#41*29+40,d0			; Default bottom right wall
	moveq	#1,d2
	bsr	VerticalFillPlayerArea

	tst.b	Player0Enabled
	bmi.s	.disablePlayer0

        move.l  #37,d0
	moveq	#$02,d1
        bsr     UpdateScoreArea
	move.l 	#DEFAULT_MASK,d3
	bsr	RestoreBat0Area

	moveq	#$00,d1
	bra.s	.updatePlayer0Area
.disablePlayer0
        move.l  #37,d0
	move.b	#WALL_BYTE,d1
	
	movem.l	d0-d1/a0,-(sp)

        bsr     UpdateScoreArea

	move.l 	#%11111110000000001111111000000000,d3	; Mask 1 more bit than expected
	bsr	RestoreBat0Area			; Restore = clear due to mask

	movem.l	(sp)+,d0-d1/a0

.updatePlayer0Area
	move.w	#25,d2
	move.w	#41*3+1+39,d0

	bsr     UpdateVerticalPlayerArea
;-------
.player1
	moveq	#41*1+1,d0			; Default top left wall
	moveq	#1,d2
	bsr	VerticalFillPlayerArea

	move.w	#41*29+1,d0			; Default bottom left wall
	moveq	#1,d2
	bsr	VerticalFillPlayerArea

	tst.b	Player1Enabled
	bmi.s	.disablePlayer1

        move.l  #41*31+1,d0
	moveq	#$03,d1
        bsr     UpdateScoreArea
	move.l 	#DEFAULT_MASK,d3
	bsr	RestoreBat1Area

	moveq	#$00,d1
	bra.s	.updatePlayer1Area
.disablePlayer1
        move.l  #41*31+1,d0
	move.b	#WALL_BYTE,d1

	movem.l	d0-d1/a0,-(sp)

        bsr     UpdateScoreArea

	move.l 	#%00000000111111110000000011111111,d3
	bsr	RestoreBat1Area			; Restore = clear due to mask

	movem.l	(sp)+,d0-d1/a0

.updatePlayer1Area
	move.w	#25,d2
	move.w	#41*3+1,d0

        bsr     UpdateVerticalPlayerArea
;-------
.player2
	tst.b	Player2Enabled
	bmi.s	.disablePlayer2

        move.l  #41*31+37,d0
	moveq	#$04,d1
        bsr     UpdateScoreArea
	bsr	RestoreBat2Area

	moveq	#$00,d1
	bra.s	.updatePlayer2Area
.disablePlayer2
        move.l  #41*31+37,d0
	move.b	#WALL_BYTE,d1
        bsr     UpdateScoreArea

	movem.l	d0-d1/a0,-(sp)

	move.l	GAMESCREEN_BITMAPBASE,a0
	move.l	#(ScrBpl*(256-8)*4)+4,d2
	add.l 	d2,a0
	moveq	#ScrBpl-32,d0
	move.w	#(64*8*4)+16,d1

	bsr	ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l 	d2,a0
	bsr	ClearBlitWords

	movem.l	(sp)+,d0-d1/a0
	
.updatePlayer2Area
	move.w	#31,d2
	move.w	#41*31+1+4,d0

        bsr     UpdateHorizontalPlayerArea

;-------
.player3
	tst.b	Player3Enabled
	bmi.s	.disablePlayer3

        moveq   #1,d0
	moveq	#$05,d1
        bsr     UpdateScoreArea
	bsr	RestoreBat3Area

	moveq	#$00,d1
	bra.s	.updatePlayer3Area
.disablePlayer3
        moveq   #1,d0
	move.b	#WALL_BYTE,d1
        bsr     UpdateScoreArea

	movem.l	d0-d1/a0,-(sp)

	move.l	GAMESCREEN_BITMAPBASE,a0
	addq.l	#4,a0
	moveq	#ScrBpl-32,d0
	move.w	#(64*8*4)+16,d1

	bsr	ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE_BACK,a0
	addq.l	#4,a0
	bsr	ClearBlitWords
	
	movem.l	(sp)+,d0-d1/a0

.updatePlayer3Area
	move.w	#31,d2
	move.w	#1+4,d0

        bsr     UpdateHorizontalPlayerArea

.exit
	movem.l	(sp)+,d2-d3/a6
	rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Offset to start of score area
; In:   d1.b = Tile code to set in score area
UpdateScoreArea:
	cmp.b	#WALL_BYTE,d1
	beq	.drawScoreAreaWall

	move.b	d1,(a0,d0)		; Enable Player score area
	move.b	d1,1(a0,d0)
	move.b	d1,2(a0,d0)
	move.b	d1,3(a0,d0)


	movem.l	d0-d1/a0/a5-a6,-(sp)

	; Clear any gfx
	move.l	a0,a5
	add.l	d0,a5
	bsr	GetCoordsFromGameareaPtr

	lsr.w	#3,d0
	mulu.w	#(ScrBpl*4),d1
					; Does the thing, but consider blitting instead
	move.l 	GAMESCREEN_BITMAPBASE,a6
	add.l	d0,a6
	add.l	d1,a6
	CPUCLEARALLPLANES_8_8 a6
	addq.l	#1,a6
	CPUCLEARALLPLANES_8_8 a6
	addq.l	#1,a6
	CPUCLEARALLPLANES_8_8 a6
	addq.l	#1,a6
	CPUCLEARALLPLANES_8_8 a6

	movem.l	(sp)+,d0-d1/a0/a5-a6

	bra	.exit

.drawScoreAreaWall
	movem.l	d0-d2/a0/a5-a6,-(sp)

	move.l	a0,a5
	add.l	d0,a5
	bsr	GetCoordsFromGameareaPtr

	mulu.w	#(ScrBpl*4),d1		; TODO dynamic handling of no. of bitplanes
	add.l	#ScrBpl,d1		; Fill bitplane 1
	lsr.w	#3,d0
	add.l	d0,d1			; Add byte (x pos) to longword (y pos)

	lea	CUSTOM,a6
	move.l 	GAMESCREEN_BITMAPBASE,a0
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a5
	add.l	d1,a0
	add.l	d1,a5
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*8*1)+2,d2

	bsr	FillBoxBlit
	exg	a0,a5
	bsr	FillBoxBlit

	add.l	#ScrBpl,a0		; Fill bitplane 2 also
	add.l	#ScrBpl,a5		; Fill bitplane 2 also
	bsr	FillBoxBlit
	exg	a0,a5
	bsr	FillBoxBlit

	movem.l	(sp)+,d0-d2/a0/a5-a6

.exit
        rts

; In:	d3.l = First- & last-word masks
RestoreBat0Area:
	movem.l	d1/d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	#(ScrBpl*24*4)+38,d0
	add.l 	d0,a0
	add.l 	d0,a1
	moveq	#ScrBpl-2,d1
	move.w	#(64*(256-24-24)*4)+1,d2

	bsr	CopyRestoreGameareaMasked

	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	d0,a1

	bsr	CopyRestoreGameareaMasked

	movem.l	(sp)+,d1/d2/a0/a1/a6

	rts

; In:	d3.l = First- & last-word masks
RestoreBat1Area:
	movem.l	d1/d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	#(ScrBpl*24*4),d0
	add.l 	d0,a0
	add.l 	d0,a1
	moveq	#ScrBpl-2,d1
	move.w	#(64*(256-24-24)*4)+1,d2

	bsr	CopyRestoreGameareaMasked

	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	d0,a1

	bsr	CopyRestoreGameareaMasked

	movem.l	(sp)+,d1/d2/a0/a1/a6

	rts

RestoreBat2Area:
	movem.l	d1/d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	#(ScrBpl*(256-8)*4)+4,d0
	add.l 	d0,a0
	add.l 	d0,a1
	moveq	#ScrBpl-32,d1
	move.w	#(64*8*4)+16,d2

	bsr	CopyRestoreGamearea
	movem.l	(sp)+,d1/d2/a0/a1/a6

	rts

RestoreBat3Area:
	movem.l	d1/d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	#4,d0
	add.l 	d0,a0
	add.l 	d0,a1
	moveq	#ScrBpl-32,d1
	move.w	#(64*8*4)+16,d2

	bsr	CopyRestoreGamearea
	movem.l	(sp)+,d1/d2/a0/a1/a6

	rts


; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d1.b = Tile code to set in player area
; In:   d2.w = Number of tiles to update
UpdateVerticalPlayerArea:
	cmp.b	#WALL_BYTE,d1
	bne	.playerLoop

	bsr	VerticalFillPlayerArea

.playerLoop
	move.b	d1,(a0,d0)
	addi.w	#41,d0
	dbf	d2,.playerLoop

.exit
        rts

; Fills 8*8 pixels vertically
; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d2.w = Number of tiles to update
VerticalFillPlayerArea:
	movem.l	d0-d2/a0/a5-a6,-(sp)

	move.l	a0,a5
	add.l	d0,a5
	bsr	GetCoordsFromGameareaPtr

	mulu.w	#(ScrBpl*4),d1		; TODO dynamic handling of no. of bitplanes
	add.l	#ScrBpl,d1		; Fill bitplane 1
	lsr.w	#3,d0
	add.l	d0,d1			; Add byte (x pos) to longword (y pos)

	move.l 	GAMESCREEN_BITMAPBASE,a5
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6
	add.l	d1,a5
	add.l	d1,a6

	move.l	d2,-(sp)		; Preserve vertical count
.l1
	CPUPLANESET_8_8 a5
	CPUPLANESET_8_8 a6
	add.l	#32*ScrBpl,a5
	add.l	#32*ScrBpl,a6
	dbf	d2,.l1

	move.l	(sp)+,d2
	

	add.l	#ScrBpl,d1		; Fill bitplane 2 also

	move.l 	GAMESCREEN_BITMAPBASE,a5
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6
	add.l	d1,a5
	add.l	d1,a6
.l2
	CPUPLANESET_8_8 a5
	CPUPLANESET_8_8 a6
	add.l	#32*ScrBpl,a5
	add.l	#32*ScrBpl,a6
	dbf	d2,.l2

	movem.l	(sp)+,d0-d2/a0/a5-a6
	rts

; Fills 8*8 pixels horizontally
; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d2.w = Number of tiles to update
HorizontalFillPlayerArea:
	movem.l	d0-d2/a0/a5-a6,-(sp)

	move.l	a0,a5
	add.l	d0,a5
	bsr	GetCoordsFromGameareaPtr

	mulu.w	#(ScrBpl*4),d1		; TODO dynamic handling of no. of bitplanes
	add.l	#ScrBpl,d1		; Fill bitplane 1
	lsr.w	#3,d0
	add.l	d0,d1			; Add byte (x pos) to longword (y pos)

	move.l 	GAMESCREEN_BITMAPBASE,a5
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6
	add.l	d1,a5
	add.l	d1,a6

	move.l	d2,-(sp)		; Preserve vertical count
.l1
	CPUPLANESET_8_8 a5
	CPUPLANESET_8_8 a6
	addq.l	#1,a5
	addq.l	#1,a6
	dbf	d2,.l1

	move.l	(sp)+,d2
	

	add.l	#ScrBpl,d1		; Fill bitplane 2 also

	move.l 	GAMESCREEN_BITMAPBASE,a5
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a6
	add.l	d1,a5
	add.l	d1,a6
.l2
	CPUPLANESET_8_8 a5
	CPUPLANESET_8_8 a6
	addq.l	#1,a5
	addq.l	#1,a6
	dbf	d2,.l2

	movem.l	(sp)+,d0-d2/a0/a5-a6
	rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d1.b = Tile code to set in player area
; In:   d2.w = Number of tiles to update
UpdateHorizontalPlayerArea:
	cmp.b	#WALL_BYTE,d1
	bne	.playerLoop

	bsr	HorizontalFillPlayerArea
.playerLoop
	move.b	d1,(a0,d0)
	addq.w	#1,d0
	dbf	d2,.playerLoop
.exit
        rts


RegenerateGameareaCopperlist:
	move.l	#$ffffffff,DirtyRowBits
	bsr	ProcessAllDirtyRowQueue
	rts

InitGameareaForNextLevel:
	movem.l	d7/a2-a3,-(sp)

	lea	LEVELPTR,a0
	move.l	(a0),a0
	move.l	(a0),d0
	bne	.addBricks
.reset
	move.l	#LEVEL_TABLE,LEVELPTR	; Reset from start
	move.l	LEVELPTR,a0

.addBricks
	move.l	(a0)+,a1
	move.l	a0,LEVELPTR		; Update pointer

	move.l	AddBrickQueuePtr,a0
	move.l	AddTileQueuePtr,a3

	moveq	#0,d0
	moveq	#0,d7
.addLoop
	cmpi.w	#41*32,d7
	beq	.processQ

	move.b	(a1)+,d0		; Any brick/tile here?
	beq	.next


	cmp.b	#STATICBRICKS_START,d0	; Single tile?
	bge	.brickConfirmed

	move.w	d7,d1
	add.w	d1,d1
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	move.b	1(a2,d1.w),(a3)+	; GAMEAREA row

	move.w	d7,d1			; Adjustment
	subq.w	#1,d1

	move.b	d0,(a3)+		; Brick code
	move.w	d1,(a3)+		; Position in GAMEAREA
	bra	.next

.brickConfirmed
	move.b	d0,(a0)+		; Brick code
	cmpi.b	#BRICK_2ND_BYTE,d0
	beq	.addPos
	bra	.next
.addPos
	move.w	d7,d0
	subq.w	#2,d0
	move.w	d0,(a0)+		; Position in GAMEAREA
.next
	addq.w	#1,d7
	bra	.addLoop

.processQ
	move.l	a0,AddBrickQueuePtr	; Point to 1 beyond the last item
	move.l	a3,AddTileQueuePtr

	bsr	SpawnEnemies
	clr.b	SpawnInCount		; No blitsize spawn-in
	bsr	SetSpawnedEnemies

.processFrame
	addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .proceed
        clr.b	FrameTick
.proceed
	WAITLASTLINE	d0

	bsr	ClearBobs
	bsr	EnemyUpdates
	moveq	#0,d0
	bsr	DrawBobs

	bsr	BrickAnim
	
	move.l	AddBrickQueuePtr,a2
	cmpa.l	#AddBrickQueue,a2	; Is queue empty?
	beq.s	.doneAddingBricks
	bsr	ProcessAddBrickQueue	; Need at least 1 brick or the gameloop moves to next level
	bsr	ProcessDirtyRowQueue

	bra.s	.processFrame
.doneAddingBricks
	move.l	AddTileQueuePtr,a0
	cmpa.l	#AddTileQueue,a0	; Is queue empty?
	beq.s	.doneAddingTiles
	bsr	ProcessAddTileQueue
	bsr	ProcessDirtyRowQueue

	bra.s	.processFrame
.doneAddingTiles
	
	moveq	#7,d7			; Some extra frames for brick animations
.l
	WAITLASTLINE	d0
	bsr	BrickAnim
	tst.l	DirtyRowBits
	beq	.nextBrickAnim
	bsr	ProcessDirtyRowQueue
.nextBrickAnim
	dbf	d7,.l

	bsr	ProcessAllDirtyRowQueue	; Draw any remaining bricks

	movem.l	(sp)+,d7/a2-a3
	rts

ClearGameArea:
	bsr	ClearEnemies
	bsr	ClearBobs
	bsr	ClearProtectiveTiles

.clearBricksAndTiles
	lea	GAMEAREA,a5
	add.l	#40,a5			; Skip top border
	moveq	#29,d0
.rowLoop
	addq.l	#3,a5			; Ignore padding and border
	moveq	#38-1,d1
.colLoop
		tst.b	(a5)
		beq	.skip

		movem.l	d0-d1,-(sp)
		bsr	RemoveBrick
		movem.l	(sp)+,d0-d1
.skip
		clr.b	(a5)+
		dbf	d1,.colLoop
	dbf	d0,.rowLoop

 	bsr	ResetBrickAnim

	rts

; In:   = a5 Adress pointing to a GAMEAREA byte
; Out:	= d0.w X
; Out:	= d1.w Y
GetCoordsFromGameareaPtr:
	move.l	a5,d0
	sub.l	#GAMEAREA,d0		; Which GAMEAREA byte is it?

	add.l	d0,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a0
	add.l	d0,a0

	moveq	#0,d0
	moveq	#0,d1
	move.b	(a0)+,d0		; Col / X pos
	subq.w	#1,d0		        ; Compensate for empty first byte in GAMEAREA
	move.b	(a0),d1			; Row / Y pos
	lsl.w   #3,d0                   ; Convert to pixels
	lsl.w   #3,d1
	rts

; In:   = a5 Adress pointing to a GAMEAREA byte
; Out:	= d0.b Column
; Out:	= d1.b Row
GetRowColFromGameareaPtr:
	move.l	a5,d0
	sub.l	#GAMEAREA,d0		; Which GAMEAREA byte is it?

	add.l	d0,d0
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a0
	add.l	d0,a0

	moveq	#0,d0
	moveq	#0,d1
	move.b	(a0)+,d0
	move.b	(a0),d1

	rts

RestoreGamescreen:
	movem.l	d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2

	bsr	CopyRestoreGamearea

	add.l	#(ScrBpl*255*4),a0	; Restore last line with CPU
	add.l	#(ScrBpl*255*4),a1
	move.w	#ScrBpl-1,d0
.l
	move.b	ScrBpl*0(a0),ScrBpl*0(a1)
	move.b	ScrBpl*1(a0),ScrBpl*1(a1)
	move.b	ScrBpl*2(a0),ScrBpl*2(a1)
	move.b	ScrBpl*3(a0),ScrBpl*3(a1)
	addq.l	#1,a0
	addq.l	#1,a1
	dbf	d0,.l

	movem.l	(sp)+,d2/a0/a1/a6

	rts

ClearGamescreen:
        move.l	a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE,a0
	moveq	#0,d0
	move.w	#(64*255*4)+20,d1
        bsr     ClearBlitWords

	add.l	#(ScrBpl*255*4),a0	; Clear last line with CPU
	move.w	#ScrBpl-1,d0
.l
	clr.b	ScrBpl*0(a0)
	clr.b	ScrBpl*1(a0)
	clr.b	ScrBpl*2(a0)
	clr.b	ScrBpl*3(a0)
	addq.l	#1,a0
	dbf	d0,.l

        move.l	(sp)+,a6
        rts