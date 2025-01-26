; ------------------ Debug symbols ------------------
;ENABLE_RASTERMONITOR
;ENABLE_BRICKRASTERMON
;ENABLE_DEBUG_BRICKS 	        ; Maxed out number of bricks
;ENABLE_DEBUGLEVEL		        ; Load specific level
;ENABLE_DEBUG_BRICKDROP		    ; Short time between brickdrops
;ENABLE_DEBUG_BALL			    ; Repeated insanoballz - check for escaping balls
;ENABLE_DEBUG_ENEMYCOLLISION	; Repeated ballrelease against target enemy
;ENABLE_DEBUG_BOUNCE_REPT	    ; Repeated ballrelease against target area
;ENABLE_DEBUG_INSANO            ; Activate insanoballz
;ENABLE_DEBUG_PLAYERS		    ; Bat0 human. Bat1-3 CPU
;ENABLE_DEBUG_GLUE			    ; Release ball at glue bat
;ENABLE_DEBUG_GUN			    ; Peashooters on every bat
;ENABLE_DEBUG_PWR			    ; Powerups on keypress
;ENABLE_DEBUG_ADDRERR		    ; Install level 3 interrupt "handler"

; Sybol breakdown into constituent parts
	IFD		ENABLE_DEBUG_ENEMYCOLLISION
ENABLE_BALLDEBUG
ENABLE_DEBUG_GAMEAREA
ENABLE_BALLRELEASE
ENABLE_TESTCASES
	ENDIF
	IFD		ENABLE_DEBUG_GLUE
ENABLE_BALLDEBUG
ENABLE_TESTCASES
	ENDIF
	IFD		ENABLE_DEBUG_BALL
ENABLE_BALLDEBUG
ENABLE_DEBUG_GAMEAREA
ENABLE_BALLRELEASE
	ENDIF
	IFD		ENABLE_DEBUG_BOUNCE_REPT
ENABLE_BALLDEBUG
ENABLE_DEBUG_GAMEAREA
ENABLE_BALLRELEASE
ENABLE_TESTCASES
	ENDIF
	IFD		ENABLE_DEBUG_PLAYERS
ENABLE_BALLDEBUG
	ENDIF
	IFD		ENABLE_DEBUGLEVEL
ENABLE_DEBUG_GAMEAREA
	ENDIF
	IFD		ENABLE_DEBUG_INSANO
ENABLE_INSANO
	ENDIF
	IFD		ENABLE_DEBUG_BALL
ENABLE_INSANO
ENABLE_TESTCASES
	ENDIF


; ------------------ System ------------------ 
_EXECBASE						=	$4

; http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node006F.html
FIRST_X_POS						=	$3f
FIRST_Y_POS						=	$2c

; ------------------ Game configuration ------------------ 
ENABLE_SOUND					=	1
ENABLE_MUSIC					=	1
ENABLE_SFX						=	1
ENABLE_USERINTENT				=	1	; Disabled = start game with configured bat
ENABLE_ENEMIES					=	1

; Attract/chill config
CHILLMODE_SEC					=	12	; Seconds to stay on one screen

; ------------------ Display setup & copper ------------------ 
; See http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node006F.html
DISP_XSTRT						=	129	; $81
DISP_XSTOP						=	129+320
DISP_YSTRT						=	44	; $2c
DISP_YSTOP						=	44+256
DISP_HSTRT						=	129
DISP_WIDTH						=	320	; actual bpl width (excluding modulos)
DISP_HEIGHT						=	256
DISP_RES						=	8	; 8=lores, 4=hires

WAIT_VERT_WRAP					=	$ffdffffe	; For PAL where vertical position wraps to 0
COPPERLIST_END					=	$fffffffe
; COPNOP see http://www.amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node0060.html
COPNOP							=	$1fe

; ------------------ Blitter ------------------ 
BLTPRI_ENABLE					=	$8400	; Nasty blit on
BLTPRI_DISABLE					=	$0400	; Nasty blit off

; ------------------ States ------------------ 
; Overall GameStates
STATE_NOT_RUNNING				=	-1
STATE_RUNNING					=	0
STATE_SHOPPING					=	1

; User intent states
USERINTENT_QUIT_CONFIRMED		=	-2
USERINTENT_QUIT					=	-1
USERINTENT_PLAY					=	0
USERINTENT_CHILL				=	1
USERINTENT_NEW_GAME				=	2	; No way around this state at the moment

