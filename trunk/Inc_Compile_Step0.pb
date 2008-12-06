
;@returnvalue : 1  > Success
;@returnvalue : 0  > Error : Can't delete files of old projects
;@returnvalue : -1 > Error : Can't create the directory of project
;@returnvalue : -2 > Error : Can't create the directory "Project\ASM"
;@returnvalue : -3 > Error : Can't create the directory "Project\LOGS"
;@returnvalue : -4 > Error : Can't create the directory "Project\LIB"
;@returnvalue : -5 > Error : Can't create the directory "Project\OBJ"
;@returnvalue : -6 > Error : Can't delete the old userlibrary
ProcedureDLL Moebius_Compile_Step0()
  ; 0. Cleaning & Preparing
  ;Cleans the old userlib
  If FileSize(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\LibName) > 0
    If DeleteFile(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\LibName) = 0
      ProcedureReturn #False -6
    EndIf
  EndIf
  ;Prepares the location For Moebius
  If FileSize(gConf_ProjectDir) = -2
    If DeleteDirectory(gConf_ProjectDir, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #False
    EndIf
  EndIf
  If CreateDirectoryEx(gConf_ProjectDir)
    If CreateDirectoryEx(gConf_ProjectDir+"ASM"+#System_Separator)
      If CreateDirectoryEx(gConf_ProjectDir+"LOGS"+#System_Separator)
        Log_Init()
        If CreateDirectoryEx(gConf_ProjectDir+"LIB"+#System_Separator)
          If CreateDirectoryEx(gConf_ProjectDir+"OBJ"+#System_Separator)
            ProcedureReturn #True
          Else
            ProcedureReturn #False -5
          EndIf
        Else
          ProcedureReturn #False -4
        EndIf
      Else
        ProcedureReturn #False -3
      EndIf
    Else
      ProcedureReturn #False -2
    EndIf
  Else
    ProcedureReturn #False -1
  EndIf
EndProcedure
