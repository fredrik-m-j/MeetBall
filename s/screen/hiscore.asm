Player0InitialsBuffer:  dc.l    $41414100	; A-Z $41-$5a
Player1InitialsBuffer:  dc.l    $41414100
Player2InitialsBuffer:  dc.l    $41414100
Player3InitialsBuffer:  dc.l    $41414100

InitHiscore:
	move.b	#-1,EditHiScore(a5)
	move.b	#-1,DirtyInitials(a5)	
	rts

ResetHiScoreEntry:
	clr.l	CursorPlayer0Y(a5)
	clr.l	CursorPlayer0Pos(a5)
	clr.l	HiScorePlayer0Fire(a5)
	move.b	#-1,EditHiScore(a5)
	move.b	#-1,DirtyInitials(a5)
	rts

ShowHiscorescreen:
	clr.b	FrameTick(a5)
	move.b	#6,ChillCount(a5)

	bsr		ClearBackscreen
	move.l	GAMESCREEN_BackPtr(a5),a1
	bsr		DrawEscButton

	jsr		AppendDisarmedSprites
	lea		Copper_MISC,a1
	jsr		LoadCopper

	bsr		DrawHiscore

	tst.b	UserIntentState(a5)
	beq.s	.doHiscore
	bhi.s	.chillHiscoreLoop
.doHiscore
	bsr		CheckHiScores
	clr.b	DirtyInitials(a5)
	bsr		DrawInitials

.viewHiscoreLoop
	WAITBOVP	d0

	tst.b	KeyArray+KEY_ESCAPE		; Exit hiscore on ESC?
	bne.s	.exitHiScoreEntry

	bsr		CheckFirebuttons
	tst.b	d0						; Exit hiscore on FIRE?
	bne.s	.viewHiscoreLoop
	
	bra.s	.exitHiScoreEntry

.chillHiscoreLoop
	addq.b	#1,FrameTick(a5)
	cmpi.b	#50,FrameTick(a5)
	blo.s	.chillFrame
	clr.b	FrameTick(a5)

	addq.b	#1,ChillTick(a5)

	bsr		ToggleBackscreenFireToStart

	subq.b	#1,ChillCount(a5)
	beq		.exitChill

.chillFrame
	WAITBOVP	d0

	tst.b	KeyArray+KEY_ESCAPE		; Go to title on ESC?
	bne.s	.exitChill

	bsr		CheckAllPossibleFirebuttons
	tst.b	d0						; Go to controls on FIRE?
	bne.s	.chillHiscoreLoop
	bra.s	.controls

.exitHiScoreEntry
	lea		Copper_MISC,a0
	lea		hColor00(a0),a0
	move.l	a0,-(sp)
	jsr		GfxAndMusicFadeOut		; Different fade after gameover
	move.l	(sp)+,a0
	jsr		ResetFadePalette

	bsr		ResetHiScoreEntry
	bra.s	.exit

.controls
	move.b  #USERINTENT_PLAY,UserIntentState(a5)
	bsr		FadeoutHiscorescreen
	bra		.exit
.exitChill
	bsr		FadeoutHiscorescreen
.exit

	rts

FadeoutHiscorescreen:
	lea		Copper_MISC,a0
	lea		hColor00(a0),a0
	move.l	a0,-(sp)
	jsr		SimpleFadeOut
	move.l	(sp)+,a0

	WAITVBL

	jsr		ResetFadePalette

	rts

DrawHiscore:
	lea		HISCORE0_STR,a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*9*4)+16+RL_SIZE,a2      ; Skip to suitable bitplane/color
	moveq	#RL_SIZE-8,d5
	move.w	#(64*8*4)+4,d6
	bsr		DrawStringBuffer
	lea		HISCORE1_STR,a0
	COPYSTR	a0,a1
	add.l	#(RL_SIZE*7*4),a2
	bsr		DrawStringBuffer

	lea		RANK_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*40*4)+15+RL_SIZE,a2
	move.l	a2,a3
	add.l	#(RL_SIZE*7*4),a3
	moveq	#RL_SIZE-6,d5
	move.w	#(64*7*4)+3,d6
	bsr     DrawStringBufferRightAligned

	lea		SCORE_STR,a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*40*4)+22+RL_SIZE,a2
	move.l	a2,a3
	add.l	#(RL_SIZE*7*4),a3
	moveq	#RL_SIZE-6,d5
	move.w	#(64*7*4)+3,d6
	bsr     DrawStringBufferRightAligned

	lea		NAME_STR,a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*40*4)+28+RL_SIZE,a2
	move.l	a2,a3
	add.l	#(RL_SIZE*7*4),a3
	moveq	#RL_SIZE-6,d5
	move.w	#(64*7*4)+3,d6
	bsr     DrawStringBufferRightAligned

	bsr		DrawRankValues
	bsr		DrawScoreValues
	clr.b	DirtyInitials(a5)
	bsr		DrawInitials

	rts

