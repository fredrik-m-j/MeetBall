; General macros
;------------------------

; Byte/char copy
; In:   = \1 from address register
; In:   = \2 to address register
COPYSTR	        MACRO
.\@	move.b  (\1)+,(\2)+
	bne.s	.\@
	ENDM

; Concatenate 2 null-terminated strings
; In:   = \1 string a
; In:   = \2 string b
; Out:  = \3 result
CONCATSTR       MACRO
	COPYSTR	\1,\3
	subq.l	#1,\3
	COPYSTR	\2,\3
	ENDM

; This will add + sign for good looks.
; In:   = d0.l
; In:   = \1 working address register - thrashed
; Out:  = \2 string result. address register
; a0 is thrashed
SIGNDSTR     MACRO
	tst.l	d0
	ble.s	.\@number

	lea		PLUS_STR,\1
	COPYSTR	\1,\2
	jsr		Binary2Decimal
	APNDSTR	a0,\2
	bra.s	.\@done
.\@number
	jsr		Binary2Decimal
	COPYSTR	a0,\2
.\@done
	ENDM

; Appends null-terminated string to another
; In:   = \1 source string to be appended
; In:   = \2 address to end of destination string
APNDSTR       MACRO
	subq.l	#1,\2
	COPYSTR	\1,\2
	ENDM

; Frame synchronization (when not using interrupt).
; In:	\1 = A data register
WAITBOVP	MACRO
.\@vpos
	move.l	CUSTOM+VPOSR,\1
	and.l	#$1ff00,\1
	cmp.l	#303<<8,\1				; Wait for line 303
	bne.b	.\@vpos
.\@vposNext
	move.l	CUSTOM+VPOSR,\1
	and.l	#$1ff00,\1
	cmp.l	#304<<8,\1				; Wait for line 304 - for really fast CPUs
	bne.b	.\@vposNext
	ENDM

WAITVBL MACRO
.\@waitVbl
	btst	#5,$dff01f				; INTREQR +1
	beq.b	.\@waitVbl
	move.w	#INTF_VERTB,$dff09c		; Clear VBL
	ENDM

; In:   = a6 CUSTOM chipset address register
WAITBLIT	MACRO
	tst.b	DMACONR(a6)
.\@
	btst	#6,DMACONR(a6)
	bne.s	.\@
	ENDM

; Tanks to djh0ffman streams.
; In:   = a6 CUSTOM chipset address register
WAITBLITN	MACRO
	move.w	#BLTPRI_ENABLE,DMACON(a6)
	tst.b	DMACONR(a6)
.\@	btst	#6,DMACONR(a6)
	bne.s	.\@
	move.w	#BLTPRI_DISABLE,DMACON(a6)
	ENDM


; INSPIRED BY
; djh0ffman - Knightmare
; https://github.com/djh0ffman/KnightmareAmiga
;----------------------------------------------------------------------------
;
; textchar plot macro
;
; \1 font address 
; \2 screen address
; \3 stride
;----------------------------------------------------------------------------
PLANARCHARPLOT_6_4 MACRO
	move.b	\3*0(\1),\3*0(\2)
	move.b	\3*1(\1),\3*1(\2)
	move.b	\3*2(\1),\3*2(\2)
	move.b	\3*3(\1),\3*3(\2)

	move.b	\3*4(\1),\3*4(\2)
	move.b	\3*5(\1),\3*5(\2)
	move.b	\3*6(\1),\3*6(\2)
	move.b	\3*7(\1),\3*7(\2)

	move.b	\3*8(\1),\3*8(\2)
	move.b	\3*9(\1),\3*9(\2)
	move.b	\3*10(\1),\3*10(\2)
	move.b	\3*11(\1),\3*11(\2)

	move.b	\3*12(\1),\3*12(\2)
	move.b	\3*13(\1),\3*13(\2)
	move.b	\3*14(\1),\3*14(\2)
	move.b	\3*15(\1),\3*15(\2)

	move.b	\3*16(\1),\3*16(\2)
	move.b	\3*17(\1),\3*17(\2)
	move.b	\3*18(\1),\3*18(\2)
	move.b	\3*19(\1),\3*19(\2)

	move.b	\3*20(\1),\3*20(\2)
	move.b	\3*21(\1),\3*21(\2)
	move.b	\3*22(\1),\3*22(\2)
	move.b	\3*23(\1),\3*23(\2)

;     move.b       \3*24(\1),\3*24(\2)
;     move.b       \3*25(\1),\3*25(\2)
;     move.b       \3*26(\1),\3*26(\2)
;     move.b       \3*27(\1),\3*27(\2)

;     move.b       \3*28(\1),\3*28(\2)
;     move.b       \3*29(\1),\3*29(\2)
;     move.b       \3*30(\1),\3*30(\2)
;     move.b       \3*31(\1),\3*31(\2)

	ENDM

