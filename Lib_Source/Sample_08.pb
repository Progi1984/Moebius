ProcedureDLL S08_GetVarL(MyArrayL.l(1), Num.l) ; Commebt
	Protected sContent.s, lInc.l
	For lInc = 1 To  10
	  sContent + "ID : " + Str(lInc)+ " - Element : "+Str(MyArrayL(lInc))
	Next
	MessageRequester("S07_GetVarL", sContent)
	ProcedureReturn #True
EndProcedure
; ProcedureDLL S08_GetVarS(Num.l, MyArrayS.s(1))
; 	Protected sContent.s
; 	For lInc = 0 To  9
; 	  sContent + "ID : " + Str(lInc)+ " - Element : "+MyArrayS(lInc)+Chr(13) + Chr(10)
; 	Next
; 	MessageRequester("S07_GetVarS", sContent)
; 	ProcedureReturn #True
; EndProcedure
; ProcedureDLL S08_GetVarPoint(MyArrayPoint.Point(1))
; 	Protected sContent.s
; 	For lInc = 0 To  9
; 	  sContent + "ID : " + Str(lInc)+ " - Element X: "+Str(MyArrayPoint(lInc)\x)+ " - Element Y: "+Str(MyArrayPoint(lInc)\y)+Chr(13)+Chr(10)
; 	Next
; 	MessageRequester("S07_GetVarPoint", sContent)
; 	ProcedureReturn #True
; EndProcedure
