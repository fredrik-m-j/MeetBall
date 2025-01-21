DebugCheckAddPowerup:
	tst.b	KEYARRAY+KEY_I
	beq		.g
	clr.b	KEYARRAY+KEY_I
	bsr		PwrStartInsanoballz
.g
	tst.b	KEYARRAY+KEY_G
	beq		.exit
	clr.b	KEYARRAY+KEY_G
	bsr		DebugGlueBats
.exit
	rts

DebugGlueBats:
	lea		Bat0,a1
	bsr		PwrStartGluebat
	lea		Bat1,a1
	bsr		PwrStartGluebat
	lea		Bat2,a1
	bsr		PwrStartGluebat
	lea		Bat3,a1
	bsr		PwrStartGluebat
	rts