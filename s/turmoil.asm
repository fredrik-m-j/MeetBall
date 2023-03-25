; Initializes annoying things
InitTroubles:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*89*4),d0

	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96)*4),d1

        lea	IdiotAnim0,a0
	move.l	d0,hAddress(a0)
	move.l	d1,hSprBobMaskAddress(a0)

        ; lea	IdiotAnim1,a0
	; addq	#4,d0
	; move.l	d0,hAddress(a0)
	; addq	#4,d1
	; move.l	d1,hSprBobMaskAddress(a0)

        rts