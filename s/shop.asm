; Initializes things
InitShop:
	move.l	d7,-(sp)

	move.l	BobsBitmapbasePtr(a5),d0	; Init animation frames
	addi.l	#(RL_SIZE*88*4),d0
	move.l	BobsBitmapbasePtr(a5),d1
	addi.l	#(RL_SIZE*(88+69)*4),d1

	lea		ShopAnimMap,a0

	moveq	#9,d7
.loop1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf		d7,.loop1

	move.l	BobsBitmapbasePtr(a5),d0
	addi.l	#(RL_SIZE*(88+23)*4),d0
	move.l	BobsBitmapbasePtr(a5),d1
	addi.l 	#(RL_SIZE*(88+69+23)*4),d1

	moveq	#9,d7
.loop2
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf		d7,.loop2

	move.l	BobsBitmapbasePtr(a5),d0
	addi.l	#(RL_SIZE*(88+46)*4),d0
	move.l	BobsBitmapbasePtr(a5),d1
	addi.l 	#(RL_SIZE*(88+46)*4)+20,d1

	moveq	#4,d7
.loop3
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf		d7,.loop3

	move.l	BobsBitmapbasePtr(a5),d0
	addi.l	#(RL_SIZE*14*4)+20,d0

	lea		MonBob,a0
	lea		AnderBob,a1
	move.l	d0,hSprBobMaskAddress(a0)	; Same full mask
	move.l	d0,hSprBobMaskAddress(a1)

	addi.l	#(RL_SIZE*25*4),d0
	move.l	d0,hAddress(a0)
	add.l	#4,d0
	move.l	d0,hAddress(a1)

	move.l	(sp)+,d7
	rts


SinShopCount:	dc.w	17
SinShop:
	dc.w 	0,0,-1,-1,-1,-1,-1,-1,0,0,1,1,1,1,1,1
	dc.w	0,0
CosinShop:
	dc.w 	-1,-1,-1,0,0,0,1,1,1,1,1,1,0,0,0,-1
	dc.w	-1,-1

; Moves the shop around
ShopUpdates:
	move.b	FrameTick(a5),d0
	and.b	#3,d0					; Updates every 4th frame
	bne		.fastExit

	movem.l	d7/a2,-(sp)

	lea		ShopBob,a0
	move.w	SinShopCount,d0
	add.w	d0,d0

	lea		(SinShop,pc,d0),a1
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
	movem.l	(sp)+,d7/a2
.fastExit
	rts

; Create a shop pool of available items for this ball-owner
; In:   a0 = address to ball structure
CreateShopPool:
	movem.l	a2-a4,-(sp)

	lea		ShopPool,a4

.clearLoop
	move.l	(a4),d0
	beq.s	.fillPool

	clr.l	(a4)+
	bra.s	.clearLoop

.fillPool
	move.l	hPlayerBat(a0),a0
	lea		ShopItems,a4
	lea		ShopPool,a2
.fillLoop
	tst.l	(a4)
	beq.s	.exit

	move.l	(a4),a3
	move.l	hItemValidFunction(a3),a3
	jsr		(a3)					; Function require bat address in a0

	tst.b	d0
	bmi.s	.nextItem
	move.l	(a4)+,(a2)+
	bra.s	.fillLoop

.nextItem
	addq.l	#4,a4
	bra.s	.fillLoop
.exit
	movem.l	(sp)+,a2-a4
	rts

; Open shop for the ball-owner.
; In:	a6 = address to CUSTOM $dff000
GoShopping:
	clr.b	Paused(a5)

	move.l	ShopCustomerBall(a5),a0

	move.l	a0,-(sp)
	bsr		CreateShopPool
	move.l	(sp)+,a0
	bsr		EnterShop
	
	lea		ShopBob,a0				; Close the shop
	move.b	#2,IsShopOpenForBusiness(a5)	; Closing now...

	move.b	#-1,Paused(a5)
	move.b	#STATE_RUNNING,GameState(a5)
	rts


