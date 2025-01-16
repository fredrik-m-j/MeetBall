; First-time initialization.
; In:	a6 = address to CUSTOM $dff000
InitControlscreen:
	lea		Bat0,a1
	bsr		EnableMenuBat

	; Default to joystick controls and player 0
	move.b	#JoystickControl,Player0Enabled

	IFGT	ENABLE_DEBUG_PLAYERS
	move.b	#JoystickControl,Player1Enabled
	move.b	#JoystickControl,Player2Enabled
	move.b	#JoystickControl,Player3Enabled
	ENDC
	rts

ShowControlscreen:
	jsr		ResetPlayers
	bsr		ResetBalls
	move.l	#Spr_Ball0,Ball0
	bsr		MoveBall0ToOwner

	bsr		ClearBackscreen
	bsr		DrawControlscreenButtons
	bsr		DrawControlscreenBats
	bsr		DrawControlscreenBallspeed
	bsr		DrawControlscreenRampup
	bsr		DrawControlscreenControlsText
	bsr 	DrawControlscreenFireToStartText
	bsr 	DrawControlscreenCurrentControls

	bsr		AppendControlsCopper
	move.l	COPPTR_MISC,a1
	jsr		LoadCopper

	bsr		AwaitAllFirebuttonsReleased

.controlsLoop
	tst.b	KEYARRAY+KEY_ESCAPE		; Exit controls on ESC?
	bne		.escape

	WAITBOVP	d0
	
	bsr		CheckPlayerSelectionKeys
	bsr		CheckBallspeedKey
	bsr		CheckBallspeedIncreaseKey

	lea		Ball0,a2
	jsr		MoveBall
	bsr		MenuPlayerUpdates
	bsr		CheckFirebuttons
	tst.b	d0						; Start game?
	bne.s	.controlsLoop


	move.b	#USERINTENT_PLAY,UserIntentState(a5)	; Game is on!

	move.l	COPPTR_MISC,a0
	move.l	hAddress(a0),a0
	lea		hColor00(a0),a0
	move.l	a0,-(sp)
	bsr		GfxAndMusicFadeOut
	move.l	(sp)+,a0
	
	WAITVBL

	jsr		ResetFadePalette

	bsr		StartNewGame
	bra		.exit

.escape
	move.b	#USERINTENT_QUIT,UserIntentState(a5)

	move.l	COPPTR_MISC,a0
	move.l	hAddress(a0),a0
	lea		hColor00(a0),a0
	move.l	a0,-(sp)
	jsr		SimpleFadeOut
	move.l	(sp)+,a0

	WAITVBL

	jsr		ResetFadePalette
.exit
	rts

DrawControlscreenControlsText:
	movem.l	d5-d6/a2,-(sp)

	lea		CONTROLS1_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*120*4)+14,a2
	moveq	#ScrBpl-14,d5
	move.w	#(64*8*4)+7,d6
	bsr		DrawStringBuffer

	moveq	#2,d0					; Finetune
	bsr		BlitShiftRight

	movem.l	(sp)+,d5-d6/a2
	rts
DrawControlscreenFireToStartText:
	movem.l	d5-d6/a2/a5,-(sp)

	lea		CONTROLS2_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*130*4)+15,a2
	moveq	#ScrBpl-14,d5
	move.w	#(64*8*4)+7,d6

	bsr		DrawStringBuffer

	movem.l	(sp)+,d5-d6/a2/a5
	rts

ClearControlscreenPlayer0Text:
	move.l  GAMESCREEN_BackPtr(a5),a0

	add.l	#(ScrBpl*147*4)+28,a0
	moveq	#ScrBpl-12,d0
	move.w	#(64*24*4)+6,d1

	bsr		ClearBlitWords
	rts
ClearControlscreenPlayer1Text:
	move.l  GAMESCREEN_BackPtr(a5),a0

	add.l	#(ScrBpl*147*4)+2,a0
	moveq	#ScrBpl-12,d0
	move.w	#(64*28*4)+6,d1

	bsr		ClearBlitWords
	rts
