ProcedureDLL S07_GetVarL(List MyListL.l(), Num.l) ; Comment
	Protected sContent.s
	ForEach MyListL()
	  sContent + "ID : " + Str(ListIndex(MyListL()))+ " - Element : "+Str(MyListL())+Chr(13) + Chr(10)
	Next
	MessageRequester("S07_GetVarL", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S07_GetVarS(Num.l, List MyListS.s())
	Protected sContent.s
	ForEach MyListS()
	  sContent + "ID : " + Str(ListIndex(MyListS()))+ " - Element : "+MyListS()+Chr(13) + Chr(10)
	Next
	MessageRequester("S07_GetVarS", sContent)
	ProcedureReturn #True
EndProcedure
ProcedureDLL S07_GetVarPoint(List MyListPoint.Point())
	Protected sContent.s
	ForEach MyListPoint()
	  sContent + "ID : " + Str(ListIndex(MyListPoint()))+ " - Element X: "+Str(MyListPoint()\x)+ " - Element Y: "+Str(MyListPoint()\y)+Chr(13)+Chr(10)
	Next
	MessageRequester("S07_GetVarPoint", sContent)
	ProcedureReturn #True
EndProcedure
