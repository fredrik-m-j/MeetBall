; In:	a1 = Copper Pointer
; Set up hw-sprites in copperlist - no attached sprites.
; During insanoball powerup all balls use same palette.
AppendHardwareSprites:

	move.l	#Spr_Ball0,d0
	move.w	#SPR0PTL,(a1)+
	move.l	a1,Copper_SPR0PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.l	a1,Copper_SPR0PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball3,d0		; Insano
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

	move.l	#Spr_Ball4,d0		; Insano
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

	move.l	#Spr_Ball5,d0		; Insano
	move.w	#SPR5PTL,(a1)+
	move.l	a1,Copper_SPR5PTL
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.l	a1,Copper_SPR5PTH
	move.w	d0,(a1)+

	move.l	#Spr_Ball6,d0		; Insano
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

	rts

DrawSprites:
	tst.l	Powerup
	beq.w	.drawBalls

	lea	Powerup,a0
	bsr	PlotSprite

.drawBalls
        lea     AllBalls+hAllBallsBall0,a1
.ballLoop
        move.l  (a1)+,d0		; Any ball in this slot?
	beq.s   .exit
	move.l	d0,a0

	bsr	PlotBall
	bra.s	.ballLoop
.exit
	rts

SpriteAnim:
	btst.b	#0,FrameTick		; Swap pixels every other frame
	beq.s	.exit

	tst.l	Powerup
	beq.w	.animBalls

	lea	Powerup,a0
	bsr	DoSpriteAnim

.animBalls
        lea     AllBalls+hAllBallsBall0,a1
.ballLoop
        move.l  (a1)+,d0		; Any ball in this slot?
	beq.s   .exit
	move.l	d0,a0

	bsr	DoSpriteAnim
	bra.s	.ballLoop
.exit
	rts

; In:	a0 = sprite handle
DoSpriteAnim:
	tst.b	hIndex(a0)		; Anything to animate?
	bmi.s	.exit

	moveq	#0,d0
	move.b  hIndex(a0),d0
	add.b	d0,d0			; Look up sprite struct
	add.b	d0,d0
	move.l	hSpriteAnimMap(a0),a3
	add.l	d0,a3

	move.l	(a3),hAddress(a0)

	move.l	hSpritePtr(a0),a2
	move.l	(a2),a2

	move.l	(a3),d1
	move.w	d1,(a2)			; New sprite pointers
	swap	d1
	move.w	d1,4(a2)

	move.b	hIndex(a0),d0
	cmp.b	hLastIndex(a0),d0	; Reset anim?
	bne.s	.incAnim

	move.b  #-1,d0			; Reset to 0
.incAnim
	addq.b	#1,d0
	move.b	d0,hIndex(a0)
.exit
	rts


; In:	a0 = sprite handle
PlotBall:
; Calculate X position
	move.l	hSprBobTopLeftXPos(a0),d1	; X & Y coordinates

	; Suspicious - but it works
	lsr.l	#VC_POW,d1		; Convert X and Y virtual coords to screen-coords
	move.w	d1,d2
	swap	d1

	move.l	hAddress(a0),a0		; Point to the sprite in CHIP ram

	addi.w	#DISP_XSTRT-1,d1	; Translate to sprite coordinate using offset
	btst	#0,d1			; bit basso della coordinata X azzerato?
	beq.s	.clearHStartControlBit
	bset	#0,hControlBits(a0)	; Settiamo il bit basso di HSTART
	bra.s	.setHSTART

.clearHStartControlBit
	bclr	#0,hControlBits(a0)	; Azzeriamo il bit basso di HSTART
.setHSTART
	lsr.w	#1,d1			; SHIFTIAMO, ossia spostiamo di 1 bit a destra
					; il valore di HSTART, per "trasformarlo" nel
					; valore fa porre nel byte HSTART, senza cioe'
					; il bit basso.
	move.b	d1,hHStart(a0)		; Set HSTART

; Calculate Y position
	addi.w	#DISP_YSTRT,d2		; Translate to sprite coordinate using offset
	move.b	d2,hVStart(a0)		; Set VSTART
	btst 	#8,d2
	beq.s	.clearVStartControlBit
	bset.b	#2,hControlBits(a0)
	bra.s	.checkVStop
.clearVStartControlBit
	bclr.b	#2,hControlBits(a0)
.checkVStop
	add.w	#BallDiameter,d2
	move.b	d2,hVStop(a0)		; Set VSTOP
	btst 	#8,d2
	beq.s	.clearVStopControlBit
	bset.b	#1,hControlBits(a0)
	bra.s	.exit
.clearVStopControlBit
	bclr.b	#1,hControlBits(a0)
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

	addi.w	#DISP_XSTRT-1,d1	; Translate to sprite coordinate using offset
	btst	#0,d1			; bit basso della coordinata X azzerato?
	beq.s	.clearHStartControlBit
	bset	#0,hControlBits(a0)	; Settiamo il bit basso di HSTART
	bra.s	.setHSTART

.clearHStartControlBit
	bclr	#0,hControlBits(a0)	; Azzeriamo il bit basso di HSTART
.setHSTART
	lsr.w	#1,d1			; SHIFTIAMO, ossia spostiamo di 1 bit a destra
					; il valore di HSTART, per "trasformarlo" nel
					; valore fa porre nel byte HSTART, senza cioe'
					; il bit basso.
	move.b	d1,hHStart(a0)		; Set HSTART

; Calculate Y position
	addi.w	#DISP_YSTRT,d2		; Translate to sprite coordinate using offset
	move.b	d2,hVStart(a0)		; Set VSTART
	btst 	#8,d2
	beq.s	.clearVStartControlBit
	bset.b	#2,hControlBits(a0)
	bra.s	.checkVStop
.clearVStartControlBit
	bclr.b	#2,hControlBits(a0)
.checkVStop
	add.w	d0,d2
	move.b	d2,hVStop(a0)		; Set VSTOP
	btst 	#8,d2
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
	rts