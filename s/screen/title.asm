	include 's/utilities/scroller.asm'

InitTitlescreen:
	move.l 	#TitleRunningFrame,TitleFrameRoutinePtr(a5)
	move.b	#10,MenuRasterOffset(a5)
	rts

DrawTitlescreen:
	bsr		ResetPlayers
	bsr		ResetBalls
	move.l	#Spr_Ball0,Ball0
	bsr		MoveBall0ToOwner

	move.l	GAMESCREEN_Ptr(a5),TitleBufferPtr(a5)
	move.l	GAMESCREEN_BackPtr(a5),TitleBackbufferPtr(a5)

	bsr		ClearGamescreen
	bsr		ClearBackscreen

	move.l	TitleBufferPtr(a5),a1
	bsr		DrawTitlescreenLogo
	move.l	TitleBackbufferPtr(a5),a1
	bsr		DrawTitlescreenLogo

	move.l	TitleBufferPtr(a5),a1
	bsr		DrawTitlescreenButtons
	move.l	TitleBackbufferPtr(a5),a1
	bsr		DrawTitlescreenButtons

	move.l	TitleBufferPtr(a5),a0
	bsr		DrawTitlescreenCredits
	move.l	TitleBackbufferPtr(a5),a0
	bsr		DrawTitlescreenCredits

	move.l	TitleBufferPtr(a5),a2
	bsr		DrawTitlescreenVersion
	move.l	TitleBackbufferPtr(a5),a2
	bsr		DrawTitlescreenVersion

	bsr		AppendTitleCopper
	move.l	COPPTR_MISC,a1
	jsr		LoadCopper

	move.l	#TitleRunningFrame,TitleFrameRoutinePtr(a5)
	move.l	#ShowTitlescreen,CurrentVisibleScreenPtr(a5)
	rts

; Doesn't run from VBL
ShowTitlescreen:
	bsr		DrawTitlescreen

	move.b	#USERINTENT_CHILL,UserIntentState(a5)

.l
	; Disable VBL interrupt to correctly set StayOnTitle
	move.w	#$7FFF,CUSTOM+INTENA
	move.w	#INTF_SETCLR|INTF_INTEN|INTF_EXTER|INTF_PORTS,CUSTOM+INTENA

	move.b	#-1,StayOnTitle(a5)

	move.l	#ShowTitlescreen,d0
	sub.l	CurrentVisibleScreenPtr(a5),d0
	bne		.checked
	clr.b	StayOnTitle(a5)
.checked
	; Enable VBL interrupt
	move.w	#$7FFF,CUSTOM+INTENA
	move.w	#INTF_SETCLR|INTF_INTEN|INTF_EXTER|INTF_PORTS|INTF_VERTB,CUSTOM+INTENA

	cmp.l	#ShowCreditsScreen,CurrentVisibleScreenPtr(a5)	; Navigate to credits?
	bne		.skip

	bsr		ShowCreditsScreen
	bsr		DrawTitlescreen
	clr.b	StayOnTitle(a5)

.skip
	tst.b	StayOnTitle(a5)
	beq		.l

	rts

; This does run from VBL interrupt.
; Jumps to one of the frame routines.
UpdateTitleFrame:
	move.l	TitleBufferPtr(a5),d1	; Swap screenbuffers
	move.l	TitleBackbufferPtr(a5),TitleBufferPtr(a5)
	move.l	d1,TitleBackbufferPtr(a5)

	move.l	END_COPPTR_MISC,a0
	sub.l	#2*4*4,a0				; 2*4 longword instructions * 4 bitplanes

	move.l	d7,-(sp)
	BUFRSWAP	a0,d1,d0,d7
	move.l	(sp)+,d7

	move.l	TitleFrameRoutinePtr(a5),a0
	jmp		(a0)

	rts

; The regular tile frame.
TitleRunningFrame:
	move.l	a2,-(sp)

	cmp.b	#USERINTENT_QUIT,UserIntentState(a5)
	beq		.confirmExitCheck

	subq.b	#1,MenuRasterOffset(a5)
	bne		.frameTick
	move.b	#10,MenuRasterOffset(a5)
.frameTick
	addq.b	#1,FrameTick(a5)
	cmpi.b	#50,FrameTick(a5)
	bne		.title

	clr.b	FrameTick(a5)
	addq.b	#1,ChillTick(a5)

	bsr		TitleToggleFireToStart

	subq.b	#1,ChillCount(a5)
	beq		.exitChill

.title
	tst.b	KEYARRAY+KEY_ESCAPE		; Exit game?
	beq		.checkCredits
	bne		.confirmExit
