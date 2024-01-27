; Backingscreen is for in-game and attract mode screens usages.

ClearBackscreen:
        move.l	a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	moveq	#0,d0
	move.w	#(64*255*4)+20,d1
        bsr     ClearBlitWords

        move.l	(sp)+,a6
        rts

DrawLogoToBackscreen:
	move.l	LOGO_BITMAPBASE,a0
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*58*4)+8,a1

        lea 	CUSTOM,a6
        
	WAITBLIT a6

	move.l 	#$79f07000,BLTCON0(a6)          ; Maxshift - incorrectly 2px to the left of center
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#0,BLTAMOD(a6)
	move.w 	#ScrBpl-22,BLTDMOD(a6)

	move.w 	#(64*94*4)+11,BLTSIZE(a6)
	rts

DrawTitleButtonsToBackscreen:
	move.l	a6,-(sp)

	bsr	DrawEscButtonToBackScreen

	lea 	CUSTOM,a6

	lea	BTN_F5_SM,a0			; F5 small
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*(3+BTN_HEIGHT_SMALL)*4),a1
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#0,BLTAMOD(a6)
	move.w 	#ScrBpl-2,BLTDMOD(a6)
        move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)

	lea	BTN_F6_SM,a0			; F6 small
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*(3+BTN_HEIGHT_SMALL*2)*4),a1
        
	WAITBLIT a6

	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)


	lea	BTN_F8_SM,a0			; F8 small
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*(3+BTN_HEIGHT_SMALL*3)*4),a1
        
	WAITBLIT a6

	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)


	lea	BTN_F1,a0			; F1
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*(DISP_HEIGHT/2-12)*4)+2,a1
        
	WAITBLIT a6

	move.l 	#$29f02000,BLTCON0(a6)
	move.w 	#ScrBpl-4,BLTDMOD(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)


	lea	BTN_F2,a0			; F2
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*(DISP_HEIGHT-BTN_HEIGHT-19)*4)+18,a1
        
	WAITBLIT a6

	move.l 	#$19f01000,BLTCON0(a6)
	move.w 	#ScrBpl-4,BLTDMOD(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)


	lea	BTN_F3,a0			; F3
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*(DISP_HEIGHT/2-12)*4)+34,a1
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.w 	#ScrBpl-4,BLTDMOD(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)


	lea	BTN_F4,a0			; F4
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*19*4)+18,a1

	WAITBLIT a6

	move.l 	#$19f01000,BLTCON0(a6)
	move.w 	#ScrBpl-4,BLTDMOD(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)

	move.l	(sp)+,a6
	rts


MenuDrawBallspeed:
        movem.l d5-d6/a2/a6,-(sp)

        lea 	CUSTOM,a6
        lea     BALLSPEED_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1

        moveq   #0,d0
        move.w  BallspeedBase,d0
        jsr     Binary2Decimal

	move.b	#" ",-1(a1)
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#(ScrBpl*16*4)+2,a0
        moveq   #ScrBpl-12,d0
        move.w  #(64*8*4)+6,d1

        bsr     ClearBlitWords

        move.l	a0,a2
	move.l	d0,d5
	move.l	d1,d6
        bsr     DrawStringBuffer

        movem.l (sp)+,d5-d6/a2/a6
        rts

MenuDrawRampup:
        movem.l d5-d6/a2/a6,-(sp)

        lea 	CUSTOM,a6
        lea     RAMPUP_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1

        moveq   #0,d0
        move.b  BallspeedFrameCount,d0
        jsr     Binary2Decimal

	move.b	#" ",-1(a1)
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#(ScrBpl*28*4)+2,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*8*4)+7,d1

        bsr     ClearBlitWords

	move.l	a0,a2
	move.l	d0,d5
	move.l	d1,d6
        bsr     DrawStringBuffer

        movem.l (sp)+,d5-d6/a2/a6
        rts

MenuDrawCredits:
        movem.l d5-d6/a2/a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*40*4)+2,a0
        moveq   #ScrBpl-10,d0
        move.w  #(64*8*4)+5,d1

        bsr     ClearBlitWords

        lea     CREDITS_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
	move.l	a0,a2
	move.l	d0,d5
	move.l	d1,d6
        bsr     DrawStringBuffer

        movem.l (sp)+,d5-d6/a2/a6
        rts

MenuDrawMakers:
        lea     MAKERS2_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*218*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*226*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS3_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*236*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        lea     MAKERS4_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*244*4),a2
        moveq   #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6
        bsr     DrawStringBuffer

        rts

MenuDrawVersion:
        lea     VERSION_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+36,a2
        moveq   #ScrBpl-4,d5
        move.w  #(64*8*4)+2,d6
        bsr     DrawStringBuffer
        rts

MenuDrawControlsText:
        movem.l d5-d6/a2/a5/a6,-(sp)
        lea 	CUSTOM,a6

	lea	CONTROLS1_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*164*4)+14,a2
        moveq	#ScrBpl-14,d5
        move.w  #(64*8*4)+7,d6
        bsr     DrawStringBuffer

        moveq   #2,d0                           ; Finetune
        bsr     BlitShiftRight

        movem.l (sp)+,d5-d6/a2/a5/a6
        rts
MenuClearControlsText:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*164*4)+14,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*16*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts

MenuDrawFireToStartText:
        movem.l d5-d6/a2/a5,-(sp)

	lea	CONTROLS2_STR,a0
        lea     STRINGBUFFER,a1
	COPYSTR a0,a1

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*172*4)+15,a2
        moveq	#ScrBpl-14,d5
        move.w  #(64*8*4)+7,d6

	bsr     DrawStringBuffer

        movem.l (sp)+,d5-d6/a2/a5
        rts
MenuClearFireToStartText:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*172*4)+14,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*8*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts

