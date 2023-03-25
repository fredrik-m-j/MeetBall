; Initializes annoying things
InitTroubles:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*89*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96)*4),d1

        lea	IdiotMap,a0
	lea	IdiotMaskMap,a1

	moveq	#9,d7
.loop1
	move.l	d0,(a0)+
	move.l	d1,(a1)+
	addq	#4,d0
	addq	#4,d1
	dbf	d7,.loop1

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(89+32)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96+32)*4),d1

	moveq	#9,d7
.loop2
	move.l	d0,(a0)+
	move.l	d1,(a1)+
	addq	#4,d0
	addq	#4,d1
	dbf	d7,.loop2


	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(89+64)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+64)*4)+20,d1

	moveq	#4,d7
.loop3
	move.l	d0,(a0)+
	move.l	d1,(a1)+
	addq	#4,d0
	addq	#4,d1
	dbf	d7,.loop3

        rts