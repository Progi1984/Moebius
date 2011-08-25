;@desc : Read preferences
ProcedureDLL Moebius_ReadPrefs()
  Protected psFilename.s
  ; ReadPreferences > Path
  ;-TODO : Verifier que la structure est intégré pour gConf dans les prefs
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
  ;-TODO : Verifier que la structure est intégré pour gProject dans les paramètres
  If gConf\sIni_Project <> "" And FileSize(gConf\sIni_Project) > 0
    If OpenPreferences(gConf\sIni_Project) <> 0
      PreferenceGroup(UCase(#System_OS))
        gProject\sLibName           = ReadPreferenceString("LibName", "")
        psFilename                  = ReadPreferenceString("FileName", "")
        If LCase(GetExtensionPart(psFilename)) = "pbp"
          gProject\sPBPFileName     = psFilename
        Else
          gProject\sFileName        = psFilename
        EndIf
        gConf\sSourceDir            = GetTemporaryDirectory() + "Moebius" + #System_Separator
        gProject\sDirProject        = gConf\sSourceDir + gProject\sLibName + #System_Separator
        M_Moebius_InitDir()
      
      PreferenceGroup("PROJECT")
        gProject\sFileOutput        = ReadPreferenceString("Output",gProject\sLibName)
        gProject\bDontBuildLib      = ReadPreferenceLong("DontBuildLib", #False)
        gProject\bDontKeepSrcFiles  = ReadPreferenceLong("DontKeepSrcFiles", #False)
        gProject\bUnicode           = ReadPreferenceLong("Unicode", #False)
        gProject\bThreadSafe        = ReadPreferenceLong("ThreadSafe", #False)
        gProject\bInlineASM         = ReadPreferenceLong("InlineASM", #False)
        gProject\bBatFile           = ReadPreferenceLong("BatFile", #False)
        gProject\bLogFile           = ReadPreferenceLong("LogFile", #False)
        gProject\sPBPTarget         = ReadPreferenceLong("PBPTarget", #False)
      ClosePreferences()
    EndIf
  EndIf
EndProcedure
;@desc : Read parameters from command line
;@return : #Error_037 : PBProject malformed
ProcedureDLL Moebius_ReadParameters()
  Protected IncA.l, lLastParam.l, plXML.l
  Protected bDecl_Switch_Param_LogFileName.b, bDecl_Switch_Param_OutputLib.b, bDecl_Switch_Param_Help.b, pbFound.b
  Protected piXMLNode.i, piXMLNodeSection.i, piXMLNodeTarget.i, piXMLNodeInputFile.i
  Protected psFilename.s
  ; Default informations
  ;-TODO : Verifier que la structure est intégré pour gConf dans les paramètres
  gConf\sIni_Purebasic = ""
  gConf\sIni_Project = ""
  gConf\sSourceDir          = ""
  
  ;-TODO : Verifier que la structure est intégré pour gProject dans les paramètres
  gProject\sFileName = ""
  gProject\sPBPFileName = ""
  gProject\bDontBuildLib = #False
  gProject\bDontKeepSrcFiles  = #True
  gProject\bLogFile  = #False
  gProject\bUnicode  = #False
  gProject\bThreadSafe  = #False
  gProject\bBatFile  = #False
  gProject\sSubsystem  = ""
  gProject\bTypeOutput = #TypeOutput_UserLib  
  gProject\bLogInStreaming = #False
  gProject\sPBPTarget = ""
  gProject\sFileCHM = ""
  
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
        IncA = IncA + 1
      ;}
      Case #Switch_Param_LogFile_s, #Switch_Param_LogFile_sl  ;{
        gProject\bLogFile = #True
      ;}
      Case #Switch_Param_OutputFilename_s, #Switch_Param_OutputFilename_sl  ;{
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
        IncA = IncA + 1
      ;}
      Case #Switch_Param_LogFileInStream_s, #Switch_Param_LogFileInStream_sl ;{
        gProject\bLogInStreaming = #True
      ;}
      Case #Switch_Param_TypeOutput_s, #Switch_Param_TypeOutput_sl ;{
        gProject\bTypeOutput = Val(ProgramParameter(IncA + 1))
        IncA = IncA + 1
      ;}
      Case #Switch_Param_InlineASM_s, #Switch_Param_InlineASM_sl ;{
        gProject\bInlineASM = #True
      ;}
      Case #Switch_Param_ProjectTarget_s, #Switch_Param_ProjectTarget_sl ;{
        gProject\sPBPTarget = ProgramParameter(IncA + 1)
        IncA = IncA + 1
      ;}
      Default ;{ Filename PB, PBI, PBP
        psFilename = Trim(ProgramParameter(IncA))
        If LCase(GetExtensionPart(psFilename)) = "pbp"
          gProject\sPBPFileName = psFilename
        ElseIf LCase(GetExtensionPart(psFilename)) = "pbi" Or LCase(GetExtensionPart(psFilename)) = "pb"
          gProject\sFileName    = psFilename
        EndIf
      ;}
    EndSelect
  Next

  ; we define last informations
  If gProject\sPBPFileName <> "" And gProject\sPBPTarget <> ""
    If FileSize(gProject\sPBPFileName) > 0
      plXML = LoadXML(#PB_Any, gProject\sPBPFileName, #PB_UTF8)
      If plXML > 0 
        If XMLStatus(plXML) = #PB_XML_Success
          piXMLNode = MainXMLNode(plXML)
          piXMLNodeSection = ChildXMLNode(piXMLNode)
          ; Loop for analysing MainNode\project
          Repeat 
            ExamineXMLAttributes(piXMLNodeSection)
            If GetXMLAttribute(piXMLNodeSection, "name") = "targets"
              pbFound = #True
            Else
              piXMLNodeSection = NextXMLNode(piXMLNodeSection)
              If piXMLNodeSection = 0
                pbFound = -1
              EndIf
            EndIf
          Until pbFound <> #False
          If pbFound = #True 
            pbFound = #False
            piXMLNodeTarget = ChildXMLNode(piXMLNodeSection)
            ; Loop for analysing MainNode\project\section['name=targets']
            Repeat 
              ExamineXMLAttributes(piXMLNodeTarget)
              If GetXMLAttribute(piXMLNodeTarget, "name") = gProject\sPBPTarget
                pbFound = #True
              Else
                piXMLNodeTarget = NextXMLNode(piXMLNodeTarget)
                If piXMLNodeTarget = 0
                  pbFound = -1
                EndIf
              EndIf
            Until pbFound <> #False
            If pbFound = #True 
              pbFound = #False
              piXMLNodeInputFile = ChildXMLNode(piXMLNodeTarget)
              ; Loop for analysing MainNode\project\section['name=targets']\target['name=gProject\sPBPTarget']
              Repeat 
                ExamineXMLAttributes(piXMLNodeInputFile)
                If GetXMLAttribute(piXMLNodeInputFile, "value") <> ""
                  pbFound = #True
                Else
                  piXMLNodeInputFile = NextXMLNode(piXMLNodeInputFile)
                  If piXMLNodeInputFile = 0
                    pbFound = -1
                  EndIf
                EndIf
              Until pbFound <> #False
              If pbFound = #True
                gProject\sFileName = GetPathPart(gProject\sPBPFileName) + GetXMLAttribute(piXMLNodeInputFile, "value")
              Else
                ;-TODO : Where is the error exactly ?
                ProcedureReturn #Error_037
              EndIf
            Else
              ;-TODO : Where is the error exactly ?
              ProcedureReturn #Error_037
            EndIf
          Else
            ;-TODO : Where is the error exactly ?
            ProcedureReturn #Error_037
          EndIf
        Else
          ;-TODO : Error XML to draw
        EndIf
        FreeXML(plXML)
      EndIf
    EndIf
  EndIf
  If gProject\sFileName <> ""
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
      CompilerCase #PB_OS_MacOS;{
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
  EndIf
  gProject\sLibName  = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)

  If gConf\sSourceDir = ""
    gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
  EndIf
  gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
  If bDecl_Switch_Param_Help = #False And gProject\sFileCHM  = ""
    gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
    bDecl_Switch_Param_Help = #True
  EndIf
  M_Moebius_InitDir(bDecl_Switch_Param_Help, bDecl_Switch_Param_LogFileName, bDecl_Switch_Param_OutputLib)
EndProcedure 