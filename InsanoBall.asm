; Thanks to McGeezer for putting together Amiga Game Dev series!
; Thanks to Prince of Phaze101 for streaming RamJam assembly course based on the book by Fabio Ciucci!
; Thanks to Photon of Scoopex for the AsmSkool and YouTube series!
; Thanks to everyone else that is spreading the knowledge on assembler for 68k processors!

; CREDITS
; Source structure and asset system is based on Amiga Game Dev series.
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com

	section	GameCode, code_p

VERSION_STR:		dc.b    "V0.73",0
	even

INIT_BALLCOUNT		equ	3		; Number of balls at game start

ENABLE_SOUND		equ	1
ENABLE_MUSIC		equ	1
ENABLE_SFX		equ	1
ENABLE_MENU		equ	1

ENABLE_RASTERMONITOR	equ	0
ENABLE_BRICKRASTERMON	equ	0
ENABLE_DEBUG_BRICKS	equ	0
ENABLE_DEBUG_BRICKDROP	equ	0
ENABLE_DEBUG_BALL	equ	0
ENABLE_DEBUG_GAMECOPPER	equ	0
ENABLE_DEBUG_INSANO	equ	0
ENABLE_DEBUG_PLAYERS	equ	0

ENABLE_DEBUG_ADDRERR	equ	0

; INCLUDES
	incdir	'Include/'

; OS Libraries and Constants
	include 'exec/types.i'			; Include these because we use the exec lib
	include 'exec/exec.i'			
	include 'exec/exec_lib.i'
	include 'libraries/dos.i'		; Include these because we use the dos lib
	include 'libraries/dos_lib.i'
	include 'graphics/gfxbase.i'		; Include these because we use the gfx lib
	include	'graphics/graphics_lib.i'
	include 'hardware/cia.i'		; Include these because we use interrupts
	include 'hardware/intbits.i'

; Our additional includes
	include 'custom.i'
	include 'hardware.i'
	include 'keycodes.i'


;	include 'easystart.i'			; Doesn't work properly on my A1200 OS3.2.1
_main:
	jmp	START
	
	incdir	''
; Our Functions and Constants
	include 's/handles.i'			; Handle constants
	include 's/utilities/loader.i'		; Loader constants
	include 's/utilities/loader.asm'	; Add in loader functions
	include 's/utilities/unpack.asm'	; RNC Unpacker code
	include 's/utilities/handle.asm'		
	include 's/utilities/bitmap.asm'	; Bitmap helpers
	include 's/utilities/palette.asm'	; Palette helpers
	include 's/utilities/copper.asm'	; Copper Builder
	include 's/utilities/system.asm'
	include 's/utilities/Binary2Decimal-v2.s'
	include	's/utilities/random.asm'
	include	's/utilities/macros.asm'
	include 's/utilities/fades.asm'

	include 's/io/joystick.asm'
	include 's/io/joystick.i'		; Joystick constants
	include 's/io/interrupts.asm'
	include 's/io/keyboard.asm'
	include 's/io/parallellport.asm'
	include 's/audio/music.asm'
	include 's/audio/ptplayer.asm'
	include 's/hwsprites.asm'
	include 's/bobs.asm'
	include 's/menu.asm'
	include 's/player.asm'
	include 's/balls.asm'

	include	's/score.asm'
	include 's/gamearea.asm'
	include 's/gameloop.asm'

	include	's/text.asm'


	IFGT ENABLE_DEBUG_BRICKS
	include 's/debugging/brickdebug.asm'
	ENDC
	IFGT ENABLE_DEBUG_BALL
	include 's/debugging/balldebug.asm'
	ENDC

START:
	movem.l	d0-d7/a0-a6,-(sp)

	jsr 	OpenLibraries

; Read and unpack files into ram.
	lea	MENU_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_BITMAP1_IFF		; Save pointer to asset!
	nop

	lea	GAME_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_BITMAP2_IFF		; Save pointer to asset!
	nop
	lea	GAME_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_BITMAP3_IFF		; Save pointer to asset!
	nop
	lea	GAME_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_BITMAP4_IFF		; Save pointer to asset!
	nop

	lea	BOBS_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_BOBS_IFF			; Save pointer to asset!
	nop

