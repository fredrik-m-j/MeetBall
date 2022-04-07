	IFND	INTUITION_INTUITION_I
INTUITION_INTUITION_I	=	1
	IFND	EXEC_TYPES_I
	INCLUDE	exec/types.i
	ENDC
	IFND	GRAPHICS_GFX_I
	INCLUDE	graphics/gfx.i
	ENDC
	IFND	GRAPHICS_CLIP_I
	INCLUDE	graphics/clip.i
	ENDC
	IFND	GRAPHICS_VIEW_I
	INCLUDE	graphics/view.i
	ENDC
	IFND	GRAPHICS_RASTPORT_I
	INCLUDE	graphics/rastport.i
	ENDC
	IFND	GRAPHICS_LAYERS_I
	INCLUDE	graphics/layers.i
	ENDC
	IFND	GRAPHICS_TEXT_I
	INCLUDE	graphics/text.i
	ENDC
	IFND	EXEC_PORTS_I
	INCLUDE	exec/ports.i
	ENDC
	IFND	DEVICES_TIMER_I
	INCLUDE	devices/timer.i
	ENDC
	IFND	DEVICES_INPUTEVENT_I
	INCLUDE	devices/inputevent.i
	ENDC
	RSRESET
Menu		RS.B	0
mu_NextMenu	RS.L	1
mu_LeftEdge	RS.W	1
mu_TopEdge	RS.W	1
mu_Width	RS.W	1
mu_Height	RS.W	1
mu_Flags	RS.W	1
mu_MenuName	RS.L	1
mu_FirstItem	RS.L	1
mu_JazzX	RS.W	1
mu_JazzY	RS.W	1
mu_BeatX	RS.W	1
mu_BeatY	RS.W	1
mu_SIZEOF	RS.W	0
MENUENABLED	=	$0001
MIDRAWN		=	$0100
	RSRESET
MenuItem	RS.B	0
mi_NextItem	RS.L	1
mi_LeftEdge	RS.W	1
mi_TopEdge	RS.W	1
mi_Width	RS.W	1
mi_Height	RS.W	1
mi_Flags	RS.W	1
mi_MutualExclude RS.L	1
mi_ItemFill	RS.L	1
mi_SelectFill	RS.L	1
mi_Command	RS.B	1
mi_KludgeFill00	RS.B	1
mi_SubItem	RS.L	1
mi_NextSelect	RS.W	1
mi_SIZEOF	RS.W	0
CHECKIT		=	$0001
ITEMTEXT	=	$0002
COMMSEQ		=	$0004
MENUTOGGLE	=	$0008
ITEMENABLED	=	$0010
HIGHFLAGS	=	$00C0
HIGHIMAGE	=	$0000
HIGHCOMP	=	$0040
HIGHBOX		=	$0080
HIGHNONE	=	$00C0
CHECKED		=	$0100
ISDRAWN		=	$1000
HIGHITEM	=	$2000
MENUTOGGLED	=	$4000
	RSRESET
Requester	RS.B	0
rq_OlderRequest	RS.L	1
rq_LeftEdge	RS.W	1
rq_TopEdge	RS.W	1
rq_Width	RS.W	1
rq_Height	RS.W	1
rq_RelLeft	RS.W	1
rq_RelTop	RS.W	1
rq_ReqGadget	RS.L	1
rq_ReqBorder	RS.L	1
rq_ReqText	RS.L	1
rq_Flags	RS.W	1
rq_BackFill	RS.B	1
rq_KludgeFill00	RS.B	1
rq_ReqLayer	RS.L	1
rq_ReqPad1	RS.B	32
rq_ImageBMap	RS.L	1
rq_RWindow	RS.L	1
rq_ReqPad2	RS.B	36
rq_SIZEOF	RS.W	0
POINTREL	=	$0001
PREDRAWN	=	$0002
NOISYREQ	=	$0004
REQOFFWINDOW	=	$1000
REQACTIVE	=	$2000
SYSREQUEST	=	$4000
DEFERREFRESH	=	$8000
	RSRESET
