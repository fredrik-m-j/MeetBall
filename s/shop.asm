ShopItemVerticalModulo		equ	ScrBpl-4
ShopItemHorizontalModulo	equ	ScrBpl-12
ShopItemVerticalBlitsize	equ	(64*7*4)+2
ShopItemHorizontalBlitsize	equ	(64*7*4)+6
ShopTextheight			equ	ScrBpl*7*4

ShopHorizontalOffset:		dc.l	0
ShopVerticalOffset:		dc.l	0


; Initializes things
InitShop:
	lea	ItemExtraBall,a0

        lea     EXTRA_STR,a1
        lea  	(hItemDescription0,a0),a2
        COPYSTR a1,a2
        lea     BALL_STR,a1
        lea	(hItemDescription1,a0),a2
        COPYSTR a1,a2
        lea     MINUS_STR,a1
	lea     S1500_STR,a2
        lea	(hItemCost0,a0),a3
        CONCATSTR a1,a2,a3
        lea     POINTS_STR,a1
        lea	(hItemCost1,a0),a2
        COPYSTR a1,a2

	lea	ItemExtraPoints,a0

        lea     PLUS_STR,a1
	lea     S1200_STR,a2
        lea	(hItemDescription0,a0),a3
        CONCATSTR a1,a2,a3
        lea     POINTS_STR,a1
        lea	(hItemDescription1,a0),a2
        COPYSTR a1,a2


	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*89*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96)*4),d1

        lea	ShopAnimMap,a0

	moveq	#9,d7
.loop1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop1

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(89+32)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96+32)*4),d1

	moveq	#9,d7
.loop2
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop2

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(89+64)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+64)*4)+20,d1

	moveq	#4,d7
.loop3
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop3

        rts

ShopUpdates:
	lea	ShopBob,a0

	move.w  hSprBobTopLeftXPos(a0),d0

	cmpi.w	#275,d0
	bne.s	.goRight
	neg.w	hSprBobXCurrentSpeed(a0)
.goRight
	cmpi.w	#25,d0
	bne.s	.checkY
	neg.w	hSprBobXCurrentSpeed(a0)
.checkY

	move.w  hSprBobTopLeftYPos(a0),d0

	cmpi.w	#215,d0
	bne.s	.goDown
	neg.w	hSprBobYCurrentSpeed(a0)
.goDown
	cmpi.w	#30,d0
	bne.s	.updatePos
	neg.w	hSprBobYCurrentSpeed(a0)

.updatePos
	move.w  hSprBobTopLeftXPos(a0),d0
        move.w  hSprBobTopLeftYPos(a0),d1
        add.w   hSprBobXCurrentSpeed(a0),d0     ; Update ball coordinates
        add.w   hSprBobYCurrentSpeed(a0),d1
        
	move.w  d0,hSprBobTopLeftXPos(a0)       ; Set the new coordinate values
        move.w  d1,hSprBobTopLeftYPos(a0)

	add.w	hSprBobWidth(a0),d0
	add.w	hSprBobHeight(a0),d1

        move.w  d0,hSprBobBottomRightXPos(a0)       ; Set the new coordinate values
        move.w  d1,hSprBobBottomRightYPos(a0)

	rts

; Open shop for the ball-owner.
; In:   a0 = address to ball structure
EnterShop:
	move.l	hBallPlayerBat(a0),a3

	lea	Bat0,a2
	cmpa.l	a2,a3
	bne.w	.bat1

	bsr	EnterVerticalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat0,a0
	bsr 	CookieBlitToScreen
	bra.s	.exit
.bat1
	lea	Bat1,a2
	cmpa.l	a2,a3
	bne.w	.bat2

	bsr	EnterVerticalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat1,a0
	bsr 	CookieBlitToScreen
	bra.s	.exit
.bat2
	lea	Bat2,a2
	cmpa.l	a2,a3
	bne.s	.bat3

	bsr	EnterHorizontalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat2,a0
	bsr 	CookieBlitToScreen
	bra.s	.exit
.bat3
	bsr	EnterHorizontalShop
	; Retore bat
	move.l 	GAMESCREEN_BITMAPBASE_BACK,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	lea	Bat3,a0
	bsr 	CookieBlitToScreen
.exit
	rts


; In:   a3 = address to bat structure
EnterHorizontalShop:
	lea	Bat2,a0
	cmpa.l	a0,a3
	bne.s	.noOffset
	move.l	#(ScrBpl*224*4),ShopVerticalOffset
	bra.s	.draw
.noOffset
	move.l	#0,ShopVerticalOffset

.draw
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#6,a0
	add.l	ShopVerticalOffset,a0
	moveq	#ScrBpl-28,d1
	move.w	#(64*32*4)+14,d2
        bsr     ClearBlitWords			; Clear GAMESCREEN for horiz bat

        move.l  GAMESCREEN_BITMAPBASE,a2	; Draw strings
        add.l 	#(ScrBpl*1*4)+6,a2
	add.l	ShopVerticalOffset,a2
	bsr 	PlotShopDealString

