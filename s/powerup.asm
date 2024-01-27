; TODO: Create sprite system
InitPowerupPalette:
	; Override/set sprite colors - Sprite 6-7
	lea     CUSTOM+COLOR29,a0 
	move.w 	#$511,(a0)+ 
	move.w 	#$933,(a0)+ 
	move.w 	#$d88,(a0)

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
; In:   a2 = address to ball structure
; In	a5 = pointer to brick in GAMEAREA
CheckAddPowerup:
	tst.l	Powerup
	bne	.fastExit
	tst.b	InsanoState
	bpl	.fastExit

	move.l	d2,-(sp)

	jsr	RndB
	and.w	#%1111,d0		; 0 to 15
	add.b	d0,d0
	add.b	d0,d0
	lea	PowerupTable,a1
	move.l	(a1,d0.w),d2
	beq.w	.exit			; No luck

	cmpi.l	#PwrStartMultiball,d2	; Can't have multiple simultaneous multi-ball effect
	bne.s	.checkInsano
	tst.l	AllBalls
	bne.w	.exit
.checkInsano
	cmpi.l	#PwrStartInsanoballz,d2
	bne.s	.setPowerupSprite
	tst.l	AllBalls		; Insanoballz must start from 1 ball
	bne.w	.exit

.setPowerupSprite
	cmpi.l	#PwrStartMultiball,d2
	bne.s	.wideBatSprite
	bsr	SetMultiballPowerupSprite
	bra.s	.createPowerup
.wideBatSprite
	cmpi.l	#PwrStartWideBat,d2
	bne.s	.glueBatSprite
	bsr	SetWideBatPowerupSprite
	bra.s	.createPowerup
.glueBatSprite
	cmpi.l	#PwrStartGluebat,d2
	bne.s	.breachballSprite
	bsr	SetGlueBatPowerupSprite
	bra.s	.createPowerup
.breachballSprite
	cmpi.l	#PwrStartBreachball,d2
	bne.s	.pointsSprite
	bsr	SetBreachballPowerupSprite
	bra.s	.createPowerup
.pointsSprite
	cmpi.l	#PwrExtraPoints,d2
	bne.s	.batspeedSprite
	bsr	SetPointsPowerupSprite
	bra.s	.createPowerup
.batspeedSprite
	cmpi.l	#PwrIncreaseBatspeed,d2
	bne.s	.batGunSprite
	bsr	SetBatspeedPowerupSprite
	bra.s	.createPowerup
.batGunSprite
	cmpi.l	#PwrGun,d2
	bne.s	.insanoballzSprite
	bsr	SetBatGunPowerupSprite
	bra.s	.createPowerup
.insanoballzSprite
	bsr	SetInsanoballzPowerupSprite

.createPowerup
        lea     Powerup,a1
	move.l	d2,hPowerupRoutine(a1)
        move.l  #Spr_Powerup0,hAddress(a1)	; Display it
        clr.b	hIndex(a1)

	bsr	GetCoordsFromGameareaPtr
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
	move.b  #DEFAULT_INSANODROPS,InsanoDrops
	move.b  BallspeedFrameCountCopy,BallspeedFrameCount
	rts

; Adds powerup effect for the player who got the powerup.
; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
CollectPowerup:
	move.l	a2,-(sp)

	move.l	hPowerupRoutine(a0),a2
	jsr	(a2)
	bsr	ClearPowerup
	
	lea	SFX_POWERUP_STRUCT,a0
	jsr     PlaySample

	move.l	(sp)+,a2
	rts

; In:	a0 = adress to powerup structure
; In:	a1 = adress to bat
PwrStartMultiball:
	movem.l a2-a6,-(sp)

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

	movem.l (sp)+,a2-a6
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

	tst.l	hSize(a1)			; Already wide?
	bhi.s	.exit

	cmpi.w	#7,hSprBobHeight(a1)		; Is it a vertical bat?
	bhi.s	.increaseHeight
	move.l	#PwrWidenHoriz,WideningRoutine
	move.b	#16,WideBatCounter
	bra.s	.setWidening

.increaseHeight
	move.l	#PwrWidenVert,WideningRoutine
	move.b	#12,WideBatCounter

.setWidening
	move.l	a1,WideningBat
.exit
	rts


PwrWidenVert:
	movem.l	a3-a6,-(sp)

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

	move.l	a0,a3
	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a4
	move.l	GAMESCREEN_BITMAPBASE,a5
	lea	CUSTOM,a6

	; TODO: optimize - this could draw this bat twice in this frame
	bsr	CookieBlitToScreen

	movem.l	(sp)+,a3-a6

	rts


; Routine that adds 1 pixel-column of gfx to active bat - extending it to the left
PwrWidenHoriz:
	movem.l	a3-a6,-(sp)

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
	
	move.l	a0,a3
	move.l	GAMESCREEN_BITMAPBASE_ORIGINAL,a4
	move.l	GAMESCREEN_BITMAPBASE,a5
	lea	CUSTOM,a6

	; TODO: optimize - this could draw this bat twice in this frame
	bsr	CookieBlitToScreen

	movem.l	(sp)+,a3-a6

	rts


PwrStartInsanoballz:
	lea	AllBalls+hAllBallsBall0,a0	; Remove any ball effect
	move.l	(a0),a0
        move.l	hSprBobXCurrentSpeed(a0),d2
        move.w	hBallSpeedLevel(a0),d3

	bsr	ResetBallStruct

        move.l	d2,hSprBobXCurrentSpeed(a0)	; Preserve speed
        move.w	d3,hBallSpeedLevel(a0)

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


ShowPowerups:
	move.l	a6,-(sp)

	lea 	CUSTOM,a6

        clr.b   FrameTick
        move.b  #8,AttractCount

	bsr	ClearBackscreen
	bsr	DrawEscButtonToBackScreen
	bsr	DrawPowerupTexts

	move.w	#%10,$dff02e		; Enable CDANG bit to do blitting from copperlist

	bsr	AppendPowerupBlits
	move.l	COPPTR_MISC,a1
	jsr	LoadCopper

.attractPowerupLoop
        addq.b  #1,FrameTick
        cmpi.b  #50,FrameTick
        blo.s   .viewAttract
        clr.b   FrameTick

        addq.b  #1,AttractTick
        bsr     HiscoreToggleFireToStart

	subq.b	#1,AttractCount
	beq     .exitAttract

.viewAttract
        WAITLASTLINE	d0

	tst.b	KEYARRAY+KEY_ESCAPE     ; Got to menu on ESC?
	bne.s	.exitAttract

	btst.b	#0,FrameTick		; Swap pixels every other frame
	beq.s	.checkFire
	bsr     AnimatePowerupFrame
.checkFire
	bsr	CheckFirebuttons
	tst.b	d0                      ; Got to menu on FIRE?
        bne.s   .attractPowerupLoop
.exitAttract
        move.l	COPPTR_MISC,a0
        move.l	hAddress(a0),a0
	lea	hColor00(a0),a0
	move.l  a0,-(sp)
	jsr     SimpleFadeOut

	WAITVBL

	move.l	END_COPPTR_MISC,a0
	move.l	#COPPERLIST_END,(a0)	; Cut off all the blitting stuff for safe transition
	move.w	#%0,CUSTOM+COPCON	; Restore CDANG bit

	bsr	AppendDisarmedSprites	; Prevent spriteflicker on next screen

	bsr	ClearPowerup

	move.l  (sp)+,a0
        jsr	ResetFadePalette

	move.l	(sp)+,a6
	rts