ClearControlscreenPlayer2Text:
	move.l  GAMESCREEN_BackPtr(a5),a0

	add.l	#(ScrBpl*212*4)+22,a0
	moveq	#ScrBpl-14,d0
	move.w	#(64*28*4)+7,d1

	bsr		ClearBlitWords
	rts
ClearControlscreenPlayer3Text:
	move.l  GAMESCREEN_BackPtr(a5),a0

	add.l	#(ScrBpl*19*4)+22,a0
	moveq	#ScrBpl-14,d0
	move.w	#(64*28*4)+7,d1

	bsr		ClearBlitWords
	rts

DrawControlscreenPlayer0Joy:
	movem.l	d5/d6/a2,-(sp)

	lea		JOY1_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*148*4)+28+ScrBpl,a2
	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6
	bsr		DrawStringBuffer

	moveq	#3,d0					; Finetune
	bsr		BlitShiftRight

	move.l  GAMESCREEN_BackPtr(a5),a2 ; Fill background
	add.l	#(ScrBpl*147*4)+28,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	movem.l	(sp)+,d5/d6/a2
	rts
DrawControlscreenPlayer1Joy:
	movem.l	d5/d6/a2,-(sp)

	lea		JOY0_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*148*4)+ScrBpl+2,a2
	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6
	bsr		DrawStringBuffer

	moveq	#3,d0					; Finetune
	bsr		BlitShiftRight

	move.l  GAMESCREEN_BackPtr(a5),a2	; Fill background
	add.l	#(ScrBpl*147*4)+2,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	movem.l	(sp)+,d5/d6/a2
	rts
DrawControlscreenPlayer2Joy:
	movem.l	d5/d6/a2,-(sp)

	lea		JOY2_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*213*4)+22+ScrBpl,a2
	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6
	bsr		DrawStringBuffer

	moveq	#3,d0					; Finetune
	bsr		BlitShiftRight

	move.l  GAMESCREEN_BackPtr(a5),a2	; Fill background
	add.l	#(ScrBpl*212*4)+22,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	move.l  GAMESCREEN_BackPtr(a5),a2	; Shift
	add.l	#(ScrBpl*212*4)+22,a2
	moveq	#5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*12*4)+6,d6
	bsr		BlitShiftRight

	movem.l	(sp)+,d5/d6/a2
	rts
DrawControlscreenPlayer3Joy:
	movem.l	d5/d6/a2,-(sp)

	lea		JOY3_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*20*4)+22+ScrBpl,a2
	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6
	bsr		DrawStringBuffer

	moveq	#3,d0					; Finetune
	bsr		BlitShiftRight

	move.l  GAMESCREEN_BackPtr(a5),a2	; Fill background
	add.l	#(ScrBpl*19*4)+22,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*10*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	move.l  GAMESCREEN_BackPtr(a5),a2	; Shift
	add.l	#(ScrBpl*19*4)+22,a2
	moveq	#5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*12*4)+6,d6
	bsr		BlitShiftRight

	movem.l	(sp)+,d5/d6/a2
	rts

DrawControlscreenPlayer0UpArrow:
	lea		FONT,a0
	add.l	#("Z"+2)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*100*4)+39,a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2   ; Clear opposite arrow
	add.l	#(ScrBpl*148*4)+39,a2
	CHRCLR81	a2,40
	rts
DrawControlscreenPlayer0DownArrow:
	lea		FONT,a0
	add.l	#("Z"+3)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*148*4)+39,a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*100*4)+39,a2
	CHRCLR81	a2,40
	rts
ClearControlscreenPlayer0Arrows:
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*100*4)+39,a2
	CHRCLR81	a2,40
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*148*4)+39,a2
	CHRCLR81	a2,40
	rts

DrawControlscreenPlayer1UpArrow:
	lea		FONT,a0
	add.l	#("Z"+2)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*100*4),a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2   ; Clear opposite arrow
	add.l	#(ScrBpl*148*4),a2
	CHRCLR81	a2,40
	rts