; TODO - add more items and randomize
	lea	ItemExtraBall,a4

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(12+2)*4)+6,a2
	add.l	ShopVerticalOffset,a2
	bsr	PlotShopHorizontalItemText

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(12+6)*4)+18,a2
	add.l	ShopVerticalOffset,a2
	bsr	PlotShopExitString

; TODO - add more items and randomize
	lea	ItemExtraPoints,a4

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(12+2)*4)+22,a2
	add.l	ShopVerticalOffset,a2
	bsr	PlotShopHorizontalItemText

	move.l  GAMESCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#ScrBpl+ScrBpl+ScrBpl+6,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-28,d1
	move.w	#(64*11*1)+14,d2
	bsr	FillBoxBlit			; DEAL?

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+6,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-28,d1
	move.w	#(64*20*1)+14,d2
	bsr	FillBoxBlit			; Items area fill

	bsr	ShopLoop

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0	; Restore gamescreen
	add.l   #6,a0
	add.l	ShopVerticalOffset,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #6,a1
	add.l	ShopVerticalOffset,a1
	moveq	#ScrBpl-28,d1
	move.w	#(64*32*4)+14,d2
        bsr	CopyRestoreGamearea

	rts

; In:   a3 = address to bat structure
EnterVerticalShop:
	lea	Bat0,a0
	cmpa.l	a0,a3
	bne.s	.noOffset
	move.l	#36,ShopHorizontalOffset
	bra.s	.draw
.noOffset
	move.l	#0,ShopHorizontalOffset

.draw
        move.l  GAMESCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*48*4),a0
	add.l	ShopHorizontalOffset,a0
	moveq	#ShopItemVerticalModulo,d1
	move.w	#(64*160*4)+2,d2
        bsr     ClearBlitWords			; Clear GAMESCREEN for vert bat

        move.l  GAMESCREEN_BITMAPBASE,a2	; Draw strings
        add.l 	#(ScrBpl*52*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr 	PlotShopDealString

; TODO - add more items and randomize
	lea	ItemExtraBall,a4

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*70*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr	PlotShopVerticalItemText

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*(124+8)*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr	PlotShopExitString

; TODO - add more items and randomize
	lea	ItemExtraPoints,a4

        move.l  GAMESCREEN_BITMAPBASE,a2
        add.l 	#(ScrBpl*150*4),a2
	add.l	ShopHorizontalOffset,a2
	bsr	PlotShopVerticalItemText

	move.l  GAMESCREEN_BITMAPBASE,a1	; Fill background
	add.l 	#(ScrBpl*48*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*16*1)+2,d2
	bsr	FillBoxBlit			; DEAL?

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*65*4)+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*143*1)+2,d2
	bsr	FillBoxBlit			; Items area fill

	bsr	ShopLoop

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0	; Restore gamescreen
	add.l   #(ScrBpl*48*4),a0
	add.l	ShopHorizontalOffset,a0
	move.l	GAMESCREEN_BITMAPBASE,a1
	add.l   #(ScrBpl*48*4),a1
	add.l	ShopHorizontalOffset,a1
	moveq	#ShopItemVerticalModulo,d1
	move.w	#(64*160*4)+2,d2
        bsr	CopyRestoreGamearea

	rts



; In:   a3 = address to bat structure
ShopLoop:

.shop
	lea	Bat0,a0
	cmpa.l	a0,a3
	bne.s	.bat1

					; TODO: Reuse code? Consider using MACRO?
	tst.b	Player0Enabled		; What controls are used?
	beq.s	.joy1

	move.w	#KEY_UP,d0
	move.w	#KEY_DOWN,d1
	bsr	detectUpDown
	bra.s	.updatePlayer0Shop
.joy1
	lea	CUSTOM+JOY1DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer0Shop
	bsr	UpdateVerticalShopChoice

	bsr	CheckPlayer0Fire
	tst.b	d0
	bne.w	.anim
	beq.w	.checkChoice

.bat1
	lea	Bat1,a2
	cmpa.l	a3,a2
	bne.s	.bat2

	tst.b	Player1Enabled		; What controls are used?
	beq.s	.joy0

	move.w	#KEY_W,d0
	move.w	#KEY_S,d1
	bsr	detectUpDown
	bra.s	.updatePlayer1Shop
.joy0
	lea	CUSTOM+JOY0DAT,a5
	bsr	agdJoyDetectMovement
.updatePlayer1Shop
	bsr	UpdateVerticalShopChoice

	bsr	CheckPlayer1Fire
	tst.b	d0
	bne.s	.anim
	beq.w	.checkChoice
.bat2
	lea	Bat2,a2
	cmpa.l	a3,a2
	bne.s	.bat3

	tst.b	Player2Enabled		; What controls are used?
	beq.s	.joy2

	move.w	#KEY_LEFT,d0
	move.w	#KEY_RIGHT,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer2Shop