; In:   a0 = address to ball structure
; In:	a6 = address to CUSTOM $dff000
EnterShop:
	tst.b	UserIntentState(a5)
	bgt		.fastExit

	movem.l	a2-a4,-(sp)

	btst.b	#0,FrameTick(a5)
	beq		.mon
	move.l	#AnderBob,Shopkeep(a5)
	bra		.enter
.mon
	move.l	#MonBob,Shopkeep(a5)

.enter
	move.l	hPlayerBat(a0),a1
	lea		Bat0,a3
	cmpa.l	a3,a1
	bne.w	.bat1

.awaitPlayer0ReleaseFirebutton
	bsr		CheckPlayer0Fire
	tst.b	d0
	beq.s	.awaitPlayer0ReleaseFirebutton

	bsr		EnterVerticalShop
	; Retore bat
	lea		Bat0,a3
	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2
	bsr		CookieBlitToScreen

	clr.b	DirtyPlayer0Score(a5)
	bra.w	.checkout
.bat1
	IFD		ENABLE_DEBUG_PLAYERS
	bra		.exit
	ENDIF

	move.l	hPlayerBat(a0),a1
	lea		Bat1,a3
	cmpa.l	a3,a1
	bne.w	.bat2

.awaitPlayer1ReleaseFirebutton
	bsr		CheckPlayer1Fire
	tst.b	d0
	beq.s	.awaitPlayer1ReleaseFirebutton

	bsr		EnterVerticalShop
	; Retore bat
	lea		Bat1,a3
	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2
	bsr		CookieBlitToScreen

	clr.b	DirtyPlayer1Score(a5)
	bra.s	.checkout
.bat2
	IFD		ENABLE_DEBUG_PLAYERS
	bra		.exit
	ENDIF

	move.l	hPlayerBat(a0),a1
	lea		Bat2,a3
	cmpa.l	a3,a1
	bne.s	.bat3

.awaitPlayer2ReleaseFirebutton
	bsr		CheckPlayer2Fire
	tst.b	d0
	beq.s	.awaitPlayer2ReleaseFirebutton

	bsr		EnterHorizontalShop
	; Retore bat
	lea		Bat2,a3
	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2
	bsr		CookieBlitToScreen

	clr.b	DirtyPlayer2Score(a5)
	bra.s	.checkout
.bat3
.awaitPlayer3ReleaseFirebutton
	IFD		ENABLE_DEBUG_PLAYERS
	bra		.exit
	ENDIF
	lea		Bat3,a3

	bsr		CheckPlayer3Fire
	tst.b	d0
	beq.s	.awaitPlayer3ReleaseFirebutton

	bsr		EnterHorizontalShop
	; Retore bat
	lea		Bat3,a3
	move.l	GAMESCREEN_BackPtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2
	bsr		CookieBlitToScreen

	clr.b	DirtyPlayer3Score(a5)
.checkout
	tst.l	ShopSelectedItem(a5)
	beq.s	.exit
	move.l	ShopSelectedItem(a5),a2
	; Expected input:
	move.l	a3,a0					; a0 address to bat
	jsr		(a2)

	lea		SFX_POWERUP_STRUCT,a0
	jsr		PlaySample
.exit
	movem.l	(sp)+,a2-a4
.fastExit
	rts

; Move the shop around a bit
MoveShop:
	lea		ShopBob,a0
.tryGetNexPos
	move.l	ShopTopLeftPosPtr(a5),a1
	move.l	(a1)+,d0
	bne.s	.setNextPos

	move.l  #ShopTopLeftPos,ShopTopLeftPosPtr(a5)
	bra.s	.tryGetNexPos
.setNextPos
	move.w  d0,hSprBobTopLeftYPos(a0)
	add.w	hSprBobHeight(a0),d0
	move.w  d0,hSprBobBottomRightYPos(a0)
	swap	d0
	move.w  d0,hSprBobTopLeftXPos(a0)
	add.w	hSprBobWidth(a0),d0
	move.w  d0,hSprBobBottomRightXPos(a0)

	move.l	a1,ShopTopLeftPosPtr(a5)

	rts