DrawRankValues:
	moveq	#1,d1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*HISCORE_LISTOFFSET_Y*4)+14+RL_SIZE,a2
	move.l	a2,a3
	add.l	#(RL_SIZE*7*4),a3
	moveq	#RL_SIZE-4,d5
	move.w	#(64*7*4)+2,d6
.rankLoop
	moveq	#0,d0
	move.b	d1,d0
	jsr		Binary2Decimal

	lea		StringBuffer,a1
	COPYSTR	a0,a1
	move.b	#".",-1(a1)
	clr.b	(a1)

	move.l	d1,-(sp)

	bsr     DrawStringBufferRightAligned
	add.l 	#(RL_SIZE*HISCORE_ROWHEIGHT*4),a2	; Next row
	add.l 	#(RL_SIZE*HISCORE_ROWHEIGHT*4),a3

	move.l	(sp)+,d1

	addq.b	#1,d1
	cmp.b	#11,d1
	beq.s	.doneRank
	bra.s	.rankLoop
.doneRank
	rts

; Scores in the score column
; In:	a6 = address to CUSTOM $dff000
DrawScoreValues:
	movem.l	d5-d7/a2-a4,-(sp)

	move.l  GAMESCREEN_BackPtr(a5),a0
	add.l 	#(RL_SIZE*HISCORE_LISTOFFSET_Y*4)+18,a0
	moveq	#RL_SIZE-8,d0
	move.w  #(64*HISCORE_ROWHEIGHT*10*4)+4,d1

	bsr		ClearBlitWords

	lea		HighScores,a4

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*HISCORE_LISTOFFSET_Y*4)+22+RL_SIZE,a2
	move.l	a2,a3
	add.l	#(RL_SIZE*7*4),a3
	moveq	#RL_SIZE-8,d5
	move.w	#(64*7*4)+4,d6

	moveq	#9,d7
.scoreLoop
	move.l	(a4)+,d0
	jsr		Binary2Decimal

	lea		StringBuffer,a1
	COPYSTR	a0,a1

	bsr     DrawStringBufferRightAligned

	add.l 	#(RL_SIZE*HISCORE_ROWHEIGHT*4),a2	; Next row
	add.l 	#(RL_SIZE*HISCORE_ROWHEIGHT*4),a3
	addq.l	#4,a4					; Skip initials column

	dbf		d7,.scoreLoop
.done
	movem.l	(sp)+,d5-d7/a2-a4
	rts

; Initials in the name column
; In:	a6 = address to CUSTOM $dff000
DrawInitials:
	tst.b	DirtyInitials(a5)
	bne.s	.fastExit

	; Clear one bitplane (text) to avoid interference with cursor bitplane.
	move.l  GAMESCREEN_BackPtr(a5),a0
	add.l 	#(RL_SIZE*HISCORE_LISTOFFSET_Y*4)+24+RL_SIZE,a0
	move.w  #RL_SIZE-6+RL_SIZE+RL_SIZE+RL_SIZE,d0
	move.w  #(64*HISCORE_ROWHEIGHT*10*1)+3,d1

	bsr		ClearBlitWords

	lea		HighScores,a4

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(RL_SIZE*HISCORE_LISTOFFSET_Y*4)+28+RL_SIZE,a2
	move.l	a2,a3
	add.l	#(RL_SIZE*7*4),a3
	moveq	#RL_SIZE-6,d5
	move.w	#(64*7*4)+3,d6

	moveq	#9,d7