.joy2	; In parallel port
	move.b	CIAA+ciaprb,d3		; Unlike Joy0/1 these bits need no decoding
.updatePlayer2Shop
	bsr	UpdateHorizontalShopChoice

	bsr	CheckPlayer2Fire
	tst.b	d0
	bne.s	.anim
	beq.s	.checkChoice

.bat3
	tst.b	Player3Enabled		; What controls are used?
	beq.s	.joy3

	move.w	#KEY_A,d0
	move.w	#KEY_D,d1
	bsr	detectLeftRight
	bra.s	.updatePlayer3Shop
.joy3	; In parallel port
	move.b	CIAA+ciaprb,d3		; Unlike Joy0/1 these bits need no decoding
	lsr.b	#4,d3
.updatePlayer3Shop
	bsr	UpdateHorizontalShopChoice

	bsr	CheckPlayer3Fire
	tst.b	d0
	beq.s	.checkChoice

.anim
	WAITLASTLINE d0

	move.l	a3,-(sp)

	lea	ShopBob,a0
	bsr	BobAnim

	move.l	(sp)+,a3

	bra.w	.shop

.checkChoice

.exit

	rts

; In:	d3.b = directionBits for UP or DOWN
UpdateVerticalShopChoice:
	cmp.b	ShopPreviousDirectionalBits,d3
	beq.b	.done

	move.l  GAMESCREEN_BITMAPBASE,a0	; Clear bitplane
	add.l 	#(ScrBpl*65*4)+ScrBpl+ScrBpl+ScrBpl,a0
	add.l	ShopHorizontalOffset,a0
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*143*1)+2,d2
	bsr	ClearBlitWords

	cmpi.b	#JOY_UP,d3			; Check direction
	bne.s	.checkDown

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*65*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*63*1)+2,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.checkDown
	cmpi.b	#JOY_DOWN,d3
	bne.s	.nothing

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*(120+8+16)*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*64*1)+2,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.nothing
	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*(120+8)*4)+ScrBpl+ScrBpl+ScrBpl,a1
	add.l	ShopHorizontalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*16*1)+2,d2
	bsr	FillBoxBlit

.setPreviousDirectionalBits
	move.b	d3,ShopPreviousDirectionalBits
.done
	rts

; In:	d3.b = directionBits for UP or DOWN
UpdateHorizontalShopChoice:
	move.b	d3,d7				; Isolate the nibble
	and.b	#$0f,d7

	cmp.b	ShopPreviousDirectionalBits,d7
	beq.s	.done

	move.l  GAMESCREEN_BITMAPBASE,a0	; Clear bitplane
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+6,a0
	add.l	ShopVerticalOffset,a0
	move.w	#(4*ScrBpl)-28,d1
	move.w	#(64*20*1)+14,d2
	bsr	ClearBlitWords

	btst.l	#JOY_LEFT_BIT,d7		; Check direction
	bne.s	.checkRight

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+6,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-12,d1
	move.w	#(64*20*1)+6,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.checkRight
	btst.l	#JOY_RIGHT_BIT,d7
	bne.s	.nothing

	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+6+12+4,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-12,d1
	move.w	#(64*20*1)+6,d2
	bsr	FillBoxBlit

	bra.s	.setPreviousDirectionalBits
.nothing
	move.l  GAMESCREEN_BITMAPBASE,a1
	add.l 	#(ScrBpl*12*4)+ScrBpl+ScrBpl+ScrBpl+6+12,a1
	add.l	ShopVerticalOffset,a1
	move.w	#(4*ScrBpl)-4,d1
	move.w	#(64*20*1)+2,d2
	bsr	FillBoxBlit

.setPreviousDirectionalBits
	move.b	d7,ShopPreviousDirectionalBits
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
	beq.s	.itemCost0

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
	bsr     DrawStringBuffer
.itemCost0
	add.l	#ShopTextheight,a2
	add.l	#ShopTextheight,a2

	lea     (hItemCost0,a4),a0
	tst.b	(a0)
	beq.s	.itemCost1

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
	bsr     DrawStringBuffer
.itemCost1
	add.l	#ShopTextheight,a2

	lea     (hItemCost1,a4),a0
	tst.b	(a0)
	beq.s	.exit

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

	lea     (hItemCost0,a4),a0
	tst.b	(a0)
	beq.s	.exit

        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
.itemCost1
	lea     (hItemCost1,a4),a0
	tst.b	(a0)
	beq.s	.plotCost

        move.b	#" ",-1(a1)
        COPYSTR a0,a1
.plotCost
	bsr     DrawStringBuffer
.exit
	rts


; In:	a1 = adress to bat
ShopExtraPoints:

	rts

; In:	a1 = adress to bat
ShopExtraBall:

	rts