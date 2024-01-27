	include	's/credits.asm'

ShowTitlescreen:
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

MainMenu:
	bsr	ShowTitlescreen

	move.b	#ATTRACT_ON,AttractState
	move.b	#MENU_ATTRACT_SEC,AttractCount

.drawTitleMiscText
	bsr	ClearTitlecreenControlsText
.loop
        subq.b  #1,MenuRasterOffset
        bne	.frameTick
        move.b	#10,MenuRasterOffset
.frameTick
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        bne.s   .menu
        
	clr.b	FrameTick
	addq.b	#1,AttractTick

	bsr	MenuToggleFireToStart

	tst.b	AttractState
	bmi	.menu
	subq.b	#1,AttractCount
	bne.s	.menu
	bsr	NextAttract

.menu
	tst.b	KEYARRAY+KEY_ESCAPE		; Exit game?
	bne.s	.confirmExit

	WAITLASTLINE	d0
	
	bsr	CheckCreditsKey
	bsr	UpdateMenuCopper
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
	tst.b	KEYARRAY+KEY_Y		; Exit game
	bne.s	.setExit
	tst.b	KEYARRAY+KEY_N		; Stay
	bne.w	.drawTitleMiscText
	bra.s	.confirmExitLoop
.setExit
	moveq	#-1,d0
	bra	.exit
.controls
	move.b	#-1,AttractCount
	move.b	#ATTRACT_OFF,AttractState
	bsr	ClearTitlecreenControlsText

	bsr	FadeOutTitlescreen

	bsr	ShowControlscreen
.exit
	rts

NextAttract:
	bsr	FadeOutTitlescreen

	move.l	AttractTablePtr,a0
	move.l	(a0),a0
	jsr	(a0)

	bsr	ShowTitlescreen

	move.l	AttractTablePtr,a0		; Update pointer
	addq.l	#4,a0

	cmpa.l	#AttractTableEnd,a0
	bne	.setPtr
	move.l	#AttractTable,a0
.setPtr
	move.l	a0,AttractTablePtr

	move.b	#MENU_ATTRACT_SEC,AttractCount
	rts


CheckCreditsKey:
	tst.b	KEYARRAY+KEY_F8
	beq	.exit
	clr.b	KEYARRAY+KEY_F8		; Clear the KeyDown

	bsr	FadeOutTitlescreen
	bsr	ShowCreditsScreen
	bsr	ShowTitlescreen
.exit
	rts

FadeOutTitlescreen:
        move.l	COPPTR_MISC,a5
        move.l	hAddress(a5),a5
	lea	hColor00(a5),a5
        move.l  a5,a0
        bsr     FadeOutAnimateTitlescreen

	WAITVBL

        move.l	COPPTR_MISC,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
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

; Fade to black while animating.
; Assumes that ResetFadePalette is executed afterwards.
; In:	a0 = address to COLOR00 in copperlist.
FadeOutAnimateTitlescreen:
	moveq	#$f,d7
	jsr	InitFadeOut16
.fadeLoop

	WAITLASTLINE	d0


;	TODO: currently destroys 1 color
; 	movem.l	d0-a6,-(sp)

;         subq.b  #1,MenuRasterOffset
;         bne	.updateRasters
;         move.b	#10,MenuRasterOffset
; .updateRasters
; 	bsr	UpdateMenuCopper
	
; 	movem.l	(sp)+,d0-a6

	jsr	FadeOutStep16		; a0 = Starting fadestep from COLOR00
	dbf	d7,.fadeLoop

	rts


MenuToggleFireToStart:
	btst	#0,AttractTick
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