ProcedureDLL S10_FuncL(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureCDLL S10_FuncL_Debug(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	;DebugLog("S09_FuncL")
	;DebugLog(sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S10_FuncS(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncS", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureCDLL S10_FuncS_Debug(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	;DebugLog("S09_FuncS")
	;DebugLog(sContent)
	ProcedureReturn #True
EndProcedure