; Copies animation frames into Spr_Powerup that is being displayed.
AnimatePowerupFrame:
	moveq	#0,d0			; Find sprite color data
	move.b	PowerupFrameCount,d0
	mulu	#SIZEOF_POWERUPSPRITE,d0
	addq.w	#4,d0			; Skip CTRL words

	lea	Spr_Powerup,a1
	addq.l	#4,a1			; Skip CTRL words

	lea	Spr_Powerup0,a0		; Powerup0 = first frame
	add.l	d0,a0

	move.l	(a0)+,(a1)+		; 1st line
	move.l	(a0)+,(a1)+		; 2nd line

	move.w	#6,d0
.l					; line 3-9
	move.l	(a0)+,d1
	and.l   #%11111111111111111100000001111111,d1
	move.l	d1,(a1)+
	dbf	d0,.l

	move.l	(a0)+,(a1)+		; 10th line
	move.l	(a0)+,(a1)+		; 11th line

	cmp.b	#LASTPOWERUPINDEX,PowerupFrameCount
	beq	.reset
	bne	.done
.reset
	move.b	#-1,PowerupFrameCount
.done
	addq.b	#1,PowerupFrameCount
	rts


; Set up one powerup sprite that gets blit-updated in copperlist - no attached sprites.
; Minterm - see https://youtu.be/0KhiHOfmeLw?t=1509
;	Bit	Channel
;		ABC ->	D (this one yield A OR B)
;
;	0	000	0
;	1	001	0
;	2	010	1
;	3	011	1
;	4	100	1
;	5	101	1
;	6	110	1
;	7	111	1
AppendPowerupBlits:
	move.l	END_COPPTR_MISC,a1

	move.l	#Spr_Ball1,d0			; Disarm other sprites using Ball1 as dummy
	move.w	#SPR0PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR1PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR1PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR2PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR2PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR3PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR3PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR4PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR4PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR5PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR6PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR6PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0

	; Calculate start of "background"
	move.l	#Spr_LetterFrame+2,d0		; +2 = 2nd bitplane
	move.l	#BLTBPTH<<16,d3
	move.l	#BLTBPTL<<16,d4
	add.w	d0,d4
	swap	d0
	add.w	d0,d3

	; Calculate start of destination
	move.l	#Spr_Letter+2,d0		; +2 = 2nd bitplane
	move.l	#BLTDPTH<<16,d5
	move.l	#BLTDPTL<<16,d6
	add.w	d0,d6
	swap	d0
	add.w	d0,d5

	; Multiball
	move.l	#$2c3f7ffe,(a1)+		; WAIT for pos & bliter finished
	move.l	#BLTCON0<<16+$0dfc,(a1)+	; Set up A OR B blit.
	move.l	#BLTCON1<<16+$0000,(a1)+
	move.l	#BLTAFWM<<16+$ffff,(a1)+
	move.l	#BLTALWM<<16+$ffff,(a1)+
	move.l	#BLTAMOD<<16+$0002,(a1)+
	move.l	#BLTBMOD<<16+$0002,(a1)+
	move.l	#BLTDMOD<<16+$0002,(a1)+

	move.l	#Spr_Powerup_Multiball+2,d0	; +2 = 2nd bitplane
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+

	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0a70,(a1)+
	move.l	#COLOR30<<16+$0e90,(a1)+
	move.l	#COLOR31<<16+$0fec,(a1)+
	move.l	#SPR7POS<<16+$5150,(a1)+
	move.l	#SPR7CTL<<16+$5d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Glue
	move.l	#$603f7ffe,(a1)+		; WAIT for pos & bliter finished
	; move.l	#BLTCON0<<16+$0dfc,(a1)+	; Set up A OR B blit.
	; move.l	#BLTCON1<<16+$0000,(a1)+
	; move.l	#BLTAFWM<<16+$ffff,(a1)+
	; move.l	#BLTALWM<<16+$ffff,(a1)+
	; move.l	#BLTAMOD<<16+$0002,(a1)+
	; move.l	#BLTBMOD<<16+$0002,(a1)+
	; move.l	#BLTDMOD<<16+$0002,(a1)+

	move.l	#Spr_Powerup_Glue+2,d0	; +2 = 2nd bitplane
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0171,(a1)+
	move.l	#COLOR30<<16+$03b3,(a1)+
	move.l	#COLOR31<<16+$0bfb,(a1)+
	move.l	#SPR7POS<<16+$6150,(a1)+
	move.l	#SPR7CTL<<16+$6d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Widebat
	move.l	#$6d3f7ffe,(a1)+

	move.l	#Spr_Powerup_WideBat+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0117,(a1)+
	move.l	#COLOR30<<16+$033b,(a1)+
	move.l	#COLOR31<<16+$088f,(a1)+
	move.l	#SPR7POS<<16+$7150,(a1)+
	move.l	#SPR7CTL<<16+$7d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Breachball
	move.l	#$7d3f7ffe,(a1)+

	move.l	#Spr_Powerup_Breachball+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0820,(a1)+
	move.l	#COLOR30<<16+$0e30,(a1)+
	move.l	#COLOR31<<16+$0fa5,(a1)+
	move.l	#SPR7POS<<16+$8150,(a1)+
	move.l	#SPR7CTL<<16+$8d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Points
	move.l	#$8d3f7ffe,(a1)+

	move.l	#Spr_Powerup_Score+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0334,(a1)+
	move.l	#COLOR30<<16+$0668,(a1)+
	move.l	#COLOR31<<16+$0bbe,(a1)+
	move.l	#SPR7POS<<16+$9150,(a1)+
	move.l	#SPR7CTL<<16+$9d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Bat speedup
	move.l	#$9d3f7ffe,(a1)+

	move.l	#Spr_Powerup_Batspeed+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$033b,(a1)+
	move.l	#COLOR30<<16+$066e,(a1)+
	move.l	#COLOR31<<16+$0bbf,(a1)+
	move.l	#SPR7POS<<16+$a150,(a1)+
	move.l	#SPR7CTL<<16+$ad00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Gun
	move.l	#$ad3f7ffe,(a1)+

	move.l	#Spr_Powerup_Gun+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0a2a,(a1)+
	move.l	#COLOR30<<16+$0e3e,(a1)+
	move.l	#COLOR31<<16+$0fbf,(a1)+
	move.l	#SPR7POS<<16+$b150,(a1)+
	move.l	#SPR7CTL<<16+$bd00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	; Insanoballz
	move.l	#$bd3f7ffe,(a1)+

	move.l	#Spr_Powerup_Insanoballs+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+			; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+			; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+			; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0060,(a1)+
	move.l	#COLOR30<<16+$04a4,(a1)+
	move.l	#COLOR31<<16+$0efe,(a1)+
	move.l	#SPR7POS<<16+$c150,(a1)+
	move.l	#SPR7CTL<<16+$cd00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+			; Reset sprite pointer
	move.l	d2,(a1)+

	move.l	#COPPERLIST_END,(a1)

	rts

DrawPowerupTexts:
	lea     STRINGBUFFER,a1

	lea	POW_POWERUPS0_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*20*4)+4,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer
	lea     POW_POWERUPS1_STR,a0
        COPYSTR a0,a1
        add.l 	#(ScrBpl*7*4),a2
        bsr     DrawStringBuffer


        lea     POW_MULTIBALL_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*0)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_GLUE_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*1)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_WIDE_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*2)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_BREACH_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*3)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_POINTS_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*4)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_SPEEDUP_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*5)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_GUN_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*6)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

        lea     POW_INSANO_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*(39+16*7)*4)+7,a2
        moveq   #ScrBpl-20,d5
        move.w  #(64*7*4)+10,d6
        bsr     DrawStringBuffer

	rts

PowerupToggleFireToStart:
	btst	#0,AttractTick
	bne	.off
	bsr	HiscoreDrawFireToStartText
	bra	.done
.off
	bsr	HiscoreClearFireToStartText
.done
	rts