.checkCredits
	tst.b	KEYARRAY+KEY_F8
	beq		.continue
	clr.b	KEYARRAY+KEY_F8			; Clear KeyDown

	bsr		SetupTitleAnimFade
	move.l	#TitleToCreditsFrame,TitleFrameRoutinePtr(a5)

.continue
	IFGT	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC
	bsr		DrawLinescroller
	bsr		UpdateMenuCopper
	bsr		CheckAllPossibleFirebuttons

	tst.b	d0
	bne		.fastExit

	bra		.controls

.confirmExit
	bsr		DrawLinescroller
	bsr		UpdateMenuCopper

	move.l	TitleBackbufferPtr(a5),a2
	bsr		DrawTitleConfirmExit
	move.l	TitleBufferPtr(a5),a2
	bsr		DrawTitleConfirmExit

	move.b	#USERINTENT_QUIT,UserIntentState(a5)
	
	bra		.fastExit
.confirmExitCheck
	bsr		DrawLinescroller
	bsr		UpdateMenuCopper

	tst.b	KEYARRAY+KEY_Y			; Quit game
	bne		.quitIntent
	tst.b	KEYARRAY+KEY_N
	bne		.stay
	beq		.fastExit

.stay
	move.l	TitleBackbufferPtr(a5),a0
	bsr		ClearTitlecreenControlsText
	move.l	TitleBufferPtr(a5),a0
	bsr		ClearTitlecreenControlsText

	move.b	#USERINTENT_CHILL,UserIntentState(a5)

	bra		.fastExit
.exitChill
	moveq	#USERINTENT_CHILL,d0
	bra		.exit
.controls
	move.b	#USERINTENT_PLAY,UserIntentState(a5)

	bra		.exit
.quitIntent
	move.b	#USERINTENT_QUIT_CONFIRMED,UserIntentState(a5)
.exit
	bsr		SetupTitleAnimFade
	move.l	#TitleFadeoutFrame,TitleFrameRoutinePtr(a5)

.fastExit
	move.l	(sp)+,a2

	rts

TitleRestoreBitplanePtrs:
	move.l	GAMESCREEN_BackPtr(a5),d1	; Restore bitplane pointers
	move.l	END_COPPTR_MISC,a0
	sub.l	#2*4*4,a0				; 2*4 longword instructions * 4 bitplanes

	BUFRSWAP	a0,d1,d0,d7

	rts

; Fade to credits frame.
TitleToCreditsFrame:
	tst.b	FadeCount				; Fadeout done?
	bgt		.fadeStep

	bsr		TitleFadeoutComplete
	move.l	#ShowCreditsScreen,CurrentVisibleScreenPtr(a5)
	bra		.exit
.fadeStep
	bsr		TitleFadeoutFrame
.exit
	rts

SetupTitleAnimFade:
	move.l	COPPTR_MISC,a0
	move.l	hAddress(a0),a0
	lea		hColor00(a0),a0

	move.b	#$f,FadeCount
	jsr		InitFadeOut16

	rts

TitleFadeoutComplete:
	bsr		ClearBackscreen
	bsr		TitleRestoreBitplanePtrs

	move.l	COPPTR_MISC,a0
	move.l	hAddress(a0),a0
	lea		hColor00(a0),a0
	jsr		ResetFadePalette

	rts

; Fadeout frame.
TitleFadeoutFrame:
	tst.b	FadeCount				; Fadeout done?
	bgt		.fadeStep

	bsr		TitleFadeoutComplete
	clr.l	CurrentVisibleScreenPtr(a5)

	bra		.exit

.fadeStep
	subq.b	#1,MenuRasterOffset(a5)
	bne		.updateRasters
	move.b	#10,MenuRasterOffset(a5)
.updateRasters
	bsr		UpdateMenuCopper
	bsr		DrawLinescroller

	move.l	COPPTR_MISC,a0
	move.l	hAddress(a0),a0
	lea		hColor00(a0),a0

	jsr		FadeOutStep16			; a0 = Starting fadestep from COLOR00

	subq.b	#1,FadeCount

.exit
	rts

UpdateMenuCopper:
	move.l	LogoCopperEffectPtr(a5),a1

	tst.b	FadePhase
	bmi		.noFade

	move.w	#$f,d7
	sub.w	FadePhase,d7
	bra		.fade
.noFade
	moveq	#0,d7
.fade
	moveq	#0,d0
	moveq	#0,d4
	move.b	MenuRasterOffset(a5),d4
	lea		PowTable,a0
	move.b	(a0,d4.w),d1
