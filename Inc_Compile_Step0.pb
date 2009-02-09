;@returnvalue : 1  > Success
;@returnvalue : 0  > Error : Can't delete userlibs of old projects
;@returnvalue : -1 > Error : Can't create the directory of project
;@returnvalue : -2 > Error : Can't create the directory "Project\ASM"
;@returnvalue : -3 > Error : Can't create the directory "Project\LOGS"
;@returnvalue : -4 > Error : Can't create the directory "Project\LIB"
;@returnvalue : -5 > Error : Can't create the directory "Project\OBJ"
;@returnvalue : -6 > Error : Can't delete the directory ASM of project
;@returnvalue : -7 > Error : Can't delete the directory LIB of project
;@returnvalue : -8 > Error : Can't delete the directory OBJ of project
;@returnvalue : -9 > Error : Can't create the directory "Project\BAT"
;@returnvalue : -10> Error : Can't delete the directory BAT of project
ProcedureDLL Moebius_Compile_Step0()
  ; 0. Cleaning & Preparing
  ;Cleans the old userlib
  If FileSize(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName) > 0
    If DeleteFile(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName) = 0
      Log_Add(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName, 2)
      ProcedureReturn #False
    EndIf
  EndIf
  ;Prepares the location For Moebius
  If FileSize(gProject\sDirAsm) = -2
    If DeleteDirectory(gProject\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      Log_Add(gProject\sDirAsm, 2)
      ProcedureReturn #False -6
    EndIf
  EndIf
  If FileSize(gProject\sDirBat) = -2
    If DeleteDirectory(gProject\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      Log_Add(gProject\sDirBat, 2)
      ProcedureReturn #False -10
    EndIf
  EndIf
  If FileSize(gProject\sDirLib) = -2
    If DeleteDirectory(gProject\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      Log_Add(gProject\sDirLib, 2)
      ProcedureReturn #False -7
    EndIf
  EndIf
  If FileSize(gProject\sDirObj) = -2
    If DeleteDirectory(gProject\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      Log_Add(gProject\sDirObj, 2)
      ProcedureReturn #False -8
    EndIf
  EndIf
  If CreateDirectoryEx(gProject\sDirProject) = #False
    Log_Add(gProject\sDirProject, 2)
    ProcedureReturn #False -1
  EndIf
  If CreateDirectoryEx(gProject\sDirBat)= #False
    Log_Add(gProject\sDirBat, 2)
    ProcedureReturn #False -9
  Else
    Batch_Init()
  EndIf
  If CreateDirectoryEx(gProject\sDirAsm)= #False
    Log_Add(gProject\sDirAsm, 2)
    ProcedureReturn #False -2
  EndIf
  If CreateDirectoryEx(gProject\sDirLogs)= #False
    Log_Add(gProject\sDirLogs, 2)
    ProcedureReturn #False -3
  Else
    Log_Init()
  EndIf
  If CreateDirectoryEx(gProject\sDirLib)= #False
    Log_Add(gProject\sDirLib, 2)
    ProcedureReturn #False -4
  EndIf
  If CreateDirectoryEx(gProject\sDirObj)= #False
    Log_Add(gProject\sDirObj, 2)
    ProcedureReturn #False -5
  EndIf
  ProcedureReturn #True
EndProcedure