Gadget		RS.B	0
gg_NextGadget	RS.L	1
gg_LeftEdge	RS.W	1
gg_TopEdge	RS.W	1
gg_Width	RS.W	1
gg_Height	RS.W	1
gg_Flags	RS.W	1
gg_Activation	RS.W	1
gg_GadgetType	RS.W	1
gg_GadgetRender	RS.L	1
gg_SelectRender	RS.L	1
gg_GadgetText	RS.L	1
gg_MutualExclude RS.L	1
gg_SpecialInfo	RS.L	1
gg_GadgetID	RS.W	1
gg_UserData	RS.L	1
gg_SIZEOF	RS.W	0
GADGHIGHBITS	=	$0003
GADGHCOMP	=	$0000
GADGHBOX	=	$0001
GADGHIMAGE	=	$0002
GADGHNONE	=	$0003
GADGIMAGE	=	$0004
GRELBOTTOM	=	$0008
GRELRIGHT	=	$0010
GRELWIDTH	=	$0020
GRELHEIGHT	=	$0040
SELECTED	=	$0080
GADGDISABLED	=	$0100
RELVERIFY	=	$0001
GADGIMMEDIATE	=	$0002
ENDGADGET	=	$0004
FOLLOWMOUSE	=	$0008
RIGHTBORDER	=	$0010
LEFTBORDER	=	$0020
TOPBORDER	=	$0040
BOTTOMBORDER	=	$0080
TOGGLESELECT	=	$0100
STRINGCENTER	=	$0200
STRINGRIGHT	=	$0400
LONGINT		=	$0800
ALTKEYMAP	=	$1000
BOOLEXTEND	=	$2000
GADGETTYPE	=	$FC00
SYSGADGET	=	$8000
SCRGADGET	=	$4000
GZZGADGET	=	$2000
REQGADGET	=	$1000
SIZING		=	$0010
WDRAGGING	=	$0020
SDRAGGING	=	$0030
WUPFRONT	=	$0040
SUPFRONT	=	$0050
WDOWNBACK	=	$0060
SDOWNBACK	=	$0070
CLOSE		=	$0080
BOOLGADGET	=	$0001
GADGET0002	=	$0002
PROPGADGET	=	$0003
STRGADGET	=	$0004
	RSRESET
BoolInfo	RS.B	0
bi_Flags	RS.W	1
bi_Mask		RS.L	1
bi_Reserved	RS.L	1
bi_SIZEOF	RS.W	0
BOOLMASK	=	$0001
	RSRESET
PropInfo	RS.B	0
pi_Flags	RS.W	1
pi_HorizPot	RS.W	1
pi_VertPot	RS.W	1
pi_HorizBody	RS.W	1
pi_VertBody	RS.W	1
pi_CWidth	RS.W	1
pi_CHeight	RS.W	1
pi_HPotRes	RS.W	1
pi_VPotRes	RS.W	1
pi_LeftBorder	RS.W	1
pi_TopBorder	RS.W	1
pi_SIZEOF	RS.W	0
AUTOKNOB	=	$0001
FREEHORIZ	=	$0002
FREEVERT	=	$0004
PROPBORDERLESS	=	$0008
KNOBHIT		=	$0100
KNOBHMIN	=	6
KNOBVMIN	=	4
MAXBODY		=	$FFFF
MAXPOT		=	$FFFF
	RSRESET
StringInfo	RS.B	0
si_Buffer	RS.L	1
si_UndoBuffer	RS.L	1
si_BufferPos	RS.W	1
si_MaxChars	RS.W	1
si_DispPos	RS.W	1
si_UndoPos	RS.W	1
si_NumChars	RS.W	1
si_DispCount	RS.W	1
si_CLeft	RS.W	1
si_CTop		RS.W	1
si_LayerPtr	RS.L	1
si_LongInt	RS.L	1
si_AltKeyMap	RS.L	1
si_SIZEOF	RS.W	0
	RSRESET
