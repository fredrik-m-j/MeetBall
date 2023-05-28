MusicFadeSteps	equ	127
FadeFrameWaits	equ 	6

	include	's/credits.asm'


; First-time initialization of main menu.
InitMainMenu:
	lea	Bat0,a1
	bsr	EnableMenuBat
	rts

MenuLoop:
	bsr	MenuClearMiscText

	lea	CONTROLS1_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4)+11,a2
        move.l  #ScrBpl-20,d5
        move.w  #(64*8*4)+10,d6
        bsr     DrawStringBuffer

	lea	CONTROLS2_STR,a0
	COPYSTR a0,a1

	move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*163*4)+15,a2
        move.l  #ScrBpl-16,d5
        move.w  #(64*8*4)+8,d6

	bsr     DrawStringBuffer

.loop
	tst.b	KEYARRAY+KEY_ESCAPE		; Exit game?
	bne.s	.confirmExit

	bsr	CheckPlayerSelectionKeys
	bsr	CheckCreditsKey

	WAITLASTLINE d0
	bsr	DrawSprites
	bsr	MenuPlayerUpdates
	bsr	CheckFirebuttons
	tst.b	d0
	bne.s	.loop

	bra.s	.startGame

.confirmExit
	bsr	MenuClearMiscText

	lea     QUIT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*155*4)+16,a2
        move.l  #ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
.confirmExitLoop
	tst.b	KEYARRAY+KEY_Y		; Exit game
	bne.s	.exit
	tst.b	KEYARRAY+KEY_N		; Stay
	bne.w	MenuLoop
	bra.s	.confirmExitLoop
.exit
	moveq	#-1,d0
.startGame
	bsr	MenuClearMiscText

	rts

; Blits active player bats to menu screen.
DrawMenuBats:
	move.l 	MENUSCREEN_BITMAPBASE,a1
	move.l 	MENUSCREEN_BITMAPBASE,a2

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a0
	bsr	CookieBlitToScreen

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea	Bat2,a0
	bsr     CookieBlitToScreen

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea	Bat1,a0
	bsr     CookieBlitToScreen

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea	Bat0,a0
	bsr     CookieBlitToScreen
.exit
	rts


CheckCreditsKey:
	tst.b	KEYARRAY+KEY_F8
	beq	.exit
	move.b	#0,KEYARRAY+KEY_F8	; Clear the KeyDown

	move.l	Spr_Ball0,d0		; Preserve ball status
	move.l	d0,-(sp)
	move.l	#0,Spr_Ball0		; Disarm ball sprite

        move.l	COPPTR_MENU,a5
        move.l	hAddress(a5),a5
	lea	hColor00(a5),a5
        move.l  a5,a0
        bsr     SimpleFadeOut

	bsr	ShowCredits

        move.l  a5,a0
        bsr	ResetFadePalette

	move.l	(sp)+,d0
	move.l	d0,Spr_Ball0
.exit
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
	beq.s	.set1keys

	move.b	#$ff,Player1Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.f2

.set1keys
	move.b	#KeyboardControl,Player1Enabled
	bsr	MenuDrawPlayer1Keys
	bra.s	.f2
.set1Joy
	move.b	#JoystickControl,Player1Enabled
	move.l 	MENUSCREEN_BITMAPBASE,a1
	move.l 	MENUSCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer1Joy

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
	beq.s	.set2Keys

	move.b	#$ff,Player2Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.f3

.set2Keys
	move.b	#KeyboardControl,Player2Enabled
	bsr	MenuDrawPlayer2Keys
	bra.s	.f3
.set2Joy
	move.b	#JoystickControl,Player2Enabled
	move.l 	MENUSCREEN_BITMAPBASE,a1
	move.l 	MENUSCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer2Joy

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

	move.b	#$ff,Player0Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.f4
.set0Joy
	move.b	#JoystickControl,Player0Enabled
	move.l 	MENUSCREEN_BITMAPBASE,a1
	move.l 	MENUSCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer0Joy

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
	beq.s	.set3Keys

	move.b	#$ff,Player3Enabled
	bsr	MenuClearBat
	bsr	DisableMenuBat
	bra.s	.exit

.set3Keys
	move.b	#KeyboardControl,Player3Enabled
	bsr	MenuDrawPlayer3Keys
	bra.s	.exit
.set3Joy
	move.b	#JoystickControl,Player3Enabled
	move.l 	MENUSCREEN_BITMAPBASE,a1
	move.l 	MENUSCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer3Joy

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

MenuPlayerUpdates:
	tst.b	Player0Enabled
	bmi.s	.player1
	beq.s	.joy1

	move.w	#KEY_UP,d0
	move.w	#KEY_DOWN,d1
	bsr	detectUpDown
	bra.s	.updatePlayer0
.joy1
	lea	CUSTOM+JOY1DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer0
	cmpi.b	#JOY_NOTHING,d3
	beq.s	.clearPlayer0UD

.0up	btst.l	#JOY_UP_BIT,d3
	bne.s	.0down
	bsr	MenuDrawPlayer0UpArrow
	bra.s	.player1
.0down	bsr	MenuDrawPlayer0DownArrow
	bra.s	.player1
.clearPlayer0UD
	bsr	MenuDrawPlayer0ClearArrows

.player1
	tst.b	Player1Enabled
	bmi.s	.player2
	beq.s	.joy0

	move.w	#Player1KeyUp,d0
	move.w	#Player1KeyDown,d1
	bsr	detectUpDown
	bra.s	.updatePlayer1

.joy0
	lea	CUSTOM+JOY0DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer1
	cmpi.b	#JOY_NOTHING,d3
	beq.s	.clearPlayer1UD

.1up	btst.l	#JOY_UP_BIT,d3
	bne.s	.1down
	bsr	MenuDrawPlayer1UpArrow
	bra.s	.player2
.1down	bsr	MenuDrawPlayer1DownArrow
	bra.s	.player2
.clearPlayer1UD
	bsr	MenuDrawPlayer1ClearArrows

.player2
	tst.b	Player2Enabled
	bmi.s	.player3
	beq.s	.joy2

	move.w	#Player2KeyLeft,d0
	move.w	#Player2KeyRight,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer2

.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2
	and.b	#$0f,d3

.2left	btst.l	#JOY_LEFT_BIT,d3
	bne.s	.2rite
	bsr	MenuDrawPlayer2LeftArrow
	bra.s	.player3
.2rite	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.clearPlayer2LR
	bsr	MenuDrawPlayer2RightArrow
	bra.s	.player3
.clearPlayer2LR
	bsr	MenuDrawPlayer2ClearArrows

.player3
	tst.b	Player3Enabled
	bmi.s	.exit
	beq.s	.joy3

	move.w	#Player3KeyLeft,d0
	move.w	#Player3KeyRight,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer3
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3
	lsr.b	#4,d3
.updatePlayer3
	and.b	#$0f,d3

.3left	btst.l	#JOY_LEFT_BIT,d3
	bne.s	.3rite
	bsr	MenuDrawPlayer3LeftArrow
	bra.s	.exit
.3rite	btst.l	#JOY_RIGHT_BIT,d3
	bne.s	.clearPlayer3LR
	bsr	MenuDrawPlayer3RightArrow
	bra.s	.exit
.clearPlayer3LR
	bsr	MenuDrawPlayer3ClearArrows

.exit
	rts


; Out:	d0.l = Zero if firebutton pressed, JOY_NOTHING if not.
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
	lea	Ball0,a0
	bsr     SetBallColor

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