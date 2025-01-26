ResourceTable:	
	dc.l	Assets,RESOURCESTRUCT_SIZEOF			; 0
	dc.l	Resources,RESOURCESTRUCT_SIZEOF			; 1
	dc.l	ResourceBitmap,BITMAPSTRUCT_SIZEOF		; 2
	dc.l	ResourcePalette,PALETTESTRUCT_SIZEOF	; 3
		
Assets:
Resources:		
	REPT	H_RESOURCES_MAX				; 0 = _structResourceType
	REPT	RESOURCESTRUCT_SIZEOF		; 4 = _structResourceIndex
	dc.b	-1							; 8 = _structResourceAddress
	ENDR							; 12 = _structResourceLength			 
	ENDR


ResourceBitmap:	
	REPT	H_BITMAPS_MAX
	REPT	BITMAPSTRUCT_SIZEOF
	dc.b	-1
	ENDR	
	ENDR	

ResourcePalette:	
	REPT	H_PALETTES_MAX
	REPT	PALETTESTRUCT_SIZEOF
	dc.b	-1
	ENDR	
	ENDR