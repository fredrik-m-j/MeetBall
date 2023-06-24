ShowCredits:
        movem.l d2/a5,-(sp)

        move.l  GAMESCREEN_BITMAPBASE_BACK,a0
	moveq	#0,d1
	move.w	#(64*255*4)+20,d2
        bsr     ClearBlitWords

	move.l 	MENUSCREEN_BITMAPBASE,a0
	add.l   #(ScrBpl*3*4),a0
	move.l	GAMESCREEN_BITMAPBASE_BACK,a1
	add.l   #(ScrBpl*3*4),a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*14*4)+2,d2
        move.l  #$fffff000,d0
	bsr	CopyBlit

	move.l	COPPTR_CREDITS,a1
	jsr	LoadCopper

        bsr     DrawCredits

.creditsLoop
	tst.b	KEYARRAY+KEY_ESCAPE     ; Exit credits on ESC?
	bne.s	.exit

	bsr	CheckFirebuttons
	tst.b	d0                      ; Exit credits on FIRE?
        bne.s   .creditsLoop

.exit
        move.l	COPPTR_CREDITS,a5
        move.l	hAddress(a5),a5
	lea	hColor00(a5),a5
        move.l  a5,a0
        bsr     SimpleFadeOut

	move.l	COPPTR_MENU,a1
	jsr	LoadCopper

        move.l  a5,a0
        bsr	ResetFadePalette

        movem.l (sp)+,d2/a5
        rts

; Not the prettiest routine to display credits...
DrawCredits:
        lea     CREDITS0_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*9*4)+17+80,a2          ; Skip to suitable bitplane/color
        moveq   #ScrBpl-8,d5
        move.w  #(64*8*4)+4,d6
        bsr     DrawStringBuffer
        lea     CREDITS1_STR,a0
        COPYSTR a0,a1
        add.l 	#(ScrBpl*7*4),a2
        bsr     DrawStringBuffer

        lea     CREDITS2_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*30*4)+5+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; McGeezer
        lea     CREDITS3_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*44*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS4_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*52*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS5_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*60*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer


        ; Prince of Phaze101 & Fabio
        lea     CREDITS6_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*72*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS7_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*80*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Photon
        lea     CREDITS8_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*92*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS9_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*100*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Nivrig
        lea     CREDITS10_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*112*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS11_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*120*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Frank Wille
        lea     CREDITS12_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*132*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS13_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*140*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Highpuff & Ludis Langens
        lea     CREDITS14_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*152*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS15_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*160*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Tom Handley & Tom Kroener
        lea     CREDITS16_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*172*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS17_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*180*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Gfx & Sfx
        lea     CREDITS18_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*192*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS19_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*200*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Chucky
        lea     CREDITS20_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*212*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS21_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*220*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        ; Others...
        lea     CREDITS22_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*240*4)+40,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer
        lea     CREDITS23_STR,a0
        COPYSTR a0,a1
        move.l  GAMESCREEN_BITMAPBASE_BACK,a2
        add.l 	#(ScrBpl*248*4)+80,a2
        moveq   #0,d5
        move.w  #(64*7*4)+20,d6
        bsr     DrawStringBuffer

        rts