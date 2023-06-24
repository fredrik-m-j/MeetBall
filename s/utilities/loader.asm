; CREDITS
; Author:	Graeme Cowie (Mcgeezer)
;		https://mcgeezer.itch.io
;		https://www.amigagamedev.com
; History: 
;		June 2023 FmJ
;		* Testing d0 returned from AllocMem for 0, not minus.
;		https://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node0332.html

; In:	a0 = Pointer to filename
; In:	d1 = Memory type where the file should be unpacked into
; Out:	d0 = handle to asset
agdLoadPackedAsset:
	movem.l	d1-d7/a0-a1,-(a7)		; Save Registers
	move.l	d1,d5				; Save Requested Memory Type
	
; Open the file for reading
	move.l	a0,d1				      
        move.l  #MODE_OLDFILE,d2
	move.l  _DOSBase,a6 
        jsr     _LVOOpen(a6)         		; handle[d0] = LVOOpenFile(filename[d1],mode[d2])
	tst.l	d0				
	beq	.open_error
	
; Read the RNC header file
	move.l	d0,d4				; Save the file handle for later use.	
	lea	amgRncHeaderBuffer,a0		; Buffer to read RNC header bytes into
	move.l	a0,d2						
	move.l	#16,d3				; Read the first 16 bytes of the file.				
        jsr     _LVORead(a6)         		; bytes[d0] = LVORead(handle[d1],buffer[d2],size[d3])
	tst.l	d0				; Was there an error when reading?
	bmi	.header_error			; Yes, there was an error.
	cmp.l	d0,d3				; No error, but did we read the correct number of bytes?
	bne	.read_error			; bytes read was
       
	
; Check the RNC header
	lea	amgRncHeaderBuffer,a0		; Get pointer to the read header space
	move.l	(a0),d0
	lsr.l	#8,d0
	cmp.l	#"RNC",d0			; Is it RNC?
	bne	.rnc_error

; Allocate ram based on RNC header	
	move.l	4(a0),d0			; address[d0] = LVOAllocMem(buffsize[d0],MEM_TYPE[d1])
	move.l	d0,d6				; Get unpack length
	move.l	d5,d1				
	CALLEXEC	AllocMem
	tst.l	d0
	beq.s	.alloc_error
	move.l	d0,d5				; Save the allocated buffer origin into d5
	
	move.l	d4,d1				; Get file handle for seek 
	moveq	#0,d2				; To 0 byte offset
	move.l	#OFFSET_BEGINNING,d3		; Return to start of file
	move.l  _DOSBase,a6 
	jsr	_LVOSeek(a6)			
	
; Read the entire file	
	move.l	d4,d1				; Get file handle for seek 
	move.l	d5,d2				; Buffer to read into
	move.l	#$ffffff,d3			; Read entire file
        jsr     _LVORead(a6)        		; bytes[d0] = LVORead(handle[d1],buffer[d2],size[d3]) 	
	tst.l	d0
	bmi.s	.read_error
	move.l	d0,d3
	
; Close the file
	move.l	d4,d1				; result = LVOClose(handle[d1])      
        jsr     _LVOClose(a6)        

; Unpack the file.
	movem.l	a0-a1,-(a7)
	move.l	d5,a0
	move.l	d5,a1				; UnpackSize[d0] = Unpack[source[a0],dest[a0]
	bsr	Unpack
	movem.l	(a7)+,a0-a1
	
; Create an asset resource
	move.l	#tAsset,d0
	bsr	agdCreateNewHandle
	move.l	d5,hAddress(a0)			; Save address of asset
	move.l	#tAsset,hType(a0)		; Save type of resource
	move.b	d0,hIndex(a0)			; Save handle for this type
	clr.b	hLastIndex(a0)
	move.l	d6,hSize(a0)			; Save Length of asset
	move.l	a0,d0
	bra	.exit				; All done.
	        	
.open_error:
	moveq	#ERROR_HANDLE_FILE_OPEN,d0
	bra.s	.exit
.header_error:
	moveq	#ERROR_HANDLE_HEADER_NOT_FOUND,d0
	bra.s	.exit
.alloc_error:
	moveq	#ERROR_HANDLE_ALLOCATE_FAIL,d0
	bra.s	.exit
.read_error:
	moveq	#ERROR_HANDLE_FILE_READ,d0
	bra.s	.exit
.rnc_error:
	moveq	#ERROR_HANDLE_RNC,d0
	bra.s	.exit
.unpack_error:
	moveq	#ERROR_HANDLE_UNPACK,d0
	bra.s	.exit
	nop
.exit:	
	movem.l	(a7)+,d1-d7/a0-a1
	rts
	
	
; In:	d0 = Requested memory size
; In:	d1 = Requested memory type
; Out:	d0 = Handle to memory resource
agdAllocateResource:
	movem.l	d5-d6/a0,-(a7)			; Save Registers	
	move.l	d0,d6				; Get alloc Size				
	CALLEXEC	AllocMem
	tst.l	d0
	beq.s	.alloc_error
	move.l	d0,d5				; Save the allocated buffer origin into d5
	
; Create an asset resource
	move.l	#tRes,d0
	bsr	agdCreateNewHandle		
	move.l	#tRes,hType(a0)			; Save type of resource
	move.b	d0,hIndex(a0)			; Save handle for this type
	clr.b	hLastIndex(a0)
	move.l	d5,hAddress(a0)			; Save address of asset
	move.l	d6,hSize(a0)			; Save Length of asset
	move.l	a0,d0
	bra	.exit				; All done.
	        	
.alloc_error:
	moveq	#ERROR_HANDLE_ALLOCATE_FAIL,d0	
.exit:	movem.l	(a7)+,d5-d6/a0
	rts
	