IntuiText	RS.B	0
it_FrontPen	RS.B	1
it_BackPen	RS.B	1
it_DrawMode	RS.B	1
it_KludgeFill00	RS.B	1
it_LeftEdge	RS.W	1
it_TopEdge	RS.W	1
it_ITextFont	RS.L	1
it_IText	RS.L	1
it_NextText	RS.L	1
it_SIZEOF	RS.W	0
	RSRESET
Border		RS.B	0
bd_LeftEdge	RS.W	1
bd_TopEdge	RS.W	1
bd_FrontPen	RS.B	1
bd_BackPen	RS.B	1
bd_DrawMode	RS.B	1
bd_Count	RS.B	1
bd_XY		RS.L	1
bd_NextBorder	RS.L	1
bd_SIZEOF	RS.W	0
	RSRESET
Image		RS.B	0
ig_LeftEdge	RS.W	1
ig_TopEdge	RS.W	1
ig_Width	RS.W	1
ig_Height	RS.W	1
ig_Depth	RS.W	1
ig_ImageData	RS.L	1
ig_PlanePick	RS.B	1
ig_PlaneOnOff	RS.B	1
ig_NextImage	RS.L	1
ig_SIZEOF	RS.W	0
	RSRESET
IntuiMessage	RS.B	0
im_ExecMessage	RS.B	MN_SIZE
im_Class	RS.L	1
im_Code		RS.W	1
im_Qualifier	RS.W	1
im_IAddress	RS.L	1
im_MouseX	RS.W	1
im_MouseY	RS.W	1
im_Seconds	RS.L	1
im_Micros	RS.L	1
im_IDCMPWindow	RS.L	1
im_SpecialLink	RS.L	1
im_SIZEOF	RS.W	0
SIZEVERIFY	=	$00000001
NEWSIZE		=	$00000002
REFRESHWINDOW	=	$00000004
MOUSEBUTTONS	=	$00000008
MOUSEMOVE	=	$00000010
GADGETDOWN	=	$00000020
GADGETUP	=	$00000040
REQSET		=	$00000080
MENUPICK	=	$00000100
CLOSEWINDOW	=	$00000200
RAWKEY		=	$00000400
REQVERIFY	=	$00000800
REQCLEAR	=	$00001000
MENUVERIFY	=	$00002000
NEWPREFS	=	$00004000
DISKINSERTED	=	$00008000
DISKREMOVED	=	$00010000
WBENCHMESSAGE	=	$00020000
ACTIVEWINDOW	=	$00040000
INACTIVEWINDOW	=	$00080000
DELTAMOVE	=	$00100000
VANILLAKEY	=	$00200000
INTUITICKS	=	$00400000
LONELYMESSAGE	=	$80000000
MENUHOT		=	$0001
MENUCANCEL	=	$0002
MENUWAITING	=	$0003
OKOK		=	MENUHOT
OKABORT		=	$0004
OKCANCEL	=	MENUCANCEL
WBENCHOPEN	=	$0001
WBENCHCLOSE	=	$0002
	RSRESET
