ShopItemVerticalModulo		equ	ScrBpl-4
ShopItemHorizontalModulo	equ	ScrBpl-10
ShopItemVerticalBlitsize	equ	(64*7*4)+2
ShopItemHorizontalBlitsize	equ	(64*7*4)+5
ShopTextheight			equ	ScrBpl*7*4

ShopHorizontalOffset:		dc.l	0
ShopVerticalOffset:		dc.l	0


; Initializes things
InitShop:

	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*88*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(88+69)*4),d1

        lea	ShopAnimMap,a0

	moveq	#9,d7
.loop1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop1

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(88+23)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(88+69+23)*4),d1

	moveq	#9,d7
.loop2
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop2

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(88+46)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(88+46)*4)+20,d1

	moveq	#4,d7
.loop3
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop3

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*16*4)+24,d0
	lea	AnderBob,a0
	move.l	d0,hSprBobMaskAddress(a0)

	addi.l 	#(ScrBpl*24*4),d0
	move.l	d0,hAddress(a0)

        rts


SinShopCount:	dc.w	17
SinShop:
	dc.w 	0,0,-1,-1,-1,-1,-1,-1,0,0,1,1,1,1,1,1
	dc.w 	0,0
CosinShop:
	dc.w 	-1,-1,-1,0,0,0,1,1,1,1,1,1,0,0,0,-1
	dc.w 	-1,-1
; Moves the shop around
ShopUpdates:
        tst.b   IsShopOpenForBusiness
        bmi.s   .exit
	btst	#1,FrameTick
	beq.s	.exit

	lea	ShopBob,a0
	move.w	SinShopCount,d0
	add.w	d0,d0

	lea	(SinShop,pc,d0),a1
	move.l	#CosinShop,a2
	add.w	d0,a2

	move.w	(a2),d7
	beq.s	.sin

	add.w	d7,hSprBobTopLeftYPos(a0)
	add.w	d7,hSprBobBottomRightYPos(a0)
.sin
	move.w	(a1),d7
	beq.s	.checkCounter

	add.w	d7,hSprBobTopLeftXPos(a0)
	add.w	d7,hSprBobBottomRightXPos(a0)

.checkCounter
	tst.w	SinShopCount
	bne.s	.sub
	move.w	#17,SinShopCount
	bra.s	.exit
.sub
	subq.w	#1,SinShopCount
.exit
	rts

; Create a shop pool of available items for this ball-owner
; In:   a0 = address to ball structure
CreateShopPool:
	move.l	a0,-(sp)
	lea	ShopPool,a4

.clearLoop
	move.l	(a4),d0
	beq.s	.fillPool

	clr.l	(a4)+
	bra.s	.clearLoop

.fillPool
	move.l	hPlayerBat(a0),a0
	lea	ShopItems,a4
	lea	ShopPool,a5
.fillLoop
	tst.l	(a4)
	beq.s	.exit

	move.l	(a4),a2
	move.l	hItemValidFunction(a2),a2
	jsr	(a2)

	tst.b	d0
	bmi.s	.nextItem
	move.l	(a4)+,(a5)+
	bra.s	.fillLoop

.nextItem
	addq.l	#4,a4
	bra.s	.fillLoop
.exit
	move.l	(sp)+,a0
	rts

; Open shop for the ball-owner.
GoShopping:
	move.l	ShopCustomerBall,a0

        bsr     CreateShopPool
        bsr     EnterShop
        
        lea	ShopBob,a0                      ; Close the shop
	bsr	CopyRestoreFromBobPosToScreen
        move.b  #-1,IsShopOpenForBusiness
        bsr     MoveShop

	move.b	#RUNNING_STATE,GameState

	rts


; In:   a0 = address to ball structure
EnterShop:
	move.l	hPlayerBat(a0),a3

	lea	Bat0,a2
	cmpa.l	a2,a3
	bne.w	.bat1

.awaitPlayer0ReleaseFirebutton
	bsr	InShopAnimation
	bsr	CheckPlayer0Fire
	tst.b	d0
	beq.s	.awaitPlayer0ReleaseFirebutton

	bsr	EnterVerticalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat0,a0
	bsr 	CookieBlitToScreen

	clr.b	DirtyPlayer0Score
	bra.w	.checkout
.bat1
	lea	Bat1,a2
	cmpa.l	a2,a3
	bne.w	.bat2

.awaitPlayer1ReleaseFirebutton
	bsr	InShopAnimation
	bsr	CheckPlayer1Fire
	tst.b	d0
	beq.s	.awaitPlayer1ReleaseFirebutton

	bsr	EnterVerticalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat1,a0
	bsr 	CookieBlitToScreen

	clr.b	DirtyPlayer1Score
	bra.s	.checkout