; In:   a3 = address to bat structure
; In:	a6 = address to CUSTOM $dff000
EnterHorizontalShop:
	movem.l	d2/a2-a5,-(sp)

	move.l	GAMESCREEN_Ptr(a5),a4

	lea		Bat2,a0
	cmpa.l	a0,a3
	bne.s	.topOffset
	move.l	#(RL_SIZE*(224-13)*4),ShopVerticalOffset(a5)
	move.l	Shopkeep(a5),a0
	move.w	#64,hSprBobTopLeftXPos(a0)
	move.w	#64+32,hSprBobBottomRightXPos(a0)
	move.w	#211-15,hSprBobTopLeftYPos(a0)
	move.w	#211-15+25,hSprBobBottomRightYPos(a0)
	bra.s	.draw
.topOffset
	move.l	#(RL_SIZE*15*4),ShopVerticalOffset(a5)
	move.l	Shopkeep(a5),a0
	move.w	#64,hSprBobTopLeftXPos(a0)
	move.w	#64+32,hSprBobBottomRightXPos(a0)
	clr.w	hSprBobTopLeftYPos(a0)
	move.w	#0+25,hSprBobBottomRightYPos(a0)

.draw
	move.l	GAMESCREEN_Ptr(a5),a0
	addq.l	#8,a0
	add.l	ShopVerticalOffset(a5),a0
	moveq	#RL_SIZE-24,d0
	move.w	#(64*32*4)+12,d1
	bsr		ClearBlitWords			; Clear GAMESCREEN for horiz bat

	move.l	GAMESCREEN_Ptr(a5),a2	; Draw strings
	add.l	#(RL_SIZE*1*4)+12,a2
	add.l	ShopVerticalOffset(a5),a2
	bsr		PlotShopDealString

	bsr		GetRandomShopItem
	move.l	hItemFunction(a0),ShopItemA(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l	#(RL_SIZE*10*4)+8,a2
	add.l	ShopVerticalOffset(a5),a2
	bsr		PlotShopHorizontalItemText

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l	#(RL_SIZE*(10+7)*4)+18,a2
	add.l	ShopVerticalOffset(a5),a2
	bsr		PlotShopExitString

	bsr		GetRandomShopItem
	move.l	hItemFunction(a0),ShopItemB(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l	#(RL_SIZE*10*4)+22,a2
	add.l	ShopVerticalOffset(a5),a2
	bsr		PlotShopHorizontalItemText

	move.l	GAMESCREEN_Ptr(a5),a2	; Fill background
	add.l 	#RL_SIZE+RL_SIZE+RL_SIZE+8,a2
	add.l	ShopVerticalOffset(a5),a2
	move.w	#(4*RL_SIZE)-24,d1
	move.w	#(64*10*1)+12,d2
	bsr		FillBoxBlit				; DEAL?

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*11*4)+RL_SIZE+RL_SIZE+8,a2
	add.l	ShopVerticalOffset(a5),a2
	move.w	#(4*RL_SIZE)-24,d1
	move.w	#(64*21*1)+12,d2
	bsr		FillBoxBlit				; Items area fill

	move.l	Shopkeep(a5),a0
	exg		a0,a3
	move.l	GAMESCREEN_Ptr(a5),a4
	movea.l	a4,a2
	bsr		CookieBlitToScreen
	exg		a0,a3

	bsr		ShopLoop

	move.l 	GAMESCREEN_BackPtr(a5),a0	; Restore gamescreen
	addq.l	#8,a0
	add.l	ShopVerticalOffset(a5),a0
	move.l	GAMESCREEN_Ptr(a5),a1
	addq.l	#8,a1
	add.l	ShopVerticalOffset(a5),a1
	moveq	#RL_SIZE-24,d1
	move.w	#(64*32*4)+12,d2
	bsr		CopyRestoreGamearea

	move.l	Shopkeep(a5),a0
	bsr	CopyRestoreFromBobPosToScreen

	movem.l	(sp)+,d2/a2-a5
	rts

; In:   a3 = address to bat structure
; In:	a6 = address to CUSTOM $dff000
EnterVerticalShop:
	movem.l	d2/a2-a4,-(sp)

	move.l	GAMESCREEN_Ptr(a5),a4

	lea		Bat0,a0
	cmpa.l	a0,a3
	bne.s	.leftOffset
	move.l	#34,ShopHorizontalOffset(a5)
	move.l	Shopkeep(a5),a0
	move.w	#272,hSprBobTopLeftXPos(a0)
	move.w	#272+32,hSprBobBottomRightXPos(a0)
	move.w	#41,hSprBobTopLeftYPos(a0)
	move.w	#41+25,hSprBobBottomRightYPos(a0)
	bra.s	.draw
.leftOffset
	move.l	#2,ShopHorizontalOffset(a5)
	move.l	Shopkeep(a5),a0
	move.w	#16,hSprBobTopLeftXPos(a0)
	move.w	#16+32,hSprBobBottomRightXPos(a0)
	move.w	#41,hSprBobTopLeftYPos(a0)
	move.w	#41+25,hSprBobBottomRightYPos(a0)
.draw
	move.l	GAMESCREEN_Ptr(a5),a0
	add.l	#(RL_SIZE*60*4),a0
	add.l	ShopHorizontalOffset(a5),a0
	moveq	#SHOPITEM_VERTICALMODULO,d0
	move.w	#(64*136*4)+2,d1
	bsr		ClearBlitWords			; Clear GAMESCREEN for vert bat

	move.l	GAMESCREEN_Ptr(a5),a2	; Draw strings
	add.l	#(RL_SIZE*67*4),a2
	add.l	ShopHorizontalOffset(a5),a2
	bsr		PlotShopDealString

	bsr		GetRandomShopItem
	move.l	hItemFunction(a0),ShopItemA(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*SHOP_ITEMA_VERTTOP_Y*4),a2
	add.l	ShopHorizontalOffset(a5),a2
	bsr		PlotShopVerticalItemText

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l	#(RL_SIZE*(124+8)*4),a2
	add.l	ShopHorizontalOffset(a5),a2
	bsr		PlotShopExitString

	bsr		GetRandomShopItem
	move.l	hItemFunction(a0),ShopItemB(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*SHOP_ITEMB_VERTTOP_Y*4),a2
	add.l	ShopHorizontalOffset(a5),a2
	bsr		PlotShopVerticalItemText

	move.l	GAMESCREEN_Ptr(a5),a2	; Fill background
	add.l 	#(RL_SIZE*60*4)+RL_SIZE+RL_SIZE+RL_SIZE,a2
	add.l	ShopHorizontalOffset(a5),a2
	move.w	#(4*RL_SIZE)-4,d1
	move.w	#(64*16*1)+2,d2
	bsr		FillBoxBlit				; DEAL?

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*77*4)+RL_SIZE+RL_SIZE,a2
	add.l	ShopHorizontalOffset(a5),a2
	move.w	#(4*RL_SIZE)-4,d1
	move.w	#(64*SHOPITEMS_VERTICALHEIGHT*1)+2,d2
	bsr		FillBoxBlit				; Items area fill

	move.l	Shopkeep(a5),a0
	exg		a0,a3
	move.l	GAMESCREEN_Ptr(a5),a4
	movea.l	a4,a2
	bsr		CookieBlitToScreen
	exg		a0,a3

	bsr		ShopLoop

	move.l 	GAMESCREEN_BackPtr(a5),a0	; Restore gamescreen
	add.l	#(RL_SIZE*60*4),a0
	add.l	ShopHorizontalOffset(a5),a0
	move.l	GAMESCREEN_Ptr(a5),a1
	add.l	#(RL_SIZE*60*4),a1
	add.l	ShopHorizontalOffset(a5),a1
	moveq	#SHOPITEM_VERTICALMODULO,d1
	move.w	#(64*136*4)+2,d2
	bsr		CopyRestoreGamearea

	move.l	Shopkeep(a5),a0
	bsr	CopyRestoreFromBobPosToScreen

	movem.l	(sp)+,d2/a2-a4

	rts



