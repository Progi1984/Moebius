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
    #Window_0
      #Window_0_Button_0
      #Window_0_Button_1
      #Window_0_Button_2
      #Window_0_Button_3
      #Window_0_Button_4
      #Window_0_Button_5
      #Window_0_Button_6
      #Window_0_Button_7
      #Window_0_Button_8
      #Window_0_CheckBox_0
      #Window_0_CheckBox_1
      #Window_0_CheckBox_2
      #Window_0_CheckBox_3
      #Window_0_CheckBox_4
      #Window_0_CheckBox_5
      #Window_0_CheckBox_6
      #Window_0_Combo_0
      #Window_0_Combo_1
      #Window_0_Editor_0
      #Window_0_Frame3D_0
      #Window_0_Frame3D_1
      #Window_0_Frame3D_2
      #Window_0_Frame3D_3
      #Window_0_Frame3D_4
      #Window_0_String_0
      #Window_0_String_1
      #Window_0_String_2
      #Window_0_String_3
      #Window_0_Text_0
      #Window_0_Text_1
      #Window_0_Text_2
      #Window_0_Text_3
      #Window_0_Text_4
      #Window_0_Text_5
      #Window_0_Text_6
      #Window_0_Text_7
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
    DisableGadget(#Window_0_Button_0, 1 - Step1)
    ; Step2
    DisableGadget(#Window_0_Button_4, 1 - Step2)
    ; Step3
    DisableGadget(#Window_0_Button_5, 1 - Step3)
    DisableGadget(#Window_0_CheckBox_6, 1 - Step3)
  EndMacro
  Macro M_Profil_GUIReload()
    ; clears the combo
    ClearGadgetItems(#Window_0_Combo_1)
    ; adds "New" Item
    AddGadgetItem(#Window_0_Combo_1, 0, "=== Nouveau ===")
    ; Load all groups name in profiles files, if existant
    If FileSize("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
      If OpenPreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
        If ExaminePreferenceGroups() > 0
          While NextPreferenceGroup()
            AddGadgetItem(#Window_0_Combo_1, -1, PreferenceGroupName())
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
      SetGadgetState(#Window_0_CheckBox_0, ReadPreferenceLong("Unicode", #False))
      SetGadgetState(#Window_0_CheckBox_1, ReadPreferenceLong("Threadsafe", #False))
      SetGadgetState(#Window_0_CheckBox_2, ReadPreferenceLong("Batch", #False))
      SetGadgetState(#Window_0_CheckBox_3, ReadPreferenceLong("Log", #False))
      SetGadgetState(#Window_0_CheckBox_4, ReadPreferenceLong("DontBuildLib", #False))
      SetGadgetState(#Window_0_CheckBox_5, ReadPreferenceLong("DontKeepSrcFiles", #False))
      ; String
      SetGadgetText(#Window_0_String_0, ReadPreferenceString("LibName", ""))
      SetGadgetText(#Window_0_String_1, ReadPreferenceString("Source", ""))
      SetGadgetText(#Window_0_String_2, ReadPreferenceString("HelpFile", ""))
      SetGadgetText(#Window_0_String_3, ReadPreferenceString("DirProject", ""))
    EndIf
    ; load project infos in structure
    gProject\bUnicode = GetGadgetState(#Window_0_CheckBox_0)
    gProject\bThreadSafe = GetGadgetState(#Window_0_CheckBox_1)
    gProject\bBatFile = GetGadgetState(#Window_0_CheckBox_2)
    gProject\bLogFile = GetGadgetState(#Window_0_CheckBox_3)
    gProject\bDontBuildLib = GetGadgetState(#Window_0_CheckBox_4)
    gProject\bDontKeepSrcFiles = 1-GetGadgetState(#Window_0_CheckBox_5)
    gProject\sFileName = GetGadgetText(#Window_0_String_1)
    gProject\sLibName = GetGadgetText(#Window_0_String_0)
    gProject\sFileCHM = GetGadgetText(#Window_0_String_2)
    gProject\sDirProject = GetGadgetText(#Window_0_String_3)
    If gProject\sDirProject <> "" And FileSize(gProject\sDirProject) = -2
      M_Moebius_InitDir(#True, #False, #False)
    EndIf
  EndMacro
  Macro M_GUI_CloseWindow(Fenetre)
    CloseWindow(#Window_#Fenetre)
    bAnotherWindowOpened - 1
    DisableWindow(#Window_0,#False)
    SetActiveWindow(#Window_0) 
  EndMacro
;}
