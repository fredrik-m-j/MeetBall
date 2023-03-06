CHAR_S          equ     51
CHAR_W          equ     55

STRINGBUFFER:   dcb.b   40,$0

JOY0_STR:       dc.b    "JOYSTICK 0",0
        even
JOY1_STR:       dc.b    "JOYSTICK 1",0
        even
JOY2_STR:       dc.b    "PARALLEL 0",0
        even
JOY3_STR:       dc.b    "PARALLEL 1",0
        even
UP_STR:         dc.b    "   UP:",0
        even
DOWN_STR:       dc.b    " DOWN:",0
        even
LEFT_STR:       dc.b    " LEFT:",0
        even
RIGHT_STR:      dc.b    "RIGHT:",0
        even
FIRE_STR:       dc.b    " FIRE:",0
        even
LSHIFT_STR      dc.b    "L.SHIFT",0
        even
RSHIFT_STR      dc.b    "R.SHIFT",0
        even
LAMIGA_STR      dc.b    "L.AMIGA",0
        even
RAMIGA_STR      dc.b    "R.AMIGA",0
        even

MenuClearPlayer0Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*155*4)+30,a0
        move.w  #ScrBpl-10,d1
        move.W  #(64*24*4)+5,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer1Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*155*4),a0
        move.w  #ScrBpl-10,d1
        move.W  #(64*24*4)+5,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer2Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*220*4)+22,a0
        move.w  #ScrBpl-14,d1
        move.W  #(64*24*4)+7,d2

        bsr     ClearBlitWords
        rts
MenuClearPlayer3Text:
        move.l  MENUSCREEN_BITMAPBASE,a0
        add.l 	#(ScrBpl*12*4)+22,a0
        move.w  #ScrBpl-14,d1
        move.W  #(64*24*4)+7,d2

        bsr     ClearBlitWords
        rts

MenuDrawPlayer0Joy:
        WAITBLIT
        lea     JOY1_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*155*4)+29,a6
        bsr     DrawStringBuffer
        rts
MenuDrawPlayer1Joy:
        WAITBLIT
        lea     JOY0_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*155*4),a6
        bsr     DrawStringBuffer
        rts
MenuDrawPlayer2Joy:
        WAITBLIT
        lea     JOY2_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*236*4)+22,a6
        bsr     DrawStringBuffer
        rts
MenuDrawPlayer3Joy:
        WAITBLIT
        lea     JOY3_STR,a2
        lea     STRINGBUFFER,a1
        COPYSTR a2,a1
        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*12*4)+22,a6
        bsr     DrawStringBuffer
        rts

MenuDrawPlayer0UD:
        WAITBLIT

        lea     UP_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z"+2,-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*155*4)+29,a6
        bsr     DrawStringBuffer                ; Up

        lea     DOWN_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z"+3,-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*163*4)+29,a6
        bsr     DrawStringBuffer                ; Down

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     RSHIFT_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*171*4)+29,a6
        bsr     DrawStringBuffer                ; Fire

        rts

MenuDrawPlayer1WS:
        WAITBLIT

        lea     UP_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"W",-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*155*4),a6
        bsr     DrawStringBuffer                ; Up

        lea     DOWN_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"S",-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*163*4),a6
        bsr     DrawStringBuffer                ; Down

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LSHIFT_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*171*4),a6
        bsr     DrawStringBuffer                ; Fire

        rts

MenuDrawPlayer2LR:
        WAITBLIT

        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z"+1,-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*220*4)+22,a6
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"Z"+4,-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*228*4)+22,a6
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     RAMIGA_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*236*4)+22,a6
        bsr     DrawStringBuffer                ; Fire

        rts

MenuDrawPlayer3AD:
        WAITBLIT

        lea     LEFT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"A",-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*12*4)+22,a6
        bsr     DrawStringBuffer                ; Left

        lea     RIGHT_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1
        move.b  #"S",-1(a1)
        move.b  #0,(a1)

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*20*4)+22,a6
        bsr     DrawStringBuffer                ; Right

        lea     FIRE_STR,a0
        lea     STRINGBUFFER,a1
        COPYSTR a0,a1

        lea     LAMIGA_STR,a0
        sub.l   #1,a1
        COPYSTR a0,a1

        move.l  MENUSCREEN_BITMAPBASE,a6
        add.l 	#(ScrBpl*28*4)+22,a6
        bsr     DrawStringBuffer                ; Fire

        rts


; In:   a6 = Destination (4 bitplanes)
DrawStringBuffer:
        lea     FONT,a3
        lea     STRINGBUFFER,a1
        moveq   #0,d1
.l
        move.l  a3,a5
        move.b  (a1)+,d1
        beq.s   .exit

        subi.b  #$20,d1
        add.l   d1,a5

        bsr     DrawSinglePlaneChar

        addq.l  #1,a6
        bra.s   .l
.exit
        rts

; In:	a5 = Address to source char (1 bitplane)
; In:   a6 = Destination (4 bitplanes)
DrawSinglePlaneChar:
	move.b  0*64(a5),0*40(a6)
        move.b  1*64(a5),4*40(a6)
        move.b  2*64(a5),8*40(a6)
        move.b  3*64(a5),12*40(a6)

	move.b  4*64(a5),16*40(a6)
        move.b  5*64(a5),20*40(a6)
        move.b  6*64(a5),24*40(a6)
        move.b  7*64(a5),28*40(a6)

        rts


; In:   a0 = Destination to clear
; In:   d1.w = Destination modulo
; In:   d2.w = Blit size
ClearBlitWords:
        lea 	CUSTOM,a6
        
        WAITBLIT

	move.l 	#$01000000,BLTCON0(a6)
	move.l 	a0,BLTDPTH(a6)
	move.w 	d1,BLTDMOD(a6)

	move.w 	d2,BLTSIZE(a6)
        rts