ProcedureDLL.b S000_FunctionByte(pParam.b)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.w S000_FunctionWord(pParam.w)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.l S000_FunctionLong(pParam.l)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.i S000_FunctionInteger(pParam.i)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.f S000_FunctionFloat(pParam.f)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.q S000_FunctionQuad(pParam.q)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.d S000_FunctionDouble(pParam.d)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.s S000_FunctionString(pParam.s)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.s S000_FunctionParamTwo(pParam1.s, pParam2.s)
  ProcedureReturn pParam1 + pParam2
EndProcedure
ProcedureDLL.s S000_FunctionParamThree(pParam1.s, pParam2.s, pParam3.s)
  ProcedureReturn pParam1 + pParam2 + pParam3
EndProcedure
ProcedureDLL.s S000_FunctionParamFour(pParam1.s, pParam2.s, pParam3.s, pParam4.s)
  ProcedureReturn pParam1 + pParam2 + pParam3 + pParam4
EndProcedure
ProcedureDLL.l S000_FunctionMem(*pMem)
  ProcedureReturn *pMem
EndProcedure
Procedure.l Private_S000_FunctionPrivate(pParam.l)
  ProcedureReturn pParam * 2
EndProcedure
ProcedureDLL.l S000_FunctionPrivate(pParam)
  Protected pVal.l = Private_S000_FunctionPrivate(pParam)
  ProcedureReturn pVal
EndProcedure

