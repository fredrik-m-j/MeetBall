EditHiScore:            dc.b    -1              ; Flag indicating edit mode
DirtyInitials:          dc.b    -1              ; Flag indicating need for re-draw

; Cursor Y offset from SCREEN top
CursorPlayer0Y:         dc.b    0
CursorPlayer1Y:         dc.b    0
CursorPlayer2Y:         dc.b    0
CursorPlayer3Y:         dc.b    0

; Cursor X pos offset (0..3)
CursorPlayer0Pos:       dc.b    0
CursorPlayer1Pos:       dc.b    0
CursorPlayer2Pos:       dc.b    0
CursorPlayer3Pos:       dc.b    0

HiScorePlayer0Fire      dc.b    0
HiScorePlayer1Fire      dc.b    0
HiScorePlayer2Fire      dc.b    0
HiScorePlayer3Fire      dc.b    0

Player0InitialsBuffer:  dc.l    $41414100       ; A-Z $41-$5a
Player1InitialsBuffer:  dc.l    $41414100
Player2InitialsBuffer:  dc.l    $41414100
Player3InitialsBuffer:  dc.l    $41414100

ResetHiScoreEntry:
        clr.l   CursorPlayer0Y
        clr.l   CursorPlayer0Pos
        clr.l   HiScorePlayer0Fire
        move.b  #-1,EditHiScore
        move.b  #-1,DirtyInitials
        rts

ShowHiscore:
        movem.l d2/a5,-(sp)
        clr.b   FrameTick
        move.b  #6,AttractCount

        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2
        bsr     ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	bsr     CopyEscGfx

	move.l	COPPTR_CREDITS,a1
	jsr	LoadCopper

        bsr     DrawHiscore

        tst.b   AttractState
        bmi.s   .doHiscore
        bra.s   .attractHiscoreLoop
.doHiscore
        bsr     CheckHiScores
        clr.b   DirtyInitials
        bsr     DrawInitials

.viewHiscoreLoop
        WAITLASTLINE d0

	tst.b	KEYARRAY+KEY_ESCAPE     ; Exit hiscore on ESC?
	bne.s	.exitHiScoreEntry

	bsr	CheckFirebuttons
	tst.b	d0                      ; Exit hiscore on FIRE?
        bne.s   .viewHiscoreLoop
        
        bra.s   .exitHiScoreEntry

.attractHiscoreLoop
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        blo.s   .viewAttract
        clr.b   FrameTick

	subq.b	#1,AttractCount
	beq     .exitAttract

.viewAttract
        WAITLASTLINE d0

	tst.b	KEYARRAY+KEY_ESCAPE     ; Got to menu on ESC?
	bne.s	.exitAttract

	bsr	CheckFirebuttons
	tst.b	d0                      ; Got to menu on FIRE?
        bne.s   .attractHiscoreLoop
        bra.s   .exitAttract

.exitHiScoreEntry
        move.l	COPPTR_CREDITS,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
	move.l  a0,-(sp)
	jsr	GfxAndMusicFadeOut
	move.l  (sp)+,a0
	jsr	ResetFadePalette

        bsr     ResetHiScoreEntry
        bra.s   .exit

.exitAttract
        move.l	COPPTR_CREDITS,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
	move.l  a0,-(sp)
	jsr     SimpleFadeOut
	move.l  (sp)+,a0
        jsr	ResetFadePalette
.exit
        movem.l (sp)+,d2/a5
        rts

DrawHiscore:
        lea     HISCORE0_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*9*4)+16+ScrBpl,a2      ; Skip to suitable bitplane/color
        moveq   #ScrBpl-8,d5
        move.w  #(64*8*4)+4,d6
        bsr     DrawStringBuffer
        lea     HISCORE1_STR,a0
        COPYSTR a0,a1
        add.l 	#(ScrBpl*7*4),a2
        bsr     DrawStringBuffer

        lea     RANK_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*40*4)+15+ScrBpl,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        moveq   #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6
        bsr     DrawStringBufferRightAligned

        lea     SCORE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*40*4)+22+ScrBpl,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        moveq   #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6
        bsr     DrawStringBufferRightAligned

        lea     NAME_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*40*4)+28+ScrBpl,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        moveq   #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6
        bsr     DrawStringBufferRightAligned

        bsr     DrawRankValues
        bsr     DrawScoreValues
        clr.b   DirtyInitials
        bsr     DrawInitials

        rts

