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

	move.l	#Sprite3,d0
	move.w	#SPR3PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR3PTH,(a1)+
	move.w	d0,(a1)+

	move.l	#Sprite4,d0
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
	movem.l	d0-d2/a0,-(sp)

	lea	Ball0,a0
	bsr	PlotSprite

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
	movem.l	(sp)+,d0-d2/a0
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



        SECTION Sprites, DATA_C
	
;------ Bat RIGHT
Spr_Bat0:
	dc.b $30	; VSTART
	dc.b $90	; HSTART
	dc.b $3d	; VSTOP
	dc.b $00	; Control bits

	dc.w	$3e00,$0200
	dc.w	$7400,$0e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$a400,$5e00
	dc.w	$c200,$3e00
	dc.w	$7400,$0e00
	dc.w	$3e00,$0200

        dc.w	0,0     ;End of Sprite
        even
;------
Sprite1:
	dc.w 0,0        ; End of Sprite
	even
;------ Ball
Spr_Ball0:
	dc.b $2c	; VSTART
	dc.b $40	; HSTART
	dc.b $33	; VSTOP
	dc.b $00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w 0,0        ; End of Sprite
	even
;------ Bat BOTTOM
Sprite3:
	; dc.b $00	; VSTART
	; dc.b $00	; HSTART
	; dc.b $00	; VSTOP
	; dc.b $00	; Control bits
	; dc.w	$3fff,$0000
	; dc.w	$6aaa,$1555
	; dc.w	$d555,$2aaa
	; dc.w	$c000,$3fff
	; dc.w	$8000,$7fff
	; dc.w	$d555,$7fff
	; dc.w	$aaaa,$ffff
	; dc.w	$ffff,$0000
	; dc.w	$aaaa,$5555
	; dc.w	$5555,$aaaa
	; dc.w	$0000,$ffff
	; dc.w	$0000,$ffff
	; dc.w	$5555,$ffff
	; dc.w	$aaaa,$ffff
	; dc.w	$fe00,$0000
	; dc.w	$ab00,$5400
	; dc.w	$5580,$aa00
	; dc.w	$0180,$fe00
	; dc.w	$0080,$ff00
	; dc.w	$5580,$ff00
	; dc.w	$ab80,$fe80
	dc.w 0,0        ; End of Sprite
	even
;-------
Sprite4:
	dc.w 0,0        ; End of Sprite
	even
;------ Bat LEFT
Spr_Bat1:
	dc.b $00	; VSTART
	dc.b $00	; HSTART
	dc.b $00	; VSTOP
	dc.b $00	; Control bits
	dc.w	$f800,$8000
	dc.w	$5c00,$e000
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$4a00,$f400
	dc.w	$8600,$f800
	dc.w	$5c00,$e000
	dc.w	$f800,$8000
	
	dc.w	0,0    ;End of Sprite
        even
;------ Bat TOP
Sprite6:
	; dc.b $00	; VSTART
	; dc.b $00	; HSTART
	; dc.b $00	; VSTOP
	; dc.b $00	; Control bits
	; dc.w	$3fff,$0000
	; dc.w	$6aaa,$1555
	; dc.w	$d555,$2aaa
	; dc.w	$c000,$3fff
	; dc.w	$8000,$7fff
	; dc.w	$d555,$7fff
	; dc.w	$aaaa,$ffff
	; dc.w	$ffff,$0000
	; dc.w	$aaaa,$5555
	; dc.w	$5555,$aaaa
	; dc.w	$0000,$ffff
	; dc.w	$0000,$ffff
	; dc.w	$5555,$ffff
	; dc.w	$aaaa,$ffff
	; dc.w	$fe00,$0000
	; dc.w	$ab00,$5400
	; dc.w	$5580,$aa00
	; dc.w	$0180,$fe00
	; dc.w	$0080,$ff00
	; dc.w	$5580,$ff00
	; dc.w	$ab80,$fe80
	dc.w 0,0        ; End of Sprite
	even
;-------
Sprite7:
	dc.w $2a20,$3c00; Out of range position
	dc.w 0,0
        dc.w 0,0        ; End of Sprites
        even
;-------
        section	MyGameo,code