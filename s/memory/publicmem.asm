	section	PublicMemBss, bss

Variables:				ds.b	Variables_SizeOf
amgRncHeaderBuffer:		ds.w	20
FadeFromPalette16:		ds.l	16
ClockDigitMap:			ds.l	11		; Contains addresses to digit or ":" in CHIP ram
ColorTable:				ds.w	32*40 	; Contains RGB base color words
ShopPool:				ds.l	9
StringBuffer:			ds.b	56		; Roughly 56 chars possible on 1 line
KeyArray:				ds.b	$68