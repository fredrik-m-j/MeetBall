MusicFadeSteps	equ	127
FadeFrameWaits	equ 	6

; Routines for the main menu
FadeOutMenu:
	move.l	COPPTR_MENU,a0		; Find menu copperlist
	move.l	hAddress(a0),a0
	lea	hColor00(a0),a0		; a0 traverses colors
	moveq	#MusicFadeSteps,d6
	moveq	#FadeFrameWaits,d7
	bsr	InitFadeOut16
.fadeLoop
	WAITFRAME
;	bsr.s	MenuStuff

	tst.l	d7
	bne.s	.skipColorFade

	bsr	FadeOutStep16		; a0 = Starting fadestep from COLOR00
	moveq	#FadeFrameWaits,d7
.skipColorFade
	ror.l	d6			; Fade music volume
	move.l	d6,d0
	rol.l	d6
	bsr	SetMasterVolume

	subi.l	#1,d7
	dbf	d6,.fadeLoop

	move.l	COPPTR_MENU,a0		; Find menu copperlist
	move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
	bsr	ResetFadePalette

	bsr 	StopAudio
	rts

; Player selection routine for F1-F4 keys.
CheckPlayerSelectionKeys:
.f1
	tst.b	KEYARRAY+KEY_F1
	beq	.f2
	move.b	#0,KEYARRAY+KEY_F1	; Clear the KeyDown
	not.b	Player1Enabled
	bne.s	.disarmBat1
	lea	Bat1,a1
	bsr	EnableMenuBat
	bra.s	.f2
.disarmBat1
	move.l	#0,Spr_Bat1		; Disarm sprite
	bsr	DisableMenuBat
.f2
	tst.b	KEYARRAY+KEY_F2
	beq	.f3
	move.b	#0,KEYARRAY+KEY_F2

	lea	Bat2,a0

	not.b	Player2Enabled
	bmi.s	.clearPlayer2
	beq.s	.blitPlayer2
.clearPlayer2
	add.l	#20,hAddress(a0)	; Ugly hack to use same routine for clearing
	lea 	HDL_BITMAP1_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#20,hAddress(a0)

	bsr	DisableMenuBat
	bra.s	.f3
.blitPlayer2
	lea 	HDL_BITMAP1_DAT,a4
	bsr	CopyBlitToScreen
	lea	Bat2,a1
	bsr	EnableMenuBat

.f3
	tst.b	KEYARRAY+KEY_F3
	beq	.f4
	move.b	#0,KEYARRAY+KEY_F3

	not.b	Player0Enabled
	bne.s	.disarmBat0
	lea	Bat0,a1
	bsr	EnableMenuBat
	bra.s	.f4
.disarmBat0
	move.l	#0,Spr_Bat0
	bsr	DisableMenuBat
.f4
	tst.b	KEYARRAY+KEY_F4
	beq	.exit
	move.b	#0,KEYARRAY+KEY_F4

	lea	Bat3,a0

	not.b	Player3Enabled
	bmi.s	.clearPlayer3
	beq.s	.blitPlayer3
.clearPlayer3
	add.l	#20,hAddress(a0)	; Ugly hack to use same routine for clearing
	lea 	HDL_BITMAP1_DAT,a4
	bsr	CopyBlitToScreen
	sub.l	#20,hAddress(a0)

	bsr	DisableMenuBat
	bra.s	.exit
.blitPlayer3
	lea 	HDL_BITMAP1_DAT,a4
	bsr	CopyBlitToScreen
	lea	Bat3,a1
	bsr	EnableMenuBat

.exit
	rts


; Out:	d0 = Zero if firebutton pressed, $ff if not.
CheckFirebuttons:
	move.b	#$ff,d0

	tst.b	Player0Enabled
	bmi.s	.checkPlayer1
	
	bsr	Joy1DetectFire
	btst.l	#JOY1_FIRE0_BIT,d3	; Firebutton 0 pressed?
	bne.s	.checkPlayer1

	moveq	#0,d0
	bra.s	.exit
.checkPlayer1
	tst.b	Player1Enabled
	bmi.s	.checkPlayer2

	bsr	Joy0DetectFire
	btst.l	#JOY0_FIRE0_BIT,d3	; Firebutton 0 pressed?
	bne.s	.checkPlayer2

	moveq	#0,d0
	bra.s	.exit
.checkPlayer2
	tst.b	Player2Enabled
	bmi.s	.checkPlayer3

	bsr	Joy2DetectFire
	btst.l	#JOY2_FIRE0_BIT,d3	; Firebutton 0 pressed?
	bne.s	.checkPlayer3

	moveq	#0,d0
	bra.s	.exit
.checkPlayer3
	tst.b	Player3Enabled
	bmi.s	.exit

	bsr	Joy3DetectFire
	btst.l	#JOY3_FIRE0_BIT,d3	; Firebutton 0 pressed?
	bne.s	.exit

	moveq	#0,d0
.exit
	rts

; In:	a1 = address to bat to enable in menu.
EnableMenuBat:
	bsr     SetBallColor

	lea	Ball0,a0
	move.l	a1,hBallPlayerBat(a0)
	rts

; Assign ball to a bat that is enabled or disarm ball sprite.
DisableMenuBat:
	tst.b	Player0Enabled
	bmi.s	.checkPlayer1
	lea	Bat0,a1
	bsr	EnableMenuBat
	bra.s	.exit
.checkPlayer1
	tst.b	Player1Enabled
	bmi.s	.checkPlayer2
	lea	Bat1,a1
	bsr	EnableMenuBat
	bra.s	.exit
.checkPlayer2
	tst.b	Player2Enabled
	bmi.s	.checkPlayer3
	lea	Bat2,a1
	bsr	EnableMenuBat
	bra.s	.exit
.checkPlayer3
	tst.b	Player3Enabled
	bmi.s	.disarmBallZero
	lea	Bat3,a1
	bsr	EnableMenuBat
	bra.s	.exit
.disarmBallZero
	move.l	#0,Spr_Ball0		; No player enabled - disarm ball sprite
.exit
	rts