Window		RS.B	0
wd_NextWindow	RS.L	1
wd_LeftEdge	RS.W	1
wd_TopEdge	RS.W	1
wd_Width	RS.W	1
wd_Height	RS.W	1
wd_MouseY	RS.W	1
wd_MouseX	RS.W	1
wd_MinWidth	RS.W	1
wd_MinHeight	RS.W	1
wd_MaxWidth	RS.W	1
wd_MaxHeight	RS.W	1
wd_Flags	RS.L	1
wd_MenuStrip	RS.L	1
wd_Title	RS.L	1
wd_FirstRequest	RS.L	1
wd_DMRequest	RS.L	1
wd_ReqCount	RS.W	1
wd_WScreen	RS.L	1
wd_RPort	RS.L	1
wd_BorderLeft	RS.B	1
wd_BorderTop	RS.B	1
wd_BorderRight	RS.B	1
wd_BorderBottom	RS.B	1
wd_BorderRPort	RS.L	1
wd_FirstGadget	RS.L	1
wd_Parent	RS.L	1
wd_Descendant	RS.L	1
wd_Pointer	RS.L	1
wd_PtrHeight	RS.B	1
wd_PtrWidth	RS.B	1
wd_XOffset	RS.B	1
wd_YOffset	RS.B	1
wd_IDCMPFlags	RS.L	1
wd_UserPort	RS.L	1
wd_WindowPort	RS.L	1
wd_MessageKey	RS.L	1
wd_DetailPen	RS.B	1
wd_BlockPen	RS.B	1
wd_CheckMark	RS.L	1
wd_ScreenTitle	RS.L	1
wd_GZZMouseX	RS.W	1
wd_GZZMouseY	RS.W	1
wd_GZZWidth	RS.W	1
wd_GZZHeight	RS.W	1
wd_ExtData	RS.L	1
wd_UserData	RS.L	1
wd_WLayer	RS.L	1
IFont		RS.L	1
wd_Size		RS.W	0
WINDOWSIZING	=	$0001
WINDOWDRAG	=	$0002
WINDOWDEPTH	=	$0004
WINDOWCLOSE	=	$0008
SIZEBRIGHT	=	$0010
SIZEBBOTTOM	=	$0020
REFRESHBITS	=	$00C0
SMART_REFRESH	=	$0000
SIMPLE_REFRESH	=	$0040
SUPER_BITMAP	=	$0080
OTHER_REFRESH	=	$00C0
BACKDROP	=	$0100
REPORTMOUSE	=	$0200
GIMMEZEROZERO	=	$0400
BORDERLESS	=	$0800
ACTIVATE	=	$1000
WINDOWACTIVE	=	$2000
INREQUEST	=	$4000
MENUSTATE	=	$8000
RMBTRAP		=	$00010000
NOCAREREFRESH	=	$00020000
WINDOWREFRESH	=	$01000000
WBENCHWINDOW	=	$02000000
WINDOWTICKED	=	$04000000
SUPER_UNUSED	=	$FCFC0000
	RSRESET
NewWindow	RS.B	0
nw_LeftEdge	RS.W	1
nw_TopEdge	RS.W	1
nw_Width	RS.W	1
nw_Height	RS.W	1
nw_DetailPen	RS.B	1
nw_BlockPen	RS.B	1
nw_IDCMPFlags	RS.L	1
nw_Flags	RS.L	1
nw_FirstGadget	RS.L	1
nw_CheckMark	RS.L	1
nw_Title	RS.L	1
nw_Screen	RS.L	1
nw_BitMap	RS.L	1
nw_MinWidth	RS.W	1
nw_MinHeight	RS.W	1
nw_MaxWidth	RS.W	1
nw_MaxHeight	RS.W	1
nw_Type		RS.W	1
nw_SIZE		RS.W	0
	RSRESET
Screen		RS.B	0
sc_NextScreen	RS.L	1
sc_FirstWindow	RS.L	1
sc_LeftEdge	RS.W	1
sc_TopEdge	RS.W	1
sc_Width	RS.W	1
sc_Height	RS.W	1
sc_MouseY	RS.W	1
sc_MouseX	RS.W	1
sc_Flags	RS.W	1
sc_Title	RS.L	1
sc_DefaultTitle	RS.L	1
sc_BarHeight	RS.B	1
sc_BarVBorder	RS.B	1
sc_BarHBorder	RS.B	1
sc_MenuVBorder	RS.B	1
sc_MenuHBorder	RS.B	1
sc_WBorTop	RS.B	1
sc_WBorLeft	RS.B	1
sc_WBorRight	RS.B	1
sc_WBorBottom	RS.B	1
sc_KludgeFill00	RS.B	1
sc_Font		RS.L	1
sc_ViewPort	RS.B	vp_SIZEOF
sc_RastPort	RS.B	rp_SIZEOF
sc_BitMap	RS.B	bm_SIZEOF
sc_LayerInfo	RS.B	li_SIZEOF
sc_FirstGadget	RS.L	1
sc_DetailPen	RS.B	1
sc_BlockPen	RS.B	1
sc_SaveColor0	RS.W	1
sc_BarLayer	RS.L	1
sc_ExtData	RS.L	1
sc_UserData	RS.L	1
sc_SIZEOF	RS.W	0
SCREENTYPE	=	$000F
WBENCHSCREEN	=	$0001
CUSTOMSCREEN	=	$000F
SHOWTITLE	=	$0010
BEEPING		=	$0020
CUSTOMBITMAP	=	$0040
SCREENBEHIND	=	$0080
SCREENQUIET	=	$0100
STDSCREENHEIGHT	=	-1
	RSRESET
