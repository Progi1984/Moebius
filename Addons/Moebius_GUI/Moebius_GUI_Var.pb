;- Constants
Enumeration
  #Button_00
  #Button_01
  #Button_02
  #Button_03
  #Button_04
  #Button_05
  #Button_06
  #Button_07
  #Button_08
  #Button_09
  #Button_10
  #Button_11
  #Button_12
  #Button_13
  #Button_14
  #Button_15
  #Button_16
  #Button_17
  #Button_18
  #Button_19
  #Button_20
  #Button_21
  #CheckBox_00
  #CheckBox_01
  #CheckBox_02
  #CheckBox_03
  #CheckBox_04
  #CheckBox_05
  #CheckBox_06
  #CheckBox_07
  #CheckBox_08
  #CheckBox_09
  #CheckBox_10
  #ComboBox_00
  #ComboBox_01
  #ComboBox_02
  #ComboBox_03
  #ComboBox_04
  #Editor_00
  #Editor_01
  #Frame3D_00
  #Frame3D_01
  #Frame3D_02
  #Frame3D_03
  #Frame3D_04
  #Frame3D_05
  #Frame3D_06
  #Frame3D_07
  #Image_00
  #Image_01
  #Image_02
  #Image_03
  #Image_04
  #Panel_00
  #Panel_01
  #Panel_02
  #String_00
  #String_01
  #String_02
  #String_03
  #String_04
  #String_05
  #String_06
  #String_07
  #String_08
  #String_09
  #String_10
  #String_11
  #String_12
  #Text_00
  #Text_01
  #Text_02
  #Text_03
  #Text_04
  #Text_05
  #Text_06
  #Text_07
  #Text_08
  #Text_09
  #Text_10
  #Text_11
  #Text_12
  #Text_13
  #Text_14
  #Window_00
EndEnumeration

;- Structures
Structure S_MoebiusGUIPrefs
  lAlwaysAskBeforeLoadingProject.l
  sLanguage.s
EndStructure

