;{ Declarations
  DeclareDLL WinMain_Create()
  DeclareDLL WinParamsPB_Create()
  DeclareDLL WinParamsPB_Validate(InWindow.b)
  DeclareDLL WinParamsPB_LoadIni()
  DeclareDLL WinParamsPB_SaveIni()
  DeclareDLL WinPrefs_Create()
  DeclareDLL Misc_GetDisableGadget(Gadget.l)
;}
;{ Constants
  Enumeration
    #Button_0
    #Button_1
    #Button_2
    #Button_3
    #Button_4
    #Button_5
    #Button_6
    #Button_7
    #Button_8
    #Button_9
    #Button_10
    #Button_11
    #Button_12
    #Button_13
    #Button_14
    #Button_15
    #Button_16
    #Combo_0
    #Combo_1
    #CheckBox_0
    #CheckBox_1
    #CheckBox_2
    #CheckBox_3
    #CheckBox_4
    #CheckBox_5
    #CheckBox_6
    #Editor_0
    #Frame3D_0
    #Frame3D_1
    #Frame3D_2
    #Frame3D_3
    #Frame3D_4
    #String_0
    #String_1
    #String_2
    #String_3
    #String_4
    #String_5
    #String_6
    #String_7
    #String_8
    #Text_0
    #Text_1
    #Text_2
    #Text_3
    #Text_4
    #Text_5
    #Text_6
    #Text_7
    #Text_8
    #Text_9
    #Text_10
    #Text_11
    #Text_12
    #Text_13
    #Text_14
    #Text_15
    #Text_16
    #Text_17
    #Window_0
    #Window_1
      #Window_1_Button_0
      #Window_1_Button_1
      #Window_1_Button_2
      #Window_1_Button_3
      #Window_1_Button_4
      #Window_1_Button_5
      #Window_1_Button_6
      #Window_1_Button_7
      #Window_1_String_0
      #Window_1_String_1
      #Window_1_String_2
      #Window_1_String_3
      #Window_1_String_4
      #Window_1_Text_0
      #Window_1_Text_1
      #Window_1_Text_2
      #Window_1_Text_3
      #Window_1_Text_4
      #Window_1_Text_5
      #Window_1_Text_6
      #Window_1_Text_7
      #Window_1_Text_8
      #Window_1_Text_9
    #Window_2
      #Window_2_CheckBox_0
      #Window_2_Button_0
      #Window_2_Button_1
  EndEnumeration
;}
;{ Structures
  Structure S_MoebiusGUIPrefs
    lAlwaysAskBeforeLoadingProject.l
  EndStructure
;}
;{ Variables
  Global lFont_Arial28 = LoadFont(#PB_Any, "Arial", 28)

  Global lEvt_System.l
  Global lEvt_Window.l
  Global lEvt_Gadget.l
  Global lEvt_Type.l
  Global lQuit.l = #False

  Global sRetString.s

  Global bPBParams_Valid.b = #False
  Global bEnableLogEditor.b = #False
  Global bAnotherWindowOpened.b

  Global cReturnMessageRequester.c
  
  Global gGUIPrefs.S_MoebiusGUIPrefs
;}
;{ Macros
  Macro M_GUI_EnableStep(Step1, Step2, Step3)
    ; Step1
    DisableGadget(#Button_0, 1 - Step1)
    ; Step2
    DisableGadget(#Button_11, 1 - Step2)
    ; Step3
    DisableGadget(#Button_3, 1 - Step3)
    DisableGadget(#Checkbox_6, 1 - Step3)
  EndMacro
  Macro M_Profil_GUIReload()
    ; clears the combo
    ClearGadgetItems(#Combo_1)
    ; adds "New" Item
    AddGadgetItem(#Combo_1, 0, "=== Nouveau ===")
    ; Load all groups name in profiles files, if existant
    If FileSize("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
      If OpenPreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
        If ExaminePreferenceGroups() > 0
          While NextPreferenceGroup()
            AddGadgetItem(#Combo_1, -1, PreferenceGroupName())
          Wend 
        EndIf
        ClosePreferences()
      EndIf
    EndIf
  EndMacro
  Macro M_Profil_Load(ContainsInfos = #False)
    ; if the prefs file is here and we want to load data.
    If ContainsInfos = #True
      ; Long
      SetGadgetState(#CheckBox_0, ReadPreferenceLong("Unicode", #False))
      SetGadgetState(#CheckBox_1, ReadPreferenceLong("Threadsafe", #False))
      SetGadgetState(#CheckBox_2, ReadPreferenceLong("Batch", #False))
      SetGadgetState(#CheckBox_3, ReadPreferenceLong("Log", #False))
      SetGadgetState(#CheckBox_4, ReadPreferenceLong("DontBuildLib", #False))
      SetGadgetState(#CheckBox_5, ReadPreferenceLong("DontKeepSrcFiles", #False))
      ; String
      SetGadgetText(#String_1, ReadPreferenceString("Source", ""))
      SetGadgetText(#String_0, ReadPreferenceString("LibName", ""))
      SetGadgetText(#String_2, ReadPreferenceString("HelpFile", ""))
      SetGadgetText(#String_8, ReadPreferenceString("DirProject", ""))
    EndIf
    ; load project infos in structure
    gProject\bUnicode = GetGadgetState(#CheckBox_0)
    gProject\bThreadSafe = GetGadgetState(#CheckBox_1)
    gProject\bBatFile = GetGadgetState(#CheckBox_2)
    gProject\bLogFile = GetGadgetState(#CheckBox_3)
    gProject\bDontBuildLib = GetGadgetState(#CheckBox_4)
    gProject\bDontKeepSrcFiles = 1-GetGadgetState(#CheckBox_5)
    gProject\sFileName = GetGadgetText(#String_1)
    gProject\sLibName = GetGadgetText(#String_0)
    gProject\sFileCHM = GetGadgetText(#String_2)
    gProject\sDirProject = GetGadgetText(#String_8)
    If gProject\sDirProject <> "" And FileSize(gProject\sDirProject) = -2
      M_Moebius_InitDir(#True, #False, #False)
    EndIf
  EndMacro
;}
