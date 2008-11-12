ProcedureDLL FunctionTest(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL FunctionBis(PrimParam.l, TestSecundo.s)
	ProcedureReturn PrimParam
EndProcedure
Procedure FunctionTestPriv(PrimParam.l)
	ProcedureReturn PrimParam
EndProcedure
ProcedureDLL FunctionTrisTest(PrimParam.l, TestSecundo.s, ThirdParam.b)
	ProcedureReturn PrimParam
EndProcedure

ProcedureDLL FunctionTrisQuad(MyParam.l)
  Protected Val.l = FunctionTestPriv(MyParam) * 2
	ProcedureReturn Val
EndProcedure
; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 15
; Folding = -
; EnableXP