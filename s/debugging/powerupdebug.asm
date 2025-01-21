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
	tst.b	Player0Enabled
	bmi		.p1
	lea		Bat0,a1
	bsr		PwrStartGluebat
.p1
	tst.b	Player1Enabled
	bmi		.p2
	lea		Bat1,a1
	bsr		PwrStartGluebat
.p2
	tst.b	Player2Enabled
	bmi		.p3
	lea		Bat2,a1
	bsr		PwrStartGluebat
.p3
	tst.b	Player3Enabled
	bmi		.exit
	lea		Bat3,a1
	bsr		PwrStartGluebat
.exit
	rts