DrawRankValues:
        moveq   #1,d1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+14+ScrBpl,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        moveq   #ScrBpl-4,d5
        move.w  #(64*7*4)+2,d6
.rankLoop
        moveq   #0,d0
        move.b  d1,d0
        jsr     Binary2Decimal

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #".",-1(a1)
        clr.b   (a1)

        move.l  d1,-(sp)

        bsr     DrawStringBufferRightAligned
        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4),a2        ; Next row
        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4),a3

        move.l  (sp)+,d1

        addq.b  #1,d1
        cmp.b   #11,d1
        beq.s   .doneRank
        bra.s   .rankLoop
.doneRank
        rts

; Scores in the score column
DrawScoreValues:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+18,a0
        moveq   #ScrBpl-8,d1
        move.w  #(64*HISCORE_ROWHEIGHT*10*4)+4,d2

        bsr     ClearBlitWords

        lea     HighScores,a4

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+22+ScrBpl,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        moveq   #ScrBpl-8,d5
        move.w  #(64*7*4)+4,d6

        moveq   #9,d7
.scoreLoop
        move.l  (a4)+,d0
        jsr     Binary2Decimal

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        bsr     DrawStringBufferRightAligned

        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4),a2        ; Next row
        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4),a3
        addq.l  #4,a4                                   ; Skip initials column

        dbf     d7,.scoreLoop
.done
        rts

; Initials in the name column
DrawInitials:
        tst.b   DirtyInitials
        bne.s   .done

        ; Clear one bitplane (text) to avoid interference with cursor bitplane.
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+24+ScrBpl,a0
        move.w  #ScrBpl-6+ScrBpl+ScrBpl+ScrBpl,d1
        move.w  #(64*HISCORE_ROWHEIGHT*10*1)+3,d2

        bsr     ClearBlitWords

        lea     HighScores,a4

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+28+ScrBpl,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        moveq   #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6

        moveq   #9,d7
.initialsLoop
        addq.l   #4,a4                                  ; Skip score column

        lea     STRINGBUFFER,a1
        COPYSTR a4,a1

        bsr     DrawStringBufferRightAligned

        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4),a2        ; Next row
        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4),a3

        dbf     d7,.initialsLoop

        move.b  #-1,DirtyInitials
.done
        rts


CheckHiScores:
        ; move.l  #30001,Player0Score
        ; move.l  #30001,Player1Score
        ; move.l  #30001,Player2Score
        ; move.l  #30001,Player3Score
.doHiscore
        bsr     CreateSortedNewHiScoreEntries

        move.l  d7,-(sp)

        lea     SortedNewHiScoreEntries,a0
        moveq   #3,d7
.l
        move.l  a0,a2                   ; a2 = current hiscore entry
        move.l  (a0)+,a3
        move.l  (a3),d0

        ; move.l  #30001,d0

        bsr	CheckPlayerRank
        move.w  d1,(a0)+                ; Store rank

        tst.b   d1
        bmi.s   .noHiscore

        move.l  a0,-(sp)
        bsr     InsertHiScoreEntry
        move.l  a0,4+2(a2)              ; Store initials adress
        
        clr.b   DirtyInitials
        move.l  (sp)+,a0
.noHiscore
        addq.l  #4,a0                   ; Skip initials
        dbf     d7,.l

        bsr     CheckDrawHiScoreBatsAndCursorSetup
        bsr     DrawScoreValues

        tst.b   EditHiScore
        bne.s   .exit

        bsr     AddHiScoreLoop

.exit
        bsr     InitPlayerBobs          ; Restore any bobs that might got "destroyed"

        move.l  (sp)+,d7
        rts

; In:   a3 = Address to New HiScore Entry.
; In:   d1.w = Position in hiscore list (zero-indexed).
; Out:  a0 = Adress to initials in HighScores struct.
InsertHiScoreEntry:      
        lea     HighScores,a0           ; Move lower ranked players down in the list
        add.l   #(10*8),a0
        lea     HighScores,a1
        add.l   #(11*8),a1

        moveq   #9,d0
        sub.w   d1,d0
.insertLoop
        move.l  -(a0),-(a1)             ; Name
        move.l  -(a0),-(a1)             ; Score
        dbf     d0,.insertLoop

        move.l  (a3),(a0)+              ; Set new score

        rts


