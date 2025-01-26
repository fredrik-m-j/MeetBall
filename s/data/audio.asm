SFX_BOUNCE_STRUCT:		
	dc.l	SFX_BOUNCE					; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	222							; WORD sfx_len (sample length in words)				; 444
	dc.w	178							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	64							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_BOUNCEMETAL_STRUCT:
	dc.l	SFX_BOUNCEMETAL				; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	1397						; WORD sfx_len (sample length in words)				; 444
	dc.w	178							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	45							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_BRICKDROP_STRUCT:
	dc.l	SFX_BRICKDROP				; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	1335						; WORD sfx_len (sample length in words)				; 2394
	dc.w	470							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	40							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_BRICKSMASH_STRUCT:		
	dc.l	SFX_BRICKSMASH				; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	1197						; WORD sfx_len (sample length in words)				; 2394
	dc.w	178							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	35							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_POWERUP_STRUCT:
	dc.l	SFX_POWERUP					; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	1708						; WORD sfx_len (sample length in words)				; 2394
	dc.w	400							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	30							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_EXPLODE_STRUCT:
	dc.l	SFX_EXPLODE					; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	2309						; WORD sfx_len (sample length in words)				; 2394
	dc.w	300							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	64							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_SHOT_STRUCT:
	dc.l	SFX_SHOT					; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	997							; WORD sfx_len (sample length in words)				; 2394
	dc.w	200							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	64							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even
SFX_SELECT_STRUCT:
	dc.l	SFX_SELECT					; sfx_ptr (pointer to sample start in Chip RAM, even address)
	dc.w	338							; WORD sfx_len (sample length in words)				; 2394
	dc.w	200							; WORD sfx_per (hardware replay period for sample)		; 300
	dc.w	54							; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
	dc.b	-1							; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
	dc.b	50							; BYTE sfx_pri (unsigned priority, must be non-zero)
	even