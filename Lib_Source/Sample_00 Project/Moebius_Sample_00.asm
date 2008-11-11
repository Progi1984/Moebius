; 
; PureBasic x86 4.20 (Linux - x86) - generated code
; 
; (c) 2008 Fantaisie Software
; 
; The header must remain intact for Re-Assembly
; 
; :System
; :Import
; 
format ELF
; 
extrn exit
; 
extrn memset
extrn SYS_FastAllocateString
extrn SYS_FreeString
extrn _PB_StringBase
extrn PB_StringBase
extrn SYS_InitString
; 
extrn PB_StringBasePosition

macro pb_public symbol
{
_#symbol:
symbol:
}

; 
; 
section '.text' executable
; 
public PB_FunctionTest
public PB_FunctionTest_bis
public PB_FunctionTest_tris

macro MP0{
_Procedure0:
FunctionTest:
  PS0=4                                                                                                                                                                                                                                                     
; ProcedureReturn PrimParam
  MOV    eax,dword [esp+PS0+0]
  JMP   _EndProcedure1
; EndProcedure
  XOR    eax,eax
_EndProcedure1:
  RET    4
}
; ProcedureDLL FunctionTest_bis(PrimParam.l, TestSecundo.s)
macro MP2{
_Procedure2:
FunctionTest_bis:
  PS2=8
  XOR    eax,eax
  PUSH   eax                                                                                                                                                                                                                             
  MOV    edx,dword [esp+PS2+4]
  LEA    ecx,[esp+0]
  CALL   SYS_FastAllocateString
; ProcedureReturn PrimParam
  MOV    eax,dword [esp+PS2+0]
  JMP   _EndProcedure3
; EndProcedure
  XOR    eax,eax
_EndProcedure3:
  PUSH   dword [esp]
  CALL   SYS_FreeString
  ADD    esp,4
  RET    8
}
; Procedure PrivFunctionTest(PrimParam.l)
macro MP4{
_Procedure4:
  PS4=4                                                                                                                                                                                                                                                     
; ProcedureReturn PrimParam
  MOV    eax,dword [esp+PS4+0]
  JMP   _EndProcedure5
; EndProcedure
  XOR    eax,eax
_EndProcedure5:
  RET    4
}
; ProcedureDLL FunctionTest_tris(PrimParam.l, TestSecundo.s, ThirdParam.b)
macro MP6{
_Procedure6:
FunctionTest_tris:
  PS6=8
  XOR    eax,eax
  PUSH   eax                                                                                                                                                                                                                             
  MOV    edx,dword [esp+PS6+4]
  LEA    ecx,[esp+0]
  CALL   SYS_FastAllocateString
; ProcedureReturn PrimParam
  MOV    eax,dword [esp+PS6+0]
  JMP   _EndProcedure7
; EndProcedure
  XOR    eax,eax
_EndProcedure7:
  PUSH   dword [esp]
  CALL   SYS_FreeString
  ADD    esp,4
  RET    12
}
_PB_EOP:
_PB_EOP_NoValue:
  CALL   PB_EndFunctions
  PUSH   dword [PB_ExitCode]
  CALL   exit
PB_EndFunctions:
  RET
; 
MP0
MP2
MP6
section '.data' writeable
PB_DEBUGGER_LineNumber: dd -1
PB_DEBUGGER_IncludedFiles: dd 0
_SYS_StaticStringStart:
pb_public PB_NullString
  db     0
_SYS_StaticStringEnd:
align 4
align 4
s_s:
  dd     0
  dd     -1
align 4
; 
_PB_BSSSection:
align 4
; 
I_BSSStart:
PB_MemoryBase:  rd 1
PB_ArgC:  rd 1
PB_ArgV:  rd 1
PB_ExitCode:  rd 1
align 4
PB_DataPointer rd 1
align 4
align 4
align 4
align 4
I_BSSEnd:
section '.data' writeable
SYS_EndDataSection:
