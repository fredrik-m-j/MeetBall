; CREDITS
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com
; History:
;		June 2023, added audio filter on/off.
;		Sept 2023, store and restore filter setting.

; Initialise Music / SFX routines
; In:	a6 = address to CUSTOM $dff000
InstallMusicPlayer:
	btst.b	#1,CIAA+CIAPRA
	beq		.filterIsEnabled
	move.b	#1,MusicOldFilter(a5)
.filterIsEnabled

	IFNE	ENABLE_SOUND
	move.l	BaseVBR,a0
	moveq	#1,d0					; PAL
	bsr		_mt_install

	moveq	#1,d0
	bsr		mt_filter
	ENDIF
	rts

; In:	a6 = address to CUSTOM $dff000
RemoveMusicPlayer:
	IFNE	ENABLE_SOUND
	move.b	MusicOldFilter(a5),d0
	bsr		mt_filter

	bsr		_mt_remove_cia
	ENDIF
	rts

	
; LoadModule:
; 	IFNE	ENABLE_MUSIC
; 	lea	MODULE_TAB(a6),a0
; 	add.w	d0,d0
; 	add.w	d0,d0
; 	move.l	(a0,d0),a0
; ;	lea	CHIP_MOD_INGAME,a1
; 	move.l	MEMCHK4_CHIP_MODULE,a1
; 	bsr	Unpack
; 	ENDIF
; 	rts

; In:	d0 = volume 0-64
; In:	a6 = address to CUSTOM $dff000
SetMasterVolume:
	IFNE	ENABLE_MUSIC
	bsr		_mt_mastervol
	ENDIF
	rts

; In:	a0 = Pointer to MOD
; In:	a6 = address to CUSTOM $dff000
PlayTune:
	IFNE	ENABLE_MUSIC
	tst.w	MusicOn(a5)
	beq.s	.unmask					; Music is off.

	move.l	hAddress(a0),a0			; Fetch address

	move.l	#0,a1
	moveq	#0,d0
	jsr		_mt_init

	move.b	#-1,_mt_Enable			; Play music

	moveq	#64,d0
	jsr		SetMasterVolume

	bra.s	.exit

.unmask:
	moveq	#%00000111,d0			; reserve chans 1,2 & 3 for ziks
	jsr		_mt_musicmask
	clr.b	_mt_Enable

.exit:
	ENDIF
	rts

; In:	a6 = address to CUSTOM $dff000
StopAudio:
	IFNE	ENABLE_MUSIC
	clr.b	_mt_Enable
	jsr		_mt_end
	ENDIF
	rts

; In:	a0 = pointer to sample struct.
; In:	a6 = address to CUSTOM $dff000
PlaySample:
	IFNE	ENABLE_SFX
	tst.b	EnableSfx(a5)
	bmi		.fastExit
	jsr		_mt_playfx
.fastExit
	ENDIF
	
	rts