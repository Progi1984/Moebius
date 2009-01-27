
ProcedureDLL Moebius_Compile_Step6()
  ; 6. Cleans the place
  If gProject\bDontKeepSrcFiles = #False
    If FileSize(gConf_ProjectDir+"ASM"+#System_Separator) = -2
      DeleteDirectory(gConf_ProjectDir+"ASM"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gConf_ProjectDir+"BAT"+#System_Separator) = -2
      DeleteDirectory(gConf_ProjectDir+"BAT"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gConf_ProjectDir+"LIB"+#System_Separator) = -2
      DeleteDirectory(gConf_ProjectDir+"LIB"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gConf_ProjectDir+"OBJ"+#System_Separator) = -2
      DeleteDirectory(gConf_ProjectDir+"OBJ"+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
  EndIf
  Log_End()
  Batch_End()
EndProcedure