.bat2
	lea	Bat2,a2
	cmpa.l	a2,a3
	bne.s	.bat3

.awaitPlayer2ReleaseFirebutton
	bsr	InShopAnimation
	bsr	CheckPlayer2Fire
	tst.b	d0
	beq.s	.awaitPlayer2ReleaseFirebutton

	bsr	EnterHorizontalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat2,a0
	bsr 	CookieBlitToScreen

	clr.b	DirtyPlayer2Score
	bra.s	.checkout
.bat3
.awaitPlayer3ReleaseFirebutton
	bsr	InShopAnimation
	bsr	CheckPlayer3Fire
	tst.b	d0
	beq.s	.awaitPlayer3ReleaseFirebutton

	bsr	EnterHorizontalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat3,a0
	bsr 	CookieBlitToScreen

	clr.b	DirtyPlayer3Score
.checkout
	tst.l	ShopSelectedItem
	beq.s	.exit
	move.l	ShopSelectedItem,a2
	jsr	(a2)

	lea	SFX_POWERUP_STRUCT,a0
	jsr     PlaySample
.exit
	rts

MoveShop:
	lea	ShopBob,a0
.tryGetNexPos
        move.l  ShopTopLeftPosPtr,a1
        move.l  (a1)+,d0
        bne.s   .setNextPos

        move.l  #ShopTopLeftPos,ShopTopLeftPosPtr
        bra.s   .tryGetNexPos
.setNextPos
        move.w  d0,hSprBobTopLeftYPos(a0)
        add.w   hSprBobHeight(a0),d0
        move.w  d0,hSprBobBottomRightYPos(a0)
        swap    d0
        move.w  d0,hSprBobTopLeftXPos(a0)
        add.w   hSprBobWidth(a0),d0
        move.w  d0,hSprBobBottomRightXPos(a0)

        move.l  a1,ShopTopLeftPosPtr

	rts

; In:   a3 = address to bat structure
EnterHorizontalShop:
	lea	Bat2,a0
	cmpa.l	a0,a3
	bne.s	.topOffset
	move.l	#(ScrBpl*(224-13)*4),ShopVerticalOffset
	lea	AnderBob,a0
	move.w	#63,hSprBobTopLeftXPos(a0)
	move.w	#63+31,hSprBobBottomRightXPos(a0)
	move.w	#211-13,hSprBobTopLeftYPos(a0)
	move.w	#211-13+24,hSprBobBottomRightYPos(a0)
	bra.s	.draw
.topOffset
	move.l	#(ScrBpl*13*4),ShopVerticalOffset
	lea	AnderBob,a0
	move.w	#63,hSprBobTopLeftXPos(a0)
	move.w	#63+31,hSprBobBottomRightXPos(a0)
	clr.w	hSprBobTopLeftYPos(a0)
	move.w	#0+24,hSprBobBottomRightYPos(a0)

.draw
        move.l  GAMESCREEN_BITMAPBASE,a0
        addq.l 	#8,a0
	add.l	ShopVerticalOffset,a0
	moveq	#ScrBpl-24,d1
	move.w	#(64*32*4)+12,d2
        bsr     ClearBlitWords			; Clear GAMESCREEN for horiz bat

        move.l  GAMESCREEN_BITMAPBASE,a2	; Draw strings
        add.l 	#(ScrBpl*1*4)+12,a2
	add.l	ShopVerticalOffset,a2
	bsr 	PlotShopDealString

	bsr	GetRandomShopItem
	move.l	hItemFunction(a4),ShopItemA

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(12+2)*4)+8,a2
	add.l	ShopVerticalOffset,a2
	bsr	PlotShopHorizontalItemText

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(12+6)*4)+18,a2
	add.l	ShopVerticalOffset,a2
	bsr	PlotShopExitString

	bsr	GetRandomShopItem
	move.l	hItemFunction(a4),ShopItemB

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(12+2)*4)+22,a2
	add.l	ShopVerticalOffset,a2
	bsr	PlotShopHorizontalItemText

	move.l  GAMESCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#ScrBpl+ScrBpl+ScrBpl+8,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-24,d1
	move.w	#(64*11*1)+12,d2
	bsr	FillBoxBlit			; DEAL?

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+8,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-24,d1
	move.w	#(64*20*1)+12,d2
	bsr	FillBoxBlit			; Items area fill

	lea	AnderBob,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen

	bsr	ShopLoop

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0	; Restore gamescreen
	addq.l	#8,a0
	add.l	ShopVerticalOffset,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	addq.l	#8,a1
	add.l	ShopVerticalOffset,a1
	moveq	#ScrBpl-24,d1
	move.w	#(64*32*4)+12,d2
        bsr	CopyRestoreGamearea

	lea	AnderBob,a0
	bsr	CopyRestoreFromBobPosToScreen

	rts