DrawControlscreenPlayer1DownArrow:
	lea		FONT,a0
	add.l	#("Z"+3)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*148*4),a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*100*4),a2
	CHRCLR81	a2,40
	rts
ClearControlscreenPlayer1Arrows:
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*100*4),a2
	CHRCLR81	a2,40
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*148*4),a2
	CHRCLR81	a2,40
	rts

DrawControlscreenPlayer2LeftArrow:
	lea		FONT,a0
	add.l	#("Z"+1)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*248*4)+16,a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2   ; Clear opposite arrow
	add.l	#(ScrBpl*248*4)+23,a2
	CHRCLR81	a2,40
	rts
DrawControlscreenPlayer2RightArrow:
	lea		FONT,a0
	add.l	#("Z"+4)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*248*4)+23,a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*248*4)+16,a2
	CHRCLR81	a2,40
	rts
ClearControlscreenPlayer2Arrows:
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*248*4)+16,a2
	CHRCLR81	a2,40
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*248*4)+23,a2
	CHRCLR81	a2,40
	rts

DrawControlscreenPlayer3LeftArrow:
	lea		FONT,a0
	add.l	#("Z"+1)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*4)+16,a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2   ; Clear opposite arrow
	add.l	#(ScrBpl*4)+23,a2
	CHRCLR81	a2,40
	rts
DrawControlscreenPlayer3RightArrow:
	lea		FONT,a0
	add.l	#("Z"+4)-$20,a0

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*4)+23,a2
	bsr		DrawSinglePlaneChar
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*4)+16,a2
	CHRCLR81	a2,40
	rts
ClearControlscreenPlayer3Arrows:
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*4)+16,a2
	CHRCLR81	a2,40
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*4)+23,a2
	CHRCLR81	a2,40
	rts


DrawControlscreenPlayer1Keys:
	movem.l	d5-d6/a2,-(sp)

	lea		UP_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1
	move.b	#"1",-1(a1)
	clr.b	(a1)

	moveq	#ScrBpl-12,d5
	move.w	#(64*8*4)+6,d6

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*148*4)+ScrBpl+1,a2
	bsr		DrawStringBuffer		; Up

	moveq	#5,d0					; Finetune
	bsr		BlitShiftRight

	lea		DOWN_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1
	move.b	#"Q",-1(a1)
	clr.b	(a1)

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*156*4)+ScrBpl+1,a2
	bsr		DrawStringBuffer		; Down
   
	moveq	#5,d0					; Finetune
	bsr		BlitShiftRight

	lea		FIRE_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	lea		LSHIFT_STR,a0
	subq.l	#1,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*164*4)+ScrBpl+1,a2
	bsr		DrawStringBuffer		; Fire

	moveq	#5,d0					; Finetune
	bsr		BlitShiftRight

	move.l  GAMESCREEN_BackPtr(a5),a2	; Fill background
	add.l	#(ScrBpl*147*4)+2,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	movem.l	(sp)+,d5/d6/a2
	rts

DrawControlscreenPlayer2Keys:
	movem.l	d5-d6/a2,-(sp)

	lea		LEFT_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1
	move.b	#"K",-1(a1)
	clr.b	(a1)

	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*213*4)+22+ScrBpl,a2
	bsr		DrawStringBuffer		; Left

	lea		RIGHT_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1
	move.b	#"L",-1(a1)
	clr.b	(a1)

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*221*4)+22+ScrBpl,a2
	bsr		DrawStringBuffer		; Right

	lea		FIRE_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	lea		RAMIGA_STR,a0
	subq.l	#1,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*229*4)+22+ScrBpl,a2
	bsr		DrawStringBuffer		; Fire

	move.l  GAMESCREEN_BackPtr(a5),a2	; Fill background
	add.l	#(ScrBpl*212*4)+22,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	move.l  GAMESCREEN_BackPtr(a5),a2	; Shift
	add.l	#(ScrBpl*212*4)+22,a2
	moveq	#5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*28*4)+6,d6
	bsr		BlitShiftRight

	movem.l	(sp)+,d5/d6/a2
	rts