CreateSortedNewHiScoreEntries:
        lea     SortedNewHiScoreEntries,a0
        move.l  #Player0Score,(a0)+
        move.w  #10,(a0)+                       ; 10 = DUMMY rank
        clr.l   (a0)+
        move.l  #Player1Score,(a0)+
        move.w  #10,(a0)+
        clr.l   (a0)+
        move.l  #Player2Score,(a0)+
        move.w  #10,(a0)+
        clr.l   (a0)+
        move.l  #Player3Score,(a0)+
        move.w  #10,(a0)+
        clr.l   (a0)+

.bubbleLoop
        lea     SortedNewHiScoreEntries,a0

        moveq   #2,d7
        moveq   #0,d0                           ; Swap flag
.swapLoop
        move.l  (a0),a1
        move.l  HiScoreEntryStructSize(a0),a2

        move.l  (a2),d2

        cmp.l   (a1),d2
        ble.s   .sorted

        move.b  #1,d0
        move.l  a2,(a0)
        move.l  a1,HiScoreEntryStructSize(a0)

.sorted
        add.l   #HiScoreEntryStructSize,a0
        dbf     d7,.swapLoop

        tst.b   d0
        bne.s   .bubbleLoop     

        rts

; Find out what rank the score corresponds to.
; In:   d0.l = Player score
; Out:  d1.w = Position in hiscore list (zero-indexed), or -1 if no highscore.
CheckPlayerRank:
        movem.l  d2-d3/a4,-(sp)

        lea     HighScores,a4
        add.l   #(8*10),a4              ; +1 for looping reasons
        
        cmp.l   -8(a4),d0               ; Higher score than the bottom ranked?
        bmi.s   .no

        moveq   #9,d1
.findRankLoop
        subq.l  #8,a4
        cmp.l   (a4),d0
        dblt    d1,.findRankLoop

        addq.w  #1,d1                   ; Adjust for looping to -1


.rankCollisionLoop
        lea     SortedNewHiScoreEntries,a5
        moveq   #-1,d3                  ; Assume no collision
        addq.l  #4,a5                   ; Start at first rank
        moveq   #3,d2
.resolveCollisionLoop
        cmp.w   (a5),d1
        bne.s   .ok

        addq.w  #1,d1                   ; Resolve rank/score collision
        moveq   #0,d3
.ok
        add.l   #HiScoreEntryStructSize,a5
        dbf     d2,.resolveCollisionLoop

        tst.b   d3                      ; Repeat until no collision
        beq.s   .rankCollisionLoop
        bra.s   .exit

.no
        move.w  #-1,d1
.exit      
        movem.l  (sp)+,d2-d3/a4
        rts


CheckDrawHiScoreBatsAndCursorSetup:
        movem.l  a3-a4,-(sp)

        lea     SortedNewHiScoreEntries,a3
        moveq   #3,d7
.playerScoreLoop
        move.l  (a3)+,a4
        move.w  (a3)+,d1
        bmi.w   .next

        clr.b   EditHiScore

 	cmpa.l	#Player0Score,a4
	bne.s	.player1
	
        lea     Bat0,a0
        moveq   #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0
        addq.b  #1,d0

        move.b  d0,CursorPlayer0Y

        move.w  #88,hSprBobTopLeftXPos(a0)
        move.w  d0,hSprBobTopLeftYPos(a0)
        move.w	#(64*(BatVertMargin+8)*4)+1,hBobBlitSize(a0)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        bsr     CookieBlitToScreen

	bra.w	.next
.player1
	cmpa.l	#Player1Score,a4
	bne.s	.player2

        lea     Bat1,a0
        moveq   #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0
        addq.b  #1,d0

        move.b  d0,CursorPlayer1Y

        move.w  #88,hSprBobTopLeftXPos(a0)
        move.w  d0,hSprBobTopLeftYPos(a0)
        move.w	#(64*(BatVertMargin+8)*4)+1,hBobBlitSize(a0)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        bsr     CookieBlitToScreen
	
	bra.w	.next
.player2
	cmpa.l	#Player2Score,a4
	bne.s	.player3
	
        lea     Bat2,a0
        moveq   #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0
        addq.b  #1,d0

        move.b  d0,CursorPlayer2Y

        move.w  #56,hSprBobTopLeftXPos(a0)
        move.w  d0,hSprBobTopLeftYPos(a0)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        bsr     CookieBlitToScreen

	bra.s	.next
