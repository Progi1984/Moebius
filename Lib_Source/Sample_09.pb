DeclareDLL S09_FuncL2(Var1.l, Var2.s, Var3.l)
ProcedureDLL S09_FuncL(Var1.l, Var2.s)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncL2(Var1.l, Var2.s, Var3.l)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
  sContent + "3 : " + Str(Var3) + Chr(13) + Chr(10)
	MessageRequester("S09_FuncL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncS(Var1.l, Var2.s)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncS", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncS2(Var1.l, Var2.s, Var3.s) ;  Help S09_FuncS()
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
  sContent + "3 : " +     Var3  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncS", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncSL(Var1.l, Var2.s)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncSL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncSL2(Var1.l, Var2.s, Var3.s)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
  sContent + "3 : " +     Var3  + Chr(13) + Chr(10)
	MessageRequester("S09_FuncSL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncSL3(Var1.l, Var2.s, Var3.s, Var4.l)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
  sContent + "3 : " +     Var3  + Chr(13) + Chr(10)
  sContent + "4 : " + Str(Var4) + Chr(13) + Chr(10)
	MessageRequester("S09_FuncSL", sContent)
	ProcedureReturn #True
EndProcedure