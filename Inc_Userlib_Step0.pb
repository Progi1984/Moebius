;@desc Cleans  the directory and prepares the working directory
;@return #Error_000 > Success
;@return #Error_001 > Error : Can't delete userlibs of old projects
;@return #Error_002 > Error : Can't delete the directory ASM of project
;@return #Error_003 > Error : Can't delete the directory BAT of project
;@return #Error_004 > Error : Can't delete the directory LIB of project
;@return #Error_005 > Error : Can't delete the directory OBJ of project
;@return #Error_006 > Error : Can't create the directory of project
;@return #Error_007 > Error : Can't create the directory "Project\BAT"
;@return #Error_008 > Error : Can't create the directory "Project\ASM"
;@return #Error_009 > Error : Can't create the directory "Project\LOGS"
;@return #Error_010 > Error : Can't create the directory "Project\LIB"
;@return #Error_011 > Error : Can't create the directory "Project\OBJ"
ProcedureDLL Moebius_Userlib_Step0()
  gState = #State_Step0
  ;Cleans the old userlib
  If FileSize(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+LCase(gProject\sLibName)) > 0
    If DeleteFile(gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+LCase(gProject\sLibName)) = 0
      ProcedureReturn #Error_001
    EndIf
  EndIf
  ;Deletes old content of directories
  With gProject
    If FileSize(\sDirAsm) = -2
      If DeleteDirectory(\sDirAsm, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
        ProcedureReturn #Error_002
      EndIf
    EndIf
    If FileSize(\sDirBat) = -2
      If DeleteDirectory(\sDirBat, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
        ProcedureReturn #Error_003
      EndIf
    EndIf
    If FileSize(\sDirLib) = -2
      If DeleteDirectory(\sDirLib, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
        ProcedureReturn #Error_004
      EndIf
    EndIf
    If FileSize(\sDirObj) = -2
      If DeleteDirectory(\sDirObj, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
        ProcedureReturn #Error_005
      EndIf
    EndIf
  EndWith
  ; Creates directories if inexistant
  With gProject
    If CreateDirectoryEx(\sDirProject) = #False
      ProcedureReturn #Error_006
    EndIf
    If CreateDirectoryEx(\sDirBat)= #False
      ProcedureReturn #Error_007
    EndIf
    If CreateDirectoryEx(\sDirAsm)= #False
      ProcedureReturn #Error_008
    EndIf
    If CreateDirectoryEx(\sDirLogs)= #False
      ProcedureReturn#Error_009
    EndIf
    If CreateDirectoryEx(\sDirLib)= #False
      ProcedureReturn #Error_010
    EndIf
    If CreateDirectoryEx(\sDirObj)= #False
      ProcedureReturn #Error_011
    EndIf
  EndWith
  ; Initializes batch and log files
  Output_Init()
  ; Initializes regural expressions
  If CreateRegularExpression(#Regex_enx, "^((?i)e)[a-z]{1}x") = 0
    Output_Add(RegularExpressionError(), #Output_Log)
    ProcedureReturn #Error_034
  EndIf
  If CreateRegularExpression(#Regex_enp, "^((?i)e)[a-z]{1}p") = 0
    Output_Add(RegularExpressionError(), #Output_Log)
    ProcedureReturn #Error_035
  EndIf
  If CreateRegularExpression(#Regex_eni, "^((?i)e)[a-z]{1}i") = 0
    Output_Add(RegularExpressionError(), #Output_Log)
    ProcedureReturn #Error_036
  EndIf
  
  ProcedureReturn #Error_000
EndProcedure
