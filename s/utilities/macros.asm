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
        COPYSTR \1,\3
        subq.l  #1,\3
        COPYSTR \2,\3
	ENDM

; This will add + sign for good looks.
; In:   = d0.l
; In:   = \1 working address register - thrashed
; Out:  = \2 string result. address register
; a0 is thrashed
SIGNEDTOSTR     MACRO
	tst.l   d0
	ble.s	.\@number

	lea	PLUS_STR,\1
	COPYSTR \1,\2
        jsr	Binary2Decimal
        APPENDSTR a0,\2
        bra.s   .\@done
.\@number
        jsr	Binary2Decimal
	COPYSTR a0,\2
.\@done
        ENDM

; Appends null-terminated string to another
; In:   = \1 source string to be appended
; In:   = \2 address to end of destination string
APPENDSTR       MACRO
        subq.l  #1,\2
        COPYSTR \1,\2
	ENDM

; TODO: Consider using interrupt - this wastes 1 scanline but assure steady framerate for fast CPUs.
; Helps drawing as much as possible during vertical blank.
; In:	\1 = A data register
WAITLASTLINE	MACRO
.\@vpos
	move.l  CUSTOM+VPOSR,\1
        and.l   #$1ff00,\1
        cmp.l   #303<<8,\1              ; Wait for line 303
        bne.b   .\@vpos
.\@vposNext:
	move.l  CUSTOM+VPOSR,\1
        and.l   #$1ff00,\1
        cmp.l   #304<<8,\1              ; Wait for line 304 - for really fast CPUs
        bne.b   .\@vposNext
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
    move.b       \3*0(\1),\3*0(\2)
    move.b       \3*1(\1),\3*1(\2)
    move.b       \3*2(\1),\3*2(\2)
    move.b       \3*3(\1),\3*3(\2)

    move.b       \3*4(\1),\3*4(\2)
    move.b       \3*5(\1),\3*5(\2)
    move.b       \3*6(\1),\3*6(\2)
    move.b       \3*7(\1),\3*7(\2)

    move.b       \3*8(\1),\3*8(\2)
    move.b       \3*9(\1),\3*9(\2)
    move.b       \3*10(\1),\3*10(\2)
    move.b       \3*11(\1),\3*11(\2)

    move.b       \3*12(\1),\3*12(\2)
    move.b       \3*13(\1),\3*13(\2)
    move.b       \3*14(\1),\3*14(\2)
    move.b       \3*15(\1),\3*15(\2)

    move.b       \3*16(\1),\3*16(\2)
    move.b       \3*17(\1),\3*17(\2)
    move.b       \3*18(\1),\3*18(\2)
    move.b       \3*19(\1),\3*19(\2)

    move.b       \3*20(\1),\3*20(\2)
    move.b       \3*21(\1),\3*21(\2)
    move.b       \3*22(\1),\3*22(\2)
    move.b       \3*23(\1),\3*23(\2)

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
        move.b       \3*0(\1),\3*0(\2)
        move.b       \3*4(\1),\3*4(\2)
        move.b       \3*8(\1),\3*8(\2)
        move.b       \3*12(\1),\3*12(\2)
        move.b       \3*16(\1),\3*16(\2)
        move.b       \3*20(\1),\3*20(\2)
        move.b       \3*24(\1),\3*24(\2)
        move.b       \3*28(\1),\3*28(\2)
        ENDM

PLANARCHARCLEAR_8_1 MACRO
        clr.b       \2*0(\1)
        clr.b       \2*4(\1)
        clr.b       \2*8(\1)
        clr.b       \2*12(\1)
        clr.b       \2*16(\1)
        clr.b       \2*20(\1)
        clr.b       \2*24(\1)
        clr.b       \2*28(\1)
        ENDM






; Highly specific macros
;------------------------

; In:   = \1 Adress to an EnemyStruct
CLEAR_ENEMYSTRUCT MACRO
        clr.l   hSprBobTopLeftXPos(\1)
        clr.l   hSprBobBottomRightXPos(\1)
        clr.l   hSprBobBottomRightXPos(\1)
	clr.b   hIndex(\1)
        move.b  #3,hLastIndex(\1)
        move.w  #Enemy1BlitSize,hBobBlitSize(\1)
        move.w  #eDead,hEnemyState(\1)
	ENDM

; In:   = \1 Adress to an BulletStruct
CLEAR_BULLETSTRUCT MACRO
        clr.l	hSprBobXCurrentSpeed(\1)        ; .l to clear both X & Y
        ENDM

; Copies most vital ball data to another ball struct
; In:   = \1 Adress to source BallStruct
; In:   = \2 Adress to target BallStruct
REASSIGN_BALL MACRO
        move.l  hPlayerBat(\1),hPlayerBat(\2)
        move.l  hSprBobTopLeftXPos(\1),hSprBobTopLeftXPos(\2)
        move.l  hSprBobBottomRightXPos(\1),hSprBobBottomRightXPos(\2)
        move.l  hSprBobXCurrentSpeed(\1),hSprBobXCurrentSpeed(\2)
        move.l  hSprBobXSpeed(\1),hSprBobXSpeed(\2)
        ENDM