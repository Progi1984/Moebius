ProcedureDLL S08_GetVarL(Array MyArrayL.l(1), Num.l)
	Protected sContent.s, lInc.l
	For lInc = 1 To  10
	  sContent + "ID : " + Str(lInc)+ " - Element : "+Str(MyArrayL(lInc))+Chr(13) + Chr(10)
	Next
	MessageRequester("S08_GetVarL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S08_2GetVarL(Array MyArrayL.l(1), Num.l)
	ProcedureReturn MyArrayL(Num)
EndProcedure
ProcedureDLL S08_GetVarS(Num.l, Array MyArrayS.s(1))
	Protected sContent.s
	For lInc = 0 To  9
	  sContent + "ID : " + Str(lInc)+ " - Element : "+MyArrayS(lInc)+Chr(13) + Chr(10)
	Next
	MessageRequester("S08_GetVarS", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S08_GetVarPoint(Array MyArrayPoint.Point(1))
	Protected sContent.s
	For lInc = 0 To  9
	  sContent + "ID : " + Str(lInc)+ " - Element X: "+Str(MyArrayPoint(lInc)\x)+ " - Element Y: "+Str(MyArrayPoint(lInc)\y)+Chr(13)+Chr(10)
	Next
	MessageRequester("S08_GetVarPoint", sContent)
	ProcedureReturn #True
EndProcedure
