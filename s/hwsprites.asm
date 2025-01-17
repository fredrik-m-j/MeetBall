; In:	a1 = Copper Pointer
; Set up hw-sprites in copperlist - no attached sprites.
; During insanoball powerup all balls use same palette.
AppendGameSprites:
	move.l	#Spr_Ball0,d0
	move.w	#SPR0PTL,(a1)+
	move.l	a1,Copper_SPR0PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.l	a1,Copper_SPR0PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball3,d0			; Insano
	move.w	#SPR1PTL,(a1)+
	move.l	a1,Copper_SPR1PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR1PTH,(a1)+
	move.l	a1,Copper_SPR1PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball1,d0
	move.w	#SPR2PTL,(a1)+
	move.l	a1,Copper_SPR2PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR2PTH,(a1)+
	move.l	a1,Copper_SPR2PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball4,d0			; Insano
	move.w	#SPR3PTL,(a1)+
	move.l	a1,Copper_SPR3PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR3PTH,(a1)+
	move.l	a1,Copper_SPR3PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball2,d0
	move.w	#SPR4PTL,(a1)+
	move.l	a1,Copper_SPR4PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR4PTH,(a1)+
	move.l	a1,Copper_SPR4PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball5,d0			; Insano
	move.w	#SPR5PTL,(a1)+
	move.l	a1,Copper_SPR5PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.l	a1,Copper_SPR5PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball6,d0			; Insano
	move.w	#SPR6PTL,(a1)+
	move.l	a1,Copper_SPR6PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR6PTH,(a1)+
	move.l	a1,Copper_SPR6PTH
	move.w	d0,(a1)+

	move.l	#Spr_Powerup0,d0
	move.w	#SPR7PTL,(a1)+
	move.l	a1,Copper_SPR7PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR7PTH,(a1)+
	move.l	a1,Copper_SPR7PTH
	move.w	d0,(a1)+

	move.l	#COPPERLIST_END,(a1)
	rts

; Set up hw-sprites in copperlist - no attached sprites.
; Out:	a1 = Copper Pointer to end of MISC copperlist.
AppendDisarmedSprites:
	move.l	END_COPPTR_MISC,a1
	clr.l	Spr_Ball1
	; Not in use
	move.l	#Spr_Ball1,d0			; Use Ball1 as dummy
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
	move.w	#SPR7PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR7PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#COPPERLIST_END,(a1)
	rts


; In:	a2 = sprite handle
DoSpriteAnim:
	tst.b	hIndex(a2)				; Anything to animate?
	bmi.s	.exit

	moveq	#0,d0
	move.b	hIndex(a2),d0
	add.b	d0,d0					; Look up sprite struct
	add.b	d0,d0
	move.l	hSpriteAnimMap(a2),a0
	add.l	d0,a0

	move.l	(a0),hAddress(a2)

	move.l	hSpritePtr(a2),a1
	move.l	(a1),a1

	move.l	(a0),d1
	move.w	d1,(a1)					; New sprite pointers
	swap	d1
	move.w	d1,4(a1)

	move.b	hIndex(a2),d0
	cmp.b	hLastIndex(a2),d0		; Reset anim?
	bne.s	.incAnim

	move.b	#-1,d0					; Reset to 0
.incAnim
	addq.b	#1,d0
	move.b	d0,hIndex(a2)
.exit
	rts


; In:	a2 = sprite handle
MoveBallSprite:
; Calculate X position
	move.l	hSprBobTopLeftXPos(a2),d1	; X & Y coordinates

	; Suspicious - but it works
	lsr.l	#VC_POW,d1				; Convert X and Y virtual coords to screen-coords
	move.w	d1,d2
	swap	d1

	move.l	hAddress(a2),a0			; Point to the sprite in CHIP ram

	addi.w	#DISP_XSTRT-1,d1		; Translate to sprite coordinate using offset
	btst	#0,d1					; bit basso della coordinata X azzerato?
	beq.s	.clearHStartControlBit
	bset	#0,hControlBits(a0)		; Settiamo il bit basso di HSTART
	bra.s	.setHSTART

.clearHStartControlBit
	bclr	#0,hControlBits(a0)		; Azzeriamo il bit basso di HSTART
.setHSTART
	lsr.w	#1,d1					; SHIFTIAMO, ossia spostiamo di 1 bit a destra
									; il valore di HSTART, per "trasformarlo" nel
									; valore fa porre nel byte HSTART, senza cioe'
									; il bit basso.
	move.b	d1,hHStart(a0)			; Set HSTART

; Calculate Y position
	addi.w	#DISP_YSTRT,d2			; Translate to sprite coordinate using offset
	move.b	d2,hVStart(a0)			; Set VSTART
	btst	#8,d2
	beq.s	.clearVStartControlBit
	bset.b	#2,hControlBits(a0)
	bra.s	.checkVStop
.clearVStartControlBit
	bclr.b	#2,hControlBits(a0)
.checkVStop
	addq.w	#BallDiameter,d2
	move.b	d2,hVStop(a0)			; Set VSTOP
	btst	#8,d2
	beq.s	.clearVStopControlBit
	bset.b	#1,hControlBits(a0)
	bra.s	.exit
.clearVStopControlBit
	bclr.b	#1,hControlBits(a0)
.exit
	rts


; In:	a2 = sprite handle
MoveSprite:
; Calculate X position
	moveq	#0,d0

	move.w	hSprBobHeight(a2),d0	; Grab height and x,y coordinates
	move.w	hSprBobTopLeftXPos(a2),d1
	move.w	hSprBobTopLeftYPos(a2),d2

	move.l	hAddress(a2),a0			; Point to the sprite in CHIP ram

	addi.w	#DISP_XSTRT-1,d1		; Translate to sprite coordinate using offset
	btst	#0,d1					; bit basso della coordinata X azzerato?
	beq.s	.clearHStartControlBit
	bset	#0,hControlBits(a0)		; Settiamo il bit basso di HSTART
	bra.s	.setHSTART

.clearHStartControlBit
	bclr	#0,hControlBits(a0)		; Azzeriamo il bit basso di HSTART
.setHSTART
	lsr.w	#1,d1					; SHIFTIAMO, ossia spostiamo di 1 bit a destra
									; il valore di HSTART, per "trasformarlo" nel
									; valore fa porre nel byte HSTART, senza cioe'
									; il bit basso.
	move.b	d1,hHStart(a0)			; Set HSTART

; Calculate Y position
	addi.w	#DISP_YSTRT,d2			; Translate to sprite coordinate using offset
	move.b	d2,hVStart(a0)			; Set VSTART
	btst	#8,d2
	beq.s	.clearVStartControlBit
	bset.b	#2,hControlBits(a0)
	bra.s	.checkVStop
.clearVStartControlBit
	bclr.b	#2,hControlBits(a0)
.checkVStop
	add.w	d0,d2
	move.b	d2,hVStop(a0)			; Set VSTOP
	btst	#8,d2
	beq.s	.clearVStopControlBit
	bset.b	#1,hControlBits(a0)
	bra.s	.exit
.clearVStopControlBit
	bclr.b	#1,hControlBits(a0)
.exit
	rts

DisarmAllSprites:
	clr.l	Spr_Ball0
	clr.l	Spr_Ball1
	clr.l	Spr_Ball2
	clr.l	Spr_Ball3
	clr.l	Spr_Ball4
	clr.l	Spr_Ball5
	clr.l	Spr_Ball6
	clr.l	Spr_Ball7
	clr.l	Spr_Powerup0
	clr.l	Spr_Powerup1
	clr.l	Spr_Powerup2
	clr.l	Spr_Powerup3
	clr.l	Spr_Powerup4
	clr.l	Spr_Powerup5
	clr.l	Spr_Powerup6
	clr.l	Spr_Powerup7
	clr.l	Spr_Powerup8

	clr.l	Spr_Ball0Anim0
	clr.l	Spr_Ball0Anim1
	clr.l	Spr_Ball0Anim2
	clr.l	Spr_Ball0Anim3
	clr.l	Spr_Ball0Anim4
	clr.l	Spr_Ball0Anim5
	clr.l	Spr_Ball0Anim6
	clr.l	Spr_Ball0Anim7
	clr.l	Spr_Ball1Anim0
	clr.l	Spr_Ball1Anim1
	clr.l	Spr_Ball1Anim2
	clr.l	Spr_Ball1Anim3
	clr.l	Spr_Ball1Anim4
	clr.l	Spr_Ball1Anim5
	clr.l	Spr_Ball1Anim6
	clr.l	Spr_Ball1Anim7
	clr.l	Spr_Ball2Anim0
	clr.l	Spr_Ball2Anim1
	clr.l	Spr_Ball2Anim2
	clr.l	Spr_Ball2Anim3
	clr.l	Spr_Ball2Anim4
	clr.l	Spr_Ball2Anim5
	clr.l	Spr_Ball2Anim6
	clr.l	Spr_Ball2Anim7
	rts


SetMultiballPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0e90,(a0)+
	move.w	#$0a70,(a0)+
	move.w	#$0fec,(a0)

	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Multiball,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	rts

SetGlueBatPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0171,(a0)+
	move.w	#$03b3,(a0)+
	move.w	#$0bfb,(a0)

	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Glue,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1

	rts

SetWideBatPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0117,(a0)+
	move.w	#$033b,(a0)+
	move.w	#$088f,(a0)

	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_WideBat,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1

	rts

SetBreachballPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0820,(a0)+
	move.w	#$0e30,(a0)+
	move.w	#$0fa5,(a0)

	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Breachball,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1

	rts
SetPointsPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0334,(a0)+
	move.w	#$0668,(a0)+
	move.w	#$0bbe,(a0)

	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Score,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1

	rts
SetBatspeedPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$033b,(a0)+
	move.w	#$066e,(a0)+
	move.w	#$0bbf,(a0)

	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Batspeed,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	rts

SetBatGunPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0a2a,(a0)+
	move.w	#$0e3e,(a0)+
	move.w	#$0fbf,(a0)

	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Gun,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	rts

SetInsanoballzPowerupSprite:
	lea		CUSTOM+COLOR29,a0 
	move.w	#$0060,(a0)+
	move.w	#$04a4,(a0)+
	move.w	#$0efe,(a0)

	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup0+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup1+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup2+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup3+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup4+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup5+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup6+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup7+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	lea		Spr_Powerup_Insanoballs,a0
	lea		Spr_Powerup8+4+4,a1
	moveq	#8,d0
	LETTRCPY	a0,a1,d0,d1
	rts