.initialsLoop
	addq.l	#4,a4					; Skip score column

	lea		StringBuffer,a1
	COPYSTR	a4,a1

	bsr     DrawStringBufferRightAligned

	add.l 	#(RL_SIZE*HISCORE_ROWHEIGHT*4),a2	; Next row
	add.l 	#(RL_SIZE*HISCORE_ROWHEIGHT*4),a3

	dbf		d7,.initialsLoop

	move.b	#-1,DirtyInitials(a5)

.fastExit
	rts


; In:	a6 = address to CUSTOM $dff000
CheckHiScores:
	movem.l	d7/a2-a4,-(sp)

	bsr		CreateSortedNewHiScoreEntries

	lea		SortedNewHiScoreEntriesPtr(a5),a4
	moveq	#3,d7
.l
	move.l	a4,a2					; a2 = current hiscore entry
	move.l	(a4)+,a3
	move.l	(a3),d0

	; move.l  #30001,d0

	bsr		CheckPlayerRank
	move.w	d1,(a4)+				; Store rank

	tst.b	d1
	bmi.s	.noHiscore

	bsr		InsertHiScoreEntry
	move.l	a0,4+2(a2)				; Store initials adress
	
	clr.b	DirtyInitials(a5)
.noHiscore
	addq.l	#4,a4					; Skip initials
	dbf		d7,.l

	bsr     CheckDrawHiScoreBatsAndCursorSetup
	bsr		DrawScoreValues

	tst.b	EditHiScore(a5)
	bne.s	.exit

	bsr		AddHiScoreLoop

.exit
	bsr		InitPlayerBobs			; Restore any bobs that might got "destroyed"

	movem.l	(sp)+,d7/a2-a4
	rts

; In:   a3 = Address to New HiScore Entry.
; In:   d1.w = Position in hiscore list (zero-indexed).
; Out:  a0 = Adress to initials in HighScores struct.
InsertHiScoreEntry:      
	lea		HighScores,a0			; Move lower ranked players down in the list
	add.l	#(10*8),a0
	lea		HighScores,a1
	add.l	#(11*8),a1

	moveq	#9,d0
	sub.w	d1,d0
.insertLoop
	move.l	-(a0),-(a1)				; Name
	move.l	-(a0),-(a1)				; Score
	dbf		d0,.insertLoop

	move.l	(a3),(a0)+				; Set new score

	rts


CreateSortedNewHiScoreEntries:
	lea		SortedNewHiScoreEntriesPtr(a5),a0
	move.l	#Variables+Player0Score,(a0)+
	move.w	#10,(a0)+				; 10 = DUMMY rank
	clr.l	(a0)+
	move.l	#Variables+Player1Score,(a0)+
	move.w	#10,(a0)+
	clr.l	(a0)+
	move.l	#Variables+Player2Score,(a0)+
	move.w	#10,(a0)+
	clr.l	(a0)+
	move.l	#Variables+Player3Score,(a0)+
	move.w	#10,(a0)+
	clr.l	(a0)+

.bubbleLoop
	lea		SortedNewHiScoreEntriesPtr(a5),a0

	moveq	#2,d7
	moveq	#0,d0					; Swap flag
.swapLoop
	move.l	(a0),a1
	move.l  HiscoreEntryStruct_SizeOf(a0),a2

	move.l	(a2),d2

	cmp.l	(a1),d2
	ble.s	.sorted

	move.b	#1,d0
	move.l	a2,(a0)
	move.l  a1,HiscoreEntryStruct_SizeOf(a0)

.sorted
	add.l	#HiscoreEntryStruct_SizeOf,a0
	dbf		d7,.swapLoop

	tst.b	d0
	bne.s	.bubbleLoop     

	rts

; Find out what rank the score corresponds to.
; In:   d0.l = Player score
; Out:  d1.w = Position in hiscore list (zero-indexed), or -1 if no highscore.
CheckPlayerRank:
	movem.l	d2-d3/a4,-(sp)

	lea		HighScores,a4
	add.l	#(8*10),a4				; +1 for looping reasons
	
	cmp.l	-8(a4),d0				; Higher score than the bottom ranked?
	bmi.s	.no

	moveq	#9,d1
.findRankLoop
	subq.l	#8,a4
	cmp.l	(a4),d0
	dblt	d1,.findRankLoop

	addq.w	#1,d1					; Adjust for looping to -1


