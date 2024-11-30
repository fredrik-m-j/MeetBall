	include 's/utilities/scroller.asm'

DrawTitlescreen:
	bsr	ResetPlayers
	bsr	ResetBalls
	move.l	#Spr_Ball0,Ball0
	bsr	MoveBall0ToOwner

	move.l	GAMESCREEN_BITMAPBASE,TitleBuffer
	move.l	GAMESCREEN_BITMAPBASE_BACK,TitleBackbuffer

	bsr	ClearGamescreen
	bsr	ClearBackscreen

	move.l	TitleBuffer,a1
	bsr	DrawTitlescreenLogo
	move.l	TitleBackbuffer,a1
	bsr	DrawTitlescreenLogo

	move.l	TitleBuffer,a1
	bsr	DrawTitlescreenButtons
	move.l	TitleBackbuffer,a1
	bsr	DrawTitlescreenButtons

	move.l	TitleBuffer,a0
	bsr	DrawTitlescreenCredits
	move.l	TitleBackbuffer,a0
	bsr	DrawTitlescreenCredits

	move.l	TitleBuffer,a2
	bsr	DrawTitlescreenVersion
	move.l	TitleBackbuffer,a2
	bsr	DrawTitlescreenVersion

	bsr	AppendTitleCopper
	move.l	COPPTR_MISC,a1
	jsr	LoadCopper

	move.l	#TitleRunningFrame,TitleFrameRoutine
	move.l	#ShowTitlescreen,CurrentVisibleScreen
	rts

; Doesn't run from VBL
ShowTitlescreen:
 	bsr	DrawTitlescreen

	move.b	#USERINTENT_CHILL,UserIntentState

.l
		; Disable VBL interrupt to correctly set StayOnTitle
		move.w  #$7FFF,CUSTOM+INTENA
		move.w	#INTF_SETCLR|INTF_INTEN|INTF_EXTER|INTF_PORTS,CUSTOM+INTENA

		move.b	#-1,StayOnTitle

		move.l	#ShowTitlescreen,d0
		sub.l	CurrentVisibleScreen,d0
		bne	.checked
		clr.b	StayOnTitle
.checked
		; Enable VBL interrupt
		move.w  #$7FFF,CUSTOM+INTENA
		move.w	#INTF_SETCLR|INTF_INTEN|INTF_EXTER|INTF_PORTS|INTF_VERTB,CUSTOM+INTENA

	cmp.l	#ShowCreditsScreen,CurrentVisibleScreen	; Navigate to credits?
	bne	.skip

	bsr	ShowCreditsScreen
	bsr	DrawTitlescreen
	clr.b	StayOnTitle

.skip
	tst.b	StayOnTitle
	beq	.l

	rts

UpdateTitleFrame:
	move.l	TitleBuffer,d1		; Swap screenbuffers
	move.l	TitleBackbuffer,TitleBuffer
	move.l	d1,TitleBackbuffer

	move.l	END_COPPTR_MISC,a0
	sub.l	#2*4*4,a0		; 2*4 longword instructions * 4 bitplanes

	move.l	d7,-(sp)
	BUFFERSWAP a0,d1,d0,d7
	move.l	(sp)+,d7

	move.l	TitleFrameRoutine,a0
	jmp	(a0)

	rts

; This does run from VBL interrupt
TitleRunningFrame:
	movem.l	d0-a6,-(sp)
.running

	cmp.b	#USERINTENT_QUIT,UserIntentState
	beq	.confirmExitCheck

        subq.b  #1,MenuRasterOffset
        bne	.frameTick
        move.b	#10,MenuRasterOffset
.frameTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne	.title

	clr.b	FrameTick
	addq.b	#1,ChillTick

	bsr	TitleToggleFireToStart

	subq.b	#1,ChillCount
	beq     .exitChill

.title
	tst.b	KEYARRAY+KEY_ESCAPE		; Exit game?
	beq	.checkCredits
	bne	.confirmExit
