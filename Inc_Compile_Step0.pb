;@desc Cleans  the directory and prepares the working directory
;@returnvalue 1  > Success
;@returnvalue 0  > Error : Can't delete userlibs of old projects
;@returnvalue -1 > Error : Can't create the directory of project
;@returnvalue -2 > Error : Can't create the directory "Project\ASM"
;@returnvalue -3 > Error : Can't create the directory "Project\LOGS"
;@returnvalue -4 > Error : Can't create the directory "Project\LIB"
;@returnvalue -5 > Error : Can't create the directory "Project\OBJ"
;@returnvalue -6 > Error : Can't delete the directory ASM of project
;@returnvalue -7 > Error : Can't delete the directory LIB of project
;@returnvalue -8 > Error : Can't delete the directory OBJ of project
;@returnvalue -9 > Error : Can't create the directory "Project\BAT"
;@returnvalue -10> Error : Can't delete the directory BAT of project
ProcedureDLL Moebius_Compile_Step0()
  ;Cleans the old userlib
  If FileSize(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName) > 0
    If DeleteFile(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName) = 0
      ProcedureReturn #False
    EndIf
  EndIf
  ;Deletes old content of directories
  If FileSize(gProject\sDirAsm) = -2
    If DeleteDirectory(gProject\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #False -6
    EndIf
  EndIf
  If FileSize(gProject\sDirBat) = -2
    If DeleteDirectory(gProject\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #False -10
    EndIf
  EndIf
  If FileSize(gProject\sDirLib) = -2
    If DeleteDirectory(gProject\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #False -7
    EndIf
  EndIf
  If FileSize(gProject\sDirObj) = -2
    If DeleteDirectory(gProject\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #False -8
    EndIf
  EndIf
  ; Creates directories if inexistant
  If CreateDirectoryEx(gProject\sDirProject) = #False
    ProcedureReturn #False -1
  EndIf
  If CreateDirectoryEx(gProject\sDirBat)= #False
    ProcedureReturn #False -9
  EndIf
  If CreateDirectoryEx(gProject\sDirAsm)= #False
    ProcedureReturn #False -2
  EndIf
  If CreateDirectoryEx(gProject\sDirLogs)= #False
    ProcedureReturn #False -3
  EndIf
  If CreateDirectoryEx(gProject\sDirLib)= #False
    ProcedureReturn #False -4
  EndIf
  If CreateDirectoryEx(gProject\sDirObj)= #False
    ProcedureReturn #False -5
  EndIf
  ; Initializes batch and log files
  Output_Init()
  ProcedureReturn #True
EndProcedure
