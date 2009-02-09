ProcedureDLL Moebius_MainThread(Param.l)
  Protected RetValue.l
  RetValue = Moebius_Compile_Step0()
  Log_Add("Moebius_Compile_Step0()")
  If RetValue = #True
    Log_Add("Moebius_Compile_Step1()")
    RetValue = Moebius_Compile_Step1()
    If RetValue = #True
      Log_Add("Moebius_Compile_Step2()")
      Moebius_Compile_Step2()
      Log_Add("Moebius_Compile_Step3()")
      Moebius_Compile_Step3()
      Log_Add("Moebius_Compile_Step4()")
      Moebius_Compile_Step4()
      Log_Add("Moebius_Compile_Step5()")
      Moebius_Compile_Step5()
      ; 6. Cleans the place
      Log_Add("Moebius_Compile_Step6()")
      Moebius_Compile_Step6()
    Else
      Log_Add("Step1 > Error > "+Str(RetValue))
    EndIf
  Else
    Log_Add("Step0 > Error > "+Str(RetValue))
  EndIf
EndProcedure
