;------
Spr_Ball0:
	dc.b 	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b 	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;------
Spr_Ball1:
	dc.b 	$00	; VSTART
	dc.b 	$00	; HSTART
	dc.b 	$00	; VSTOP
	dc.b 	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;------
Spr_Ball2:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;------
; Insano
Spr_Ball3:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;-------
; Insano
Spr_Ball4:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;------
; Insano
Spr_Ball5:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;------
; Insano
Spr_Ball6:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
;------
; Insano
Spr_Ball7:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even


;------
Spr_PowerupFrame:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
Spr_LetterFrame:
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even

Spr_Powerup:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
Spr_Letter:
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even

	; Size: 13 longwords
Spr_Powerup0:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
;....... and animations
Spr_Powerup1:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $2000,$3F80 ; line 1
	dc.w $7F80,$4040 ; line 2
	dc.w $FFC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
Spr_Powerup2:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $1800,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $FFC0,$8020 ; line 4
	dc.w $FFC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
Spr_Powerup3:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0600,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $FFC0,$8020 ; line 6
	dc.w $FFC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
Spr_Powerup4:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0180,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $FFC0,$8020 ; line 8
	dc.w $FFC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
Spr_Powerup5:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
	dc.w $3FC0,$4040 ; line 2
	dc.w $7FE0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $7F80,$4040 ; line 10
	dc.w $2000,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
Spr_Powerup6:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FE0,$8020 ; line 4
	dc.w $7FE0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $1800,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even
Spr_Powerup7:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FE0,$8020 ; line 6
	dc.w $7FE0,$8020 ; line 7
	dc.w $7FC0,$8020 ; line 8
	dc.w $7FC0,$8020 ; line 9
	dc.w $3F80,$4040 ; line 10
	dc.w $0600,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even

Spr_Powerup8:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits

	dc.w $0000,$3F80 ; line 1
	dc.w $3F80,$4040 ; line 2
	dc.w $7FC0,$8020 ; line 3
	dc.w $7FC0,$8020 ; line 4
	dc.w $7FC0,$8020 ; line 5
	dc.w $7FC0,$8020 ; line 6
	dc.w $7FC0,$8020 ; line 7
	dc.w $7FE0,$8020 ; line 8
	dc.w $7FE0,$8020 ; line 9
	dc.w $3FC0,$4040 ; line 10
	dc.w $0180,$3F80 ; line 11

	dc.w	0,0	; End of Sprite
	even


;------
Spr_Ball0Anim0:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$2800,$1800
	dc.w	$4400,$3c00
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$7800
	dc.w	$2800,$3000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim1:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3000,$0800
	dc.w	$4400,$3c00
	dc.w	$9200,$7e00
	dc.w	$ba00,$7c00
	dc.w	$9200,$fc00
	dc.w	$4400,$7800
	dc.w	$1800,$2000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim2:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4000,$3c00
	dc.w	$9200,$7e00
	dc.w	$ba00,$fe00
	dc.w	$9200,$fc00
	dc.w	$0400,$7800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim3:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9000,$fe00
	dc.w	$ba00,$fe00
	dc.w	$1200,$fe00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim4:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$7800
	dc.w	$9200,$fc00
	dc.w	$3800,$fe00
	dc.w	$9200,$7e00
	dc.w	$4400,$3c00
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim5:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$2000
	dc.w	$4400,$7800
	dc.w	$1200,$fc00
	dc.w	$ba00,$7c00
	dc.w	$9000,$7e00
	dc.w	$4400,$3c00
	dc.w	$3800,$0800
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim6:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$3000
	dc.w	$0400,$7800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4000,$3c00
	dc.w	$3800,$1800
	dc.w	0,0	; End of Sprite
	even
Spr_Ball0Anim7:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$1800,$3800
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3000,$3800
	dc.w	0,0	; End of Sprite
	even


;------
Spr_Ball1Anim0:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$2800,$1800
	dc.w	$4400,$3c00
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$7800
	dc.w	$2800,$3000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim1:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3000,$0800
	dc.w	$4400,$3c00
	dc.w	$9200,$7e00
	dc.w	$ba00,$7c00
	dc.w	$9200,$fc00
	dc.w	$4400,$7800
	dc.w	$1800,$2000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim2:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4000,$3c00
	dc.w	$9200,$7e00
	dc.w	$ba00,$fe00
	dc.w	$9200,$fc00
	dc.w	$0400,$7800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim3:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9000,$fe00
	dc.w	$ba00,$fe00
	dc.w	$1200,$fe00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim4:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$7800
	dc.w	$9200,$fc00
	dc.w	$3800,$fe00
	dc.w	$9200,$7e00
	dc.w	$4400,$3c00
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim5:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$2000
	dc.w	$4400,$7800
	dc.w	$1200,$fc00
	dc.w	$ba00,$7c00
	dc.w	$9000,$7e00
	dc.w	$4400,$3c00
	dc.w	$3800,$0800
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim6:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$3000
	dc.w	$0400,$7800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4000,$3c00
	dc.w	$3800,$1800
	dc.w	0,0	; End of Sprite
	even
Spr_Ball1Anim7:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$1800,$3800
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3000,$3800
	dc.w	0,0	; End of Sprite
	even