.checkCredits
	tst.b	KEYARRAY+KEY_F8
	beq	.continue
	clr.b	KEYARRAY+KEY_F8			; Clear KeyDown

	bsr	SetupTitleAnimFade
	move.l	#TitleToCreditsFrame,TitleFrameRoutine

.continue
	IFGT	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC
	bsr	DrawLinescroller
	bsr	UpdateMenuCopper
	bsr	CheckAllPossibleFirebuttons

	tst.b	d0
	bne	.fastExit

	bra	.controls

.confirmExit
	bsr	DrawLinescroller
	bsr	UpdateMenuCopper

	move.l	TitleBackbuffer,a2
	bsr	DrawTitleConfirmExit
	move.l	TitleBuffer,a2
	bsr	DrawTitleConfirmExit

	move.b	#USERINTENT_QUIT,UserIntentState
	
	bra	.fastExit
.confirmExitCheck
	bsr	DrawLinescroller
	bsr	UpdateMenuCopper

	tst.b	KEYARRAY+KEY_Y		; Quit game
	bne	.quitIntent
	tst.b	KEYARRAY+KEY_N
	bne	.stay
	beq	.fastExit

.stay
	move.l	TitleBackbuffer,a0
	bsr	ClearTitlecreenControlsText
	move.l	TitleBuffer,a0
	bsr	ClearTitlecreenControlsText

	move.b	#USERINTENT_CHILL,UserIntentState

	bra	.fastExit
.exitChill
	moveq	#USERINTENT_CHILL,d0
	bra	.exit
.controls
	move.b	#USERINTENT_PLAY,UserIntentState

	bra	.exit
.quitIntent
	move.b	#USERINTENT_QUIT_CONFIRMED,UserIntentState
.exit
	bsr	FadeOutTitlescreen
	bsr	TitleRestoreBitplanePtrs
	clr.l	CurrentVisibleScreen

.fastExit
	movem.l	(sp)+,d0-a6
	rts

TitleRestoreBitplanePtrs:
	move.l	GAMESCREEN_BITMAPBASE_BACK,d1	; Restore bitplane pointers
	move.l	END_COPPTR_MISC,a0
	sub.l	#2*4*4,a0		; 2*4 longword instructions * 4 bitplanes

	BUFFERSWAP a0,d1,d0,d7

	rts

TitleToCreditsFrame:
	movem.l	d0-a6,-(sp)

        subq.b  #1,MenuRasterOffset
        bne	.updateRasters
        move.b	#10,MenuRasterOffset
.updateRasters
	bsr	UpdateMenuCopper
	bsr	DrawLinescroller

	move.l	COPPTR_MISC,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0

	jsr	FadeOutStep16		; a0 = Starting fadestep from COLOR00
	
	subq.b	#1,FadeCount
	
	tst.b	FadeCount
	bne	.exit

	jsr	ResetFadePalette
	bsr	TitleRestoreBitplanePtrs
	
	move.l	#ShowCreditsScreen,CurrentVisibleScreen
.exit
	movem.l	(sp)+,d0-a6

	rts

SetupTitleAnimFade:
        move.l	COPPTR_MISC,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
        
	move.b	#$f,FadeCount
	jsr	InitFadeOut16

	rts

FadeOutTitlescreen:
        move.l	COPPTR_MISC,a5
        move.l	hAddress(a5),a5
	lea	hColor00(a5),a5
        move.l  a5,a0
        bsr     FadeOutAnimateTitlescreen

	WAITVBL

        move.l  a5,a0
        jsr	ResetFadePalette

	rts

UpdateMenuCopper:
	move.l 	LogoCopperEffectPtr,a1

	tst.b	FadePhase
	bmi	.noFade

	move.w	#$f,d7
	sub.w	FadePhase,d7
	bra	.fade
.noFade
	moveq	#0,d7
.fade
	moveq	#0,d0
	moveq	#0,d4
	move.b	MenuRasterOffset,d4
	lea	PowTable,a0
	move.b	(a0,d4.w),d1
.l
	cmp.b	#48,d0
	bhs	.exit

	addq.l	#4+2,a1

	move.w	d1,d3
	moveq	#0,d2

	lsr.b	#2,d3
	add.b	#3,d3
	sub.b	d7,d3			; Apply fade
	bpl	.okFade
	moveq	#0,d3
