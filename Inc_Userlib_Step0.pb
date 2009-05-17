;@desc Cleans  the directory and prepares the working directory
;@returnvalue #Error_000 > Success
;@returnvalue #Error_001 > Error : Can't delete userlibs of old projects
;@returnvalue #Error_002 > Error : Can't delete the directory ASM of project
;@returnvalue #Error_003 > Error : Can't delete the directory BAT of project
;@returnvalue #Error_004 > Error : Can't delete the directory LIB of project
;@returnvalue #Error_005 > Error : Can't delete the directory OBJ of project
;@returnvalue #Error_006 > Error : Can't create the directory of project
;@returnvalue #Error_007 > Error : Can't create the directory "Project\BAT"
;@returnvalue #Error_008 > Error : Can't create the directory "Project\ASM"
;@returnvalue #Error_009 > Error : Can't create the directory "Project\LOGS"
;@returnvalue #Error_010 > Error : Can't create the directory "Project\LIB"
;@returnvalue #Error_011 > Error : Can't create the directory "Project\OBJ"
ProcedureDLL Moebius_Userlib_Step0()
  gState = #State_Step0

  ;Cleans the old userlib
  If FileSize(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName) > 0
    If DeleteFile(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\sLibName) = 0
      ProcedureReturn #Error_001
    EndIf
  EndIf
  ;Deletes old content of directories
  If FileSize(gProject\sDirAsm) = -2
    If DeleteDirectory(gProject\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #Error_002
    EndIf
  EndIf
  If FileSize(gProject\sDirBat) = -2
    If DeleteDirectory(gProject\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #Error_003
    EndIf
  EndIf
  If FileSize(gProject\sDirLib) = -2
    If DeleteDirectory(gProject\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #Error_004
    EndIf
  EndIf
  If FileSize(gProject\sDirObj) = -2
    If DeleteDirectory(gProject\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #Error_005
    EndIf
  EndIf
  ; Creates directories if inexistant
  If CreateDirectoryEx(gProject\sDirProject) = #False
    ProcedureReturn #Error_006
  EndIf
  If CreateDirectoryEx(gProject\sDirBat)= #False
    ProcedureReturn #Error_007
  EndIf
  If CreateDirectoryEx(gProject\sDirAsm)= #False
    ProcedureReturn #Error_008
  EndIf
  If CreateDirectoryEx(gProject\sDirLogs)= #False
    ProcedureReturn#Error_009
  EndIf
  If CreateDirectoryEx(gProject\sDirLib)= #False
    ProcedureReturn #Error_010
  EndIf
  If CreateDirectoryEx(gProject\sDirObj)= #False
    ProcedureReturn #Error_011
  EndIf
  ; Initializes batch and log files
  Output_Init()
  ; Initializes regural expressions
  CreateRegularExpression(#Regex_enx, "^e[a-z]{1}x")
  CreateRegularExpression(#Regex_enp, "^e[a-z]{1}p")
  CreateRegularExpression(#Regex_eni, "^e[a-z]{1}i")
  
  ProcedureReturn #Error_000
EndProcedure
