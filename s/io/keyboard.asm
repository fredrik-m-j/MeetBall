KEYCODE_ESC	equ	$45
KEYCODE_F1	equ	$50
KEYCODE_F2	equ	$51
KEYCODE_F3	equ	$52
KEYCODE_F4	equ	$53

KEYARRAY:       dcb.b   128,$0

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
	movem.l	d0-d7/a0-a6,-(a7)

	lea	CUSTOM,a5
	move.w	INTREQR(a5),d0
	btst	#INTB_PORTS,d0
	beq	.end
	
; Ports generated interrupt
	lea	CIAA,a1
	btst	#CIAICRB_SP,ciaicr(a1)
	beq	.end

;read key and store him
	moveq	#0,d0
	move.b	ciasdr(a1),d0			; Serial Shift Data Register, Keycode is dumped into here
						; and then an IRQ2 generated.
	or.b	#CIACRAF_SPMODE,ciacra(a1)
	not.b	d0
	ror.b	#1,d0
	spl	d1
	and.b	#$7f,d0
	
	lea	KEYARRAY,a2
	move.b	d1,(a2,d0.w)			; Set $ff on KeyDown, $0 on on KeyUp

;Wait 3 lines for handshake.
	moveq	#3-1,d1
.wait1	move.b	VHPOSR(a5),d0
.wait2	cmp.b	VHPOSR(a5),d0
	beq.s	.wait2
	dbf	d1,.wait1

;set input mode
	and.b	#~(CIACRAF_SPMODE),ciacra(a1)

.end	move.w	#INTF_PORTS,INTREQ(a5)
	tst.w	INTREQR(a5)
	movem.l	(a7)+,d0-d7/a0-a6
	rte