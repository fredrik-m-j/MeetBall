	include 's/utilities/scroller.asm'

DrawTitlescreen:
	bsr	ResetPlayers
	bsr	ResetBalls
	move.l	#Spr_Ball0,Ball0
	bsr	MoveBall0ToOwner

	bsr	ClearBackscreen
	bsr	DrawTitlescreenLogo
	bsr	DrawTitlescreenButtons
	bsr	DrawTitlescreenCredits
	bsr	DrawTitlescreenMakers
	bsr	DrawTitlescreenVersion

	bsr	AppendTitleCopper
	move.l	COPPTR_MISC,a1
	jsr	LoadCopper
	rts

ShowTitlescreen:
	bsr	DrawTitlescreen

.stay
	bsr	ClearTitlecreenControlsText
	move.b	#USERINTENT_CHILL,UserIntentState
.loop
        subq.b  #1,MenuRasterOffset
        bne	.frameTick
        move.b	#10,MenuRasterOffset
.frameTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .title
        
	clr.b	FrameTick
	addq.b	#1,ChillTick

	bsr	TitleToggleFireToStart

	subq.b	#1,ChillCount
	beq     .exitChill

.title
	tst.b	KEYARRAY+KEY_ESCAPE		; Exit game?
	bne	.confirmExit
	tst.b	UserIntentState
	bmi	.confirmExit

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$000,$dff180
	ENDC

	WAITLASTLINE	d0

	IFGT	ENABLE_RASTERMONITOR
	move.w	#$f00,$dff180
	ENDC
	
	bsr	CheckCreditsKey
	bsr	UpdateMenuCopper
	; bsr	UpdateScroller
	; bsr	DrawLinescroller
	bsr	CheckFirebuttons

	tst.b	d0
	bne.w	.loop

	bra.s	.controls

.confirmExit
	bsr	ClearTitlecreenControlsText

	lea     QUIT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*164*4)+16,a2
        moveq	#ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
.confirmExitLoop
	tst.b	KEYARRAY+KEY_Y		; Quit game
	bne	.quitIntent
	tst.b	KEYARRAY+KEY_N
	bne	.stay
	bra	.confirmExitLoop
.exitChill
	moveq	#USERINTENT_CHILL,d0
	bra	.exit
.controls
	bsr	ClearTitlecreenControlsText

	move.b	#USERINTENT_PLAY,UserIntentState

	bra	.exit
.quitIntent
	move.b	#USERINTENT_QUIT_CONFIRMED,UserIntentState
.exit
	bsr	FadeOutTitlescreen

	rts


CheckCreditsKey:
	tst.b	KEYARRAY+KEY_F8
	beq	.exit
	clr.b	KEYARRAY+KEY_F8		; Clear the KeyDown

	bsr	FadeOutTitlescreen
	bsr	ShowCreditsScreen
	bsr	DrawTitlescreen
.exit
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
	beq	.exit

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




; UpdateScroller:

; 	lea 	CUSTOM,a6

; 	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
; 	add.l   #(ScrBpl*170*4)+3*ScrBpl,a0
; 	moveq	#0,d0
; 	move.w	#(64*41*4)+20,d1
; 	bsr 	ClearBlitWords


; 	lea	Achar,a0
; .lchar
; 	move.l	(a0)+,d0
; 	beq	.exit

; 	move.l	d0,d2
; 	lsl.w	#2,d2				; 4*dy		B modulo register value

; 	move.w	d0,d1
; 	swap	d0
; 	sub.w	d0,d1
; 	lsl.w	#2,d1				; 4*(dy-dx)	A modulo register value

; 	; move.w	#4*(dy-dx),d1			; A modulo register value
; 	; move.w	#4*dy,d2			; B modulo register value

; 	move.w	d0,d4				; d0 = dx
; 	lsl.w	d4

; 	moveq	#0,d3
; 	move.w	d2,d3
; 	sub.w	d4,d3				; (4*dy)-(2*dx)	A pointer register value

; 	; move.l	#(4*dy)-(2*dx),d3		; A pointer register value

; 	move.w	d0,d4
; 	addq.w	#1,d4				; blit height = the length of the line +1
; 	lsl.w	#6,d4
; 	addq.w	#2,d4				; blit width = always 2

; 	; move.w	#(64*(dx+1))+2,d4		; blit height = the length of the line +1
; 						; blit width = always 2
; 	; move.w	#(64*7*4)+5,d2


; 	moveq	#0,d5
; 	move.b	ScrollWord,d5

; 	move.b	A_Char,d0
; 	sub.b	#1,d0
; 	bpl	.bltcon
; .updateScrollWord
; 	sub.b	#2,d5
; 	bpl	.charScrollOffset
; .r
; 	move.b	#ScrBpl-8,d5
; .charScrollOffset
; 	move.b	d5,ScrollWord

; 	move.b	#15,d0		; Reset A_Char

; .bltcon
; 	move.b	d0,A_Char

; 	ror.l	#4,d0
; 	add.l	#$bca0000,d0	; $4a = xor, $ca = normal
; 	add.w	(a0)+,d0


; 	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
; 	add.l	(a0)+,a1	; Destination D
; 	add.l	d5,a1

; 	WAITBLIT a6

; 	 move.l 	#%00001011110010100000000000000101,BLTCON0(a6)
; 	; move.l 	#$0bca0005,BLTCON0(a6)
; 	move.l	d0,BLTCON0(a6)
; 	; move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	
; 	move.l 	d3,BLTAPTH(a6)

; 	move.l 	a1,BLTCPTH(a6)			; word containing the first pixel of the line
; 	move.l 	a1,BLTDPTH(a6)			; word containing the first pixel of the line

; 	move.w	#$8000,BLTADAT(a6)		; Preloaded data register
; 	move.w	#$FFFF,BLTBDAT(a6)		; Solid line

; 	move.w 	d1,BLTAMOD(a6)
; 	move.w 	d2,BLTBMOD(a6)
; 	move.w 	#ScrBpl*4,BLTCMOD(a6)
; 	move.w 	#ScrBpl*4,BLTDMOD(a6)

; 	move.w 	d4,BLTSIZE(a6)

; 	bra	.lchar
; .exit
; 	rts




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