.rankCollisionLoop
	lea		SortedNewHiScoreEntriesPtr(a5),a0
	moveq	#-1,d3					; Assume no collision
	addq.l	#4,a0					; Start at first rank
	moveq	#3,d2
.resolveCollisionLoop
	cmp.w	(a0),d1
	bne.s	.ok

	addq.w	#1,d1					; Resolve rank/score collision
	moveq	#0,d3
.ok
	add.l	#HiscoreEntryStruct_SizeOf,a0
	dbf		d2,.resolveCollisionLoop

	tst.b	d3						; Repeat until no collision
	beq.s	.rankCollisionLoop
	bra.s	.exit

.no
	move.w	#-1,d1
.exit      
	movem.l	(sp)+,d2-d3/a4
	rts


CheckDrawHiScoreBatsAndCursorSetup:
	movem.l	d7/a2-a4,-(sp)

	move.l	GAMESCREEN_BackPtr(a5),a4
	movea.l	a4,a2

	lea		SortedNewHiScoreEntriesPtr(a5),a0
	moveq	#3,d7
.playerScoreLoop
	move.l	(a0)+,a1
	move.w	(a0)+,d1
	bmi.w	.next

	clr.b	EditHiScore(a5)

	cmpa.l	#Variables+Player0Score,a1
	bne.s	.player1
	
	lea		Bat0,a3
	moveq	#HISCORE_ROWHEIGHT,d0
	mulu.w	d1,d0
	add.w	#HISCORE_LISTOFFSET_Y,d0
	addq.b	#1,d0

	move.b	d0,CursorPlayer0Y(a5)

	move.w  #88,hSprBobTopLeftXPos(a3)
	move.w  d0,hSprBobTopLeftYPos(a3)
	move.w	#(64*(BAT_VERTICALMARGIN+8)*4)+1,hBobBlitSize(a3)

	bsr		CookieBlitToScreen

	bra.w	.next
.player1
	cmpa.l	#Variables+Player1Score,a1
	bne.s	.player2

	lea		Bat1,a3
	moveq	#HISCORE_ROWHEIGHT,d0
	mulu.w	d1,d0
	add.w	#HISCORE_LISTOFFSET_Y,d0
	addq.b	#1,d0

	move.b	d0,CursorPlayer1Y(a5)

	move.w  #88,hSprBobTopLeftXPos(a3)
	move.w  d0,hSprBobTopLeftYPos(a3)
	move.w	#(64*(BAT_VERTICALMARGIN+8)*4)+1,hBobBlitSize(a3)

	bsr		CookieBlitToScreen
	
	bra.w	.next
.player2
	cmpa.l	#Variables+Player2Score,a1
	bne.s	.player3
	
	lea		Bat2,a3
	moveq	#HISCORE_ROWHEIGHT,d0
	mulu.w	d1,d0
	add.w	#HISCORE_LISTOFFSET_Y,d0
	addq.b	#1,d0

	move.b	d0,CursorPlayer2Y(a5)

	move.w  #48,hSprBobTopLeftXPos(a3)
	move.w  d0,hSprBobTopLeftYPos(a3)

	bsr		CookieBlitToScreen

	bra.s	.next
.player3
	lea		Bat3,a3
	moveq	#HISCORE_ROWHEIGHT,d0
	mulu.w	d1,d0
	add.w	#HISCORE_LISTOFFSET_Y,d0
	addq.b	#1,d0

	move.b	d0,CursorPlayer3Y(a5)

	move.w  #48,hSprBobTopLeftXPos(a3)
	move.w  d0,hSprBobTopLeftYPos(a3)

	bsr		CookieBlitToScreen
	
.next
	addq.l	#4,a0					; Skip initials
	dbf		d7,.playerScoreLoop

	movem.l	(sp)+,d7/a2-a4
	rts


AddHiScoreLoop:
	move.l	a4,-(sp)

	; Set / reuse players' initials
	lea		Bat0,a4
	bsr		FindHiScoreInitialsForBat
	tst.l	(a0)
	beq.s	.player1
	move.l	(a0),a0
	move.l  Player0InitialsBuffer,(a0)
.player1
	lea		Bat1,a4
	bsr		FindHiScoreInitialsForBat
	tst.l	(a0)
	beq.s	.player2
	move.l	(a0),a0
	move.l  Player1InitialsBuffer,(a0)