; Create a Bitmap Handle and work out dimensions
	move.l	HDL_BITMAP1_IFF,a1		; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapDimensions
	move.l	d0,HDL_BITMAP1_DAT
	nop

	move.l	HDL_BITMAP2_IFF,a1		; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapDimensions
	move.l	d0,HDL_BITMAP2_DAT

	move.l	HDL_BITMAP3_IFF,a1		; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapDimensions
	move.l	d0,HDL_BITMAP3_DAT

	move.l	HDL_BITMAP4_IFF,a1		; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapDimensions
	move.l	d0,HDL_BITMAP4_DAT

        lea 	HDL_BITMAP1_DAT,a1
        move.l 	hAddress(a1),a1
	move.l 	hBitmapBody(a1),d0
	addq.l 	#8,d0				; +8 to get past BODY tag
	move.l	d0,MENUSCREEN_BITMAPBASE

        lea 	HDL_BITMAP2_DAT,a1
        move.l 	hAddress(a1),a1
	move.l 	hBitmapBody(a1),d0
	addq.l 	#8,d0				; +8 to get past BODY tag
	move.l	d0,GAMESCREEN_BITMAPBASE
	nop
        lea 	HDL_BITMAP3_DAT,a1
        move.l 	hAddress(a1),a1
	move.l 	hBitmapBody(a1),d0
	addq.l 	#8,d0				; +8 to get past BODY tag
	move.l	d0,GAMESCREEN_BITMAPBASE_BACK
	nop
        lea 	HDL_BITMAP4_DAT,a1
        move.l 	hAddress(a1),a1
	move.l 	hBitmapBody(a1),d0
	addq.l 	#8,d0				; +8 to get past BODY tag
	move.l	d0,GAMESCREEN_BITMAPBASE_ORIGINAL
	nop

	move.l	HDL_BOBS_IFF,a1			; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapDimensions
	move.l	d0,HDL_BOBS_DAT

        lea 	HDL_BOBS_DAT,a1
        move.l 	hAddress(a1),a1
	move.l 	hBitmapBody(a1),d0
	addq.l 	#8,d0				; +8 to get past BODY tag
	move.l	d0,BOBS_BITMAPBASE
	nop

; Get the palette of the Bitmap
	move.l	HDL_BITMAP1_IFF,a1		; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapPalette
	move.l	d0,HDL_BITMAP1_PAL
	nop

	move.l	HDL_BITMAP2_IFF,a1		; Pointer to IFF in a1
	move.l	hAddress(a1),a1
	jsr	agdGetBitmapPalette
	move.l	d0,HDL_BITMAP2_PAL
	nop

; Read and unpack music files
	IFNE	ENABLE_MUSIC
	lea	MUSIC_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_MUSICMOD_1		; Save pointer to asset!
	nop

	lea	END_MUSIC_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi	.error
	move.l	d0,HDL_MUSICMOD_2		; Save pointer to asset!
	nop
	ENDC
	
; Create copper resources
	move.l	#1024,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdAllocateResource
	tst.l	d0
	bmi	.error
	move.l	d0,COPPTR_MENU
	nop

	move.l	#1024,d0
	moveq	#MEMF_CHIP,d1
	jsr	agdAllocateResource
	tst.l	d0
	bmi	.error
	move.l	d0,COPPTR_CREDITS
	nop

	move.l	#$A590+4,d0			; Need HUGE game copperlist to do all the tricks
	moveq	#MEMF_CHIP,d1			; This is the fully maxed out size + small margin
	jsr	agdAllocateResource
	tst.l	d0
	bmi	.error
	move.l	d0,COPPTR_GAME
	nop

	
