
	include	's/credits.asm'

; First-time initialization of main menu.
InitMainMenu:
	lea	Bat0,a1
	bsr	EnableMenuBat
	bsr	MenuDrawMakers
	bsr	MenuDrawVersion
	bsr	AddMenuCopper

	; Default to joystick controls and player 0
	move.b	#JoystickControl,Player0Enabled
	bsr	MenuDrawPlayer0Joy

	bsr	ResetPlayers
	rts

MainMenu:
	move.l	COPPTR_MENU,a1
	jsr	LoadCopper


	bsr	SetMenuBall0CopperPtr
	bsr	ResetBalls
	bsr	MoveBall0ToOwner

	move.l	HDL_MUSICMOD_1,a0
        jsr	PlayTune

	move.b	#ATTRACT_ON,AttractState
	move.b	#MENU_ATTRACT_SEC,AttractCount

	bsr	DrawMenuBats
	bsr	MenuDrawBallspeed
	bsr	MenuDrawRampup
	bsr	MenuDrawCredits
.drawMenuMiscText
	bsr	MenuClearControlsText
	bsr	MenuDrawControlsText

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
	
	bsr	CheckPlayerSelectionKeys
	bsr	CheckCreditsKey
	bsr	CheckBallspeedKey
	bsr	CheckBallspeedIncreaseKey

	bsr	UpdateMenuCopper
	bsr	DrawSprites
	bsr	MenuPlayerUpdates
	bsr	CheckFirebuttons
	tst.b	d0
	bne.w	.loop

	bra.s	.startGame

.confirmExit
	bsr	MenuClearControlsText

	lea     QUIT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*164*4)+16,a2
        moveq	#ScrBpl-10,d5
        move.w  #(64*8*4)+5,d6
        bsr     DrawStringBuffer
.confirmExitLoop
	tst.b	KEYARRAY+KEY_Y		; Exit game
	bne.s	.setExit
	tst.b	KEYARRAY+KEY_N		; Stay
	bne.w	.drawMenuMiscText
	bra.s	.confirmExitLoop
.setExit
	moveq	#-1,d0
	bra	.exit
.startGame
	move.b	#-1,AttractCount
	move.b	#ATTRACT_OFF,AttractState
	bsr	MenuClearControlsText

	move.l	COPPTR_MENU,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
	move.l  a0,-(sp)
	jsr	GfxAndMusicFadeOut
	move.l  (sp)+,a0
	jsr	ResetFadePalette
.exit
	rts

NextAttract:
	move.l	AttractTablePtr,a0

	move.l	Spr_Ball0,-(sp)			; Preserve ball status
	clr.l	Spr_Ball0			; Disarm ball sprite

	move.l	a0,-(sp)
	bsr	SimpleFadeOutMenu
	move.l	(sp)+,a0

	move.l	(a0),a0
	jsr	(a0)

	move.l	(sp)+,Spr_Ball0			; Re-arm ball sprite

	move.l	COPPTR_MENU,a1			; Return to menu screen
	move.l  a1,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
	jsr	ResetFadePalette
	jsr	LoadCopper

	move.l	AttractTablePtr,a0		; Update pointer
	addq.l	#4,a0

	cmpa.l	#AttractTableEnd,a0
	bne	.setPtr
	move.l	#AttractTable,a0
.setPtr
	move.l	a0,AttractTablePtr

	move.b	#MENU_ATTRACT_SEC,AttractCount
	rts

; Blits active player bats to menu screen.
DrawMenuBats:
	movem.l	a3-a6,-(sp)

	move.l	MENUSCREEN_BITMAPBASE,a4
	move.l	MENUSCREEN_BITMAPBASE,a5
	lea	CUSTOM,a6

	tst.b	Player3Enabled
	bmi.s	.isPlayer2Enabled

	lea	Bat3,a3
	bsr	CookieBlitToScreen

