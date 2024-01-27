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

DrawTitlescreenLogo:
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

; Copy ESC button graphixs to GAMESCREEN_BITMAPBASE_BACK
DrawBackscreenEscButton:
	move.l	a6,-(sp)

	lea	BTN_ESC_SM,a0			; ESC small
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l 	#(ScrBpl*3*4),a1
        
	WAITBLIT a6

	move.l 	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l 	a0,BLTAPTH(a6)
	move.l 	a1,BLTDPTH(a6)
	move.w 	#0,BLTAMOD(a6)
	move.w 	#ScrBpl-2,BLTDMOD(a6)

	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)

	move.l	(sp)+,a6
	rts

DrawControlscreenButtons:
	move.l	a6,-(sp)

	bsr	DrawBackscreenEscButton

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

DrawTitlescreenButtons:
	move.l	a6,-(sp)

	bsr	DrawBackscreenEscButton

	lea 	CUSTOM,a6

	lea	BTN_F8_SM,a0			; F8 small
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

	move.l	(sp)+,a6
	rts


DrawTitlescreenCredits:
        movem.l d5-d6/a2/a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*4*(3+BTN_HEIGHT_SMALL))+2,a0
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

DrawTitlescreenMakers:
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

DrawTitlescreenVersion:
        lea     VERSION_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+36,a2
        moveq   #ScrBpl-4,d5
        move.w  #(64*8*4)+2,d6
        bsr     DrawStringBuffer
        rts

DrawBackscreenFireToStartText:
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
ClearBackscreenFireToStartText:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0

        add.l 	#(ScrBpl*172*4)+14,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*8*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts