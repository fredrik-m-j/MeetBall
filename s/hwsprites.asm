; In:	a1 = Copper Pointer
AppendHardwareSprites:

	move.l	#Spr_Bat0,d0
	move.w	#SPR0PTL,(a1)+
	move.l	a1,Copper_SPR0PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.l	a1,Copper_SPR0PTH
	move.w	d0,(a1)+

	move.l	#Spr_Powerup0,d0
	move.w	#SPR1PTL,(a1)+
	move.l	a1,Copper_SPR1PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR1PTH,(a1)+
	move.l	a1,Copper_SPR1PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball0,d0
	move.w	#SPR2PTL,(a1)+
	move.l	a1,Copper_SPR2PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR2PTH,(a1)+
	move.l	a1,Copper_SPR2PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball1,d0
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

	move.l	#Spr_Bat1,d0
	move.w	#SPR5PTL,(a1)+
	move.l	a1,Copper_SPR5PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.l	a1,Copper_SPR5PTH
	move.w	d0,(a1)+

	move.l	#Sprite6,d0
	move.w	#SPR6PTL,(a1)+
	move.l	a1,Copper_SPR6PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR6PTH,(a1)+
	move.l	a1,Copper_SPR6PTH
	move.w	d0,(a1)+

	move.l	#Sprite7,d0
	move.w	#SPR7PTL,(a1)+
	move.l	a1,Copper_SPR7PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR7PTH,(a1)+
	move.l	a1,Copper_SPR7PTH
	move.w	d0,(a1)+

	rts

DrawSprites:
	tst.l	Powerup
	beq.s	.drawBalls

	lea	Powerup,a0
	
	move.w	hSprBobYCurrentSpeed(a0),d0
	add.w	d0,hSprBobTopLeftYPos(a0)

	btst.b	#0,FrameTick		; Don't animate every frame
	beq.s	.plotPowerup

	move.l  hIndex(a0),d0
	cmpi.b	#7,d0
	bne.s	.incPowerupAnim

	move.l  #0,hIndex(a0)		; Reset anim
	bra.s	.animPowerup
.incPowerupAnim
	addq	#1,d0
	move.l	d0,hIndex(a0)

.animPowerup
	add.b	d0,d0			; Look up sprite struct
	add.b	d0,d0
	lea	PowerupMap,a1
	move.l	(a1,d0),d0

	move.l	d0,hAddress(a0)

	move.l	Copper_SPR1PTL,a1
	move.w	d0,(a1)			; New sprite pointers
	swap	d0
	move.w	d0,4(a1)
.plotPowerup
	bsr	PlotSprite

.drawBalls
        move.l  AllBalls,d7
        lea     AllBalls+4,a1
.ballLoop
        move.l  (a1)+,d0		; Any ball in this slot?
	beq.s   .doneBall
	move.l	d0,a0
	bsr	PlotSprite
.doneBall
        dbf	d7,.ballLoop

.exit
	rts

; In:	a0 = sprite handle
PlotSprite:
; Calculate X position
	moveq	#0,d0

	move.w	hSprBobHeight(a0),d0	; Grab height and x,y coordinates
	move.w	hSprBobTopLeftXPos(a0),d1
	move.w	hSprBobTopLeftYPos(a0),d2

	move.l	hAddress(a0),a0		; Point to the sprite in CHIP ram

	addi.w	#DISP_XSTRT,d1	; Translate to sprite coordinate using offset
	btst	#0,d1		; bit basso della coordinata X azzerato?
	beq.s	.clearHStartControlBit
	bset	#0,hControlBits(a0)	; Settiamo il bit basso di HSTART
	bra.s	.setHSTART

.clearHStartControlBit
	bclr	#0,hControlBits(a0)	; Azzeriamo il bit basso di HSTART
.setHSTART
	lsr.w	#1,d1		; SHIFTIAMO, ossia spostiamo di 1 bit a destra
				; il valore di HSTART, per "trasformarlo" nel
				; valore fa porre nel byte HSTART, senza cioe'
				; il bit basso.
	move.b	d1,hHStart(a0)	; Set HSTART

; Calculate Y position
	addi.w	#DISP_YSTRT,d2	; Translate to sprite coordinate using offset
	move.b	d2,hVStart(a0)	; Set VSTART
	btst 	#8,d2
	beq.s	.clearVStartControlBit
	bset.b	#2,hControlBits(a0)
	bra.s	.checkVStop
.clearVStartControlBit
	bclr.b	#2,hControlBits(a0)
.checkVStop
	add.w	d0,d2
	move.b	d2,hVStop(a0)	; Set VSTOP
	btst 	#8,d2
	beq.s	.clearVStopControlBit
	bset.b	#1,hControlBits(a0)
	bra.s	.exit
.clearVStopControlBit
	bclr.b	#1,hControlBits(a0)
.exit
	rts

DisarmAllSprites:
	; Clear player bobs and disarm sprites
	move.l	#0,Spr_Ball0
	move.l	#0,Spr_Ball1
	move.l	#0,Spr_Ball2

	move.l	#0,Spr_Powerup0
	rts