ProcedureDLL S006_FunctionListLong(List pListLong.l())
	Protected psContent.s
	ForEach pListLong()
	  psContent + "ID : " + Str(ListIndex(pListLong()))
    psContent + " - Element : "+Str(pListLong()) 
    psContent + Chr(13) + Chr(10)
	Next
	MessageRequester("S006_FunctionListLong", psContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S006_FunctionListString(List pListString.s())
	Protected psContent.s
	ForEach pListString()
	  psContent + "ID : " + Str(ListIndex(pListString()))
    psContent + " - Element : "+pListString() 
    psContent + Chr(13) + Chr(10)
	Next
	MessageRequester("S006_FunctionListString", psContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S006_FunctionListStructured(List pListPoint.Point())
	Protected psContent.s
	ForEach pListPoint()
	  psContent + "ID : " + Str(ListIndex(pListPoint()))
    psContent + " - Element X: "+Str(pListPoint()\x)
    psContent + " - Element Y: "+Str(pListPoint()\y)
    psContent + Chr(13) + Chr(10)
	Next
	MessageRequester("S006_FunctionListStructured", psContent)
	ProcedureReturn #True
EndProcedure
