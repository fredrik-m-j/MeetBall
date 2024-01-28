; Backingscreen is for in-game and chill screens usages.
; Routines intended to be shared between screens.

ClearBackscreen:
        move.l	a6,-(sp)

        lea 	CUSTOM,a6
        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	moveq	#0,d0
	move.w	#(64*255*4)+20,d1
        bsr     ClearBlitWords

        move.l	(sp)+,a6
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

ToggleBackscreenFireToStart:
	btst	#0,ChillTick
	bne	.off
	bsr	DrawBackscreenFireToStartText
	bra	.done
.off
	bsr	ClearBackscreenFireToStartText
.done
	rts

DrawBackscreenFireToStartText
        movem.l d5-d6/a2/a5,-(sp)

	lea	CONTROLS2_STR,a0
        lea     STRINGBUFFER,a1
	COPYSTR a0,a1

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*240*4)+15,a2
        moveq	#ScrBpl-14,d5
        move.w  #(64*8*4)+7,d6

	bsr     DrawStringBuffer

        movem.l (sp)+,d5-d6/a2/a5
        rts

ClearBackscreenFireToStartText:
        move.l  a6,-(sp)
        lea 	CUSTOM,a6

        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
        add.l 	#(ScrBpl*240*4)+14,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*8*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts