
ProcedureDLL Moebius_Compile_Step6()
  ; 6. Cleans the place
  If gProject\bDontKeepSrcFiles = #False
    If FileSize(gProject\sDirProject+"ASM"+#System_Separator) = -2
      DeleteDirectory(gProject\sDirProject+"ASM"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gProject\sDirProject+"BAT"+#System_Separator) = -2
      DeleteDirectory(gProject\sDirProject+"BAT"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gProject\sDirProject+"LIB"+#System_Separator) = -2
      DeleteDirectory(gProject\sDirProject+"LIB"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gProject\sDirProject+"OBJ"+#System_Separator) = -2
      DeleteDirectory(gProject\sDirProject+"OBJ"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
  EndIf
  Log_End()
  Batch_End()
EndProcedure