; In:   a3 = address to bat structure
; In:	a6 = address to CUSTOM $dff000
ShopLoop:
	movem.l	d3/a2,-(sp)

.shop
	lea		Bat0,a0
	cmpa.l	a0,a3
	bne.s	.bat1

	tst.b	Player0Enabled(a5)
	bmi.s	.bat1

	lea		CUSTOM+JOY1DAT,a2
	jsr		agdJoyDetectMovement
	bsr		UpdateVerticalShopChoice

	bsr		CheckPlayer0Fire
	tst.b	d0
	bne.w	.anim
	beq.w	.exit

.bat1
	lea		Bat1,a0
	cmpa.l	a0,a3
	bne.s	.bat2

	tst.b	Player1Enabled(a5)		; What controls are used?
	beq.s	.joy0

	move.w	#PLAYER1_KEYUP,d0
	move.w	#PLAYER1_KEYDOWN,d1
	jsr		DetectUpDown
	bra.s	.updatePlayer1Shop
.joy0
	lea		CUSTOM+JOY0DAT,a2
	jsr		agdJoyDetectMovement
.updatePlayer1Shop
	bsr		UpdateVerticalShopChoice

	bsr		CheckPlayer1Fire
	tst.b	d0
	bne.s	.anim
	beq.w	.exit