NewScreen	RS.B	0
ns_LeftEdge	RS.W	1
ns_TopEdge	RS.W	1
ns_Width	RS.W	1
ns_Height	RS.W	1
ns_Depth	RS.W	1
ns_DetailPen	RS.B	1
ns_BlockPen	RS.B	1
ns_ViewModes	RS.W	1
ns_Type		RS.W	1
ns_Font		RS.L	1
ns_DefaultTitle	RS.L	1
ns_Gadgets	RS.L	1
ns_CustomBitMap	RS.L	1
ns_SIZEOF	RS.W	0
FILENAME_SIZE	=	30
POINTERSIZE	=	[1+16+1]*2
TOPAZ_EIGHTY	=	8
TOPAZ_SIXTY	=	9
	RSRESET
Preferences	RS.B	0
pf_FontHeight	RS.B	1
pf_PrinterPort	RS.B	1
pf_BaudRate	RS.W	1
pf_KeyRptSpeed	RS.B	TV_SIZE
pf_KeyRptDelay	RS.B	TV_SIZE
pf_DoubleClick	RS.B	TV_SIZE
pf_PointerMatrix	RS.B	POINTERSIZE*2
pf_XOffset	RS.B	1
pf_YOffset	RS.B	1
pf_color17	RS.W	1
pf_color18	RS.W	1
pf_color19	RS.W	1
pf_PointerTicks	RS.W	1
pf_color0	RS.W	1
pf_color1	RS.W	1
pf_color2	RS.W	1
pf_color3	RS.W	1
pf_ViewXOffset	RS.B	1
pf_ViewYOffset	RS.B	1
pf_ViewInitX	RS.W	1
pf_ViewInitY	RS.W	1
EnableCLI	RS.W	1
pf_PrinterType	RS.W	1
pf_PrinterFilename	RS.B	FILENAME_SIZE
pf_PrintPitch	RS.W	1
pf_PrintQuality	RS.W	1
pf_PrintSpacing	RS.W	1
pf_PrintLeftMargin	RS.W	1
pf_PrintRightMargin	RS.W	1
pf_PrintImage	RS.W	1
pf_PrintAspect	RS.W	1
pf_PrintShade	RS.W	1
pf_PrintThreshold	RS.W	1
pf_PaperSize	RS.W	1
pf_PaperLength	RS.W	1
pf_PaperType	RS.W	1
pf_SerRWBits	RS.B	1
pf_SerStopBuf	RS.B	1
pf_SerParShk	RS.B	1
pf_LaceWB	RS.B	1
pf_WorkName	RS.B	FILENAME_SIZE
pf_padding	RS.B	16
pf_SIZEOF	RS.W	0
LACEWB		=	$01
PARALLEL_PRINTER=	$00
SERIAL_PRINTER	=	$01
BAUD_110	=	$00
BAUD_300	=	$01
BAUD_1200	=	$02
BAUD_2400	=	$03
BAUD_4800	=	$04
BAUD_9600	=	$05
BAUD_19200	=	$06
BAUD_MIDI	=	$07
FANFOLD	=	$00
SINGLE	=	$80
PICA	=	$000
ELITE	=	$400
FINE	=	$800
DRAFT	=	$000
LETTER	=	$100
SIX_LPI	=	$000
EIGHT_LPI	=	$200
IMAGE_POSITIVE	=	$00
IMAGE_NEGATIVE	=	$01
ASPECT_HORIZ	=	$00
ASPECT_VERT	=	$01
SHADE_BW	=	$00
SHADE_GREYSCALE	=	$01
SHADE_COLOR	=	$02
US_LETTER	=	$00
US_LEGAL	=	$10
N_TRACTOR	=	$20
W_TRACTOR	=	$30
CUSTOM		=	$40
CUSTOM_NAME	=	$00
ALPHA_P_101	=	$01
BROTHER_15XL	=	$02
CBM_MPS1000	=	$03
DIAB_630	=	$04
DIAB_ADV_D25	=	$05
DIAB_C_150	=	$06
EPSON		=	$07
EPSON_JX_80	=	$08
OKIMATE_20	=	$09
QUME_LP_20	=	$0A
HP_LASERJET	=	$0B
HP_LASERJET_PLUS=	$0C
SBUF_512	=	$00
SBUF_1024	=	$01
SBUF_2048	=	$02
SBUF_4096	=	$03
SBUF_8000	=	$04
SBUF_16000	=	$05
SREAD_BITS	=	$F0
SWRITE_BITS	=	$0F
SSTOP_BITS	=	$F0
SBUFSIZE_BITS	=	$0F
SPARITY_BITS	=	$F0
SHSHAKE_BITS	=	$0F
SPARITY_NONE	=	$00
SPARITY_EVEN	=	$01
SPARITY_ODD	=	$02
SHSHAKE_XON	=	$00
SHSHAKE_RTS	=	$01
SHSHAKE_NONE	=	$02
	RSRESET
