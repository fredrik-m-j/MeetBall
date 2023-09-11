; CREDITS
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com
; History:
;		June 2023, added audio filter on/off.
;		Sept 2023, store and restore filter setting.

; Initialise Music / SFX routines
InstallMusicPlayer:
	btst.b	#1,CIAA+CIAPRA
	beq	.filterIsEnabled
	move.b	#1,_OLDFILTER
.filterIsEnabled

	IFNE	ENABLE_SOUND
	move.l	a6,-(sp)
	lea	CUSTOM,a6		
	move.l	BaseVBR,a0
	moveq	#1,d0
	bsr	_mt_install_cia

	moveq	#1,d0
	bsr	mt_filter
	move.l	(sp)+,a6
	ENDC
	rts

RemoveMusicPlayer:
	IFNE	ENABLE_SOUND
	move.l	a6,-(sp)

	move.b	_OLDFILTER,d0
	bsr	mt_filter

	lea	CUSTOM,a6
	bsr	_mt_remove_cia
	move.l	(sp)+,a6
	ENDC
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
; 	ENDC
; 	rts

; In:	d0 = volume 0-64
SetMasterVolume:
	IFNE	ENABLE_MUSIC
	movem.l	d0-d7/a0-a6,-(SP)	; Don't know what ptplayer uses so save everything
	lea	CUSTOM,a6
	bsr	_mt_mastervol
	movem.l	(SP)+,d0-d7/a0-a6
	ENDC
	rts

; In:	a0 = Pointer to MOD
PlayTune:
	IFNE	ENABLE_MUSIC
	move.l	a6,-(sp)

	tst.w	MUSIC_ON
	beq.s	.unmask			; Music is off.

	lea	CUSTOM,a6

	move.l	hAddress(a0),a0		; Fetch address

	move.l	#0,a1
	moveq	#0,d0
	jsr	_mt_init

	move.b	#-1,_mt_Enable		; Play music

	moveq	#64,d0
	jsr	SetMasterVolume

	bra.s	.exit

.unmask:
	move.l	d0,-(sp)
	lea	CUSTOM,a6
	moveq	#%00000111,d0		; reserve chans 1,2 & 3 for ziks
	jsr	_mt_musicmask
	move.l	(sp)+,d0
	clr.b	_mt_Enable

.exit:	move.l	(sp)+,a6

	ENDC
	rts
	
StopAudio:
	IFNE	ENABLE_MUSIC
	move.l	a6,-(sp)
	clr.b	_mt_Enable
	lea	CUSTOM,a6
	jsr	_mt_end
	move.l	(sp)+,a6
	ENDC
	rts

; In:	a0 = pointer to sample struct.
PlaySample:
	IFNE	ENABLE_SFX
	move.l	a6,-(sp)

	lea	CUSTOM,a6
	jsr	_mt_playfx
.exit:	
	move.l	(sp)+,a6
	ENDC
	
	rts