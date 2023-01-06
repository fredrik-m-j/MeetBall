COPPTR_GAME_DEBUG:
	dc.w $01fc,$0000    ; FMODE := $0000
	dc.w $008e,$2c80    ; DIWSTRT := $2c80
	dc.w $0090,$2cc0    ; DIWSTOP := $2cc0
	dc.w $0092,$0038    ; DDFSTRT := $0038
	dc.w $0094,$00d0    ; DDFSTOP := $00d0
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0182,$0211    ; COLOR01 := $0211
	dc.w $0184,$0b11    ; COLOR02 := $0b11
	dc.w $0186,$0f11    ; COLOR03 := $0f11
	dc.w $0188,$0fff    ; COLOR04 := $0fff
	dc.w $018a,$0444    ; COLOR05 := $0444
	dc.w $018c,$0999    ; COLOR06 := $0999
	dc.w $018e,$0ddd    ; COLOR07 := $0ddd
	dc.w $0190,$0c60    ; COLOR08 := $0c60
	dc.w $0192,$0511    ; COLOR09 := $0511
	dc.w $0194,$0922    ; COLOR10 := $0922
	dc.w $0196,$0b40    ; COLOR11 := $0b40
	dc.w $0198,$0941    ; COLOR12 := $0941
	dc.w $019a,$0115    ; COLOR13 := $0115
	dc.w $019c,$0229    ; COLOR14 := $0229
	dc.w $019e,$088c    ; COLOR15 := $088c
	dc.w $0108,$0078    ; BPL1MOD := $0078
	dc.w $010a,$0078    ; BPL2MOD := $0078
	dc.w $0100,$4200    ; BPLCON0 := $4200
	dc.w $0102,$0000    ; BPLCON1 := $0000
	dc.w $0104,$0020    ; BPLCON2 := $0020
	dc.w $0106,$0000    ; BPLCON3 := $0000
	dc.w $00e0,$0001    ; BPL1PTH := $0001
	dc.w $00e2,$fdc4    ; BPL1PTL := $fdc4
	dc.w $00e4,$0001    ; BPL2PTH := $0001
	dc.w $00e6,$fdec    ; BPL2PTL := $fdec
	dc.w $00e8,$0001    ; BPL3PTH := $0001
	dc.w $00ea,$fe14    ; BPL3PTL := $fe14
	dc.w $00ec,$0001    ; BPL4PTH := $0001
	dc.w $00ee,$fe3c    ; BPL4PTL := $fe3c
	dc.w $0122,$5060    ; SPR0PTL := $5060
	dc.w $0120,$0001    ; SPR0PTH := $0001
	dc.w $0126,$50ec    ; SPR1PTL := $50ec
	dc.w $0124,$0001    ; SPR1PTH := $0001
	dc.w $012a,$50f0    ; SPR2PTL := $50f0
	dc.w $0128,$0001    ; SPR2PTH := $0001
	dc.w $012e,$5114    ; SPR3PTL := $5114
	dc.w $012c,$0001    ; SPR3PTH := $0001
	dc.w $0132,$5118    ; SPR4PTL := $5118
	dc.w $0130,$0001    ; SPR4PTH := $0001
	dc.w $0136,$511c    ; SPR5PTL := $511c
	dc.w $0134,$0001    ; SPR5PTH := $0001
	dc.w $013a,$51a8    ; SPR6PTL := $51a8
	dc.w $0138,$0001    ; SPR6PTH := $0001
	dc.w $013e,$51ac    ; SPR7PTL := $51ac
	dc.w $013c,$0001    ; SPR7PTH := $0001
	dc.w $2c3f,$fffe    ; Wait for vpos >= 0x2c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $2d3f,$fffe    ; Wait for vpos >= 0x2d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $2e3f,$fffe    ; Wait for vpos >= 0x2e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $2f3f,$fffe    ; Wait for vpos >= 0x2f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $303f,$fffe    ; Wait for vpos >= 0x30 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $313f,$fffe    ; Wait for vpos >= 0x31 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $323f,$fffe    ; Wait for vpos >= 0x32 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0161    ; COLOR00 := $0161
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $333f,$fffe    ; Wait for vpos >= 0x33 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0030    ; COLOR00 := $0030
	dc.w $0180,$0030    ; COLOR00 := $0030
	dc.w $0180,$0030    ; COLOR00 := $0030
	dc.w $0180,$0030    ; COLOR00 := $0030
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $343f,$fffe    ; Wait for vpos >= 0x34 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $34db,$fffe    ; Wait for vpos >= 0x34 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $353f,$fffe    ; Wait for vpos >= 0x35 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $35db,$fffe    ; Wait for vpos >= 0x35 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $363f,$fffe    ; Wait for vpos >= 0x36 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $36db,$fffe    ; Wait for vpos >= 0x36 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $373f,$fffe    ; Wait for vpos >= 0x37 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $37db,$fffe    ; Wait for vpos >= 0x37 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $383f,$fffe    ; Wait for vpos >= 0x38 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $38db,$fffe    ; Wait for vpos >= 0x38 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $393f,$fffe    ; Wait for vpos >= 0x39 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $39db,$fffe    ; Wait for vpos >= 0x39 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3a3f,$fffe    ; Wait for vpos >= 0x3a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3adb,$fffe    ; Wait for vpos >= 0x3a and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3b3f,$fffe    ; Wait for vpos >= 0x3b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3bdb,$fffe    ; Wait for vpos >= 0x3b and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3c3f,$fffe    ; Wait for vpos >= 0x3c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3cdb,$fffe    ; Wait for vpos >= 0x3c and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3d3f,$fffe    ; Wait for vpos >= 0x3d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3ddb,$fffe    ; Wait for vpos >= 0x3d and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3e3f,$fffe    ; Wait for vpos >= 0x3e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3edb,$fffe    ; Wait for vpos >= 0x3e and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3f3f,$fffe    ; Wait for vpos >= 0x3f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $3fdb,$fffe    ; Wait for vpos >= 0x3f and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $403f,$fffe    ; Wait for vpos >= 0x40 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $40db,$fffe    ; Wait for vpos >= 0x40 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $413f,$fffe    ; Wait for vpos >= 0x41 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $41db,$fffe    ; Wait for vpos >= 0x41 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $423f,$fffe    ; Wait for vpos >= 0x42 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $42db,$fffe    ; Wait for vpos >= 0x42 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $433f,$fffe    ; Wait for vpos >= 0x43 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $43db,$fffe    ; Wait for vpos >= 0x43 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $443f,$fffe    ; Wait for vpos >= 0x44 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $453f,$fffe    ; Wait for vpos >= 0x45 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $463f,$fffe    ; Wait for vpos >= 0x46 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $473f,$fffe    ; Wait for vpos >= 0x47 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $483f,$fffe    ; Wait for vpos >= 0x48 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $493f,$fffe    ; Wait for vpos >= 0x49 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $4a3f,$fffe    ; Wait for vpos >= 0x4a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $4b3f,$fffe    ; Wait for vpos >= 0x4b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $4c3f,$fffe    ; Wait for vpos >= 0x4c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $4d3f,$fffe    ; Wait for vpos >= 0x4d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $4e3f,$fffe    ; Wait for vpos >= 0x4e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $4f3f,$fffe    ; Wait for vpos >= 0x4f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $503f,$fffe    ; Wait for vpos >= 0x50 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $513f,$fffe    ; Wait for vpos >= 0x51 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $523f,$fffe    ; Wait for vpos >= 0x52 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $533f,$fffe    ; Wait for vpos >= 0x53 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $543f,$fffe    ; Wait for vpos >= 0x54 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $553f,$fffe    ; Wait for vpos >= 0x55 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $563f,$fffe    ; Wait for vpos >= 0x56 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $573f,$fffe    ; Wait for vpos >= 0x57 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $583f,$fffe    ; Wait for vpos >= 0x58 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $593f,$fffe    ; Wait for vpos >= 0x59 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $5a3f,$fffe    ; Wait for vpos >= 0x5a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $5b3f,$fffe    ; Wait for vpos >= 0x5b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $5c3f,$fffe    ; Wait for vpos >= 0x5c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $5d3f,$fffe    ; Wait for vpos >= 0x5d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $5e3f,$fffe    ; Wait for vpos >= 0x5e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $5f3f,$fffe    ; Wait for vpos >= 0x5f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $603f,$fffe    ; Wait for vpos >= 0x60 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $613f,$fffe    ; Wait for vpos >= 0x61 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $623f,$fffe    ; Wait for vpos >= 0x62 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $633f,$fffe    ; Wait for vpos >= 0x63 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $643f,$fffe    ; Wait for vpos >= 0x64 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $653f,$fffe    ; Wait for vpos >= 0x65 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $663f,$fffe    ; Wait for vpos >= 0x66 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $673f,$fffe    ; Wait for vpos >= 0x67 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $683f,$fffe    ; Wait for vpos >= 0x68 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $693f,$fffe    ; Wait for vpos >= 0x69 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6a3f,$fffe    ; Wait for vpos >= 0x6a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6b3f,$fffe    ; Wait for vpos >= 0x6b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6c3f,$fffe    ; Wait for vpos >= 0x6c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6c77,$fffe    ; Wait for vpos >= 0x6c and hpos >= 0x76
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6d3f,$fffe    ; Wait for vpos >= 0x6d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6d77,$fffe    ; Wait for vpos >= 0x6d and hpos >= 0x76
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6e3f,$fffe    ; Wait for vpos >= 0x6e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6e77,$fffe    ; Wait for vpos >= 0x6e and hpos >= 0x76
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6f3f,$fffe    ; Wait for vpos >= 0x6f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $6f77,$fffe    ; Wait for vpos >= 0x6f and hpos >= 0x76
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $703f,$fffe    ; Wait for vpos >= 0x70 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7077,$fffe    ; Wait for vpos >= 0x70 and hpos >= 0x76
	dc.w $0180,$00ee    ; COLOR00 := $00ee
	dc.w $0180,$00cf    ; COLOR00 := $00cf
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $713f,$fffe    ; Wait for vpos >= 0x71 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7177,$fffe    ; Wait for vpos >= 0x71 and hpos >= 0x76
	dc.w $0180,$00ee    ; COLOR00 := $00ee
	dc.w $0180,$00cf    ; COLOR00 := $00cf
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $723f,$fffe    ; Wait for vpos >= 0x72 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7277,$fffe    ; Wait for vpos >= 0x72 and hpos >= 0x76
	dc.w $0180,$00ee    ; COLOR00 := $00ee
	dc.w $0180,$00cf    ; COLOR00 := $00cf
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $733f,$fffe    ; Wait for vpos >= 0x73 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7377,$fffe    ; Wait for vpos >= 0x73 and hpos >= 0x76
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $743f,$fffe    ; Wait for vpos >= 0x74 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $746f,$fffe    ; Wait for vpos >= 0x74 and hpos >= 0x6e
	dc.w $0180,$0777    ; COLOR00 := $0777
	dc.w $0180,$0557    ; COLOR00 := $0557
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0fa9    ; COLOR00 := $0fa9
	dc.w $0180,$0f99    ; COLOR00 := $0f99
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7497,$fffe    ; Wait for vpos >= 0x74 and hpos >= 0x96
	dc.w $0180,$0cd4    ; COLOR00 := $0cd4
	dc.w $0180,$0bc4    ; COLOR00 := $0bc4
	dc.w $0180,$0fa0    ; COLOR00 := $0fa0
	dc.w $0180,$0d82    ; COLOR00 := $0d82
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $753f,$fffe    ; Wait for vpos >= 0x75 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $756f,$fffe    ; Wait for vpos >= 0x75 and hpos >= 0x6e
	dc.w $0180,$0777    ; COLOR00 := $0777
	dc.w $0180,$0557    ; COLOR00 := $0557
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0d87    ; COLOR00 := $0d87
	dc.w $0180,$0c77    ; COLOR00 := $0c77
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7597,$fffe    ; Wait for vpos >= 0x75 and hpos >= 0x96
	dc.w $0180,$0cd4    ; COLOR00 := $0cd4
	dc.w $0180,$0bc4    ; COLOR00 := $0bc4
	dc.w $0180,$0fa0    ; COLOR00 := $0fa0
	dc.w $0180,$0d82    ; COLOR00 := $0d82
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $763f,$fffe    ; Wait for vpos >= 0x76 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $766f,$fffe    ; Wait for vpos >= 0x76 and hpos >= 0x6e
	dc.w $0180,$0777    ; COLOR00 := $0777
	dc.w $0180,$0557    ; COLOR00 := $0557
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0fa9    ; COLOR00 := $0fa9
	dc.w $0180,$0f99    ; COLOR00 := $0f99
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7697,$fffe    ; Wait for vpos >= 0x76 and hpos >= 0x96
	dc.w $0180,$0cd4    ; COLOR00 := $0cd4
	dc.w $0180,$0bc4    ; COLOR00 := $0bc4
	dc.w $0180,$0fa0    ; COLOR00 := $0fa0
	dc.w $0180,$0d82    ; COLOR00 := $0d82
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $773f,$fffe    ; Wait for vpos >= 0x77 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $776f,$fffe    ; Wait for vpos >= 0x77 and hpos >= 0x6e
	dc.w $0180,$0777    ; COLOR00 := $0777
	dc.w $0180,$0557    ; COLOR00 := $0557
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0d87    ; COLOR00 := $0d87
	dc.w $0180,$0c77    ; COLOR00 := $0c77
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7797,$fffe    ; Wait for vpos >= 0x77 and hpos >= 0x96
	dc.w $0180,$0cd4    ; COLOR00 := $0cd4
	dc.w $0180,$0bc4    ; COLOR00 := $0bc4
	dc.w $0180,$0fa0    ; COLOR00 := $0fa0
	dc.w $0180,$0d82    ; COLOR00 := $0d82
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $783f,$fffe    ; Wait for vpos >= 0x78 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $786f,$fffe    ; Wait for vpos >= 0x78 and hpos >= 0x6e
	dc.w $0180,$0666    ; COLOR00 := $0666
	dc.w $0180,$0556    ; COLOR00 := $0556
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0fa9    ; COLOR00 := $0fa9
	dc.w $0180,$0f99    ; COLOR00 := $0f99
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7897,$fffe    ; Wait for vpos >= 0x78 and hpos >= 0x96
	dc.w $0180,$0ab2    ; COLOR00 := $0ab2
	dc.w $0180,$09a2    ; COLOR00 := $09a2
	dc.w $0180,$0e90    ; COLOR00 := $0e90
	dc.w $0180,$0c72    ; COLOR00 := $0c72
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $793f,$fffe    ; Wait for vpos >= 0x79 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $796f,$fffe    ; Wait for vpos >= 0x79 and hpos >= 0x6e
	dc.w $0180,$0666    ; COLOR00 := $0666
	dc.w $0180,$0556    ; COLOR00 := $0556
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0d87    ; COLOR00 := $0d87
	dc.w $0180,$0c77    ; COLOR00 := $0c77
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7997,$fffe    ; Wait for vpos >= 0x79 and hpos >= 0x96
	dc.w $0180,$0ab2    ; COLOR00 := $0ab2
	dc.w $0180,$09a2    ; COLOR00 := $09a2
	dc.w $0180,$0e90    ; COLOR00 := $0e90
	dc.w $0180,$0c72    ; COLOR00 := $0c72
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7a3f,$fffe    ; Wait for vpos >= 0x7a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7a6f,$fffe    ; Wait for vpos >= 0x7a and hpos >= 0x6e
	dc.w $0180,$0666    ; COLOR00 := $0666
	dc.w $0180,$0556    ; COLOR00 := $0556
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$0fa9    ; COLOR00 := $0fa9
	dc.w $0180,$0f99    ; COLOR00 := $0f99
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7a97,$fffe    ; Wait for vpos >= 0x7a and hpos >= 0x96
	dc.w $0180,$0ab2    ; COLOR00 := $0ab2
	dc.w $0180,$09a2    ; COLOR00 := $09a2
	dc.w $0180,$0e90    ; COLOR00 := $0e90
	dc.w $0180,$0c72    ; COLOR00 := $0c72
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7b3f,$fffe    ; Wait for vpos >= 0x7b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7b6f,$fffe    ; Wait for vpos >= 0x7b and hpos >= 0x6e
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7b97,$fffe    ; Wait for vpos >= 0x7b and hpos >= 0x96
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7c3f,$fffe    ; Wait for vpos >= 0x7c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7c77,$fffe    ; Wait for vpos >= 0x7c and hpos >= 0x76
	dc.w $0180,$0c26    ; COLOR00 := $0c26
	dc.w $0180,$0d16    ; COLOR00 := $0d16
	dc.w $0180,$0c7a    ; COLOR00 := $0c7a
	dc.w $0180,$0d6a    ; COLOR00 := $0d6a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7c9f,$fffe    ; Wait for vpos >= 0x7c and hpos >= 0x9e
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7d3f,$fffe    ; Wait for vpos >= 0x7d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7d77,$fffe    ; Wait for vpos >= 0x7d and hpos >= 0x76
	dc.w $0180,$0a04    ; COLOR00 := $0a04
	dc.w $0180,$0904    ; COLOR00 := $0904
	dc.w $0180,$0a58    ; COLOR00 := $0a58
	dc.w $0180,$0948    ; COLOR00 := $0948
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7d9f,$fffe    ; Wait for vpos >= 0x7d and hpos >= 0x9e
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7e3f,$fffe    ; Wait for vpos >= 0x7e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7e77,$fffe    ; Wait for vpos >= 0x7e and hpos >= 0x76
	dc.w $0180,$0c26    ; COLOR00 := $0c26
	dc.w $0180,$0d16    ; COLOR00 := $0d16
	dc.w $0180,$0c7a    ; COLOR00 := $0c7a
	dc.w $0180,$0d6a    ; COLOR00 := $0d6a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7e9f,$fffe    ; Wait for vpos >= 0x7e and hpos >= 0x9e
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7f3f,$fffe    ; Wait for vpos >= 0x7f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7f77,$fffe    ; Wait for vpos >= 0x7f and hpos >= 0x76
	dc.w $0180,$0a04    ; COLOR00 := $0a04
	dc.w $0180,$0904    ; COLOR00 := $0904
	dc.w $0180,$0a58    ; COLOR00 := $0a58
	dc.w $0180,$0948    ; COLOR00 := $0948
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $7f9f,$fffe    ; Wait for vpos >= 0x7f and hpos >= 0x9e
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $803f,$fffe    ; Wait for vpos >= 0x80 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8077,$fffe    ; Wait for vpos >= 0x80 and hpos >= 0x76
	dc.w $0180,$0c26    ; COLOR00 := $0c26
	dc.w $0180,$0d16    ; COLOR00 := $0d16
	dc.w $0180,$0c7a    ; COLOR00 := $0c7a
	dc.w $0180,$0d6a    ; COLOR00 := $0d6a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $809f,$fffe    ; Wait for vpos >= 0x80 and hpos >= 0x9e
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $813f,$fffe    ; Wait for vpos >= 0x81 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8177,$fffe    ; Wait for vpos >= 0x81 and hpos >= 0x76
	dc.w $0180,$0a04    ; COLOR00 := $0a04
	dc.w $0180,$0904    ; COLOR00 := $0904
	dc.w $0180,$0a58    ; COLOR00 := $0a58
	dc.w $0180,$0948    ; COLOR00 := $0948
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $819f,$fffe    ; Wait for vpos >= 0x81 and hpos >= 0x9e
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $823f,$fffe    ; Wait for vpos >= 0x82 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8277,$fffe    ; Wait for vpos >= 0x82 and hpos >= 0x76
	dc.w $0180,$0c26    ; COLOR00 := $0c26
	dc.w $0180,$0d16    ; COLOR00 := $0d16
	dc.w $0180,$0c7a    ; COLOR00 := $0c7a
	dc.w $0180,$0d6a    ; COLOR00 := $0d6a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $829f,$fffe    ; Wait for vpos >= 0x82 and hpos >= 0x9e
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $833f,$fffe    ; Wait for vpos >= 0x83 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8377,$fffe    ; Wait for vpos >= 0x83 and hpos >= 0x76
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $839f,$fffe    ; Wait for vpos >= 0x83 and hpos >= 0x9e
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $843f,$fffe    ; Wait for vpos >= 0x84 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $853f,$fffe    ; Wait for vpos >= 0x85 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $863f,$fffe    ; Wait for vpos >= 0x86 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $873f,$fffe    ; Wait for vpos >= 0x87 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $883f,$fffe    ; Wait for vpos >= 0x88 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $893f,$fffe    ; Wait for vpos >= 0x89 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8a3f,$fffe    ; Wait for vpos >= 0x8a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8b3f,$fffe    ; Wait for vpos >= 0x8b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8c3f,$fffe    ; Wait for vpos >= 0x8c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8d3f,$fffe    ; Wait for vpos >= 0x8d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8e3f,$fffe    ; Wait for vpos >= 0x8e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $8f3f,$fffe    ; Wait for vpos >= 0x8f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $903f,$fffe    ; Wait for vpos >= 0x90 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $913f,$fffe    ; Wait for vpos >= 0x91 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $923f,$fffe    ; Wait for vpos >= 0x92 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $933f,$fffe    ; Wait for vpos >= 0x93 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $943f,$fffe    ; Wait for vpos >= 0x94 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $953f,$fffe    ; Wait for vpos >= 0x95 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $963f,$fffe    ; Wait for vpos >= 0x96 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $973f,$fffe    ; Wait for vpos >= 0x97 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $983f,$fffe    ; Wait for vpos >= 0x98 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $993f,$fffe    ; Wait for vpos >= 0x99 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9a3f,$fffe    ; Wait for vpos >= 0x9a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9b3f,$fffe    ; Wait for vpos >= 0x9b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9c3f,$fffe    ; Wait for vpos >= 0x9c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9c97,$fffe    ; Wait for vpos >= 0x9c and hpos >= 0x96
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$099b    ; COLOR00 := $099b
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9d3f,$fffe    ; Wait for vpos >= 0x9d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9d97,$fffe    ; Wait for vpos >= 0x9d and hpos >= 0x96
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$099b    ; COLOR00 := $099b
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9e3f,$fffe    ; Wait for vpos >= 0x9e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9e97,$fffe    ; Wait for vpos >= 0x9e and hpos >= 0x96
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$099b    ; COLOR00 := $099b
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9f3f,$fffe    ; Wait for vpos >= 0x9f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $9f97,$fffe    ; Wait for vpos >= 0x9f and hpos >= 0x96
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$099b    ; COLOR00 := $099b
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a03f,$fffe    ; Wait for vpos >= 0xa0 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a097,$fffe    ; Wait for vpos >= 0xa0 and hpos >= 0x96
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$088a    ; COLOR00 := $088a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a13f,$fffe    ; Wait for vpos >= 0xa1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a197,$fffe    ; Wait for vpos >= 0xa1 and hpos >= 0x96
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$088a    ; COLOR00 := $088a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a23f,$fffe    ; Wait for vpos >= 0xa2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a297,$fffe    ; Wait for vpos >= 0xa2 and hpos >= 0x96
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$088a    ; COLOR00 := $088a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a33f,$fffe    ; Wait for vpos >= 0xa3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a397,$fffe    ; Wait for vpos >= 0xa3 and hpos >= 0x96
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a43f,$fffe    ; Wait for vpos >= 0xa4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a477,$fffe    ; Wait for vpos >= 0xa4 and hpos >= 0x76
	dc.w $0180,$066d    ; COLOR00 := $066d
	dc.w $0180,$066d    ; COLOR00 := $066d
	dc.w $0180,$0caa    ; COLOR00 := $0caa
	dc.w $0180,$0b9a    ; COLOR00 := $0b9a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0877    ; COLOR00 := $0877
	dc.w $0180,$0877    ; COLOR00 := $0877
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a53f,$fffe    ; Wait for vpos >= 0xa5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a577,$fffe    ; Wait for vpos >= 0xa5 and hpos >= 0x76
	dc.w $0180,$066d    ; COLOR00 := $066d
	dc.w $0180,$066d    ; COLOR00 := $066d
	dc.w $0180,$0caa    ; COLOR00 := $0caa
	dc.w $0180,$0b9a    ; COLOR00 := $0b9a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0888    ; COLOR00 := $0888
	dc.w $0180,$0888    ; COLOR00 := $0888
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a63f,$fffe    ; Wait for vpos >= 0xa6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a677,$fffe    ; Wait for vpos >= 0xa6 and hpos >= 0x76
	dc.w $0180,$066d    ; COLOR00 := $066d
	dc.w $0180,$066d    ; COLOR00 := $066d
	dc.w $0180,$0caa    ; COLOR00 := $0caa
	dc.w $0180,$0b9a    ; COLOR00 := $0b9a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0988    ; COLOR00 := $0988
	dc.w $0180,$0988    ; COLOR00 := $0988
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a73f,$fffe    ; Wait for vpos >= 0xa7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a777,$fffe    ; Wait for vpos >= 0xa7 and hpos >= 0x76
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$0caa    ; COLOR00 := $0caa
	dc.w $0180,$0b9a    ; COLOR00 := $0b9a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0999    ; COLOR00 := $0999
	dc.w $0180,$0999    ; COLOR00 := $0999
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a83f,$fffe    ; Wait for vpos >= 0xa8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a877,$fffe    ; Wait for vpos >= 0xa8 and hpos >= 0x76
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$0a88    ; COLOR00 := $0a88
	dc.w $0180,$0978    ; COLOR00 := $0978
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0667    ; COLOR00 := $0667
	dc.w $0180,$0667    ; COLOR00 := $0667
	dc.w $0180,$00e0    ; COLOR00 := $00e0
	dc.w $0180,$00c2    ; COLOR00 := $00c2
	dc.w $0180,$0e0f    ; COLOR00 := $0e0f
	dc.w $0180,$0c0e    ; COLOR00 := $0c0e
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a93f,$fffe    ; Wait for vpos >= 0xa9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $a977,$fffe    ; Wait for vpos >= 0xa9 and hpos >= 0x76
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$0a88    ; COLOR00 := $0a88
	dc.w $0180,$0978    ; COLOR00 := $0978
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$00e0    ; COLOR00 := $00e0
	dc.w $0180,$00c2    ; COLOR00 := $00c2
	dc.w $0180,$0e0f    ; COLOR00 := $0e0f
	dc.w $0180,$0c0e    ; COLOR00 := $0c0e
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $aa3f,$fffe    ; Wait for vpos >= 0xaa and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $aa77,$fffe    ; Wait for vpos >= 0xaa and hpos >= 0x76
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$033b    ; COLOR00 := $033b
	dc.w $0180,$0a88    ; COLOR00 := $0a88
	dc.w $0180,$0978    ; COLOR00 := $0978
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0445    ; COLOR00 := $0445
	dc.w $0180,$0445    ; COLOR00 := $0445
	dc.w $0180,$00e0    ; COLOR00 := $00e0
	dc.w $0180,$00c2    ; COLOR00 := $00c2
	dc.w $0180,$0e0f    ; COLOR00 := $0e0f
	dc.w $0180,$0c0e    ; COLOR00 := $0c0e
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ab3f,$fffe    ; Wait for vpos >= 0xab and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ab77,$fffe    ; Wait for vpos >= 0xab and hpos >= 0x76
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000			- SHOULD BE DONE HERE, now it should WAIT!!!