.bat2
	lea		Bat2,a0
	cmpa.l	a0,a3
	bne.s	.bat3

	tst.b	Player2Enabled(a5)		; What controls are used?
	beq.s	.joy2

	move.w	#PLAYER2_KEYLEFT,d0
	move.w	#PLAYER2_KEYRIGHT,d1
	jsr		DetectLeftRight
	bra.s	.updatePlayer2Shop
.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
.updatePlayer2Shop
	bsr		UpdateHorizontalShopChoice

	bsr		CheckPlayer2Fire
	tst.b	d0
	bne.s	.anim
	beq.s	.exit

.bat3
	tst.b	Player3Enabled(a5)		; What controls are used?
	beq.s	.joy3

	move.w	#PLAYER3_KEYLEFT,d0
	move.w	#PLAYER3_KEYRIGHT,d1
	jsr		DetectLeftRight
	bra.s	.updatePlayer3Shop
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3			; Unlike Joy0/1 these bits need no decoding
	lsr.b	#4,d3
.updatePlayer3Shop
	bsr		UpdateHorizontalShopChoice

	bsr		CheckPlayer3Fire
	tst.b	d0
	beq.s	.exit

.anim
	bsr		InShopAnimation

	bra.w	.shop

.exit
	movem.l	(sp)+,d3/a2
	rts

; In:	d3.b = directionBits for UP or DOWN
; In:	a6 = address to CUSTOM $dff000
UpdateVerticalShopChoice:
	cmp.b	ShopPreviousDirectionalBits(a5),d3
	beq.w	.fastExit

	movem.l	d2/a2,-(sp)

	move.l	GAMESCREEN_Ptr(a5),a0	; Clear bitplane
	add.l 	#(RL_SIZE*77*4)+RL_SIZE+RL_SIZE+RL_SIZE,a0
	add.l	ShopHorizontalOffset(a5),a0
	move.w	#(4*RL_SIZE)-4,d0
	move.w	#(64*SHOPITEMS_VERTICALHEIGHT*1)+2,d1
	bsr		ClearBlitWords

	cmpi.b	#JOY_UP,d3				; Check direction
	bne.s	.checkDown

	move.l	ShopItemA(a5),ShopSelectedItem(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*77*4)+RL_SIZE+RL_SIZE+RL_SIZE,a2
	add.l	ShopHorizontalOffset(a5),a2
	move.w	#(4*RL_SIZE)-4,d1
	move.w	#(64*51*1)+2,d2
	bsr		FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.checkDown
	cmpi.b	#JOY_DOWN,d3
	bne.s	.nothing

	move.l	ShopItemB(a5),ShopSelectedItem(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*(120+8+16)*4)+RL_SIZE+RL_SIZE+RL_SIZE,a2
	add.l	ShopHorizontalOffset(a5),a2
	move.w	#(4*RL_SIZE)-4,d1
	move.w	#(64*52*1)+2,d2
	bsr		FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.nothing
	clr.l	ShopSelectedItem(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*(120+8)*4)+RL_SIZE+RL_SIZE+RL_SIZE,a2
	add.l	ShopHorizontalOffset(a5),a2
	move.w	#(4*RL_SIZE)-4,d1
	move.w	#(64*16*1)+2,d2
	bsr		FillBoxBlit

