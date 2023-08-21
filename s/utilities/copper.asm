; CREDITS
; Source based on Amiga Game Dev
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com
; Date: 2023-01-06
; 	FmJ: Added Hw sprite and other small adjustments
;	2023-08-21
;	FmJ: Set BPLCON4 to default values and revert usage of clr with dffxxx.
;	See: https://github.com/rkrajnc/minimig-mist/blob/master/doc/amiga/aga/RandyAGA.txt

; Build of a simple copper list
; In:	a1 = Copper buffer space
; In:	a3 = Bitmap data handle
; In:	a4 = Bitmap palette handle
; Out:	d0.l = Adress to end of copper list
agdBuildCopper:	
	move.l	hAddress(a1),a1
	
	move.l	#(FMODE<<16)+$0000,(a1)+	; No AGA

; Set the Display window sizes
	move.l	#(DIWSTRT<<16)+DISP_XSTRT+(DISP_YSTRT*256),(a1)+
	move.l	#(DIWSTOP<<16)+(DISP_XSTOP-256)+(DISP_YSTOP-256)*256,(a1)+
	move.l	#(DDFSTRT<<16)+(DISP_HSTRT/2-DISP_RES),(a1)+
	move.l	#(DDFSTOP<<16)+(DISP_HSTRT/2-DISP_RES)+(8*((DISP_WIDTH/16)-1)),(a1)+

; Load the colour palette
	move.l	#COLOR00<<16,d3
	lea	hPalette(a4),a2			; Get palette address
	move.w	hBitmapColours(a3),d7
	subi.w	#1,d7
	
.pal:	move.l	(a2)+,d1
	move.w	d1,d3
	move.l	d3,(a1)+
	add.l	#$2<<16,d3			; Increment high word to get to next COLORxx
	dbf	d7,.pal

; Work out the Bitplane Modulo
	moveq	#0,d3
	move.l	hBitmapBody(a3),d1
	addq.l	#8,d1				; d1 = Body pointer
	moveq	#0,d2
	move.w	hBitmapWidth(a3),d2
	lsr.w	#3,d2				; d2 = Bitplane Byte width
	move.w	hBitmapModulo(a3),d3		; d3 = Modulo
	
	move.w	#BPL1MOD,(a1)+
	move.w	d3,(a1)+
	move.w	#BPL2MOD,(a1)+
	move.w	d3,(a1)+

; Work out the number of bitplanes
	move.w	hBitmapPlanes(a3),d7		; d7 = Number of planes
	ror.w	#4,d7
	or.w	#$200,d7			; set bit 9 = Enables color burst output signal
	move.w	#BPLCON0,(a1)+
	move.w	d7,(a1)+
	move.w	#BPLCON1,(a1)+
	move.w	#0,(a1)+
	move.w	#BPLCON2,(a1)+
	move.w	#%0000000000100000,(a1)+	; Have all sprites on top of picture
	move.l	#(BPLCON3<<16)+$0000,(a1)+	; No AGA
	move.l	#(BPLCON4<<16)+$0011,(a1)+	; No AGA
	
	moveq	#0,d0				; Set to 8 
	move.l	a1,COPPTR_TOP

	bsr	agdCopperBitplanes

	bsr AppendHardwareSprites

	move.l	#COPPERLIST_END,(a1)
	move.l	a1,d0
	rts
	

	
; Load bitplane pointers to our IFF
; In:	d0.w = Y Position in Memory
; In:	a1 = Copper Pointer
; In:	a3 = Bitmap data handle
agdCopperBitplanes:
	move.w	hBitmapScanLength(a3),d3	; Get full scanline length
	mulu	d0,d3

	move.l	hBitmapBody(a3),d1
	addq.l	#8,d1				; d1 = Body pointer
	add.l	d3,d1
	
	move.w	hBitmapPlanes(a3),d7		; d7 = Number of planes
	subq.w	#1,d7	
	move.l	#BPL0PTH<<16,d3
.bp:	swap	d1
	move.w	d1,d3
	move.l	d3,(a1)+
	add.l	#$2<<16,d3
	swap	d1
	move.w	d1,d3
	move.l	d3,(a1)+
	add.l	#$2<<16,d3	
	add.l	d2,d1
	dbf	d7,.bp
	rts


	IFNE	ENABLE_DEBUG_GAMECOPPER

LoadDebugCopperlist:
	movem.l	d1/a0,-(sp)

	lea	CUSTOM,a0
	move.l	#COPPTR_GAME_DEBUG,d1	; Get address of copper list.
	move.l	d1,COP1LCH(a0)		; Load copper 1
	move.l	d1,COP2LCH(a0)		; Load copper 2
	move.w	d1,COPJMP1(a0)		; Start copper 1
	move.w	#0,COPJMP2(a0)		; Start copper 2

	movem.l	(sp)+,d1/a0
	rts
	ENDC