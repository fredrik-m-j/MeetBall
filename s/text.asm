MenuClearMiscText:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*155*4)+10,a0
        move.w  #ScrBpl-20,d1
        move.w  #(64*16*4)+10,d2

        bsr     ClearBlitWords
        rts

MenuClearPlayer0Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*155*4)+30,a0
        move.w  #ScrBpl-10,d1
        move.w  #(64*24*4)+5,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer1Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*155*4),a0
        move.w  #ScrBpl-10,d1
        move.w  #(64*24*4)+5,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer2Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*212*4)+22,a0
        move.w  #ScrBpl-14,d1
        move.w  #(64*24*4)+7,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer3Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*18*4)+22,a0
        move.w  #ScrBpl-14,d1
        move.w  #(64*24*4)+7,d2

        bsr     ClearBlitWords
        rts

MenuDrawPlayer0Joy:
        lea     JOY1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4)+30,a2
        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
        rts
MenuDrawPlayer1Joy:
        lea     JOY0_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4),a2
        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
        rts
MenuDrawPlayer2Joy:
        lea     JOY2_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*212*4)+22,a2
        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
        rts
MenuDrawPlayer3Joy:
        lea     JOY3_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*18*4)+22,a2
        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
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

        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4),a2
        bsr     DrawStringBuffer                ; Up

        lea     DOWN_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Q",-1(a1)
        clr.b   (a1)

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*163*4),a2
        bsr     DrawStringBuffer                ; Down

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LSHIFT_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*171*4),a2
        bsr     DrawStringBuffer                ; Fire

        rts

MenuDrawPlayer2Keys:
        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"K",-1(a1)
        clr.b   (a1)

        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*212*4)+22,a2
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"L",-1(a1)
        clr.b   (a1)

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*220*4)+22,a2
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     RAMIGA_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*228*4)+22,a2
        bsr     DrawStringBuffer                ; Fire

        rts

MenuDrawPlayer3Keys:
        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z",-1(a1)
        clr.b   (a1)

        move.w  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*18*4)+22,a2
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"X",-1(a1)
        clr.b   (a1)

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*26*4)+22,a2
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LAMIGA_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*34*4)+22,a2
        bsr     DrawStringBuffer                ; Fire

        rts

GameareaDrawGameOver:
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#GAMEOVER_DEST,a0
	move.l	#GAMEOVER_MODULO,d1
	move.w	#(64*14*4)+7,d2

	bsr	ClearBlitWords

        lea     GAMEOVER_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#GAMEOVER_TEXTDEST,a2
        move.l  #GAMEOVER_MODULO,d5
        move.w  #(64*8*4)+7,d6
        bsr     DrawStringBuffer

	rts

GameareaDrawNextLevel:
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#GAMEOVER_DEST,a0
	move.l	#GAMEOVER_MODULO,d1
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
        move.l  #GAMEOVER_MODULO,d5
        move.w  #(64*8*4)+7,d6
        bsr     DrawStringBuffer

	rts

GameareaRestoreGameOver:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#GAMEOVER_DEST,a0
        move.l  GAMESCREEN_BITMAPBASE,a1
        add.l 	#GAMEOVER_DEST,a1
	move.l	#GAMEOVER_MODULO,d1
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
        sub.l   #1,a1

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
	move.l 	#$ffffffff,BLTAFWM(a6)
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
	move.l 	#$ffffffff,BLTAFWM(a6)
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