.setPreviousDirectionalBits
	move.b	d3,ShopPreviousDirectionalBits(a5)
	lea		SFX_SELECT_STRUCT,a0
	jsr		PlaySample

	movem.l	(sp)+,d2/a2
.fastExit
	rts

; In:	d3.b = directionBits for UP or DOWN
; In:	a6 = address to CUSTOM $dff000
UpdateHorizontalShopChoice:
	move.l	d7,-(sp)

	move.b	d3,d7					; Isolate the nibble
	and.b	#$0f,d7
	cmp.b	ShopPreviousDirectionalBits(a5),d7
	beq.w	.fastExit

	movem.l	d2/a2,-(sp)

	move.l	GAMESCREEN_Ptr(a5),a0	; Clear bitplane
	add.l 	#(RL_SIZE*11*4)+RL_SIZE+RL_SIZE+RL_SIZE+8,a0
	add.l	ShopVerticalOffset(a5),a0
	move.w	#(4*RL_SIZE)-24,d0
	move.w	#(64*21*1)+12,d1
	bsr		ClearBlitWords

	btst.l	#JOY_LEFT_BIT,d7		; Check direction
	bne.s	.checkRight

	move.l	ShopItemA(a5),ShopSelectedItem(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*11*4)+RL_SIZE+RL_SIZE+RL_SIZE+8,a2
	add.l	ShopVerticalOffset(a5),a2
	move.w	#(4*RL_SIZE)-10,d1
	move.w	#(64*21*1)+5,d2
	bsr		FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.checkRight
	btst.l	#JOY_RIGHT_BIT,d7
	bne.s	.nothing

	move.l	ShopItemB(a5),ShopSelectedItem(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*11*4)+RL_SIZE+RL_SIZE+RL_SIZE+8+10+4,a2
	add.l	ShopVerticalOffset(a5),a2
	move.w	#(4*RL_SIZE)-10,d1
	move.w	#(64*21*1)+5,d2
	bsr		FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.nothing
	clr.l	ShopSelectedItem(a5)

	move.l	GAMESCREEN_Ptr(a5),a2
	add.l 	#(RL_SIZE*11*4)+RL_SIZE+RL_SIZE+RL_SIZE+8+10,a2
	add.l	ShopVerticalOffset(a5),a2
	move.w	#(4*RL_SIZE)-4,d1
	move.w	#(64*21*1)+2,d2
	bsr		FillBoxBlit

.setPreviousDirectionalBits
	move.b	d7,ShopPreviousDirectionalBits(a5)
	lea		SFX_SELECT_STRUCT,a0
	jsr		PlaySample

	movem.l	(sp)+,d2/a2
.fastExit
	move.l	(sp)+,d7
	rts

; In:	a2 = destination on screen
PlotShopDealString:
	movem.l	d5-d6,-(sp)

	lea		DEAL_STR,a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	move.w  #SHOPITEM_VERTICALMODULO,d5
	move.w  #SHOPITEM_VERTICALBLITSIZE,d6
	bsr		DrawStringBuffer

	movem.l	(sp)+,d5-d6

	rts

; In:	a2 = destination on screen
PlotShopExitString:
	movem.l	d5-d6,-(sp)

	lea		EXIT_STR,a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	move.w  #SHOPITEM_VERTICALMODULO,d5
	move.w  #SHOPITEM_VERTICALBLITSIZE,d6
	bsr		DrawStringBuffer

	movem.l	(sp)+,d5-d6

	rts

; In:	a0 = adress to shop item
; In:	a2 = destination on screen
PlotShopVerticalItemText:
	movem.l	a2/a4/d5-d6,-(sp)

	move.l	a0,a4

	move.w  #SHOPITEM_VERTICALMODULO,d5
	move.w  #SHOPITEM_VERTICALBLITSIZE,d6

	lea		(hItemDescription0,a4),a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	bsr		DrawStringBuffer

	add.l	#SHOP_TEXTHEIGHT,a2

	lea		(hItemDescription1,a4),a0
	tst.b	(a0)
	beq.s	.itemValue0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	bsr		DrawStringBuffer

	add.l	#SHOP_TEXTHEIGHT,a2

	lea		(hItemDescription2,a4),a0
	tst.b	(a0)
	beq.s	.itemValue0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	bsr		DrawStringBuffer

	add.l	#SHOP_TEXTHEIGHT,a2

	; lea     (hItemDescription3,a4),a0
	; tst.b	(a0)
	; beq.s	.itemValue0
	; lea     StringBuffer,a1
	; COPYSTR a0,a1
	; bsr     DrawStringBuffer

