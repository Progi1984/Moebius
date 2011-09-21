ProcedureDLL.s S011_FunctionString(pParam.s)
  If Len(pParam) >=5
    Goto lbl_test1
  Else
    Goto lbl_test2
  EndIf
  lbl_test1:
    ProcedureReturn "LABEL lbl_test1 : "+ pParam
  lbl_test2:
    ProcedureReturn "LABEL lbl_test2 : "+ pParam
EndProcedure