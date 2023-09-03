MenuDrawBallspeed:
        lea     BALLSPEED_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1

        moveq   #0,d0
        move.w  BallspeedBase,d0
        jsr     Binary2Decimal

	move.b	#" ",-1(a1)
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*16*4)+2,a0
        moveq   #ScrBpl-12,d1
        move.w  #(64*8*4)+6,d2

        bsr     ClearBlitWords

        move.l	a0,a2
	move.l	d1,d5
	move.l	d2,d6
        bsr     DrawStringBuffer
        rts

MenuDrawRampup:
        lea     RAMPUP_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1

        moveq   #0,d0
        move.b  BallspeedFrameCount,d0
        jsr     Binary2Decimal

	move.b	#" ",-1(a1)
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*28*4)+2,a0
        moveq   #ScrBpl-14,d1
        move.w  #(64*8*4)+7,d2

        bsr     ClearBlitWords

	move.l	a0,a2
	move.l	d1,d5
	move.l	d2,d6
        bsr     DrawStringBuffer
        rts

MenuDrawCredits:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*40*4)+2,a0
        moveq   #ScrBpl-10,d1
        move.w  #(64*8*4)+5,d2

        bsr     ClearBlitWords

        lea     CREDITS_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
	move.l	a0,a2
	move.l	d1,d5
	move.l	d2,d6
        bsr     DrawStringBuffer
        rts

MenuDrawMakers:
        lea     MAKERS0_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*200*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*208*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS2_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*218*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*226*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS3_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*236*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS4_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*244*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        rts

MenuDrawMiscText:
	lea	CONTROLS1_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*164*4)+14,a2
        moveq	#ScrBpl-14,d5
        move.w  #(64*8*4)+7,d6
        bsr     DrawStringBuffer

        move.l  #DEFAULT_MASK,d4
        moveq   #2,d0                           ; Finetune
        bsr     BlitShiftRight

	lea	CONTROLS2_STR,a0
	COPYSTR a0,a1

	move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*172*4)+15,a2
        moveq	#ScrBpl-14,d5
        move.w  #(64*8*4)+7,d6

	bsr     DrawStringBuffer
        rts
MenuClearMiscText:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*164*4)+14,a0
        moveq   #ScrBpl-14,d1
        move.w  #(64*16*4)+7,d2

        bsr     ClearBlitWords
        rts

MenuClearPlayer0Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*154*4)+28,a0
        moveq   #ScrBpl-12,d1
        move.w  #(64*24*4)+6,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer1Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*154*4)+2,a0
        moveq   #ScrBpl-12,d1
        move.w  #(64*28*4)+6,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer2Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*212*4)+22,a0
        moveq   #ScrBpl-14,d1
        move.w  #(64*28*4)+7,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer3Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*18*4)+22,a0
        moveq   #ScrBpl-14,d1
        move.w  #(64*28*4)+7,d2

        bsr     ClearBlitWords
        rts

MenuDrawPlayer0Joy:
        lea     JOY1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4)+28+ScrBpl,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        move.l  #DEFAULT_MASK,d4
        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*154*4)+28,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit

        rts
MenuDrawPlayer1Joy:
        lea     JOY0_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4)+ScrBpl+2,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        move.l  #DEFAULT_MASK,d4
        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*154*4)+2,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit
        rts
MenuDrawPlayer2Joy:
        lea     JOY2_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*213*4)+22+ScrBpl,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*212*4)+22,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit

	move.l  MENUSCREEN_BITMAPBASE,a2	; Shift
	add.l 	#(ScrBpl*212*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*12*4)+6,d6
        bsr     BlitShiftRight

        rts
MenuDrawPlayer3Joy:
        lea     JOY3_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*19*4)+22+ScrBpl,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*18*4)+22,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit

	move.l  MENUSCREEN_BITMAPBASE,a2	; Shift
	add.l 	#(ScrBpl*18*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*12*4)+6,d6
        bsr     BlitShiftRight
        rts

MenuDrawPlayer0UpArrow:
        lea     FONT,a0
        add.l   #("Z"+2)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*110*4)+39,a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*158*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer0DownArrow:
        lea     FONT,a0
        add.l   #("Z"+3)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*158*4)+39,a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*110*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer0ClearArrows:
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*110*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*158*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts

MenuDrawPlayer1UpArrow:
        lea     FONT,a0
        add.l   #("Z"+2)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*110*4),a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*158*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer1DownArrow:
        lea     FONT,a0
        add.l   #("Z"+3)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*158*4),a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*110*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer1ClearArrows:
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*110*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*158*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        rts

