ProcedureDLL.s S04_FunctionTest(PrimParam.l)
	ProcedureReturn Str(PrimParam)+"Normal"
EndProcedure
ProcedureDLL.s S04_FunctionTest_3DNOW(PrimParam.l)
	ProcedureReturn Str(PrimParam)+"3DNOW"
EndProcedure
ProcedureDLL.s S04_FunctionTest_MMX(PrimParam.l)
	ProcedureReturn Str(PrimParam)+"MMX"
EndProcedure
ProcedureDLL.s S04_FunctionTest_SSE(PrimParam.l)
	ProcedureReturn Str(PrimParam)+"SSE"
EndProcedure
ProcedureDLL.s S04_FunctionTest_SSE2(PrimParam.l)
	ProcedureReturn Str(PrimParam)+"SSE2"
EndProcedure
; ProcedureDLL.s S04_FunctionTest_DEBUG(PrimParam.l)
; 	ProcedureReturn Str(PrimParam)+"DEBUG"
; EndProcedure
; ProcedureDLL.s S04_FunctionTest_UNICODE(PrimParam.l)
; 	ProcedureReturn Str(PrimParam)+"Unicode"
; EndProcedure
; ProcedureDLL.s S04_FunctionTest_THREAD_UNICODE(PrimParam.l)
; 	ProcedureReturn Str(PrimParam)+"UnicodeThread"
; EndProcedure
; ProcedureDLL.s S04_FunctionTest_THREAD(PrimParam.l)
; 	ProcedureReturn Str(PrimParam)+"Thread"
; EndProcedure