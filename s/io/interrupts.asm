; CREDITS
; Author:	???
;		Posted by Graeme Cowie (Mcgeezer)
;		https://eab.abime.net/showpost.php?p=1411387&postcount=8
;		https://mcgeezer.itch.io
; History: 
;		Feb 2022 FmJ
;		* Added enable I/O Ports and timers.
;		* I get VBR base in other place so that part is commented out.
;		* Save/restore also a0/a1 just in case...
;		* Added RestoreInterrupts.
;		July 2023 FmJ
;		* Added vertical blank interrupt

intVectorLevel1	=	$64
intVectorLevel2	=	$68
intVectorLevel3	=	$6c
intVectorLevel4	=	$70
intVectorLevel5	=	$74
intVectorLevel6	=	$78
intVectorLevel7	=	$7c


; In:	a6 = address to CUSTOM $dff000
InstallInterrupts:
	move.w	#INTF_SETCLR|INTF_INTEN|INTF_PORTS|INTF_VERTB,INTENA(a6)

; Get the VB Base
	; lea	getvbr(pc),a6 
	; move.l	$4.w,a6
	; jsr	_LVOSupervisor(a6)		; returns vbr in d0 
	; lea	vbroffset(pc),a0 
	; move.l	d0,(a0)			
	; move.l	d0,a0			; VB Base in a0
	move.l	BaseVBR(a5),a0			; VB Base in a0
	move.l	intVectorLevel2(a0),_OLDLEVEL2INTERRUPT(a5)	; Save old interrupt
	move.l	intVectorLevel3(a0),_OLDLEVEL3INTERRUPT(a5)	; Save old interrupt

; Level 2 - keyboard
	lea		Level2IntHandler(pc),a1 
	move.l	a1,intVectorLevel2(a0)
	
	lea		CIAA,a1	
	move.b	#CIAICRF_SETCLR!CIAICRF_SP,ciaicr(a1); Interrupt control register 
;clear all ciaa-interrupts
	tst.b	ciaicr(a1)
;set input mode
	and.b	#~(CIACRAF_SPMODE),ciacra(a1)		
	

; Level 3 - VBL
	move.l	#VerticalBlankInterruptHandler,intVectorLevel3(a0)

	IFD		ENABLE_DEBUG_ADDRERR
	; Exception handler for address error
    	move.l  #ExeptionAddressError,$c(a0)
	ENDIF
.exit
	rts


	IFD		ENABLE_DEBUG_ADDRERR
ExeptionAddressError:
.crash:	bra.s	.crash
	ENDIF


;	Consider using AddIntServer + RemIntServer instead?
;	ori	#4,ccr			; Set Z flag

; CREDITS
; Author:	???
;		Posted by Daniel Allsop
;		https://eab.abime.net/showpost.php?p=1538796&postcount=8
; History: 
;		Nov 2023 FmJ
;		Removed usage of a0.
VerticalBlankInterruptHandler:
	btst	#5,$dff01f				; INTREQR +1
	beq.s	.notvb
	*--- do stuff here ---*

	movem.l	d0-a6,-(sp)

	; We don't know what was interrupted - load a5 and a6
	lea		Variables,a5
	lea		CUSTOM,a6

	tst.b	GameState(a5)			; Running state?
	bmi		.menu
	beq		.game
	bgt		.done

.menu
	cmp.l	#ShowTitlescreen,CurrentVisibleScreenPtr(a5)	; Titlescreen?
	bne		.done
	jsr		UpdateTitleFrame

	bra		.done
.game
	jsr		UpdateFrame

.done
	movem.l	(sp)+,d0-a6

	*--- do stuff here ---*
	; moveq #$20,d0		;poll irq bit
	move.w	#INTF_VERTB,$dff09c		; Clear VBL
	move.w	#INTF_VERTB,$dff09c		; Clear VBL for fast machine + quick interrupt
.notvb:

	; ori	#4,ccr			; Set Z flag
	rte


RestoreInterrupts:
	tst.l	_OLDLEVEL2INTERRUPT(a5)
	beq.s	.level3

	move.l	BaseVBR(a5),a0
	move.l	_OLDLEVEL2INTERRUPT(a5),intVectorLevel2(a0)
.level3
	tst.l	_OLDLEVEL3INTERRUPT(a5)
	beq.s	.exit

	move.l	BaseVBR(a5),a0
	move.l	_OLDLEVEL3INTERRUPT(a5),intVectorLevel3(a0)
.exit
	rts