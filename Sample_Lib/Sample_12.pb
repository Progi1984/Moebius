ProcedureDLL.l S12_Function(lval.l)
	If lval = 5
		Goto label_twelve
	Else
		Goto label_twelvebis
	EndIf
	label_twelve:
	ProcedureReturn 10
	label_twelvebis:
	ProcedureReturn 20
EndProcedure 