.player3
	lea     Bat3,a0
        moveq   #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0
        addq.b  #1,d0

        move.b  d0,CursorPlayer3Y

        move.w  #56,hSprBobTopLeftXPos(a0)
        move.w  d0,hSprBobTopLeftYPos(a0)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        bsr     CookieBlitToScreen
        
.next
        addq.l  #4,a3                   ; Skip initials
        dbf     d7,.playerScoreLoop

        movem.l  (sp)+,a3-a4
        rts


AddHiScoreLoop:
        ; Set / reuse players' initials
        lea     Bat0,a4
        bsr     FindHiScoreInitialsForBat
        tst.l   (a5)
        beq.s   .player1
        move.l  (a5),a5
        move.l  Player0InitialsBuffer,(a5)
.player1
        lea     Bat1,a4
        bsr     FindHiScoreInitialsForBat
        tst.l   (a5)
        beq.s   .player2
        move.l  (a5),a5
        move.l  Player1InitialsBuffer,(a5)
.player2
        lea     Bat2,a4
        bsr     FindHiScoreInitialsForBat
        tst.l   (a5)
        beq.s   .player3
        move.l  (a5),a5
        move.l  Player2InitialsBuffer,(a5)
.player3
        lea     Bat3,a4
        bsr     FindHiScoreInitialsForBat
        tst.l   (a5)
        beq.s   .doneInitials
        move.l  (a5),a5
        move.l  Player3InitialsBuffer,(a5)
.doneInitials
        clr.b   DirtyInitials

.editLoop
        addq.b  #1,FrameTick
        cmpi.b  #25,FrameTick
        bne.s   .edit

        bsr     ToggleCursors
        clr.b   FrameTick
.edit
	tst.b	KEYARRAY+KEY_ESCAPE     ; Exit hiscore on ESC?
	bne.w	.done

        btst	#0,FrameTick		; Limit time for user input
	bne.s	.skip
        btst	#1,FrameTick
	bne.s	.skip

        bsr     HiScoreUpdates

.skip
        WAITLASTLINE d0

        tst.l   CursorPlayer0Y          ; .l = all players done?
        bne.s   .continueEdit
        move.b  #-1,EditHiScore
        bsr     AwaitAllFirebuttonsReleased

.continueEdit
        tst.b   DirtyInitials
        bne.s   .noUpdate

        WAITLASTLINE d0
        bsr     DrawInitials

.noUpdate
        tst.b   EditHiScore
        bne.s   .done
        bra.w   .editLoop

.done
        rts

ToggleCursors:
        bsr     TogglePlayer0Cursor
        bsr     TogglePlayer1Cursor
        bsr     TogglePlayer2Cursor
        bsr     TogglePlayer3Cursor
        rts

TogglePlayer0Cursor:
        moveq   #0,d0
        move.b  CursorPlayer0Pos,d0
        add.b   d0,d0
        lea     (CursorMasks,pc,d0),a0
        move.b  CursorPlayer0Y,d0
        bsr     ToggleCursor
        rts
TogglePlayer1Cursor:
        moveq   #0,d0
        move.b  CursorPlayer1Pos,d0
        add.b   d0,d0
        lea     (CursorMasks,pc,d0),a0
        move.b  CursorPlayer1Y,d0
        bsr     ToggleCursor
        rts
TogglePlayer2Cursor:
        moveq   #0,d0
        move.b  CursorPlayer2Pos,d0
        add.b   d0,d0
        lea     (CursorMasks,pc,d0),a0
        move.b  CursorPlayer2Y,d0
        bsr     ToggleCursor
        rts
TogglePlayer3Cursor:
        moveq   #0,d0
        move.b  CursorPlayer3Pos,d0
        add.b   d0,d0
        lea     (CursorMasks,pc,d0),a0
        move.b  CursorPlayer3Y,d0
        bsr     ToggleCursor
        rts
CursorMasks:
        dc.w    %1111000000000000
        dc.w    %0000001111000000
        dc.w    %0000000000001111
        dc.w    %0000000000000000

; In:   d0.b = Cursor Y position.
; In:   a0 = Adress to cursor mask.
ToggleCursor:
        tst.b   d0
        beq.s   .done

        move.l  #ScrBpl*4,d1
        
        addq.w  #7,d0
        mulu    d1,d0

        add.w   #ScrBpl+ScrBpl,d0
        add.w   #26,d0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        add.l 	d0,a1
        not.w   (a1)

        move.w  (a0),d0
        and.w   d0,(a1)
