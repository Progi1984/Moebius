ProcedureDLL S06_Init()
	Global S06_gVar = AllocateMemory(SizeOf(Long))
EndProcedure
ProcedureDLL S06_Get()
	ProcedureReturn PeekL(S06_gVar)
EndProcedure
ProcedureDLL S06_Set(Var.l)
	ProcedureReturn PokeL(S06_gVar, Var)
EndProcedure
ProcedureDLL S06_End()
	If S06_gVar
		FreeMemory(S06_gVar)
	EndIf
EndProcedure