; Create base copperlists. NOTE: Order is imporant game-copper need to be last
	move.l	COPPTR_MENU,a1
	move.l	HDL_BITMAP1_DAT,a3
	move.l	HDL_BITMAP1_PAL,a4
	jsr	agdBuildCopper
	bsr	AppendMenuSprites
	move.l	a1,END_COPPTR_MENU
	nop

	move.l	COPPTR_CREDITS,a1
	move.l	HDL_BITMAP3_DAT,a3
	move.l	HDL_BITMAP2_PAL,a4
	jsr	agdBuildCopper
	bsr	AppendCreditsSprites
	move.l	a1,END_COPPTR_CREDITS
	nop

	move.l	COPPTR_GAME,a1
	move.l	HDL_BITMAP2_DAT,a3
	move.l	HDL_BITMAP2_PAL,a4
	jsr	agdBuildCopper
	bsr	AppendGameSprites
	move.l	a1,END_COPPTR_GAME
	nop

	jsr	StopDrives

	jsr	StoreVectorBaseRegister

; Setup Parallel port
	jsr	GetParallelPort
	tst.l	d0
; TODO: Perhaps disable 3 and 4 player game instead and not do freeport?
	bne	.error

	jsr	DisableOS
	jsr	InstallInterrupts

	WAITLASTLINE d0

	lea	CUSTOM,a5
	move.w	#%1000001111111111,DMACON(a5) 	; Setup DMA for BPL,COP,SPR,BLT,AUD0-3

	jsr 	InstallMusicPlayer
	bsr	InitBobs
	bsr	InitPowerupPalette
	bsr	InitMainMenu

.mainMenu
	IFNE	ENABLE_MENU
	bsr	MainMenu
	tst.l	d0
	bmi.s	.exit
	ENDC

	bsr	StartNewGame
	bra.s	.mainMenu

.error	moveq	#-1,d0
	bra	.rts
	
.exit
	jsr	StopAudio
	jsr	RemoveMusicPlayer

; Deallocate memory
	move.l	HDL_BITMAP1_IFF,a0
	jsr	FreeMemoryForHandle
	move.l	HDL_BITMAP2_IFF,a0
	jsr	FreeMemoryForHandle
	move.l	HDL_BITMAP3_IFF,a0
	jsr	FreeMemoryForHandle
	move.l	HDL_BITMAP4_IFF,a0
	jsr	FreeMemoryForHandle
	move.l	HDL_BOBS_IFF,a0
	jsr	FreeMemoryForHandle
	
	IFNE	ENABLE_MUSIC
	move.l	HDL_MUSICMOD_1,a0
	jsr	FreeMemoryForHandle
	move.l	HDL_MUSICMOD_2,a0
	jsr	FreeMemoryForHandle
	ENDC

	move.l	COPPTR_MENU,a0
	jsr	FreeMemoryForHandle
	move.l	COPPTR_CREDITS,a0
	jsr	FreeMemoryForHandle
	move.l	COPPTR_GAME,a0
	jsr	FreeMemoryForHandle

	jsr	EnableOS
	jsr	CloseLibraries
	jsr	FreeParallelPort

	WAITLASTLINE d0

	movem.l	(sp)+,d0-d7/a0-a6
	moveq	#0,d0			; Exit with 0
.rts:	rts


HDL_BITMAP1_IFF:		dc.l	0
HDL_BITMAP1_PAL:		dc.l	0
HDL_BITMAP1_DAT:		dc.l	0
HDL_BITMAP2_IFF:		dc.l	0
HDL_BITMAP2_PAL:		dc.l	0
HDL_BITMAP2_DAT:		dc.l	0
; Shared palette with BITMAP2
HDL_BITMAP3_IFF:		dc.l	0
HDL_BITMAP3_DAT:		dc.l	0
HDL_BITMAP4_IFF:		dc.l	0
HDL_BITMAP4_DAT:		dc.l	0

HDL_BOBS_DAT:			dc.l	0
HDL_BOBS_IFF:			dc.l	0
MENUSCREEN_BITMAPBASE:		dc.l	0
GAMESCREEN_BITMAPBASE:		dc.l	0
GAMESCREEN_BITMAPBASE_BACK:	dc.l	0
GAMESCREEN_BITMAPBASE_ORIGINAL:	dc.l	0
BOBS_BITMAPBASE:		dc.l	0

HDL_MUSICMOD_1:		dc.l	0
HDL_MUSICMOD_2:		dc.l	0

