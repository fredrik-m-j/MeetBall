; TODO: Create sprite system
InitPowerup:
	; Override/set sprite colors - Sprite 6-7
	lea		CUSTOM+COLOR29,a0 
	move.w	#$511,(a0)+ 
	move.w	#$933,(a0)+ 
	move.w	#$d88,(a0)

	lea		Powerup,a0
	move.l	Copper_SPR7PTL(a5),hSpritePtr(a0)

	rts


PowerupUpdates:
	tst.l	Powerup
	beq		.exit
	
	lea		Powerup,a2

.movePowerupX
	move.w	hSprBobXCurrentSpeed(a2),d0
	beq		.movePowerupY
	add.w	d0,hSprBobTopLeftXPos(a2)
	bra		.checkBounds
.movePowerupY
	move.w	hSprBobYCurrentSpeed(a2),d0
	add.w	d0,hSprBobTopLeftYPos(a2)

.checkBounds
	move.w	hSprBobTopLeftXPos(a2),d0	; Powerup moved out of gamearea?
	cmpi.w	#-15,d0
	ble		.powerupOutOfBounds
	
	cmpi.w	#DISP_WIDTH,d0
	bgt		.powerupOutOfBounds

	move.w	hSprBobTopLeftYPos(a2),d0
	cmpi.w	#-7,d0
	ble		.powerupOutOfBounds

	cmpi.w	#DISP_HEIGHT,d0
	bgt		.powerupOutOfBounds
	bra		.awaitSpriteMove
	
.powerupOutOfBounds
	bsr		ClearPowerup
	bra		.exit

.awaitSpriteMove				; In the rare case we get here early
	cmp.b	#FIRST_Y_POS-1,$dff006	; Check VHPOSR
	blo		.awaitSpriteMove

	btst	#0,FrameTick(a5)		; Even out the load
	beq		.doMove
	bsr		DoSpriteAnim
.doMove
	bsr		MoveSprite

.exit
	rts

; Make powerup appear if conditions are fulfilled.
; In:   a2 = address to ball structure
; In:	a3 = pointer to brick in GAMEAREA
CheckAddPowerup:
	tst.l	Powerup
	bne		.fastExit
	tst.b	InsanoState(a5)
	bpl		.fastExit

	move.l	d2,-(sp)

	jsr		RndB
	and.w	#%1111,d0				; 0 to 15
	add.b	d0,d0
	add.b	d0,d0
	lea		PowerupTable,a1
	move.l	(a1,d0.w),d2
	beq.w	.exit					; No luck

	cmpi.l	#PwrStartMultiball,d2	; Can't have multiple simultaneous multi-ball effect
	bne.s	.checkInsano
	tst.l	AllBalls
	bne.w	.exit
.checkInsano
	cmpi.l	#PwrStartInsanoballz,d2
	bne.s	.setPowerupSprite
	tst.l	AllBalls				; Insanoballz must start from 1 ball
	bne.w	.exit

.setPowerupSprite
	cmpi.l	#PwrStartMultiball,d2
	bne.s	.wideBatSprite
	bsr		SetMultiballPowerupSprite
	bra.s	.createPowerup
.wideBatSprite
	cmpi.l	#PwrStartWideBat,d2
	bne.s	.glueBatSprite
	bsr		SetWideBatPowerupSprite
	bra.s	.createPowerup
.glueBatSprite
	cmpi.l	#PwrStartGluebat,d2
	bne.s	.breachballSprite
	bsr		SetGlueBatPowerupSprite
	bra.s	.createPowerup
.breachballSprite
	cmpi.l	#PwrStartBreachball,d2
	bne.s	.pointsSprite
	bsr		SetBreachballPowerupSprite
	bra.s	.createPowerup
.pointsSprite
	cmpi.l	#PwrExtraPoints,d2
	bne.s	.batspeedSprite
	bsr		SetPointsPowerupSprite
	bra.s	.createPowerup
.batspeedSprite
	cmpi.l	#PwrIncreaseBatspeed,d2
	bne.s	.batGunSprite
	bsr		SetBatspeedPowerupSprite
	bra.s	.createPowerup
.batGunSprite
	cmpi.l	#PwrGun,d2
	bne.s	.insanoballzSprite
	bsr		SetBatGunPowerupSprite
	bra.s	.createPowerup
.insanoballzSprite
	bsr		SetInsanoballzPowerupSprite

.createPowerup
	lea		Powerup,a1
	move.l	d2,hPowerupRoutine(a1)
	move.l  #Spr_Powerup0,hAddress(a1)	; Display it
	clr.b	hIndex(a1)

	bsr		GetCoordsFromGameareaPtr
	move.w  d0,hSprBobTopLeftXPos(a1)
	move.w  d1,hSprBobTopLeftYPos(a1)

	move.l	hPlayerBat(a2),d0

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
	move.l	(sp)+,d2
.fastExit
	rts


