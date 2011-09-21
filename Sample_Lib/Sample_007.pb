ProcedureDLL S007_FunctionArrayLong(Array pArrayLong.l(1), pSize.l)
	Protected psContent.s
  Protected plVar.l
	For plVar = 0 To pSize - 1
	  psContent + "ID : " + Str(ArrayIndex(pArrayLong(plVar)))
    psContent + " - Element : "+Str(pArrayLong(plVar)) 
    psContent + Chr(13) + Chr(10)
	Next
	MessageRequester("S007_FunctionArrayLong", psContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S007_FunctionArrayString(Array pArrayString.s(1), pSize.l)
	Protected psContent.s
	Protected plVar.l
	For plVar = 0 To pSize - 1
	  psContent + "ID : " + Str(ArrayIndex(pArrayString(plVar)))
    psContent + " - Element : "+pArrayString(plVar) 
    psContent + Chr(13) + Chr(10)
	Next
	MessageRequester("S007_FunctionArrayString", psContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S007_FunctionArrayStructured(Array pArrayPoint.Point(1), pSize.l)
	Protected psContent.s
	Protected plVar.l
	For plVar = 0 To pSize - 1
	  psContent + "ID : " + Str(ArrayIndex(pArrayPoint(plVar)))
    psContent + " - Element X: "+Str(pArrayPoint(plVar)\x)
    psContent + " - Element Y: "+Str(pArrayPoint(plVar)\y)
    psContent + Chr(13) + Chr(10)
	Next
	MessageRequester("S007_FunctionArrayStructured", psContent)
	ProcedureReturn #True
EndProcedure
