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


; ------------------ Game configuration ------------------ 
ENABLE_SOUND				=	1
ENABLE_MUSIC				=	1
ENABLE_SFX					=	1
ENABLE_USERINTENT			=	1	; Disabled = start game with configured bat
ENABLE_ENEMIES				=	1

; Attract/chill config
CHILLMODE_SEC				=	12	; Seconds to stay on one screen


; ------------------ States ------------------ 
; Overall GameStates
STATE_NOT_RUNNING			=	-1
STATE_RUNNING				=	0
STATE_SHOPPING				=	1

; User intent states
USERINTENT_QUIT_CONFIRMED	=	-2
USERINTENT_QUIT				=	-1
USERINTENT_PLAY				=	0
USERINTENT_CHILL			=	1
USERINTENT_NEW_GAME			=	2	; No way around this state at the moment

; Insanoballz states
INSANOSTATE_INACTIVE		=	-1
INSANOSTATE_SLOWING			=	0
INSANOSTATE_RUNNING			=	1
INSANOSTATE_RESETTING		=	2
INSANOSTATE_PHAZE101OUT		=	3

LASTPOWERUPINDEX			=	8

; ------------------ Screen-related ------------------ 
; Fades
FADE_MUSICSTEPS				=	127
FADE_FRAMEWAITS				=	8

; Title
CHARBASE_W					=	21
CHARMARGIN					=	5
CHARTOP_Y					=	190

; ------------------ Enemy-related ------------------ 
ENEMIES_DEFAULTMAX			=	12
ENEMY_SINMAX				=	31
ENEMY_STRUCTSIZE			=	72	; bytes

ENEMY1_BLITSIZE				=	(64*16*4)+2	; hBobBlitSize
ENEMY1_MODULO				=	ScrBpl-4
; ExplosionBlitSize	=	(64*16*4)+2	; hBobBlitSize
; ExplosionModulo	=	ScrBpl-4
ENEMY_EXPLOSIONCOUNT		=	14

; ------------------ Powerup-related ------------------ 
PWR_EXTRAPOINTS_BASEVALUE	=	60
DEFAULT_INSANODROPS			=	12
INSANOTICKS					=	25

; ------------------ Ball-related ------------------ 
INIT_BALLCOUNT				=	3	; Number of balls at game start
SOFTLOCK_FRAMES				=	15	; Seconds until anti-softlock mechanism kicks in

BALL_DIAMETER				=	7
VC_FACTOR					=	64	; Virtual coordinates have 2^6 times resolution
VC_POW						=	6	; Exponent/power (base = 2), giving 2^6 times resolution

BALL_BLITSIZE				=	(64*7*4)+2	; hBobBlitSize
BALL_MODULO					=	ScrBpl-4

MIN_BALLSPEED				=	8
DEFAULT_BALLSPEED			=	50
USERMAX_BALLSPEED			=	84

DEFAULT_RAMPUP				=	120
MIN_RAMPUP					=	10
MAX_RAMPUP					=	255

BALLEFFECTBIT_BREACH		=	1

; Buggy collision detection above this speed
BALL_MAXSPEED				=	2*VC_FACTOR

; ------------------ Highscore-related ------------------ 
HISCORE_ROWHEIGHT			=	13
HISCORE_LISTOFFSET_Y		=	64
HISCORE_ENTRY_SIZEOF		=	10