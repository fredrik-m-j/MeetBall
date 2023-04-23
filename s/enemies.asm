InitEnemies:
        ; Enemy 1
	move.l	BOBS_BITMAPBASE,d0		; Init animation frames
	addi.l 	#(ScrBpl*31*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*31*4)+(4*2),d1         ; Same mask for all frames

        lea	Enemy1AnimMap,a0

	moveq	#3,d7
.loop
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#2,d0
	dbf	d7,.loop

        rts