MenuDrawPlayer2LeftArrow:
        lea     FONT,a0
        add.l   #("Z"+1)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*248*4)+16,a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*248*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer2RightArrow:
        lea     FONT,a0
        add.l   #("Z"+4)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*248*4)+23,a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*248*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer2ClearArrows:
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*248*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*248*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts

MenuDrawPlayer3LeftArrow:
        lea     FONT,a0
        add.l   #("Z"+1)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*4)+16,a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer3RightArrow:
        lea     FONT,a0
        add.l   #("Z"+4)-$20,a0

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*4)+23,a2
        bsr     DrawSinglePlaneChar
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer3ClearArrows:
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts


MenuDrawPlayer1Keys:
        lea     UP_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"1",-1(a1)
        clr.b   (a1)

        moveq   #ScrBpl-12,d5
        move.w  #(64*8*4)+6,d6

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4)+ScrBpl+1,a2
        bsr     DrawStringBuffer                ; Up

        move.l  #DEFAULT_MASK,d4
        moveq   #5,d0                           ; Finetune
        bsr     BlitShiftRight

        lea     DOWN_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Q",-1(a1)
        clr.b   (a1)

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*163*4)+ScrBpl+1,a2
        bsr     DrawStringBuffer                ; Down
        
        move.l  #DEFAULT_MASK,d4
        moveq   #5,d0                           ; Finetune
        bsr     BlitShiftRight

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LSHIFT_STR,a0
        subq.l  #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*171*4)+ScrBpl+1,a2
        bsr     DrawStringBuffer                ; Fire

        move.l  #DEFAULT_MASK,d4
        moveq   #5,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*154*4)+2,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit

        rts

MenuDrawPlayer2Keys:
        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"K",-1(a1)
        clr.b   (a1)

        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*213*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"L",-1(a1)
        clr.b   (a1)

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*221*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     RAMIGA_STR,a0
        subq.l  #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*229*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Fire

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*212*4)+22,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit

	move.l  MENUSCREEN_BITMAPBASE,a2	; Shift
	add.l 	#(ScrBpl*212*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*28*4)+6,d6
        bsr     BlitShiftRight

        rts

MenuDrawPlayer3Keys:
        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z",-1(a1)
        clr.b   (a1)

        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*19*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"X",-1(a1)
        clr.b   (a1)

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*27*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LAMIGA_STR,a0
        subq.l  #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*35*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Fire

	move.l  MENUSCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*18*4)+22,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a1
        bsr	FillBoxBlit

	move.l  MENUSCREEN_BITMAPBASE,a2	; Shift
	add.l 	#(ScrBpl*18*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*28*4)+6,d6
        bsr     BlitShiftRight
        rts

GameareaDrawGameOver:
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#GAMEOVER_DEST,a0
	moveq	#GAMEOVER_MODULO,d1
	move.w	#(64*14*4)+7,d2

	bsr	ClearBlitWords

        lea     GAMEOVER_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#GAMEOVER_TEXTDEST,a2
        moveq   #GAMEOVER_MODULO,d5
        move.w  #(64*8*4)+7,d6
        bsr     DrawStringBuffer

	rts

GameareaDrawNextLevel:
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#GAMEOVER_DEST,a0
	moveq   #GAMEOVER_MODULO,d1
	move.w	#(64*14*4)+7,d2

	bsr	ClearBlitWords

        lea     LEVEL_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        moveq   #0,d0
        move.w  LevelCount,d0
        jsr     Binary2Decimal

	move.b	#" ",-1(a1)
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#GAMEOVER_TEXTDEST,a2
        moveq   #GAMEOVER_MODULO,d5
        move.w  #(64*8*4)+7,d6
        bsr     DrawStringBuffer

	rts

GameareaRestoreGameOver:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#GAMEOVER_DEST,a0
        move.l  GAMESCREEN_BITMAPBASE,a1
        add.l 	#GAMEOVER_DEST,a1
	moveq	#GAMEOVER_MODULO,d1
	move.w	#(64*14*4)+7,d2

        bsr     CopyRestoreGamearea
	rts

; In:   a2 = Start Destination (4 bitplanes)
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
DrawStringBuffer:
        lea     STRINGBUFFER,a1
        lea 	CUSTOM,a6
.l1
        move.b  (a1)+,d1
        bne.s   .l1
        subq.l  #1,a1

        moveq   #0,d1
.l2
        lea     FONT,a0
        move.b  -(a1),d1
        
        subi.b  #$20,d1
        add.l   d1,a0

        WAITBLIT a6                     ; Make sure shifting is done before adding next char
        bsr     DrawSinglePlaneChar

        cmpa.l  #STRINGBUFFER,a1
        beq.s   .exit

        move.l  #DEFAULT_MASK,d4
        moveq   #6,d0
        bsr     BlitShiftRight

        bra.s   .l2
.exit
        rts

