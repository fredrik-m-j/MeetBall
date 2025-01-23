; In:	a6 = address to CUSTOM $dff000
ShowPowerupscreen:
	clr.b	FrameTick(a5)
	move.b	#8,ChillCount(a5)

	bsr		ClearBackscreen
	move.l	GAMESCREEN_BackPtr(a5),a1
	bsr		DrawEscButton
	bsr		DrawPowerupTexts

	move.w	#%10,$dff02e			; Enable CDANG bit to do blitting from copperlist

	bsr		AppendPowerupBlits
	lea		Copper_MISC,a1
	jsr		LoadCopper

.chillPowerupLoop
	addq.b	#1,FrameTick(a5)
	cmpi.b	#50,FrameTick(a5)
	blo.s	.chillFrame
	clr.b	FrameTick(a5)

	addq.b	#1,ChillTick(a5)
	subq.b	#1,ChillCount(a5)
	beq		.exit

.chillFrame
.vpos					; Embarrasingly slow textroutine hogs blitter - special wait needed
	move.l	CUSTOM+VPOSR,d0
	and.l	#$1ff00,d0
	cmp.l	#220<<8,d0
	bne.b	.vpos
.vposNext
	move.l	CUSTOM+VPOSR,d0
	and.l	#$1ff00,d0
	cmp.l	#221<<8,d0				; extra wait for really fast CPUs
	bne.b	.vposNext

	tst.b	FrameTick(a5)
	bne		.skip
	bsr		ToggleBackscreenFireToStart
.skip
	tst.b	KeyArray+KEY_ESCAPE		; Go to title on ESC?
	bne.s	.quit

	btst.b	#0,FrameTick(a5)		; Swap pixels every other frame
	beq.s	.checkFire
	bsr		AnimatePowerupFrame
.checkFire
	bsr		CheckAllPossibleFirebuttons
	tst.b	d0						; Go to controls on FIRE?
	bne.s	.chillPowerupLoop

	move.b	#USERINTENT_PLAY,UserIntentState(a5)
	bra		.exit
.quit
	move.b	#USERINTENT_QUIT,UserIntentState(a5)
	bra		.exit
.exit
	bsr		FadeoutCollectiblesScreen

	rts

FadeoutCollectiblesScreen:
	lea		Copper_MISC,a0
	lea		hColor00(a0),a0
	move.l	a0,-(sp)				; Preserve for palette restore

	moveq	#$f,d7
	bsr		InitFadeOut16
.fadeLoop
	WAITVBL
	bsr		FadeOutStep16			; a0 = Starting fadestep from COLOR00
	move.l	a0,-(sp)
	bsr		AnimatePowerupFrame
	move.l	(sp)+,a0
	dbf		d7,.fadeLoop

	WAITVBL

	move.l	CopperMiscEndPtr(a5),a0
	move.l	#COPPERLIST_END,(a0)	; Cut off all the blitting stuff for safe transition
	move.w	#%0,CUSTOM+COPCON		; Restore CDANG bit

	jsr		AppendDisarmedSprites	; Prevent spriteflicker on next screen

	bsr		ClearPowerup

	move.l	(sp)+,a0
	jsr		ResetFadePalette

	rts

; Copies animation frames into Spr_Powerup that is being displayed.
AnimatePowerupFrame:
	moveq	#0,d0					; Find sprite color data
	move.b	PowerupFrameCount(a5),d0
	add.b	d0,d0
	add.b	d0,d0

	lea		PowerupMap,a0
	move.l	(a0,d0),a0
	addq.l	#4,a0					; Skip CTRL words

	lea		Spr_Powerup,a1
	addq.l	#4,a1					; Skip CTRL words

	move.l	(a0)+,(a1)+				; 1st line
	move.l	(a0)+,(a1)+				; 2nd line

	move.w	#6,d0
.l					; line 3-9
	move.l	(a0)+,d1
	and.l   #%11111111111111111100000001111111,d1
	move.l	d1,(a1)+
	dbf		d0,.l

	move.l	(a0)+,(a1)+				; 10th line
	move.l	(a0)+,(a1)+				; 11th line

	cmp.b	#LASTPOWERUPINDEX,PowerupFrameCount(a5)
	beq		.reset
	bne		.done