.player2
	lea		Bat2,a4
	bsr		FindHiScoreInitialsForBat
	tst.l	(a0)
	beq.s	.player3
	move.l	(a0),a0
	move.l  Player2InitialsBuffer,(a0)
.player3
	lea		Bat3,a4
	bsr		FindHiScoreInitialsForBat
	tst.l	(a0)
	beq.s	.doneInitials
	move.l	(a0),a0
	move.l  Player3InitialsBuffer,(a0)
.doneInitials
	clr.b	DirtyInitials(a5)

.editLoop
	addq.b	#1,FrameTick(a5)
	cmpi.b	#25,FrameTick(a5)
	bne.s	.edit

	bsr		ToggleCursors
	clr.b	FrameTick(a5)
.edit
	tst.b	KeyArray+KEY_ESCAPE		; Exit hiscore on ESC?
	bne.w	.done

	btst	#0,FrameTick(a5)		; Limit time for user input
	bne.s	.skip
	btst	#1,FrameTick(a5)
	bne.s	.skip

	bsr		HiScoreUpdates

.skip
	WAITBOVP	d0

	tst.l	CursorPlayer0Y(a5)		; .l = all players done?
	bne.s	.continueEdit
	move.b	#-1,EditHiScore(a5)
	bsr		AwaitAllFirebuttonsReleased

.continueEdit
	tst.b	DirtyInitials(a5)
	bne.s	.noUpdate

	WAITBOVP	d0
	bsr		DrawInitials

.noUpdate
	tst.b	EditHiScore(a5)
	bne.s	.done
	bra.w	.editLoop

.done
	move.l	(sp)+,a4
	rts

ToggleCursors:
	bsr		TogglePlayer0Cursor
	bsr		TogglePlayer1Cursor
	bsr		TogglePlayer2Cursor
	bsr		TogglePlayer3Cursor
	rts

TogglePlayer0Cursor:
	moveq	#0,d0
	move.b	CursorPlayer0Pos(a5),d0
	add.b	d0,d0
	lea		(CursorMasks,pc,d0),a0
	move.b	CursorPlayer0Y(a5),d0
	bsr		ToggleCursor
	rts
TogglePlayer1Cursor:
	moveq	#0,d0
	move.b	CursorPlayer1Pos(a5),d0
	add.b	d0,d0
	lea		(CursorMasks,pc,d0),a0
	move.b	CursorPlayer1Y(a5),d0
	bsr		ToggleCursor
	rts
TogglePlayer2Cursor:
	moveq	#0,d0
	move.b	CursorPlayer2Pos(a5),d0
	add.b	d0,d0
	lea		(CursorMasks,pc,d0),a0
	move.b	CursorPlayer2Y(a5),d0
	bsr		ToggleCursor
	rts
TogglePlayer3Cursor:
	moveq	#0,d0
	move.b	CursorPlayer3Pos(a5),d0
	add.b	d0,d0
	lea		(CursorMasks,pc,d0),a0
	move.b	CursorPlayer3Y(a5),d0
	bsr		ToggleCursor
	rts
CursorMasks:
	dc.w	%1111000000000000
	dc.w	%0000001111000000
	dc.w	%0000000000001111
	dc.w	%0000000000000000

; In:   d0.b = Cursor Y position.
; In:   a0 = Adress to cursor mask.
ToggleCursor:
	tst.b	d0
	beq.s	.done

	move.l	#RL_SIZE*4,d1
	
	addq.w	#7,d0
	mulu	d1,d0

	add.w	#RL_SIZE+RL_SIZE,d0
	add.w	#26,d0

	move.l  GAMESCREEN_BackPtr(a5),a1
	add.l	d0,a1
	not.w	(a1)

	move.w	(a0),d0
	and.w	d0,(a1)
.done
	rts

HiScoreUpdates:
	movem.l	d3/a2/a4,-(sp)

	tst.b	CursorPlayer0Y(a5)		; Got cursor / high score?
	beq.s	.player1

	lea		CUSTOM+JOY1DAT,a2
	jsr		agdJoyDetectMovement

	lea		Bat0,a4
	bsr		UpdatePlayerVerticalHiScore

	bsr		CheckPlayer0Fire
	tst.b	d0
	bne.s	.noPlayer0Fire
	tst.b	HiScorePlayer0Fire(a5)	; Fire was already pressed?
	beq.s	.player1
	move.b	d0,HiScorePlayer0Fire(a5)

	addq.b	#1,CursorPlayer0Pos(a5)
	bsr		TogglePlayer0Cursor
	cmpi.b	#2,CursorPlayer0Pos(a5)
	bhi.s	.player0Done
	bra.s	.player1