.done
        rts

HiScoreUpdates:
        tst.b   CursorPlayer0Y          ; Got cursor / high score?
        beq.s   .player1

	lea	CUSTOM+JOY1DAT,a5
	jsr	agdJoyDetectMovement

	lea	Bat0,a4
	bsr	UpdatePlayerVerticalHiScore

	bsr	CheckPlayer0Fire
	tst.b	d0
	bne.s	.noPlayer0Fire
        tst.b   HiScorePlayer0Fire      ; Fire was already pressed?
        beq.s   .player1
        move.b  d0,HiScorePlayer0Fire

	addq.b  #1,CursorPlayer0Pos
        bsr     TogglePlayer0Cursor
        cmpi.b  #2,CursorPlayer0Pos
        bhi.s   .player0Done
        bra.s   .player1
.player0Done
        clr.b   CursorPlayer0Y
.noPlayer0Fire
        move.b  d0,HiScorePlayer0Fire

.player1
        tst.b   CursorPlayer1Y          ; Got cursor / high score?
        beq.s   .player2
	tst.b	Player1Enabled          ; What controls?
	beq.s	.joy0

	move.w	#Player1KeyUp,d0
	move.w	#Player1KeyDown,d1
	jsr	DetectUpDown
	bra.s	.updatePlayer1

.joy0
	lea	CUSTOM+JOY0DAT,a5
	jsr	agdJoyDetectMovement
.updatePlayer1
	lea	Bat1,a4
	bsr	UpdatePlayerVerticalHiScore

	bsr	CheckPlayer1Fire
	tst.b	d0
	bne.s	.noPlayer1Fire
        tst.b   HiScorePlayer1Fire      ; Fire was already pressed?
        beq.s   .player2
        move.b  d0,HiScorePlayer1Fire

	addq.b  #1,CursorPlayer1Pos
        bsr     TogglePlayer1Cursor
        cmpi.b  #2,CursorPlayer1Pos
        bhi.s   .player1Done
        bra.s   .player2
.player1Done
        clr.b   CursorPlayer1Y
.noPlayer1Fire
        move.b  d0,HiScorePlayer1Fire

.player2
        tst.b   CursorPlayer2Y          ; Got cursor / high score?
        beq.s   .player3
	tst.b	Player2Enabled          ; What controls?
	beq.s	.joy2

	move.w	#Player2KeyLeft,d0
	move.w	#Player2KeyRight,d1
	jsr	DetectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	lea	Bat2,a4
	bsr	UpdatePlayerHorizontalHiScore	; Process Joy2

	bsr	CheckPlayer2Fire
	tst.b	d0
	bne.s	.noPlayer2Fire
        tst.b   HiScorePlayer2Fire      ; Fire was already pressed?
        beq.s   .player3
        move.b  d0,HiScorePlayer2Fire

	addq.b  #1,CursorPlayer2Pos
        bsr     TogglePlayer2Cursor
        cmpi.b  #2,CursorPlayer2Pos
        bhi.s   .player2Done
        bra.s   .player3
.player2Done
        clr.b   CursorPlayer2Y
.noPlayer2Fire
        move.b  d0,HiScorePlayer2Fire

.player3
        tst.b   CursorPlayer3Y          ; Got cursor / high score?
        beq.s   .exit
	tst.b	Player3Enabled          ; What controls?
	beq.s	.joy3

	move.w	#Player3KeyLeft,d0
	move.w	#Player3KeyRight,d1
	jsr	DetectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	lea	Bat3,a4
	bsr	UpdatePlayerHorizontalHiScore	; Process Joy3 in upper nibble

	bsr	CheckPlayer3Fire
	tst.b	d0
	bne.s	.noPlayer3Fire
        tst.b   HiScorePlayer3Fire      ; Fire was already pressed?
        beq.s   .exit
        move.b  d0,HiScorePlayer3Fire

	addq.b  #1,CursorPlayer3Pos
        bsr     TogglePlayer3Cursor
        cmpi.b  #2,CursorPlayer3Pos
        bhi.s   .player3Done
        bra.s   .exit
.player3Done
        clr.b   CursorPlayer3Y