MenuClearPlayer0Text:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*154*4)+28,a0
        moveq   #ScrBpl-12,d0
        move.w  #(64*24*4)+6,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts
MenuClearPlayer1Text:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*154*4)+2,a0
        moveq   #ScrBpl-12,d0
        move.w  #(64*28*4)+6,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts
MenuClearPlayer2Text:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*212*4)+22,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*28*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts
MenuClearPlayer3Text:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*18*4)+22,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*28*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts

MenuDrawPlayer0Joy:
	movem.l	d5/d6/a2/a5/a6,-(sp)
	lea	CUSTOM,a6

        lea     JOY1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*155*4)+28+ScrBpl,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*154*4)+28,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts
MenuDrawPlayer1Joy:
	movem.l	d5/d6/a2/a5/a6,-(sp)
	lea	CUSTOM,a6

        lea     JOY0_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*155*4)+ScrBpl+2,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*154*4)+2,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts
MenuDrawPlayer2Joy:
	movem.l	d5/d6/a2/a5/a6,-(sp)
	lea	CUSTOM,a6

        lea     JOY2_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*213*4)+22+ScrBpl,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*212*4)+22,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2	; Shift
	add.l 	#(ScrBpl*212*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*12*4)+6,d6
        bsr     BlitShiftRight

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts
MenuDrawPlayer3Joy:
	movem.l	d5/d6/a2/a5/a6,-(sp)
	lea	CUSTOM,a6

        lea     JOY3_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*19*4)+22+ScrBpl,a2
        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer

        moveq   #3,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*18*4)+22,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2	; Shift
	add.l 	#(ScrBpl*18*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*12*4)+6,d6
        bsr     BlitShiftRight

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts

MenuDrawPlayer0UpArrow:
        lea     FONT,a0
        add.l   #("Z"+2)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*110*4)+39,a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*158*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer0DownArrow:
        lea     FONT,a0
        add.l   #("Z"+3)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*158*4)+39,a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*110*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer0ClearArrows:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*110*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*158*4)+39,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts

MenuDrawPlayer1UpArrow:
        lea     FONT,a0
        add.l   #("Z"+2)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*110*4),a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*158*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer1DownArrow:
        lea     FONT,a0
        add.l   #("Z"+3)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*158*4),a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*110*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer1ClearArrows:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*110*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*158*4),a2
        PLANARCHARCLEAR_8_1 a2,40
        rts

MenuDrawPlayer2LeftArrow:
        lea     FONT,a0
        add.l   #("Z"+1)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+16,a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*248*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer2RightArrow:
        lea     FONT,a0
        add.l   #("Z"+4)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+23,a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer2ClearArrows:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts

MenuDrawPlayer3LeftArrow:
        lea     FONT,a0
        add.l   #("Z"+1)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*4)+16,a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2        ; Clear opposite arrow
        add.l 	#(ScrBpl*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer3RightArrow:
        lea     FONT,a0
        add.l   #("Z"+4)-$20,a0

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*4)+23,a2
        bsr     DrawSinglePlaneChar
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts
MenuDrawPlayer3ClearArrows:
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*4)+16,a2
        PLANARCHARCLEAR_8_1 a2,40
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*4)+23,a2
        PLANARCHARCLEAR_8_1 a2,40
        rts


MenuDrawPlayer1Keys:
        movem.l d5-d6/a2/a5/a6,-(sp)
        lea 	CUSTOM,a6

        lea     UP_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"1",-1(a1)
        clr.b   (a1)

        moveq   #ScrBpl-12,d5
        move.w  #(64*8*4)+6,d6

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*155*4)+ScrBpl+1,a2
        bsr     DrawStringBuffer                ; Up

        moveq   #5,d0                           ; Finetune
        bsr     BlitShiftRight

        lea     DOWN_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Q",-1(a1)
        clr.b   (a1)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*163*4)+ScrBpl+1,a2
        bsr     DrawStringBuffer                ; Down
        
        moveq   #5,d0                           ; Finetune
        bsr     BlitShiftRight

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LSHIFT_STR,a0
        subq.l  #1,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*171*4)+ScrBpl+1,a2
        bsr     DrawStringBuffer                ; Fire

        moveq   #5,d0                           ; Finetune
        bsr     BlitShiftRight

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*154*4)+2,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts

MenuDrawPlayer2Keys:
        movem.l d5-d6/a2/a5/a6,-(sp)
        lea 	CUSTOM,a6

        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"K",-1(a1)
        clr.b   (a1)

        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*213*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"L",-1(a1)
        clr.b   (a1)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*221*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     RAMIGA_STR,a0
        subq.l  #1,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*229*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Fire

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*212*4)+22,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2	; Shift
	add.l 	#(ScrBpl*212*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*28*4)+6,d6
        bsr     BlitShiftRight

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts

MenuDrawPlayer3Keys:
        movem.l d5-d6/a2/a5/a6,-(sp)
        lea 	CUSTOM,a6

        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z",-1(a1)
        clr.b   (a1)

        moveq   #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*19*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"X",-1(a1)
        clr.b   (a1)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*27*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LAMIGA_STR,a0
        subq.l  #1,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*35*4)+22+ScrBpl,a2
        bsr     DrawStringBuffer                ; Fire

	move.l  GAMESCREEN_BITMAPBASE_BACK,a5	; Fill background
	add.l 	#(ScrBpl*18*4)+22,a5
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	bsr	FillBoxBlit

        add.l 	#11*ScrBpl,a5
        bsr	FillBoxBlit

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2	; Shift
	add.l 	#(ScrBpl*18*4)+22,a2
        moveq   #5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*28*4)+6,d6
        bsr     BlitShiftRight

        movem.l	(sp)+,d5/d6/a2/a5/a6
        rts