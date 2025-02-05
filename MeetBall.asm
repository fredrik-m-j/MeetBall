; Conventions used (for the most part):
; * M68k ABI calling convention
; * a6 = $dff000
; * a5 = Variables defined in bss

; Thanks to McGeezer for putting together Amiga Game Dev series!
; Thanks to Prince of Phaze101 for streaming RamJam assembly course based on the book by Fabio Ciucci!
; Thanks to Photon of Scoopex for the AsmSkool and YouTube series!
; Thanks to everyone else that is spreading the knowledge on assembler for 68k processors!

; CREDITS
; Source structure and asset system is based on Amiga Game Dev series...
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com
;
; ... but also influenced by H0ffman's Knightmare port
; 		https://github.com/djh0ffman/KnightmareAmiga

	section	GameCode, code_p

VERSION_STR:	dc.b    "V0.87",0
	even

; INCLUDES
	incdir	'Include/'
	include	'exec/exec_lib.i'
	; include 'easystart.i'			; Doesn't work properly on my A1200 OS3.2.1
_main:
	jmp		START


; OS Libraries and Constants
	include	'exec/types.i'			; Include these because we use the exec lib
	include	'exec/exec.i'			
	; include 'exec/exec_lib.i'
	include	'libraries/dos.i'		; Include these because we use the dos lib
	include	'libraries/dos_lib.i'
	include	'graphics/gfxbase.i'	; Include these because we use the gfx lib
	include	'graphics_lib.i'
	include	'hardware/cia.i'		; Include these because we use interrupts
	include	'hardware/intbits.i'
	include	'hardware/blit.i'

; Our additional includes
	include	'custom.i'
	include	'hardware.i'
	include	'keycodes.i'


	incdir	''
; Our Functions and Constants
	include	'common.asm'

	include	's/handles.i'			; Handle constants
	include	's/utilities/loader.asm'	; Add in loader functions
	include 's/utilities/unpack.asm'	; RNC Unpacker code
	include 's/utilities/handle.asm'		
	include 's/utilities/bitmap.asm'	; Bitmap helpers
	include 's/utilities/palette.asm'	; Palette helpers
	include 's/utilities/copper.asm'	; Copper Builder
	include 's/utilities/system.asm'
	include 's/utilities/Binary2Decimal-v2.s'
	include	's/utilities/random.asm'
	include	's/utilities/macros.asm'
	include	's/utilities/simplelineXor.asm'

	include	's/io/joystick.asm'
	include	's/io/interrupts.asm'
	include	's/io/keyboard.asm'
	include 's/io/parallellport.asm'
	include	's/audio/music.asm'
	include	's/audio/ptplayer.asm'
	include	's/hwsprites.asm'
	include	's/bobs.asm'
	include	's/player.asm'
	include	's/balls.asm'
	include	's/score.asm'
	include	's/gamearea.asm'
	include	's/gameloop.asm'

	include	's/text.asm'
	include	's/screen/title.asm'
	include	's/screen/backing.asm'
	include	's/screen/hiscore.asm'
	include	's/screen/collectibles.asm'
	include	's/screen/controls.asm'
	include	's/screen/fades.asm'
	include	's/screen/credits.asm'


	IFD		ENABLE_DEBUG_BRICKS
		include 's/debugging/brickdebug.asm'
	ENDIF
	IFD		ENABLE_BALLDEBUG
		include 's/debugging/balldebug.asm'
	ENDIF
	IFD		ENABLE_DEBUG_PWR
		include 's/debugging/powerupdebug.asm'
	ENDIF

START:
	movem.l	d0-a6,-(sp)

	lea		Variables,a5			; Variables in a5
	bsr		InitVariables
	lea		CUSTOM,a6				; $dff000 in a6

	jsr		OpenLibraries

; Read and unpack files into ram.
	lea		LOGO_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,LogoPtr(a5)			; Save pointer to asset!
	
	move.l	d0,a0
	move.l	hAddress(a0),a0
	move.l	a0,LogoBitmapbasePtr(a5)	; Save pointer to asset!
	nop

	lea		MENU_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,Bitmap1IffPtr(a5)	; Save pointer to asset!
	nop

	lea		GAME_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,Bitmap2IffPtr(a5)	; Save pointer to asset!
	nop
	lea		GAME_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,Bitmap3IffPtr(a5)	; Save pointer to asset!
	nop
	lea		GAME_BKG_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,Bitmap4IffPtr(a5)	; Save pointer to asset!
	nop

	lea		BOBS_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,BobsIffPtr(a5)		; Save pointer to asset!
	nop