ClearPowerup:
	lea		Powerup,a0
	tst.l	(a0)
	beq.s	.exit
	
	clr.l	hSprBobXCurrentSpeed(a0)	; Clear X.w and Y.w speeds
	move.l	hAddress(a0),a0
	clr.l	(a0)					; Disarm sprite
	clr.l	Powerup					; Remove sprite
.exit
	rts

ClearActivePowerupEffects:
	clr.b	WideBatCounter(a5)

	move.b	#INSANOSTATE_INACTIVE,InsanoState(a5)
	move.b  #DEFAULT_INSANODROPS,InsanoDrops(a5)
	move.b  BallspeedFrameCountCopy(a5),BallspeedFrameCount(a5)
	rts

; Adds powerup effect for the player who got the powerup.
; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
CollectPowerup:
	move.l	a2,-(sp)

	move.l	hPowerupRoutine(a0),a2
	jsr		(a2)
	bsr		ClearPowerup
	
	lea		SFX_POWERUP_STRUCT,a0
	jsr		PlaySample

	move.l	(sp)+,a2
	rts

; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
PwrStartMultiball:
	movem.l	a2-a6,-(sp)

	lea		Ball0,a3
	lea		Ball1,a4
	lea		Ball2,a5

	move.l	hPlayerScore(a1),a2		; Update score
	addq.l	#5,(a2)

	move.l	a1,hPlayerBat(a3)		; Set ballowner
	move.l	a1,hPlayerBat(a4)
	move.l	a1,hPlayerBat(a5)

	move.l	hAddress(a3),a6			; Find active ball
	tst.l	(a6)					; ... by checking if current sprite is enabled
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
	lea		AllBalls,a2
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

	bsr		Set3BallColor

	movem.l	(sp)+,a2-a6
	rts


; In:	a1 = adress to bat
PwrExtraPoints:
	move.l	hPlayerScore(a1),a2		; Update score
	move.l	PwrExtraPointsValue(a5),d0
	add.l	d0,(a2)
	rts

; In:	a1 = adress to bat
PwrStartBreachball:
	move.l	hPlayerScore(a1),a2		; Update score
	addq.l	#5,(a2)

	lea		AllBalls+hAllBallsBall0,a2
.ballLoop
	move.l	(a2)+,d1				; Any ball in this slot?
	beq.s	.exit

	move.l	d1,a3
	clr.b	hIndex(a3)				; Turn animation ON

	move.w	hBallEffects(a3),d1
	bset.l	#BALLEFFECTBIT_BREACH,d1
	move.w	d1,hBallEffects(a3)

	bra.s	.ballLoop
.exit
	rts

; In:	a1 = adress to bat
PwrStartGluebat:
	move.l	hPlayerScore(a1),a2		; Update score
	addq.l	#5,(a2)

	move.w	hBatEffects(a1),d1
	bset.l	#BATEFFECTBIT_GLUE,d1
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

	tst.l	hSize(a1)				; Already wide?
	bhi.s	.exit

	cmpi.w	#7,hSprBobHeight(a1)	; Is it a vertical bat?
	bhi.s	.increaseHeight
	move.l	#PwrWidenHoriz,WideningRoutine(a5)
	move.b	#16,WideBatCounter(a5)
	bra.s	.setWidening

.increaseHeight
	move.l	#PwrWidenVert,WideningRoutine(a5)
	move.b	#12,WideBatCounter(a5)

.setWidening
	move.l	a1,WideningBat(a5)
.exit
	rts

; In:	a6 = address to CUSTOM $dff000
PwrWidenVert:
	movem.l	a2-a4,-(sp)

	move.l	WideningBat(a5),a0
	addq.l	#1,hSize(a0)

	cmpa.l	#Bat0,a0
	bne		.bat1
	move.l	Bat0BobPtr(a5),a1
	move.l	Bat0BobMaskPtr(a5),a4
	bra		.prepareBlit
.bat1
	move.l	Bat1BobPtr(a5),a1
	move.l	Bat1BobMaskPtr(a5),a4

.prepareBlit
	move.l	hSize(a0),d1
	add.b	d1,d1
	add.b	d1,d1
	
	lea		BatVertBlitSizes,a3
	move.l	(a3,d1),d1

	move.w	d1,hBobBlitSize(a0)		; Next bat-blits cover +1 line
	swap	d1
	move.w	d1,d3

	add.l	#(RL_SIZE*(12+2)*4),a1	; Source starts after Y offsets

	move.l	hAddress(a0),a2
	addq.l	#2*4,a2					; Destination starts 1 line down
	moveq	#RL_SIZE-2,d2

	bsr		BatExtendVerticalBlitToActiveBob

	move.l	a4,a1
	add.l	#(RL_SIZE*(12+2)*4),a1	; Source starts after Y offsets
	move.l	hSprBobMaskAddress(a0),a2
	addq.l	#2*4,a2

	bsr		BatExtendVerticalBlitToActiveBob


	subq.l	#2*4,hAddress(a0)		; Bob & Mask grew 1 line
	subq.l	#2*4,hSprBobMaskAddress(a0)

	move.b	WideBatCounter(a5),d1
	and.b	#1,d1
	bne		.odd

	subq.w	#1,hSprBobTopLeftYPos(a0)
	bra		.setHeight
