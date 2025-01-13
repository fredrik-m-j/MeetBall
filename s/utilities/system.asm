; CREDITS
; This code is mostly from Amiga Game Dev series, but also RamJam course.

; Author:	Graeme Cowie (Mcgeezer)
;	https://mcgeezer.itch.io
;	https://www.amigagamedev.com

; RamJam assembly course by Prince of Phaze101
;	https://princephaze101.wordpress.com
; 	https://www.youtube.com/playlist?list=PL-i3KPjyWoghwa9ZNAfiKQ-1HGToHn9EJ
; Author:	Fabio Ciucci
;	http://corsodiassembler.ramjam.it/index_en.htm
; History:
;	Feb 2022, cleaned up. Now using macros for most lib calls.


; Store base address of the VBR, based on code from Fabio Ciucci
StoreVectorBaseRegister:
	movem.l	d0-d7/a0-a6,-(SP)

	move.l	_EXECBASE,a6			; ExecBase in a6
	btst.b	#0,$129(a6)				; Testa se siamo su un 68010 o superiore
	beq.s	.done					; E' un 68000! Allora la base e' sempre zero.
	lea		.superCode(PC),a5		; Routine da eseguire in supervisor
	jsr		-$1e(a6)				; LvoSupervisor - esegui la routine
	bra.s	.done					; Abbiamo il valore del VBR, continuiamo...

;**********************CODICE IN SUPERVISORE per 68010+ **********************
.superCode:
	dc.l	$4e7a9801				; Movec Vbr,A1 (istruzione 68010+).
			; E' in esadecimale perche' non tutti gli
			; assemblatori assemblano il movec.
	move.l	a1,BaseVBR				; Label dove salvare il valore del VBR
	RTE								; Ritorna dalla eccezione
;*****************************************************************************
.done:
	movem.l	(SP)+,d0-d7/a0-a6
	rts


StopDrives:
	move.l	a5,-(sp)
	lea		$bfd100,a5
	or.b	#$f8,(a5)
	nop
	and.b	#$87,(a5)
	nop
	or.b	#$78,(a5)
	nop
	move.l	(sp)+,a5
	rts

; TODO: Check that library pointer is returned
OpenLibraries:
	lea		_DOSNAME,a1
	moveq	#0,d0
	CALLEXEC	OpenLibrary
	move.l	d0,_DOSBase				; Save DosBase address

	lea		_GFXNAME,a1
	moveq	#0,d0
	CALLEXEC	OpenLibrary
	move.l	d0,_GfxBase				; Save GfxBase address

	rts


; Store DMA current settings
SaveDMA:
	lea		CUSTOM,a0
	move.w	DMACONR(a0),d0	
	or.w	#$8000,d0
	move.w	d0,_DMACON
	move.w	INTENAR(a0),d0
	or.w	#$8000,d0
	move.w	d0,_INTENA
	move.w	INTREQR(a0),d0
	or.w	#$8000,d0
	move.w	d0,_INTREQ
	move.w	ADKCONR(a0),d0
	or.w	#$8000,d0
	move.w	d0,_ADKCON
	rts

; Store current Copper pointers	
SaveCopper:
	movem.l	d0/a1/a6,-(sp)

	; Grab copperdetails from GfxBase "struct View"
	; http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node05ED.html
	move.l	_GfxBase,a6
	move.l	34(a6),_OLDVIEW
	move.l	$26(a6),_OLDCOPPER1
	move.l	$32(a6),_OLDCOPPER2

	move.l	#0,a1
	CALLGRAF	LoadView
	CALLGRAF	WaitTOF
	CALLGRAF	WaitTOF

	CALLGRAF	OwnBlitter

	movem.l	(sp)+,d0/a1/a6
	rts

; Load copper given a pointer to a location where it was set up.
; In:	a1 = address to start of copperlist in chipmem
LoadCopper:
	movem.l	d1/a6,-(sp)

.vBlank
	move.l	$dff004,d1				; Wait for vertical blank to avoid garbage on screen
	and.l	#$1ff00,d1
	cmp.l	#303<<8,d1
	bne.b	.vBlank

	lea		CUSTOM,a6
	move.l	hAddress(a1),d1			; Get address of copper list.
	move.l	d1,COP1LCH(a6)			; Load copper 1
	move.l	d1,COP2LCH(a6)			; Load copper 2
	; move.w	d1,COPJMP1(a0)	; Not good for this application ; ; Start copper 1
	; move.w	#0,COPJMP2(a0)	; Start copper 2

	movem.l	(sp)+,d1/a6
	rts

