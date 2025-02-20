PowTable:
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	6
	dc.b	7
	dc.b	8
	dc.b	8
	dc.b	9
	dc.b	10
	dc.b	11
	dc.b	11
	dc.b	12
	dc.b	13
	dc.b	14
	dc.b	15
	dc.b	16
	dc.b	17
	dc.b	18
	dc.b	19
	dc.b	20
	dc.b	21
	dc.b	22
	dc.b	23
	dc.b	24
	dc.b	25
	dc.b	26
	dc.b	27
	dc.b	29
	dc.b	30
	dc.b	31
	dc.b	32
	dc.b	34
	dc.b	35
	dc.b	36
	dc.b	38
	dc.b	39
	dc.b	41
	dc.b	42
	dc.b	44
	dc.b	45
	dc.b	47
	even

ScrollerAnimTable:
	dc.w	%1111111111111111
	dc.w	%1111111111110111
	dc.w	%1111011111111111
	dc.w	%0111111111110111
	dc.w	%0111101111111111
	dc.w	%0111111101110111
	dc.w	%0111110111110111
	dc.w	%0111011101110111
	dc.w	%1111011101110110
	dc.w	%0111011101110101
	dc.w	%0111010101110101
	dc.w	%0111010101010101
	dc.w	%0101010101010101
	dc.w	%0101000101010101
	dc.w	%0101000101000101
	dc.w	%0001000101000101
	dc.w	%0001000100000101
	dc.w	%0001000100000100
	dc.w	%0000000100000100
ScrollerAnimTableEnd:

ScrollTextPtr: 
	dc.l	ScrollText
	dc.w	DISP_WIDTH
ScrollText:
	dc.b	"CODE AND MENU MUSIC:  FREDRIK JOHANSSON.  GAMEOVER MUSIC:  HANS WESTMAN.",0

;	debug texts
;	dc.b	"ABCDEFGHIJKLMNOPQRSTUVWXYZ.",0
;	dc.b	"RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR",0

	even

CharLoopkup:
	dc.l	SpaceChar
	dc.l	0							; !
	dc.l	0							; "
	dc.l	0							; #
	dc.l	0							; $
	dc.l	0							; %
	dc.l	0							; &
	dc.l	0							; '
	dc.l	0							; (
	dc.l	0							; )
	dc.l	0							; *
	dc.l	0							; +
	dc.l	0							; ,
	dc.l	0							; -
	dc.l	PeriodChar
	dc.l	0							; /
	dc.l	0							; 0
	dc.l	0							; 1
	dc.l	0							; 2
	dc.l	0							; 3
	dc.l	0							; 4
	dc.l	0							; 5
	dc.l	0							; 6
	dc.l	0							; 7
	dc.l	0							; 8
	dc.l	0							; 9
	dc.l	ColonChar
	dc.l	0							; ;
	dc.l	0							; <
	dc.l	0							; =
	dc.l	0							; >
	dc.l	0							; ?
	dc.l	0							; @
	dc.l	Achar
	dc.l	Bchar
	dc.l	Cchar
	dc.l	Dchar
	dc.l	Echar
	dc.l	Fchar
	dc.l	Gchar
	dc.l	Hchar
	dc.l	Ichar
	dc.l	Jchar
	dc.l	Kchar
	dc.l	Lchar
	dc.l	Mchar
	dc.l	Nchar
	dc.l	Ochar
	dc.l	Pchar
	dc.l	Qchar
	dc.l	Rchar
	dc.l	Schar
	dc.l	Tchar
	dc.l	Uchar
	dc.l	Vchar
	dc.l	Wchar
	dc.l	Xchar
	dc.l	Ychar
	dc.l	Zchar

SpaceChar:
	dc.w	14+CHARMARGIN				; Width
	dc.w	-1							; END lines