; Create a Bitmap Handle and work out dimensions
	move.l	Bitmap1IffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapDimensions
	move.l	d0,Bitmap1DataPtr(a5)
	nop

	move.l	Bitmap2IffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapDimensions
	move.l	d0,Bitmap2DataPtr(a5)

	move.l	Bitmap3IffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapDimensions
	move.l	d0,Bitmap3DataPtr(a5)

	move.l	Bitmap4IffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapDimensions
	move.l	d0,Bitmap4DataPtr(a5)


	lea		Bitmap2DataPtr(a5),a1
	move.l	hAddress(a1),a1
	move.l	hBitmapBody(a1),d0
	addq.l	#8,d0					; +8 to get past BODY tag
	move.l	d0,GAMESCREEN_Ptr(a5)
	nop
	lea		Bitmap3DataPtr(a5),a1
	move.l	hAddress(a1),a1
	move.l	hBitmapBody(a1),d0
	addq.l	#8,d0					; +8 to get past BODY tag
	move.l	d0,GAMESCREEN_BackPtr(a5)
	nop
	lea		Bitmap4DataPtr(a5),a1
	move.l	hAddress(a1),a1
	move.l	hBitmapBody(a1),d0
	addq.l	#8,d0					; +8 to get past BODY tag
	move.l	d0,GAMESCREEN_PristinePtr(a5)
	nop

	move.l	BobsIffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapDimensions
	move.l	d0,BobsDataPtr(a5)

	lea		BobsDataPtr(a5),a1
	move.l	hAddress(a1),a1
	move.l	hBitmapBody(a1),d0
	addq.l	#8,d0					; +8 to get past BODY tag
	move.l	d0,BobsBitmapbasePtr(a5)
	nop

; Get the palette of the Bitmap
	move.l	Bitmap1IffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapPalette
	move.l	d0,Bitmap1PalettePtr(a5)
	nop

	move.l	Bitmap2IffPtr(a5),a1
	move.l	hAddress(a1),a1
	jsr		agdGetBitmapPalette
	move.l	d0,Bitmap2PalettePtr(a5)
	nop

; Read and unpack music files
	IFGT	ENABLE_MUSIC
	lea		MUSIC_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,Mod1Ptr(a5)			; Save pointer to asset!
	nop

	lea		END_MUSIC_FILENAME,a0
	moveq	#0,d0
	moveq	#MEMF_CHIP,d1
	jsr		agdLoadPackedAsset		; hAsset = amgLoadPackedAsset(*name[a0], memtype[d1])
	tst.l	d0
	bmi		.error
	move.l	d0,Mod2Ptr(a5)			; Save pointer to asset!
	nop
	ENDIF
	
	
; Create base copperlists. NOTE: Order is imporant game-copper need to be last
	lea		Copper_MISC,a1
	move.l	Bitmap3DataPtr(a5),a3
	move.l	Bitmap2PalettePtr(a5),a4
	jsr		agdBuildCopper
	move.l	a1,CopperMiscEndPtr(a5)
	nop

	lea		Copper_GAME,a1
	move.l	Bitmap2DataPtr(a5),a3
	move.l	Bitmap2PalettePtr(a5),a4
	jsr		agdBuildCopper
	jsr		AppendGameSprites
	move.l	a1,CopperGameEndPtr(a5)
	nop

	jsr		StopDrives

	jsr		StoreVectorBaseRegister

; Setup Parallel port
	jsr		GetParallelPort
	tst.l	d0
; TODO: Perhaps disable 3 and 4 player game instead and not do freeport?
	bne		.error

	jsr		DisableOS
	jsr		InstallInterrupts

	WAITBOVP	d0

	move.w	#%1000001111111111,DMACON(a6) 	; Setup DMA for BPL,COP,SPR,BLT,AUD0-3

	jsr		InstallMusicPlayer
	jsr		InitPlayers
	jsr		InitScores
	bsr		InitHiscore
	jsr		InitBalls
	jsr		InitBobs
	bsr		InitTitlescreen
	bsr		InitPowerup
	bsr		InitControlscreen
	bsr		InitEnemies
	bsr		InitBricks


	move.b	#USERINTENT_CHILL,UserIntentState(a5)
	move.l	#ChillSequence,ChillSequencePtr(a5)	; Start with 1st screen

	move.l	Mod1Ptr(a5),a0
	jsr		PlayTune

.title
	tst.b	UserIntentState(a5)
	bgt		.chillin

	move.b	#USERINTENT_CHILL,UserIntentState(a5)
	move.l	#ChillSequence,ChillSequencePtr(a5)	; Start with 1st screen


.chillin

	IFGT	ENABLE_USERINTENT
	move.b	#USERINTENT_CHILL,UserIntentState(a5)
	move.b	#CHILLMODE_SEC,ChillCount(a5)
.chillOrNewGame
	cmp.b	#USERINTENT_NEW_GAME,UserIntentState(a5)
	beq		.controls

	bsr		NextChillscreen
	tst.b	UserIntentState(a5)
	bmi		.quitIntent
	beq		.controls
	bgt		.chillOrNewGame
	ELSE
	move.b	#USERINTENT_PLAY,UserIntentState(a5)
	ENDIF

.controls
	bsr		ShowControlscreen

	tst.b	UserIntentState(a5)
	beq		.afterGameover
	bmi		.quitIntent

	move.b	#USERINTENT_CHILL,UserIntentState(a5)	; Go chill after gaming or quit controls

	bra		.title

