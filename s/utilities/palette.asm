; CREDITS
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com

;--------------------------------------------
; In:	a1 = Pointer to ILBM file	
agdGetBitmapPalette:
	movem.l	d5-d6/a1,-(a7)

	move.l	#tPalette,d0				; Create a new Palette handle
	bsr	agdCreateNewHandle	
			; Save handle for this type	
	
	move.l	#40,d7			
	
.loop:
	cmp.l	#"CMAP",(a1)
	beq.s	.cmap
	addq.w	#2,a1
	dbf	d7,.loop
	moveq	#-1,d1
	bra	.exit

; Parse Colour Map header here.
.cmap:	
	move.l	a1,hAddress(a0)				; Save address of asset
	move.l	4(a1),hSize(a0)				; Save Length of asset
	move.l	#tPalette,hType(a0)			; Save type of resource	
	move.w	d0,hIndex(a0)
	move.w	#0,hLastIndex(a0)
	move.l	a0,a2
	add.l	#16,a2
	
	addq.w	#4,a1
	move.l	(a1)+,d7			; Length

.transform:
	moveq	#0,d5
	moveq	#0,d6
	move.b	(a1)+,d5			; Move in red and green
	move.b	d5,d6				; $3e
	lsr.b	#4,d5				; d5=$0000001
	and.b	#$f,d6				; d6=$0000008
	lsl.w	#8,d5				; d5=$0000100
	lsl.w	#8,d6				; d6=$0000800
	
	move.b	(a1)+,d5			; d5=$0000129
	move.b	d5,d6				; d6=$0000829
	and.b	#$f0,d5				; d5=$0000120
	lsl.b	#4,d6				; d6=$0000890
	
	lsl.l	#4,d5				; d5=$0001200
	lsl.l	#4,d6				; d6=$0008900
	move.b	(a1)+,d5			; d5=$000123a
	move.b	d5,d6				; d6=$000893a
	
	lsr.w	#4,d5				; d5=$0000123
	lsl.b	#4,d6				; d6=$00089a0
	lsr.w	#4,d6				; d6=$000089a
	
	swap	d6				; d6=089a0000
	move.w	d5,d6				; d6=089a0123
	move.l	d6,(a2)+			; d6 
	
	subq.w	#3,d7
	bpl.s	.transform
	move.l	a0,d0

	tst.w	d7
	beq	.transform

	bra.s	.exit
	
.error_handle_fail:
	moveq	#-1,d0
.exit:	
	movem.l	(a7)+,d5-d6/a1
	rts