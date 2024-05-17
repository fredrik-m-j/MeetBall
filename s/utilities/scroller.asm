; CREDITS
; Linedrawing routine based on the simpleline.asm.
; Source:	
;		https://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node02DF.html
; 
; simpleline.asm
;
;   This example uses the line draw mode of the blitter
;   to draw a line.  The line is drawn with no pattern
;   and a simple `or' blit into a single bitplane.
;   (Link with amiga.lib)
;
;   Input:  d0=x1 d1=y1 d2=x2 d3=y2 d4=width a0=aptr
;
;         include 'exec/types.i'
;         include 'hardware/custom.i'
;         include 'hardware/blit.i'
;         include 'hardware/dmabits.i'
;         include 'hardware/hw_examples.i'
;
;         xref    _custom
;
;         xdef    simpleline
;
;   Our entry point.
;
DrawLinescroller:
	lea 	CUSTOM,a6

	move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
	add.l   #(ScrBpl*200*4)+3*ScrBpl,a0
	moveq	#0,d0
	move.w	#(64*33*4)+20,d1
	bsr 	ClearBlitWords

	move.l	#ScrBpl*4,d4
        move.l 	GAMESCREEN_BITMAPBASE_BACK,a3
	add.l	#3*ScrBpl,a3

        lea     ScrollTextPtr,a0
        move.l  (a0),a2
        tst.b   (a2)                    ; Reset?
        bne     .skipReset
        move.l  #ScrollText,(a0)
        move.w  #286,4(a0)
.skipReset
        move.l  (a0)+,a4                ; Leftmost char in text
        move.w  (a0),d6                 ; Current leftmost X

        sub.w	#1,d6                   ; In bounds?
	bpl	.setLeftX

        addq.l  #1,a4
        move.l  a4,ScrollTextPtr        ; Set new leftmost char

        tst.b   (a4)                    ; Null?
        beq     .exit

        moveq   #0,d0
        move.b  -1(a4),d0

        sub.b   #$20,d0                 ; Lookup line-char
        add.b   d0,d0
        add.b   d0,d0

        lea     CharLoopkup,a2
        add.l   d0,a2
        move.l  (a2),a2

        add.w   (a2),d6
.setLeftX
        move.w  d6,(a0)

.nextChar
        moveq   #0,d0
        move.b  (a4)+,d0

        sub.b   #$20,d0                  ; Lookup line-char
        add.b   d0,d0
        add.b   d0,d0

        lea     CharLoopkup,a2
        add.l   d0,a2
        move.l  (a2),a2

        move.w	(a2)+,d7                ; Current char width + margin

.firstLine
	move.w	(a2)+,d0                ; Next char?
	bmi	.moveNext
        addq.l	#2,a2

.drawNextLine
        moveq	#0,d0
        moveq	#0,d1
        moveq	#0,d2
        moveq	#0,d3

	move.w	(a2)+,d2

        cmp.b   #-1,d2
        bgt     .continue
	blt     .firstLine
        beq     .moveNext       
       
.continue
        move.w  -6(a2),d0
        move.w  -4(a2),d1

        move.w	(a2)+,d3

        add.w   d6,d0           ; Apply base X to relative X-position
        add.w   d6,d2

        move.l  a3,a0           ; Restore screenptr

; Input:  d0=x1 d1=y1 d2=x2 d3=y2 d4=width a0=aptr
; SimpleLine:

        lea     CUSTOM,a1       ; snarf up the custom address register
        sub.w   d0,d2           ; calculate dx
        bmi     .xneg           ; if negative, octant is one of [3,4,5,6]
        sub.w   d1,d3           ; calculate dy   ''   is one of [1,2,7,8]
        bmi     .yneg           ; if negative, octant is one of [7,8]
        cmp.w   d3,d2           ; cmp |dx|,|dy|  ''   is one of [1,2]
        bmi     .ygtx           ; if y>x, octant is 2
        moveq.l #OCTANT1+LINEMODE,d5    ; otherwise octant is 1
        bra     .lineagain      ; go to the common section
.ygtx
        exg     d2,d3           ; X must be greater than Y
        moveq.l #OCTANT2+LINEMODE,d5    ; we are in octant 2
        bra     .lineagain      ; and common again.
.yneg
        neg.w   d3              ; calculate abs(dy)
        cmp.w   d3,d2           ; cmp |dx|,|dy|, octant is [7,8]
        bmi     .ynygtx         ; if y>x, octant is 7
        moveq.l #OCTANT8+LINEMODE,d5    ; otherwise octant is 8
        bra     .lineagain
.ynygtx
        exg     d2,d3           ; X must be greater than Y
        moveq.l #OCTANT7+LINEMODE,d5    ; we are in octant 7
        bra     .lineagain
.xneg
        neg.w   d2              ; dx was negative! octant is [3,4,5,6]
        sub.w   d1,d3           ; we calculate dy
        bmi     .xyneg          ; if negative, octant is one of [5,6]
        cmp.w   d3,d2           ; otherwise it's one of [3,4]
        bmi     .xnygtx         ; if y>x, octant is 3
        moveq.l #OCTANT4+LINEMODE,d5    ; otherwise it's 4
        bra     .lineagain
.xnygtx
        exg     d2,d3           ; X must be greater than Y
        moveq.l #OCTANT3+LINEMODE,d5    ; we are in octant 3
        bra     .lineagain
.xyneg
        neg.w   d3              ; y was negative, in one of [5,6]
        cmp.w   d3,d2           ; is y>x?
        bmi     .xynygtx        ; if so, octant is 6
        moveq.l #OCTANT5+LINEMODE,d5    ; otherwise, octant is 5
        bra     .lineagain
.xynygtx
        exg     d2,d3           ; X must be greater than Y
        moveq.l #OCTANT6+LINEMODE,d5    ; we are in octant 6
.lineagain
        mulu.w  d4,d1           ; Calculate y1 * width
        ror.l   #4,d0           ; move upper four bits into hi word
        add.w   d0,d0           ; multiply by 2
        add.l   d1,a0           ; ptr += (x1 >> 3)
        add.w   d0,a0           ; ptr += y1 * width
        swap    d0              ; get the four bits of x1
        or.w    #$BFA,d0        ; or with USEA, USEC, USED, F=A+C
        lsl.w   #2,d3           ; Y = 4 * Y
        add.w   d2,d2           ; X = 2 * X
        move.w  d2,d1           ; set up size word
        lsl.w   #5,d1           ; shift five left
        add.w   #$42,d1         ; and add 1 to height, 2 to width
        
;         btst    #DMAB_BLTDONE-8,DMACONR(a1)     ; safety check
; waitblit:
;         btst    #DMAB_BLTDONE-8,DMACONR(a1)     ; wait for blitter
;         bne     waitblit
        WAITBLIT a1

        move.w  d3,BLTBMOD(a1)  ; B mod = 4 * Y
        sub.w   d2,d3
        ext.l   d3
        move.l  d3,BLTAPT(a1)   ; A ptr = 4 * Y - 2 * X
        bpl     .lineover       ; if negative,
        or.w    #SIGNFLAG,d5    ; set sign bit in con1
.lineover
        move.w  d0,BLTCON0(a1)  ; write control registers
        move.w  d5,BLTCON1(a1)
        move.w  d4,BLTCMOD(a1)  ; C mod = bitplane width
        move.w  d4,BLTDMOD(a1)  ; D mod = bitplane width
        sub.w   d2,d3
        move.w  d3,BLTAMOD(a1)  ; A mod = 4 * Y - 4 * X
        move.w  #$8000,BLTADAT(a1)      ; A data = 0x8000
        moveq.l #-1,d5          ; Set masks to all ones
        move.l  d5,BLTAFWM(a1)  ; we can hit both masks at once
        move.l  a0,BLTCPT(a1)   ; Pointer to first pixel to set
        move.l  a0,BLTDPT(a1)
        move.w  d1,BLTSIZE(a1)  ; Start blit
        

        bra     .drawNextLine

.moveNext
        add.w   d7,d6           ; Add char width + margin

        cmp.w   #286,d6         ; Room for one more char?
        bhi     .exit

        tst.b   (a4)            ; At the end of the text?
        bne     .nextChar       
.exit
        rts                     ; and return, blit still in progress.