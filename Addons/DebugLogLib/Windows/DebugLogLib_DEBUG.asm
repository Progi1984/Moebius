format MS COFF

public _PB_DebugLog_DEBUG

extrn _PB_DEBUGGER_SendError@4

macro sc proc,[arg]
{
	reverse PUSH dword arg
	common CALL proc
}

section '.text' code readable executable

_PB_DebugLog_DEBUG:
  	TEST eax, eax
  	JZ .end
  	sc _PB_DEBUGGER_SendError@4,eax
	.end:
  	RET
