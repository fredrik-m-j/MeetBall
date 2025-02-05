; Fade to black.
; Assumes that ResetFadePalette is executed afterwards.
; In:	a0 = address to COLOR00 in copperlist.
SimpleFadeOut:
	move.l	d7,-(sp)

	moveq	#$f,d7
	bsr		InitFadeOut16
.fadeLoop
	WAITBOVP	d0
	bsr		FadeOutStep16			; a0 = Starting fadestep from COLOR00
	dbf		d7,.fadeLoop

	move.l	(sp)+,d7
	rts

; Gfx and sound fade to black/out.
; Assumes that ResetFadePalette is executed afterwards.
; In:	a0 = address to COLOR00 in copperlist.
GfxAndMusicFadeOut:
	movem.l	d6-d7,-(sp)

	moveq	#FADE_MUSICSTEPS,d6
	moveq	#FADE_FRAMEWAITS,d7
	bsr		InitFadeOut16
.fadeLoop

	WAITBOVP	d0

	tst.l	d7
	bne.s	.skipColorFade

	bsr		FadeOutStep16			; a0 = Starting fadestep from COLOR00
	moveq	#FADE_FRAMEWAITS,d7
.skipColorFade
	ror.l	d6						; Fade music volume
	move.l	d6,d0
	rol.l	d6

	move.l	a0,-(sp)
	jsr		SetMasterVolume
	move.l	(sp)+,a0

	subq.l	#1,d7
	dbf		d6,.fadeLoop

	jsr		StopAudio

	move.b	#-1,FadePhase(a5)

	movem.l	(sp)+,d6-d7
	rts

; In:	a0 = pointer to COLOR00 in active copperlist
InitFadeOut16:
	movem.l	d7/a0/a1,-(sp)

	move.b	#$f,FadePhase(a5)		; Fades in 1/16th steps is the most granular fade possible

	lea		FadeFromPalette16,a1
	moveq	#16-1,d7				; Number of color words to copy
.loop
	move.l	(a0)+,(a1)+
	dbf		d7,.loop

	movem.l	(sp)+,d7/a0/a1
	rts

; In:	a0 = pointer to COLOR00 in copperlist
ResetFadePalette:
	movem.l	d7/a0/a1,-(sp)
	lea		FadeFromPalette16,a1
	moveq	#16-1,d7				; Number of color words to copy
.loop
	move.l	(a1)+,(a0)+
	dbf		d7,.loop

	movem.l	(sp)+,d7/a0/a1
	rts

; Manipulates COLOR00 to COLOR15 to get a fade-to-black effect
; Algorithm by Fabio Ciucci http://corsodiassembler.ramjam.it/index_en.htm
; In:	a0 = pointer to COLOR00 in active copperlist
FadeOutStep16:
	tst.b	FadePhase(a5)
	bmi.s	.exit

	movem.l	d0-d3/d7/a0/a1,-(sp)

	lea		FadeFromPalette16,a1	; a1 has a copy of the original color words

	moveq	#0,d3
	move.b	FadePhase(a5),d3
	moveq	#16-1,d7				; Number of colors to fade
	moveq	#0,d1
.colorLoop
	move.l	(a1),d2					; d2 contains the resulting longword at the end of an iteration
	
	move.w	(a1)+,d0				; Skip over COLORnn word
	moveq	#0,d0
	
	move.b	(a1)+,d0				; RED in d0

	mulu.w	d3,d0
	lsr.w	#4,d0

	ror.l	#2*4,d2					; Rotate 2 nibbles
	move.b	d0,d2
	rol.l	#2*4,d2

	move.b	(a1),d0					; GREEN in d0

	lsr.b	#4,d0					; Shift 1 nibble
	mulu.w	d3,d0
	and.b	#$f0,d0

	move.b	(a1)+,d1				; BLUE in d1
	and.b	#$0F,d1
	mulu.w	d3,d1
	lsr.w	#4,d1

	or.w	d1,d0					; Combine Green and Blue results
	move.b	d0,d2

	move.l	d2,(a0)+				; Set new color in active copperlist

	dbf		d7,.colorLoop

	subq.b	#1,FadePhase(a5)
	movem.l	(sp)+,d0-d3/d7/a0/a1
.exit
	rts