; In:   a3 = address to bat structure
EnterVerticalShop:
	lea	Bat0,a0
	cmpa.l	a0,a3
	bne.s	.leftOffset
	move.l	#34,ShopHorizontalOffset
	lea	AnderBob,a0
	move.w	#271,hSprBobTopLeftXPos(a0)
	move.w	#271+31,hSprBobBottomRightXPos(a0)
	move.w	#43,hSprBobTopLeftYPos(a0)
	move.w	#43+24,hSprBobBottomRightYPos(a0)
	bra.s	.draw
.leftOffset
	move.l	#2,ShopHorizontalOffset
	lea	AnderBob,a0
	move.w	#15,hSprBobTopLeftXPos(a0)
	move.w	#15+31,hSprBobBottomRightXPos(a0)
	move.w	#43,hSprBobTopLeftYPos(a0)
	move.w	#43+24,hSprBobBottomRightYPos(a0)
.draw
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*48*4),a0
	add.l	ShopHorizontalOffset,a0
	moveq	#ShopItemVerticalModulo,d1
	move.w	#(64*148*4)+2,d2
        bsr     ClearBlitWords			; Clear GAMESCREEN for vert bat

        move.l  GAMESCREEN_BITMAPBASE,a2	; Draw strings
        add.l 	#(ScrBpl*67*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr 	PlotShopDealString

	bsr	GetRandomShopItem
	move.l	hItemFunction(a4),ShopItemA

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*82*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr	PlotShopVerticalItemText

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(124+8)*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr	PlotShopExitString

	bsr	GetRandomShopItem
	move.l	hItemFunction(a4),ShopItemB

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*150*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr	PlotShopVerticalItemText

	move.l  GAMESCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*60*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*16*1)+2,d2
	bsr	FillBoxBlit			; DEAL?

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*77*4)+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*119*1)+2,d2
	bsr	FillBoxBlit			; Items area fill

	lea	AnderBob,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen

	bsr	ShopLoop

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0	; Restore gamescreen
	add.l   #(ScrBpl*48*4),a0
	add.l	ShopHorizontalOffset,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*48*4),a1
	add.l	ShopHorizontalOffset,a1
	moveq	#ShopItemVerticalModulo,d1
	move.w	#(64*148*4)+2,d2
        bsr	CopyRestoreGamearea

	lea	AnderBob,a0
	bsr	CopyRestoreFromBobPosToScreen

	rts



; In:   a3 = address to bat structure
ShopLoop:

.shop
	lea	Bat0,a0
	cmpa.l	a0,a3
	bne.s	.bat1

	tst.b	Player0Enabled
	bmi.s	.bat1

	lea	CUSTOM+JOY1DAT,a5
	jsr	agdJoyDetectMovement
	bsr	UpdateVerticalShopChoice

	bsr	CheckPlayer0Fire
	tst.b	d0
	bne.w	.anim
	beq.w	.exit

.bat1
	lea	Bat1,a2
	cmpa.l	a3,a2
	bne.s	.bat2

	tst.b	Player1Enabled		; What controls are used?
	beq.s	.joy0

	move.w	#Player1KeyUp,d0
	move.w	#Player1KeyDown,d1
	jsr	DetectUpDown
	bra.s	.updatePlayer1Shop
.joy0
	lea	CUSTOM+JOY0DAT,a5
	jsr	agdJoyDetectMovement
.updatePlayer1Shop
	bsr	UpdateVerticalShopChoice

	bsr	CheckPlayer1Fire
	tst.b	d0
	bne.s	.anim
	beq.w	.exit
.bat2
	lea	Bat2,a2
	cmpa.l	a3,a2
	bne.s	.bat3

	tst.b	Player2Enabled		; What controls are used?
	beq.s	.joy2

	move.w	#Player2KeyLeft,d0
	move.w	#Player2KeyRight,d1
	jsr	DetectLeftRight
	bra.s	.updatePlayer2Shop
.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3		; Unlike Joy0/1 these bits need no decoding
.updatePlayer2Shop
	bsr	UpdateHorizontalShopChoice

	bsr	CheckPlayer2Fire
	tst.b	d0
	bne.s	.anim
	beq.s	.exit