; Row 0xac is completely missing here. Should be see a WAIT $acd3,$fffe + gray->black
; Possibilities: Bug in copper extension code. Frame overrun. Other?

	dc.w $0180,$005f    ; COLOR00 := $005f
	dc.w $0180,$004f    ; COLOR00 := $004f
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0bbb    ; COLOR00 := $0bbb
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ad3f,$fffe    ; Wait for vpos >= 0xad and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ad7f,$fffe    ; Wait for vpos >= 0xad and hpos >= 0x7e
	dc.w $0180,$0711    ; COLOR00 := $0711
	dc.w $0180,$0711    ; COLOR00 := $0711
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$005f    ; COLOR00 := $005f
	dc.w $0180,$004f    ; COLOR00 := $004f
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0cbb    ; COLOR00 := $0cbb
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ae3f,$fffe    ; Wait for vpos >= 0xae and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ae7f,$fffe    ; Wait for vpos >= 0xae and hpos >= 0x7e
	dc.w $0180,$0811    ; COLOR00 := $0811
	dc.w $0180,$0811    ; COLOR00 := $0811
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$005f    ; COLOR00 := $005f
	dc.w $0180,$004f    ; COLOR00 := $004f
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0ccc    ; COLOR00 := $0ccc
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $af3f,$fffe    ; Wait for vpos >= 0xaf and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $af7f,$fffe    ; Wait for vpos >= 0xaf and hpos >= 0x7e
	dc.w $0180,$0911    ; COLOR00 := $0911
	dc.w $0180,$0911    ; COLOR00 := $0911
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$005f    ; COLOR00 := $005f
	dc.w $0180,$004f    ; COLOR00 := $004f
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0ddd    ; COLOR00 := $0ddd
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b03f,$fffe    ; Wait for vpos >= 0xb0 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b07f,$fffe    ; Wait for vpos >= 0xb0 and hpos >= 0x7e
	dc.w $0180,$0711    ; COLOR00 := $0711
	dc.w $0180,$0711    ; COLOR00 := $0711
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$004e    ; COLOR00 := $004e
	dc.w $0180,$003e    ; COLOR00 := $003e
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0bbc    ; COLOR00 := $0bbc
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b13f,$fffe    ; Wait for vpos >= 0xb1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b17f,$fffe    ; Wait for vpos >= 0xb1 and hpos >= 0x7e
	dc.w $0180,$0601    ; COLOR00 := $0601
	dc.w $0180,$0601    ; COLOR00 := $0601
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$004e    ; COLOR00 := $004e
	dc.w $0180,$003e    ; COLOR00 := $003e
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0aaa    ; COLOR00 := $0aaa
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b23f,$fffe    ; Wait for vpos >= 0xb2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b27f,$fffe    ; Wait for vpos >= 0xb2 and hpos >= 0x7e
	dc.w $0180,$0511    ; COLOR00 := $0511
	dc.w $0180,$0511    ; COLOR00 := $0511
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$004e    ; COLOR00 := $004e
	dc.w $0180,$003e    ; COLOR00 := $003e
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$099a    ; COLOR00 := $099a
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b33f,$fffe    ; Wait for vpos >= 0xb3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b37f,$fffe    ; Wait for vpos >= 0xb3 and hpos >= 0x7e
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b38f,$fffe    ; Wait for vpos >= 0xb3 and hpos >= 0x8e
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b43f,$fffe    ; Wait for vpos >= 0xb4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b53f,$fffe    ; Wait for vpos >= 0xb5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b63f,$fffe    ; Wait for vpos >= 0xb6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b73f,$fffe    ; Wait for vpos >= 0xb7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b83f,$fffe    ; Wait for vpos >= 0xb8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $b93f,$fffe    ; Wait for vpos >= 0xb9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ba3f,$fffe    ; Wait for vpos >= 0xba and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bb3f,$fffe    ; Wait for vpos >= 0xbb and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bc3f,$fffe    ; Wait for vpos >= 0xbc and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bcb7,$fffe    ; Wait for vpos >= 0xbc and hpos >= 0xb6
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bd3f,$fffe    ; Wait for vpos >= 0xbd and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bdb7,$fffe    ; Wait for vpos >= 0xbd and hpos >= 0xb6
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $be3f,$fffe    ; Wait for vpos >= 0xbe and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $beb7,$fffe    ; Wait for vpos >= 0xbe and hpos >= 0xb6
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bf3f,$fffe    ; Wait for vpos >= 0xbf and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $bfb7,$fffe    ; Wait for vpos >= 0xbf and hpos >= 0xb6
	dc.w $0180,$00f0    ; COLOR00 := $00f0
	dc.w $0180,$00d2    ; COLOR00 := $00d2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c03f,$fffe    ; Wait for vpos >= 0xc0 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c0b7,$fffe    ; Wait for vpos >= 0xc0 and hpos >= 0xb6
	dc.w $0180,$00e0    ; COLOR00 := $00e0
	dc.w $0180,$00c2    ; COLOR00 := $00c2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c13f,$fffe    ; Wait for vpos >= 0xc1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c1b7,$fffe    ; Wait for vpos >= 0xc1 and hpos >= 0xb6
	dc.w $0180,$00e0    ; COLOR00 := $00e0
	dc.w $0180,$00c2    ; COLOR00 := $00c2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c23f,$fffe    ; Wait for vpos >= 0xc2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c2b7,$fffe    ; Wait for vpos >= 0xc2 and hpos >= 0xb6
	dc.w $0180,$00e0    ; COLOR00 := $00e0
	dc.w $0180,$00c2    ; COLOR00 := $00c2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c33f,$fffe    ; Wait for vpos >= 0xc3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c3b7,$fffe    ; Wait for vpos >= 0xc3 and hpos >= 0xb6
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c43f,$fffe    ; Wait for vpos >= 0xc4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c4af,$fffe    ; Wait for vpos >= 0xc4 and hpos >= 0xae
	dc.w $0180,$0a00    ; COLOR00 := $0a00
	dc.w $0180,$0a00    ; COLOR00 := $0a00
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c53f,$fffe    ; Wait for vpos >= 0xc5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c5af,$fffe    ; Wait for vpos >= 0xc5 and hpos >= 0xae
	dc.w $0180,$0a00    ; COLOR00 := $0a00
	dc.w $0180,$0a00    ; COLOR00 := $0a00
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c63f,$fffe    ; Wait for vpos >= 0xc6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c6af,$fffe    ; Wait for vpos >= 0xc6 and hpos >= 0xae
	dc.w $0180,$0a00    ; COLOR00 := $0a00
	dc.w $0180,$0a00    ; COLOR00 := $0a00
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c73f,$fffe    ; Wait for vpos >= 0xc7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c7af,$fffe    ; Wait for vpos >= 0xc7 and hpos >= 0xae
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0f0f    ; COLOR00 := $0f0f
	dc.w $0180,$0d0f    ; COLOR00 := $0d0f
	dc.w $0180,$00ff    ; COLOR00 := $00ff
	dc.w $0180,$00df    ; COLOR00 := $00df
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c83f,$fffe    ; Wait for vpos >= 0xc8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c8af,$fffe    ; Wait for vpos >= 0xc8 and hpos >= 0xae
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0e0f    ; COLOR00 := $0e0f
	dc.w $0180,$0c0e    ; COLOR00 := $0c0e
	dc.w $0180,$00ee    ; COLOR00 := $00ee
	dc.w $0180,$00cf    ; COLOR00 := $00cf
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c93f,$fffe    ; Wait for vpos >= 0xc9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $c9af,$fffe    ; Wait for vpos >= 0xc9 and hpos >= 0xae
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0e0f    ; COLOR00 := $0e0f
	dc.w $0180,$0c0e    ; COLOR00 := $0c0e
	dc.w $0180,$00ee    ; COLOR00 := $00ee
	dc.w $0180,$00cf    ; COLOR00 := $00cf
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ca3f,$fffe    ; Wait for vpos >= 0xca and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $caaf,$fffe    ; Wait for vpos >= 0xca and hpos >= 0xae
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0700    ; COLOR00 := $0700
	dc.w $0180,$0e0f    ; COLOR00 := $0e0f
	dc.w $0180,$0c0e    ; COLOR00 := $0c0e
	dc.w $0180,$00ee    ; COLOR00 := $00ee
	dc.w $0180,$00cf    ; COLOR00 := $00cf
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cb3f,$fffe    ; Wait for vpos >= 0xcb and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cbaf,$fffe    ; Wait for vpos >= 0xcb and hpos >= 0xae
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cc3f,$fffe    ; Wait for vpos >= 0xcc and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ccb7,$fffe    ; Wait for vpos >= 0xcc and hpos >= 0xb6
	dc.w $0180,$0ff0    ; COLOR00 := $0ff0
	dc.w $0180,$0dd2    ; COLOR00 := $0dd2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cd3f,$fffe    ; Wait for vpos >= 0xcd and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cdb7,$fffe    ; Wait for vpos >= 0xcd and hpos >= 0xb6
	dc.w $0180,$0ff0    ; COLOR00 := $0ff0
	dc.w $0180,$0dd2    ; COLOR00 := $0dd2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ce3f,$fffe    ; Wait for vpos >= 0xce and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ceb7,$fffe    ; Wait for vpos >= 0xce and hpos >= 0xb6
	dc.w $0180,$0ff0    ; COLOR00 := $0ff0
	dc.w $0180,$0dd2    ; COLOR00 := $0dd2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cf3f,$fffe    ; Wait for vpos >= 0xcf and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $cfb7,$fffe    ; Wait for vpos >= 0xcf and hpos >= 0xb6
	dc.w $0180,$0ff0    ; COLOR00 := $0ff0
	dc.w $0180,$0dd2    ; COLOR00 := $0dd2
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d03f,$fffe    ; Wait for vpos >= 0xd0 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d0b7,$fffe    ; Wait for vpos >= 0xd0 and hpos >= 0xb6
	dc.w $0180,$0ee0    ; COLOR00 := $0ee0
	dc.w $0180,$0cc3    ; COLOR00 := $0cc3
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d13f,$fffe    ; Wait for vpos >= 0xd1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d1b7,$fffe    ; Wait for vpos >= 0xd1 and hpos >= 0xb6
	dc.w $0180,$0ee0    ; COLOR00 := $0ee0
	dc.w $0180,$0cc3    ; COLOR00 := $0cc3
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d23f,$fffe    ; Wait for vpos >= 0xd2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d2b7,$fffe    ; Wait for vpos >= 0xd2 and hpos >= 0xb6
	dc.w $0180,$0ee0    ; COLOR00 := $0ee0
	dc.w $0180,$0cc3    ; COLOR00 := $0cc3
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d33f,$fffe    ; Wait for vpos >= 0xd3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d3b7,$fffe    ; Wait for vpos >= 0xd3 and hpos >= 0xb6
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0217    ; COLOR00 := $0217
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d43f,$fffe    ; Wait for vpos >= 0xd4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d53f,$fffe    ; Wait for vpos >= 0xd5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d63f,$fffe    ; Wait for vpos >= 0xd6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d73f,$fffe    ; Wait for vpos >= 0xd7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d83f,$fffe    ; Wait for vpos >= 0xd8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $d93f,$fffe    ; Wait for vpos >= 0xd9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $da3f,$fffe    ; Wait for vpos >= 0xda and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $db3f,$fffe    ; Wait for vpos >= 0xdb and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $dc3f,$fffe    ; Wait for vpos >= 0xdc and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $dd3f,$fffe    ; Wait for vpos >= 0xdd and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $de3f,$fffe    ; Wait for vpos >= 0xde and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $df3f,$fffe    ; Wait for vpos >= 0xdf and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e03f,$fffe    ; Wait for vpos >= 0xe0 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e13f,$fffe    ; Wait for vpos >= 0xe1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e23f,$fffe    ; Wait for vpos >= 0xe2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e33f,$fffe    ; Wait for vpos >= 0xe3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e43f,$fffe    ; Wait for vpos >= 0xe4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e53f,$fffe    ; Wait for vpos >= 0xe5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e63f,$fffe    ; Wait for vpos >= 0xe6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e73f,$fffe    ; Wait for vpos >= 0xe7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e83f,$fffe    ; Wait for vpos >= 0xe8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $e93f,$fffe    ; Wait for vpos >= 0xe9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ea3f,$fffe    ; Wait for vpos >= 0xea and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $eb3f,$fffe    ; Wait for vpos >= 0xeb and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ec3f,$fffe    ; Wait for vpos >= 0xec and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ed3f,$fffe    ; Wait for vpos >= 0xed and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ee3f,$fffe    ; Wait for vpos >= 0xee and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ef3f,$fffe    ; Wait for vpos >= 0xef and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f03f,$fffe    ; Wait for vpos >= 0xf0 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f13f,$fffe    ; Wait for vpos >= 0xf1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f23f,$fffe    ; Wait for vpos >= 0xf2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f33f,$fffe    ; Wait for vpos >= 0xf3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f43f,$fffe    ; Wait for vpos >= 0xf4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f53f,$fffe    ; Wait for vpos >= 0xf5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f63f,$fffe    ; Wait for vpos >= 0xf6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f73f,$fffe    ; Wait for vpos >= 0xf7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f83f,$fffe    ; Wait for vpos >= 0xf8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $f93f,$fffe    ; Wait for vpos >= 0xf9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $fa3f,$fffe    ; Wait for vpos >= 0xfa and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $fb3f,$fffe    ; Wait for vpos >= 0xfb and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $fc3f,$fffe    ; Wait for vpos >= 0xfc and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $fd3f,$fffe    ; Wait for vpos >= 0xfd and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $fe3f,$fffe    ; Wait for vpos >= 0xfe and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ff3f,$fffe    ; Wait for vpos >= 0xff and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ffdf,$fffe    ; Wait for vpos >= 0xff and hpos >= 0xde
	dc.w $003f,$fffe    ; Wait for hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $013f,$fffe    ; Wait for vpos >= 0x1 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $023f,$fffe    ; Wait for vpos >= 0x2 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $033f,$fffe    ; Wait for vpos >= 0x3 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $043f,$fffe    ; Wait for vpos >= 0x4 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $053f,$fffe    ; Wait for vpos >= 0x5 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $063f,$fffe    ; Wait for vpos >= 0x6 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $073f,$fffe    ; Wait for vpos >= 0x7 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $083f,$fffe    ; Wait for vpos >= 0x8 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $093f,$fffe    ; Wait for vpos >= 0x9 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0a3f,$fffe    ; Wait for vpos >= 0xa and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0b3f,$fffe    ; Wait for vpos >= 0xb and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0c3f,$fffe    ; Wait for vpos >= 0xc and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0d3f,$fffe    ; Wait for vpos >= 0xd and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0e3f,$fffe    ; Wait for vpos >= 0xe and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $0f3f,$fffe    ; Wait for vpos >= 0xf and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $103f,$fffe    ; Wait for vpos >= 0x10 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $113f,$fffe    ; Wait for vpos >= 0x11 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $123f,$fffe    ; Wait for vpos >= 0x12 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $133f,$fffe    ; Wait for vpos >= 0x13 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $143f,$fffe    ; Wait for vpos >= 0x14 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $14db,$fffe    ; Wait for vpos >= 0x14 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $153f,$fffe    ; Wait for vpos >= 0x15 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $15db,$fffe    ; Wait for vpos >= 0x15 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $163f,$fffe    ; Wait for vpos >= 0x16 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $16db,$fffe    ; Wait for vpos >= 0x16 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $173f,$fffe    ; Wait for vpos >= 0x17 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $17db,$fffe    ; Wait for vpos >= 0x17 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $183f,$fffe    ; Wait for vpos >= 0x18 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $18db,$fffe    ; Wait for vpos >= 0x18 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $193f,$fffe    ; Wait for vpos >= 0x19 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $19db,$fffe    ; Wait for vpos >= 0x19 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1a3f,$fffe    ; Wait for vpos >= 0x1a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1adb,$fffe    ; Wait for vpos >= 0x1a and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1b3f,$fffe    ; Wait for vpos >= 0x1b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1bdb,$fffe    ; Wait for vpos >= 0x1b and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1c3f,$fffe    ; Wait for vpos >= 0x1c and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1cdb,$fffe    ; Wait for vpos >= 0x1c and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1d3f,$fffe    ; Wait for vpos >= 0x1d and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1ddb,$fffe    ; Wait for vpos >= 0x1d and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1e3f,$fffe    ; Wait for vpos >= 0x1e and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1edb,$fffe    ; Wait for vpos >= 0x1e and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1f3f,$fffe    ; Wait for vpos >= 0x1f and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $1fdb,$fffe    ; Wait for vpos >= 0x1f and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $203f,$fffe    ; Wait for vpos >= 0x20 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $20db,$fffe    ; Wait for vpos >= 0x20 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $213f,$fffe    ; Wait for vpos >= 0x21 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $21db,$fffe    ; Wait for vpos >= 0x21 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $223f,$fffe    ; Wait for vpos >= 0x22 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $22db,$fffe    ; Wait for vpos >= 0x22 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $233f,$fffe    ; Wait for vpos >= 0x23 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $23db,$fffe    ; Wait for vpos >= 0x23 and hpos >= 0xda
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $243f,$fffe    ; Wait for vpos >= 0x24 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $253f,$fffe    ; Wait for vpos >= 0x25 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $263f,$fffe    ; Wait for vpos >= 0x26 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $273f,$fffe    ; Wait for vpos >= 0x27 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $283f,$fffe    ; Wait for vpos >= 0x28 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $293f,$fffe    ; Wait for vpos >= 0x29 and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $2a3f,$fffe    ; Wait for vpos >= 0x2a and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $2b3f,$fffe    ; Wait for vpos >= 0x2b and hpos >= 0x3e
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0555    ; COLOR00 := $0555
	dc.w $0180,$0000    ; COLOR00 := $0000
	dc.w $ffff,$fffe    ; End of CopperList