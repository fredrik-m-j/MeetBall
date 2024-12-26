IsDroppingBricks:
        dc.b    $ff
        even
; Contains address to digit or ":" in CHIP ram
ClockDigitMap:
        dcb.l   11,0


; Initializes the DigitMap
InitClockDigitMap:
	move.l	BOBS_BITMAPBASE,d0
	addi.l 	#ScrBpl*30*4+1,d0

	lea	ClockDigitMap,a0	; Set up digit bobs
        moveq   #10,d7
.loop
        move.l	d0,(a0)+
	addq.l 	#1,d0
        dbf     d7,.loop
	rts

ResetDropClock:
        move.l  #BrickDropSeries,BrickDropPtr

        move.l  BrickDropPtr,a0
        move.b  (a0)+,BrickDropMinutes
        move.b  (a0)+,BrickDropSeconds
        move.l  a0,BrickDropPtr
        rts

; Counts down to next brick drop.
; In:   a6 = address to CUSTOM dff000
BrickDropCountDown:
        tst.b   IsDroppingBricks
        bmi.s   .countdown
        subq.b  #1,IsDroppingBricks
        bge.s   .exit

.countdown
        subq.b	#1,BrickDropSeconds
        bmi.s   .minuteWrap
        bra.s   .drawSeconds
.minuteWrap
        move.b  #59,BrickDropSeconds
        subq.b	#1,BrickDropMinutes
        bhs.s   .drawMinutes

        bsr     AddBricksToQueue

        move.l  BrickDropPtr,a0
        move.b  (a0)+,BrickDropMinutes
        move.b  (a0)+,BrickDropSeconds
        
        cmpa.l  #BrickDropSeriesEND,a0
        beq.s   .restartDropSeries
        move.l  a0,BrickDropPtr

        bra.s   .drawMinutes
.restartDropSeries
        move.l  #BrickDropSeries,BrickDropPtr

.drawMinutes
        bsr     DrawClockMinutes
.drawSeconds
        bsr     DrawClockSeconds
.exit
        rts

; In:   a6 = address to CUSTOM dff000
DrawClockMinutes:
        ; Copy digit to BACK to preserve digit when Bat0 or shop is around.
        move.l 	GAMESCREEN_BITMAPBASE_BACK,a2
        add.l   #(ScrBpl*4*9)+34,a2     ; Starting point: 4 bitplanes, Y = 9, X = 34th byte

        moveq	#0,d0
	move.b	BrickDropMinutes,d0
	jsr	Binary2Decimal

        cmp.b   #1,d0
        bne.s   .draw
.initialZero
        move.l  ClockDigitMap,a1
        bsr     DrawClockDigit
        addq.l	#1,a2		        ; Align second digit to the right

.draw
	subq.b	#1,d0		        ; Ignore null char
.loop
	moveq	#0,d1
	move.b	(a0)+,d1
	subi.b	#$30,d1
	lsl.b	#2,d1		        ; We'll be adressing longwords in DigitMap

        lea     ClockDigitMap,a1
	move.l	(a1,d1),a1              ; Point to digit asset

        bsr     DrawClockDigit

	addq.l	#1,a2		        ; Next digit position
	dbf	d0,.loop

        lea     ClockDigitMap,a1        ; Draw the ":"
	move.l	4*10(a1),a1
        bsr     DrawClockDigit

        move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
        add.l   #(ScrBpl*9*4)+34,a0
        move.l 	GAMESCREEN_BITMAPBASE,a1
        add.l   #(ScrBpl*9*4)+34,a1
	moveq	#ScrBpl-2,d1
	move.w	#(64*12*4)+1,d2

        bsr	CopyRestoreGamearea     ; Blit to GAMESCREEN

        rts

