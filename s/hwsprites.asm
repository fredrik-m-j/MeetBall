; In:	a1 = Copper Pointer
AppendHardwareSprites:

	move.l	#Spr_Bat0,d0
	move.w	#SPR0PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#Sprite1,d0
	move.w	#SPR1PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR1PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#Spr_Ball0,d0
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

	move.l	#Spr_Ball2,d0
	move.w	#SPR4PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR4PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#Spr_Bat1,d0
	move.w	#SPR5PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#Sprite6,d0
	move.w	#SPR6PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR6PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#Sprite7,d0
	move.w	#SPR7PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR7PTH,(a1)+
	move.w	d0,(a1)+

	rts

DrawSprites:
	; movem.l	d0-d2/a0,-(sp)

        move.l  AllBalls,d7
        lea     AllBalls+4,a1
.ballLoop
        move.l  (a1)+,d0		; Any ball in this slot?
	beq.s   .doneBall
	move.l	d0,a0
	bsr	PlotSprite
.doneBall
        dbf	d7,.ballLoop


	tst.b	Player0Enabled
	bmi.s	.isPlayer1Enabled
	lea	Bat0,a0
	bsr	PlotSprite
.isPlayer1Enabled
	tst.b	Player1Enabled
	bmi.s	.exit
	lea	Bat1,a0
	bsr	PlotSprite
.exit
	; movem.l	(sp)+,d0-d2/a0
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