DrawControlscreenPlayer3Keys:
	movem.l	d5-d6/a2,-(sp)

	lea		LEFT_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1
	move.b	#"Z",-1(a1)
	clr.b	(a1)

	moveq	#ScrBpl-10,d5
	move.w	#(64*8*4)+5,d6

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*20*4)+22+ScrBpl,a2
	bsr		DrawStringBuffer		; Left

	lea		RIGHT_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1
	move.b	#"X",-1(a1)
	clr.b	(a1)

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*28*4)+22+ScrBpl,a2
	bsr		DrawStringBuffer		; Right

	lea		FIRE_STR,a0
	lea		STRINGBUFFER,a1
	COPYSTR	a0,a1

	lea		LAMIGA_STR,a0
	subq.l	#1,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*36*4)+22+ScrBpl,a2
	bsr		DrawStringBuffer		; Fire

	move.l  GAMESCREEN_BackPtr(a5),a2	; Fill background
	add.l	#(ScrBpl*19*4)+22,a2
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*26*1)+5,d2
	jsr		FillBoxBlit

	add.l	#11*ScrBpl,a2
	jsr		FillBoxBlit

	move.l  GAMESCREEN_BackPtr(a5),a2	; Shift
	add.l	#(ScrBpl*19*4)+22,a2
	moveq	#5,d0
	move.w	#ScrBpl-12,d5
	move.w	#(64*28*4)+6,d6
	bsr		BlitShiftRight

	movem.l	(sp)+,d5/d6/a2
	rts

DrawControlscreenButtons:
	move.l	GAMESCREEN_BackPtr(a5),a1
	bsr		DrawEscButton

	lea		BTN_F5_SM,a0			; F5 small
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l 	#(ScrBpl*(3+BTN_HEIGHT_SMALL)*4),a1
   
	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.l 	#DEFAULT_MASK,BLTAFWM(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w	#0,BLTAMOD(a6)
	move.w	#ScrBpl-2,BLTDMOD(a6)
	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)

	lea		BTN_F6_SM,a0			; F6 small
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l 	#(ScrBpl*(3+BTN_HEIGHT_SMALL*2)*4),a1
   
	WAITBLIT

	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT_SMALL*4)+1,BLTSIZE(a6)


	lea		BTN_F1,a0				; F1
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l 	#(ScrBpl*(DISP_HEIGHT/2-12)*4)+2,a1
   
	WAITBLIT

	move.l	#$29f02000,BLTCON0(a6)
	move.w	#ScrBpl-4,BLTDMOD(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)


	lea		BTN_F2,a0				; F2
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l 	#(ScrBpl*(DISP_HEIGHT-BTN_HEIGHT-19)*4)+18,a1
   
	WAITBLIT

	move.l	#$19f01000,BLTCON0(a6)
	move.w	#ScrBpl-4,BLTDMOD(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)


	lea		BTN_F3,a0				; F3
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l 	#(ScrBpl*(DISP_HEIGHT/2-12)*4)+34,a1
   
	WAITBLIT

	move.l	#$09f00000,BLTCON0(a6)
	move.w	#ScrBpl-4,BLTDMOD(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)


	lea		BTN_F4,a0				; F4
	move.l	GAMESCREEN_BackPtr(a5),a1
	add.l	#(ScrBpl*19*4)+18,a1

	WAITBLIT

	move.l	#$19f01000,BLTCON0(a6)
	move.w	#ScrBpl-4,BLTDMOD(a6)
	move.l	a0,BLTAPTH(a6)
	move.l	a1,BLTDPTH(a6)
	move.w 	#(64*BTN_HEIGHT*4)+2,BLTSIZE(a6)
	rts

; Blits active player bats to menu screen.
DrawControlscreenBats:
	movem.l	a2-a4,-(sp)

	move.l	GAMESCREEN_BackPtr(a5),a4
	movea.l	a4,a2

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea		Bat3,a3
	jsr		CookieBlitToScreen

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea		Bat2,a3
	jsr		CookieBlitToScreen

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea		Bat1,a3
	jsr		CookieBlitToScreen

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea		Bat0,a3
	jsr		CookieBlitToScreen