; In:   a2 = Start Destination (4 bitplanes)
; In:   a3 = End Destination (Last byte of the blit area - descending blit)
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
DrawStringBufferRightAligned:
        lea     STRINGBUFFER,a1
        lea 	CUSTOM,a6

        moveq   #0,d1
.l2
        lea     FONT,a0
        move.b  (a1)+,d1
        beq.s   .exit
        
        subi.b  #$20,d1
        add.l   d1,a0

        WAITBLIT a6                     ; Make sure shifting is done before adding next char

        bsr     DrawSinglePlaneChar

        moveq   #6,d0
        exg     a3,a2
        bsr     BlitShiftLeft
        exg     a2,a3

        bra.s   .l2
.exit
        rts


; In:   a2 = Destination (4 bitplanes)
; In:   d0 = Number of pixels to shift
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
BlitShiftRight:
        ror.l	#4,d0			; Put remainder in most significant nibble for BLTCONx to do SHIFT
	addi.l	#$09f00000,d0		; Copy with X shift

	lea 	CUSTOM,a6
	WAITBLIT a6

	move.l 	d0,BLTCON0(a6) 
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.w 	d5,BLTAMOD(a6)
	move.w 	d5,BLTDMOD(a6)
	move.l 	a2,BLTAPTH(a6)
	move.l 	a2,BLTDPTH(a6)

	move.w 	d6,BLTSIZE(a6)

        rts

; In:   a2 = Destination (4 bitplanes)
; In:   d0 = Number of pixels to shift
; In:   d5.w = Blitmodulo
; In:   d6.w = Blitsize
BlitShiftLeft:
        ror.l	#4,d0			; Put remainder in most significant nibble for BLTCONx to do SHIFT
        bset    #1,d0                   ; Use descending mode
	addi.l	#$09f00000,d0		; Copy with X shift

	lea 	CUSTOM,a6
	WAITBLIT a6

	move.l 	d0,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.w 	d5,BLTAMOD(a6)
	move.w 	d5,BLTDMOD(a6)
	move.l 	a2,BLTAPTH(a6)
	move.l 	a2,BLTDPTH(a6)

	move.w 	d6,BLTSIZE(a6)

        rts

; In:	a0 = Address to source char (1 bitplane)
; In:   a2 = Destination (4 bitplanes)
DrawSinglePlaneChar:
	move.b  0*64(a0),d2
        or.b    d2,0*40(a2)

	move.b  1*64(a0),d2
        or.b    d2,4*40(a2)

	move.b  2*64(a0),d2
        or.b    d2,8*40(a2)

	move.b  3*64(a0),d2
        or.b    d2,12*40(a2)

	move.b  4*64(a0),d2
        or.b    d2,16*40(a2)

	move.b  5*64(a0),d2
        or.b    d2,20*40(a2)

	move.b  6*64(a0),d2
        or.b    d2,24*40(a2)

	move.b  7*64(a0),d2
        or.b    d2,28*40(a2)

	; move.b  0*64(a0),0*40(a2)
        ; move.b  1*64(a0),4*40(a2)
        ; move.b  2*64(a0),8*40(a2)
        ; move.b  3*64(a0),12*40(a2)

	; move.b  4*64(a0),16*40(a2)
        ; move.b  5*64(a0),20*40(a2)
        ; move.b  6*64(a0),24*40(a2)
        ; move.b  7*64(a0),28*40(a2)

        rts


; In:   a0 = Destination to clear
; In:   d1.w = Destination modulo
; In:   d2.w = Blit size
ClearBlitWords:
        lea 	CUSTOM,a6
        
        WAITBLIT a6

	move.l 	#$01000000,BLTCON0(a6)
	move.l 	a0,BLTDPTH(a6)
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)
        rts

; In:   a3 = Score area on GAMESCREEN to clear (top left).
ClearScoreArea:
	clr.l   0*40(a3)
        clr.l   1*40(a3)
        clr.l   2*40(a3)
        ; clr.l   3*40(a3)      - bitplane not used

	clr.l   4*40(a3)
        clr.l   5*40(a3)
        clr.l   6*40(a3)
        ; clr.l   7*40(a3)

	clr.l   8*40(a3)
        clr.l   9*40(a3)
        clr.l   10*40(a3)
        ; clr.l   11*40(a3)

	clr.l   12*40(a3)
        clr.l   13*40(a3)
        clr.l   14*40(a3)
        ; clr.l   15*40(a3)

	clr.l   16*40(a3)
        clr.l   17*40(a3)
        clr.l   18*40(a3)
        ; clr.l   19*40(a3)

	clr.l   20*40(a3)
        clr.l   21*40(a3)
        clr.l   22*40(a3)
        ; clr.l   23*40(a3)

        rts