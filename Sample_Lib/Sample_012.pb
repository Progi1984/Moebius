Global S012_gVarString.s
ProcedureDLL.s S012_FunctionString_Get()
  ProcedureReturn "Global : " + S012_gVarString
EndProcedure
ProcedureDLL.l S012_FunctionString_Set(pParam.s)
  S012_gVarString = pParam.s
  ProcedureReturn #True
EndProcedure