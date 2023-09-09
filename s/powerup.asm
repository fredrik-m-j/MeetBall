; TODO: Create sprite system
InitPowerupPalette:
	; Override/set sprite colors - Sprite 6-7
	lea     CUSTOM+COLOR29,a6 
	move.w 	#$511,(a6)+ 
	move.w 	#$933,(a6)+ 
	move.w 	#$d88,(a6)

	rts

SetMultiballPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$c80,(a6)+
	move.w	#$e90,(a6)+
	move.w	#$fca,(a6)
	rts
SetGlueBatPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$171,(a6)+
	move.w	#$3b3,(a6)+
	move.w	#$8f8,(a6)
	rts
SetWideBatPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$117,(a6)+
	move.w	#$33b,(a6)+
	move.w	#$88f,(a6)
	rts
SetBreachBallPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$c20,(a6)+
	move.w	#$e30,(a6)+
	move.w	#$f75,(a6)
	rts
SetPointsPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$334,(a6)+
	move.w	#$668,(a6)+
	move.w	#$bbe,(a6)
	rts
SetBatspeedPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$66e,(a6)+
	move.w	#$33b,(a6)+
	move.w	#$bbf,(a6)
	rts
SetBatGunPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$c2c,(a6)+
	move.w	#$e3e,(a6)+
	move.w	#$fbf,(a6)
	rts
SetInsanoballzPalette:
	lea     CUSTOM+COLOR29,a6 
	move.w	#$4a4,(a6)+
	move.w	#$060,(a6)+
	move.w	#$efe,(a6)
	rts

PowerupUpdates:
	tst.l	Powerup
	beq.w	.exit
	
	lea	Powerup,a0

.movePowerupX
	move.w	hSprBobXCurrentSpeed(a0),d0
	beq.s	.movePowerupY
	add.w	d0,hSprBobTopLeftXPos(a0)
	bra.s	.checkBounds
.movePowerupY
	move.w	hSprBobYCurrentSpeed(a0),d0
	add.w	d0,hSprBobTopLeftYPos(a0)

.checkBounds
	move.w	hSprBobTopLeftXPos(a0),d0	; Powerup moved out of gamearea?
	cmpi.w	#-15,d0
	ble.s	.powerupOutOfBounds
	
	cmpi.w	#DISP_WIDTH,d0
	bgt.s	.powerupOutOfBounds

	move.w	hSprBobTopLeftYPos(a0),d0
	cmpi.w	#-7,d0
	ble.s	.powerupOutOfBounds

	cmpi.w	#DISP_HEIGHT,d0
	bgt.s	.powerupOutOfBounds
	bra.s	.exit
	
.powerupOutOfBounds
	bsr	ClearPowerup
.exit
	rts

; Make powerup appear if conditions are fulfilled.
; In:   a0 = address to ball structure
; In	a5 = pointer to brick in GAMEAREA
CheckAddPowerup:
	tst.l	Powerup
	bne	.exit
	cmp.l	BlinkBrickGameareaPtr,a5
	bne	.exit
	tst.b	InsanoState
	bpl	.exit

	bsr	RndB
	and.w	#%1111,d0		; 0 to 15
	add.b	d0,d0
	add.b	d0,d0
	lea	PowerupTable,a1
	move.l	(a1,d0.w),d0
	beq.w	.exit			; No luck

	cmpi.l	#PwrStartMultiball,d0	; Can't have multiple simultaneous multi-ball effect
	bne.s	.checkInsano
	tst.l	AllBalls
	bne.w	.exit
.checkInsano
	cmpi.l	#PwrStartInsanoballz,d0	; Insanoballz must start from 1 ball
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
	cmpi.l	#PwrStartGluebat,d0
	bne.s	.breachBallPalette
	bsr	SetGlueBatPalette
	bra.s	.createPowerup
.breachBallPalette
	cmpi.l	#PwrStartBreachball,d0
	bne.s	.pointsPalette
	bsr	SetBreachBallPalette
	bra.s	.createPowerup
.pointsPalette
	cmpi.l	#PwrExtraPoints,d0
	bne.s	.batspeedPalette
	bsr	SetPointsPalette
	bra.s	.createPowerup
.batspeedPalette
	cmpi.l	#PwrIncreaseBatspeed,d0
	bne.s	.batGunPalette
	bsr	SetBatspeedPalette
	bra.s	.createPowerup
.batGunPalette
	cmpi.l	#PwrGun,d0
	bne.s	.insanoballzPalette
	bsr	SetBatGunPalette
	bra.s	.createPowerup
