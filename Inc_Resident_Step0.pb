ProcedureDLL Moebius_Resident_Step0()
  gState = #State_Step0

  ;Cleans the old resident
  If FileSize(gConf\sPureBasic_Path + "residents" + #System_Separator + gProject\sFileOutput) > 0
    If DeleteFile(gConf\sPureBasic_Path + "residents" + #System_Separator + gProject\sFileOutput) = 0
      ProcedureReturn #Error_001
    EndIf
  EndIf
  ; Cleans the old batch
  If FileSize(gProject\sDirBat) = -2
    If DeleteDirectory(gProject\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #Error_003
    EndIf
  EndIf
  
  ; Creates directories if inexistant
  If CreateDirectoryEx(gProject\sDirProject) = #False
    ProcedureReturn #Error_006
  EndIf
  If CreateDirectoryEx(gProject\sDirBat)= #False
    ProcedureReturn #Error_007
  EndIf
  If CreateDirectoryEx(gProject\sDirLogs) = #False
    ProcedureReturn #Error_009
  EndIf
  
  ; Initializes batch and log files
  Output_Init()

  ProcedureReturn #Error_000
EndProcedure
