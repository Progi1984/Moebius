#Moebius_App = #True

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
Main_Open()
; Load Ini File with PB Paths
PBParams_LoadIni()
PBParams_Validate(#False)
Repeat
  Evt_System = WaitWindowEvent()
  Evt_Window = EventWindow()
  Evt_Gadget = EventGadget()
  Evt_Type = EventType()
  
  Select Evt_System
    Case #PB_Event_Gadget;{
      Select Evt_Window
        Case #Window_0;{
          Select Evt_Gadget
            Case #CheckBox_0 ;{ Unicode
              gProject\bUnicode = GetGadgetState(#CheckBox_0)
              M_GUI_EnableStep2()
            ;}
            Case #CheckBox_1 ;{ Threadsafe
              gProject\bThreadSafe = GetGadgetState(#CheckBox_1)
              M_GUI_EnableStep2()
            ;}
            Case #CheckBox_2 ;{ Batch
              gProject\bBatFile = GetGadgetState(#CheckBox_2)
              M_GUI_EnableStep2()
            ;}
            Case #CheckBox_3 ;{ Log
              gProject\bLogFile = GetGadgetState(#CheckBox_3)
              M_GUI_EnableStep2()
            ;}
            Case #CheckBox_4 ;{ Don't Build Lib
              gProject\bDontBuildLib = GetGadgetState(#CheckBox_4)
              M_GUI_EnableStep2()
            ;}
            Case #CheckBox_5 ;{ Don't Keep Src Files
              gProject\bDontKeepSrcFiles = 1-GetGadgetState(#CheckBox_5)
              M_GUI_EnableStep2()
            ;}
            Case #CheckBox_6 ;{ Enable Logging
              bEnableLogEditor = GetGadgetState(#CheckBox_6)
            ;}
          
            Case #Button_0 ;{ Browse "PureBasic Params"
              bWinPBParams_Opened = #True
              PBParams_Open()
            ;}
            Case #Button_1 ;{ Source File
              Define.b bIsCHM, bIsOutput
              sRetString = OpenFileRequester("Source File", "", "Fichiers Purebasic|*.pb;*.pbi|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gProject\sFileName = sRetString
                SetGadgetText(#String_1, gProject\sFileName)
                ; we define the name of projet if inexistant
                If GetGadgetText(#String_0) = ""
                  gProject\sLibName  = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)
                  SetGadgetText(#String_0, gProject\sLibName)
                  bIsOutput = #False
                EndIf
                ; we define the name of CHM if inexistant
                If GetGadgetText(#string_2) = ""
                  bIsCHM = #False
                Else
                  bIsCHM = #True
                EndIf
                gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
                M_Moebius_InitDir(bIsCHM, #False, bIsOutput)
                M_GUI_EnableStep2()
              EndIf
            ;}
            Case #Button_2 ;{ Help File
              sRetString = OpenFileRequester("Source File", "", "Fichiers d'aide|*"+#System_ExtHelp+"|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gProject\sFileCHM = sRetString
                SetGadgetText(#String_2, gProject\sFileCHM)
                M_GUI_EnableStep2()
              EndIf
            ;}
            Case #Button_3 ;{ Compile
              ; Clear the log editor
              ClearGadgetItems(#Editor_0)
              ; Clear variables before any compilation
              ClearList(LL_DLLFunctions())
              ClearList(LL_PBFunctions())
              ClearList(LL_Functions())
              ClearList(LL_LibUsed())
              ClearList(LL_DLLUsed())
              ClearList(LL_ImportUsed())
              ClearList(LL_ASM_extrn())
              hCompiler = #False
              hFileLog = #False
              hFileBatch = #False
              ; Launchs a thread for compilation
              CreateThread(@Moebius_MainThread(),0)
            ;}
            Case #Button_11 ;{ Validate before compilation
              If bPBParams_Valid = 5
                If gProject\sFileName <> "" And FileSize(gProject\sFileName) > 0
                  If gProject\sLibName = ""
                    gProject\sLibName = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)
                    gConf\sSourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                    gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
                    M_Moebius_InitDir(#True, #False, #True)
                    If GetGadgetText(#String_2) = ""
                      gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
                      SetGadgetText(#String_2, gProject\sFileCHM)
                    EndIf
                  EndIf
                  DisableGadget(#Button_3, #False)
                  DisableGadget(#CheckBox_6, #False)
                  MessageRequester("Moebius", "Ready to Compile :)")
                Else
                  DisableGadget(#Button_3, #True)
                  DisableGadget(#CheckBox_6, #True)
                  MessageRequester("Moebius", "Need a real purebasic source file for compiling")
                EndIf
              Else
                MessageRequester("Moebius", "But How do you come here ?")
              EndIf
            ;}
            Case #Button_13 ;{ 
              sRetString = PathRequester("Purebasic path", "")
              If sRetString
                gConf\sSourceDir = sRetString
                gProject\sDirProject = gConf\sSourceDir + gProject\sLibName + #System_Separator
                M_Moebius_InitDir(#True, #False, #True)
                If GetGadgetText(#String_2) = ""
                  gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
                  SetGadgetText(#String_2, gProject\sFileCHM)
                EndIf
                SetGadgetText(#String_8, gConf\sSourceDir)
                M_GUI_EnableStep2()
              EndIf            
            ;}
            Case #Button_14 ;{ Profil : Charger
              cReturnMessageRequester = MessageRequester("Moebius", "Voulez-vous vraiment charger le profil ?", #PB_MessageRequester_YesNo)
              If cReturnMessageRequester = #PB_MessageRequester_Yes
                If GetGadgetState(#Combo_1) = 1
                  SetGadgetState(#CheckBox_0, #False)
                  SetGadgetState(#CheckBox_1, #False)
                  SetGadgetState(#CheckBox_2, #False)
                  SetGadgetState(#CheckBox_3, #False)
                  SetGadgetState(#CheckBox_4, #False)
                  SetGadgetState(#CheckBox_5, #False)
                  
                  SetGadgetText(#String_1, "")
                  SetGadgetText(#String_0, "")
                  SetGadgetText(#String_2, "")
                  SetGadgetText(#String_8, "")
                  M_GUI_EnableStep2()
                Else
                  If FileSize("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
                    If OpenPreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                      If PreferenceGroup(GetGadgetItemText(#Combo_1, GetGadgetState(#Combo_1))) = #True
                        SetGadgetState(#CheckBox_0, ReadPreferenceLong("Unicode", #False))
                        SetGadgetState(#CheckBox_1, ReadPreferenceLong("Threadsafe", #False))
                        SetGadgetState(#CheckBox_2, ReadPreferenceLong("Batch", #False))
                        SetGadgetState(#CheckBox_3, ReadPreferenceLong("Log", #False))
                        SetGadgetState(#CheckBox_4, ReadPreferenceLong("DontBuildLib", #False))
                        SetGadgetState(#CheckBox_5, ReadPreferenceLong("DontKeepSrcFiles", #False))
                        
                        SetGadgetText(#String_1, ReadPreferenceString("Source", ""))
                        SetGadgetText(#String_0, ReadPreferenceString("LibName", ""))
                        SetGadgetText(#String_2, ReadPreferenceString("HelpFile", ""))
                        SetGadgetText(#String_8, ReadPreferenceString("DirProject", ""))
                        M_GUI_EnableStep2()
                      EndIf
                      ClosePreferences() 
                    EndIf
                  EndIf
                EndIf
              EndIf
            ;}
            Case #Button_15 ;{ Profil : Sauver
              If GetGadgetState(#Combo_1) = 0 Or GetGadgetState(#Combo_1) = 1
                sRetString = InputRequester("Moebius", "Nom du Modèle :", "Template"+Str(Random(SizeOf(Long))))
                If sRetString
                  If FileSize("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
                    OpenPreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                  Else
                    CreatePreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                  EndIf
                  PreferenceGroup(sRetString)
                  WritePreferenceLong("Unicode", GetGadgetState(#CheckBox_0))
                  WritePreferenceLong("Threadsafe", GetGadgetState(#CheckBox_1))
                  WritePreferenceLong("Batch", GetGadgetState(#CheckBox_2))
                  WritePreferenceLong("Log", GetGadgetState(#CheckBox_3))
                  WritePreferenceLong("DontBuildLib", GetGadgetState(#CheckBox_4))
                  WritePreferenceLong("DontKeepSrcFiles", GetGadgetState(#CheckBox_5))
                  
                  WritePreferenceString("LibName", GetGadgetText(#String_0))
                  WritePreferenceString("Source", GetGadgetText(#String_1))
                  WritePreferenceString("HelpFile", GetGadgetText(#String_2))
                  WritePreferenceString("DirProject", GetGadgetText(#String_8))
                  ClosePreferences() 
                  M_GUI_ReloadProfiles()
                EndIf
              Else
                If FileSize("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
                  If OpenPreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
                    If PreferenceGroup(GetGadgetItemText(#Combo_1, GetGadgetState(#Combo_1))) = #True
                      WritePreferenceLong("Unicode", GetGadgetState(#CheckBox_0))
                      WritePreferenceLong("Threadsafe", GetGadgetState(#CheckBox_1))
                      WritePreferenceLong("Batch", GetGadgetState(#CheckBox_2))
                      WritePreferenceLong("Log", GetGadgetState(#CheckBox_3))
                      WritePreferenceLong("DontBuildLib", GetGadgetState(#CheckBox_4))
                      WritePreferenceLong("DontKeepSrcFiles", GetGadgetState(#CheckBox_5))
                      
                      WritePreferenceString("LibName", GetGadgetText(#String_0))
                      WritePreferenceString("Source", GetGadgetText(#String_1))
                      WritePreferenceString("HelpFile", GetGadgetText(#String_2))
                      WritePreferenceString("DirProject", GetGadgetText(#String_8))
                    EndIf
                    ClosePreferences() 
                    M_GUI_ReloadProfiles()
                  EndIf
                EndIf
              EndIf
            ;}
            
            Case #String_0 ;{ LibName
              sRetString = GetGadgetText(#String_0)
              If sRetString 
                gProject\sLibName  = Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName))-1)
                M_GUI_EnableStep2()
              EndIf
            ;}
            Case #String_1 ;{ Source
              sRetString = GetGadgetText(#String_1)
              If sRetString 
                gProject\sFileName  = sRetString
                M_GUI_EnableStep2()
              EndIf
            ;}
            Case #String_2 ;{ Help File
              sRetString = GetGadgetText(#String_2)
              If sRetString 
                gProject\sFileCHM  = GetFilePart(sRetString)
                M_GUI_EnableStep2()
              EndIf
            ;}
            Case #String_8 ;{ DirProject
              sRetString = GetGadgetText(#String_8)
              If sRetString 
                If FileSize(sRetString) = -2
                  gProject\sDirProject  = sRetString
                  M_Moebius_InitDir(#True, #False, #False)
                  M_GUI_EnableStep2()
                EndIf
              EndIf
            ;}
          EndSelect
        ;}
        Case #Window_1;{
          Select Evt_Gadget
            Case #Button_4 ;{ Purebasic path
              sRetString = PathRequester("Purebasic path", "")
              If sRetString
                gConf\sPureBasic_Path = sRetString
                SetGadgetText(#String_3, gConf\sPureBasic_Path)
              EndIf
            ;}
            Case #Button_5 ;{ Compiler
              sRetString = OpenFileRequester("Compiler", gConf\sPureBasic_Path+"compilers"+#System_Separator, "Compiler|pbcompiler"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gConf\sPath_PBCOMPILER = sRetString
                SetGadgetText(#String_4, gConf\sPath_PBCOMPILER)
              EndIf
            ;}
            Case #Button_6 ;{ Fasm
              sRetString = OpenFileRequester("Fasm", gConf\sPureBasic_Path+"compilers"+#System_Separator, "Fasm|fasm"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gConf\sPath_FASM = sRetString
                SetGadgetText(#String_5, gConf\sPath_FASM)
              EndIf
            ;}
            Case #Button_7 ;{ Obj2Lib
              CompilerSelect #PB_Compiler_OS
                CompilerCase #PB_OS_Linux ;{
                  sRetString = OpenFileRequester("ar", "/usr/bin/ar", "ar|ar|Tous les fichiers (*.*)|*.*",0)
                ;}
                CompilerCase #PB_OS_Windows ;{
                  sRetString = OpenFileRequester("Polib", gConf\sPureBasic_Path+"compilers\", "Polib |polib.exe|Tous les fichiers (*.*)|*.*",0)
                ;}
              CompilerEndSelect              
              If sRetString
                gConf\sPath_OBJ2LIB = sRetString
                SetGadgetText(#String_6, gConf\sPath_OBJ2LIB)
              EndIf
            ;}
            Case #Button_8 ;{ LibMaker 
              CompilerSelect #PB_Compiler_OS
                CompilerCase #PB_OS_Linux ;{
                  sRetString = OpenFileRequester("Library Maker", gConf\sPureBasic_Path+"compilers"+#System_Separator, "LibMaker|pblibrarymaker"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
                ;}
                CompilerCase #PB_OS_Windows ;{
                  sRetString = OpenFileRequester("Library Maker", gConf\sPureBasic_Path+"compilers"+#System_Separator, "LibMaker|LibraryMaker"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
                ;}
              CompilerEndSelect
              If sRetString
                gConf\sPath_PBLIBMAKER = sRetString
                SetGadgetText(#String_7, gConf\sPath_PBLIBMAKER)
              EndIf
            ;}
            Case #Button_9 ;{ Validate Purebasic paths
              PBParams_Validate(#True)
            ;}
            Case #Button_10 ;{ Fermer
              CloseWindow(#Window_1)
              If bPBParams_Valid = 5
                DisableGadget(#Button_0, #True)
                DisableGadget(#Button_11, #False)
              EndIf
              bWinPBParams_Opened = #False
            ;}
            Case #Button_12 ;{ Sauver
              PBParams_SaveIni()
            ;}
            
            Case #String_3 ;{ PureBasic path
              sRetString = GetGadgetText(#String_3)
              If sRetString And FileSize(sRetString) = -2
                gConf\sPureBasic_Path = sRetString
                gConf\sPath_PBCOMPILER = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec
                gConf\sPath_FASM = gConf\sPureBasic_Path+"compilers"+#System_Separator+"fasm"+#System_ExtExec
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Windows;{
                    gConf\sPath_OBJ2LIB = gConf\sPureBasic_Path+"compilers"+#System_Separator+"polib"+#System_ExtExec
                    gConf\sPath_PBLIBMAKER = gConf\sPureBasic_Path+"SDK"+#System_Separator+"LibraryMaker"+#System_ExtExec
                  ;}
                  CompilerCase #PB_OS_Linux;{
                    gConf\sPath_OBJ2LIB = "/usr/bin/ar"
                    gConf\sPath_PBLIBMAKER = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pblibrarymaker"+#System_ExtExec
                  ;}
                CompilerEndSelect
                SetGadgetText(#String_4, gConf\sPath_PBCOMPILER)
                SetGadgetText(#String_5, gConf\sPath_FASM)
                SetGadgetText(#String_6, gConf\sPath_OBJ2LIB)
                SetGadgetText(#String_7, gConf\sPath_PBLIBMAKER)
              EndIf
            ;}
            Case #String_4 ;{ PbCompiler
              sRetString = GetGadgetText(#String_4)
              If sRetString
                gConf\sPath_PBCOMPILER = sRetString
              EndIf
            ;}
            Case #String_5 ;{ Fasm
              sRetString = GetGadgetText(#String_5)
              If sRetString
                gConf\sPath_FASM = sRetString
              EndIf
            ;}
            Case #String_6 ;{ OBJ2LIB
              sRetString = GetGadgetText(#String_6)
              If sRetString
                gConf\sPath_OBJ2LIB = sRetString
              EndIf
            ;}
            Case #String_7 ;{ PBLibMaker
              sRetString = GetGadgetText(#String_7)
              If sRetString
                gConf\sPath_PBLIBMAKER = sRetString
              EndIf
            ;}
          EndSelect
        ;}
      EndSelect
    ;}
    Case #PB_Event_CloseWindow;{
      If Evt_Window = #Window_0 And bWinPBParams_Opened = #False
        lQuit = #True
      EndIf
    ;}
  EndSelect
Until lQuit = #True