PLANARCHARPLOT_8_1 MACRO
	move.b	\3*0(\1),\3*0(\2)
	move.b	\3*4(\1),\3*4(\2)
	move.b	\3*8(\1),\3*8(\2)
	move.b	\3*12(\1),\3*12(\2)
	move.b	\3*16(\1),\3*16(\2)
	move.b	\3*20(\1),\3*20(\2)
	move.b	\3*24(\1),\3*24(\2)
	move.b	\3*28(\1),\3*28(\2)
	ENDM

CHRCLR81 MACRO
	clr.b	\2*0(\1)
	clr.b	\2*4(\1)
	clr.b	\2*8(\1)
	clr.b	\2*12(\1)
	clr.b	\2*16(\1)
	clr.b	\2*20(\1)
	clr.b	\2*24(\1)
	clr.b	\2*28(\1)
	ENDM

; Does a screenbuffer swap, writing the bitplane pointers into copperlist.
; In:   = \1 Adress to BPL0PTH in copperlist 
; In:   = \2 Adress to other buffer
; In:   = \3 Temp dataregister
; In:   = \4 Loop counter
BUFRSWAP MACRO
	move.w	#BPL0PTH,\3
	moveq	#4-1,\4
.\@bp
	swap	\2
	move.w	\3,(\1)+				; PTH
	move.w	\2,(\1)+

	addq.w	#2,\3
	swap	\2
	move.w	\3,(\1)+				; PTL
	move.w	\2,(\1)+

	addq.w	#2,\3
	add.l	#RL_SIZE,\2				; Next interleaved bitplane

	dbf		\4,.\@bp
	ENDM


; Clears 8*8 pixels in all (4) planes using CPU.
; In:   = \1 Planar destination (top).
CPUCLR88 MACRO 
	clr.b	0*40(\1)
	clr.b	1*40(\1)
	clr.b	2*40(\1)
	clr.b	3*40(\1)

	clr.b	4*40(\1)
	clr.b	5*40(\1)
	clr.b	6*40(\1)
	clr.b	7*40(\1)

	clr.b	8*40(\1)
	clr.b	9*40(\1)
	clr.b	10*40(\1)
	clr.b	11*40(\1)

	clr.b	12*40(\1)
	clr.b	13*40(\1)
	clr.b	14*40(\1)
	clr.b	15*40(\1)

	clr.b	16*40(\1)
	clr.b	17*40(\1)
	clr.b	18*40(\1)
	clr.b	19*40(\1)

	clr.b	20*40(\1)
	clr.b	21*40(\1)
	clr.b	22*40(\1)
	clr.b	23*40(\1)

	clr.b	24*40(\1)
	clr.b	25*40(\1)
	clr.b	26*40(\1)
	clr.b	27*40(\1)

	clr.b	28*40(\1)
	clr.b	29*40(\1)
	clr.b	30*40(\1)
	clr.b	31*40(\1)
	ENDM

; Copies 8*8 pixels in 4 planes using CPU.
; In:   = \1 Planar source (top).
; In:   = \2 Planar destination (top).
CPUCPY88 MACRO 
	move.b	0*40(\1),0*40(\2)
	move.b	1*40(\1),1*40(\2)
	move.b	2*40(\1),2*40(\2)
	move.b	3*40(\1),3*40(\2)

	move.b	4*40(\1),4*40(\2)
	move.b	5*40(\1),5*40(\2)
	move.b	6*40(\1),6*40(\2)
	move.b	7*40(\1),7*40(\2)

	move.b	8*40(\1),8*40(\2)
	move.b	9*40(\1),9*40(\2)
	move.b	10*40(\1),10*40(\2)
	move.b	11*40(\1),11*40(\2)

	move.b	12*40(\1),12*40(\2)
	move.b	13*40(\1),13*40(\2)
	move.b	14*40(\1),14*40(\2)
	move.b	15*40(\1),15*40(\2)

	move.b	16*40(\1),16*40(\2)
	move.b	17*40(\1),17*40(\2)
	move.b	18*40(\1),18*40(\2)
	move.b	19*40(\1),19*40(\2)

	move.b	20*40(\1),20*40(\2)
	move.b	21*40(\1),21*40(\2)
	move.b	22*40(\1),22*40(\2)
	move.b	23*40(\1),23*40(\2)

	move.b	24*40(\1),24*40(\2)
	move.b	25*40(\1),25*40(\2)
	move.b	26*40(\1),26*40(\2)
	move.b	27*40(\1),27*40(\2)

	move.b	28*40(\1),28*40(\2)
	move.b	29*40(\1),29*40(\2)
	move.b	30*40(\1),30*40(\2)
	move.b	31*40(\1),31*40(\2)
	ENDM

