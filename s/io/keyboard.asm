KEYARRAY:	dcb.b   $68,$0

; CREDITS
; Author:	???
;		Posted by Graeme Cowie (Mcgeezer)
;		https://eab.abime.net/showpost.php?p=1411198&postcount=3
;		https://mcgeezer.itch.io
; History: 
;		Feb 2022
;		* Added needed KEYARRAY
;		* Clear d0 before reading Serial Shift Data Register / keycode

; Keyboard handler routine.
Level2IntHandler:	
	movem.l	d0-d1/a0-a1/a6,-(sp)

	lea		CUSTOM,a6
	move.w	INTREQR(a6),d0
	btst	#INTB_PORTS,d0
	beq		.end
	
; Ports generated interrupt
	lea		CIAA,a1
	btst	#CIAICRB_SP,ciaicr(a1)
	beq		.end

;read key and store him
	moveq	#0,d0
	move.b	ciasdr(a1),d0			; Serial Shift Data Register, Keycode is dumped into here
						; and then an IRQ2 generated.
	or.b	#CIACRAF_SPMODE,ciacra(a1)
	not.b	d0
	ror.b	#1,d0
	spl		d1
	and.b	#$7f,d0
	
	lea		KEYARRAY(pc),a0
	move.b	d1,(a0,d0.w)			; Set $ff on KeyDown, $0 on on KeyUp

;Wait 3 lines for handshake.
	moveq	#3-1,d1
.wait1	
	move.b	VHPOSR(a6),d0
.wait2
	cmp.b	VHPOSR(a6),d0
	beq.s	.wait2
	dbf		d1,.wait1

;set input mode
	and.b	#~(CIACRAF_SPMODE),ciacra(a1)

.end
	move.w	#INTF_PORTS,INTREQ(a6)
	tst.w	INTREQR(a6)
	movem.l	(sp)+,d0-d1/a0-a1/a6
	rte


; In:	d0 = UP key
; In:	d1 = DOWN key
; Out:	d3 = Joystic direction bits
DetectUpDown:
	move.b	#JOY_NOTHING,d3

	lea		KEYARRAY(pc),a0
	tst.b	(a0,d0.w)
	beq.s	.checkDown

	move.b	#JOY_UP,d3
	bra.s	.done
.checkDown
	tst.b	(a0,d1.w)
	beq.s	.done

	move.b	#JOY_DOWN,d3
.done
	rts

; In:	d0 = LEFT key
; In:	d1 = RIGHT key
; Out:	d3 = Joystic direction bits
DetectLeftRight:
	move.b	#JOY_NOTHING,d3

	lea		KEYARRAY(pc),a0
	tst.b	(a0,d0.w)
	beq.s	.checkRight

	move.b	#JOY_LEFT,d3
	bra.s	.done
.checkRight
	tst.b	(a0,d1.w)
	beq.s	.done

	move.b	#JOY_RIGHT,d3
.done
	rts

; Somehow this is needed to avoid infinite loop in AwaitAllFirebuttonsReleased.
ClearKeyboardFire:
	clr.b	KEYARRAY+Player1KeyFire
	clr.b	KEYARRAY+Player2KeyFire
	clr.b	KEYARRAY+Player3KeyFire
	rts