.isPlayer2Enabled
	tst.b	Player2Enabled
	bmi.s	.isPlayer1Enabled

	lea	Bat2,a3
	bsr	CookieBlitToScreen

.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.isPlayer0Enabled

	lea	Bat1,a3
	bsr	CookieBlitToScreen

.isPlayer0Enabled
	tst.b	Player0Enabled
	bmi.s	.exit

	lea	Bat0,a3
	bsr	CookieBlitToScreen
.exit
	movem.l	(sp)+,a3-a6
	rts


CheckCreditsKey:
	tst.b	KEYARRAY+KEY_F8
	beq	.exit
	clr.b	KEYARRAY+KEY_F8		; Clear the KeyDown

	move.l	Spr_Ball0,d0		; Preserve ball status
	move.l	d0,-(sp)
	clr.l	Spr_Ball0		; Disarm ball sprite

	bsr	SimpleFadeOutMenu

	bsr	ShowCredits

        move.l  a5,a0
        bsr	ResetFadePalette

	move.l	(sp)+,d0
	move.l	d0,Spr_Ball0
.exit
	rts

CheckBallspeedKey:
	tst.b	KEYARRAY+KEY_F5
	beq	.exit
	; clr.b	KEYARRAY+KEY_F5		; Clear the KeyDown

	move.b	#ATTRACT_OFF,AttractState
	cmp.w	#USERMAX_BALLSPEED,BallspeedBase
	blo.s	.ok
	move.w	#MIN_BALLSPEED,BallspeedBase
.ok
	addq.w	#1,BallspeedBase
	bsr	MenuDrawBallspeed
.exit
	rts

CheckBallspeedIncreaseKey:
	tst.b	KEYARRAY+KEY_F6
	beq	.exit
	; clr.b	KEYARRAY+KEY_F6		; Clear the KeyDown

	move.b	#ATTRACT_OFF,AttractState
	cmp.b	#MAX_RAMPUP,BallspeedFrameCount
	blo.s	.ok
	move.b	#MIN_RAMPUP,BallspeedFrameCount
	subq.b	#1,BallspeedFrameCount
.ok
	addq.b	#1,BallspeedFrameCount

	bsr	MenuDrawRampup
.exit
	rts

; Player selection routine for F1-F4 keys.
CheckPlayerSelectionKeys:
	movem.l	d2/a3-a6,-(sp)

	move.l	KEYARRAY+KEY_F1,d2

	move.l	MENUSCREEN_BITMAPBASE,a4
	move.l	MENUSCREEN_BITMAPBASE,a5
	lea	CUSTOM,a6

.f1
	tst.b	KEYARRAY+KEY_F1
	beq	.f2
	clr.b	KEYARRAY+KEY_F1		; Clear the KeyDown
	move.b	#ATTRACT_OFF,AttractState

	bsr	MenuClearPlayer1Text
	lea	Bat1,a3

	tst.b	Player1Enabled
	bmi.s	.set1Joy
	beq.s	.set1keys

	move.b	#$ff,Player1Enabled
	bsr	ClearBlitToScreen
	bsr	DisableMenuBat
	bra.s	.f2

.set1keys
	move.b	#KeyboardControl,Player1Enabled
	bsr	MenuDrawPlayer1Keys
	bra.s	.f2
.set1Joy
	move.b	#JoystickControl,Player1Enabled
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer1Joy

	lea	Bat1,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.f2
	tst.b	KEYARRAY+KEY_F2
	beq	.f3
	clr.b	KEYARRAY+KEY_F2
	move.b	#ATTRACT_OFF,AttractState

	bsr	MenuClearPlayer2Text
	lea	Bat2,a3

	tst.b	Player2Enabled
	bmi.s	.set2Joy
	beq.s	.set2Keys

	move.b	#$ff,Player2Enabled
	bsr	ClearBlitToScreen
	bsr	DisableMenuBat
	bra.s	.f3

