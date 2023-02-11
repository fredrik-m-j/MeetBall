; TODO: Create sprite system
InitPowerupPalette:
	; Override/set sprite colors - Sprite 0-1
	lea     CUSTOM+COLOR17,a6 
	move.w	#$151,(a6)+
	move.w	#$393,(a6)+
	move.w	#$8d8,(a6)
	; Override/set sprite colors - Sprite 4-5
	lea     CUSTOM+COLOR25,a6 
	move.w 	#$511,(a6)+ 
	move.w 	#$933,(a6)+ 
	move.w 	#$d88,(a6)

	rts

; Make powerup appear if conditions are fulfilled.
; In:   a0 = address to ball structure
; In	a5 = pointer to brick in GAMEAREA
CheckAddPowerup:
	tst.l	Powerup         ; Powerup active?
	bne.s	.exit

        lea     Powerup,a1
        move.l  #Spr_Powerup0,hAddress(a1)
        move.l  #0,hIndex(a1)

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
					; Set powerup position & speed
        move.w  d0,hSprBobTopLeftXPos(a1)
        move.w  d1,hSprBobTopLeftYPos(a1)

	move.l	hBallPlayerBat(a0),d0

	cmp.l	#Bat0,d0
	bne.s	.bat1
	move.w  #1,hSprBobXCurrentSpeed(a1)
	bra.s	.exit
.bat1
	cmp.l	#Bat1,d0
	bne.s	.bat2
	move.w  #-1,hSprBobXCurrentSpeed(a1)
	bra.s	.exit
.bat2
	cmp.l	#Bat2,d0
	bne.s	.bat3
	move.w  #1,hSprBobYCurrentSpeed(a1)
	bra.s	.exit
.bat3
	move.w  #-1,hSprBobYCurrentSpeed(a1)

.exit
        rts


ClearPowerup:
	lea	Powerup,a0
	cmpi.l	#0,(a0)
	beq.s	.exit
	move.l	#0,hSprBobXCurrentSpeed(a0)	; Clear X.w and Y.w speeds
	move.l	hAddress(a0),a0
	move.l	#0,(a0)         		; Disarm sprite
        move.l  #0,Powerup      		; Remove sprite
.exit
        rts

; Adds powerup effect for the player who got the powerup.
; In:	a0 = adress to powerup structure
; In:	a1 = adress to player score
BatPowerup:
; TODO: Add sound effect at pickup. Visual effect too?

        ; TODO: Add sound effect at pickup. Visual effect too?

        move.l	hPowerupPlayerScore(a0),d1
        add.w   d1,(a1)

	bra.s	ClearPowerup
;	rts by ClearPowerup