InitializePlayerAreas:
	movem.l	d2/a6,-(sp)

	lea	GAMEAREA,a0
	lea 	CUSTOM,a6
;-------
.player0
	tst.b	Player0Enabled
	bmi.s	.disablePlayer0

        move.l  #37,d0
	moveq	#$02,d1
        bsr     UpdateScoreArea
	bsr	RestoreBat0Area

	moveq	#$00,d1
	bra.s	.updatePlayer0Area
.disablePlayer0
        move.l  #37,d0
	moveq	#$01,d1
        bsr     UpdateScoreArea

	movem.l	d0-d1/a0,-(sp)

	move.l	GAMESCREEN_BITMAPBASE,a0
	move.l	#(ScrBpl*24*4)+38,d2
	add.l 	d2,a0
	moveq	#ScrBpl-2,d0
	move.w	#(64*(256-24-24)*4)+1,d1

	bsr	ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l 	d2,a0
	bsr	ClearBlitWords

	movem.l	(sp)+,d0-d1/a0

.updatePlayer0Area
	move.w	#25,d2
	move.w	d2,d0
	mulu.w	#41,d0
        add.w	#41*4-1,d0

        bsr     UpdateVerticalPlayerArea
;-------
.player1
	tst.b	Player1Enabled
	bmi.s	.disablePlayer1

        move.l  #41*31+1,d0
	moveq	#$03,d1
        bsr     UpdateScoreArea
	bsr	RestoreBat1Area

	moveq	#$00,d1
	bra.s	.updatePlayer1Area
.disablePlayer1
        move.l  #41*31+1,d0
	moveq	#$01,d1
        bsr     UpdateScoreArea

	movem.l	d0-d1/a0,-(sp)

	move.l	GAMESCREEN_BITMAPBASE,a0
	move.l	#(ScrBpl*24*4),d2
	add.l 	d2,a0
	moveq	#ScrBpl-2,d0
	move.w	#(64*(256-24-24)*4)+1,d1

	bsr	ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l 	d2,a0
	bsr	ClearBlitWords
	
	movem.l	(sp)+,d0-d1/a0

.updatePlayer1Area
	move.w	#25,d2
	move.w	d2,d0
	mulu.w	#41,d0
        add.w   #41*3+1,d0

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
	moveq	#$01,d1
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
	move.w	#41*31+36,d0

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
	moveq	#$01,d1
        bsr     UpdateScoreArea

	movem.l	d0-d1/a0,-(sp)

	move.l	GAMESCREEN_BITMAPBASE,a0
	moveq	#4,d2
	add.l 	d2,a0
	moveq	#ScrBpl-32,d0
	move.w	#(64*8*4)+16,d1

	bsr	ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l 	d2,a0
	bsr	ClearBlitWords
	
	movem.l	(sp)+,d0-d1/a0

.updatePlayer3Area
	move.w	#31,d2
	move.w	#36,d0

        bsr     UpdateHorizontalPlayerArea

.exit
	movem.l	(sp)+,d2/a6
	rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Offset to start of score area
; In:   d1.b = Tile code to set in score area
UpdateScoreArea:
	move.b	d1,(a0,d0)		; Enable Player 0 score area
	move.b	d1,1(a0,d0)
	move.b	d1,2(a0,d0)
	move.b	d1,3(a0,d0)

        rts

RestoreBat0Area:
	movem.l	d1/d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	#(ScrBpl*24*4)+38,d0
	add.l 	d0,a0
	add.l 	d0,a1
	moveq	#ScrBpl-2,d1
	move.w	#(64*(256-24-24)*4)+1,d2

	bsr	CopyRestoreGamearea
	movem.l	(sp)+,d1/d2/a0/a1/a6

	rts

