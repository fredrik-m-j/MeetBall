	IFND	EXEC_EXEC_LIB_I
EXEC_EXEC_LIB_I SET	1
**
**	$Filename: exec/exec_lib.i $
**	$Release: 1.3 $
**
**	
**
**	(C) Copyright 1985,1986,1987,1988 Commodore-Amiga, Inc.
**	    All Rights Reserved
**

	; FUNCDEF Supervisor
	; FUNCDEF ExitIntr
	; FUNCDEF Schedule
	; FUNCDEF Reschedule
	; FUNCDEF Switch
	; FUNCDEF Dispatch
	; FUNCDEF Exception
	; FUNCDEF InitCode
	; FUNCDEF InitStruct
	; FUNCDEF MakeLibrary
	; FUNCDEF MakeFunctions
	; FUNCDEF FindResident
	; FUNCDEF InitResident
	; FUNCDEF Alert
	; FUNCDEF Debug
	; FUNCDEF Disable
	; FUNCDEF Enable
	; FUNCDEF Forbid
	; FUNCDEF Permit
	; FUNCDEF SetSR
	; FUNCDEF SuperState
	; FUNCDEF UserState
	; FUNCDEF SetIntVector
	; FUNCDEF AddIntServer
	; FUNCDEF RemIntServer
	; FUNCDEF Cause
	; FUNCDEF Allocate
	; FUNCDEF Deallocate
	; FUNCDEF AllocMem
	; FUNCDEF AllocAbs
	; FUNCDEF FreeMem
	; FUNCDEF AvailMem
	; FUNCDEF AllocEntry
	; FUNCDEF FreeEntry
	; FUNCDEF Insert
	; FUNCDEF AddHead
	; FUNCDEF AddTail
	; FUNCDEF Remove
	; FUNCDEF RemHead
	; FUNCDEF RemTail
	; FUNCDEF Enqueue
	; FUNCDEF FindName
	; FUNCDEF AddTask
	; FUNCDEF RemTask
	; FUNCDEF FindTask
	; FUNCDEF SetTaskPri
	; FUNCDEF SetSignal
	; FUNCDEF SetExcept
	; FUNCDEF Wait
	; FUNCDEF Signal
	; FUNCDEF AllocSignal
	; FUNCDEF FreeSignal
	; FUNCDEF AllocTrap
	; FUNCDEF FreeTrap
	; FUNCDEF AddPort
	; FUNCDEF RemPort
	; FUNCDEF PutMsg
	; FUNCDEF GetMsg
	; FUNCDEF ReplyMsg
	; FUNCDEF WaitPort
	; FUNCDEF FindPort
	; FUNCDEF AddLibrary
	; FUNCDEF RemLibrary
	; FUNCDEF OldOpenLibrary
	; FUNCDEF CloseLibrary
	; FUNCDEF SetFunction
	; FUNCDEF SumLibrary
	; FUNCDEF AddDevice
	; FUNCDEF RemDevice
	; FUNCDEF OpenDevice
	; FUNCDEF CloseDevice
	; FUNCDEF DoIO
	; FUNCDEF SendIO
	; FUNCDEF CheckIO
	; FUNCDEF WaitIO
	; FUNCDEF AbortIO
	; FUNCDEF AddResource
	; FUNCDEF RemResource
	; FUNCDEF OpenResource
	; FUNCDEF RawIOInit
	; FUNCDEF RawMayGetChar
	; FUNCDEF RawPutChar
	; FUNCDEF RawDoFmt
	; FUNCDEF GetCC
	; FUNCDEF TypeOfMem
	; FUNCDEF Procure
	; FUNCDEF Vacate
	; FUNCDEF OpenLibrary
	; FUNCDEF InitSemaphore
	; FUNCDEF ObtainSemaphore
	; FUNCDEF ReleaseSemaphore
	; FUNCDEF AttemptSemaphore
	; FUNCDEF ObtainSemaphoreList
	; FUNCDEF ReleaseSemaphoreList
	; FUNCDEF FindSemaphore
	; FUNCDEF AddSemaphore
	; FUNCDEF RemSemaphore
	; FUNCDEF SumKickData
	; FUNCDEF AddMemList
	; FUNCDEF CopyMem
	; FUNCDEF CopyMemQuick

