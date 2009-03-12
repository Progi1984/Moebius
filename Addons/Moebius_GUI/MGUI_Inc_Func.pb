;@desc Opens the main window for Moebius
ProcedureDLL WinMain_Create()
  If OpenPreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini")
    PreferenceGroup("Main")
      gGUIPrefs\lAlwaysAskBeforeLoadingProject = ReadPreferenceLong("AlwaysAskBeforeLoadingProject", #False)
      gGUIPrefs\sLanguage = ReadPreferenceString("Language", "French")
      Debug gGUIPrefs\sLanguage
      Language_Load(gGUIPrefs\sLanguage)
    ClosePreferences()
  EndIf
  If OpenWindow(#Window_0, 353, 5, 600, 575, LanguageItems(1),  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
    Frame3DGadget(#Window_0_Frame3D_0, 10, 10, 580, 70, LanguageItems(2)+" 1 : Purebasic") ;{
      TextGadget(#Window_0_Text_0, 80, 40, 40, 20, LanguageItems(3)+" : ")
      ButtonGadget(#Window_0_Button_0, 450, 30, 130, 40, LanguageItems(4))
      TextGadget(#Window_0_Text_1, 250, 30, 100, 40, "NOK", #PB_Text_Center)
        SetGadgetFont(#Window_0_Text_1, FontID(lFont_Arial28))
        SetGadgetColor(#Window_0_Text_1, #PB_Gadget_FrontColor, RGB(255, 0, 0))
    ;}
    Frame3DGadget(#Window_0_Frame3D_1, 10, 80, 580, 260, LanguageItems(2)+" 2 : "+LanguageItems(5)) ;{
      CheckBoxGadget(#Window_0_CheckBox_0, 30, 100, 250, 20, LanguageItems(6))
      CheckBoxGadget(#Window_0_CheckBox_1, 330, 100, 250, 20, LanguageItems(7))
      CheckBoxGadget(#Window_0_CheckBox_2, 30, 130, 250, 20, LanguageItems(8))
      CheckBoxGadget(#Window_0_CheckBox_3, 330, 130, 250, 20, LanguageItems(9))
      CheckBoxGadget(#Window_0_CheckBox_4, 30, 160, 290, 20, LanguageItems(10))
      CheckBoxGadget(#Window_0_CheckBox_5, 330, 160, 250, 20, LanguageItems(11))
        gProject\bDontKeepSrcFiles = #True
      
      TextGadget(#Window_0_Text_2, 30, 190, 120, 20, LanguageItems(12)+" :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#Window_0_String_0, 160, 186, 330, 28, "")
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#Window_0_String_0, 160, 190, 330, 20, "")
        ;}      
      CompilerEndSelect
      
      TextGadget(#Window_0_Text_3, 30, 220, 120, 20, LanguageItems(13)+" :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#Window_0_String_1, 160, 216, 330, 28, "")
          ButtonGadget(#Window_0_Button_1, 500, 216, 80, 28, LanguageItems(14))
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#Window_0_String_1, 160, 220, 330, 20, "")
          ButtonGadget(#Window_0_Button_1, 500, 220, 80, 20, LanguageItems(14))
        ;}      
      CompilerEndSelect
      
      TextGadget(#Window_0_Text_4, 30, 250, 120, 20, LanguageItems(15)+" :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#Window_0_String_2, 160, 246, 330, 28, "")
          ButtonGadget(#Window_0_Button_2, 500, 246, 80, 28, LanguageItems(14))
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#Window_0_String_2, 160, 250, 330, 20, "")
          ButtonGadget(#Window_0_Button_2, 500, 250, 80, 20, LanguageItems(14))
        ;}      
      CompilerEndSelect
      
      TextGadget(#Window_0_Text_5, 30, 280, 120, 20, LanguageItems(16)+" :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#Window_0_String_3, 160, 276, 330, 28, "")
          ButtonGadget(#Window_0_Button_3, 500, 276, 80, 28, LanguageItems(14))
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#Window_0_String_3, 160, 280, 330, 20, "")
          ButtonGadget(#Window_0_Button_3, 500, 280, 80, 20, LanguageItems(14))
        ;}      
      CompilerEndSelect

      TextGadget(#Window_0_Text_6, 30, 310, 120, 20, LanguageItems(17)+" :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          ComboBoxGadget(#Window_0_Combo_0, 160, 306, 330, 28)
          ButtonGadget(#Window_0_Button_4, 500, 306, 80, 28, LanguageItems(18))
        ;}
        CompilerCase #PB_OS_Windows;{
          ComboBoxGadget(#Window_0_Combo_0, 160, 306, 330, 20)
          ButtonGadget(#Window_0_Button_4, 500, 306, 80, 20, LanguageItems(18))
        ;}      
      CompilerEndSelect
        DisableGadget(#Window_0_Button_4, #True)
    ;}
    Frame3DGadget(#Window_0_Frame3D_2, 10, 340, 580, 180, LanguageItems(2)+" 3 : "+LanguageItems(19)) ;{
      ButtonGadget(#Window_0_Button_5, 20, 356, 110, 28, LanguageItems(20))
        DisableGadget(#Window_0_Button_5, #True)
      CheckBoxGadget(#Window_0_CheckBox_6, 140, 356, 110, 28, LanguageItems(21))
        DisableGadget(#Window_0_CheckBox_6, #True)
      ProgressBarGadget(#Window_0_ProgressBar_0, 20, 385, 560, 20, #State_Step0, #State_Step6, #PB_ProgressBar_Smooth)
      EditorGadget(#Window_0_Editor_0, 20, 410, 560, 100, #PB_Editor_ReadOnly)
    ;}
    Frame3DGadget(#Window_0_Frame3D_3, 10, 520, 90, 50, "") ;{ Préférences
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          ButtonGadget(#Window_0_Button_6, 20, 536, 70, 28, LanguageItems(22))
        ;}
        CompilerCase #PB_OS_Windows;{
          ButtonGadget(#Window_0_Button_6, 20, 536, 70, 20, LanguageItems(22))
        ;}
      CompilerEndSelect
    ;}
    Frame3DGadget(#Window_0_Frame3D_4, 100, 520, 490, 50, "") ;{
      TextGadget(#Window_0_Text_7, 110, 540, 30, 20, LanguageItems(23)+" :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          ComboBoxGadget(#Window_0_Combo_1, 160, 536, 250, 28)
          ButtonGadget(#Window_0_Button_7, 415, 536, 80, 28, LanguageItems(24))
          ButtonGadget(#Window_0_Button_8, 500, 536, 80, 28, LanguageItems(25))
        ;}
        CompilerCase #PB_OS_Windows;{
          ComboBoxGadget(#Window_0_Combo_1, 160, 536, 250, 20)
          ButtonGadget(#Window_0_Button_7, 420, 536, 80, 20, LanguageItems(24))
          ButtonGadget(#Window_0_Button_8, 500, 536, 80, 20, LanguageItems(25))
        ;}      
      CompilerEndSelect
        M_Profil_GUIReload()
        ; Load the default preference group if existant
        If FileSize(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
          If OpenPreferences(sPath+"Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
            If ExaminePreferenceGroups() > 0
              While NextPreferenceGroup()
                If LCase(PreferenceGroupName()) = "default"
                  M_Profil_Load(#True)
                  Break
                EndIf
              Wend 
            EndIf
            ClosePreferences()
          EndIf
        EndIf
        SetGadgetState(#Window_0_Combo_1, 0)
    ;}
  EndIf
EndProcedure

;@desc Set Purebasic params
ProcedureDLL WinParamsPB_Create()
  If OpenWindow(#Window_1, 488, 98, 520, 200, LanguageItems(1)+" : PureBasic",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
    TextGadget(#Window_1_Text_0, 10, 10, 110, 20, LanguageItems(26)+" :", #PB_Text_Center)
    StringGadget(#Window_1_String_0, 130, 10, 260, 20, "")
      SetGadgetText(#Window_1_String_0, gConf\sPureBasic_Path)
    ButtonGadget(#Window_1_Button_0, 400, 6, 80, 28, LanguageItems(14))
    TextGadget(#Window_1_Text_1, 486, 6, 28, 28, "")
      SetGadgetColor(#Window_1_Text_1, #PB_Gadget_BackColor, RGB(255, 0, 0))

    TextGadget(#Window_1_Text_2, 10, 40, 110, 20, LanguageItems(27)+" :", #PB_Text_Center)
    StringGadget(#Window_1_String_1, 130, 40, 260, 20, "")
      SetGadgetText(#Window_1_String_1, gConf\sPath_PBCOMPILER)
    ButtonGadget(#Window_1_Button_1, 400, 36, 80, 28, LanguageItems(14))
    TextGadget(#Window_1_Text_3, 486, 36, 28, 28, "")
      SetGadgetColor(#Window_1_Text_3, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Window_1_Text_4, 10, 70, 110, 20, "Fasm :", #PB_Text_Center)
    StringGadget(#Window_1_String_2, 130, 70, 260, 20, "")
      SetGadgetText(#Window_1_String_2, gConf\sPath_FASM)
    ButtonGadget(#Window_1_Button_2, 400, 66, 80, 28, LanguageItems(14))
    TextGadget(#Window_1_Text_5, 486, 66, 28, 28, "")
      SetGadgetColor(#Window_1_Text_5, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Window_1_Text_6, 10, 100, 110, 20, "Obj2Lib :", #PB_Text_Center)
    StringGadget(#Window_1_String_3, 130, 100, 260, 20, "")
      SetGadgetText(#Window_1_String_3, gConf\sPath_OBJ2LIB)
    ButtonGadget(#Window_1_Button_3, 400, 96, 80, 28, LanguageItems(14))
    TextGadget(#Window_1_Text_7, 486, 96, 28, 28, "")
      SetGadgetColor(#Window_1_Text_7, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Window_1_Text_8, 10, 130, 110, 20, "LibMaker :", #PB_Text_Center)
    StringGadget(#Window_1_String_4, 130, 130, 260, 20, "")
      SetGadgetText(#Window_1_String_4, gConf\sPath_PBLIBMAKER)
    ButtonGadget(#Window_1_Button_4, 400, 126, 80, 28, LanguageItems(14))
    TextGadget(#Window_1_Text_9, 486, 126, 28, 28, "")
      SetGadgetColor(#Window_1_Text_9, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    ButtonGadget(#Window_1_Button_5, 220, 160, 90, 30, LanguageItems(25))
    ButtonGadget(#Window_1_Button_6, 320, 160, 90, 30, LanguageItems(18))
    ButtonGadget(#Window_1_Button_7, 420, 160, 90, 30, LanguageItems(28))

    DisableWindow(#Window_0, #True)
    StickyWindow(#Window_1, #True)
    SetActiveWindow(#Window_1)
  EndIf
EndProcedure

;@desc Validate Purebasic paths
;@param InWindow : If #True, this is the window param
  ;@+  If #False, that validates params at startup
ProcedureDLL WinParamsPB_Validate(InWindow.b)
  bPBParams_Valid = #False
  SetGadgetText(#Window_0_Text_1, "NOK")
  SetGadgetColor(#Window_0_Text_1, #PB_Gadget_FrontColor, RGB(255, 0, 0))
  If gConf\sPureBasic_Path <> ""
    If FileSize(gConf\sPureBasic_Path) = -2
      If InWindow = #True
        SetGadgetColor(#Window_1_Text_1, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
      ; SubSystems if the path is valid
      If ExamineDirectory(0, gConf\sPureBasic_Path+"subsystems"+#System_Separator, "*.*")  
        ClearGadgetItems(#Window_0_Combo_0)
        AddGadgetItem(#Window_0_Combo_0, 0, "")
        While NextDirectoryEntry(0)
          If DirectoryEntryType(0) = #PB_DirectoryEntry_Directory 
            If DirectoryEntryName(0) <> "." And DirectoryEntryName(0) <> ".."
              AddGadgetItem(#Window_0_Combo_0, -1, "subsystems"+#System_Separator+DirectoryEntryName(0) +#System_Separator)
            EndIf
          EndIf
        Wend
        FinishDirectory(0)
      EndIf
    EndIf
  EndIf
  If gConf\sPath_PBCOMPILER <> ""
    If LCase(GetFilePart(gConf\sPath_PBCOMPILER)) = "pbcompiler"+#System_ExtExec And FileSize(gConf\sPath_PBCOMPILER) > 0
      If InWindow = #True
        SetGadgetColor(#Window_1_Text_3, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If gConf\sPath_FASM <> ""
    If LCase(GetFilePart(gConf\sPath_FASM)) = "fasm"+#System_ExtExec And FileSize(gConf\sPath_FASM) > 0
      If InWindow = #True
        SetGadgetColor(#Window_1_Text_5, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If gConf\sPath_OBJ2LIB <> "" And FileSize(gConf\sPath_OBJ2LIB) > 0
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux;{
        If LCase(GetFilePart(gConf\sPath_OBJ2LIB)) = "ar"
      ;}
      CompilerCase #PB_OS_Windows;{
        If LCase(GetFilePart(gConf\sPath_OBJ2LIB)) = "polib.exe"
      ;}
    ;}
    CompilerEndSelect
      If InWindow = #True
        SetGadgetColor(#Window_1_Text_7, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If gConf\sPath_PBLIBMAKER <> "" And FileSize(gConf\sPath_PBLIBMAKER) > 0
    If LCase(GetFilePart(gConf\sPath_PBLIBMAKER)) = "pblibrarymaker" Or LCase(GetFilePart(gConf\sPath_PBLIBMAKER)) = "librarymaker.exe"
      If InWindow = #True
        SetGadgetColor(#Window_1_Text_9, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If bPBParams_Valid = 5
    SetGadgetText(#Window_0_Text_1, "OK")
    SetGadgetColor(#Window_0_Text_1, #PB_Gadget_FrontColor, RGB(0, 255, 0))
    If InWindow = #True
      MessageRequester(LanguageItems(29), LanguageItems(30))
    Else ; enable the step 2
      M_GUI_EnableStep(#False, #True, #False)
    EndIf
  EndIf
EndProcedure
ProcedureDLL WinParamsPB_LoadIni()
Protected bPrefsPresent.b
Protected sDefaultPath.s
  If FileSize(sPath+"Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini") > 0
    bPrefsPresent = #True
    OpenPreferences(sPath+"Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini")
  EndIf
  If bPrefsPresent = #True
    PreferenceGroup("PATH")
    ; PureBasic Folder
    gConf\sPureBasic_Path = ReadPreferenceString("PureBasic", PB_GetPBFolder())
    
    ; PbCompiler
    If gConf\sPureBasic_Path <> ""
      sDefaultPath = gConf\sPureBasic_Path+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec
    Else
      sDefaultPath = ""
    EndIf
    gConf\sPath_PBCOMPILER = ReadPreferenceString("PBCompiler", sDefaultPath)
    
    ; Fasm
    If gConf\sPureBasic_Path <> ""
      sDefaultPath = gConf\sPureBasic_Path+"compilers"+#System_Separator+"fasm"+#System_ExtExec
    Else
      sDefaultPath = ""
    EndIf
    gConf\sPath_FASM = ReadPreferenceString("PBFasm",sDefaultPath)
    ; Obj2Lib
    gConf\sPath_OBJ2LIB = ReadPreferenceString("PBObj2Lib",sDefaultPath)
    ; LibMaker
    gConf\sPath_PBLIBMAKER = ReadPreferenceString("PBLibMaker","")
    
    ClosePreferences()
  EndIf
EndProcedure
ProcedureDLL WinParamsPB_SaveIni()
  Protected bPrefsPresent.b
  bPrefsPresent = CreatePreferences(sPath+"Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini")
  If bPrefsPresent <> #False
    PreferenceGroup("PATH")
    WritePreferenceString("PureBasic", gConf\sPureBasic_Path)
    WritePreferenceString("PBCompiler", gConf\sPath_PBCOMPILER)
    WritePreferenceString("PBFasm", gConf\sPath_FASM)
    WritePreferenceString("PBObj2Lib", gConf\sPath_OBJ2LIB)
    WritePreferenceString("PBLibMaker", gConf\sPath_PBLIBMAKER)
    ClosePreferences()
  EndIf
EndProcedure

;@desc Create the Window for Preferences
ProcedureDLL WinPrefs_Create()
  If OpenWindow(#Window_2, 0, 0, 350, 100, LanguageItems(22), #PB_Window_ScreenCentered) 
    CheckBoxGadget(#Window_2_CheckBox_0, 10,  10, 330, 20, LanguageItems(31))
    
    TextGadget(#Window_2_Text_0, 10, 40, 100, 20, LanguageItems(32)+" :")
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux;{
        ComboBoxGadget(#Window_2_Combo_0, 80, 40, 260, 23)
      ;}
      CompilerCase #PB_OS_Windows;{
        ComboBoxGadget(#Window_2_Combo_0, 80, 40, 260, 15)
      ;}      
    CompilerEndSelect
    If ExamineDirectory(0, sPath+"Prefs"+#System_Separator, "*.ini")
      While NextDirectoryEntry(0)
        If DirectoryEntryType(0) = #PB_DirectoryEntry_File
          If Left(LCase(DirectoryEntryName(0)), 4) = "lng_"
            AddGadgetItem(#Window_2_Combo_0, -1, Mid(DirectoryEntryName(0), 5, Len(DirectoryEntryName(0)) - 4 - 4))
          EndIf
        EndIf
      Wend
      FinishDirectory(0)
    EndIf
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux;{
        ButtonGadget(#Window_2_Button_0, 130, 66, 70, 28, LanguageItems(33))
        ButtonGadget(#Window_2_Button_1, 210, 66, 130, 28, LanguageItems(25)+" "+LanguageItems(34)+" "+LanguageItems(28))
      ;}
      CompilerCase #PB_OS_Windows;{
        ButtonGadget(#Window_2_Button_0, 180, 70, 050, 20, LanguageItems(33))
        ButtonGadget(#Window_2_Button_1, 240, 70, 100, 20, LanguageItems(25)+" "+LanguageItems(34)+" "+LanguageItems(28))
      ;}
    CompilerEndSelect
      
    DisableWindow(#Window_0, #True)
    StickyWindow(#Window_2, #True)
    SetActiveWindow(#Window_2)
  EndIf
EndProcedure

;@desc Error Handler : draws a messagerequester which contains infos on error
ProcedureDLL Main_ErrorHandler()
  Protected ErrorMessage.s
  ErrorMessage = "A program error was detected:" + Chr(13)
  ErrorMessage + Chr(13)
  ErrorMessage + "Error Message:   " + ErrorMessage()      + Chr(13)
  ErrorMessage + "Error Code:      " + Str(ErrorCode())    + Chr(13)
  ErrorMessage + "Code Address:    " + Str(ErrorAddress()) + Chr(13)
  If ErrorCode() = #PB_OnError_InvalidMemory   
    ErrorMessage + "Target Address:  " + Str(ErrorTargetAddress()) + Chr(13)
  EndIf
  If ErrorLine() = -1
    ErrorMessage + "Sourcecode line: Enable OnError lines support to get code line information." + Chr(13)
  Else
    ErrorMessage + "Sourcecode line: " + Str(ErrorLine()) + Chr(13)
    ErrorMessage + "Sourcecode file: " + ErrorFile() + Chr(13)
  EndIf
  ErrorMessage + Chr(13)
  ErrorMessage + "Register content:" + Chr(13)
  CompilerSelect #PB_Compiler_Processor
    CompilerCase #PB_Processor_x86 ;{
      ErrorMessage + "EAX = " + Str(ErrorRegister(#PB_OnError_EAX)) + Chr(13)
      ErrorMessage + "EBX = " + Str(ErrorRegister(#PB_OnError_EBX)) + Chr(13)
      ErrorMessage + "ECX = " + Str(ErrorRegister(#PB_OnError_ECX)) + Chr(13)
      ErrorMessage + "EDX = " + Str(ErrorRegister(#PB_OnError_EDX)) + Chr(13)
      ErrorMessage + "EBP = " + Str(ErrorRegister(#PB_OnError_EBP)) + Chr(13)
      ErrorMessage + "ESI = " + Str(ErrorRegister(#PB_OnError_ESI)) + Chr(13)
      ErrorMessage + "EDI = " + Str(ErrorRegister(#PB_OnError_EDI)) + Chr(13)
      ErrorMessage + "ESP = " + Str(ErrorRegister(#PB_OnError_ESP)) + Chr(13)
    ;}
    CompilerCase #PB_Processor_x64 ;{
      ErrorMessage + "RAX = " + Str(ErrorRegister(#PB_OnError_RAX)) + Chr(13)
      ErrorMessage + "RBX = " + Str(ErrorRegister(#PB_OnError_RBX)) + Chr(13)
      ErrorMessage + "RCX = " + Str(ErrorRegister(#PB_OnError_RCX)) + Chr(13)
      ErrorMessage + "RDX = " + Str(ErrorRegister(#PB_OnError_RDX)) + Chr(13)
      ErrorMessage + "RBP = " + Str(ErrorRegister(#PB_OnError_RBP)) + Chr(13)
      ErrorMessage + "RSI = " + Str(ErrorRegister(#PB_OnError_RSI)) + Chr(13)
      ErrorMessage + "RDI = " + Str(ErrorRegister(#PB_OnError_RDI)) + Chr(13)
      ErrorMessage + "RSP = " + Str(ErrorRegister(#PB_OnError_RSP)) + Chr(13)
      ErrorMessage + "Display of registers R8-R15 skipped."         + Chr(13)
    ;}
    CompilerCase #PB_Processor_PowerPC ;{
      ErrorMessage + "r0 = " + Str(ErrorRegister(#PB_OnError_r0)) + Chr(13)
      ErrorMessage + "r1 = " + Str(ErrorRegister(#PB_OnError_r1)) + Chr(13)
      ErrorMessage + "r2 = " + Str(ErrorRegister(#PB_OnError_r2)) + Chr(13)
      ErrorMessage + "r3 = " + Str(ErrorRegister(#PB_OnError_r3)) + Chr(13)
      ErrorMessage + "r4 = " + Str(ErrorRegister(#PB_OnError_r4)) + Chr(13)
      ErrorMessage + "r5 = " + Str(ErrorRegister(#PB_OnError_r5)) + Chr(13)
      ErrorMessage + "r6 = " + Str(ErrorRegister(#PB_OnError_r6)) + Chr(13)
      ErrorMessage + "r7 = " + Str(ErrorRegister(#PB_OnError_r7)) + Chr(13)
      ErrorMessage + "Display of registers r8-R31 skipped."       + Chr(13)
  ;}
  CompilerEndSelect
  MessageRequester("MoebiusGUI", ErrorMessage)
  End
EndProcedure

;@desc Returns the error message in function of Error Number
ProcedureDLL.s GetStringError(Error.l)
  ProcedureReturn LanguageItems(100+Error)
EndProcedure

ProcedureDLL Language_Load(LanguageName.s)
  Protected lNbItems.l
  If OpenPreferences(sPath+"Prefs"+#System_Separator+"Lng_"+LanguageName+".ini")
    PreferenceGroup("Main")
    ReDim LanguageItems.s(ReadPreferenceLong("NumItems",1))
    For lNbItems = 1 To ReadPreferenceLong("NumItems",1)
      LanguageItems(lNbItems - 1) = ReadPreferenceString("lng"+Str(lNbItems - 1), "")
      Debug ReadPreferenceString("lng"+Str(lNbItems - 1), "")
    Next
    ClosePreferences()
  EndIf
EndProcedure
ProcedureDLL Language_Apply()
  SetWindowTitle(#Window_0, LanguageItems(1))
  SetGadgetText(#Window_0_Frame3D_0,LanguageItems(2)+" 1 : Purebasic")
    SetGadgetText(#Window_0_Text_0,LanguageItems(3)+" : ")
    SetGadgetText(#Window_0_Button_0,LanguageItems(4))
    
  SetGadgetText(#Window_0_Frame3D_1,LanguageItems(2)+" 2 : "+LanguageItems(5))
    SetGadgetText(#Window_0_CheckBox_0,LanguageItems(6))
    SetGadgetText(#Window_0_CheckBox_1,LanguageItems(7))
    SetGadgetText(#Window_0_CheckBox_2,LanguageItems(8))
    SetGadgetText(#Window_0_CheckBox_3,LanguageItems(9))
    SetGadgetText(#Window_0_CheckBox_4,LanguageItems(10))
    SetGadgetText(#Window_0_CheckBox_5,LanguageItems(11))
    SetGadgetText(#Window_0_Text_2,LanguageItems(12))
    SetGadgetText(#Window_0_Text_3,LanguageItems(13))
    SetGadgetText(#Window_0_Text_4,LanguageItems(15))
    SetGadgetText(#Window_0_Text_5,LanguageItems(16))
    SetGadgetText(#Window_0_Text_6,LanguageItems(17))
    SetGadgetText(#Window_0_Button_1,LanguageItems(14))
    SetGadgetText(#Window_0_Button_2,LanguageItems(14))
    SetGadgetText(#Window_0_Button_3,LanguageItems(14))
    SetGadgetText(#Window_0_Button_4,LanguageItems(18))
  
  SetGadgetText(#Window_0_Frame3D_2,LanguageItems(2)+" 3 : "+LanguageItems(19))
    SetGadgetText(#Window_0_Button_5,LanguageItems(20))
    SetGadgetText(#Window_0_CheckBox_6,LanguageItems(21))
  
  SetGadgetText(#Window_0_Button_6,LanguageItems(22))
  SetGadgetText(#Window_0_Text_7,LanguageItems(23)+" :")
  SetGadgetText(#Window_0_Button_7,LanguageItems(24))
  SetGadgetText(#Window_0_Button_8,LanguageItems(25))
  
  SetGadgetItemText(#Window_0_Combo_1, 0, "=== "+LanguageItems(0)+" ===")
EndProcedure
