; Joystick flags/return codes.
; These have been selected to line up well with joy-input from parallel port.
; The upper nibble can contain movement input from JOY3 (i.e the fourth joystick).
; Directions can be combined, for instance JOY_RIGHT + JOY_UP.
; Firebuttons are treated separately.
JOY_NOTHING		equ	$FF				; %1111 1111

JOY_UP			equ	$FE				; %1111 1110
JOY_UP_BIT		equ	0
JOY_DOWN		equ	$FD				; %1111 1101
JOY_DOWN_BIT	equ	1
JOY_LEFT		equ	$FB				; %1111 1011
JOY_LEFT_BIT	equ	2
JOY_RIGHT		equ	$F7				; %1111 0111
JOY_RIGHT_BIT	equ	3

JOY0_FIRE0		equ	$FE				; %1111 1110
JOY0_FIRE0_BIT	equ	0
JOY1_FIRE0		equ	$FD				; %1111 1101
JOY1_FIRE0_BIT	equ	1
JOY2_FIRE0		equ	$FB				; %1111 1011 - SELECT=0
JOY2_FIRE0_BIT	equ	2
JOY3_FIRE0		equ	$FE				; %1111 1110 - BUSY=0
JOY3_FIRE0_BIT	equ	0