; Backingscreen is for in-game and chill screens usages.
; Routines intended to be shared between screens.

ClearBackscreen:
	move.l	a6,-(sp)

	lea		CUSTOM,a6
	move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	moveq	#0,d0
	move.w	#(64*255*4)+20,d1
	bsr		ClearBlitWords

	add.l	#(ScrBpl*255*4),a0		; Clear last line with CPU
	move.w	#ScrBpl-1,d0
.l
	clr.b	ScrBpl*0(a0)
	clr.b	ScrBpl*1(a0)
	clr.b	ScrBpl*2(a0)
	clr.b	ScrBpl*3(a0)
	addq.l	#1,a0
	dbf		d0,.l

	move.l	(sp)+,a6
	rts

; Copy ESC button graphics to destination
; In:	a1 = Destination. Pointer to bitmap in CHIP memory.
DrawEscButton:
	move.l	a6,-(sp)

	lea		BTN_ESC_SM,a0			; ESC small
	add.l	#(ScrBpl*3*4),a1
        
	WAITBLIT	a6

	move.l	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	#0,BLTAMOD(a6)
	move.w	#ScrBpl-2,BLTDMOD(a6)

	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)

	move.l	(sp)+,a6
	rts

ToggleBackscreenFireToStart:
	btst	#0,ChillTick(a5)
	bne		.off
	bsr		DrawBackscreenFireToStartText
	bra		.done
.off
	bsr		ClearBackscreenFireToStartText
.done
	rts

DrawBackscreenFireToStartText
	movem.l	a2,-(sp)

	lea		CONTROLS2_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BITMAPBASE_BACK,a2
	add.l	#(ScrBpl*240*4)+13,a2

	bsr		DrawStringBufferSimple

	move.l	GAMESCREEN_BITMAPBASE,a2	; Should be done on next frame...
	add.l	#(ScrBpl*240*4)+13,a2

	bsr		DrawStringBufferSimple

	movem.l	(sp)+,a2
	rts

ClearBackscreenFireToStartText:
	move.l	a6,-(sp)
	lea		CUSTOM,a6

	move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	add.l	#(ScrBpl*240*4)+12,a0
	moveq	#ScrBpl-14,d0
	move.w	#(64*8*4)+7,d1

	bsr		ClearBlitWords

	move.l	GAMESCREEN_BITMAPBASE,a0	; Should be done on next frame...
	add.l	#(ScrBpl*240*4)+12,a0

	bsr		ClearBlitWords

	move.l	(sp)+,a6
	rts