.bat3
	tst.b	Player3Enabled		; What controls are used?
	beq.s	.joy3

	move.w	#Player3KeyLeft,d0
	move.w	#Player3KeyRight,d1
	jsr	DetectLeftRight
	bra.s	.updatePlayer3Shop
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3		; Unlike Joy0/1 these bits need no decoding
	lsr.b	#4,d3
.updatePlayer3Shop
	bsr	UpdateHorizontalShopChoice

	bsr	CheckPlayer3Fire
	tst.b	d0
	beq.s	.exit

.anim
	bsr	InShopAnimation

	bra.w	.shop

.exit
	rts

; In:	d3.b = directionBits for UP or DOWN
UpdateVerticalShopChoice:
	cmp.b	ShopPreviousDirectionalBits,d3
	beq.w	.done

	move.l  GAMESCREEN_BITMAPBASE,a0	; Clear bitplane
	add.l 	#(ScrBpl*77*4)+ScrBpl+ScrBpl+ScrBpl,a0
	add.l	ShopHorizontalOffset,a0
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*131*1)+2,d2
	bsr	ClearBlitWords

	cmpi.b	#JOY_UP,d3			; Check direction
	bne.s	.checkDown

	move.l	ShopItemA,ShopSelectedItem

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*77*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*51*1)+2,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.checkDown
	cmpi.b	#JOY_DOWN,d3
	bne.s	.nothing

	move.l	ShopItemB,ShopSelectedItem

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*(120+8+16)*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*52*1)+2,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.nothing
	clr.l	ShopSelectedItem

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*(120+8)*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*16*1)+2,d2
	bsr	FillBoxBlit

.setPreviousDirectionalBits
	move.b	d3,ShopPreviousDirectionalBits
	lea	SFX_SELECT_STRUCT,a0
	jsr     PlaySample
.done
	rts

; In:	d3.b = directionBits for UP or DOWN
UpdateHorizontalShopChoice:
	move.b	d3,d7				; Isolate the nibble
	and.b	#$0f,d7

	cmp.b	ShopPreviousDirectionalBits,d7
	beq.w	.done

	move.l  GAMESCREEN_BITMAPBASE,a0	; Clear bitplane
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+8,a0
	add.l	ShopVerticalOffset,a0
	move.w	#(4*ScrBpl)-24,d1
	move.w	#(64*20*1)+12,d2
	bsr	ClearBlitWords

	btst.l	#JOY_LEFT_BIT,d7		; Check direction
	bne.s	.checkRight

	move.l	ShopItemA,ShopSelectedItem

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+8,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*20*1)+5,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.checkRight
	btst.l	#JOY_RIGHT_BIT,d7
	bne.s	.nothing

	move.l	ShopItemB,ShopSelectedItem

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+8+10+4,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-10,d1
	move.w	#(64*20*1)+5,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.nothing
	clr.l	ShopSelectedItem

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+8+10,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*20*1)+2,d2
	bsr	FillBoxBlit

.setPreviousDirectionalBits
	move.b	d7,ShopPreviousDirectionalBits
	lea	SFX_SELECT_STRUCT,a0
	jsr     PlaySample
.done
	rts

; In:	a2 = destination on screen
PlotShopDealString:
        lea     DEAL_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.w  #ShopItemVerticalModulo,d5
        move.w  #ShopItemVerticalBlitsize,d6
        bsr     DrawStringBuffer

	rts

PlotShopExitString:
        lea     EXIT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.w  #ShopItemVerticalModulo,d5
        move.w  #ShopItemVerticalBlitsize,d6
        bsr     DrawStringBuffer

	rts

; In:	a4 = adress to shop item
; In:	a2 = destination on screen
PlotShopVerticalItemText:
        move.w  #ShopItemVerticalModulo,d5
        move.w  #ShopItemVerticalBlitsize,d6

	lea     (hItemDescription0,a4),a0

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
	bsr     DrawStringBuffer

	add.l	#ShopTextheight,a2

	lea     (hItemDescription1,a4),a0
	tst.b	(a0)
	beq.s	.itemValue0

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
	bsr     DrawStringBuffer
.itemValue0
	add.l	#ShopTextheight,a2
	add.l	#ShopTextheight,a2

	moveq	#0,d0
	lea     (hItemValue0,a4),a0
	move.l	(a0),d0

	lea     STRINGBUFFER,a1
	SIGNEDTOSTR a0,a1
	bsr     DrawStringBuffer