.l
	cmp.b	#48,d0
	bhs		.exit

	addq.l	#4+2,a1

	move.w	d1,d3
	moveq	#0,d2

	lsr.b	#2,d3
	add.b	#3,d3
	sub.b	d7,d3					; Apply fade
	bpl		.okFade
	moveq	#0,d3
.okFade
	move.b	d3,d2
	lsl.b	#4,d2
	or.b	d3,d2
	lsl.w	#4,d2
	or.b	d3,d2

	cmp.b	d1,d0
	beq		.line

	move.w	d2,(a1)+
	bra		.doneLine
.line
	sub.w	#$222,d2
	bpl		.goodLine
	moveq	#0,d2
.goodLine
	move.w	d2,(a1)+
	add.b	#10,d4

	cmp.b	#60,d4
	blo		.lookup
	bra		.doneLine
.lookup
	lea		PowTable,a0
	move.b	(a0,d4.w),d1			; Lookup in tile map

.doneLine
	addq.l	#4+2,a1

	moveq	#0,d2
	move.w	#$d,d3					; Reset color
	sub.b	d7,d3					; Apply fade
	bpl		.okReset
	moveq	#0,d3
.okReset
	move.b	d3,d2
	lsl.b	#4,d2
	or.b	d3,d2
	lsl.w	#4,d2
	or.b	d3,d2

	move.w	d2,(a1)+

	addq.b	#1,d0
	bra		.l
.exit
	rts

TitleToggleFireToStart:
	btst	#0,ChillTick(a5)
	bne		.off
	bsr		DrawBackscreenFireToStartText
	bra		.done
.off
	bsr		ClearBackscreenFireToStartText
.done
	rts

; Set up hw-sprites in copperlist - no attached sprites.
AppendTitleCopper:
	bsr		AppendDisarmedSprites
	move.l	a1,LogoCopperEffectPtr(a5)

	moveq	#47,d0					; Add WAITs for logo-effect
	move.l	#$9363fffe,d1
	move.l	#$93bbfffe,d2
	move.l	#$01000000,d3
.l
	move.l	d1,(a1)+
	move.l	#COLOR07<<16+$0fff,(a1)+
	move.l	d2,(a1)+
	move.l	#COLOR07<<16+$0ddd,(a1)+

	add.l	d3,d1
	add.l	d3,d2

	dbf		d0,.l


	move.l	#COPPERLIST_END,(a1)
	rts

; In:	a1 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenButtons:
	bsr		DrawEscButton

	lea		BTN_F8_SM,a0			; F8 small
	add.l 	#(ScrBpl*(3+BTN_HEIGHT_SMALL)*4),a1

	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	#0,BLTAMOD(a6)
	move.w	#ScrBpl-2,BLTDMOD(a6)
	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)

	rts

; In:	a0 = Destination. Pointer to bitmap in CHIP memory.
; In:	a6 = address to CUSTOM $dff000
DrawTitlescreenCredits:
	movem.l	d5-d6/a2,-(sp)

	add.l 	#(ScrBpl*4*(7+BTN_HEIGHT_SMALL))+2,a0
	moveq	#ScrBpl-10,d0
	move.w	#(64*8*4)+5,d1

	bsr		ClearBlitWords

	lea		CREDITS_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1
	move.l	a0,a2
	move.l	d0,d5
	move.l	d1,d6
	bsr		DrawStringBuffer

	movem.l	(sp)+,d5-d6/a2
	rts

; In:	a2 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenVersion:
	lea		VERSION_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	add.l	#(ScrBpl*248*4)+36,a2
	moveq	#ScrBpl-4,d5
	move.w	#(64*8*4)+2,d6
	bsr		DrawStringBuffer
	rts

; In:	a1 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenLogo:
	move.l	LOGO_BITMAPBASE,a0
	add.l	#(ScrBpl*58*4)+8,a1

	WAITBLIT

	move.l	#$79f07000,BLTCON0(a6)	; Maxshift - incorrectly 2px to the left of center
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	#0,BLTAMOD(a6)
	move.w	#ScrBpl-22,BLTDMOD(a6)

	move.w 	#(64*94*4)+11,BLTSIZE(a6)
	rts

; In:	a2 = Destination. Pointer to bitmap in CHIP memory.
DrawTitleConfirmExit:
	lea		QUIT_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	add.l	#(ScrBpl*164*4)+16,a2
	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6
	bsr		DrawStringBuffer
	rts

; In:	a0 = Destination. Pointer to bitmap in CHIP memory.
; In:	a6 = address to CUSTOM $dff000
ClearTitlecreenControlsText:
	add.l	#(ScrBpl*164*4)+14,a0
	moveq	#ScrBpl-14,d0
	move.w	#(64*16*4)+7,d1

	bsr		ClearBlitWords
	rts