.reset
	move.b	#-1,PowerupFrameCount(a5)
.done
	addq.b	#1,PowerupFrameCount(a5)
	rts


; Set up one powerup sprite that gets blit-updated in copperlist - no attached sprites.
; Minterm - see https://youtu.be/0KhiHOfmeLw?t=1509
;	Bit	Channel
;		ABC ->	D (this one yield A OR B)
;
;	0	000	0
;	1	001	0
;	2	010	1
;	3	011	1
;	4	100	1
;	5	101	1
;	6	110	1
;	7	111	1
AppendPowerupBlits:
	move.l	CopperMiscEndPtr(a5),a1

	move.l	#Spr_Ball1,d0			; Disarm other sprites using Ball1 as dummy
	move.w	#SPR0PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR0PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR1PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR1PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR2PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR2PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR3PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR3PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR4PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR4PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR5PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR5PTH,(a1)+
	move.w	d0,(a1)+
	move.l	#Spr_Ball1,d0
	move.w	#SPR6PTL,(a1)+
	move.w	d0,(a1)+
	swap	d0
	move.w	#SPR6PTH,(a1)+
	move.w	d0,(a1)+

	; Calculate start of "background"
	move.l	#Spr_LetterFrame+2,d0	; +2 = 2nd bitplane
	move.l	#BLTBPTH<<16,d3
	move.l	#BLTBPTL<<16,d4
	add.w	d0,d4
	swap	d0
	add.w	d0,d3

	; Calculate start of destination
	move.l	#Spr_Letter+2,d0		; +2 = 2nd bitplane
	move.l	#BLTDPTH<<16,d5
	move.l	#BLTDPTL<<16,d6
	add.w	d0,d6
	swap	d0
	add.w	d0,d5

	; Multiball
	move.l	#$2c3f7ffe,(a1)+		; WAIT for pos & bliter finished
	move.l	#BLTCON0<<16+$0dfc,(a1)+	; Set up A OR B blit.
	move.l	#BLTCON1<<16+$0000,(a1)+
	move.l	#BLTAFWM<<16+$ffff,(a1)+
	move.l	#BLTALWM<<16+$ffff,(a1)+
	move.l	#BLTAMOD<<16+$0002,(a1)+
	move.l	#BLTBMOD<<16+$0002,(a1)+
	move.l	#BLTDMOD<<16+$0002,(a1)+

	move.l	#Spr_Powerup_Multiball+2,d0	; +2 = 2nd bitplane
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+

	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0a70,(a1)+
	move.l	#COLOR30<<16+$0e90,(a1)+
	move.l	#COLOR31<<16+$0fec,(a1)+
	move.l	#SPR7POS<<16+$5150,(a1)+
	move.l	#SPR7CTL<<16+$5d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Glue
	move.l	#$603f7ffe,(a1)+		; WAIT for pos & bliter finished
	; move.l	#BLTCON0<<16+$0dfc,(a1)+	; Set up A OR B blit.
	; move.l	#BLTCON1<<16+$0000,(a1)+
	; move.l	#BLTAFWM<<16+$ffff,(a1)+
	; move.l	#BLTALWM<<16+$ffff,(a1)+
	; move.l	#BLTAMOD<<16+$0002,(a1)+
	; move.l	#BLTBMOD<<16+$0002,(a1)+
	; move.l	#BLTDMOD<<16+$0002,(a1)+

	move.l	#Spr_Powerup_Glue+2,d0	; +2 = 2nd bitplane
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0171,(a1)+
	move.l	#COLOR30<<16+$03b3,(a1)+
	move.l	#COLOR31<<16+$0bfb,(a1)+
	move.l	#SPR7POS<<16+$6150,(a1)+
	move.l	#SPR7CTL<<16+$6d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Widebat
	move.l	#$6d3f7ffe,(a1)+

	move.l	#Spr_Powerup_WideBat+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0117,(a1)+
	move.l	#COLOR30<<16+$033b,(a1)+
	move.l	#COLOR31<<16+$088f,(a1)+
	move.l	#SPR7POS<<16+$7150,(a1)+
	move.l	#SPR7CTL<<16+$7d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Breachball
	move.l	#$7d3f7ffe,(a1)+

	move.l	#Spr_Powerup_Breachball+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0820,(a1)+
	move.l	#COLOR30<<16+$0e30,(a1)+
	move.l	#COLOR31<<16+$0fa5,(a1)+
	move.l	#SPR7POS<<16+$8150,(a1)+
	move.l	#SPR7CTL<<16+$8d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Points
	move.l	#$8d3f7ffe,(a1)+

	move.l	#Spr_Powerup_Score+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0334,(a1)+
	move.l	#COLOR30<<16+$0668,(a1)+
	move.l	#COLOR31<<16+$0bbe,(a1)+
	move.l	#SPR7POS<<16+$9150,(a1)+
	move.l	#SPR7CTL<<16+$9d00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Bat speedup
	move.l	#$9d3f7ffe,(a1)+

	move.l	#Spr_Powerup_Batspeed+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$033b,(a1)+
	move.l	#COLOR30<<16+$066e,(a1)+
	move.l	#COLOR31<<16+$0bbf,(a1)+
	move.l	#SPR7POS<<16+$a150,(a1)+
	move.l	#SPR7CTL<<16+$ad00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Gun
	move.l	#$ad3f7ffe,(a1)+

	move.l	#Spr_Powerup_Gun+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0a2a,(a1)+
	move.l	#COLOR30<<16+$0e3e,(a1)+
	move.l	#COLOR31<<16+$0fbf,(a1)+
	move.l	#SPR7POS<<16+$b150,(a1)+
	move.l	#SPR7CTL<<16+$bd00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	; Insanoballz
	move.l	#$bd3f7ffe,(a1)+

	move.l	#Spr_Powerup_Insanoballs+2,d0
	move.l	#BLTAPTH<<16,d1
	move.l	#BLTAPTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1
	move.l	d1,(a1)+				; Source A
	move.l	d2,(a1)+
	move.l	d3,(a1)+				; Source B - "background"
	move.l	d4,(a1)+
	move.l	d5,(a1)+				; Destination D
	move.l	d6,(a1)+
	move.l	#BLTSIZE<<16+9<<6+1,(a1)+

	move.l	#COLOR29<<16+$0060,(a1)+
	move.l	#COLOR30<<16+$04a4,(a1)+
	move.l	#COLOR31<<16+$0efe,(a1)+
	move.l	#SPR7POS<<16+$c150,(a1)+
	move.l	#SPR7CTL<<16+$cd00,(a1)+

	move.l	#Spr_Powerup,d0
	move.l	#SPR7PTH<<16,d1
	move.l	#SPR7PTL<<16,d2
	add.w	d0,d2
	swap	d0
	add.w	d0,d1

	move.l	d1,(a1)+				; Reset sprite pointer
	move.l	d2,(a1)+

	move.l	#COPPERLIST_END,(a1)

	rts

DrawPowerupTexts:
	lea		StringBuffer,a1

	lea		POW_POWERUPS0_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l	#(ScrBpl*20*4)+4,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer
	lea		POW_POWERUPS1_STR,a0
	COPYSTR	a0,a1
	add.l	#(ScrBpl*7*4),a2
	bsr		DrawStringBuffer


	lea		POW_MULTIBALL_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*0)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_GLUE_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*1)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_WIDE_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*2)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_BREACH_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*3)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_POINTS_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*4)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_SPEEDUP_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*5)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_GUN_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*6)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	lea		POW_INSANO_STR,a0
	COPYSTR	a0,a1
	move.l  GAMESCREEN_BackPtr(a5),a2
	add.l 	#(ScrBpl*(39+16*7)*4)+7,a2
	moveq	#ScrBpl-20,d5
	move.w	#(64*7*4)+10,d6
	bsr		DrawStringBuffer

	rts