.insanoballzPalette
	bsr	SetInsanoballzPalette

.createPowerup
        lea     Powerup,a1
	move.l	d0,hPowerupRoutine(a1)
        move.l  #Spr_Powerup0,hAddress(a1)	; Display it
        clr.b	hIndex(a1)

	bsr	GetCoordsFromGameareaPtr
        move.w  d0,hSprBobTopLeftXPos(a1)
        move.w  d1,hSprBobTopLeftYPos(a1)

	move.l	hPlayerBat(a0),d0

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
	move.l	a0,-(sp)

	lea	Powerup,a0
	cmpi.l	#0,(a0)
	beq.s	.exit
	clr.l	hSprBobXCurrentSpeed(a0)	; Clear X.w and Y.w speeds
	move.l	hAddress(a0),a0
	clr.l	(a0)         			; Disarm sprite
        clr.l	Powerup      			; Remove sprite
.exit
	move.l	(sp)+,a0
        rts

ClearActivePowerupEffects:
	clr.b	WideBatCounter

	move.b	#INACTIVE_STATE,InsanoState
	rts

; Adds powerup effect for the player who got the powerup.
; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
CollectPowerup:
	move.l	hPowerupRoutine(a0),a2
	jsr	(a2)
	bsr	ClearPowerup
	
	lea	SFX_POWERUP_STRUCT,a0
	bsr     PlaySample

	rts

; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
PwrStartMultiball:
	lea	Ball0,a3
	lea	Ball1,a4
	lea	Ball2,a5

	move.l	hPlayerScore(a1),a2		; Update score
        addq.l	#5,(a2)

	move.l	a1,hPlayerBat(a3)		; Set ballowner
	move.l	a1,hPlayerBat(a4)
	move.l	a1,hPlayerBat(a5)

	move.l	hAddress(a3),a6			; Find active ball
	tst.l	(a6)				; ... by checking if current sprite is enabled
	beq.s	.ball1
	move.l	a3,a6
	bra.s	.releaseBalls
.ball1
	move.l	hAddress(a4),a6
	tst.l	(a6)
	beq.s	.ball2
	move.l	a4,a6
	bra.s	.releaseBalls
.ball2
	move.l	a5,a6

.releaseBalls
	lea	AllBalls,a2
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

	; Punish any glue-playing bastard and release ball sitting on bat
	move.w	hSprBobXSpeed(a6),hSprBobXCurrentSpeed(a6)
	move.w	hSprBobYSpeed(a6),hSprBobYCurrentSpeed(a6)

	move.w	hSprBobXCurrentSpeed(a6),d1	; Set other speeds
	move.w	d1,hSprBobXCurrentSpeed(a3)	; ... but copy the speed from active ball to ball0
	move.w	d1,hSprBobXSpeed(a3)
	move.w	d1,hSprBobXCurrentSpeed(a4)
	move.w	d1,hSprBobXSpeed(a4)
	neg.w	d1
	move.w	d1,hSprBobXCurrentSpeed(a5)
	move.w	d1,hSprBobXSpeed(a5)

	move.w	hSprBobYCurrentSpeed(a6),d1
	move.w	d1,hSprBobYCurrentSpeed(a3)
	move.w	d1,hSprBobYSpeed(a3)
	move.w	d1,hSprBobYCurrentSpeed(a5)
	move.w	d1,hSprBobYSpeed(a5)
	neg.w	d1
	move.w	d1,hSprBobYCurrentSpeed(a4)
	move.w	d1,hSprBobYSpeed(a4)

	bsr	Set3BallColor

	rts


; In:	a1 = adress to bat
PwrExtraPoints:
	move.l	hPlayerScore(a1),a2		; Update score
        add.l	#10,(a2)
	rts

; In:	a1 = adress to bat
PwrStartBreachball:
	move.l	hPlayerScore(a1),a2		; Update score
        addq.l	#5,(a2)

        lea     AllBalls+hAllBallsBall0,a2
.ballLoop
        move.l  (a2)+,d1			; Any ball in this slot?
	beq.s   .exit

	move.l	d1,a3
	clr.b	hIndex(a3)			; Turn animation ON

	move.w	hBallEffects(a3),d1
	bset.l	#1,d1
	move.w	d1,hBallEffects(a3)

	bra.s	.ballLoop
.exit
	rts

; In:	a1 = adress to bat
PwrStartGluebat:
	move.l	hPlayerScore(a1),a2		; Update score
        addq.l	#5,(a2)

	move.w	hBatEffects(a1),d1
	bset.l	#0,d1
	move.w	d1,hBatEffects(a1)

	rts

