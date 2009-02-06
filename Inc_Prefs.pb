ProcedureDLL Moebius_ReadPrefs()
  ; ReadPreferences > Path
  If gConf_Ini_Purebasic <> "" And FileSize(gConf_Ini_Purebasic) > 0
    If OpenPreferences(gConf_Ini_Purebasic) <> 0
      PreferenceGroup("PATH")
      gConf_PureBasic_Path.s = ReadPreferenceString("PureBasic", PB_GetPBFolder())
      gConf_Path_PBCOMPILER.s = ReadPreferenceString("PBCompiler", gConf_PureBasic_Path+#System_Separator+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec)
      gConf_Path_FASM.s = ReadPreferenceString("PBFasm",gConf_PureBasic_Path+#System_Separator+"compilers"+#System_Separator+"fasm"+#System_ExtExec)
      gConf_Path_OBJ2LIB.s = ReadPreferenceString("PBObj2Lib","")
      gConf_Path_PBLIBMAKER.s = ReadPreferenceString("PBLibMaker","")
      ClosePreferences()
    EndIf
  EndIf

  ; ReadPreferences > Project
  If gConf_Ini_Project <> "" And FileSize(gConf_Ini_Project) > 0
    If OpenPreferences(gConf_Ini_Project) <> 0
      PreferenceGroup(UCase(#System_OS))
        gProject\LibName = ReadPreferenceString("LibName", "")
        gProject\FileName = ReadPreferenceString("FileName", "")
        gConf_SourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
        gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
        gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
        gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
        gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
        gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
        gProject\FileCHM  = gProject\LibName + #System_ExtHelp
        gProject\sFileLog  = gConf_ProjectDir+"LOGS"+#System_Separator+"Log_"+FormatDate("%yyyy_%mm_%dd_%hh_%ii_%ss", Date())+".log"
        gProject\sFileOutput  = gProject\LibName
      
      PreferenceGroup("PROJECT")
        gProject\sFileOutput  = ReadPreferenceString("Output",gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1))
        gProject\bDontBuildLib  = ReadPreferenceLong("DontBuildLib", #False)
        gProject\bDontKeepSrcFiles  = ReadPreferenceLong("DontKeepSrcFiles", #False)
        gProject\bUnicode = ReadPreferenceLong("Unicode", #False)
        gProject\bThreadSafe = ReadPreferenceLong("ThreadSafe", #False)
        gProject\bBatFile  = ReadPreferenceLong("BatFile", #False)
        gProject\bLogFile  = ReadPreferenceLong("LogFile", #False)
      ClosePreferences()
    EndIf
  EndIf
EndProcedure
ProcedureDLL Moebius_ReadParameters()
  Protected IncA.l, lLastParam.l
  Protected bDecl_Switch_Param_LogFileName.b, bDecl_Switch_Param_OutputLib.b, bDecl_Switch_Param_Help.b
  ; Default informations
  gProject\FileName = Trim(ProgramParameter(CountProgramParameters()-1))
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux;{
      If Left(gProject\FileName,1) <> #System_Separator
        gProject\FileName = GetCurrentDirectory()+gProject\FileName
      EndIf
    ;}
    CompilerCase #PB_OS_Windows;{
      If Mid(gProject\FileName,3,1) <> #System_Separator
        gProject\FileName = GetCurrentDirectory()+gProject\FileName
      EndIf
    ;}
  CompilerEndSelect
  gProject\LibName  = Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)

  gConf_SourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
  gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
  gConf_Ini_Purebasic = ""
  gConf_Ini_Project = ""
  
  gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
  gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
  gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
  gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
  gProject\FileCHM  = gProject\LibName + #System_ExtHelp
  gProject\sFileLog  = gConf_ProjectDir+"LOGS"+#System_Separator+"Log_"+FormatDate("%yyyy_%mm_%dd_%hh_%ii_%ss", Date())+".log"
  gProject\bDontBuildLib = #False
  gProject\bDontKeepSrcFiles  = #True
  gProject\bLogFile  = #False
  gProject\sFileOutput  = gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\LibName
  gProject\bUnicode  = #False
  gProject\bThreadSafe  = #False
  gProject\bBatFile  = #False
  gProject\sSubsystem  = ""
  For IncA = 0 To CountProgramParameters()-1
      Select ProgramParameter(IncA)
        Case #Switch_Param_Help_s, #Switch_Param_Help_sl  ;{
          gProject\FileCHM = ProgramParameter(IncA + 1)
          bDecl_Switch_Param_Help = #True
          IncA = IncA + 1
        ;}
        Case #Switch_Param_DontBuildLib_s, #Switch_Param_DontBuildLib_sl  ;{
          gProject\bDontBuildLib = #True
        ;}
        Case #Switch_Param_DontKeepSrcFiles_s, #Switch_Param_DontKeepSrcFiles_sl  ;{
          gProject\bDontKeepSrcFiles = #False
        ;}
        Case #Switch_Param_LibName_s, #Switch_Param_LibName_sl  ;{
          gProject\LibName = ProgramParameter(IncA + 1)
          gConf_SourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
          gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
          gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
          gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
          gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
          gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
          If bDecl_Switch_Param_Help = #False
            gProject\FileCHM  = gProject\LibName + #System_ExtHelp
          EndIf
          If bDecl_Switch_Param_LogFileName = #False
            gProject\sFileLog  = gConf_ProjectDir+"LOGS"+#System_Separator+"Log_"+FormatDate("%yyyy_%mm_%dd_%hh_%ii_%ss", Date())+".log"
          EndIf
          If bDecl_Switch_Param_OutputLib = #False
            gProject\sFileOutput  = gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)
          EndIf
          IncA = IncA + 1
        ;}
        Case #Switch_Param_LogFile_s, #Switch_Param_LogFile_sl  ;{
          gProject\bLogFile = #True
        ;}
        Case #Switch_Param_OutputLib_s, #Switch_Param_OutputLib_sl  ;{
          gProject\sFileOutput = ProgramParameter(IncA + 1)
          bDecl_Switch_Param_OutputLib = #True
          IncA = IncA + 1
        ;}
        Case #Switch_Param_Unicode_s, #Switch_Param_Unicode_sl  ;{
          gProject\bUnicode = #True
        ;}
        Case #Switch_Param_ThreadSafe_s, #Switch_Param_ThreadSafe_sl  ;{
          gProject\bThreadSafe = #True
        ;}
        Case #Switch_Param_BatchFile_s, #Switch_Param_BatchFile_sl  ;{
          gProject\bBatFile = #True
        ;}
        Case #Switch_Param_PB_Path_s, #Switch_Param_PB_Path_sl;{
          gConf_PureBasic_Path = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Compiler_s, #Switch_Param_PB_Compiler_sl;{
          gConf_Path_PBCOMPILER = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Obj2Lib_s, #Switch_Param_PB_Obj2Lib_sl;{
          gConf_Path_OBJ2LIB = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Fasm_s, #Switch_Param_PB_Fasm_sl;{
          gConf_Path_FASM = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_LibMaker_s, #Switch_Param_PB_LibMaker_sl;{
          gConf_Path_PBLIBMAKER = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Ini_s, #Switch_Param_PB_Ini_sl;{
          gConf_Ini_Purebasic = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_Project_Ini_s, #Switch_Param_Project_Ini_sl;{
          gConf_Ini_Project = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_Subsytem_s, #Switch_Param_Subsytem_sl;{
          gProject\sSubsystem = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_LogFileName_s, #Switch_Param_LogFileName_sl;{
          gProject\sFileLog = ProgramParameter(IncA + 1)
          bDecl_Switch_Param_LogFileName = #True
          IncA = IncA + 1
        ;}
        Case #Switch_Param_ProjectDir_s, #Switch_Param_ProjectDir_sl ;{
          gConf_SourceDir = ProgramParameter(IncA + 1)
          gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
          gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
          gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
          gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
          gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
          gProject\FileCHM  = gProject\LibName + #System_ExtHelp
          IncA = IncA + 1
        ;}
        Default:
      EndSelect
  Next
EndProcedure 
