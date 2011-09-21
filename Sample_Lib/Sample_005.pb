ProcedureDLL S005_Init()
  Global *pVarMem = AllocateMemory(SizeOf(Long))
EndProcedure
ProcedureDLL S005_End()
  If *pVarMem
    FreeMemory(*pVarMem)
  EndIf
EndProcedure

ProcedureDLL.l S005_FunctionSet(pParam.l)
  ProcedureReturn PokeL(*pVarMem, pParam)
EndProcedure
ProcedureDLL.l S005_FunctionGet()
  ProcedureReturn PeekL(*pVarMem)
EndProcedure