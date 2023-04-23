; CREDITS
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com

; *pBitmap = agdGetBitmapDimensions(*ptr pAsset)
; In:	a1 = pAsset
; Out:	d0 = pBitmap
agdGetBitmapDimensions:
	movem.l	d5-d6/a1,-(a7)

	move.l	#tBitmap,d0				; Create a new Bitmap handle
	bsr	agdCreateNewHandle	
	
	move.l	#512-1,d7					
.loop_bmhd:
	cmp.l	#"BMHD",(a1)
	beq.s	.bmhd
	addq.w	#2,a1
	dbf	d7,.loop_bmhd
	moveq	#-1,d1
	bra	.exit
	
; Parse Bitmap Header here
.bmhd:	
	move.l	a1,hAddress(a0)				; Save address of asset
	move.l	4(a1),hSize(a0)				; Save Length of asset
	move.l	#tBitmap,hType(a0)			; Save type of resource	
	move.w	d0,hIndex(a0)				; Save handle for this type
	move.w	#0,hLastIndex(a0)

	addq.w	#8,a1	
	move.w	(a1),hBitmapWidth(a0)
	move.w	2(a1),hBitmapHeight(a0)
; Save number of Bitplanes
	moveq	#0,d6	
	move.b	8(a1),d6
	move.w	d6,hBitmapPlanes(a0)

; Work out the modulo
	moveq	#0,d5
	move.w	hBitmapWidth(a0),d5
	lsr.w	#3,d5					; Divide by 8
	subq.w	#1,d6
	mulu	d5,d6
	move.w	d6,hBitmapModulo(a0)

	move.b	8(a1),d6				; Save full scan line length
	mulu	d5,d6
	move.w	d6,hBitmapScanLength(a0)
	
; Get number of colours
	moveq	#0,d5
	moveq	#0,d6
	move.b	8(a1),d5
	bset	d5,d6
	move.w	d6,hBitmapColours(a0)

.loop_body:
	cmp.l	#"BODY",(a1)
	beq.s	.body
	addq.w	#2,a1
	dbf	d7,.loop_body	
	
.body:	move.l	a1,hBitmapBody(a0)			; Save 
	move.l	a0,d0					; Return pointer to handle	
	bra.s	.exit
	
.error_handle_fail:
	moveq	#-1,d0
.exit:	movem.l	(a7)+,d5-d6/a1
	rts
	
