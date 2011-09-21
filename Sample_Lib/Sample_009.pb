ProcedureDLL.s S009_Function(pParam.s)
  ProcedureReturn pParam
EndProcedure
ProcedureDLL.s S009_Function2(pParam.s, pParam2.s)
  ProcedureReturn pParam + pParam2
EndProcedure
ProcedureDLL.s S009_Function3(pParam.s, pParam2.s, pParam3.l)
  ProcedureReturn pParam + pParam2 + " - " + Str(pParam3)
EndProcedure