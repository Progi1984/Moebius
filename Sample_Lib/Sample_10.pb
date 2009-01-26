ProcedureDLL S10_FuncL(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S10_FuncL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureCDLL S10_FuncL_DEBUG(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "DEBUG Start"+ Chr(13) + Chr(10)
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	sContent + "DEBUG End"+ Chr(13) + Chr(10)
	MessageRequester("S10_FuncL_DEBUG", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S10_FuncS(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S10_FuncS", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureCDLL S10_FuncS_DEBUG(Var1.l, Var2.s)
	Protected sContent.s
	sContent + "DEBUG Start"+ Chr(13) + Chr(10)
	sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
	sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	sContent + "DEBUG End"+ Chr(13) + Chr(10)
	MessageRequester("S10_FuncS_DEBUG", sContent)
	ProcedureReturn #True
EndProcedure