; Insanoballz states
INSANOSTATE_INACTIVE			=	-1
INSANOSTATE_SLOWING				=	0
INSANOSTATE_RUNNING				=	1
INSANOSTATE_RESETTING			=	2
INSANOSTATE_PHAZE101OUT			=	3

LASTPOWERUPINDEX				=	8

; ------------------ Screen ------------------ 
; Fades
FADE_MUSICSTEPS					=	127
FADE_FRAMEWAITS					=	8

; Title
CHARBASE_W						=	21
CHARMARGIN						=	5
CHARTOP_Y						=	190

; Highscore
HISCORE_ROWHEIGHT				=	13
HISCORE_LISTOFFSET_Y			=	64
HISCORE_ENTRY_SIZEOF			=	10

RL_SIZE							=	DISP_WIDTH/8	; Bytes used per rasterline

; ------------------ Blitter ------------------ 
DEFAULT_MASK					=	$ffffffff

; ------------------ Text ------------------ 
GAMEOVER_DEST					=	(RL_SIZE*115*4)+12
GAMEOVER_MODULO					=	RL_SIZE-16
GAMEOVER_BLITSIZE				=	(64*14*4)+8
GAMEOVER_TEXTDEST				=	(RL_SIZE*118*4)+15
LEVEL_TEXTDEST					=	(RL_SIZE*118*4)+14

DEMO_DEST						=	(RL_SIZE*240*4)+16
DEMO_MODULO						=	RL_SIZE-8

; ------------------ Buttons ------------------ 
BTN_HEIGHT_SMALL				=	12
BTN_HEIGHT						=	25

; ------------------ Player ------------------ 
BAT_VERTICAL_BLITSIZE			=	(64*(45+BAT_VERTICALMARGIN+BAT_VERTICALMARGIN)*4)+1
BAT_HORIZONTAL_BLITSIZE			=	(64*7*4)+(BAT_HORIZONTAL_BYTEWIDTH/2)	; hBobBlitSize - 7 lines to blit
BAT_VERTICAL_MODULO				=	RL_SIZE-2	; [16px] 16 bits / 8 = 2 bytes to blit per line
BAT_HORIZONTAL_MODULO			=	RL_SIZE-BAT_HORIZONTAL_BYTEWIDTH		: [96px] 96 bits / 8 = 12 bytes to blit per line
BAT_DEFAULTSPEED				=	2
BAT_VERTICALMARGIN				=	10	; Number of pixels
BAT_HORIZONTAL_BYTEWIDTH		=	12	; Number of bytes/line to blit

BAT_VERT_DEFAULTHEIGHT			=	33
BAT_HORIZ_DEFAULTWIDTH			=	44
BAT_HORIZ_LEFT_OFFSET			=	32

BATEFFECTBIT_GLUE				=	0

BAT_EFFECT_GLUE					=	%00000001
BAT_EFFECT_GUN					=	%00000010
BAT_EFFECT_BREACH				=	%00000010

CONTROL_JOYSTICK				=	0
CONTROL_KEYBOARD				=	1

AFTERBATHIT_COUNT				=	21

; Keyboard controls
; No keyboard support for player 0.
; Reason: A1200 keyboard matrix makes it too hard to achieve 4 simultaneous keyboard players.
; Also too awkward and stupid to have 4-8 hands around 1 keyboard.
; Will just end up blocking eachother if > 1 keydown on same matrix ROW, see:
; http://www.amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node017A.html
PLAYER1_KEYUP					=	KEY_1
PLAYER1_KEYDOWN					=	KEY_Q
PLAYER1_KEYFIRE					=	KEY_LEFTSHIFT
PLAYER2_KEYLEFT					=	KEY_K
PLAYER2_KEYRIGHT				=	KEY_L
PLAYER2_KEYFIRE					=	KEY_RIGHTAMIGA
PLAYER3_KEYLEFT					=	KEY_Z
PLAYER3_KEYRIGHT				=	KEY_X
PLAYER3_KEYFIRE					=	KEY_LEFTAMIGA

; ------------------ Enemy ------------------ 
ENEMIES_DEFAULTMAX				=	12
ENEMY_SINMAX					=	31
ENEMY_STRUCTSIZE				=	72	; bytes

ENEMY1_BLITSIZE					=	(64*16*4)+2	; hBobBlitSize
ENEMY1_MODULO					=	RL_SIZE-4
; ExplosionBlitSize	=	(64*16*4)+2	; hBobBlitSize
; ExplosionModulo	=	RL_SIZE-4
ENEMY_EXPLOSIONCOUNT			=	14

