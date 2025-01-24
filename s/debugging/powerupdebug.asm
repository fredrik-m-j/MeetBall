DebugCheckAddPowerup:
	tst.b	KeyArray+KEY_I
	beq		.g
	clr.b	KeyArray+KEY_I
	bsr		PwrStartInsanoballz
.g
	tst.b	KeyArray+KEY_G
	beq		.p
	clr.b	KeyArray+KEY_G
	bsr		DebugGlueBats
.p
	tst.b	KeyArray+KEY_P
	beq		.exit
	clr.b	KeyArray+KEY_P
	bsr		PwrDebugGun
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

PwrDebugGun:
	tst.b	Player0Enabled
	bmi		.p1
	lea		Bat0,a1
	bsr		PwrGun
.p1
	tst.b	Player1Enabled
	bmi		.p2
	lea		Bat1,a1
	bsr		PwrGun
.p2
	tst.b	Player2Enabled
	bmi		.p3
	lea		Bat2,a1
	bsr		PwrGun
.p3
	tst.b	Player3Enabled
	bmi		.exit
	lea		Bat3,a1
	bsr		PwrGun
.exit
	rts