_LVOSupervisor	=	-30 
_LVOExitIntr	=	-36 
_LVOSchedule	=	-42 
_LVOReschedule	=	-48 
_LVOSwitch	=	-54 
_LVODispatch	=	-60 
_LVOException	=	-66 
_LVOInitCode	=	-72 
_LVOInitStruct	=	-78 
_LVOMakeLibrary	=	-84 
_LVOMakeFunctions=	-90 
_LVOFindResident=	-96 
_LVOInitResident=	-102 
_LVOAlert	=	-108 
_LVODebug	=	-114 
_LVODisable	=	-120 
_LVOEnable	=	-126 
_LVOForbid	=	-132 
_LVOPermit	=	-138 
_LVOSetSR	=	-144 
_LVOSuperState	=	-150 
_LVOUserState	=	-156 
_LVOSetIntVector=	-162 
_LVOAddIntServer=	-168 
_LVORemIntServer=	-174 
_LVOCause	=	-180 
_LVOAllocate	=	-186 
_LVODeallocate	=	-192 
_LVOAllocMem	=	-198 
_LVOAllocAbs	=	-204 
_LVOFreeMem	=	-210 
_LVOAvailMem	=	-216 
_LVOAllocEntry	=	-222 
_LVOFreeEntry	=	-228 
_LVOInsert	=	-234 
_LVOAddHead	=	-240 
_LVOAddTail	=	-246 
_LVORemove	=	-252 
_LVORemHead	=	-258 
_LVORemTail	=	-264 
_LVOEnqueue	=	-270 
_LVOFindName	=	-276 
_LVOAddTask	=	-282 
_LVORemTask	=	-288 
_LVOFindTask	=	-294 
_LVOSetTaskPri	=	-300 
_LVOSetSignal	=	-306 
_LVOSetExcept	=	-312 
_LVOWait	=	-318 
_LVOSignal	=	-324 
_LVOAllocSignal	=	-330 
_LVOFreeSignal	=	-336 
_LVOAllocTrap	=	-342 
_LVOFreeTrap	=	-348 
_LVOAddPort	=	-354 
_LVORemPort	=	-360 
_LVOPutMsg	=	-366 
_LVOGetMsg	=	-372 
_LVOReplyMsg	=	-378 
_LVOWaitPort	=	-384 
_LVOFindPort	=	-390 
_LVOAddLibrary	=	-396 
_LVORemLibrary	=	-402 
_LVOOldOpenLibrary=	-408 
_LVOCloseLibrary=	-414 
_LVOSetFunction	=	-420 
_LVOSumLibrary	=	-426 
_LVOAddDevice	=	-432 
_LVORemDevice	=	-438 
_LVOOpenDevice	=	-444 
_LVOCloseDevice	=	-450 
_LVODoIO	=	-456 
_LVOSendIO	=	-462 
_LVOCheckIO	=	-468 
_LVOWaitIO	=	-474 
_LVOAbortIO	=	-480 
_LVOAddResource	=	-486 
_LVORemResource	=	-492 
_LVOOpenResource=	-498 
_LVORawIOInit	=	-504 
_LVORawMayGetChar=	-510 
_LVORawPutChar	=	-516 
_LVORawDoFmt	=	-522 
_LVOGetCC	=	-528 
_LVOTypeOfMem	=	-534 
_LVOProcure	=	-540 
_LVOVacate	=	-546 
_LVOOpenLibrary	=	-552 
_LVOInitSemaphore=	-558 
_LVOObtainSemaphore=	-564 
_LVOReleaseSemaphore=	-570 
_LVOAttemptSemaphore=	-576 
_LVOObtainSemaphoreList=-582 
_LVOReleaseSemaphoreList=-588 
_LVOFindSemaphore=	-594 
_LVOAddSemaphore=	-600 
_LVORemSemaphore=	-606 
_LVOSumKickData	=	-612 
_LVOAddMemList	=	-618 
_LVOCopyMem	=	-624 
_LVOCopyMemQuick=	-630 
CALLEXEC	MACRO
	MOVE.L	(_SysBase).W,A6
	JSR	_LVO\1(A6)
	ENDM
EXECNAME	MACRO
	DC.B	'exec.library',0
	ENDM
_SysBase	=	4


	ENDC	; EXEC_EXEC_LIB_I
