
; ------------------ Highscore ------------------ 
Player0InitialsBuffer:  dc.l    $41414100	; A-Z $41-$5a
Player1InitialsBuffer:  dc.l    $41414100
Player2InitialsBuffer:  dc.l    $41414100
Player3InitialsBuffer:  dc.l    $41414100

; Top 10 high scores
HighScores:
	dc.l	5600						; Score
	dc.b	"ELK",0						; Initials string
	dc.l	4400						; Score
	dc.b	"COW",0						; Initials string
	dc.l	3200						; Score
	dc.b	"PIG",0						; Initials string
	dc.l	2000						; Score
	dc.b	"DOG",0						; Initials string
	dc.l	64							; Score
	dc.b	"CAT",0						; Initials string
	dc.l	32							; Score
	dc.b	"EEL",0						; Initials string
	dc.l	16							; Score
	dc.b	"KOI",0						; Initials string
	dc.l	8							; Score
	dc.b	"RAT",0						; Initials string
	dc.l	4							; Score
	dc.b	"FLY",0						; Initials string
	dc.l	2							; Score
	dc.b	"ANT",0						; Initials string

	dc.l	0							; DUMMY
	dc.b	"   ",0						; Used for logic reasons when inserting new player into list