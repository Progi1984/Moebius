ProcedureDLL S09_FuncL(Var1.l, Var2.s)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
  sContent + "3 : " + Str(Var3) + Chr(13) + Chr(10)
	MessageRequester("S09_FuncL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S09_FuncL2(Var1.l, Var2.s, Var3.l=100)
	Protected sContent.s
  sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
  sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
  sContent + "3 : " + Str(Var3) + Chr(13) + Chr(10)
	MessageRequester("S09_FuncL", sContent)
	ProcedureReturn #True
EndProcedure
; ProcedureDLL S09_FuncS(Var1.l, Var2.s, Var3.s="Azerty For Moebius") ;  Help S09_FuncS()
; 	Protected sContent.s
;   sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
;   sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
;   sContent + "3 : " +     Var3  + Chr(13) + Chr(10)
; 	MessageRequester("S09_FuncS", sContent)
; 	ProcedureReturn #True
; EndProcedure
; ProcedureDLL S09_FuncSL(Var1.l, Var2.s, Var3.s="Azerty For Moebius", Var4.l = 1000)
; 	Protected sContent.s
;   sContent + "1 : " + Str(Var1) + Chr(13) + Chr(10)
;   sContent + "2 : " +     Var2  + Chr(13) + Chr(10)
;   sContent + "3 : " +     Var3  + Chr(13) + Chr(10)
;   sContent + "4 : " + Str(Var4) + Chr(13) + Chr(10)
; 	MessageRequester("S09_FuncSL", sContent)
; 	ProcedureReturn #True
; EndProcedure
