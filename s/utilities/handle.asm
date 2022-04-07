; CREDITS
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com

; Create a new global handle or resource
; In:	d0 = Resource Type to return
; Out:	d0 = Handle number
; Out:	a0 = Handle pointer
;--------------------------------------
agdCreateNewHandle:
		movem.l	d6-d7,-(a7)
		move.l	#0,d6				; Handle counter
		move.l	#maxResourceStructs-1,d7	; Maximum number of handles
		lea	RESOURCE_TABLE,a0
		lsl.l	#3,d0				; Multiply by 8
		add.l	d0,a0				; Index to correct type
		
		move.l	4(a0),d0			; Get the structure size
		move.l	(a0),a0				; Get the address of the structures

.loop:		tst.w	(a0)				; Is the handle free?
		bmi	.allocate
		add.l	d0,a0				; Next handle
		add.w	#1,d6
		dbf	d7,.loop
		moveq	#-1,d0				; Error code in d0
		sub.l	a0,a0				; Null a0
		bra	.exit
		
; Exhausted all handles
.allocate:	move.l	d6,d0				; Return handle 
		
.exit:		movem.l	(a7)+,d6-d7
		rts
	