.player0Done
	clr.b	CursorPlayer0Y(a5)
.noPlayer0Fire
	move.b	d0,HiScorePlayer0Fire(a5)

.player1
	tst.b	CursorPlayer1Y(a5)		; Got cursor / high score?
	beq.s	.player2
	tst.b	Player1Enabled(a5)		; What controls?
	beq.s	.joy0

	move.w	#PLAYER1_KEYUP,d0
	move.w	#PLAYER1_KEYDOWN,d1
	jsr		DetectUpDown
	bra.s	.updatePlayer1

.joy0
	lea		CUSTOM+JOY0DAT,a2
	jsr		agdJoyDetectMovement
.updatePlayer1
	lea		Bat1,a4
	bsr		UpdatePlayerVerticalHiScore

	bsr		CheckPlayer1Fire
	tst.b	d0
	bne.s	.noPlayer1Fire
	tst.b	HiScorePlayer1Fire(a5)	; Fire was already pressed?
	beq.s	.player2
	move.b	d0,HiScorePlayer1Fire(a5)

	addq.b	#1,CursorPlayer1Pos(a5)
	bsr		TogglePlayer1Cursor
	cmpi.b	#2,CursorPlayer1Pos(a5)
	bhi.s	.player1Done
	bra.s	.player2
.player1Done
	clr.b	CursorPlayer1Y(a5)
.noPlayer1Fire
	move.b	d0,HiScorePlayer1Fire(a5)

.player2
	tst.b	CursorPlayer2Y(a5)		; Got cursor / high score?
	beq.s	.player3
	tst.b	Player2Enabled(a5)		; What controls?
	beq.s	.joy2

	move.w	#PLAYER2_KEYLEFT,d0
	move.w	#PLAYER2_KEYRIGHT,d1
	jsr		DetectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	lea		Bat2,a4
	bsr		UpdatePlayerHorizontalHiScore	; Process Joy2

	bsr		CheckPlayer2Fire
	tst.b	d0
	bne.s	.noPlayer2Fire
	tst.b	HiScorePlayer2Fire(a5)	; Fire was already pressed?
	beq.s	.player3
	move.b	d0,HiScorePlayer2Fire(a5)

	addq.b	#1,CursorPlayer2Pos(a5)
	bsr		TogglePlayer2Cursor
	cmpi.b	#2,CursorPlayer2Pos(a5)
	bhi.s	.player2Done
	bra.s	.player3
.player2Done
	clr.b	CursorPlayer2Y(a5)
.noPlayer2Fire
	move.b	d0,HiScorePlayer2Fire(a5)

.player3
	tst.b	CursorPlayer3Y(a5)		; Got cursor / high score?
	beq.s	.exit
	tst.b	Player3Enabled(a5)		; What controls?
	beq.s	.joy3

	move.w	#PLAYER3_KEYLEFT,d0
	move.w	#PLAYER3_KEYRIGHT,d1
	jsr		DetectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	lea		Bat3,a4
	bsr		UpdatePlayerHorizontalHiScore	; Process Joy3 in upper nibble

	bsr		CheckPlayer3Fire
	tst.b	d0
	bne.s	.noPlayer3Fire
	tst.b	HiScorePlayer3Fire(a5)	; Fire was already pressed?
	beq.s	.exit
	move.b	d0,HiScorePlayer3Fire(a5)

	addq.b	#1,CursorPlayer3Pos(a5)
	bsr		TogglePlayer3Cursor
	cmpi.b	#2,CursorPlayer3Pos(a5)
	bhi.s	.player3Done
	bra.s	.exit
.player3Done
	clr.b	CursorPlayer3Y(a5)
.noPlayer3Fire
	move.b	d0,HiScorePlayer3Fire(a5)
.exit

	movem.l	(sp)+,d3/a2/a4
	rts



