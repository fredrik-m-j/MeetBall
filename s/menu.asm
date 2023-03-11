MusicFadeSteps	equ	127
FadeFrameWaits	equ 	6

; First-time initialization of main menu.
InitMainMenu:
	lea	Bat0,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner
	rts

; Blits active player bats to menu screen.
DrawMenuBats:
	move.l 	MENUSCREEN_BITMAPBASE,a4

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a0
	bsr     CopyBlitToScreen

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea	Bat2,a0
	bsr     CopyBlitToScreen

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea	Bat1,a0
	bsr     CopyBlitToScreen

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea	Bat0,a0
	bsr     CopyBlitToScreen

.exit
	rts


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

	bsr	MenuClearPlayer1Text
	lea	Bat1,a0

	tst.b	Player1Enabled
	bmi.s	.set1Joy
	beq.s	.set1Wasd

	move.b	#$ff,Player1Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.f2

.set1Wasd
	move.b	#WasdControl,Player1Enabled
	bsr	MenuDrawPlayer1WS
	bra.s	.f2
.set1Joy
	move.b	#JoystickControl,Player1Enabled
	bsr	MenuDrawPlayer1Joy

	move.l 	MENUSCREEN_BITMAPBASE,a4
	bsr	CopyBlitToScreen
	lea	Bat1,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.f2
	tst.b	KEYARRAY+KEY_F2
	beq	.f3
	move.b	#0,KEYARRAY+KEY_F2

	bsr	MenuClearPlayer2Text
	lea	Bat2,a0

	tst.b	Player2Enabled
	bmi.s	.set2Joy
	beq.s	.set2Arrow

	move.b	#$ff,Player2Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.f3

.set2Arrow
	move.b	#ArrowControl,Player2Enabled
	bsr	MenuDrawPlayer2LR
	bra.s	.f3
.set2Joy
	move.b	#JoystickControl,Player2Enabled
	bsr	MenuDrawPlayer2Joy

	move.l 	MENUSCREEN_BITMAPBASE,a4
	bsr	CopyBlitToScreen
	lea	Bat2,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.f3
	tst.b	KEYARRAY+KEY_F3
	beq	.f4
	move.b	#0,KEYARRAY+KEY_F3

	bsr	MenuClearPlayer0Text
	lea	Bat0,a0

	tst.b	Player0Enabled
	bmi.s	.set0Joy
	beq.s	.set0Arrow

	move.b	#$ff,Player0Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.f4

.set0Arrow
	move.b	#ArrowControl,Player0Enabled
	bsr	MenuDrawPlayer0UD
	bra.s	.f4
.set0Joy
	move.b	#JoystickControl,Player0Enabled
	bsr	MenuDrawPlayer0Joy

	move.l 	MENUSCREEN_BITMAPBASE,a4
	bsr	CopyBlitToScreen
	lea	Bat0,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.f4
	tst.b	KEYARRAY+KEY_F4
	beq	.exit
	move.b	#0,KEYARRAY+KEY_F4

	bsr	MenuClearPlayer3Text
	lea	Bat3,a0

	tst.b	Player3Enabled
	bmi.s	.set3Joy
	beq.s	.set3Wasd

	move.b	#$ff,Player3Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.exit

.set3Wasd
	move.b	#WasdControl,Player3Enabled
	bsr	MenuDrawPlayer3AD
	bra.s	.exit
.set3Joy
	move.b	#JoystickControl,Player3Enabled
	bsr	MenuDrawPlayer3Joy

	move.l 	MENUSCREEN_BITMAPBASE,a4
	bsr	CopyBlitToScreen
	lea	Bat3,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.exit
	rts

; In:	a0 = bat handle :-)
MenuClearBat:
	move.l 	MENUSCREEN_BITMAPBASE,a2
	bsr	ClearBlitToScreen
	rts


; Out:	d0 = Zero if firebutton pressed, JOY_NOTHING if not.
CheckFirebuttons:
	bsr	CheckPlayer0Fire
	tst.b	d0
	beq.s	.done
	bsr	CheckPlayer1Fire
	tst.b	d0
	beq.s	.done
	bsr	CheckPlayer2Fire
	tst.b	d0
	beq.s	.done
	bsr	CheckPlayer3Fire
.done
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
	bsr	MoveBall0ToOwner
	bra.s	.exit
.checkPlayer1
	tst.b	Player1Enabled
	bmi.s	.checkPlayer2
	lea	Bat1,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner
	bra.s	.exit
.checkPlayer2
	tst.b	Player2Enabled
	bmi.s	.checkPlayer3
	lea	Bat2,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner
	bra.s	.exit
.checkPlayer3
	tst.b	Player3Enabled
	bmi.s	.disarmBallZero
	lea	Bat3,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner
	bra.s	.exit
.disarmBallZero
	move.l	#0,Spr_Ball0		; No player enabled - disarm ball sprite
.exit
	rts