;@desc Cleans the place
;@return #Error_029 The directory ASM can't be deleted
;@return #Error_030 The directory OBJ can't be deleted
;@return #Error_031 The directory LIB can't be deleted
;@return #Error_032 The directory BAT can't be deleted
ProcedureDLL Moebius_Userlib_Step6()
  gState = #State_Step6

  ; if we don't keep files, we delete directories and their contents
  With gProject
    If \bDontKeepSrcFiles = #False
      If FileSize(\sDirAsm) = -2
        If DeleteDirectory(\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
          ProcedureReturn #Error_029
        EndIf
      EndIf
      If FileSize(\sDirObj) = -2
        If DeleteDirectory(\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
          ProcedureReturn #Error_030
        EndIf
      EndIf
      If FileSize(\sDirLib) = -2
        If DeleteDirectory(\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
          ProcedureReturn #Error_031
        EndIf
      EndIf
      If FileSize(\sDirBat) = -2
        If DeleteDirectory(\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = #False
          ProcedureReturn #Error_032
        EndIf
      EndIf
    EndIf
  EndWith
  
  ; we close logs & batchs
  Output_End()
  
  ; frees regural expressions
  FreeRegularExpression(#Regex_enx)
  FreeRegularExpression(#Regex_enp)
  FreeRegularExpression(#Regex_eni)
  
  ProcedureReturn #Error_000
EndProcedure