.exit
	movem.l	(sp)+,a2-a4
	rts

DrawControlscreenBallspeed:
	movem.l	d5-d6/a2,-(sp)

	lea		BALLSPEED_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1

	moveq	#0,d0
	move.w	BallspeedBase,d0
	jsr		Binary2Decimal

	move.b	#" ",-1(a1)
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a0
	add.l	#(ScrBpl*16*4)+2,a0
	moveq	#ScrBpl-12,d0
	move.w	#(64*8*4)+6,d1

	bsr		ClearBlitWords

	move.l	a0,a2
	move.l	d0,d5
	move.l	d1,d6
	bsr		DrawStringBuffer

	movem.l	(sp)+,d5-d6/a2
	rts

DrawControlscreenRampup:
	movem.l	d5-d6/a2,-(sp)

	lea		RAMPUP_STR,a2
	lea		STRINGBUFFER,a1
	COPYSTR	a2,a1

	moveq	#0,d0
	move.b	BallspeedFrameCount,d0
	jsr		Binary2Decimal

	move.b	#" ",-1(a1)
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a0
	add.l	#(ScrBpl*28*4)+2,a0
	moveq	#ScrBpl-14,d0
	move.w	#(64*8*4)+7,d1

	bsr		ClearBlitWords

	move.l	a0,a2
	move.l	d0,d5
	move.l	d1,d6
	bsr		DrawStringBuffer

	movem.l	(sp)+,d5-d6/a2
	rts


CheckBallspeedKey:
	tst.b	KEYARRAY+KEY_F5
	beq		.exit
	; clr.b	KEYARRAY+KEY_F5		; Clear the KeyDown

	cmp.w	#USERMAX_BALLSPEED,BallspeedBase
	blo.s	.ok
	move.w	#MIN_BALLSPEED,BallspeedBase
.ok
	addq.w	#1,BallspeedBase
	bsr		DrawControlscreenBallspeed
.exit
	rts

CheckBallspeedIncreaseKey:
	tst.b	KEYARRAY+KEY_F6
	beq		.exit
	; clr.b	KEYARRAY+KEY_F6		; Clear the KeyDown

	cmp.b	#MAX_RAMPUP,BallspeedFrameCount
	blo.s	.ok
	move.b	#MIN_RAMPUP,BallspeedFrameCount
	subq.b	#1,BallspeedFrameCount
.ok
	addq.b	#1,BallspeedFrameCount

	bsr		DrawControlscreenRampup
.exit
	rts

; Player selection routine for F1-F4 keys.
CheckPlayerSelectionKeys:
	movem.l	d2/a2-a4,-(sp)

	move.l	KEYARRAY+KEY_F1,d2

	move.l	GAMESCREEN_BackPtr(a5),a4
	movea.l	a4,a2

.f1
	tst.b	KEYARRAY+KEY_F1
	beq		.f2
	clr.b	KEYARRAY+KEY_F1			; Clear the KeyDown

	bsr		ClearControlscreenPlayer1Text
	lea		Bat1,a3

	tst.b	Player1Enabled
	bmi.s	.set1Joy
	beq.s	.set1keys

	move.b	#$ff,Player1Enabled
	jsr		ClearBlitToScreen
	bsr		DisableMenuBat
	bra.s	.f2

.set1keys
	move.b	#KeyboardControl,Player1Enabled
	bsr		DrawControlscreenPlayer1Keys
	bra.s	.f2
.set1Joy
	move.b	#JoystickControl,Player1Enabled
	jsr		CookieBlitToScreen
	bsr		DrawControlscreenPlayer1Joy

	lea		Bat1,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner

.f2
	tst.b	KEYARRAY+KEY_F2
	beq		.f3
	clr.b	KEYARRAY+KEY_F2

	bsr		ClearControlscreenPlayer2Text
	lea		Bat2,a3

	tst.b	Player2Enabled
	bmi.s	.set2Joy
	beq.s	.set2Keys

	move.b	#$ff,Player2Enabled
	jsr		ClearBlitToScreen
	bsr		DisableMenuBat
	bra.s	.f3

.set2Keys
	move.b	#KeyboardControl,Player2Enabled
	bsr		DrawControlscreenPlayer2Keys
	bra.s	.f3
.set2Joy
	move.b	#JoystickControl,Player2Enabled
	jsr		CookieBlitToScreen
	bsr		DrawControlscreenPlayer2Joy

	lea		Bat2,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner

.f3
	tst.b	KEYARRAY+KEY_F3
	beq		.f4
	clr.b	KEYARRAY+KEY_F3

	bsr		ClearControlscreenPlayer0Text
	lea		Bat0,a3

	tst.b	Player0Enabled
	bmi.s	.set0Joy

	move.b	#$ff,Player0Enabled
	jsr		ClearBlitToScreen
	bsr		DisableMenuBat
	bra.s	.f4
.set0Joy
	move.b	#JoystickControl,Player0Enabled
	jsr		CookieBlitToScreen
	bsr		DrawControlscreenPlayer0Joy

	lea		Bat0,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner

.f4
	tst.b	KEYARRAY+KEY_F4
	beq		.exit
	clr.b	KEYARRAY+KEY_F4

	bsr		ClearControlscreenPlayer3Text
	lea		Bat3,a3

	tst.b	Player3Enabled
	bmi.s	.set3Joy
	beq.s	.set3Keys

	move.b	#$ff,Player3Enabled
	jsr		ClearBlitToScreen
	bsr		DisableMenuBat
	bra.s	.exit

.set3Keys
	move.b	#KeyboardControl,Player3Enabled
	bsr		DrawControlscreenPlayer3Keys
	bra.s	.exit
.set3Joy
	move.b	#JoystickControl,Player3Enabled
	jsr		CookieBlitToScreen
	bsr		DrawControlscreenPlayer3Joy

	lea		Bat3,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner

.exit
	tst.l	d2
	beq		.done
	jsr		SetPlayerCount
	bsr		SetAdjustedBallspeed
.done
	movem.l	(sp)+,d2/a2-a4
	rts


MenuPlayerUpdates:
	movem.l	d3/a2,-(sp)

	tst.b	Player0Enabled
	bmi.s	.player1
	beq.s	.joy1

	move.w	#KEY_UP,d0
	move.w	#KEY_DOWN,d1
	jsr		DetectUpDown
	bra.s	.updatePlayer0
.joy1
	lea		CUSTOM+JOY1DAT,a2
	jsr		agdJoyDetectMovement
.updatePlayer0
	cmpi.b	#JOY_NOTHING,d3
	beq.s	.clearPlayer0UD

.0up
	btst.l	#JOY_UP_BIT,d3
	bne.s	.0down
	bsr		DrawControlscreenPlayer0UpArrow
	bra.s	.player1
.0down
	bsr		DrawControlscreenPlayer0DownArrow
	bra.s	.player1
.clearPlayer0UD
	bsr		ClearControlscreenPlayer0Arrows

.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	beq.s	.joy0

	move.w	#Player1KeyUp,d0
	move.w	#Player1KeyDown,d1
	jsr		DetectUpDown
	bra.s	.updatePlayer1

.joy0
	lea		CUSTOM+JOY0DAT,a2
	jsr		agdJoyDetectMovement
.updatePlayer1
	cmpi.b	#JOY_NOTHING,d3
	beq.s	.clearPlayer1UD

.1up
	btst.l	#JOY_UP_BIT,d3
	bne.s	.1down
	bsr		DrawControlscreenPlayer1UpArrow
	bra.s	.player2
.1down
	bsr		DrawControlscreenPlayer1DownArrow
	bra.s	.player2
.clearPlayer1UD
	bsr		ClearControlscreenPlayer1Arrows