PeriodChar:
	dc.w	6+CHARMARGIN				; Width
							; START lines
	dc.w	3			
	dc.w	CHARTOP_Y+32-3-3	
	dc.w	6			
	dc.w	CHARTOP_Y+32-3		

	dc.w	3			
	dc.w	CHARTOP_Y+32		

	dc.w	0			
	dc.w	CHARTOP_Y+32-3		

	dc.w	3			
	dc.w	CHARTOP_Y+32-3-3	

	dc.w	-1							; END lines
ColonChar;
	dc.w	6+CHARMARGIN				; Width
							; START lines
	dc.w	3			
	dc.w	CHARTOP_Y+5		
	dc.w	6			
	dc.w	CHARTOP_Y+5+3		

	dc.w	3			
	dc.w	CHARTOP_Y+5+3+3		

	dc.w	0			
	dc.w	CHARTOP_Y+5+3		

	dc.w	3			
	dc.w	CHARTOP_Y+5		

	dc.w	-2
	dc.w	3			
	dc.w	CHARTOP_Y+32-5-3-3	
	dc.w	6			
	dc.w	CHARTOP_Y+32-5-3	

	dc.w	3			
	dc.w	CHARTOP_Y+32-5		

	dc.w	0			
	dc.w	CHARTOP_Y+32-5-3	

	dc.w	3			
	dc.w	CHARTOP_Y+32-5-3-3	

	dc.w	-1							; END lines


Achar:
	dc.w	26+CHARMARGIN				; Width
							; START lines

	dc.w	10							; x1
	dc.w	CHARTOP_Y					; y1
	dc.w	10+6						; x2
	dc.w	CHARTOP_Y					; y2

	dc.w	26							; x2 
	dc.w	CHARTOP_Y+32				; y2

	dc.w	26-5						; x2
	dc.w	CHARTOP_Y+32				; y2

	dc.w	5+2+12						; x2
	dc.w	CHARTOP_Y+24				; y2

	dc.w	5+3							; x2
	dc.w	CHARTOP_Y+24				; y2

	dc.w	5							; x2
	dc.w	CHARTOP_Y+32				; y2

	dc.w	0							; x2
	dc.w	CHARTOP_Y+32				; y2

	dc.w	10							; x2
	dc.w	CHARTOP_Y					; y2

	dc.w	-2
	dc.w	13							; x1
	dc.w	CHARTOP_Y+6					; y1
	dc.w	13-4						; x2
	dc.w	CHARTOP_Y+6+13				; y2

	dc.w	13+4						; x2
	dc.w	CHARTOP_Y+6+13				; y2

	dc.w	13							; x2
	dc.w	CHARTOP_Y+6					; y2

	dc.w	-1							; END lines

Bchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
							; START lines
	dc.w	0			
	dc.w	CHARTOP_Y		
	dc.w	13			
	dc.w	CHARTOP_Y		

	dc.w	13+4			
	dc.w	CHARTOP_Y+1		

	dc.w	CHARBASE_W			
	dc.w	CHARTOP_Y+1+4		

	dc.w	CHARBASE_W			
	dc.w	CHARTOP_Y+1+4+6		

	dc.w	15			
	dc.w	CHARTOP_Y+16		

	dc.w	CHARBASE_W			
	dc.w	CHARTOP_Y+16+5		

	dc.w	CHARBASE_W			
	dc.w	CHARTOP_Y+16+5+6	

	dc.w	13+4			
	dc.w	CHARTOP_Y+32-1		

	dc.w	13			
	dc.w	CHARTOP_Y+32		

	dc.w	0			
	dc.w	CHARTOP_Y+32		

	dc.w	0			
	dc.w	CHARTOP_Y		


	dc.w	-2
	dc.w	5			
	dc.w	CHARTOP_Y+5		
	dc.w	13-3+2			
	dc.w	CHARTOP_Y+5		

	dc.w	13-3+4+1		
	dc.w	CHARTOP_Y+5+1+3		

	dc.w	13-3			
	dc.w	CHARTOP_Y+14		

	dc.w	5			
	dc.w	CHARTOP_Y+14		

	dc.w	5			
	dc.w	CHARTOP_Y+5		


	dc.w	-2
	dc.w	5			
	dc.w	CHARTOP_Y+19		
	dc.w	13-3			
	dc.w	CHARTOP_Y+19		

	dc.w	13-3+4+1		
	dc.w	CHARTOP_Y+18+6		

	dc.w	13-3+2			
	dc.w	CHARTOP_Y+18+5+3+1	

	dc.w	5			
	dc.w	CHARTOP_Y+32-5		

	dc.w	5			
	dc.w	CHARTOP_Y+19		

	dc.w	-1							; END lines

Cchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
								; START lines

	dc.w	0			
	dc.w	CHARTOP_Y		
	dc.w	CHARBASE_W			
	dc.w	CHARTOP_Y		

	dc.w	CHARBASE_W			
	dc.w	CHARTOP_Y+5		

	dc.w	5			
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Dchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	16		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+16

	dc.w	16		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-2
	dc.w	5		
	dc.w	CHARTOP_Y+5		
	dc.w	16-4		
	dc.w	CHARTOP_Y+5		

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+16

	dc.w	16-4		
	dc.w	CHARTOP_Y+32-5	

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	-1							; END lines

Echar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+14		

	dc.w	14		
	dc.w	CHARTOP_Y+14		

	dc.w	14		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Fchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+14		

	dc.w	14		
	dc.w	CHARTOP_Y+14		

	dc.w	14		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Gchar:
	dc.w	22+CHARMARGIN				; Width
							; START lines

	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	22		
	dc.w	CHARTOP_Y	

	dc.w	22		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	22-5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	22-5		
	dc.w	CHARTOP_Y+14		

	dc.w	5+4		
	dc.w	CHARTOP_Y+14		

	dc.w	5+4		
	dc.w	CHARTOP_Y+18		

	dc.w	22		
	dc.w	CHARTOP_Y+18		

	dc.w	22		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Hchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y+14		

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+14		

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32		

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+32		

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+18		

	dc.w	5		
	dc.w	CHARTOP_Y+18		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Ichar:
	dc.w	5+CHARMARGIN				; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Jchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-7	

	dc.w	12		
	dc.w	CHARTOP_Y+32		

	dc.w	7		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32-4	

	dc.w	2		
	dc.w	CHARTOP_Y+32-4-5	

	dc.w	5+5		
	dc.w	CHARTOP_Y+32-5-1	

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+32-10	

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+5		

	dc.w	0		
	dc.w	CHARTOP_Y+5		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Kchar:
	dc.w	23+CHARMARGIN				; Width
							; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y+11		

	dc.w	23-7		
	dc.w	CHARTOP_Y	

	dc.w	23		
	dc.w	CHARTOP_Y	

	dc.w	5+2		
	dc.w	CHARTOP_Y+16		

	dc.w	23		
	dc.w	CHARTOP_Y+32		

	dc.w	23-7		
	dc.w	CHARTOP_Y+32		

	dc.w	5		
	dc.w	CHARTOP_Y+21		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Lchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Mchar:
	dc.w	26+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	13		
	dc.w	CHARTOP_Y+22-5	

	dc.w	26-5		
	dc.w	CHARTOP_Y	

	dc.w	26		
	dc.w	CHARTOP_Y	

	dc.w	26		
	dc.w	CHARTOP_Y+32		

	dc.w	26-5		
	dc.w	CHARTOP_Y+32		

	dc.w	26-5		
	dc.w	CHARTOP_Y+5+6		

	dc.w	13+2		
	dc.w	CHARTOP_Y+24		

	dc.w	13-2		
	dc.w	CHARTOP_Y+24		

	dc.w	5		
	dc.w	CHARTOP_Y+5+6		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Nchar:
	dc.w	21+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	21-5		
	dc.w	CHARTOP_Y+32-5-5	

	dc.w	21-5		
	dc.w	CHARTOP_Y	

	dc.w	21		
	dc.w	CHARTOP_Y	

	dc.w	21		
	dc.w	CHARTOP_Y+32		

	dc.w	21-5		
	dc.w	CHARTOP_Y+32		

	dc.w	5		
	dc.w	CHARTOP_Y+5+5		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Ochar:
	dc.w	21+CHARMARGIN				; Width
						; START lines

	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	21		
	dc.w	CHARTOP_Y	

	dc.w	21		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-2
	dc.w	5		
	dc.w	CHARTOP_Y+5		
	dc.w	21-5		
	dc.w	CHARTOP_Y+5		

	dc.w	21-5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	-1							; END lines

Pchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	13		
	dc.w	CHARTOP_Y	

	dc.w	13+4		
	dc.w	CHARTOP_Y+1		

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+1+4		

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+1+4+6+2	

	dc.w	14		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-2
	dc.w	5		
	dc.w	CHARTOP_Y+5		
	dc.w	13-2+2		
	dc.w	CHARTOP_Y+5		

	dc.w	13-2+4		
	dc.w	CHARTOP_Y+5+1+4	

	dc.w	13-2		
	dc.w	CHARTOP_Y+14		

	dc.w	5		
	dc.w	CHARTOP_Y+14		

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	-1							; END lines

Qchar:
	dc.w	21+CHARMARGIN				; Width
						; START lines

	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	21		
	dc.w	CHARTOP_Y	

	dc.w	21		
	dc.w	CHARTOP_Y+21		

	dc.w	21-4		
	dc.w	CHARTOP_Y+21+4	

	dc.w	21		
	dc.w	CHARTOP_Y+32-3	

	dc.w	21-3		
	dc.w	CHARTOP_Y+32		

	dc.w	21-3-4		
	dc.w	CHARTOP_Y+32-4	

	dc.w	10		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-2
	dc.w	5		
	dc.w	CHARTOP_Y+5		
	dc.w	21-5		
	dc.w	CHARTOP_Y+5		

	dc.w	21-5		
	dc.w	CHARTOP_Y+21-2	

	dc.w	8		
	dc.w	CHARTOP_Y+32-5	

	dc.w	5		
	dc.w	CHARTOP_Y+32-5	

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	-1							; END lines

Rchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	13+3		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+1+4		

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+1+4+6+1	

	dc.w	15		
	dc.w	CHARTOP_Y+18		

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32		

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+32		

	dc.w	15-5		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+19		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-2
	dc.w	5		
	dc.w	CHARTOP_Y+5		
	dc.w	13-2+1		
	dc.w	CHARTOP_Y+5		

	dc.w	13-2+5		
	dc.w	CHARTOP_Y+5+1+3	

	dc.w	13-1		
	dc.w	CHARTOP_Y+14		

	dc.w	5		
	dc.w	CHARTOP_Y+14		

	dc.w	5		
	dc.w	CHARTOP_Y+5		

	dc.w	-1							; END lines