.set2Keys
	move.b	#KeyboardControl,Player2Enabled
	bsr	MenuDrawPlayer2Keys
	bra.s	.f3
.set2Joy
	move.b	#JoystickControl,Player2Enabled
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer2Joy

	lea	Bat2,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.f3
	tst.b	KEYARRAY+KEY_F3
	beq	.f4
	clr.b	KEYARRAY+KEY_F3
	move.b	#ATTRACT_OFF,AttractState

	bsr	MenuClearPlayer0Text
	lea	Bat0,a3

	tst.b	Player0Enabled
	bmi.s	.set0Joy

	move.b	#$ff,Player0Enabled
	bsr	ClearBlitToScreen
	bsr	DisableMenuBat
	bra.s	.f4
.set0Joy
	move.b	#JoystickControl,Player0Enabled
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer0Joy

	lea	Bat0,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.f4
	tst.b	KEYARRAY+KEY_F4
	beq	.exit
	clr.b	KEYARRAY+KEY_F4
	move.b	#ATTRACT_OFF,AttractState

	bsr	MenuClearPlayer3Text
	lea	Bat3,a3

	tst.b	Player3Enabled
	bmi.s	.set3Joy
	beq.s	.set3Keys

	move.b	#$ff,Player3Enabled
	bsr	ClearBlitToScreen
	bsr	DisableMenuBat
	bra.s	.exit

.set3Keys
	move.b	#KeyboardControl,Player3Enabled
	bsr	MenuDrawPlayer3Keys
	bra.s	.exit
.set3Joy
	move.b	#JoystickControl,Player3Enabled
	bsr	CookieBlitToScreen
	bsr	MenuDrawPlayer3Joy

	lea	Bat3,a1
	bsr	EnableMenuBat
	bsr	MoveBall0ToOwner

.exit
	tst.l	d2
	beq	.done
	bsr	SetPlayerCount
	bsr	SetAdjustedBallspeed
.done
	movem.l	(sp)+,d2/a3-a6
	rts


MenuPlayerUpdates:
	tst.b	Player0Enabled
	bmi.s	.player1
	beq.s	.joy1

	move.w	#KEY_UP,d0
	move.w	#KEY_DOWN,d1
	bsr	DetectUpDown
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
	bsr	DetectUpDown
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
	bsr	DetectLeftRight
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
	bsr	DetectLeftRight
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


; In:	a1 = address to bat to enable in menu.
EnableMenuBat:
	lea	Ball0,a0
	bsr     SetBallColor

	move.l	a1,hPlayerBat(a0)
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
	clr.l	Spr_Ball0		; No player enabled - disarm ball sprite
.exit
	rts

SimpleFadeOutMenu:
        move.l	COPPTR_MENU,a5
        move.l	hAddress(a5),a5
	lea	hColor00(a5),a5
        move.l  a5,a0
        bsr     SimpleFadeOut

	rts

AddMenuCopper:
	move.l 	END_COPPTR_MENU,a1

	moveq	#47,d0
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
.finalize
	move.l	#COPPERLIST_END,(a1)

	rts

; 
UpdateMenuCopper:
	move.l 	END_COPPTR_MENU,a1

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


; Copy ESC button graphixs to destination bitmapbase
; In:   a1 = Destination bitmapbase
CopyEscGfx:
	move.l	d2,-(sp)

	move.l 	MENUSCREEN_BITMAPBASE,a0        ; Copy gfx for ESC button
	add.l   #(ScrBpl*3*4),a0

	add.l   #(ScrBpl*3*4),a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*12*4)+2,d2
        move.l  #$fffff000,d0
	bsr	CopyBlit

	move.l	(sp)+,d2
	rts

MenuToggleFireToStart:
	btst	#0,AttractTick
	bne	.off
	bsr	MenuDrawFireToStartText
	bra	.done
.off
	bsr	MenuClearFireToStartText
.done
	rts