ProcedureDLL Moebius_MainThread(Param.l)
  Protected RetValue.l
  RetValue = Moebius_Compile_Step0()
  Output_Add("Moebius_Compile_Step0()", #Output_Log)
  If RetValue = #True
    Output_Add("Moebius_Compile_Step1()", #Output_Log)
    RetValue = Moebius_Compile_Step1()
    If RetValue = #True
      Output_Add("Moebius_Compile_Step2()", #Output_Log)
      Moebius_Compile_Step2()
      Output_Add("Moebius_Compile_Step3()", #Output_Log)
      Moebius_Compile_Step3()
      Output_Add("Moebius_Compile_Step4()", #Output_Log)
      Moebius_Compile_Step4()
      Output_Add("Moebius_Compile_Step5()", #Output_Log)
      Moebius_Compile_Step5()
      ; 6. Cleans the place
      Output_Add("Moebius_Compile_Step6()", #Output_Log)
      Moebius_Compile_Step6()
    Else
      Output_Add("Step1 > Error > "+Str(RetValue), #Output_Log)
    EndIf
  Else
    Output_Add("Step0 > Error > "+Str(RetValue), #Output_Log)
  EndIf
EndProcedure
