;@desc : Read preferences
ProcedureDLL Moebius_ReadPrefs()
  ; ReadPreferences > Path
  If gConf\sIni_Purebasic <> "" And FileSize(gConf\sIni_Purebasic) > 0
    If OpenPreferences(gConf\sIni_Purebasic) <> 0
      PreferenceGroup("PATH")
      gConf\sPureBasic_Path.s = ReadPreferenceString("PureBasic", PB_GetPBFolder())
      gConf\sPath_PBCOMPILER.s = ReadPreferenceString("PBCompiler", gConf\sPureBasic_Path+#System_Separator+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec)
      gConf\sPath_FASM.s = ReadPreferenceString("PBFasm",gConf\sPureBasic_Path+#System_Separator+"compilers"+#System_Separator+"fasm"+#System_ExtExec)
      gConf\sPath_OBJ2LIB.s = ReadPreferenceString("PBObj2Lib","")
      gConf\sPath_PBLIBMAKER.s = ReadPreferenceString("PBLibMaker","")
      ClosePreferences()
    EndIf
  EndIf

  ; ReadPreferences > Project
  If gConf\sIni_Project <> "" And FileSize(gConf\sIni_Project) > 0
    If OpenPreferences(gConf\sIni_Project) <> 0
      PreferenceGroup(UCase(#System_OS))
        gProject\sLibName = ReadPreferenceString("LibName", "")
        gProject\sFileName = ReadPreferenceString("FileName", "")
        gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
        gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
        M_Moebius_InitDir()
      
      PreferenceGroup("PROJECT")
        gProject\sFileOutput  = ReadPreferenceString("Output",gProject\sLibName)
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
;@desc : Read parameters from command line
ProcedureDLL Moebius_ReadParameters()
  Protected IncA.l, lLastParam.l
  Protected bDecl_Switch_Param_LogFileName.b, bDecl_Switch_Param_OutputLib.b, bDecl_Switch_Param_Help.b
  ; Default informations
  gProject\sFileName = Trim(ProgramParameter(CountProgramParameters()-1))
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux;{
      If Left(gProject\sFileName,1) <> #System_Separator
        gProject\sFileName = GetCurrentDirectory()+gProject\sFileName
      EndIf
    ;}
    CompilerCase #PB_OS_Windows;{
      If Mid(gProject\sFileName,3,1) <> #System_Separator
        gProject\sFileName = GetCurrentDirectory()+gProject\sFileName
      EndIf
    ;}
  CompilerEndSelect
  gProject\sLibName  = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)

  gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
  gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
  M_Moebius_InitDir()
  
  gConf\sIni_Purebasic = ""
  gConf\sIni_Project = ""
  
  gProject\bDontBuildLib = #False
  gProject\bDontKeepSrcFiles  = #True
  gProject\bLogFile  = #False
  gProject\bUnicode  = #False
  gProject\bThreadSafe  = #False
  gProject\bBatFile  = #False
  gProject\sSubsystem  = ""
  
  ; now we read command line
  For IncA = 0 To CountProgramParameters()-1
      Select ProgramParameter(IncA)
        Case #Switch_Param_Help_s, #Switch_Param_Help_sl  ;{
          gProject\sFileCHM = ProgramParameter(IncA + 1)
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
          gProject\sLibName = ProgramParameter(IncA + 1)
          gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
          gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
          M_Moebius_InitDir(bDecl_Switch_Param_Help, bDecl_Switch_Param_LogFileName, bDecl_Switch_Param_OutputLib)
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
          gConf\sPureBasic_Path = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Compiler_s, #Switch_Param_PB_Compiler_sl;{
          gConf\sPath_PBCOMPILER = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Obj2Lib_s, #Switch_Param_PB_Obj2Lib_sl;{
          gConf\sPath_OBJ2LIB = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Fasm_s, #Switch_Param_PB_Fasm_sl;{
          gConf\sPath_FASM = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_LibMaker_s, #Switch_Param_PB_LibMaker_sl;{
          gConf\sPath_PBLIBMAKER = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_PB_Ini_s, #Switch_Param_PB_Ini_sl;{
          gConf\sIni_Purebasic = ProgramParameter(IncA + 1)
          IncA = IncA + 1
        ;}
        Case #Switch_Param_Project_Ini_s, #Switch_Param_Project_Ini_sl;{
          gConf\sIni_Project = ProgramParameter(IncA + 1)
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
          gConf\sSourceDir = ProgramParameter(IncA + 1)
          gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
          M_Moebius_InitDir(bDecl_Switch_Param_Help, bDecl_Switch_Param_LogFileName, bDecl_Switch_Param_OutputLib)
          gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
          IncA = IncA + 1
        ;}
        Case #Switch_Param_LogFileInStream_s, #Switch_Param_LogFileInStream_sl ;{
          gProject\bLogInStreaming = #True
        ;}
      EndSelect
  Next
EndProcedure 
