ProcedureDLL S02_FunctionTest(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S02_FunctionBis(PrimParam.l, TestSecundo.s)
	ProcedureReturn PrimParam
EndProcedure
Procedure S02_FunctionTestPriv(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S02_FunctionTrisTest(PrimParam.l, TestSecundo.s, ThirdParam.b)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S02_FunctionTrisQuad(MyParam.l)
  Protected Val.l = S02_FunctionTestPriv(MyParam) * 2
  ProcedureReturn Val
EndProcedure
