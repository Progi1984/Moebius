EnableExplicit
#Moebius_App = #True

Global gStateOld.l
Global glReturnValue.l

; Some includes must be included before others because of some specifics vars are called
IncludePath "../../"
  XIncludeFile "Inc_Declare.pb"
  XIncludeFile "Inc_Var.pb" 
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows : XIncludeFile "Inc_OS_Windows.pb"
    CompilerCase #PB_OS_Linux : XIncludeFile "Inc_OS_Linux.pb"
    CompilerCase #PB_OS_MacOS : XIncludeFile "Inc_OS_MacOS.pb"
  CompilerEndSelect

IncludePath "./"
  XIncludeFile "Moebius_GUI_Var.pb"
  XIncludeFile "Moebius_GUI_Func.pb"

IncludePath "../../"
  XIncludeFile "Moebius_Main.pb"

MoebiusGUI_Init()
MoebiusGUI_OpenWindow()
MoebiusGUI_InitGUI()

CompilerIf #PB_Compiler_Debugger = #False
  OnErrorCall(@Main_ErrorHandler())
CompilerEndIf

gStateOld = #State_StepStart
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_Gadget
      Select EventGadget()
        ; Configuration
        Case #Button_00       ;{ Browse > PureBasic Dir
          Define.s dsRetString
          dsRetString = PathRequester(dimLanguageItems(26), "")
          If dsRetString
            SetGadgetText(#String_00, dsRetString)
            MoebiusGUI_ValidatePaths(#String_00)
          EndIf
        ;}
        Case #Button_01       ;{ Browse > PBCompiler
          Define.s dsRetString
          dsRetString = OpenFileRequester(dimLanguageItems(27), GetGadgetText(#String_00)+"compilers"+#System_Separator, dimLanguageItems(27)+"|pbcompiler"+#System_ExtExec+"|"+dimLanguageItems(35)+" (*.*)|*.*",0)
          If dsRetString
            SetGadgetText(#String_01, dsRetString)
            MoebiusGUI_ValidatePaths(#String_01)
          EndIf
        ;}
        Case #Button_02       ;{ Browse > Fasm
          Define.s dsRetString
          dsRetString = OpenFileRequester("Fasm", GetGadgetText(#String_00)+"compilers"+#System_Separator, "Fasm|fasm"+#System_ExtExec+"|"+dimLanguageItems(35)+" (*.*)|*.*",0)
          If dsRetString
            SetGadgetText(#String_02, dsRetString)
            MoebiusGUI_ValidatePaths(#String_02)
          EndIf
        ;}
        Case #Button_03       ;{ Browse > Obj2Lib
          Define.s dsRetString
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Linux ;{
              dsRetString = OpenFileRequester("ar", "/usr/bin/ar", "ar|ar|"+dimLanguageItems(35)+" (*.*)|*.*",0)
            ;}
            CompilerCase #PB_OS_Windows ;{
              dsRetString = OpenFileRequester("Polib", GetGadgetText(#String_00)+"compilers\", "Polib |polib.exe|"+dimLanguageItems(35)+" (*.*)|*.*",0)
            ;}
          CompilerEndSelect
          If dsRetString
            SetGadgetText(#String_03, dsRetString)
            MoebiusGUI_ValidatePaths(#String_03)
          EndIf
        ;}
        Case #Button_04       ;{ Browse > LibMaker
          Define.s dsRetString
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Linux ;{
              dsRetString = OpenFileRequester("Library Maker", GetGadgetText(#String_00)+"compilers"+#System_Separator, "LibMaker|pblibrarymaker"+#System_ExtExec+"|"+dimLanguageItems(35)+" (*.*)|*.*",0)
            ;}
            CompilerCase #PB_OS_Windows ;{
              dsRetString = OpenFileRequester("Library Maker", GetGadgetText(#String_00)+"compilers"+#System_Separator, "LibMaker|LibraryMaker"+#System_ExtExec+"|"+dimLanguageItems(35)+" (*.*)|*.*",0)
            ;}
          CompilerEndSelect
          If dsRetString
            SetGadgetText(#String_04, dsRetString)
            MoebiusGUI_ValidatePaths(#String_04)
          EndIf
        ;}
        Case #Button_05       ;{ Load Profile
          ; Do you really want to load the profile ?
          glReturnValue = #False
          If GetGadgetState(#CheckBox_00) = #True
            If MessageRequester(dimLanguageItems(1), dimLanguageItems(41), #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
              glReturnValue = #True
            Else
              glReturnValue = #False
            EndIf
          Else
            glReturnValue = #True
          EndIf
          ; we load the profile
          If glReturnValue = #True
            Define.s psDefaultPath
            ; Loading Profile
            M_GUI_ProfilePB_Load()
            ; Validate paths
            M_GUI_ProfilePB_ValidateAll()
          EndIf
        ;}
        Case #Button_06       ;{ Save Profile
          Define.s dsFilename
          ; Do you really want to save the profile ?
          If GetGadgetState(#ComboBox_01) = 0 ; New Profile
            dsFilename = InputRequester(dimLanguageItems(1), dimLanguageItems(42), "")
          Else
            If MessageRequester(dimLanguageItems(1), ReplaceString(dimLanguageItems(33), "%1", Chr(34)+GetGadgetItemText(#ComboBox_01, GetGadgetState(#ComboBox_01))+Chr(34)), #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
              dsFilename = GetGadgetItemText(#ComboBox_01, GetGadgetState(#ComboBox_01))
            Else
              dsFilename = ""
            EndIf
          EndIf
          ; we save the profile
          If dsFilename <> ""
            CreatePreferences(gsPath+"Prefs"+#System_Separator+"Profile_"+dsFilename+".ini")
              PreferenceGroup("PATH")
              WritePreferenceString("PureBasic",GetGadgetText(#String_00))
              WritePreferenceString("PBCompiler",GetGadgetText(#String_01))
              WritePreferenceString("PBFasm",GetGadgetText(#String_02))
              WritePreferenceString("PBObj2Lib",GetGadgetText(#String_03))
              WritePreferenceString("PBLibMaker",GetGadgetText(#String_04))
            ClosePreferences()
          EndIf
        ;}
        Case #Button_20       ;{ Register PB IDE Plugin
          PureBasic_RegisterPlugin()
        ;}
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Case #Button_21       ;{ Register JaPBe Plugin
            JaPBe_RegisterPlugin()
          ;}
        CompilerEndIf
        Case #CheckBox_00   ;{ Always ask before loading a project
          ; save in preferences
          OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini")
            PreferenceGroup("Main")
            WritePreferenceLong("AlwaysAskBeforeLoadingProject", GetGadgetState(#CheckBox_00))
          ClosePreferences()
        ;}
        Case #ComboBox_00  ;{ Language
          Define.s dsReturnValue
          glReturnValue = #False
          ; save in preferences
          OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini")
            PreferenceGroup("Main")
            dsReturnValue = ReadPreferenceString("Language", "")
            If dsReturnValue <> GetGadgetItemText(#ComboBox_00, GetGadgetState(#ComboBox_00))
              WritePreferenceString("Language", GetGadgetItemText(#ComboBox_00, GetGadgetState(#ComboBox_00)))
              glReturnValue = #True
            EndIf
          ClosePreferences()
          ; apply language items
          If glReturnValue = #True
            M_GUI_LanguageLoad(GetGadgetItemText(#ComboBox_00, GetGadgetState(#ComboBox_00)))
            M_GUI_LanguageApply()
          EndIf
        ;}      
        ; Create a resident
        Case #Button_07       ;{ Browse > Main Source File
          Define.s dsRetString
          dsRetString = OpenFileRequester(dimLanguageItems(13), "", dimLanguageItems(36)+"|*.pb;*.pbi|"+dimLanguageItems(35)+" (*.*)|*.*",0)
          If dsRetString
            SetGadgetText(#String_08, dsRetString)
            ; Project Name
            SetGadgetText(#String_05, Left(GetFilePart(dsRetString), Len(GetFilePart(dsRetString)) - Len(GetExtensionPart(dsRetString)) - 1))
            ; Output File
            SetGadgetText(#String_06, Left(GetFilePart(dsRetString), Len(GetFilePart(dsRetString)) - Len(GetExtensionPart(dsRetString)) - 1))
            ; Working Directory
            SetGadgetText(#String_07, GetTemporaryDirectory()+ "Moebius" + #System_Separator + Left(GetFilePart(dsRetString), Len(GetFilePart(dsRetString)) - Len(GetExtensionPart(dsRetString)) - 1) + #System_Separator)
          EndIf
        ;}
        Case #Button_19       ;{ Browse > Working Directory
          Define.s dsRetString
          dsRetString = PathRequester(dimLanguageItems(16), GetGadgetText(#String_07))
          If dsRetString
            SetGadgetText(#String_07, dsRetString)
          EndIf
        ;}
        Case #Button_08       ;{ Valider
          Define.s dsMessage = ""
          ; Validate all paths
          If GetGadgetColor(#Image_00, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(34) + #System_EOL
          EndIf
          If GetGadgetColor(#Image_01, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(38) + #System_EOL
          EndIf
          If GetGadgetColor(#Image_02, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(39) + #System_EOL
          EndIf
          If GetGadgetColor(#Image_03, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Linux : dsMessage + dimLanguageItems(40) + #System_EOL
              CompilerCase #PB_OS_MacOS : MessageRequester(dimLanguageItems(1), "Main Loop : Event for #Button_08")
              CompilerCase #PB_OS_Windows : dsMessage + dimLanguageItems(43) + #System_EOL
            CompilerEndSelect
          EndIf
          If GetGadgetColor(#Image_04, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(44) + #System_EOL
          EndIf
          ; Validate main source filename
          If GetGadgetText(#String_08) = ""
            dsMessage + dimLanguageItems(45) + #System_EOL
          Else
            If FileSize(GetGadgetText(#String_08)) < 0
              dsMessage + dimLanguageItems(46) + #System_EOL
            EndIf
          EndIf
          If GetGadgetText(#String_05) = ""
            dsMessage + dimLanguageItems(47) + #System_EOL
          EndIf
          If GetGadgetText(#String_06) = ""
            dsMessage + dimLanguageItems(48) + #System_EOL
          EndIf
          
          If dsMessage = ""
            dsMessage = dimLanguageItems(37)
            SetGadgetState(#Panel_01, 1)
            SetActiveGadget(#Button_11)
            DisableGadget(#Button_11, #False)
          Else
            DisableGadget(#Button_11, #True)
          EndIf
          MessageRequester(dimLanguageItems(1), dsMessage)
        ;}
        Case #Button_09       ;{ Load Profile
          If GetGadgetState(#ComboBox_02) > 0 
            If GetGadgetState(#ComboBox_02) <  CountGadgetItems(#ComboBox_02) - 1
              OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_ProfilesResident.ini")
                PreferenceGroup(GetGadgetItemText(#ComboBox_02, GetGadgetState(#ComboBox_02)))
                  SetGadgetText(#String_08, ReadPreferenceString("Source", ""))
                  SetGadgetState(#CheckBox_01, ReadPreferenceLong("Unicode", #False))
                  SetGadgetState(#CheckBox_02, ReadPreferenceLong("Threadsafe", #False))
                  SetGadgetState(#CheckBox_03, ReadPreferenceLong("Batch", #False))
                  SetGadgetState(#CheckBox_04, ReadPreferenceLong("Log", #False))
                  SetGadgetText(#String_05, ReadPreferenceString("LibName", ""))
                  SetGadgetText(#String_06, ReadPreferenceString("OutputFile", ""))
                  SetGadgetText(#String_07, ReadPreferenceString("DirProject", ""))
              ClosePreferences()
            EndIf
          EndIf
        ;}
        Case #Button_10       ;{ Save profile
          Define.s dsGroupName
          If GetGadgetState(#ComboBox_02) = 0 
            dsGroupName = InputRequester(dimLanguageItems(1), dimLanguageItems(42), "")
          Else
            dsGroupName = GetGadgetItemText(#ComboBox_02, GetGadgetState(#ComboBox_02))
          EndIf
          If dsGroupName <> ""
            OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_ProfilesResident.ini")
              PreferenceGroup(dsGroupName)
                WritePreferenceString("Source", GetGadgetText(#String_08))
                WritePreferenceLong("Unicode", GetGadgetState(#CheckBox_01))
                WritePreferenceLong("Threadsafe", GetGadgetState(#CheckBox_02))
                WritePreferenceLong("Batch", GetGadgetState(#CheckBox_03))
                WritePreferenceLong("Log", GetGadgetState(#CheckBox_04))
                WritePreferenceString("LibName", GetGadgetText(#String_05))
                WritePreferenceString("OutputFile", GetGadgetText(#String_06))
                WritePreferenceString("DirProject", GetGadgetText(#String_07))
            ClosePreferences()
          EndIf
        ;}
        Case #Button_11       ;{ Build
          If gState = #State_StepStart
            gProject\sFileName = GetGadgetText(#String_08)
            gProject\bTypeOutput =  #TypeOutput_Resident
            gProject\sFileOutput = GetGadgetText(#String_06)
            gProject\sLibName = GetGadgetText(#String_05)
            gProject\sDirProject = GetGadgetText(#String_07)
            gProject\bUnicode = GetGadgetState(#CheckBox_01)
            gProject\bThreadSafe = GetGadgetState(#CheckBox_02)
            gProject\bInlineASM = GetGadgetState(#CheckBox_11)
            gProject\bLogFile = GetGadgetState(#CheckBox_03)
            gProject\bBatFile = GetGadgetState(#CheckBox_04)
  
            gConf\sPureBasic_Path = GetGadgetText(#String_00)
            gConf\sPath_PBCOMPILER = GetGadgetText(#String_01)
            gConf\sPath_FASM = GetGadgetText(#String_02)
            gConf\sPath_OBJ2LIB = GetGadgetText(#String_03)
            gConf\sPath_PBLIBMAKER = GetGadgetText(#String_04)
            gConf\sSourceDir = GetGadgetText(#String_07)
            
            ; No for CHM, ? for Log, Yes for Output
            M_Moebius_InitDir(#False, 1 - GetGadgetState(#CheckBox_03), #True) 
            
            ; Cleans all variables before a new building
            M_ClearBeforeBuilding()
            ; Output a log in Editorgadget
            bEnableLogEditor = #True
            ; Launchs a thread for compilation
            CreateThread(@Moebius_MainThread(),0)
          EndIf
        ;}
        ; Create an userlib from PB
        Case #Button_12       ;{ Browse > Main Source File
          Define.s dsRetString
          dsRetString = OpenFileRequester(dimLanguageItems(13), "", dimLanguageItems(36)+"|*.pb;*.pbi|"+dimLanguageItems(35)+" (*.*)|*.*",0)
          If dsRetString
            SetGadgetText(#String_09, dsRetString)
            ; Project Name
            SetGadgetText(#String_10, Left(GetFilePart(dsRetString), Len(GetFilePart(dsRetString)) - Len(GetExtensionPart(dsRetString)) - 1))
            ; Working Directory
            SetGadgetText(#String_11, GetTemporaryDirectory()+ "Moebius" + #System_Separator + Left(GetFilePart(dsRetString), Len(GetFilePart(dsRetString)) - Len(GetExtensionPart(dsRetString)) - 1) + #System_Separator)
          EndIf
        ;}
        Case #Button_13       ;{ Browse > Working Directory
          Define.s dsRetString
          dsRetString = PathRequester(dimLanguageItems(16), GetGadgetText(#String_07))
          If dsRetString
            SetGadgetText(#String_11, dsRetString)
          EndIf
        ;}
        Case #Button_14       ;{ Help File
          Define.s dsRetString
          dsRetString = OpenFileRequester(dimLanguageItems(15), "", dimLanguageItems(15)+"|*"+#System_ExtHelp+"|"+dimLanguageItems(35)+" (*.*)|*.*",0)
          If dsRetString
            SetGadgetText(#String_12, dsRetString)
          EndIf
        ;}
        Case #Button_15       ;{ Valider
          Define.s dsMessage = ""
          ; Validate all paths
          If GetGadgetColor(#Image_00, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(34) + #System_EOL
          EndIf
          If GetGadgetColor(#Image_01, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(38) + #System_EOL
          EndIf
          If GetGadgetColor(#Image_02, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(39) + #System_EOL
          EndIf
          If GetGadgetColor(#Image_03, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Linux : dsMessage + dimLanguageItems(40) + #System_EOL
              CompilerCase #PB_OS_MacOS : MessageRequester(dimLanguageItems(1), "Main Loop : Event for #Button_08")
              CompilerCase #PB_OS_Windows : dsMessage + dimLanguageItems(43) + #System_EOL
            CompilerEndSelect
          EndIf
          If GetGadgetColor(#Image_04, #PB_Gadget_BackColor) = RGB(255, 0, 0)
            dsMessage + dimLanguageItems(44) + #System_EOL
          EndIf
          ; Validate main source filename
          If GetGadgetText(#String_09) = ""
            dsMessage + dimLanguageItems(45) + #System_EOL
          Else
            If FileSize(GetGadgetText(#String_09)) < 0
              dsMessage + dimLanguageItems(46) + #System_EOL
            EndIf
          EndIf
          If GetGadgetText(#String_10) = ""
            dsMessage + dimLanguageItems(47) + #System_EOL
          EndIf
          
          If dsMessage = ""
            dsMessage = dimLanguageItems(37)
            SetGadgetState(#Panel_02, 1)
            SetActiveGadget(#Button_18)
            DisableGadget(#Button_18, #False)
          Else
            DisableGadget(#Button_18, #True)
          EndIf
          MessageRequester(dimLanguageItems(1), dsMessage)
        ;}
        Case #Button_16       ;{ Load Profile
          If GetGadgetState(#ComboBox_03) > 0 
            If GetGadgetState(#ComboBox_03) <=  CountGadgetItems(#ComboBox_03) 
              OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_ProfilesUserLib.ini")
                PreferenceGroup(GetGadgetItemText(#ComboBox_03, GetGadgetState(#ComboBox_03)))
                  SetGadgetText(#String_09, ReadPreferenceString("Source", ""))
                  SetGadgetState(#CheckBox_05, ReadPreferenceLong("Unicode", #False))
                  SetGadgetState(#CheckBox_06, ReadPreferenceLong("Threadsafe", #False))
                  SetGadgetState(#CheckBox_07, ReadPreferenceLong("Batch", #False))
                  SetGadgetState(#CheckBox_08, ReadPreferenceLong("Log", #False))
                  SetGadgetState(#CheckBox_09, ReadPreferenceLong("DontBuildLib", #False))
                  SetGadgetState(#CheckBox_10, ReadPreferenceLong("DontKeepSrcFiles", #False))
                  SetGadgetText(#String_10, ReadPreferenceString("LibName", ""))
                  SetGadgetText(#String_11, ReadPreferenceString("DirProject", ""))
                  SetGadgetText(#String_12, ReadPreferenceString("HelpFile", ""))
              ClosePreferences()
            EndIf
          EndIf
        ;}
        Case #Button_17       ;{ Save Profile
          Define.s dsGroupName
          If GetGadgetState(#ComboBox_03) = 0 
            dsGroupName = InputRequester(dimLanguageItems(1), dimLanguageItems(42), GetGadgetText(#String_10))
          Else
            dsGroupName = GetGadgetItemText(#ComboBox_03, GetGadgetState(#ComboBox_03))
          EndIf
          If dsGroupName <> ""
            Debug OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_ProfilesUserLib.ini")
              PreferenceGroup(dsGroupName)
                WritePreferenceString("Source", GetGadgetText(#String_09))
                WritePreferenceLong("Unicode", GetGadgetState(#CheckBox_05))
                WritePreferenceLong("Threadsafe", GetGadgetState(#CheckBox_06))
                WritePreferenceLong("Batch", GetGadgetState(#CheckBox_07))
                WritePreferenceLong("Log", GetGadgetState(#CheckBox_08))
                WritePreferenceLong("DontBuildLib", GetGadgetState(#CheckBox_09))
                WritePreferenceLong("DontKeepSrcFiles", GetGadgetState(#CheckBox_10))
                WritePreferenceString("LibName", GetGadgetText(#String_10))
                WritePreferenceString("DirProject", GetGadgetText(#String_11))
                WritePreferenceString("HelpFile", GetGadgetText(#String_12))
            ClosePreferences()
          EndIf
        ;}
        Case #Button_18       ;{ Build
          If gState = #State_StepStart
            gProject\sFileName = GetGadgetText(#String_09)
            gProject\bTypeOutput =  #TypeOutput_UserLib
            gProject\sFileOutput = GetGadgetText(#String_10)
            gProject\sFileCHM = GetGadgetText(#String_12)
            gProject\sLibName = GetGadgetText(#String_10)
            gProject\sDirProject = GetGadgetText(#String_11)
            gProject\bUnicode = GetGadgetState(#CheckBox_05)
            gProject\bThreadSafe = GetGadgetState(#CheckBox_06)
            gProject\bInlineASM = GetGadgetState(#CheckBox_12)
            gProject\bLogFile = GetGadgetState(#CheckBox_07)
            gProject\bLogInStreaming = GetGadgetState(#CheckBox_07)
            gProject\bBatFile = GetGadgetState(#CheckBox_08)
            gProject\bDontBuildLib = GetGadgetState(#CheckBox_09)
            gProject\bDontKeepSrcFiles = 1 - GetGadgetState(#CheckBox_10)
  
            gConf\sPureBasic_Path = GetGadgetText(#String_00)
            gConf\sPath_PBCOMPILER = GetGadgetText(#String_01)
            gConf\sPath_FASM = GetGadgetText(#String_02)
            gConf\sPath_OBJ2LIB = GetGadgetText(#String_03)
            gConf\sPath_PBLIBMAKER = GetGadgetText(#String_04)
            gConf\sSourceDir = GetGadgetText(#String_07)
            
            ; No or Yes for CHM, ? for Log, Yes for Output
            If GetGadgetText(#String_12) = ""
              M_Moebius_InitDir(#False, 1- GetGadgetState(#CheckBox_07), #True) 
            Else
              M_Moebius_InitDir(#True, 1- GetGadgetState(#CheckBox_07), #True) 
            EndIf
            
            ; Cleans all variables before a new building
            M_ClearBeforeBuilding()
            ; Output a log in Editorgadget
            bEnableLogEditor = #True
            ; Launchs a thread for compilation
            Moebius_MainThread(0)
          EndIf
        ;}
      EndSelect
    Case #PB_Event_CloseWindow
      Select EventWindow()
        Case #Window_00
          CloseWindow(#Window_00)
          Break
      EndSelect
  EndSelect
  ; Log & Error Management
  If gStateOld <> gState
    If gState >= #State_StepLast
      CompilerIf #PB_Compiler_Version = 440
        If bEnableLogEditor = #True
          If gProject\bTypeOutput = #TypeOutput_Resident
            If IsGadget(#Editor_00) <> 0
              ForEach LL_Logs()
                AddGadgetItem(#Editor_00, -1, LL_Logs())
              Next
            EndIf
          ElseIf gProject\bTypeOutput = #TypeOutput_UserLib
            If IsGadget(#Editor_01) <> 0
              ForEach LL_Logs()
                AddGadgetItem(#Editor_01, -1, LL_Logs())
              Next
            EndIf
          EndIf
        EndIf
      CompilerEndIf
      If gState > #State_StepLast
        gState - #State_StepLast 
        Protected psMRContent.s
        psMRContent = M_GUI_GetStringError(gError)
        If gsErrorContent <> ""
          psMRContent + #System_EOL
          psMRContent + dimLanguageItems(54)+":"
          psMRContent + #System_EOL
          psMRContent + gsErrorContent
        EndIf
        MessageRequester(dimLanguageItems(1), psMRContent)
        gState = #State_StepStart
      EndIf
    EndIf
    gStateOld = gState
  EndIf
ForEver
