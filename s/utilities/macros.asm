; Byte/char copy
; In:   = \1 from address register
; In:   = \2 to address register
COPYSTR	        MACRO
.\@		move.b  (\1)+,(\2)+
		bne.s	.\@
		ENDM