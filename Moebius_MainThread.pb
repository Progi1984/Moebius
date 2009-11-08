;@desc Main thread of all compilations
ProcedureDLL Moebius_MainThread(Param.l)
  Protected RetValue.l
  If gProject\bTypeOutput = #TypeOutput_UserLib
    ; ---------------- Step 0
    Output_Add("Moebius_Userlib_Step0()", #Output_Log)
    gsErrorContent = ""
    RetValue = Moebius_Userlib_Step0()
    If RetValue > #Error_000
      Output_Add("Step0 > Error > "+Str(RetValue), #Output_Log)
    Else ; ---------------- Step 1
      Output_Add("Moebius_Userlib_Step1()", #Output_Log)
      gsErrorContent = ""
      RetValue = Moebius_Userlib_Step1()
      If RetValue > #Error_000
        Output_Add("Step1 > Error > "+Str(RetValue), #Output_Log)
      Else ; ---------------- Step 2
        Output_Add("Moebius_Userlib_Step2()", #Output_Log)
        gsErrorContent = ""
        RetValue = Moebius_Userlib_Step2()
        If RetValue > #Error_000
          Output_Add("Step2 > Error > "+Str(RetValue), #Output_Log)
        Else ; ---------------- Step 3
          Output_Add("Moebius_Userlib_Step3()", #Output_Log)
          gsErrorContent = ""
          RetValue = Moebius_Userlib_Step3()
          If RetValue > #Error_000
            Output_Add("Step3 > Error > "+Str(RetValue), #Output_Log)
          Else ; ---------------- Step 4
            Output_Add("Moebius_Userlib_Step4()", #Output_Log)
            gsErrorContent = ""
            RetValue = Moebius_Userlib_Step4()
            If RetValue > #Error_000
              Output_Add("Step4 > Error > "+Str(RetValue), #Output_Log)
            Else ; ---------------- Step 5
              Output_Add("Moebius_Userlib_Step5()", #Output_Log)
              gsErrorContent = ""
              RetValue = Moebius_Userlib_Step5()
              If RetValue > #Error_000
                Output_Add("Step5 > Error > "+Str(RetValue), #Output_Log)
              Else ; ---------------- Step 6
                Output_Add("Moebius_Userlib_Step6()", #Output_Log)
                gsErrorContent = ""
                RetValue = Moebius_Userlib_Step6()
                If RetValue > #Error_000
                  Output_Add("Step6 > Error > "+Str(RetValue), #Output_Log)
                Else
                  RetValue = #Error_033
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  ElseIf gProject\bTypeOutput = #TypeOutput_Resident
    ; ---------------- Step 0
    Output_Add("Moebius_Resident_Step0()", #Output_Log)
    RetValue = Moebius_Resident_Step0()
    If RetValue > #Error_000
      Output_Add("Step0 > Error > "+Str(RetValue), #Output_Log)
    Else ; ---------------- Step 1
      Output_Add("Moebius_Resident_Step1()", #Output_Log)
      RetValue = Moebius_Resident_Step1()
      If RetValue > #Error_000
        Output_Add("Step1 > Error > "+Str(RetValue), #Output_Log)
      Else ; ---------------- Step 2
        Output_Add("Moebius_Resident_Step2()", #Output_Log)
        RetValue = Moebius_Resident_Step2()
        If RetValue > #Error_000
          Output_Add("Step2 > Error > "+Str(RetValue), #Output_Log)
        EndIf
      EndIf
    EndIf
  EndIf
  gError = RetValue
  gState = #State_StepLast+gState
EndProcedure