.odd
	addq.w	#1,hSprBobBottomRightYPos(a0)

.setHeight
	addq.w	#1,hSprBobHeight(a0)

	move.l	a0,a3
	move.l	GAMESCREEN_PristinePtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2

	; TODO: optimize - this could draw this bat twice in this frame
	bsr		CookieBlitToScreen

	movem.l	(sp)+,a2-a4

	rts


; Routine that adds 1 pixel-column of gfx to active bat - extending it to the left
; In:	a6 = address to CUSTOM $dff000
PwrWidenHoriz:
	movem.l	a2-a4,-(sp)

	move.l	WideningBat(a5),a0
	addq.l	#1,hSize(a0)
	move.l	hAddress(a0),a2

	cmpa.l	#Bat2,a0
	bne.s	.bat3
	move.l	Bat2BobPtr(a5),a1
	move.l	Bat2BobMaskPtr(a5),a4
	bra.s	.prepareBlit
.bat3
	move.l	Bat3BobPtr(a5),a1
	move.l	Bat3BobMaskPtr(a5),a4

.prepareBlit
	addq.l	#2+2,a1					; Source start 2 words in
	addq.l	#2+1,a2					; Activebob Destination start 3 bytes in
	moveq	#RL_SIZE-4,d2

	moveq	#0,d1
	move.b	WideBatCounter(a5),d1

	lea		BatHorizExtendMaskTable,a3
	add.l	d1,a3
	add.l	d1,a3

	ror.l	#4,d1

	move.w	#(64*7*4)+2,d3			; 7 lines, 2 word to blit horizontally

	bsr		BatExtendHorizontalBlitToActiveBob

	move.l	a4,a1
	move.l	hSprBobMaskAddress(a0),a2

	addq.l	#2+2,a1
	addq.l	#2+1,a2

	bsr		BatExtendHorizontalBlitToActiveBob

	subq.w	#1,hBobLeftXOffset(a0)
	
	move.b	WideBatCounter(a5),d1
	and.b	#1,d1
	bne.s	.odd

	subq.w	#1,hSprBobTopLeftXPos(a0)
	bra.s	.setWidth
.odd
	addq.w	#1,hSprBobBottomRightXPos(a0)

.setWidth
	addq.w	#1,hSprBobWidth(a0)
	
	move.l	a0,a3
	move.l	GAMESCREEN_PristinePtr(a5),a4
	move.l	GAMESCREEN_Ptr(a5),a2

	; TODO: optimize - this could draw this bat twice in this frame
	bsr		CookieBlitToScreen

	movem.l	(sp)+,a2-a4

	rts


PwrStartInsanoballz:
	clr.b	Paused(a5)				; Pause while ongoing

	lea		AllBalls+hAllBallsBall0,a0	; Remove any ball effect
	move.l	(a0),a0
	move.l	hSprBobXCurrentSpeed(a0),d2
	move.w	hBallSpeedLevel(a0),d3

	bsr		ResetBallStruct

	move.l	d2,hSprBobXCurrentSpeed(a0)	; Preserve speed
	move.w	d3,hBallSpeedLevel(a0)

	; Add protective tiles
	move.l	AddTileQueuePtr(a5),a0
	move.b	#6,d0					; DarkGreyCol

	moveq	#1,d2
	move.w	#1*41+1+4,d1			; Start from 1st row + 4 right
	moveq	#32-1,d7
.addTopHorizLoop
	move.b	d2,(a0)+				; Row
	move.b	d0,(a0)+				; Brick code
	move.w	d1,(a0)+				; Position in GAMEAREA
	addq.w	#1,d1
	dbf		d7,.addTopHorizLoop

	moveq	#3,d2
	move.w	#3*41+1+1,d1			; Start from 3rd row +1 right
	moveq	#26-1,d7
.addVerticalLoop
					; Left tile
	move.b	d2,(a0)+				; Row
	move.b	d0,(a0)+				; Brick code
	move.w	d1,(a0)+				; Position in GAMEAREA

	add.w	#37,d1					; Right tile
	move.b	d2,(a0)+				; Row
	move.b	d0,(a0)+				; Brick code
	move.w	d1,(a0)+				; Position in GAMEAREA
	
	addq.b	#1,d2					; Next row
	addq.w	#4,d1
	dbf		d7,.addVerticalLoop

	moveq	#30,d2
	move.w	#30*41+1+4,d1			; Start from 30th row + 4 right
	moveq	#32-1,d7
.addBottomHorizLoop
	move.b	d2,(a0)+				; Row
	move.b	d0,(a0)+				; Brick code
	move.w	d1,(a0)+				; Position in GAMEAREA
	addq.w	#1,d1
	dbf		d7,.addBottomHorizLoop

	move.l	a0,AddTileQueuePtr(a5)	; Update pointer

	move.b	#INSANOSTATE_SLOWING,InsanoState(a5)
	
	rts