.quitIntent
	cmp.b	#USERINTENT_QUIT_CONFIRMED,UserIntentState(a5)
	beq		.exit

	move.b	#USERINTENT_CHILL,UserIntentState(a5)	; Go chill after regretting quit
	move.l	#ChillSequence,ChillSequencePtr(a5)		; Start with 1st screen
	bra		.title

.afterGameover
	move.l	Mod1Ptr(a5),a0
	jsr		PlayTune
	bra		.title

.error
	moveq	#-1,d0
	bra		.rts
	
.exit
	jsr		StopAudio
	jsr		RemoveMusicPlayer

; Deallocate memory
	move.l	LogoPtr(a5),a0
	jsr		FreeMemoryForHandle
	move.l	Bitmap1IffPtr(a5),a0
	jsr		FreeMemoryForHandle
	move.l	Bitmap2IffPtr(a5),a0
	jsr		FreeMemoryForHandle
	move.l	Bitmap3IffPtr(a5),a0
	jsr		FreeMemoryForHandle
	move.l	Bitmap4IffPtr(a5),a0
	jsr		FreeMemoryForHandle
	move.l	BobsIffPtr(a5),a0
	jsr		FreeMemoryForHandle
	
	IFGT	ENABLE_MUSIC
	move.l	Mod1Ptr(a5),a0
	jsr		FreeMemoryForHandle
	move.l	Mod2Ptr(a5),a0
	jsr		FreeMemoryForHandle
	ENDIF

	jsr		EnableOS
	jsr		CloseLibraries
	jsr		FreeParallelPort

	movem.l	(sp)+,d0-a6
	moveq	#0,d0					; Exit with 0
.rts:
	rts


; Displays the next screen in the list.
NextChillscreen:
	move.l	ChillSequencePtr(a5),a0
	move.l	(a0)+,a1				; Fetch screen

	move.l	a0,-(sp)
	jsr		(a1)					; Show screen
	move.l	(sp)+,a0

	cmpa.l	#ChillSequenceEnd,a0
	bne		.setPtr
	move.l	#ChillSequence,a0

.setPtr
	move.l	a0,ChillSequencePtr(a5)

	move.b	#CHILLMODE_SEC,ChillCount(a5)
	rts


InitVariables:
	move.l	#LevelTable,LevelPtr(a5)
	move.l	#ChillSequence,ChillSequencePtr(a5)

	move.l	#-1,Player0Enabled(a5)
	move.b	#-1,FadePhase(a5)

	move.b	#STATE_NOT_RUNNING,GameState(a5)
	move.b	#USERINTENT_CHILL,UserIntentState(a5)
	move.b	#-1,ChillCount(a5)

	move.w	#1,MusicOn(a5)

	move.w	#ENEMIES_DEFAULTMAX,ENEMY_MaxSlots(a5)
	move.b	#15,ENEMY_SpawnCount(a5)
	move.l	#Variables+ENEMY_Stack,ENEMY_StackPtr(a5)

	move.b	#INSANOSTATE_INACTIVE,InsanoState(a5)
	move.l	#PWR_EXTRAPOINTS_BASEVALUE,PwrExtraPointsValue(a5)
	move.b	#INSANOTICKS,InsanoTick(a5)

	move.w	#DEFAULT_BALLSPEED,BallspeedBase(a5)
	move.b	#DEFAULT_RAMPUP,BallspeedFrameCount(a5)
	move.b	#DEFAULT_RAMPUP,BallspeedFrameCountCopy(a5)
	move.w	#1*DEFAULT_BALLSPEED,BallSpeedx1(a5)
	move.w	#2*DEFAULT_BALLSPEED,BallSpeedx2(a5)
	move.w	#3*DEFAULT_BALLSPEED,BallSpeedx3(a5)
	rts


	include	's/memory/chipmem.asm'
	include	's/memory/publicmem.asm'

	section	GameData, data_p

	include	's/data/utilities/handle.asm'
	include	's/data/gamearea.asm'
	include	's/data/player.asm'
	include	's/data/balls.asm'
	include	's/data/text.asm'
	include	's/data/audio.asm'
	include	's/data/files.asm'
	include	's/data/screens.asm'
	include	's/data/screen/title.asm'
	include	's/data/screen/hiscore.asm'

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
	include	's/data/hwsprites.asm'

	section	Buttons, data_c			; Buttons in raw interleaved format
BTN_ESC_SM:
	incbin	'Resource/Buttons/ESC.bsh'
BTN_F1:
	incbin	'Resource/Buttons/F1.bsh'
BTN_F2:
	incbin	'Resource/Buttons/F2.bsh'
BTN_F3:
	incbin	'Resource/Buttons/F3.bsh'
BTN_F4:
	incbin	'Resource/Buttons/F4.bsh'
BTN_F5_SM:
	incbin	'Resource/Buttons/F5.bsh'
BTN_F6_SM:
	incbin	'Resource/Buttons/F6.bsh'
BTN_F8_SM:
	incbin	'Resource/Buttons/F8.bsh'