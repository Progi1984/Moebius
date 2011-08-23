ProcedureDLL S01_FunctionTest(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL.s S01_FunctionBis(PrimParam.l, TestSecundo.s)
	ProcedureReturn Str(PrimParam)
EndProcedure
Procedure S01_FunctionTestPriv(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S01_FunctionTrisTest(PrimParam.l, TestSecundo.s, ThirdParam.b)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S01_FunctionTrisQuad(MyParam.l)
  Protected Val.l = S01_FunctionTestPriv(MyParam) * 2
  ProcedureReturn Val
EndProcedure