Schar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
						; START lines
	dc.w	5		
	dc.w	CHARTOP_Y	
	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+5		

	dc.w	5+3		
	dc.w	CHARTOP_Y+5		

	dc.w	5		
	dc.w	CHARTOP_Y+5+3		

	dc.w	5		
	dc.w	CHARTOP_Y+5+3+3	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-5-8	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W-5-2		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W-5		
	dc.w	CHARTOP_Y+32-5-3-2	

	dc.w	0		
	dc.w	CHARTOP_Y+16-2	

	dc.w	0		
	dc.w	CHARTOP_Y+16-5-6	

	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Tchar:
	dc.w	21+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	21		
	dc.w	CHARTOP_Y	

	dc.w	21		
	dc.w	CHARTOP_Y+5		

	dc.w	10+3		
	dc.w	CHARTOP_Y+5		

	dc.w	10+3		
	dc.w	CHARTOP_Y+32		

	dc.w	10-2		
	dc.w	CHARTOP_Y+32		

	dc.w	10-2		
	dc.w	CHARTOP_Y+5		

	dc.w	0		
	dc.w	CHARTOP_Y+5		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Uchar:
	dc.w	22+CHARMARGIN				; Width
						; START lines

	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y+32-5-4	

	dc.w	5+4		
	dc.w	CHARTOP_Y+32-5	

	dc.w	22-5-4		
	dc.w	CHARTOP_Y+32-5	

	dc.w	22-5		
	dc.w	CHARTOP_Y+32-5-4	

	dc.w	22-5		
	dc.w	CHARTOP_Y	

	dc.w	22		
	dc.w	CHARTOP_Y	

	dc.w	22		
	dc.w	CHARTOP_Y+32-5	

	dc.w	22-5		
	dc.w	CHARTOP_Y+32		

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32-5	

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Vchar:
	dc.w	26+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5+8		
	dc.w	CHARTOP_Y+32-5	

	dc.w	26-5		
	dc.w	CHARTOP_Y	

	dc.w	26		
	dc.w	CHARTOP_Y	

	dc.w	5+8+3		
	dc.w	CHARTOP_Y+32		

	dc.w	5+8-3		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Wchar:
	dc.w	26+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	5		
	dc.w	CHARTOP_Y	

	dc.w	5		
	dc.w	CHARTOP_Y+32-5-6	

	dc.w	13-2		
	dc.w	CHARTOP_Y+8		

	dc.w	13+2		
	dc.w	CHARTOP_Y+8		

	dc.w	26-5		
	dc.w	CHARTOP_Y+32-5-6	

	dc.w	26-5		
	dc.w	CHARTOP_Y	

	dc.w	26		
	dc.w	CHARTOP_Y	

	dc.w	26		
	dc.w	CHARTOP_Y+32		

	dc.w	26-5		
	dc.w	CHARTOP_Y+32		

	dc.w	13		
	dc.w	CHARTOP_Y+10+5	

	dc.w	5		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Xchar:
	dc.w	24+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	6		
	dc.w	CHARTOP_Y	
	
	dc.w	12		
	dc.w	CHARTOP_Y+16-4	

	dc.w	24-7		
	dc.w	CHARTOP_Y	

	dc.w	24		
	dc.w	CHARTOP_Y	

	dc.w	12+4		
	dc.w	CHARTOP_Y+16+1	

	dc.w	24		
	dc.w	CHARTOP_Y+32		

	dc.w	24-6		
	dc.w	CHARTOP_Y+32		

	dc.w	12		
	dc.w	CHARTOP_Y+16+4+1	

	dc.w	6		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	12-4		
	dc.w	CHARTOP_Y+16		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Ychar:
	dc.w	24+CHARMARGIN				; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	6		
	dc.w	CHARTOP_Y	
	
	dc.w	12		
	dc.w	CHARTOP_Y+16-4	

	dc.w	24-7		
	dc.w	CHARTOP_Y	

	dc.w	24		
	dc.w	CHARTOP_Y	

	dc.w	12+3		
	dc.w	CHARTOP_Y+16+1	

	dc.w	12+3		
	dc.w	CHARTOP_Y+32		

	dc.w	12-3		
	dc.w	CHARTOP_Y+32		

	dc.w	12-3		
	dc.w	CHARTOP_Y+16+1	

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines

Zchar:
	dc.w	CHARBASE_W+CHARMARGIN		; Width
						; START lines
	dc.w	0		
	dc.w	CHARTOP_Y	
	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+5		

	dc.w	6		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32		

	dc.w	0		
	dc.w	CHARTOP_Y+32-5	

	dc.w	CHARBASE_W-6		
	dc.w	CHARTOP_Y+5		

	dc.w	0		
	dc.w	CHARTOP_Y+5		

	dc.w	0		
	dc.w	CHARTOP_Y	

	dc.w	-1							; END lines