.itemValue0
	add.l	#SHOP_TEXTHEIGHT,a2

	moveq	#0,d0
	lea		(hItemValue0,a4),a0
	move.l	(a0),d0

	lea		StringBuffer,a1
	SIGNDSTR	a0,a1
	bsr		DrawStringBuffer
.itemValue1
	add.l	#SHOP_TEXTHEIGHT,a2

	lea		(hItemValue1,a4),a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	bsr		DrawStringBuffer
.exit
	movem.l	(sp)+,a2/a4/d5-d6
	rts

; In:	a0 = adress to shop item
; In:	a2 = destination on screen
PlotShopHorizontalItemText:
	movem.l	a2/a4/d5-d6,-(sp)

	move.l	a0,a4

	move.w  #SHOPITEM_HORIZONTALMODULO,d5
	move.w  #SHOPITEM_HORIZONTALBLITSIZE,d6

	lea		(hItemDescription0,a4),a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1
	lea		(hItemDescription1,a4),a0
	tst.b	(a0)
	beq.s	.plotDescription
	move.b	#" ",-1(a1)
	COPYSTR	a0,a1

	bsr		DrawStringBuffer

	lea		(hItemDescription2,a4),a0
	tst.b	(a0)
	beq.s	.plotDescription

	add.l	#SHOP_TEXTHEIGHT,a2
	COPYSTR	a0,a1

	; lea     (hItemDescription3,a4),a0
	; COPYSTR a0,a1

	bsr		DrawStringBuffer

.plotDescription
	add.l	#SHOP_TEXTHEIGHT,a2

	moveq	#0,d0
	lea		(hItemValue0,a4),a0
	move.l	(a0),d0

	lea		StringBuffer,a1
	SIGNDSTR	a0,a1
	move.b	#" ",-1(a1)
	lea		(hItemValue1,a4),a0
	COPYSTR	a0,a1

	bsr		DrawStringBuffer
.exit
	movem.l	(sp)+,a2/a4/d5-d6
	rts


; Always possible to shop
; Out:	d0.b = $FF when false, 0 when true
CanAlways:
	moveq	#0,d0
	rts

