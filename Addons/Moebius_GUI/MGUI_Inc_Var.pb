; Declaration
DeclareDLL GetDisableGadget(Gadget.l)

; Constants
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
  EndEnumeration

; Fonts
  Global FontID = LoadFont(0, "Arial", 28)

; Variables
  Global Evt_System.l
  Global Evt_Window.l
  Global Evt_Gadget.l
  Global Evt_Type.l
  Global lQuit.l = #False
  Global bWinPBParams_Opened.b
  Global sRetString.s
  Global bPBParams_Valid.b = #False
  Global bEnableLogEditor.b = #False
  Global cReturnMessageRequester.c
  
; Macros
Macro M_GUI_EnableStep2()
  If GetDisableGadget(#Button_11) = #True
    DisableGadget(#Button_11, #False)
  EndIf
  If GetDisableGadget(#Button_3) = #False
    DisableGadget(#Button_3, #True)
  EndIf
EndMacro
Macro M_GUI_ReloadProfiles()
  ClearGadgetItems(#Combo_1)
  AddGadgetItem(#Combo_1, 0, "=== Nouveau ===")
  AddGadgetItem(#Combo_1, 1, "Default")
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