; In:	a1 = adress to bat
PwrIncreaseBatspeed:
	move.w	hSprBobXSpeed(a1),d0
	beq.s	.ySpeed
	addq.w	#1,hSprBobXSpeed(a1)
	bra.s	.done
.ySpeed
	addq.w	#1,hSprBobYSpeed(a1)
.done
	rts

; In:	a1 = adress to bat
PwrGun:
	move.w	hBatEffects(a1),d1
	bset.l	#1,d1
	move.w	d1,hBatEffects(a1)
	rts

; In:	a1 = adress to bat
PwrStartWideBat:
	move.l	hPlayerScore(a1),a2		; Update score
        addq.l	#5,(a2)

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
	addq.l	#1,hSize(a0)

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

	move.w	d1,hBobBlitSize(a0)		; Next bat-blits cover +1 line
	swap	d1
	move.w	d1,d3

	add.l 	#(ScrBpl*(12+2)*4),a1		; Source starts after Y offsets

	move.l	hAddress(a0),a2
	addq.l 	#2*4,a2				; Destination starts 1 line down
	moveq	#ScrBpl-2,d2

	bsr	BatExtendVerticalBlitToActiveBob

	move.l	a4,a1
	add.l 	#(ScrBpl*(12+2)*4),a1		; Source starts after Y offsets
	move.l	hSprBobMaskAddress(a0),a2
	addq.l 	#2*4,a2

	bsr	BatExtendVerticalBlitToActiveBob


	subq.l	#2*4,hAddress(a0)		; Bob & Mask grew 1 line
	subq.l	#2*4,hSprBobMaskAddress(a0)

	move.b	WideBatCounter,d1
	and.w	#1,d1
	bne.s	.odd

	subq.w	#1,hSprBobTopLeftYPos(a0)
	bra.s	.setHeight
.odd
	addq.w	#1,hSprBobBottomRightYPos(a0)

.setHeight
	addq.w	#1,hSprBobHeight(a0)

	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	; TODO: optimize - this could draw this bat twice in this frame
	bsr	CookieBlitToScreen

	rts


; Routine that adds 1 pixel-column of gfx to active bat - extending it to the left
PwrWidenHoriz:
	move.l	WideningBat,a0
	addq.l	#1,hSize(a0)
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
	addq.l	#2+2,a1				; Source start 2 words in
	addq.l	#2+1,a2				; Activebob Destination start 3 bytes in
	moveq	#ScrBpl-4,d2

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

	addq.l	#2+2,a1
	addq.l	#2+1,a2

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
	
	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a1
	move.l	GAMESCREEN_BITMAPBASE,a2
	; TODO: optimize - this could draw this bat twice in this frame
	bsr	CookieBlitToScreen

	rts


PwrStartInsanoballz:
	; Add protective tiles

	move.l	AddTileQueuePtr,a0
	move.b	#6,d0			; LightGreyCol

	moveq	#1,d2
	move.w	#1*41+1+4,d1		; Start from 1st row + 4 right
	moveq	#32-1,d7
.addTopHorizLoop
	move.b	d2,(a0)+		; Row
	move.b	d0,(a0)+		; Brick code
	move.w	d1,(a0)+		; Position in GAMEAREA
	addq.w	#1,d1
	dbf	d7,.addTopHorizLoop

	moveq	#3,d2
	move.w	#3*41+1+1,d1		; Start from 3rd row +1 right
	moveq	#26-1,d7
.addVerticalLoop
					; Left tile
	move.b	d2,(a0)+		; Row
	move.b	d0,(a0)+		; Brick code
	move.w	d1,(a0)+		; Position in GAMEAREA

	add.w	#37,d1			; Right tile
	move.b	d2,(a0)+		; Row
	move.b	d0,(a0)+		; Brick code
	move.w	d1,(a0)+		; Position in GAMEAREA
	
	addq.b	#1,d2			; Next row
	addq.w	#4,d1
	dbf	d7,.addVerticalLoop

	moveq	#30,d2
	move.w	#30*41+1+4,d1		; Start from 30th row + 4 right
	moveq	#32-1,d7
.addBottomHorizLoop
	move.b	d2,(a0)+		; Row
	move.b	d0,(a0)+		; Brick code
	move.w	d1,(a0)+		; Position in GAMEAREA
	addq.w	#1,d1
	dbf	d7,.addBottomHorizLoop

	move.l	a0,AddTileQueuePtr	; Update pointer

	move.b	#SLOWING_STATE,InsanoState
	
	rts