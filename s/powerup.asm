; In	a5 = pointer to brick in GAMEAREA
CheckPowerup:
	tst.l	Powerup         ; Powerup active?
	bne.s	.exit

        lea     Powerup,a0
        move.l  #Spr_Powerup0,hAddress(a0)
        move.l  #0,hIndex(a0)

	move.l	a5,d7
	sub.l	#GAMEAREA,d7		; Which GAMEAREA byte is it?

	add.l	d7,d7
	lea	GAMEAREA_BYTE_TO_ROWCOL_LOOKUP,a2
	add.l	d7,a2

	moveq	#0,d0
	moveq	#0,d1
	move.b	(a2)+,d0		; Col / X pos
        subq	#1,d0		        ; Compensate for empty first byte in GAMEAREA
	move.b	(a2),d1			; Row / Y pos
        lsl.w   #3,d0                   ; Convert to pixels
        lsl.w   #3,d1

        move.w  d0,hSprBobTopLeftXPos(a0)
        move.w  d1,hSprBobTopLeftYPos(a0)
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