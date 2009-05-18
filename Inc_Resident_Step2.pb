;@desc Cleans the place
ProcedureDLL Moebius_Resident_Step2()
  gState = #State_Step6

  ; if we don't keep files, we delete directories and their contents
  If gProject\bDontKeepSrcFiles = #False
    If FileSize(gProject\sDirBat) = -2
      If DeleteDirectory(gProject\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
        ProcedureReturn #Error_032
      EndIf
    EndIf
  Else
    ProcedureReturn #Error_000
  EndIf
  
  ; we close logs & batchs
  Output_End()
  
  ProcedureReturn #Error_000
EndProcedure