ProcedureDLL S00_FunctionTest(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL.s S00_FunctionBis(PrimParam.l, TestSecundo.s)
	ProcedureReturn TestSecundo
EndProcedure
Procedure S00_FunctionTestPriv(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S00_FunctionTrisTest(PrimParam.l, TestSecundo.s, ThirdParam.b)
	ProcedureReturn PrimParam
EndProcedure

ProcedureDLL S00_FunctionTrisQuad(MyParam.l)
  Protected Val.l = S00_FunctionTestPriv(MyParam) * 2
  ProcedureReturn Val
EndProcedure