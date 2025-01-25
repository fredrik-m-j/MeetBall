ShowCreditsScreen:
	movem.l	d2/a5-a6,-(sp)

	; It's assumed that backing screen was cleared
	move.l	GAMESCREEN_BackPtr(a5),a1
	bsr		DrawEscButton
	jsr		AppendDisarmedSprites

	lea		Copper_MISC,a1
	jsr		LoadCopper

	bsr		DrawCredits

.creditsLoop
	tst.b	KeyArray+KEY_ESCAPE		; Exit credits on ESC?
	bne.s	.exit

	jsr		CheckAllPossibleFirebuttons
	tst.b	d0						; Exit credits on FIRE?
	bne.s	.creditsLoop

.exit
	lea		Copper_MISC,a0
	lea		hColor00(a0),a0
	move.l	a0,-(sp)
	jsr		SimpleFadeOut
	move.l	(sp)+,a0

	WAITVBL

	jsr		ResetFadePalette

	movem.l	(sp)+,d2/a5-a6
	rts

; Not the prettiest routine to display credits...
DrawCredits:
	lea		CREDITS0_STR,a0
	lea		StringBuffer,a1
	COPYSTR	a0,a1

	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*9*4)+17+80,a2	; Skip to suitable bitplane/color
	moveq	#RL_SIZE-8,d5
	move.w	#(64*8*4)+4,d6
	bsr		DrawStringBuffer
	lea		CREDITS1_STR,a0
	COPYSTR	a0,a1
	add.l	#(RL_SIZE*7*4),a2
	bsr		DrawStringBuffer

	lea		CREDITS2_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*30*4)+5+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; McGeezer
	lea		CREDITS3_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*44*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS4_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*52*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS5_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*60*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer


	; Prince of Phaze101 & Fabio
	lea		CREDITS6_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*72*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS7_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*80*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Photon
	lea		CREDITS8_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*92*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS9_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*100*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Nivrig
	lea		CREDITS10_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*112*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS11_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*120*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Frank Wille
	lea		CREDITS12_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*132*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS13_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*140*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Highpuff & Ludis Langens
	lea		CREDITS14_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*152*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS15_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*160*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Tom Handley & Tom Kroener
	lea		CREDITS16_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*172*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS17_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*180*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Gfx & Sfx
	lea		CREDITS18_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*192*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS19_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*200*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Chucky
	lea		CREDITS20_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*212*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS21_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*220*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	; Others...
	lea		CREDITS22_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*240*4)+40,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer
	lea		CREDITS23_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(RL_SIZE*248*4)+80,a2
	moveq	#0,d5
	move.w	#(64*7*4)+20,d6
	bsr		DrawStringBuffer

	rts