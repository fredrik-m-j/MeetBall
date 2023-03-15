; Byte/char copy
; In:   = \1 from address register
; In:   = \2 to address register
COPYSTR	        MACRO
.\@		move.b  (\1)+,(\2)+
		bne.s	.\@
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