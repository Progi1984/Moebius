EnableExplicit
#Moebius_App = #True

Global gStateOld.l

IncludePath "../../"
; Some includes must be included before others because of some specifics vars are called
  XIncludeFile "Inc_Declare.pb"
  XIncludeFile "Inc_Var.pb" 
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows : XIncludeFile "Inc_OS_Windows.pb"
    CompilerCase #PB_OS_Linux : XIncludeFile "Inc_OS_Linux.pb"
    CompilerCase #PB_OS_MacOS : XIncludeFile "Inc_OS_MacOS.pb"
  CompilerEndSelect

IncludePath "./"
  XIncludeFile "MGUI_Inc_Var.pb"
  XIncludeFile "MGUI_Inc_Func.pb"

IncludePath "../../"
  XIncludeFile "Moebius_Main.pb"

; Open the main window
WinMain_Create()
; Load Ini File with PB Paths
WinParamsPB_LoadIni()
WinParamsPB_Validate(#False)

CompilerIf #PB_Compiler_Debugger = #False
  OnErrorCall(@Main_ErrorHandler())
CompilerEndIf

gStateOld = #State_StepStart
Repeat
  lEvt_System = WaitWindowEvent()
  lEvt_Window = EventWindow()
  lEvt_Gadget = EventGadget()
  lEvt_Type = EventType()
  
  Select lEvt_System
    Case #PB_Event_Gadget;{
      Select lEvt_Window
        Case #Window_0;{ Main Window
          Select lEvt_Gadget
            Case #Window_0_CheckBox_0 ;{ Step1 > Unicode
              gProject\bUnicode = GetGadgetState(#Window_0_CheckBox_0)
              M_GUI_EnableStep(#False, #True, #False)
            ;}
            Case #Window_0_CheckBox_1 ;{ Step1 > Threadsafe
              gProject\bThreadSafe = GetGadgetState(#Window_0_CheckBox_1)
              M_GUI_EnableStep(#False, #True, #False)
            ;}
            Case #Window_0_CheckBox_2 ;{ Step1 > Batch
              gProject\bBatFile = GetGadgetState(#Window_0_CheckBox_2)
              M_GUI_EnableStep(#False, #True, #False)
            ;}
            Case #Window_0_CheckBox_3 ;{ Step1 > Log
              gProject\bLogFile = GetGadgetState(#Window_0_CheckBox_3)
              gProject\bLogInStreaming = GetGadgetState(#Window_0_CheckBox_3)
              M_GUI_EnableStep(#False, #True, #False)
            ;}
            Case #Window_0_CheckBox_4 ;{ Step1 > Don't Build Lib
              gProject\bDontBuildLib = GetGadgetState(#Window_0_CheckBox_4)
              M_GUI_EnableStep(#False, #True, #False)
            ;}
            Case #Window_0_CheckBox_5 ;{ Step1 > Don't Keep Src Files
              gProject\bDontKeepSrcFiles = 1-GetGadgetState(#Window_0_CheckBox_5)
              M_GUI_EnableStep(#False, #True, #False)
            ;}
            Case #Window_0_CheckBox_6 ;{ Step2 > Enable Logging
              bEnableLogEditor = GetGadgetState(#Window_0_CheckBox_6)
            ;}
          
            Case #Window_0_Button_0 ;{ Step0 > Browse "PureBasic Params"
              bAnotherWindowOpened + 1
              WinParamsPB_Create()
            ;}
            Case #Window_0_Button_1 ;{ Step1 > Source File
              Define.b bIsCHM, bIsOutput
              sRetString = OpenFileRequester(LanguageItems(13), "", LanguageItems(36)+"|*.pb;*.pbi|"+LanguageItems(35)+" (*.*)|*.*",0)
              If sRetString
                gProject\sFileName = sRetString
                SetGadgetText(#Window_0_String_1, gProject\sFileName)
                ; we define the name of projet if inexistant
                If GetGadgetText(#Window_0_String_0) = ""
                  gProject\sLibName  = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)
                  SetGadgetText(#Window_0_String_0, gProject\sLibName)
                  bIsOutput = #False
                EndIf
                ; we define the name of CHM if inexistant
                If GetGadgetText(#Window_0_String_2) = ""
                  bIsCHM = #False
                Else
                  bIsCHM = #True
                EndIf
                gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
                M_Moebius_InitDir(bIsCHM, #False, bIsOutput)
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
            ;}
            Case #Window_0_Button_2 ;{ Step1 > Help File
              sRetString = OpenFileRequester(LanguageItems(15), "", LanguageItems(15)+"|*"+#System_ExtHelp+"|"+LanguageItems(35)+" (*.*)|*.*",0)
              If sRetString
                gProject\sFileCHM = sRetString
                SetGadgetText(#Window_0_String_2, gProject\sFileCHM)
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
            ;}
            Case #Window_0_Button_3 ;{ Step1 > Working Directory
              sRetString = PathRequester(LanguageItems(16), "")
              If sRetString
                gConf\sSourceDir = sRetString
                gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
                M_Moebius_InitDir(#True, #False, #True)
                If GetGadgetText(#Window_0_String_2) = ""
                  gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
                  SetGadgetText(#Window_0_String_2, gProject\sFileCHM)
                EndIf
                SetGadgetText(#Window_0_String_3, gConf\sSourceDir)
                M_GUI_EnableStep(#False, #True, #False)
              EndIf            
            ;}
            Case #Window_0_Button_4 ;{ Step1 > Validate before compilation
              If bPBParams_Valid = 5
                If gProject\sFileName <> "" And FileSize(gProject\sFileName) > 0
                  If gProject\sLibName = ""
                    gProject\sLibName = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)
                    SetGadgetText(#Window_0_String_0, gProject\sLibName)
                    gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                    gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
                    M_Moebius_InitDir(#True, #False, #True)
                    If GetGadgetText(#Window_0_String_2) = ""
                      gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
                      SetGadgetText(#Window_0_String_2, gProject\sFileCHM)
                    EndIf
                  EndIf
                  If gProject\sDirProject = ""
                      SetGadgetText(#Window_0_String_3, GetTemporaryDirectory()+ "Moebius" + #System_Separator + gProject\sLibName + #System_Separator)
                      gProject\sDirProject  = GetGadgetText(#Window_0_String_3)
                      M_Moebius_InitDir(#True, #False, #False)
                      M_GUI_EnableStep(#False, #False, #True)
                      MessageRequester(LanguageItems(1), LanguageItems(37))
                  Else
                    If FileSize(gProject\sDirProject) <> -2 And Right(gProject\sDirProject, 1) <> #System_Separator
                      M_GUI_EnableStep(#False, #True, #False)
                      MessageRequester(LanguageItems(1), LanguageItems(38))
                    Else
                      M_GUI_EnableStep(#False, #False, #True)
                      MessageRequester(LanguageItems(1), LanguageItems(37))
                    EndIf
                  EndIf
                Else
                  M_GUI_EnableStep(#False, #True, #False)
                  MessageRequester(LanguageItems(1), LanguageItems(39))
                EndIf
              Else
                MessageRequester(LanguageItems(1), LanguageItems(40))
              EndIf
            ;}
            Case #Window_0_Button_5 ;{ Step2 > Compile
              M_ClearBeforeBuilding()
              ; Launchs a thread for compilation
              CreateThread(@Moebius_MainThread(),0)
            ;}
            Case #Window_0_Button_6 ;{ Pr�f�rences
              bAnotherWindowOpened + 1
              WinPrefs_Create()
            ;}
            Case #Window_0_Button_7 ;{ Profil > Load
              If gGUIPrefs\lAlwaysAskBeforeLoadingProject = #True 
                cReturnMessageRequester = MessageRequester(LanguageItems(1), LanguageItems(41), #PB_MessageRequester_YesNo)
              Else
                cReturnMessageRequester = #PB_MessageRequester_Yes
              EndIf
              If cReturnMessageRequester = #PB_MessageRequester_Yes
                If GetGadgetState(#Window_0_Combo_1) = 0
                  ; Long
                  SetGadgetState(#Window_0_CheckBox_0, #False)
                  SetGadgetState(#Window_0_CheckBox_1, #False)
                  SetGadgetState(#Window_0_CheckBox_2, #False)
                  SetGadgetState(#Window_0_CheckBox_3, #False)
                  SetGadgetState(#Window_0_CheckBox_4, #False)
                  SetGadgetState(#Window_0_CheckBox_5, #False)
                  ; String
                  SetGadgetText(#Window_0_String_1, "")
                  SetGadgetText(#Window_0_String_0, "")
                  SetGadgetText(#Window_0_String_2, "")
                  SetGadgetText(#Window_0_String_3, "")
                  ; Load the empty profile
                  M_Profil_Load()
                  ; Enable the Step 2 and Disable the Step 3
                  M_GUI_EnableStep(#False, #True, #False)
                Else
                  If FileSize(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
                    If OpenPreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                      If PreferenceGroup(GetGadgetItemText(#Window_0_Combo_1, GetGadgetState(#Window_0_Combo_1))) = #True
                        ; Load the choosen profile
                        M_Profil_Load(#True)
                        ; Enable the Step 2 and Disable the Step 3
                        M_GUI_EnableStep(#False, #True, #False)
                      EndIf
                      ClosePreferences() 
                    EndIf
                  EndIf
                EndIf
              EndIf
            ;}
            Case #Window_0_Button_8 ;{ Profil > Save
              If GetGadgetState(#Window_0_Combo_1) = 0
                sRetString = InputRequester(LanguageItems(1), LanguageItems(42)+" :", "Template"+Str(Random(SizeOf(Long))))
                If sRetString > ""
                  If FileSize(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
                    OpenPreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                  Else
                    CreatePreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                  EndIf
                  PreferenceGroup(sRetString)
                  WritePreferenceLong("Unicode", GetGadgetState(#Window_0_CheckBox_0))
                  WritePreferenceLong("Threadsafe", GetGadgetState(#Window_0_CheckBox_1))
                  WritePreferenceLong("Batch", GetGadgetState(#Window_0_CheckBox_2))
                  WritePreferenceLong("Log", GetGadgetState(#Window_0_CheckBox_3))
                  WritePreferenceLong("DontBuildLib", GetGadgetState(#Window_0_CheckBox_4))
                  WritePreferenceLong("DontKeepSrcFiles", GetGadgetState(#Window_0_CheckBox_5))
                  
                  WritePreferenceString("LibName", GetGadgetText(#Window_0_String_0))
                  WritePreferenceString("Source", GetGadgetText(#Window_0_String_1))
                  WritePreferenceString("HelpFile", GetGadgetText(#Window_0_String_2))
                  WritePreferenceString("DirProject", GetGadgetText(#Window_0_String_3))
                  ClosePreferences() 
                  M_Profil_GUIReload()
                EndIf
              Else
                If FileSize(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
                  If OpenPreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                    If PreferenceGroup(GetGadgetItemText(#Window_0_Combo_1, GetGadgetState(#Window_0_Combo_1))) = #True
                      WritePreferenceLong("Unicode", GetGadgetState(#Window_0_CheckBox_0))
                      WritePreferenceLong("Threadsafe", GetGadgetState(#Window_0_CheckBox_1))
                      WritePreferenceLong("Batch", GetGadgetState(#Window_0_CheckBox_2))
                      WritePreferenceLong("Log", GetGadgetState(#Window_0_CheckBox_3))
                      WritePreferenceLong("DontBuildLib", GetGadgetState(#Window_0_CheckBox_4))
                      WritePreferenceLong("DontKeepSrcFiles", GetGadgetState(#Window_0_CheckBox_5))
                      
                      WritePreferenceString("LibName", GetGadgetText(#Window_0_String_0))
                      WritePreferenceString("Source", GetGadgetText(#Window_0_String_1))
                      WritePreferenceString("HelpFile", GetGadgetText(#Window_0_String_2))
                      WritePreferenceString("DirProject", GetGadgetText(#Window_0_String_3))
                    EndIf
                    ClosePreferences() 
                    M_Profil_GUIReload()
                  EndIf
                EndIf
              EndIf
            ;}

            Case #Window_0_String_0 ;{ Step1 > LibName
              sRetString = GetGadgetText(#Window_0_String_0)
              If sRetString 
                gProject\sLibName  = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
            ;}
            Case #Window_0_String_1 ;{ Step1 > Source
              sRetString = GetGadgetText(#Window_0_String_1)
              If sRetString 
                gProject\sFileName  = sRetString
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
            ;}
            Case #Window_0_String_2 ;{ Step1 > Help File
              sRetString = GetGadgetText(#Window_0_String_2)
              If sRetString 
                gProject\sFileCHM  = GetFilePart(sRetString)
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
            ;}
            Case #Window_0_String_3 ;{ Step1 > DirProject
              sRetString = GetGadgetText(#Window_0_String_3)
              If sRetString 
                gProject\sDirProject  = sRetString
                M_Moebius_InitDir(#True, #False, #False)
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
            ;}
          EndSelect
        ;}
        Case #Window_1;{ PureBasic Paths
          Select lEvt_Gadget
            Case #Window_1_Button_0 ;{ Purebasic path
              sRetString = PathRequester(LanguageItems(26), "")
              If sRetString
                gConf\sPureBasic_Path = sRetString
                SetGadgetText(#Window_1_String_0, gConf\sPureBasic_Path)
                If GetGadgetText(#Window_1_String_1) = ""
                  gConf\sPath_PBCOMPILER = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec
                  SetGadgetText(#Window_1_String_1, gConf\sPath_PBCOMPILER)
                EndIf
                If GetGadgetText(#Window_1_String_2) = ""
                  gConf\sPath_FASM = gConf\sPureBasic_Path+"compilers"+#System_Separator+"fasm"+#System_ExtExec
                  SetGadgetText(#Window_1_String_2, gConf\sPath_FASM)
                EndIf
                If GetGadgetText(#Window_1_String_3) = ""
                  CompilerSelect #PB_Compiler_OS
                    CompilerCase #PB_OS_Linux ;{
                      gConf\sPath_OBJ2LIB = "/usr/bin/ar"
                    ;}
                    CompilerCase #PB_OS_Windows ;{
                      gConf\sPath_OBJ2LIB = gConf\sPureBasic_Path+"compilers"+#System_Separator+"polib"+#System_ExtExec
                    ;}
                  CompilerEndSelect
                  SetGadgetText(#Window_1_String_3, gConf\sPath_OBJ2LIB)
                EndIf
                If GetGadgetText(#Window_1_String_4) = ""
                  CompilerSelect #PB_Compiler_OS
                    CompilerCase #PB_OS_Linux ;{
                      gConf\sPath_PBLIBMAKER = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pblibrarymaker"+#System_ExtExec
                    ;}
                    CompilerCase #PB_OS_Windows ;{
                      gConf\sPath_PBLIBMAKER = gConf\sPureBasic_Path+"SDK"+#System_Separator+"LibraryMaker"+#System_ExtExec
                    ;}
                  CompilerEndSelect
                  SetGadgetText(#Window_1_String_4, gConf\sPath_PBLIBMAKER)
                EndIf
              EndIf
            ;}
            Case #Window_1_Button_1 ;{ Compiler
              sRetString = OpenFileRequester(LanguageItems(27), gConf\sPureBasic_Path+"compilers"+#System_Separator, LanguageItems(27)+"|pbcompiler"+#System_ExtExec+"|"+LanguageItems(35)+" (*.*)|*.*",0)
              If sRetString
                gConf\sPath_PBCOMPILER = sRetString
                SetGadgetText(#Window_1_String_1, gConf\sPath_PBCOMPILER)
              EndIf
            ;}
            Case #Window_1_Button_2 ;{ Fasm
              sRetString = OpenFileRequester("Fasm", gConf\sPureBasic_Path+"compilers"+#System_Separator, "Fasm|fasm"+#System_ExtExec+"|"+LanguageItems(35)+" (*.*)|*.*",0)
              If sRetString
                gConf\sPath_FASM = sRetString
                SetGadgetText(#Window_1_String_2, gConf\sPath_FASM)
              EndIf
            ;}
            Case #Window_1_Button_3 ;{ Obj2Lib
              CompilerSelect #PB_Compiler_OS
                CompilerCase #PB_OS_Linux ;{
                  sRetString = OpenFileRequester("ar", "/usr/bin/ar", "ar|ar|"+LanguageItems(35)+" (*.*)|*.*",0)
                ;}
                CompilerCase #PB_OS_Windows ;{
                  sRetString = OpenFileRequester("Polib", gConf\sPureBasic_Path+"compilers\", "Polib |polib.exe|"+LanguageItems(35)+" (*.*)|*.*",0)
                ;}
              CompilerEndSelect              
              If sRetString
                gConf\sPath_OBJ2LIB = sRetString
                SetGadgetText(#Window_1_String_3, gConf\sPath_OBJ2LIB)
              EndIf
            ;}
            Case #Window_1_Button_4 ;{ LibMaker 
              CompilerSelect #PB_Compiler_OS
                CompilerCase #PB_OS_Linux ;{
                  sRetString = OpenFileRequester("Library Maker", gConf\sPureBasic_Path+"compilers"+#System_Separator, "LibMaker|pblibrarymaker"+#System_ExtExec+"|"+LanguageItems(35)+" (*.*)|*.*",0)
                ;}
                CompilerCase #PB_OS_Windows ;{
                  sRetString = OpenFileRequester("Library Maker", gConf\sPureBasic_Path+"compilers"+#System_Separator, "LibMaker|LibraryMaker"+#System_ExtExec+"|"+LanguageItems(35)+" (*.*)|*.*",0)
                ;}
              CompilerEndSelect
              If sRetString
                gConf\sPath_PBLIBMAKER = sRetString
                SetGadgetText(#Window_1_String_4, gConf\sPath_PBLIBMAKER)
              EndIf
            ;}
            Case #Window_1_Button_6 ;{ Validate Purebasic paths
              WinParamsPB_Validate(#True)
              If bPBParams_Valid = 5
                WinParamsPB_SaveIni()
                MessageRequester(LanguageItems(1), LanguageItems(43))
                M_GUI_EnableStep(#False, #True, #False)
                M_GUI_CloseWindow(1)
              EndIf
              
            ;}
            Case #Window_1_Button_7 ;{ Fermer
              If bPBParams_Valid = 5 ; enable step 2
                M_GUI_EnableStep(#False, #True, #False)
              EndIf
              M_GUI_CloseWindow(1)
            ;}
            
            Case #Window_1_String_0 ;{ PureBasic path
              sRetString = GetGadgetText(#Window_1_String_0)
              If sRetString And FileSize(sRetString) = -2
                gConf\sPureBasic_Path = sRetString
              EndIf
            ;}
            Case #Window_1_String_1 ;{ PbCompiler
              sRetString = GetGadgetText(#Window_1_String_1)
              If sRetString
                gConf\sPath_PBCOMPILER = sRetString
              EndIf
            ;}
            Case #Window_1_String_2 ;{ Fasm
              sRetString = GetGadgetText(#Window_1_String_2)
              If sRetString
                gConf\sPath_FASM = sRetString
              EndIf
            ;}
            Case #Window_1_String_3 ;{ OBJ2LIB
              sRetString = GetGadgetText(#Window_1_String_3)
              If sRetString
                gConf\sPath_OBJ2LIB = sRetString
              EndIf
            ;}
            Case #Window_1_String_4 ;{ PBLibMaker
              sRetString = GetGadgetText(#Window_1_String_4)
              If sRetString
                gConf\sPath_PBLIBMAKER = sRetString
              EndIf
            ;}
          EndSelect
        ;}
        Case #Window_2;{ Preferences
          Select lEvt_Gadget
            Case #Window_2_Button_0 ;{ Annuler
              M_GUI_CloseWindow(2)
            ;}
            Case #Window_2_Button_1 ;{ Sauver et Quitter
              ; Save Preferences for the GUI
              If OpenPreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini")
                PreferenceGroup("Main")
                WritePreferenceLong("AlwaysAskBeforeLoadingProject", GetGadgetState(#Window_2_CheckBox_0))
                WritePreferenceString("Language", GetGadgetText(#Window_2_Combo_0))
                  gGUIPrefs\lAlwaysAskBeforeLoadingProject = GetGadgetState(#Window_2_CheckBox_0)
                  gGUIPrefs\sLanguage = GetGadgetText(#Window_2_Combo_0)
                    Language_Load(gGUIPrefs\sLanguage)
                ClosePreferences()
              EndIf
              Language_Apply()
              M_GUI_CloseWindow(2)
            ;}
          EndSelect
        ;}
      EndSelect
    ;}
    Case #PB_Event_CloseWindow;{
      If lEvt_Window = #Window_0 And bAnotherWindowOpened = 0
        lQuit = #True
      Else
        If lEvt_Window = #Window_1
          If bPBParams_Valid = 5 ; enable step 2
            M_GUI_EnableStep(#False, #True, #False)
          EndIf
          M_GUI_CloseWindow(1)
        ElseIf lEvt_Window = #Window_2
          M_GUI_CloseWindow(2)
        EndIf
      EndIf
    ;}
  EndSelect
  If gStateOld <> gState
    If gState > #State_StepStart
      If gState > #State_StepLast
        gState - #State_StepLast 
        SetGadgetState(#Window_0_ProgressBar_0, gState)
        MessageRequester(LanguageItems(1), GetStringError(gError))
      Else
        SetGadgetState(#Window_0_ProgressBar_0, gState)
      EndIf
    EndIf
    gStateOld = gState
  EndIf
Until lQuit = #True