RestoreBat1Area:
	movem.l	d1/d2/a0/a1/a6,-(sp)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	#(ScrBpl*24*4),d0
	add.l 	d0,a0
	add.l 	d0,a1
	moveq	#ScrBpl-2,d1
	move.w	#(64*(256-24-24)*4)+1,d2

	bsr	CopyRestoreGamearea
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
.playerLoop
	move.b	d1,(a0,d0)
	subi.w	#41,d0                  ; Stupidity - WHY can't I do "sub dx,dy" here???
	dbf	d2,.playerLoop

        rts

; In:   a0 = Address to GAMEAREA
; In:   d0.w = Initial player area offset (within GAMEAREA)
; In:   d1.b = Tile code to set in player area
; In:   d2.w = Number of tiles to update
UpdateHorizontalPlayerArea:
.playerLoop
	move.b	d1,(a0,d0)
	subq.w	#1,d0
	dbf	d2,.playerLoop

        rts


OptimizeCopperlist:
	move.l	d7,-(sp)

	move.l	FreeDirtyRowStackPtr,a1	; Add dirty row for later gfx update
	move.l	(a1),a1

	moveq	#32-1,d7
.fillStack
	move.w	d7,(a1)+
	addq.l	#4,FreeDirtyRowStackPtr
	addq.w	#1,DirtyRowCount
	dbf	d7,.fillStack

	bsr	ProcessAllDirtyRowQueue

	move.l	(sp)+,d7
	rts



InitGameareaForNextLevel:
	movem.l	a2/d7,-(sp)

	lea	LEVELPTR,a0
	move.l	(a0),a0
	move.l	(a0),d0
	bne.s	.addBricks
.reset
	move.l	#LEVEL_TABLE,LEVELPTR	; Reset from start
	move.l	LEVELPTR,a0

.addBricks
	move.l	(a0)+,a1
	move.l	a0,LEVELPTR		; Update pointer

	move.l	AddBrickQueuePtr,a0

	moveq	#0,d7
.addLoop
	cmpi.w	#41*32,d7
	beq.s	.processQ

	move.b	(a1)+,d0
	beq.s	.next
	cmpi.b	#$1f,d0			; Is it a brick?
	bhi.s	.brick

	IFEQ	ENABLE_DEBUG_BRICKS	; Skip for DEBUG bricks

	lea	GAMEAREA,a2		; Add singletile to GAMEAREA immediately
	add.l	d7,a2
	move.b	d0,-1(a2)
	bra.s	.next
	
	ENDIF

.brick
	move.b	d0,(a0)+		; Brick code
	cmpi.b	#BRICK_2ND_BYTE,d0
	beq.s	.addPos
	bra.s	.next
.addPos
	move.w	d7,d0
	subq.w	#2,d0
	move.w	d0,(a0)+		; Position in GAMEAREA
.next
	addq.w	#1,d7
	bra.s	.addLoop

.processQ
	move.l	a0,AddBrickQueuePtr	; Point to 1 beyond the last item

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
	beq.s	.done
	bsr	ProcessAddBrickQueue	; Need at least 1 brick or the gameloop moves to next level
	bsr	ProcessDirtyRowQueue

	bra.s	.processFrame
.done
	
	moveq	#7,d7			; Some extra frames for brick animations
.l
	WAITLASTLINE	d0
	bsr	BrickAnim
	tst.w	DirtyRowCount
	beq	.nextBrickAnim
	bsr	ProcessDirtyRowQueue
.nextBrickAnim
	dbf	d7,.l

	bsr	ProcessAllDirtyRowQueue	; Draw any remaining bricks

	movem.l	(sp)+,a2/d7
	rts

ClearGameArea:
	bsr	ClearEnemies
	bsr	ClearBobs

	lea	GAMEAREA,a5
	add.l	#40,a5			; Skip top border
	moveq	#29,d0
.rowLoop
	addq.l	#3,a5			; Ignore padding and border
	moveq	#38-1,d1
.colLoop
		movem.l	d0-d1,-(sp)
		bsr	RemoveBrick
		tst.w	DirtyRowCount
		beq	.skip
		bsr	ProcessDirtyRowQueue
.skip
		movem.l	(sp)+,d0-d1
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