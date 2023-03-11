; TODO: Create sprite system
InitPowerupPalette:
	; Override/set sprite colors - Sprite 0-1
	lea     CUSTOM+COLOR17,a6 
	move.w	#$151,(a6)+
	move.w	#$393,(a6)+
	move.w	#$8d8,(a6)
	; TODO: What to do with the 3rd ball?
	; Override/set sprite colors - Sprite 4-5
	lea     CUSTOM+COLOR25,a6 
	move.w 	#$511,(a6)+ 
	move.w 	#$933,(a6)+ 
	move.w 	#$d88,(a6)

	rts

SetMultiballPalette:
	lea     CUSTOM+COLOR17,a6 
	move.w	#$c80,(a6)+
	move.w	#$e90,(a6)+
	move.w	#$fca,(a6)
	rts
SetGlueBatPalette:
	lea     CUSTOM+COLOR17,a6 
	move.w	#$171,(a6)+
	move.w	#$3b3,(a6)+
	move.w	#$8f8,(a6)
	rts
SetWideBatPalette:
	lea     CUSTOM+COLOR17,a6 
	move.w	#$117,(a6)+
	move.w	#$33b,(a6)+
	move.w	#$88f,(a6)
	rts


; Make powerup appear if conditions are fulfilled.
; In:   a0 = address to ball structure
; In	a5 = pointer to brick in GAMEAREA
CheckAddPowerup:
	tst.l	Powerup         	; Powerup active?
	bne.w	.exit

	move.l	NextPowerupPtr,a2
	move.l	#PowerupTableEnd,a1
	move.l	(a2),d0
	cmpa.l	a1,a2
	beq.s	.resetPowerupPtr
	bne.s	.nextPowerup
	
.resetPowerupPtr
	move.l	#PowerupTable,NextPowerupPtr
	bra.s	.checkSimultaneousPowerup
.nextPowerup
	addq.l	#4,a2
	move.l	a2,NextPowerupPtr

.checkSimultaneousPowerup		; Can't have multiple simultaneous multi-ball effect
	cmpi.l	#PwrStartMultiball,d0
	bne.s	.setPowerupPalette
	tst.l	AllBalls
	bne.w	.exit

.setPowerupPalette
	cmpi.l	#PwrStartMultiball,d0
	bne.s	.wideBatPalette
	bsr	SetMultiballPalette
	bra.s	.createPowerup
.wideBatPalette
	cmpi.l	#PwrStartWideBat,d0
	bne.s	.glueBatPalette
	bsr	SetWideBatPalette
	bra.s	.createPowerup
.glueBatPalette
	bsr	SetGlueBatPalette

.createPowerup
        lea     Powerup,a1
	move.l	d0,hPowerupRoutine(a1)
        move.l  #Spr_Powerup0,hAddress(a1)
        move.l  #0,hIndex(a1)

	bsr	GetCoordsFromGameareaPtr
        move.w  d0,hSprBobTopLeftXPos(a1)
        move.w  d1,hSprBobTopLeftYPos(a1)

	move.l	hBallPlayerBat(a0),d0

	cmp.l	#Bat0,d0
	bne.s	.bat1
	move.w  #1,hSprBobXCurrentSpeed(a1)
	bra.s	.exit
.bat1
	cmp.l	#Bat1,d0
	bne.s	.bat2
	move.w  #-1,hSprBobXCurrentSpeed(a1)
	bra.s	.exit
.bat2
	cmp.l	#Bat2,d0
	bne.s	.bat3
	move.w  #1,hSprBobYCurrentSpeed(a1)
	bra.s	.exit
.bat3
	move.w  #-1,hSprBobYCurrentSpeed(a1)

.exit
        rts


ClearPowerup:
	lea	Powerup,a0
	cmpi.l	#0,(a0)
	beq.s	.exit
	move.l	#0,hSprBobXCurrentSpeed(a0)	; Clear X.w and Y.w speeds
	move.l	hAddress(a0),a0
	move.l	#0,(a0)         		; Disarm sprite
        move.l  #0,Powerup      		; Remove sprite
.exit
        rts

ClearActivePowerupEffects:
	move.b	#0,WideBatCounter
	rts

; Adds powerup effect for the player who got the powerup.
; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
BatPowerup:
        ; TODO: Add sound effect at pickup. Visual effect too?
	
	move.l	hPowerupRoutine(a0),a2
	jsr	(a2)
	bsr	ClearPowerup
	
	rts

; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
PwrStartMultiball:
	lea	Ball0,a3
	lea	Ball1,a4
	lea	Ball2,a5

	move.l	hPlayerScore(a1),a2		; Update score
        move.l	hPowerupPlayerScore(a0),d1
        add.w   d1,(a2)

	move.l	a2,hPlayerScore(a3)		; Set scoring in balls
	move.l	a2,hPlayerScore(a4)
	move.l	a2,hPlayerScore(a5)

	move.l	a1,hBallPlayerBat(a3)		; Set bat that "owns" this ball
	move.l	a1,hBallPlayerBat(a4)
	move.l	a1,hBallPlayerBat(a5)

	lea	AllBalls,a2
	; NOTE: Active ball might be OTHER than Ball0 after a previous multi-ball.
	move.l	hAllBallsBall0(a2),a6

	move.l	#3-1,hAllBallsActive(a2)
	move.l	a3,hAllBallsBall0(a2)
	move.l	a4,hAllBallsBall1(a2)
	move.l	a5,hAllBallsBall2(a2)

	move.l	hSprBobTopLeftXPos(a6),d1	; Copy Top X,Y position of active ball
	move.l	d1,hSprBobTopLeftXPos(a3)
	move.l	d1,hSprBobTopLeftXPos(a4)
	move.l	d1,hSprBobTopLeftXPos(a5)
	move.l	hSprBobBottomRightXPos(a6),d1	; Copy Bottom X,Y position
	move.l	d1,hSprBobBottomRightXPos(a3)
	move.l	d1,hSprBobBottomRightXPos(a4)
	move.l	d1,hSprBobBottomRightXPos(a5)

	move.w	hSprBobXCurrentSpeed(a6),d1	; Set other speeds
	move.w	d1,hSprBobXCurrentSpeed(a3)	; ... but copy the speed from active ball to ball0
	move.w	d1,hSprBobXCurrentSpeed(a4)
	neg.w	d1
	move.w	d1,hSprBobXCurrentSpeed(a5)

	move.w	hSprBobYCurrentSpeed(a6),d1
	move.w	d1,hSprBobYCurrentSpeed(a3)
	move.w	d1,hSprBobYCurrentSpeed(a5)
	neg.w	d1
	move.w	d1,hSprBobYCurrentSpeed(a4)

	rts

; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
PwrStartGlueball:
	move.l	hPlayerScore(a1),a2		; Update score
        move.l	hPowerupPlayerScore(a0),d1
        add.w   d1,(a2)

	move.w	hBatEffects(a1),d1
	bset.l	#0,d1
	move.w	d1,hBatEffects(a1)

	rts

; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
PwrStartWideBat:
	move.l	hPlayerScore(a1),a2		; Update score
        move.l	hPowerupPlayerScore(a0),d1
        add.w   d1,(a2)

	tst.l	hSize(a1)			; Already wide?
	bhi.s	.exit

	cmpi.w	#7,hSprBobHeight(a1)		; Is it a vertical bat?
	bhi.s	.increaseHeight
	move.l	#PwrWidenHoriz,WideningRoutine
	move.b	#15,WideBatCounter
	bra.s	.setWidening

.increaseHeight
	move.l	#PwrWidenVert,WideningRoutine
	move.b	#12,WideBatCounter

.setWidening
	move.l	a1,WideningBat
.exit
	rts


PwrWidenVert:
	move.l	WideningBat,a0
	addi.l	#1,hSize(a0)

	cmpa.l	#Bat0,a0
	bne.s	.bat1
	move.l	Bat0SourceBob,a1
	move.l	Bat0SourceBobMask,a4
	bra.s	.prepareBlit
.bat1
	move.l	Bat1SourceBob,a1
	move.l	Bat1SourceBobMask,a4

.prepareBlit
	move.l	hSize(a0),d1
	add.b	d1,d1
	add.b	d1,d1
	
	lea	BatVertBlitSizes,a3
	move.l	(a3,d1),d1

	move.w	d1,hBobBlitSize(a0)			; Next bat-blits cover +1 line
	swap	d1
	move.w	d1,d3

	add.l 	#(ScrBpl*(12+2)*4),a1			; Source starts after Y offsets

	move.l	hAddress(a0),a2
	add.l 	#2*4,a2					; Destination starts 1 line down
	move.l	#ScrBpl-2,d2

	bsr	BatExtendVerticalBlitToActiveBob

	move.l	a4,a1
	add.l 	#(ScrBpl*(12+2)*4),a1			; Source starts after Y offsets
	move.l	hSprBobMaskAddress(a0),a2
	add.l 	#2*4,a2

	bsr	BatExtendVerticalBlitToActiveBob


	subi.l	#2*4,hAddress(a0)			; Bob & Mask grew 1 line
	subi.l	#2*4,hSprBobMaskAddress(a0)

	move.b	WideBatCounter,d1
	and.w	#1,d1
	bne.s	.odd

	subq.w	#1,hSprBobTopLeftYPos(a0)
	bra.s	.setHeight
.odd
	addq.w	#1,hSprBobBottomRightYPos(a0)

.setHeight
	addq.w	#1,hSprBobHeight(a0)

	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	bsr	ClearBlitToScreen		; TODO: optimize - this could draw this bat twice in this frame
	bsr	CookieBlitToScreen

	rts


PwrWidenHoriz:
	move.l	WideningBat,a0
	addi.l	#1,hSize(a0)
	move.l	hAddress(a0),a2

	cmpa.l	#Bat2,a0
	bne.s	.bat3
	move.l	Bat2SourceBob,a1
	move.l	Bat2SourceBobMask,a4
	bra.s	.prepareBlit
.bat3
	move.l	Bat3SourceBob,a1
	move.l	Bat3SourceBobMask,a4

.prepareBlit
	addq.l	#2,a1
	addq.l	#1,a2
	move.l	#ScrBpl-4,d2

	moveq	#0,d1
	move.b	WideBatCounter,d1

	lea	BatHorizExtendMaskTable,a3
	add.l	d1,a3
	add.l	d1,a3

	ror.l	#4,d1

	move.w	#(64*7*4)+2,d3			; 7 lines, 2 word to blit horizontally

	bsr	BatExtendHorizontalBlitToActiveBob

	move.l	a4,a1
	move.l	hSprBobMaskAddress(a0),a2

	addq.l	#2,a1
	addq.l	#1,a2

	bsr	BatExtendHorizontalBlitToActiveBob

	subq.w	#1,hBobLeftXOffset(a0)
	
	move.b	WideBatCounter,d1
	and.w	#1,d1
	bne.s	.odd

	subq.w	#1,hSprBobTopLeftXPos(a0)
	bra.s	.setWidth
.odd
	addq.w	#1,hSprBobBottomRightXPos(a0)

.setWidth
	addq.w	#1,hSprBobWidth(a0)
	
	move.l	GAMESCREEN_BITMAPBASE,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	bsr	CookieBlitToScreen		; TODO: optimize - this could draw this bat twice in this frame

	rts