.okFade
	move.b	d3,d2
	lsl.b	#4,d2
	or.b	d3,d2
	lsl.w	#4,d2
	or.b	d3,d2

	cmp.b	d1,d0
	beq	.line

	move.w	d2,(a1)+
	bra	.doneLine
.line
	sub.w	#$222,d2
	bpl	.goodLine
	moveq	#0,d2
.goodLine
	move.w	d2,(a1)+
	add.b	#10,d4

	cmp.b	#60,d4
 	blo	.lookup
	bra	.doneLine
.lookup
	lea	PowTable,a0
	move.b	(a0,d4.w),d1		; Lookup in tile map

.doneLine
	addq.l	#4+2,a1

	moveq	#0,d2
	move.w	#$d,d3			; Reset color
	sub.b	d7,d3			; Apply fade
	bpl	.okReset
	moveq	#0,d3
.okReset
	move.b	d3,d2
	lsl.b	#4,d2
	or.b	d3,d2
	lsl.w	#4,d2
	or.b	d3,d2

	move.w	d2,(a1)+

	addq.b	#1,d0
	bra	.l
.exit
	rts

; Fade to black while animating.
; Assumes that ResetFadePalette is executed afterwards.
; In:	a0 = address to COLOR00 in copperlist.
FadeOutAnimateTitlescreen:
	moveq	#$f,d7
	jsr	InitFadeOut16
.fadeLoop

	WAITLASTLINE	d0

	movem.l	d0-a6,-(sp)

        subq.b  #1,MenuRasterOffset
        bne	.updateRasters
        move.b	#10,MenuRasterOffset
.updateRasters
	bsr	UpdateMenuCopper
	bsr	DrawLinescroller

	movem.l	(sp)+,d0-a6

	jsr	FadeOutStep16		; a0 = Starting fadestep from COLOR00
	dbf	d7,.fadeLoop

	rts


TitleToggleFireToStart:
	btst	#0,ChillTick
	bne	.off
	bsr	DrawBackscreenFireToStartText
	bra	.done
.off
	bsr	ClearBackscreenFireToStartText
.done
	rts

; Set up hw-sprites in copperlist - no attached sprites.
AppendTitleCopper:
	bsr	AppendDisarmedSprites
	move.l	a1,LogoCopperEffectPtr

	moveq	#47,d0			; Add WAITs for logo-effect
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

	dbf	d0,.l


	move.l	#COPPERLIST_END,(a1)
	rts

; In:	a1 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenButtons:
	move.l	a6,-(sp)

	bsr	DrawEscButton

	lea 	CUSTOM,a6

	lea	BTN_F8_SM,a0			; F8 small
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

; In:	a0 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenCredits:
        movem.l d5-d6/a2/a6,-(sp)

        lea 	CUSTOM,a6

        add.l 	#(ScrBpl*4*(7+BTN_HEIGHT_SMALL))+2,a0
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

; In:	a2 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenVersion:
        lea     VERSION_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        add.l 	#(ScrBpl*248*4)+36,a2
        moveq   #ScrBpl-4,d5
        move.w  #(64*8*4)+2,d6
        bsr     DrawStringBuffer
        rts

; In:	a1 = Destination. Pointer to bitmap in CHIP memory.
DrawTitlescreenLogo:
	move.l	LOGO_BITMAPBASE,a0
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

; In:	a2 = Destination. Pointer to bitmap in CHIP memory.
DrawTitleConfirmExit:
	lea     QUIT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        add.l 	#(ScrBpl*164*4)+16,a2
        moveq	#ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
	rts

; In:	a0 = Destination. Pointer to bitmap in CHIP memory.
ClearTitlecreenControlsText:
        move.l  a6,-(sp)

        lea 	CUSTOM,a6

        add.l 	#(ScrBpl*164*4)+14,a0
        moveq   #ScrBpl-14,d0
        move.w  #(64*16*4)+7,d1

        bsr     ClearBlitWords
        move.l  (sp)+,a6
        rts