; CREDITS
; 
; * For testing Parallel port and finding the mapped values:
; PARIO v1.5
; Author:	Tom Handley (thandley at nesbbx.rain.com)
; 		http://aminet.net/package/docs/hard/pario15
; CheckPrt v1.1
; Author:	kroener at cs.uni-sb.de (Tom Kroener)
; 		http://aminet.net/package/text/print/CheckPrt
;
; * Original source used as a base is from Amiga Mail Volume II
; Author:	?
; Source: 	
; http://amigadev.elowar.com/read/ADCD_2.1/AmigaMail_Vol2_guide/node01FF.html
; http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node012E.html#line34

; Parallel port joystick adapter mapping
; JOY2 nothing	-> CIAA_PRB (Data Port): $FF	%1111 1111
; JOY2 UP	-> CIAA_PRB (Data Port): $FE	%1111 1110
; JOY2 DOWN	-> CIAA_PRB (Data Port): $FD	%1111 1101
; JOY2 LEFT	-> CIAA_PRB (Data Port): $FB	%1111 1011
; JOY2 RIGHT	-> CIAA_PRB (Data Port): $F7	%1111 0111
; JOY2 FIRE0	-> CIAB_PRA Select State: Low	%1111 1011
; JOY2 FIRE1	-> <not supported?>
; JOY3 nothing	-> CIAA_PRB (Data Port): $FF	%1111 1111
; JOY3 UP	-> CIAA_PRB (Data Port): $EF	%1110 1111
; JOY3 DOWN	-> CIAA_PRB (Data Port): $DF	%1101 1111
; JOY3 LEFT	-> CIAA_PRB (Data Port): $BF	%1011 1111
; JOY3 RIGHT	-> CIAA_PRB (Data Port): $7F	%0111 1111
; JOY3 FIRE0	-> CIAB_PRA Busy State: Low	%1111 1110
; JOY3 FIRE1	-> <not supported?>

; Hardware reference:
; http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node01A6.html


; These routines set up the parallel port for reading JOY2 and JOY3 inputs
; After successful grab, movement can be read from $BFE101 and fire from $BFD100
; It uses system calls rather than directly modifying registers.

************************* LVOs for misc.resource ************************

_LVOAllocMiscResource	equ	-6
_LVOFreeMiscResource	equ	-12

Name	dc.b	'4play',0		; other applications will know
								; who's tying up the port. ;-)
	INCLUDE	"resources/misc.i"

MiscName	MISCNAME			; macro from resources/misc.i
_MiscResource	dc.l	0		; place to store misc.resource base

_ciaaddrb:      dc.b    0		; data direction register
_ciabddra:		dc.b    0		; data direction register
	even


; This routine simply allocates the parallel port in a system friendly
; way, and sets up the lines we want to use as input lines.
GetParallelPort:
; save registers on the stack

	movem.l	a2-a6/d2-d7,-(sp)		; push regs

;open the misc.resource

	lea		MiscName,a1				; put name of misc.resource in a1
	movea.l	_SysBase,a6				; put SysBase in a6
	jsr		_LVOOpenResource(a6)
	move.l	d0,_MiscResource		; store address of misc.resource
	bne.s	.grabIt

;Oops, couldn't open misc.resource.  Sounds like big trouble to me.

	moveq	#20,d0					; error code
	bra		.done


;This is where we grab the hardware.  If some other task has allocated
;the parallel data port or the parallel control bits, this routine will
;return non-zero.
;This part grabs the port itself
.grabIt
	lea		Name,a1					; The name of our app
	moveq	#MR_PARALLELPORT,d0		; what we want
	movea.l	_MiscResource,a6		; MiscResource Base is in A6
	jsr		_LVOAllocMiscResource(a6)
	move.l	d0,d1
	beq.s	.grab2

;well, somebody else must've got the port first.

	moveq	#30,d0					; error code
	bra		.done

;This part grabs the control bits (busy, pout, and sel.)
;We really don't need pout, but it comes free with PARALLELBITS,
;so we'll take it anyway.

.grab2
	lea		Name,a1					; The name of our app
	moveq	#MR_PARALLELBITS,d0		; what we want
	jsr		_LVOAllocMiscResource(a6)
	move.l	d0,d1
	beq.s	.setRead

;well, somebody else must've got the bits first.

	moveq	#40,d2
	bra		.freeParallelPort


;set up parallel port for reading

.setRead
	move.b	#0,_ciaaddrb			; all lines read
	andi.b	#$FF,_ciabddra			; busy, pout, and sel. to read

;Well, we made it this far, so we've got exclusive access to
;the parallel port, and all the lines we want to use are
;set up.   From here we can just put back the regs and return to
;the caller.

	bra		.done


;If something happened AFTER we got exclusive access to the parallel port,
;we'll need to let go of the port before we return the error.

.freeParallelPort
	moveq	#MR_PARALLELPORT,d0
	movea.l	_MiscResource,a6
	jsr		_LVOFreeMiscResource(a6)

	move.l	d2,d0					; put error code into d0


;Restore registers and return
;(error code is in d0)

.done
	movem.l	(sp)+,a2-a6/d2-d7		; pop regs
	rts


FreeParallelPort:
;This routine just makes sure that we let go of the parallel port and
;control lines, so somebody else can use 'em, now that we're all done.
;
;PS - Don't call this one if you got an error from GetParallelPort, as some
;of the resources might not have been opened, etc.
;

;save registers on the stack

	movem.l	a2-a6/d2-d7,-(sp)		; push regs

;free control lines

	moveq	#MR_PARALLELBITS,d0
	movea.l	_MiscResource,a6
	jsr		_LVOFreeMiscResource(a6)

;free parallel port

	moveq	#MR_PARALLELPORT,d0
	movea.l	_MiscResource,a6
	jsr		_LVOFreeMiscResource(a6)

;Clean up, restore registers, and return

	movem.l	(sp)+,a2-a6/d2-d7		; pop regs
	rts
