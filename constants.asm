; ------------------ Game configuration ------------------ 
ENABLE_SOUND				=	1
ENABLE_MUSIC				=	1
ENABLE_SFX					=	1
ENABLE_USERINTENT			=	1	; Disabled = start game with configured bat
ENABLE_ENEMIES				=	1

; Attract/chill config
CHILLMODE_SEC				=	12	; Seconds to stay on one screen

; Debug flags
ENABLE_RASTERMONITOR		=	0
ENABLE_BRICKRASTERMON		=	0
ENABLE_DEBUG_BRICKS			=	0	; Maxed out number of bricks
ENABLE_DEBUGLEVEL			=	0	; Load specific level
ENABLE_DEBUG_BRICKBUG1		=	0	; Load specific level
ENABLE_DEBUG_BRICKDROP		=	0	; Short time between brickdrops
ENABLE_DEBUG_BALL			=	0	; Repeated insanoballz - check for escaping balls
ENABLE_DEBUG_ENEMYCOLLISION	=	0	; Repeated ballrelease against target enemy
ENABLE_DEBUG_BOUNCE_REPT	=	0	; Repeated ballrelease against target area
ENABLE_DEBUG_INSANO			=	0	; Activate insanoballz
ENABLE_DEBUG_PLAYERS		=	0	; Bat0 human. Bat1-3 CPU
ENABLE_DEBUG_GLUE			=	0	; Release ball at glue bat
ENABLE_DEBUG_GUN			=	0	; Peashooters on every bat

ENABLE_DEBUG_ADDRERR		=	0	; Install level 3 interrupt "handler"

; Other game config
INIT_BALLCOUNT				=	3	; Number of balls at game start
SOFTLOCK_FRAMES				=	15	; Seconds until anti-softlock mechanism kicks in


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

ENEMY1_BLITSIZE				=	(64*16*4)+2	; hBobBlitSize
ENEMY1_MODULO				=	ScrBpl-4
; ExplosionBlitSize	=	(64*16*4)+2	; hBobBlitSize
; ExplosionModulo	=	ScrBpl-4
ENEMY_EXPLOSIONCOUNT		=	14