; Sad face :-(
ShopNothing:
	rts

; In:	a0 = adress to bat
ShopExtraPointsSmall:
	move.l	a2,-(sp)

	lea		ItemExtraPointsSmall,a2
	move.l	hPlayerScore(a0),a1		; Update score
	move.l	hItemValue0(a2),d0
	add.l	d0,(a1)

	move.l	(sp)+,a2
	rts
; In:	a0 = adress to bat
ShopExtraPointsBig:
	move.l	a2,-(sp)

	lea		ItemExtraPointsBig,a2
	move.l	hPlayerScore(a0),a1		; Update score
	move.l	hItemValue0(a2),d0
	add.l	d0,(a1)

	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
; Out:	d0.b = $FF when false, 0 when true
CanShopExtraBall:
	move.l	a2,-(sp)

	lea		ItemExtraBall,a2
	move.l	hItemValue0(a2),d1
	neg.l	d1

	move.l	hPlayerScore(a0),a1
	move.l	(a1),d0
	cmp.l	d1,d0
	blo.s	.tooExpensive
	moveq	#0,d0
	bra.s	.exit
.tooExpensive
	moveq	#-1,d0
.exit
	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
; In:	a6 = address to CUSTOM $dff000
ShopExtraBall:
	move.l	a2,-(sp)

	lea		ItemExtraBall,a2
	move.l	hItemValue0(a2),d0
	move.l	hPlayerScore(a0),a1		; Update score
	add.l	d0,(a1)					; (subtraction) - add a negative value
	addq.b	#1,BallsLeft(a5)
	bsr		DrawAvailableBalls

	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer0:
	move.l	a2,-(sp)

	lea		Bat0,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a2
	move.l	hItemValue0(a2),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer0:
	lea		ItemStealFromPlayer0,a1
	move.l	hItemValue0(a1),d0		; How much?

	lea		Bat0,a1
	move.l	hPlayerScore(a1),a1		; Take score
	sub.l	d0,(a1)
	clr.b	DirtyPlayer0Score(a5)

	move.l	hPlayerScore(a0),a1		; Give score
	add.l	d0,(a1)
	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer1:
	move.l	a2,-(sp)

	lea		Bat1,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a2
	move.l	hItemValue0(a2),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer1:
	lea		ItemStealFromPlayer1,a1
	move.l	hItemValue0(a1),d0		; How much?

	lea		Bat1,a1
	move.l	hPlayerScore(a1),a1		; Take score
	sub.l	d0,(a1)
	clr.b	DirtyPlayer1Score(a5)

	move.l	hPlayerScore(a0),a1		; Give score
	add.l	d0,(a1)
	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer2:
	move.l	a2,-(sp)

	lea		Bat2,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a2
	move.l	hItemValue0(a2),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer2:
	lea		ItemStealFromPlayer2,a1
	move.l	hItemValue0(a1),d0		; How much?

	lea		Bat2,a1
	move.l	hPlayerScore(a1),a1		; Take score
	sub.l	d0,(a1)
	clr.b	DirtyPlayer2Score(a5)

	move.l	hPlayerScore(a0),a1		; Give score
	add.l	d0,(a1)
	rts

; In:	a0 = adress to bat
; In:	a4 = shop item
; Out:	d0.b = $FF when false, 0 when true
CanShopStealFromPlayer3:
	move.l	a2,-(sp)

	lea		Bat3,a1
	cmpa.l	a0,a1
	beq.s	.notPossible

	move.l	(a4),a2
	move.l	hItemValue0(a2),d0
	move.l	hPlayerScore(a1),a1
	cmp.l	(a1),d0
	bhs.s	.notPossible

	moveq	#0,d0
	bra.s	.exit
.notPossible
	moveq	#-1,d0
.exit
	move.l	(sp)+,a2
	rts

; In:	a0 = adress to bat
ShopStealFromPlayer3:
	lea		ItemStealFromPlayer3,a1
	move.l	hItemValue0(a1),d0		; How much?

	lea		Bat3,a1
	move.l	hPlayerScore(a1),a1		; Take score
	sub.l	d0,(a1)
	clr.b	DirtyPlayer3Score(a5)

	move.l	hPlayerScore(a0),a1		; Give score
	add.l	d0,(a1)
	rts

; Pick a random item from the shop pool
; Out:	a0: adress to random shop item
GetRandomShopItem:
	lea		ShopPool,a0

	moveq	#0,d0
	jsr		RndB
	and.w	#$000f,d0
.loopitem
	tst.l	(a0)+
	beq.s	.startOver
	bne.s	.next
.startOver
	lea		ShopPool,a0
.next
	dbf		d0,.loopitem

	tst.l	(a0)
	bne.s	.getItem
	subq.l	#4,a0
.getItem
	move.l	(a0),a0

	rts

; In:	a6 = address to CUSTOM $dff000
InShopAnimation:
	movem.l	a2-a4,-(sp)

	WAITBOVP	d0

	cmp.b	#50,FrameTick(a5)
	bne		.tick
	clr.b	FrameTick(a5)
	bsr		ToggleSeparator
.tick
	addq.b	#1,FrameTick(a5)


	lea		ShopBob,a0
	bsr		CopyRestoreFromBobPosToScreen
	
	lea		ShopBob,a3
	move.l	GAMESCREEN_Ptr(a5),a4
	movea.l	a4,a2
	bsr		BobAnim

	tst.l	DirtyRowBits(a5)		; Keep processing dirty rows too
	beq		.nextBrickAnim
	bsr		ProcessDirtyRowQueue
.nextBrickAnim

	movem.l	(sp)+,a2-a4
	rts