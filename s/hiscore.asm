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
        add.l 	#(ScrBpl*64*4)+14+40,a2
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
        add.l 	#(ScrBpl*13*4),a2               ; Next row
        add.l 	#(ScrBpl*13*4),a3

        move.l  (sp)+,d1

        addq.b  #1,d1
        cmp.b   #11,d1
        beq.s   .doneRank
        bra.s   .rankLoop
.doneRank

; Scores & initials
        lea     HighScores,a4

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*64*4)+22+40,a2
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

        add.l 	#6,a2                           ; Next column
        add.l 	#6,a3

        lea     STRINGBUFFER,a1
        COPYSTR a4,a1

        bsr     DrawStringBufferRightAligned

        add.l 	#(ScrBpl*13*4)-6,a2               ; Next row
        add.l 	#(ScrBpl*13*4)-6,a3

        dbf     d7,.scoreLoop

        rts


CheckHiScores:
        bsr     CreateSortedPlayerScoreList

        move.l  d7,-(sp)

        lea     SortedPlayerScoreList,a0
        moveq   #3,d7
.l
        move.l  (a0)+,a1
        move.l  (a1),d0

        bsr	CheckPlayerHiScore

        tst.b   d1
        bmi.s   .noHiscore

        bsr     InsertHiScoreEntry
.noHiscore
        dbf     d7,.l


.viewHiscoreLoop
	tst.b	KEYARRAY+KEY_ESCAPE     ; Exit hiscore on ESC?
	bne.s	.exit

	bsr	CheckFirebuttons
	tst.b	d0                      ; Exit hiscore on FIRE?
        bne.s   .viewHiscoreLoop
.exit

        move.l  (sp)+,d7
        rts

; In:   d1.b = Position in hiscore list (zero-indexed).
InsertHiScoreEntry:
.hiscoreLoop
	tst.b	KEYARRAY+KEY_ESCAPE     ; Exit hiscore on ESC?
	bne.s	.exit

	bsr	CheckFirebuttons
	tst.b	d0                      ; Exit hiscore on FIRE?
        bne.s   .hiscoreLoop
.exit
        rts

CreateSortedPlayerScoreList:
        lea     SortedPlayerScoreList,a0
        move.l  #Player0Score,(a0)+
        move.l  #Player1Score,(a0)+
        move.l  #Player2Score,(a0)+
        move.l  #Player3Score,(a0)+

.bubbleLoop
        lea     SortedPlayerScoreList,a0

        moveq   #2,d7
        moveq   #0,d0
.swapLoop
        move.l  (a0),a1
        move.l  4(a0),a2

        move.l  (a2),d2

        cmp.l   (a1),d2
        ble.s   .sorted

        move.b  #1,d0
        move.l  a2,(a0)
        move.l  a1,4(a0)

.sorted
        addq.l  #4,a0
        dbf     d7,.swapLoop

        tst.b   d0
        bne.s   .bubbleLoop     

        rts

; In:   d0.l = Player score
; Out:  d1.b = Position in hiscore list (zero-indexed), or -1 if no highscore.
CheckPlayerHiScore:
        move.l  a4,-(sp)

        lea     HighScores,a4
        add.l   #(8*10),a4              ; +1 for looping reasons
        
        cmp.l   -8(a4),d0               ; Higher score than the bottom ranked?
        bmi.s   .no

        moveq   #9,d1
.findRankLoop
        subq.l  #8,a4
        cmp.l   (a4),d0
        dblt    d1,.findRankLoop
        
        addq.b  #1,d1                   ; Adjust for looping to -1
        bra.s   .exit
.no
        move.b  #-1,d1
.exit      
        move.l  (sp)+,a4
        rts