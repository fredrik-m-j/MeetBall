_LVOBltBitMap				=	-30
_LVOBltTemplate				=	-36
_LVOClearEOL				=	-42
_LVOClearScreen				=	-48
_LVOTextLength				=	-54
_LVOText					=	-60
_LVOSetFont					=	-66
_LVOOpenFont				=	-72
_LVOCloseFont				=	-78
_LVOAskSoftStyle			=	-84
_LVOSetSoftStyle			=	-90
_LVOAddBob					=	-96
_LVOAddVSprite				=	-102
_LVODoCollision				=	-108
_LVODrawGList				=	-114
_LVOInitGels				=	-120
_LVOInitMasks				=	-126
_LVORemIBob					=	-132
_LVORemVSprite				=	-138
_LVOSetCollision			=	-144
_LVOSortGList				=	-150
_LVOAddAnimOb				=	-156
_LVOAnimate					=	-162
_LVOGetGBuffers				=	-168
_LVOInitGMasks				=	-174
_LVODrawEllipse				=	-180
_LVOAreaEllipse				=	-186
_LVOLoadRGB4				=	-192
_LVOInitRastPort			=	-198
_LVOInitVPort				=	-204
_LVOMrgCop					=	-210
_LVOMakeVPort				=	-216
_LVOLoadView				=	-222
_LVOWaitBlit				=	-228
_LVOSetRast					=	-234
_LVOMove					=	-240
_LVODraw					=	-246
_LVOAreaMove				=	-252
_LVOAreaDraw				=	-258
_LVOAreaEnd					=	-264
_LVOWaitTOF					=	-270
_LVOQBlit					=	-276
_LVOInitArea				=	-282
_LVOSetRGB4					=	-288
_LVOQBSBlit					=	-294
_LVOBltClear				=	-300
_LVORectFill				=	-306
_LVOBltPattern				=	-312
_LVOReadPixel				=	-318
_LVOWritePixel				=	-324
_LVOFlood					=	-330
_LVOPolyDraw				=	-336
_LVOSetAPen					=	-342
_LVOSetBPen					=	-348
_LVOSetDrMd					=	-354
_LVOInitView				=	-360
_LVOCBump					=	-366
_LVOCMove					=	-372
_LVOCWait					=	-378
_LVOVBeamPos				=	-384
_LVOInitBitMap				=	-390
_LVOScrollRaster			=	-396
_LVOWaitBOVP				=	-402
_LVOGetSprite				=	-408
_LVOFreeSprite				=	-414
_LVOChangeSprite			=	-420
_LVOMoveSprite				=	-426
_LVOLockLayerRom			=	-432
_LVOUnlockLayerRom			=	-438
_LVOSyncSBitMap				=	-444
_LVOCopySBitMap				=	-450
_LVOOwnBlitter				=	-456
_LVODisownBlitter			=	-462
_LVOInitTmpRas				=	-468
_LVOAskFont					=	-474
_LVOAddFont					=	-480
_LVORemFont					=	-486
_LVOAllocRaster				=	-492
_LVOFreeRaster				=	-498
_LVOAndRectRegion			=	-504
_LVOOrRectRegion			=	-510
_LVONewRegion				=	-516
_LVOClearRectRegion			=	-522
_LVOClearRegion				=	-528
_LVODisposeRegion			=	-534
_LVOFreeVPortCopLists		=	-540
_LVOFreeCopList				=	-546
_LVOClipBlit				=	-552
_LVOXorRectRegion			=	-558
_LVOFreeCprList				=	-564
_LVOGetColorMap				=	-570
_LVOFreeColorMap			=	-576
_LVOGetRGB4					=	-582
_LVOScrollVPort				=	-588
_LVOUCopperListInit			=	-594
_LVOFreeGBuffers			=	-600
_LVOBltBitMapRastPort		=	-606
_LVOOrRegionRegion			=	-612
_LVOXorRegionRegion			=	-618
_LVOAndRegionRegion			=	-624
_LVOSetRGB4CM				=	-630
_LVOBltMaskBitMapRastPort	=	-636
_LVOGraphicsReserved1		=	-642
_LVOGraphicsReserved2		=	-648
_LVOAttemptLockLayerRom		=	-654
CALLGRAF	MACRO
	MOVE.L	_GfxBase,A6
	JSR		_LVO\1(A6)
	ENDM
GRAFNAME	MACRO
	DC.B	'graphics.library',0
	ENDM