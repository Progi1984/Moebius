Global S05_gVar.l
ProcedureDLL S05_FunctionTest(PrimParam.l)
	S05_gVar = PrimParam
	ProcedureReturn S05_gVar
EndProcedure
ProcedureDLL.s S05_FunctionBis()
  ProcedureReturn "S05Bis-" + Str(S05_gVar)
EndProcedure
ProcedureDLL S05_FunctionTrisTest()
  S05_gVar = S05_gVar * 2
  ProcedureReturn S05_gVar
EndProcedure