; Disable OS	
DisableOS:
	CALLEXEC	Disable

	bsr		SaveDMA					; DMA
	bsr		SaveCopper				; Copper pointers
	bsr		ShutDownOS				; OS
	bsr		ClearDMA

	rts

ShutDownOS:
	; CALLEXEC	Forbid  Avoiding Forbid/Permit by seting hi prio
	sub.l	a1,a1					; Null - Find current task
	CALLEXEC	FindTask
        
	tst.l	d0
	beq		.exit

	move.l	d0,a1
	moveq	#127,d0					; Very high priority...
	CALLEXEC	SetTaskPri

.exit
	rts

; Disable Interupts
ClearDMA:
	move.l	a5,-(sp)

	lea		CUSTOM,a5
	move.w	#$7fff,DMACON(a5)		;Clear all DMA
	move.w	#$7fff,INTENA(a5)		;Clear all interrupts
	move.w	#$7fff,INTREQ(a5)		;Clear pending requests
	move.w	#$7fff,INTREQ(a5)		;Twice for compatibility with A4000.
	
	movem.l	(sp)+,a5
	rts
	
EnableOS:
	bsr		RestoreInterrupts
	bsr		EnableInterrupts
	bsr		RestoreCopper
	bsr		WakeUpOS

	CALLEXEC	Enable
	rts


; Restore interrupts
EnableInterrupts:
	lea		CUSTOM,a0
	move.w	#$7fff,DMACON(a0)
	move.w	_DMACON(pc),DMACON(a0)
	move.w	#$7fff,INTENA(a0)
	move.w	_INTENA(pc),INTENA(a0)
	move.w	#$7fff,INTREQ(a0)
	move.w	_INTREQ(pc),INTREQ(a0)
	move.w	#$7fff,ADKCON(a0)
	move.w	_ADKCON(pc),ADKCON(a0)
	rts

; Restore copper
RestoreCopper:
	move.l	_OLDCOPPER1,COP1LCH(a0)
	move.l	_OLDCOPPER2,COP2LCH(a0)
	rts

WakeUpOS:
	move.l	_OLDVIEW(pc),a1
	CALLGRAF	LoadView
	CALLGRAF	WaitTOF
	CALLGRAF	WaitTOF

	CALLGRAF	DisownBlitter
	
	rts
	

CloseLibraries:
	move.l	_GfxBase(pc),a1
	CALLEXEC	CloseLibrary
	move.l	_DOSBase(pc),a1
	CALLEXEC	CloseLibrary

	rts


; In:	a0 = a handle to a resouce for wich memory was allocated
FreeMemoryForHandle:
	move.l	hAddress(a0),a1			; Fetch address
	move.l	hSize(a0),d0			; Fetch size
	CALLEXEC	FreeMem

	rts

***************************************************
*** MACRO DEFINITION		***
***************************************************

; In:   = \1 CUSTOM chipset address register
WAITBLIT	MACRO
	tst.b	DMACONR(\1)
.\@
	btst	#6,DMACONR(\1)
	bne.s	.\@
	ENDM


BLTPRI_ENABLE	=	$8400			; Nasty blit on
BLTPRI_DISABLE	=	$0400			; Nasty blit off

; Tanks to djh0ffman streams.
; In:   = \1 CUSTOM chipset address register
WAITBLITN	MACRO
	move.w	#BLTPRI_ENABLE,DMACON(\1)
	tst.b	DMACONR(\1)
.\@	btst	#6,DMACONR(\1)
	bne.s	.\@
	move.w	#BLTPRI_DISABLE,DMACON(\1)
	ENDM


; Thanks to Photon of Scoopex. http://coppershade.org/asmskool/
WAITFRAME	MACRO
.\@
	btst	#0,$dff005
	bne.b	.\@
	cmp.b	#$2a,$dff006
	bne.b	.\@
	ENDM


_ADKCON:	dc.w	0
_INTENA:	dc.w 	0
_DMACON:	dc.w	0
_INTREQ:	dc.w	0
_OLDVIEW:	dc.l	0

_GfxBase:	dc.l	0
_GFXNAME:	GRAFNAME
	even
_DOSBase:	dc.l	0
_DOSNAME:	DOSNAME
	even