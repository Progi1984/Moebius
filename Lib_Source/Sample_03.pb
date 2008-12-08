ProcedureDLL S03_FunctionTest(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL.s S03_FunctionBis(PrimParam.l, TestSecundo.s)
	ProcedureReturn Str(PrimParam)
EndProcedure
Procedure S03_FunctionTestPriv(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S03_FunctionTrisTest(PrimParam.l, TestSecundo.s, ThirdParam.b)
	ProcedureReturn PrimParam
EndProcedure

ProcedureDLL S03_FunctionTrisQuad(MyParam.l)
  Protected Val.l = S03_FunctionTestPriv(MyParam) * 2
  ProcedureReturn Val
EndProcedure