ShowHiscore:
        movem.l d2/a5,-(sp)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2
        bsr     ClearBlitWords

	move.l 	MENUSCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*3*4),a0
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l   #(ScrBpl*3*4),a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*14*4)+2,d2
        move.l  #$fffff000,d0
	bsr	CopyBlit

	move.l	COPPTR_CREDITS,a1
	jsr	LoadCopper

        bsr     DrawHiscore
        bsr     CheckHiScores

        move.l	COPPTR_CREDITS,a5
        move.l	hAddress(a5),a5
	lea	hColor00(a5),a5
        move.l  a5,a0
	bsr	GfxAndMusicFadeOut

	move.l	COPPTR_MENU,a1
	jsr	LoadCopper

        move.l  a5,a0
        bsr	ResetFadePalette

        movem.l (sp)+,d2/a5
        rts

DrawHiscore:
        lea     HISCORE0_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*9*4)+16+40,a2          ; Skip to suitable bitplane/color
        move.l  #ScrBpl-8,d5
        move.w  #(64*8*4)+4,d6
        bsr     DrawStringBuffer
        lea     HISCORE1_STR,a0
        COPYSTR a0,a1
        add.l 	#(ScrBpl*7*4),a2
        bsr     DrawStringBuffer

        lea     RANK_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*40*4)+15+40,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        move.l  #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6
        bsr     DrawStringBufferRightAligned

        lea     SCORE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*40*4)+22+40,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        move.l  #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6
        bsr     DrawStringBufferRightAligned

        lea     NAME_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*40*4)+28+40,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        move.l  #ScrBpl-6,d5
        move.w  #(64*7*4)+3,d6
        bsr     DrawStringBufferRightAligned

; RANK
        moveq   #1,d1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+14+40,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        move.l  #ScrBpl-4,d5
        move.w  #(64*7*4)+2,d6
.rankLoop
        moveq   #0,d0
        move.b  d1,d0
        bsr     Binary2Decimal

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #".",-1(a1)
        move.b  #0,(a1)

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

        bsr     DrawScoreList

        rts

; Scores & initials
DrawScoreList:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+18,a0
        move.w  #ScrBpl-14,d1
        move.w  #(64*HISCORE_ROWHEIGHT*10*4)+7,d2

        bsr     ClearBlitWords

        lea     HighScores,a4

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*HISCORE_LISTOFFSET_Y*4)+22+40,a2
        move.l  a2,a3
        add.l	#(ScrBpl*7*4),a3
        move.l  #ScrBpl-8,d5
        move.w  #(64*7*4)+4,d6

        moveq   #9,d7
.scoreLoop
        move.l   (a4)+,d0
        bsr     Binary2Decimal

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        bsr     DrawStringBufferRightAligned

        add.l 	#6,a2                                   ; Next column
        add.l 	#6,a3

        lea     STRINGBUFFER,a1
        COPYSTR a4,a1

        bsr     DrawStringBufferRightAligned

        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4)-6,a2      ; Next row
        add.l 	#(ScrBpl*HISCORE_ROWHEIGHT*4)-6,a3

        dbf     d7,.scoreLoop

        rts


CheckHiScores:
        ; move.l  #30001,Player0Score
        ; move.l  #30001,Player1Score
        ; move.l  #30001,Player2Score
        ; move.l  #30001,Player3Score

        bsr     CreateSortedPlayerScoreList

        move.l  d7,-(sp)

        lea     SortedPlayerScoreList,a0
        moveq   #3,d7
.l
        move.l  (a0)+,a3
        move.l  (a3),d0

        ; move.l  #30001,d0

        bsr	CheckPlayerRank
        move.w  d1,(a0)+                ; Store rank

        tst.b   d1
        bmi.s   .noHiscore

        move.l  a0,-(sp)
        bsr     InsertHiScoreEntry
        move.l  (sp)+,a0
.noHiscore
        dbf     d7,.l

        bsr     CheckBlitHiScoreBats
        bsr     DrawScoreList
        bsr     InitPlayerBobs          ; Restore any bobs that was destroyed

.viewHiscoreLoop
	tst.b	KEYARRAY+KEY_ESCAPE     ; Exit hiscore on ESC?
	bne.s	.exit

	bsr	CheckFirebuttons
	tst.b	d0                      ; Exit hiscore on FIRE?
        bne.s   .viewHiscoreLoop
.exit

        move.l  (sp)+,d7
        rts

; In:   a3 = Address to a player score.
; In:   d1.w = Position in hiscore list (zero-indexed).
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
        move.l  #$20202000,(a0)         ; Clear name (3 spaces + null)

        rts


CreateSortedPlayerScoreList:
        lea     SortedPlayerScoreList,a0
        move.l  #Player0Score,(a0)+
        move.w  #10,(a0)+                       ; 10 = DUMMY rank
        move.l  #Player1Score,(a0)+
        move.w  #10,(a0)+
        move.l  #Player2Score,(a0)+
        move.w  #10,(a0)+
        move.l  #Player3Score,(a0)+
        move.w  #10,(a0)+

.bubbleLoop
        lea     SortedPlayerScoreList,a0

        moveq   #2,d7
        moveq   #0,d0                           ; Swap flag
.swapLoop
        move.l  (a0),a1
        move.l  6(a0),a2

        move.l  (a2),d2

        cmp.l   (a1),d2
        ble.s   .sorted

        move.b  #1,d0
        move.l  a2,(a0)
        move.l  a1,6(a0)

.sorted
        addq.l  #6,a0
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
        lea     SortedPlayerScoreList,a5
        moveq   #-1,d3                  ; Assume no collision
        add.l   #4,a5                   ; Start at first rank
        moveq   #3,d2
.resolveCollisionLoop
        cmp.w   (a5),d1
        bne.s   .ok

        addq.w  #1,d1                   ; Resolve rank/score collision
        moveq   #0,d3
.ok
        add.l   #6,a5
        dbf     d2,.resolveCollisionLoop

        tst.b   d3                      ; Repeat until no collision
        beq.s   .rankCollisionLoop
        bra.s   .exit

.no
        move.w  #-1,d1
.exit      
        movem.l  (sp)+,d2-d3/a4
        rts


CheckBlitHiScoreBats:
        movem.l  a3-a4,-(sp)

        lea     SortedPlayerScoreList,a3
        moveq   #3,d7
.playerScoreLoop
        move.l  (a3)+,a4
        move.w  (a3)+,d1
        bmi.w   .next

 	cmpa.l	#Player0Score,a4
	bne.s	.player1
	
        lea     Bat0,a0
        move.w  #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0

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
        move.w  #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0

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
        move.w  #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0

        move.w  #56,hSprBobTopLeftXPos(a0)
        move.w  d0,hSprBobTopLeftYPos(a0)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        bsr     CookieBlitToScreen

	bra.s	.next
.player3
	lea     Bat3,a0
        move.w  #HISCORE_ROWHEIGHT,d0
        mulu.w  d1,d0
        add.w   #HISCORE_LISTOFFSET_Y,d0

        move.w  #56,hSprBobTopLeftXPos(a0)
        move.w  d0,hSprBobTopLeftYPos(a0)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        bsr     CookieBlitToScreen
        
.next
        dbf     d7,.playerScoreLoop

        movem.l  (sp)+,a3-a4
        rts