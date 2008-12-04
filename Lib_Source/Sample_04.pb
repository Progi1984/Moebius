ProcedureDLL S04_FunctionTest(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S04_FunctionBis(PrimParam.l, TestSecundo.s)
	ProcedureReturn PrimParam
EndProcedure
Procedure S04_FunctionTestPriv(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL S04_FunctionTrisTest(PrimParam.l, TestSecundo.s, ThirdParam.b)
	ProcedureReturn PrimParam
EndProcedure

ProcedureDLL S04_FunctionTrisQuad(MyParam.l)
  Protected Val.l = S04_FunctionTestPriv(MyParam) * 2
  ProcedureReturn Val
EndProcedure