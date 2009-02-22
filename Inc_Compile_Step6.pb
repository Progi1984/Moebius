;@desc Cleans the place
;@return #Error_029 The directory ASM can't be deleted
;@return #Error_030 The directory OBJ can't be deleted
;@return #Error_031 The directory LIB  can't be deleted
;@return #Error_032 The directory BAT can't be deleted
ProcedureDLL Moebius_Compile_Step6()

  gState = #State_Step6

  ; if we don't keep files, we delete directories and their contents
  If gProject\bDontKeepSrcFiles = #False
    If FileSize(gProject\sDirAsm) = -2
      If DeleteDirectory(gProject\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
        ProcedureReturn #Error_029
      EndIf
    EndIf
    If FileSize(gProject\sDirObj) = -2
      If DeleteDirectory(gProject\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
        ProcedureReturn #Error_030
      EndIf
    EndIf
    If FileSize(gProject\sDirLib) = -2
      If DeleteDirectory(gProject\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
        ProcedureReturn #Error_031
      EndIf
    EndIf
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