; Copies 8*8 pixels in 4 planes using CPU.
; In:   = \1 Planar source (top).
; In:   = \2 Planar destination (top).
CPUCPY168 MACRO 
	move.w	0*40(\1),0*40(\2)
	move.w	1*40(\1),1*40(\2)
	move.w	2*40(\1),2*40(\2)
	move.w	3*40(\1),3*40(\2)

	move.w	4*40(\1),4*40(\2)
	move.w	5*40(\1),5*40(\2)
	move.w	6*40(\1),6*40(\2)
	move.w	7*40(\1),7*40(\2)

	move.w	8*40(\1),8*40(\2)
	move.w	9*40(\1),9*40(\2)
	move.w	10*40(\1),10*40(\2)
	move.w	11*40(\1),11*40(\2)

	move.w	12*40(\1),12*40(\2)
	move.w	13*40(\1),13*40(\2)
	move.w	14*40(\1),14*40(\2)
	move.w	15*40(\1),15*40(\2)

	move.w	16*40(\1),16*40(\2)
	move.w	17*40(\1),17*40(\2)
	move.w	18*40(\1),18*40(\2)
	move.w	19*40(\1),19*40(\2)

	move.w	20*40(\1),20*40(\2)
	move.w	21*40(\1),21*40(\2)
	move.w	22*40(\1),22*40(\2)
	move.w	23*40(\1),23*40(\2)

	move.w	24*40(\1),24*40(\2)
	move.w	25*40(\1),25*40(\2)
	move.w	26*40(\1),26*40(\2)
	move.w	27*40(\1),27*40(\2)

	move.w	28*40(\1),28*40(\2)
	move.w	29*40(\1),29*40(\2)
	move.w	30*40(\1),30*40(\2)
	move.w	31*40(\1),31*40(\2)
	ENDM

; Copies 8*8 pixels in 1 singular plane using CPU.
; In:   = \1 Planar source (top).
CPUSET88 MACRO
	move.b	#$ff,0*40(\1)
	move.b	#$ff,4*40(\1)
	move.b	#$ff,8*40(\1)
	move.b	#$ff,12*40(\1)
	move.b	#$ff,16*40(\1)
	move.b	#$ff,20*40(\1)
	move.b	#$ff,24*40(\1)
	move.b	#$ff,28*40(\1)
	ENDM

; Highly specific macros
;------------------------

; In:   = \1 Adress to an EnemyStruct
CLRENEMY MACRO
	clr.l	hSprBobTopLeftXPos(\1)
    clr.l	hSprBobBottomRightXPos(\1)
	clr.b	hIndex(\1)
	move.b	#3,hLastIndex(\1)
    move.w	#ENEMY1_BLITSIZE,hBobBlitSize(\1)
	move.w	#ENEMYSTATE_DEAD,hEnemyState(\1)
	ENDM

; In:   = \1 Adress to an BulletStruct
CLRBULLET MACRO
	clr.l	hSprBobXCurrentSpeed(\1)	; .l to clear both X & Y
	ENDM

; Copies most vital ball data to another ball struct
; In:   = \1 Adress to source BallStruct
; In:   = \2 Adress to target BallStruct
REASGNBL MACRO
	move.l	hPlayerBat(\1),hPlayerBat(\2)
	move.l	hSprBobTopLeftXPos(\1),hSprBobTopLeftXPos(\2)
	move.l	hSprBobBottomRightXPos(\1),hSprBobBottomRightXPos(\2)
	move.l	hSprBobXCurrentSpeed(\1),hSprBobXCurrentSpeed(\2)
	move.l	hSprBobXSpeed(\1),hSprBobXSpeed(\2)
	ENDM


; Performs an OR to write letter pixels. Clears any previous letter (7 pixels wide)
; In:   = \1 Adress to letter 
; In:   = \2 Adress to start of target sprite color data words.
; In:   = \3 Loop counter
; In:   = \4 Temp data register
LETTRCPY MACRO
.\@loop
	move.l	(\2),\4
	and.w	#%1100000001111111,\4
	or.l	(\1)+,\4
	move.l	\4,(\2)+
	dbf		\3,.\@loop

	ENDM

; Add the score in dataregister to all enabled player(s)
; In:   = \1 Dataregister longword - the score to add
ALLSCORE MACRO
	tst.b	Player0Enabled(a5)
	bmi		.\@checkPlayer1
	add.l	\1,Player0Score(a5)
	clr.b	DirtyPlayer0Score(a5)
.\@checkPlayer1
	tst.b	Player1Enabled(a5)
	bmi		.\@checkPlayer2
	add.l	\1,Player1Score(a5)
	clr.b	DirtyPlayer1Score(a5)
.\@checkPlayer2
	tst.b	Player2Enabled(a5)
	bmi		.\@checkPlayer3
	add.l	\1,Player2Score(a5)
	clr.b	DirtyPlayer2Score(a5)
.\@checkPlayer3
	tst.b	Player3Enabled(a5)
	bmi		.\@exit
	add.l	\1,Player3Score(a5)
	clr.b	DirtyPlayer3Score(a5)
.\@exit
	ENDM


; In:   = \1 Dataregister - temp THRASHED
; In:   = \2 Addressregister pointing to a tilecode byte
; In:   = \3 Addressregister - THRASHED
; Out:	= \3 Addressregister pointing to a tile structure
GETTILE MACRO
	moveq	#0,\1
	move.b	(\2),\1
	add.w	\1,\1					; Convert .b to .l
	add.w	\1,\1
	lea		TileMap,\3
	move.l	(\3,\1.l),\3			; Lookup in tile map
	lea		(\3),\3
	ENDM