; ------------------ Powerup ------------------ 
PWR_EXTRAPOINTS_BASEVALUE		=	60
DEFAULT_INSANODROPS				=	12
INSANOTICKS						=	18

BULLET_MAXSLOTS					=	12
BULLET_STRUCTSIZE				=	70	; bytes

; ------------------ Shop ------------------ 
SHOP_TEXTHEIGHT					=	RL_SIZE*7*4

SHOP_ITEMA_VERTTOP_Y			=	79
SHOP_ITEMB_VERTTOP_Y			=	147
SHOP_BLITSIZE					=	(64*25*4)+3	; hBobBlitSize
SHOP_MODULO						=	RL_SIZE-6

SHOPKEEP_BLITSIZE				=	(64*25*4)+3	; hBobBlitSize
SHOPKEEP_MODULO					=	RL_SIZE-6

SHOPITEM_BALL_BASEVALUE			=	-320
SHOPITEM_STEAL_BASEVALUE		=	960
SHOPITEM_POINTS_BASEVALUE		=	70
SHOPITEM_BIGPOINTS_BASEVALUE	=	90
SHOPITEM_VERTICALMODULO			=	RL_SIZE-4
SHOPITEM_HORIZONTALMODULO		=	RL_SIZE-10
SHOPITEM_VERTICALBLITSIZE		=	(64*7*4)+2
SHOPITEM_HORIZONTALBLITSIZE		=	(64*7*4)+5

SHOPITEMS_VERTICALHEIGHT		=	119	; px

; ------------------ Ball ------------------ 
INIT_BALLCOUNT					=	3	; Number of balls at game start
SOFTLOCK_FRAMES					=	15	; Seconds until anti-softlock mechanism kicks in

BALL_DIAMETER					=	7
VC_FACTOR						=	64	; Virtual coordinates have 2^6 times resolution
VC_POW							=	6	; Exponent/power (base = 2), giving 2^6 times resolution

BALL_BLITSIZE					=	(64*7*4)+2	; hBobBlitSize
BALL_MODULO						=	RL_SIZE-4

MIN_BALLSPEED					=	8
DEFAULT_BALLSPEED				=	50
USERMAX_BALLSPEED				=	84

DEFAULT_RAMPUP					=	120
MIN_RAMPUP						=	10
MAX_RAMPUP						=	255

BALLEFFECTBIT_BREACH			=	1

; Buggy collision detection above this speed
BALL_MAXSPEED					=	2*VC_FACTOR

; ------------------ Brick ------------------ 
GAMEAREA_ROWS					=	32	; Number of visible GAMEAREA rows

BRICKSTRUCTSIZE					=	78	; bytes
STATICBRICKS_START				=	$10
MAX_RANDOMBRICKS				=	$4a
RANDOMBRICKS_START				=	$31
BRICK_2ND_BYTE					=	$7f
WALL_BYTE						=	$fe

MAXBRICKROWS					=	28	; TODO: Adjust later - lower the max brick count
MAXBRICKCOLS					=	18
MAXBRICKS						=	MAXBRICKCOLS*MAXBRICKROWS
MAXANIMBRICKS					=	32
MAXBLINKBRICKS					=	4
INDESTRUCTABLEBRICK				=	$30

ALLBLINKBRICKSSIZE				=	5*4
BLINKOFFSTRUCTSIZE				=	78	; Size in bytes

; ------------------ Joystick ------------------ 
; Joystick flags/return codes.
; These have been selected to line up well with joy-input from parallel port.
; The upper nibble can contain movement input from JOY3 (i.e the fourth joystick).
; Directions can be combined, for instance JOY_RIGHT + JOY_UP.
; Firebuttons are treated separately.
JOY_NOTHING						=	$FF	; %1111 1111

JOY_UP							=	$FE	; %1111 1110
JOY_UP_BIT						=	0
JOY_DOWN						=	$FD	; %1111 1101
JOY_DOWN_BIT					=	1
JOY_LEFT						=	$FB	; %1111 1011
JOY_LEFT_BIT					=	2
JOY_RIGHT						=	$F7	; %1111 0111
JOY_RIGHT_BIT					=	3

JOY0_FIRE0						=	$FE	; %1111 1110
JOY0_FIRE0_BIT					=	0
JOY1_FIRE0						=	$FD	; %1111 1101
JOY1_FIRE0_BIT					=	1
JOY2_FIRE0						=	$FB	; %1111 1011 - SELECT=0
JOY2_FIRE0_BIT					=	2
JOY3_FIRE0						=	$FE	; %1111 1110 - BUSY=0
JOY3_FIRE0_BIT					=	0