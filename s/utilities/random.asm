; CREDITS
; Posted on EAB
; Author:	Photon of Scoopex
;		https://eab.abime.net/showpost.php?p=679652&postcount=6
; History: 
;		April 2022 FmJ
;		* Remade and added ball X and Y position to the mix in RndW.

; Out:  d0.w
RndW:	move.w	CUSTOM+VHPOSR,d0
	move.b 	$bfd800,d5		;event counter
	and.b	Ball0+hBallTopLeftYPos,d5
	lsl.w 	#8,d5
	move.b 	$bfd900,d5		;event counter
	or.b	Ball0+hBallTopLeftXPos,d5

	eor.w 	d5,d0
	rts

; Out:  d0.b
RndB:	move.b 	$dff007,d0		;Hpos
	move.b 	$bfd800,d5		;event counter

	eor.b 	d5,d0
	
        rts