;------
Spr_Ball2Anim0:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$2800,$1800
	dc.w	$4400,$3c00
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$7800
	dc.w	$2800,$3000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim1:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3000,$0800
	dc.w	$4400,$3c00
	dc.w	$9200,$7e00
	dc.w	$ba00,$7c00
	dc.w	$9200,$fc00
	dc.w	$4400,$7800
	dc.w	$1800,$2000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim2:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4000,$3c00
	dc.w	$9200,$7e00
	dc.w	$ba00,$fe00
	dc.w	$9200,$fc00
	dc.w	$0400,$7800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim3:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$3800
	dc.w	$9000,$fe00
	dc.w	$ba00,$fe00
	dc.w	$1200,$fe00
	dc.w	$4400,$3800
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim4:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$0000
	dc.w	$4400,$7800
	dc.w	$9200,$fc00
	dc.w	$3800,$fe00
	dc.w	$9200,$7e00
	dc.w	$4400,$3c00
	dc.w	$3800,$0000
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim5:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$2000
	dc.w	$4400,$7800
	dc.w	$1200,$fc00
	dc.w	$ba00,$7c00
	dc.w	$9000,$7e00
	dc.w	$4400,$3c00
	dc.w	$3800,$0800
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim6:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$3800,$3000
	dc.w	$0400,$7800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4000,$3c00
	dc.w	$3800,$1800
	dc.w	0,0	; End of Sprite
	even
Spr_Ball2Anim7:
	dc.b	$00	; VSTART
	dc.b	$00	; HSTART
	dc.b	$00	; VSTOP
	dc.b	$00	; Control bits
	dc.w	$1800,$3800
	dc.w	$4400,$3800
	dc.w	$9200,$7c00
	dc.w	$ba00,$7c00
	dc.w	$9200,$7c00
	dc.w	$4400,$3800
	dc.w	$3000,$3800
	dc.w	0,0	; End of Sprite
	even



; Powerup letters
; $
Spr_Powerup_Score:
	dc.w	$0000,%0000010000000000	; line 2
	dc.w	$0000,%0001111100000000	; line 3
	dc.w	$0000,%0011010110000000	; line 4
	dc.w	$0000,%0011010000000000	; line 5
	dc.w	$0000,%0001111100000000	; line 6
	dc.w	$0000,%0000010110000000	; line 7
	dc.w	$0000,%0011010110000000	; line 8
	dc.w	$0000,%0001111100000000	; line 9
	dc.w	$0000,%0000010000000000	; line 10
Spr_Powerup_Breachball:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0011111100000000	; line 3
	dc.w	$0000,%0011000110000000	; line 4
	dc.w	$0000,%0011000110000000	; line 5
	dc.w	$0000,%0011111100000000	; line 6
	dc.w	$0000,%0011000110000000	; line 7
	dc.w	$0000,%0011000110000000	; line 8
	dc.w	$0000,%0011111100000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10
Spr_Powerup_WideBat:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0011111110000000	; line 3
	dc.w	$0000,%0011000000000000	; line 4
	dc.w	$0000,%0011000000000000	; line 5
	dc.w	$0000,%0011111110000000	; line 6
	dc.w	$0000,%0011000000000000	; line 7
	dc.w	$0000,%0011000000000000	; line 8
	dc.w	$0000,%0011111110000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10
Spr_Powerup_Glue:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0001111100000000	; line 3
	dc.w	$0000,%0011000110000000	; line 4
	dc.w	$0000,%0011000000000000	; line 5
	dc.w	$0000,%0011011110000000	; line 6
	dc.w	$0000,%0011000110000000	; line 7
	dc.w	$0000,%0011000110000000	; line 8
	dc.w	$0000,%0001111100000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10
Spr_Powerup_Multiball:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0011000110000000	; line 3
	dc.w	$0000,%0011101110000000	; line 4
	dc.w	$0000,%0011111110000000	; line 5
	dc.w	$0000,%0011010110000000	; line 6
	dc.w	$0000,%0011000110000000	; line 7
	dc.w	$0000,%0011000110000000	; line 8
	dc.w	$0000,%0011000110000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10
Spr_Powerup_Batspeed:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0001111100000000	; line 3
	dc.w	$0000,%0011000110000000	; line 4
	dc.w	$0000,%0011000000000000	; line 5
	dc.w	$0000,%0001111100000000	; line 6
	dc.w	$0000,%0000000110000000	; line 7
	dc.w	$0000,%0011000110000000	; line 8
	dc.w	$0000,%0001111100000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10
Spr_Powerup_Gun:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0011111100000000	; line 3
	dc.w	$0000,%0011000110000000	; line 4
	dc.w	$0000,%0011000110000000	; line 5
	dc.w	$0000,%0011111100000000	; line 6
	dc.w	$0000,%0011000000000000	; line 7
	dc.w	$0000,%0011000000000000	; line 8
	dc.w	$0000,%0011000000000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10
Spr_Powerup_Insanoballs:
	dc.w	$0000,%0000000000000000	; line 2
	dc.w	$0000,%0001111100000000	; line 3
	dc.w	$0000,%0000111000000000	; line 4
	dc.w	$0000,%0000111000000000	; line 5
	dc.w	$0000,%0000111000000000	; line 6
	dc.w	$0000,%0000111000000000	; line 7
	dc.w	$0000,%0000111000000000	; line 8
	dc.w	$0000,%0001111100000000	; line 9
	dc.w	$0000,%0000000000000000	; line 10