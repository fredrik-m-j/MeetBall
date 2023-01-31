; In:   d0 = x pos
; In:   d1 = y pos
CheckPowerup:
	tst.l	Powerup         ; Powerup active?
	bne.s	.exit

        move.l	a0,-(sp)

        lea     Powerup,a0
        move.l  #Spr_Powerup0,hAddress(a0)
        move.l  #0,hIndex(a0)
        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  d1,hSprBobTopLeftYPos(a0)

        move.l	(sp)+,a0
.exit
        rts

ClearPowerup:
	move.l	Powerup,a0
	cmpa	#0,a0
	beq.s	.exit
	move.l	#0,(a0)         ; Disarm sprite
        move.l  #0,Powerup      ; Remove sprite
.exit
        rts