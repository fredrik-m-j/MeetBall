; CREDITS
; JOY0 & JOY1 reading is based on RamJam assembly course by Prince of Phaze101
;		https://princephaze101.wordpress.com
; 		https://www.youtube.com/playlist?list=PL-i3KPjyWoghwa9ZNAfiKQ-1HGToHn9EJ
; Author:	Fabio Ciucci
;		http://corsodiassembler.ramjam.it/index_en.htm
; History: 
;		Feb 2022 FmJ, switched CIA includes

; Out:	d3.w = #JOY_NOTHING or #JOY0_FIRE0 if fire was pressed
; See Constants for fire codes
Joy0DetectFire:
	move.w	#JOY_NOTHING,d3	; Assume there is no fire
	btst	#6,CIAA		; Joy0 button0 pressed?
	bne.s	.exit
	move.w	#JOY0_FIRE0,d3
.exit
	rts

; Out:	d3.w = #JOY_NOTHING or #JOY1_FIRE0 if fire was pressed
; See Constants for fire codes
Joy1DetectFire:
	move.w	#JOY_NOTHING,d3	; Assume there is no fire
	btst	#7,CIAA		; Joy1 button0 pressed?
	bne.s	.exit
	move.w	#JOY1_FIRE0,d3
.exit
	rts

; Out:	d3.w = #JOY_NOTHING or #JOY2_FIRE0 if fire was pressed
; See Constants for fire codes
Joy2DetectFire:
	move.b	CIAB+ciapra,d3
.exit
	rts

; Out:	d3.w = #JOY_NOTHING or #JOY3_FIRE0 if fire was pressed
; See Constants for fire codes
Joy3DetectFire:
	move.b	CIAB+ciapra,d3
.exit
	rts

; This routine reads the joystick.
; In:	a5.l = JOYXDAT_address
; Out:	d3.w = directionBits
; See Constants for direction bits
agdJoyDetectMovement:
;	movem.l	d0/d2/d3,-(sp)

	move.w	#JOY_NOTHING,d3	; Assume there is no movement

	move.w	(a5),d0

	btst.l	#1,d0		; bit 1 is set if we go right
	beq.s	.notRight
	and.w	#JOY_RIGHT,d3
	bra.s	.checkY
.notRight
	btst.l	#9,d0		; bit 9 is set if we go left
	beq.s	.checkY
	and.w	#JOY_LEFT,d3
.checkY:
	move.w	d0,d2		; copy value from JOYXDAT and bitshift
	lsr.w	#1,d2
	eor.w	d2,d0		; execute exclusive or. Now we can test
	btst.l	#8,d0		; for up
	beq.s	.notUp
	and.w	#JOY_UP,d3
	bra.s	.exit
.notUp
	btst.l	#0,d0		; check for down
	beq.s	.exit
	and.w	#JOY_DOWN,d3
.exit

;	movem.l	(sp)+,d0/d2/d3
	rts