; In:   a4 = Adress to bat struct.
; In:   d3.w = Directional bits.
UpdatePlayerVerticalHiScore:
	cmpi.b	#JOY_NOTHING,d3
	beq.w	.done

	cmpa.l	#Bat0,a4				; Player 0?
	bne.s	.player1

	lea		Player0InitialsBuffer,a0
	moveq	#0,d0
	move.b	CursorPlayer0Pos(a5),d0

.0up
	btst.l	#JOY_UP_BIT,d3
	bne.s	.0down

	bsr		HiScoreLetterIncrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player0InitialsBuffer,(a0)

	bsr		TogglePlayer0Cursor

	bra.s	.player1
.0down
	btst.l	#JOY_DOWN_BIT,d3
	bne.s	.player1

	bsr		HiScoreLetterDecrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player0InitialsBuffer,(a0)

	bsr		TogglePlayer0Cursor

.player1
	cmpa.l	#Bat1,a4				; Player 1?
	bne.s	.done

	lea		Player1InitialsBuffer,a0
	moveq	#0,d0
	move.b	CursorPlayer1Pos(a5),d0

.1up	
	btst.l	#JOY_UP_BIT,d3
	bne.s	.1down

	bsr		HiScoreLetterIncrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player1InitialsBuffer,(a0)

	bsr		TogglePlayer1Cursor

	bra.s	.done
.1down
	btst.l	#JOY_DOWN_BIT,d3
	bne.s	.done

	bsr		HiScoreLetterDecrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player1InitialsBuffer,(a0)

	bsr		TogglePlayer1Cursor
.done
	rts

UpdatePlayerHorizontalHiScore:
	cmpi.b	#JOY_NOTHING,d3
	beq.w	.done

	cmpa.l	#Bat2,a4				; Player 2?
	bne.s	.player3

	lea		Player2InitialsBuffer,a0
	moveq	#0,d0
	move.b	CursorPlayer2Pos(a5),d0

.2right
	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.2left

	bsr		HiScoreLetterIncrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player2InitialsBuffer,(a0)

	bsr		TogglePlayer2Cursor

	bra.s	.player3
.2left
	btst.l	#JOY_LEFT_BIT,d3
	bne.s	.player3

	bsr		HiScoreLetterDecrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player2InitialsBuffer,(a0)

	bsr		TogglePlayer2Cursor

.player3
	cmpa.l	#Bat3,a4				; Player 3?
	bne.s	.done

	lea		Player3InitialsBuffer,a0
	moveq	#0,d0
	move.b	CursorPlayer3Pos(a5),d0

.3right
	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.3left

	bsr		HiScoreLetterIncrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player3InitialsBuffer,(a0)

	bsr		TogglePlayer3Cursor

	bra.s	.done
.3left
	btst.l	#JOY_LEFT_BIT,d3
	bne.s	.done

	bsr		HiScoreLetterDecrease

	bsr		FindHiScoreInitialsForBat
	move.l	(a0),a0
	move.l  Player3InitialsBuffer,(a0)

	bsr		TogglePlayer3Cursor
.done
	rts


; In:   a0 = Adress to initials buffer.
; In:   d0.b = Buffer offset
HiScoreLetterIncrease:
	add.l	d0,a0
	addq.b	#1,(a0)

	cmp.b	#$5b,(a0)
	blo.s	.ok
	move.b	#$41,(a0)				; Reset to A
.ok
	clr.b	DirtyInitials(a5)
	rts

; In:   a0 = Adress to initials buffer.
; In:   d0.b = Buffer offset
HiScoreLetterDecrease:
	add.l	d0,a0
	subq.b	#1,(a0)

	cmp.b	#$40,(a0)
	bhi.s	.ok
	move.b	#$5a,(a0)				; Reset to Z
.ok
	clr.b	DirtyInitials(a5)
	rts


; In:   a4 = Adress to bat struct.
; Out:  a0 = Adress to first byte of high score initials.
FindHiScoreInitialsForBat:
	lea		SortedNewHiScoreEntriesPtr(a5),a0

	moveq	#3,d1
.l
	move.l	(a0),d0
	cmp.l	hPlayerScore(a4),d0
	beq.s	.found
	add.l	#HiscoreEntryStruct_SizeOf,a0
	dbf		d1,.l
.found
	addq.l	#6,a0
	rts