.noPlayer3Fire
        move.b  d0,HiScorePlayer3Fire
.exit
	rts



; In:   a4 = Adress to bat struct.
; In:   d3.w = Directional bits.
UpdatePlayerVerticalHiScore:
        cmpi.b	#JOY_NOTHING,d3
	beq.w	.done

        cmpa.l  #Bat0,a4                ; Player 0?
        bne.s   .player1

        lea     Player0InitialsBuffer,a0
        moveq   #0,d0
        move.b  CursorPlayer0Pos,d0

.0up	btst.l	#JOY_UP_BIT,d3
	bne.s	.0down

	bsr	HiScoreLetterIncrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player0InitialsBuffer,(a5)

        bsr     TogglePlayer0Cursor

	bra.s	.player1
.0down
        btst.l	#JOY_DOWN_BIT,d3
        bne.s	.player1

        bsr	HiScoreLetterDecrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player0InitialsBuffer,(a5)

        bsr     TogglePlayer0Cursor

.player1
        cmpa.l  #Bat1,a4                ; Player 1?
        bne.s   .done

        lea     Player1InitialsBuffer,a0
        moveq   #0,d0
        move.b  CursorPlayer1Pos,d0

.1up	btst.l	#JOY_UP_BIT,d3
	bne.s	.1down

	bsr	HiScoreLetterIncrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player1InitialsBuffer,(a5)

        bsr     TogglePlayer1Cursor

	bra.s	.done
.1down
        btst.l	#JOY_DOWN_BIT,d3
        bne.s	.done

        bsr	HiScoreLetterDecrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player1InitialsBuffer,(a5)

        bsr     TogglePlayer1Cursor
.done
        rts

UpdatePlayerHorizontalHiScore:
        cmpi.b	#JOY_NOTHING,d3
	beq.w	.done

        cmpa.l  #Bat2,a4                ; Player 2?
        bne.s   .player3

        lea     Player2InitialsBuffer,a0
        moveq   #0,d0
        move.b  CursorPlayer2Pos,d0

.2right	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.2left

	bsr	HiScoreLetterIncrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player2InitialsBuffer,(a5)

        bsr     TogglePlayer2Cursor

	bra.s	.player3
.2left
        btst.l	#JOY_LEFT_BIT,d3
        bne.s	.player3

        bsr	HiScoreLetterDecrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player2InitialsBuffer,(a5)

        bsr     TogglePlayer2Cursor

.player3
        cmpa.l  #Bat3,a4                ; Player 3?
        bne.s   .done

        lea     Player3InitialsBuffer,a0
        moveq   #0,d0
        move.b  CursorPlayer3Pos,d0

.3right	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.3left

	bsr	HiScoreLetterIncrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player3InitialsBuffer,(a5)

        bsr     TogglePlayer3Cursor

	bra.s	.done
.3left
        btst.l	#JOY_LEFT_BIT,d3
        bne.s	.done

        bsr	HiScoreLetterDecrease

        bsr     FindHiScoreInitialsForBat
        move.l  (a5),a5
        move.l  Player3InitialsBuffer,(a5)

        bsr     TogglePlayer3Cursor
.done
        rts


; In:   a0 = Adress to initials buffer.
; In:   d0.b = Buffer offset
HiScoreLetterIncrease:
        add.l   d0,a0
        addq.b  #1,(a0)

        cmp.b   #$5b,(a0)
        blo.s   .ok
        move.b  #$41,(a0)               ; Reset to A
.ok
        clr.b   DirtyInitials
        rts

; In:   a0 = Adress to initials buffer.
; In:   d0.b = Buffer offset
HiScoreLetterDecrease:
        add.l   d0,a0
        subq.b  #1,(a0)

        cmp.b   #$40,(a0)
        bhi.s   .ok
        move.b  #$5a,(a0)               ; Reset to Z
.ok
        clr.b  DirtyInitials
        rts


; In:   a4 = Adress to bat struct.
; Out:  a5 = Adress to first byte of high score initials.
FindHiScoreInitialsForBat:
        lea     SortedNewHiScoreEntries,a5

        moveq   #3,d7
.l
        move.l  (a5),d0
        cmp.l   hPlayerScore(a4),d0
        beq.s   .found
        add.l   #HiScoreEntryStructSize,a5
        dbf     d7,.l
.found
        addq.l  #6,a5
        rts