Remember	RS.B	0
rm_NextRemember	RS.L	1
rm_RememberSize	RS.L	1
rm_Memory	RS.L	1
rm_SIZEOF	RS.W	0
NOMENU		=	$001F
NOITEM		=	$003F
NOSUB		=	$001F
MENUNULL	=	$FFFF
CHECKWIDTH	=	19
COMMWIDTH	=	27
LOWCHECKWIDTH	=	13
LOWCOMMWIDTH	=	16
ALERT_TYPE	=	$80000000
RECOVERY_ALERT	=	$00000000
DEADEND_ALERT	=	$80000000
AUTOFRONTPEN	=	0
AUTOBACKPEN	=	1
AUTODRAWMODE	=	RP_JAM2
AUTOLEFTEDGE	=	6
AUTOTOPEDGE	=	3
AUTOITEXTFONT	=	0
AUTONEXTTEXT	=	0
SELECTUP	=	IECODE_LBUTTON+IECODE_UP_PREFIX
SELECTDOWN	=	IECODE_LBUTTON
MENUUP		=	IECODE_RBUTTON+IECODE_UP_PREFIX
MENUDOWN	=	IECODE_RBUTTON
ALTLEFT		=	IEQUALIFIER_LALT
ALTRIGHT	=	IEQUALIFIER_RALT
AMIGALEFT	=	IEQUALIFIER_LCOMMAND
AMIGARIGHT	=	IEQUALIFIER_RCOMMAND
AMIGAKEYS	=	AMIGALEFT+AMIGARIGHT
CURSORUP	=	$4C
CURSORLEFT	=	$4F
CURSORRIGHT	=	$4E
CURSORDOWN	=	$4D
KEYCODE_Q	=	$10
KEYCODE_X	=	$32
KEYCODE_N	=	$36
KEYCODE_M	=	$37
KEYCODE_V	=	$34
KEYCODE_B	=	$35
	IFND	INTUITION_INTUITIONBASE_I
	INCLUDE	intuition/intuitionbase.i
	ENDC
	ENDC