; In:   a6 = address to CUSTOM dff000
DrawClockSeconds:
        ; Copy digit to BACK to preserve digit when Bat0 or shop is around.
        move.l 	GAMESCREEN_BITMAPBASE_BACK,a2
        add.l   #(ScrBpl*9*4)+37,a2     ; Starting point: 4 bitplanes, Y = 9, X = 37th byte

        moveq	#0,d0
	move.b	BrickDropSeconds,d0
	jsr	Binary2Decimal

        cmp.b   #1,d0
        bne.s   .draw
.initialZero
        move.l  ClockDigitMap,a1
        bsr     DrawClockDigit
        addq.l	#1,a2		        ; Align second digit to the right

.draw
	subq.b	#1,d0		        ; Ignore null char
.loop
	moveq	#0,d1
	move.b	(a0)+,d1
	subi.b	#$30,d1
	lsl.b	#2,d1		        ; We'll be adressing longwords in DigitMap
        
        lea     ClockDigitMap,a1
	move.l	(a1,d1),a1              ; Point to digit asset

	bsr     DrawClockDigit

	addq.l	#1,a2		        ; Next digit position
	dbf	d0,.loop   

        move.l 	GAMESCREEN_BITMAPBASE_BACK,a0
        add.l   #(ScrBpl*9*4)+36,a0
        move.l 	GAMESCREEN_BITMAPBASE,a1
        add.l   #(ScrBpl*9*4)+36,a1
	moveq	#ScrBpl-4,d1
	move.w	#(64*12*4)+2,d2

        bsr	CopyRestoreGamearea     ; Blit to GAMESCREEN

        rts

; In:   a1 = Source digit (planar)
; In:   a2 = Destination game screen
DrawClockDigit:
	move.b  0*40(a1),0*40(a2)
        move.b  1*40(a1),1*40(a2)
        move.b  2*40(a1),2*40(a2)
        move.b  3*40(a1),3*40(a2)

	move.b  4*40(a1),4*40(a2)
        move.b  5*40(a1),5*40(a2)
        move.b  6*40(a1),6*40(a2)
        move.b  7*40(a1),7*40(a2)

	move.b  8*40(a1),8*40(a2)
        move.b  9*40(a1),9*40(a2)
        move.b  10*40(a1),10*40(a2)
        move.b  11*40(a1),11*40(a2)

	move.b  12*40(a1),12*40(a2)
        move.b  13*40(a1),13*40(a2)
        move.b  14*40(a1),14*40(a2)
        move.b  15*40(a1),15*40(a2)

	move.b  16*40(a1),16*40(a2)
        move.b  17*40(a1),17*40(a2)
        move.b  18*40(a1),18*40(a2)
        move.b  19*40(a1),19*40(a2)
        
	move.b  20*40(a1),20*40(a2)
        move.b  21*40(a1),21*40(a2)
        move.b  22*40(a1),22*40(a2)
        move.b  23*40(a1),23*40(a2)

	move.b  24*40(a1),24*40(a2)
        move.b  25*40(a1),25*40(a2)
        move.b  26*40(a1),26*40(a2)
        move.b  27*40(a1),27*40(a2)

	move.b  28*40(a1),28*40(a2)
        move.b  29*40(a1),29*40(a2)
        move.b  30*40(a1),30*40(a2)
        move.b  31*40(a1),31*40(a2)

	move.b  32*40(a1),32*40(a2)
        move.b  33*40(a1),33*40(a2)
        move.b  34*40(a1),34*40(a2)
        move.b  35*40(a1),35*40(a2)

	move.b  36*40(a1),36*40(a2)
        move.b  37*40(a1),37*40(a2)
        move.b  38*40(a1),38*40(a2)
        move.b  39*40(a1),39*40(a2)

	move.b  40*40(a1),40*40(a2)
        move.b  41*40(a1),41*40(a2)
        move.b  42*40(a1),42*40(a2)
        move.b  43*40(a1),43*40(a2)

	move.b  44*40(a1),44*40(a2)
        move.b  45*40(a1),45*40(a2)
        move.b  46*40(a1),46*40(a2)
        move.b  47*40(a1),47*40(a2)

        rts