.itemValue1
	add.l	#ShopTextheight,a2

	lea     (hItemValue1,a4),a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
	bsr     DrawStringBuffer
.exit
	rts

; In:	a4 = adress to shop item
; In:	a2 = destination on screen
PlotShopHorizontalItemText:
        move.w  #ShopItemHorizontalModulo,d5
        move.w  #ShopItemHorizontalBlitsize,d6

	lea     (hItemDescription0,a4),a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

	lea     (hItemDescription1,a4),a0
	tst.b	(a0)
	beq.s	.plotDescription

	move.b	#" ",-1(a1)
        COPYSTR a0,a1
.plotDescription
	bsr     DrawStringBuffer

	add.l	#ShopTextheight,a2

	moveq	#0,d0
	lea     (hItemValue0,a4),a0
	move.l	(a0),d0

	lea     STRINGBUFFER,a1
	SIGNEDTOSTR a0,a1
	move.b	#" ",-1(a1)
	lea     (hItemValue1,a4),a0
        COPYSTR a0,a1

	bsr     DrawStringBuffer
.exit
	rts


; Out:	d0.b = $FF when false, 0 when true
CanShopExtraPoints:
	moveq	#0,d0
	rts
; In:	a0 = adress to bat
ShopExtraPoints:
	move.l	hPlayerScore(a0),a1		; Update score
        add.l	#1200,(a1)
	rts

; In:	a0 = adress to bat
; Out:	d0.b = $FF when false, 0 when true
CanShopExtraBall:
	move.l	hPlayerScore(a0),a1
	cmpi.l	#1500,(a1)
	blo.s	.tooExpensive
	moveq	#0,d0
	bra.s	.exit
.tooExpensive
	moveq	#-1,d0
.exit
	rts

; In:	a0 = adress to bat
ShopExtraBall:
	move.l	hPlayerScore(a0),a1		; Update score
        sub.l	#1500,(a1)
	addq.b  #1,BallsLeft
	bsr	DrawAvailableBalls

	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer0:
	lea	Bat0,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a6
	move.l	hItemValue0(a6),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer0:
	lea	ItemStealFromPlayer0,a2
	move.l	hItemValue0(a2),d0

	lea	Bat0,a1
	move.l	hPlayerScore(a1),a1		; Take score
        sub.l	d0,(a1)
	clr.b	DirtyPlayer0Score

	move.l	hPlayerScore(a0),a1		; Give score
        add.l	d0,(a1)

	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer1:
	lea	Bat1,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a6
	move.l	hItemValue0(a6),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer1:
	lea	ItemStealFromPlayer1,a2
	move.l	hItemValue0(a2),d0

	lea	Bat1,a1
	move.l	hPlayerScore(a1),a1		; Take score
        sub.l	d0,(a1)
	clr.b	DirtyPlayer1Score

	move.l	hPlayerScore(a0),a1		; Give score
        add.l	d0,(a1)

	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer2:
	lea	Bat2,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a6
	move.l	hItemValue0(a6),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer2:
	lea	ItemStealFromPlayer2,a2
	move.l	hItemValue0(a2),d0

	lea	Bat2,a1
	move.l	hPlayerScore(a1),a1		; Take score
        sub.l	d0,(a1)
	clr.b	DirtyPlayer2Score

	move.l	hPlayerScore(a0),a1		; Give score
        add.l	d0,(a1)

	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer3:
	lea	Bat3,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a6
	move.l	hItemValue0(a6),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer3:
	lea	ItemStealFromPlayer3,a2
	move.l	hItemValue0(a2),d0

	lea	Bat3,a1
	move.l	hPlayerScore(a1),a1		; Take score
        sub.l	d0,(a1)
	clr.b	DirtyPlayer3Score

	move.l	hPlayerScore(a0),a1		; Give score
        add.l	d0,(a1)

	rts

; Pick a random item from the shop pool
; Out:	a4: adress to random shop item
GetRandomShopItem:
	lea	ShopPool,a4

	moveq	#0,d0
	jsr	RndB
	and.w	#$000f,d0
.loopitem
	tst.l	(a4)+
	beq.s	.startOver
	bne.s	.next
.startOver
	lea	ShopPool,a4
.next
	dbf	d0,.loopitem

	tst.l	(a4)
	bne.s	.getItem
	subq.l	#4,a4
.getItem
	move.l	(a4),a4

	rts

InShopAnimation:
	WAITLASTLINE d0

	move.l	a3,-(sp)

	lea	ShopBob,a0
	bsr	CopyRestoreFromBobPosToScreen
	bsr	BobAnim

	move.l	(sp)+,a3
	rts