SFX_BOUNCE_STRUCT:		
			dc.l	SFX_BOUNCE	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	222	; WORD sfx_len (sample length in words)				; 444
			dc.w	178	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	64	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_BOUNCEMETAL_STRUCT:
			dc.l	SFX_BOUNCEMETAL	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	1397	; WORD sfx_len (sample length in words)				; 444
			dc.w	178	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	45	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_BRICKDROP_STRUCT:
			dc.l	SFX_BRICKDROP	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	1335	; WORD sfx_len (sample length in words)				; 2394
			dc.w	470	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	40	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_BRICKSMASH_STRUCT:		
			dc.l	SFX_BRICKSMASH	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	1197	; WORD sfx_len (sample length in words)				; 2394
			dc.w	178	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	35	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_POWERUP_STRUCT:
			dc.l	SFX_POWERUP	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	1708	; WORD sfx_len (sample length in words)				; 2394
			dc.w	400	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	30	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_EXPLODE_STRUCT:
			dc.l	SFX_EXPLODE	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	2309	; WORD sfx_len (sample length in words)				; 2394
			dc.w	300	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	64	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_SHOT_STRUCT:
			dc.l	SFX_SHOT; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	997	; WORD sfx_len (sample length in words)				; 2394
			dc.w	200	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	64	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even
SFX_SELECT_STRUCT:
			dc.l	SFX_SELECT	; sfx_ptr (pointer to sample start in Chip RAM, even address)
			dc.w	338	; WORD sfx_len (sample length in words)				; 2394
			dc.w	200	; WORD sfx_per (hardware replay period for sample)		; 300
			dc.w	54	; WORD sfx_vol (volume 0..64, is unaffected by the song's master volume)
			dc.b	-1	; BYTE sfx_cha (0..3 selected replay channel, -1 selects best channel)
			dc.b	50	; BYTE sfx_pri (unsigned priority, must be non-zero)
			even

COPPTR_TOP:		dc.l	0
COPPTR_MENU:		dc.l	0
COPPTR_CREDITS:		dc.l	0
COPPTR_GAME:		dc.l	0
END_COPPTR_GAME:	dc.l	0	; Points to AFTER initial boilerplate copper setup
END_COPPTR_MENU:	dc.l	0	; -"-
END_COPPTR_CREDITS:	dc.l	0	; -"-
END_COPPTR_GAME_TILES:	dc.l	0
	
MENU_BKG_FILENAME:	dc.b	"MeetBall:Resource/Title.rnc",0
			even
GAME_BKG_FILENAME:	dc.b	"MeetBall:Resource/eclipse.rnc",0
			even
MUSIC_FILENAME:		dc.b	"MeetBall:Resource/mod.main.RNC",0
			even
END_MUSIC_FILENAME:	dc.b	"MeetBall:Resource/mod.over.RNC",0
			even
BOBS_FILENAME:		dc.b	"MeetBall:Resource/Bobs.RNC",0
 			even

amgRncHeaderBuffer:	
			ds.w	20
	

	section	GameData, data_p

	include 's/utilities/system.dat'
	include 's/utilities/handle.dat'
	include	's/utilities/copper.dat'
	include 's/audio/music.dat'
	include 's/gamearea.dat'
	include	's/player.dat'
	include	's/balls.dat'
	include	's/text.dat'
	include 's/menu.dat'

	even

	section	Sfx, data_c
	even
SFX_BOUNCE:
	incbin	"Resource/knap.raw"
SFX_BOUNCEMETAL:
	incbin	"Resource/newtonhit.raw"
SFX_BRICKDROP:
	incbin	"Resource/stonedrop.raw"
SFX_BRICKSMASH:
	incbin	"Resource/tsip.raw"
SFX_SHOT:
	incbin	"Resource/shot1.raw"
SFX_POWERUP:
	incbin	"Resource/powerup3.raw"
SFX_EXPLODE:
	incbin	"Resource/Exp55.raw"
SFX_SELECT:
	incbin	"Resource/Select4.raw"
FONT:
	incbin	"Resource/Font/Pyrotechnics8.raw"
	even

	section	Sprites, data_c
	include 's/hwsprites.dat'
	include 's/bobs.dat'

	IFNE ENABLE_DEBUG_GAMECOPPER
	section	DebugCopper, data_p
	include 's/debugging/copperdebug.asm'
	ENDC