;- Macros
Macro M_GUI_ProfilePB_Load()
  OpenPreferences(gsPath+"Prefs"+#System_Separator+"Profile_"+GetGadgetItemText(#ComboBox_01, GetGadgetState(#ComboBox_01))+".ini")
    PreferenceGroup("PATH")
      SetGadgetText(#String_00, ReadPreferenceString("PureBasic", PB_GetPBFolder()))
      ; PBCompiler
      If gConf\sPureBasic_Path <> ""
        psDefaultPath = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec
      Else
        psDefaultPath = ""
      EndIf
      SetGadgetText(#String_01, ReadPreferenceString("PBCompiler", psDefaultPath))
      ; PBFasm
      If gConf\sPureBasic_Path <> ""
        psDefaultPath = gConf\sPureBasic_Path+"compilers"+#System_Separator+"fasm"+#System_ExtExec
      Else
        psDefaultPath = ""
      EndIf
      SetGadgetText(#String_02, ReadPreferenceString("PBFasm", psDefaultPath))
      ; PBObj2Lib
      If gConf\sPureBasic_Path <> ""
        CompilerSelect #PB_Compiler_OS
          CompilerCase #PB_OS_Linux : psDefaultPath = "/usr/bin/ar"
          CompilerCase #PB_OS_MacOS : MessageRequester(dimLanguageItems(1), "Moebius_GUI_Func.pb")
          CompilerCase #PB_OS_Windows : psDefaultPath = gConf\sPureBasic_Path+"compilers"+#System_Separator+"fasm"+#System_ExtExec
        CompilerEndSelect
      Else
        psDefaultPath = ""
      EndIf
      SetGadgetText(#String_03, ReadPreferenceString("PBObj2Lib", psDefaultPath))
      ; PBLibMaker
      If gConf\sPureBasic_Path <> ""
        CompilerSelect #PB_Compiler_OS
          CompilerCase #PB_OS_Linux : psDefaultPath = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pblibrarymaker"+#System_ExtExec
          CompilerCase #PB_OS_MacOS : MessageRequester(dimLanguageItems(1), "Moebius_GUI_Func.pb")
          CompilerCase #PB_OS_Windows : psDefaultPath = gConf\sPureBasic_Path+"SDK"+#System_Separator+"LibraryMaker"+#System_ExtExec
        CompilerEndSelect
      Else
        psDefaultPath = ""
      EndIf
      SetGadgetText(#String_04, ReadPreferenceString("PBLibMaker", psDefaultPath))
  ClosePreferences()
EndMacro
Macro M_GUI_ProfilePB_ValidateAll()
  MoebiusGUI_ValidatePaths(#String_00)
  MoebiusGUI_ValidatePaths(#String_01)
  MoebiusGUI_ValidatePaths(#String_02)
  MoebiusGUI_ValidatePaths(#String_03)
  MoebiusGUI_ValidatePaths(#String_04)
EndMacro
Macro M_GUI_LanguageLoad(sLanguageName)
  Define.l dlNbItems
  If OpenPreferences(gsPath+"Prefs"+#System_Separator+"Lng_"+sLanguageName+".ini")
    PreferenceGroup("Main")
    ReDim dimLanguageItems.s(ReadPreferenceLong("NumItems",1))
    For dlNbItems = 1 To ReadPreferenceLong("NumItems",1)
      dimLanguageItems(dlNbItems - 1) = ReadPreferenceString("lng"+Str(dlNbItems - 1), "")
    Next
    ClosePreferences()
  Else
    MessageRequester("Moebius", "Criticial Error : No language file")
    End
  EndIf
EndMacro
Macro M_GUI_LanguageApply()
  SetGadgetFont(#Frame3D_02, FontID(0)) 
  ; Configuration
  SetGadgetItemText(#Panel_00, 0, dimLanguageItems(5))
    SetGadgetText(#Frame3D_00, dimLanguageItems(29))
      ;SetGadgetText(#Text_00, "")
      SetGadgetText(#Button_00, dimLanguageItems(14))
      ;SetGadgetText(#Text_01, "")
      SetGadgetText(#Button_01, dimLanguageItems(14))
      ;SetGadgetText(#Text_02, "")
      SetGadgetText(#Button_02, dimLanguageItems(14))
      ;SetGadgetText(#Text_03, "")
      SetGadgetText(#Button_03, dimLanguageItems(14))
      ;SetGadgetText(#Text_04, "")
      SetGadgetText(#Button_04, dimLanguageItems(14))
    SetGadgetText(#Frame3D_01, dimLanguageItems(22))
      SetGadgetText(#Text_05, dimLanguageItems(32)+" :")
      SetGadgetText(#CheckBox_00, dimLanguageItems(31))
    SetGadgetText(#Frame3D_02, dimLanguageItems(23))
      SetGadgetItemText(#ComboBox_01, 0, "<"+dimLanguageItems(0)+">")
      SetGadgetText(#Button_05, dimLanguageItems(24))
      SetGadgetText(#Button_06, dimLanguageItems(25))
  SetGadgetItemText(#Panel_00, 1, dimLanguageItems(2))
    SetGadgetText(#Text_06, dimLanguageItems(3)+" :")
    SetGadgetText(#Button_07, dimLanguageItems(14))
    SetGadgetItemText(#Panel_01, 0, dimLanguageItems(4)) ; SetGadgetFont(#Panel_01, FontID(0)) 
      SetGadgetText(#Frame3D_03, dimLanguageItems(5)) ; SetGadgetFont(#Frame3D_03, FontID(0)) 
        SetGadgetText(#CheckBox_01, dimLanguageItems(6))
        SetGadgetText(#CheckBox_02, dimLanguageItems(7))
        SetGadgetText(#CheckBox_03, dimLanguageItems(8))
        SetGadgetText(#CheckBox_04, dimLanguageItems(9))
      SetGadgetText(#Text_07, dimLanguageItems(19))
      SetGadgetText(#Text_08, dimLanguageItems(12))
      SetGadgetText(#Text_09, dimLanguageItems(16))
      SetGadgetText(#Button_19, dimLanguageItems(14))
      SetGadgetText(#Button_08, dimLanguageItems(18))
      SetGadgetText(#Frame3D_04, dimLanguageItems(23))
        SetGadgetText(#Button_09, dimLanguageItems(24))
        SetGadgetText(#Button_10, dimLanguageItems(25))
    SetGadgetItemText(#Panel_01, 1, dimLanguageItems(21))
      SetGadgetText(#Button_11, dimLanguageItems(20))
  SetGadgetItemText(#Panel_00, 2, dimLanguageItems(28))
    SetGadgetText(#Text_14, dimLanguageItems(3)+" :")
    SetGadgetText(#Button_12, dimLanguageItems(14))
    SetGadgetItemText(#Panel_02, 0, dimLanguageItems(4))
      SetGadgetText(#Frame3D_05, dimLanguageItems(5))
        SetGadgetText(#CheckBox_05, dimLanguageItems(6))
        SetGadgetText(#CheckBox_06, dimLanguageItems(7))
        SetGadgetText(#CheckBox_07, dimLanguageItems(8))
        SetGadgetText(#CheckBox_08, dimLanguageItems(9))
        SetGadgetText(#CheckBox_09, dimLanguageItems(10))
        SetGadgetText(#CheckBox_10, dimLanguageItems(11))
      SetGadgetText(#Text_10, dimLanguageItems(12))
      SetGadgetText(#Text_11, dimLanguageItems(16))
      SetGadgetText(#Button_13, dimLanguageItems(14))
      SetGadgetText(#Text_12, dimLanguageItems(15))
      SetGadgetText(#Button_14, dimLanguageItems(14))
      SetGadgetText(#Text_13, dimLanguageItems(17))
      SetGadgetText(#Button_15, dimLanguageItems(18))
      SetGadgetText(#Frame3D_06, dimLanguageItems(23))
        SetGadgetText(#Button_16, dimLanguageItems(24))
        SetGadgetText(#Button_17, dimLanguageItems(25))
    SetGadgetItemText(#Panel_02, 1, dimLanguageItems(30))
      SetGadgetText(#Button_18, dimLanguageItems(20))
EndMacro
Macro M_GUI_GetStringError(Error)
  dimLanguageItems(100+Error)
EndMacro

;- Globals
Global gsPath.s
CompilerIf #PB_Editor_CreateExecutable = #True
  gsPath = ""
CompilerElse
  gsPath = ".."+#System_Separator+".."+#System_Separator
CompilerEndIf

Global gGUIPrefs.S_MoebiusGUIPrefs
Global bEnableLogEditor.b = #False
Global Dim dimLanguageItems.s(0)