.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	beq.s	.joy2

	move.w	#Player2KeyLeft,d0
	move.w	#Player2KeyRight,d1
	jsr		DetectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	and.b	#$0f,d3

.2left
	btst.l	#JOY_LEFT_BIT,d3
	bne.s	.2rite
	bsr		DrawControlscreenPlayer2LeftArrow
	bra.s	.player3
.2rite	
	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.clearPlayer2LR
	bsr		DrawControlscreenPlayer2RightArrow
	bra.s	.player3
.clearPlayer2LR
	bsr		ClearControlscreenPlayer2Arrows

.player3
	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	move.w	#Player3KeyLeft,d0
	move.w	#Player3KeyRight,d1
	jsr		DetectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	and.b	#$0f,d3

.3left
	btst.l	#JOY_LEFT_BIT,d3
	bne.s	.3rite
	bsr		DrawControlscreenPlayer3LeftArrow
	bra.s	.exit
.3rite
	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.clearPlayer3LR
	bsr		DrawControlscreenPlayer3RightArrow
	bra.s	.exit
.clearPlayer3LR
	bsr		ClearControlscreenPlayer3Arrows

.exit
	movem.l	(sp)+,d3/a2
	rts


; In:	a1 = address to bat to enable in menu.
EnableMenuBat:
	lea		Ball0,a0
	bsr		SetBallColor

	move.l	a1,hPlayerBat(a0)
	rts

; Assign ball to a bat that is enabled or disarm ball sprite.
DisableMenuBat:
	tst.b	Player0Enabled
	bmi.s	.checkPlayer1
	lea		Bat0,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner
	bra.s	.exit
.checkPlayer1
	tst.b	Player1Enabled
	bmi.s	.checkPlayer2
	lea		Bat1,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner
	bra.s	.exit
.checkPlayer2
	tst.b	Player2Enabled
	bmi.s	.checkPlayer3
	lea		Bat2,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner
	bra.s	.exit
.checkPlayer3
	tst.b	Player3Enabled
	bmi.s	.disarmBallZero
	lea		Bat3,a1
	bsr		EnableMenuBat
	bsr		MoveBall0ToOwner
	bra.s	.exit
.disarmBallZero
	clr.l	Spr_Ball0				; No player enabled - disarm ball sprite
.exit
	rts

SetAdjustedBallspeed:
	move.w	#DEFAULT_BALLSPEED+4,d1

	move.w	PlayerCount,d0
	beq		.exit
	subq.w	#1,d0
.l
	subq.w	#4,d1
	dbf		d0,.l

	move.w	d1,BallspeedBase
	bsr		DrawControlscreenBallspeed
.exit
	rts


AppendControlsCopper:
	move.l	END_COPPTR_MISC,a1

	move.l	#Spr_Ball0,d0			; Set sprite pointers
	move.w	#SPR0PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.w	d0,(a1)+
					; Not in use
	move.l	#Spr_Ball1,d0			; Use Ball1 as dummy
	move.w	#SPR1PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR1PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR2PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR2PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR3PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR3PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR4PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR4PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR5PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR6PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR6PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR7PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR7PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#COPPERLIST_END,(a1)
	rts

DrawControlscreenCurrentControls:
	tst.b	Player0Enabled
	bne		.player1
	bsr		DrawControlscreenPlayer0Joy

.player1
	tst.b	Player1Enabled
	bmi		.player2
	beq		.player1Joy
	bsr		DrawControlscreenPlayer1Keys
	bra		.player2
.player1Joy
	bsr		DrawControlscreenPlayer1Joy

.player2
	tst.b	Player2Enabled
	bmi		.player3
	beq		.player2Joy
	bsr		DrawControlscreenPlayer2Keys
	bra		.player3
.player2Joy
	bsr		DrawControlscreenPlayer2Joy

.player3
	tst.b	Player3Enabled
	bmi		.done
	beq		.player3Joy
	bsr		DrawControlscreenPlayer3Keys
	bra		.done
.player3Joy
	bsr		DrawControlscreenPlayer3Joy

.done
	rts