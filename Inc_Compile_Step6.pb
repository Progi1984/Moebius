;@desc Cleans the place
ProcedureDLL Moebius_Compile_Step6()
  ; if we don't keep files, we delete directories and their contents
  If gProject\bDontKeepSrcFiles = #False
    If FileSize(gProject\sDirAsm) = -2
      DeleteDirectory(gProject\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gProject\sDirObj) = -2
      DeleteDirectory(gProject\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gProject\sDirLib) = -2
      DeleteDirectory(gProject\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
    If FileSize(gProject\sDirBat) = -2
      DeleteDirectory(gProject\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    EndIf
  EndIf
  
  ; we close logs & batchs
  Output_End()
  
  ; 
  CompilerIf Defined(Moebius_App, #PB_Constant) = #True
    If FileSize(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sFileOutput) > 0
      MessageRequester("Moebius", "Build successful !")
    Else
      MessageRequester("Moebius", "Build failed !")
    EndIf
  CompilerEndIf
EndProcedure