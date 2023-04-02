; Initializes annoying things
InitTroubles:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*89*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96)*4),d1

        lea	IdiotMap,a0

	moveq	#9,d7
.loop1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop1

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(89+32)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+96+32)*4),d1

	moveq	#9,d7
.loop2
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop2

	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#(ScrBpl*(89+64)*4),d0
	move.l	BOBS_BITMAPBASE,d1
	addi.l 	#(ScrBpl*(89+64)*4)+20,d1

	moveq	#4,d7
.loop3
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	addq.l	#4,d0
	addq.l	#4,d1
	dbf	d7,.loop3

        rts

TurmoilUpdates:
	lea	Idiot0,a0

	move.w  hSprBobTopLeftXPos(a0),d0

	cmpi.w	#275,d0
	bne.s	.goRight
	neg.w	hSprBobXCurrentSpeed(a0)
.goRight
	cmpi.w	#25,d0
	bne.s	.checkY
	neg.w	hSprBobXCurrentSpeed(a0)
.checkY

	move.w  hSprBobTopLeftYPos(a0),d0

	cmpi.w	#215,d0
	bne.s	.goDown
	neg.w	hSprBobYCurrentSpeed(a0)
.goDown
	cmpi.w	#30,d0
	bne.s	.updatePos
	neg.w	hSprBobYCurrentSpeed(a0)

.updatePos
	move.w  hSprBobTopLeftXPos(a0),d0
        move.w  hSprBobTopLeftYPos(a0),d1
        add.w   hSprBobXCurrentSpeed(a0),d0     ; Update ball coordinates
        add.w   hSprBobYCurrentSpeed(a0),d1
        
	move.w  d0,hSprBobTopLeftXPos(a0)       ; Set the new coordinate values
        move.w  d1,hSprBobTopLeftYPos(a0)

	add.w	hSprBobWidth(a0),d0
	add.w	hSprBobHeight(a0),d1

        move.w  d0,hSprBobBottomRightXPos(a0)       ; Set the new coordinate values
        move.w  d1,hSprBobBottomRightYPos(a0)

	rts