Declare JaPBe_RegisterPlugin()
Declare MoebiusGUI_Init()
Declare MoebiusGUI_InitGUI()
Declare MoebiusGUI_OpenWindow()
Declare MoebiusGUI_ValidatePaths(lPath.l)
Declare PureBasic_CreateProfile()
Declare PureBasic_RegisterPlugin()

Procedure JaPBe_RegisterPlugin()
  Protected psJaPbePath.s
  Protected psToolsPrefsLocations.s
  Protected plFile.l
  Protected plToolsCount.l
  Protected plInc.l
  Protected pbToolsEverExisting.b
  
  psJaPbePath = PathRequester(dimLanguageItems(52), "")
  If psJaPbePath
    psToolsPrefsLocations = psJaPbePath + "jaPBe-Tools"
    If FileSize(psToolsPrefsLocations) = -1
      plFile = CreateFile(#PB_Any, psToolsPrefsLocations)
      If plFile
        CloseFile(plFile)
      EndIf
    EndIf
    If OpenPreferences(psToolsPrefsLocations) <> 0
      PreferenceGroup("ToolsInfo")
      plToolsCount = ReadPreferenceLong("ToolCount", 0)
      If plToolsCount > 0
        For plInc = 0 To plToolsCount -1
          PreferenceGroup("Tool_"+Str(plInc))
          If ReadPreferenceString("MenuItemName", "") = dimLanguageItems(1) + " - Userlib"
            pbToolsEverExisting = #True
            Break
          EndIf
        Next
      EndIf
      If pbToolsEverExisting = #False
        PreferenceGroup("ToolsInfo")
          WritePreferenceLong("ToolCount", plToolsCount + 2)
        
        PreferenceGroup("Tool_"+Str(plToolsCount + 1))
          WritePreferenceString("Command", ProgramFilename())
          WritePreferenceString("Arguments","/USERLIB %FILE")
          WritePreferenceString("WorkingDir","")
          WritePreferenceString("MenuItemName",dimLanguageItems(1) + " - Userlib")
          WritePreferenceLong("Shortcut",0)
          WritePreferenceLong("Flags",0)
          WritePreferenceLong("ReloadSource",0)
          WritePreferenceLong("HideEditor",0)
          WritePreferenceLong("IsPlugin",0)
          WritePreferenceLong("Menu",0)
          WritePreferenceLong("Language",0)
          WritePreferenceLong("Hide",0)
          WritePreferenceLong("Trigger",0)
          WritePreferenceLong("UniqueToolID", plToolsCount + 1)
          WritePreferenceLong("EnableUserButton",0)
          WritePreferenceString("EnableUserButtonPath", "")

        PreferenceGroup("Tool_"+Str(plToolsCount + 2))
          WritePreferenceString("Command", ProgramFilename())
          WritePreferenceString("Arguments","/RESIDENT %FILE")
          WritePreferenceString("WorkingDir","")
          WritePreferenceString("MenuItemName",dimLanguageItems(1) + " - Resident")
          WritePreferenceLong("Shortcut",0)
          WritePreferenceLong("Flags",0)
          WritePreferenceLong("ReloadSource",0)
          WritePreferenceLong("HideEditor",0)
          WritePreferenceLong("IsPlugin",0)
          WritePreferenceLong("Menu",0)
          WritePreferenceLong("Language",0)
          WritePreferenceLong("Hide",0)
          WritePreferenceLong("Trigger",0)
          WritePreferenceLong("UniqueToolID", plToolsCount + 2)
          WritePreferenceLong("EnableUserButton",0)
          WritePreferenceString("EnableUserButtonPath", "")
      EndIf
      ClosePreferences()
    EndIf    
  EndIf
EndProcedure
Procedure MoebiusGUI_Init()
  ; Fonts
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux : LoadFont(0, "Sans", 7)
    CompilerCase #PB_OS_MacOS : MessageRequester(dimLanguageItems(1), "Set Font equivalent To Arial") : End 
    CompilerCase #PB_OS_Windows : LoadFont(0, "Arial", 7)
  CompilerEndSelect
  SetGadgetFont(#PB_Default, FontID(0)) 
  
  ; Preferences
  If FileSize(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini") < 0 
    CreatePreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini")
      PreferenceGroup("Main")
      WritePreferenceLong("AlwaysAskBeforeLoadingProject", #False)
      gGUIPrefs\lAlwaysAskBeforeLoadingProject = #False
      WritePreferenceString("Language", "English")
      gGUIPrefs\sLanguage = "English"
      WritePreferenceString("Profile", "Default")
      gGUIPrefs\sProfile  = "Default"
    ClosePreferences()
  EndIf
  If OpenPreferences(gsPath+"Prefs"+#System_Separator+"MoebiusGUI_Prefs.ini") <> 0
    PreferenceGroup("Main")
      gGUIPrefs\lAlwaysAskBeforeLoadingProject = ReadPreferenceLong("AlwaysAskBeforeLoadingProject", #False)
      gGUIPrefs\sLanguage = ReadPreferenceString("Language", "French")
      gGUIPrefs\sProfile  = ReadPreferenceString("Profile", "Default")
    ClosePreferences()
  Else
    gGUIPrefs\lAlwaysAskBeforeLoadingProject = #False
    gGUIPrefs\sLanguage = "English"
    gGUIPrefs\sProfile = "Default"
  EndIf

  ; Languages
  M_GUI_LanguageLoad(gGUIPrefs\sLanguage)
  
  ; 
  gState = #State_StepStart
EndProcedure
Procedure MoebiusGUI_InitGUI()
  Protected psFilename.s
  Protected psOutput.s
  ; Paramètres
  If CountProgramParameters() > 0
    psOutput = ProgramParameter(0)
    If psOutput <> ""
      If UCase(psOutput) = "/RESIDENT"
        SetGadgetState(#Panel_00, 1)
      EndIf
      If UCase(psOutput) = "/USERLIB"
        SetGadgetState(#Panel_00, 2)
      EndIf
    EndIf
    psFilename = ProgramParameter(1)
    If psFilename <> ""
      ;{ Resident
        ; Filename
        SetGadgetText(#String_08, psFilename)
        ; Project Name
        SetGadgetText(#String_05, Left(GetFilePart(psFilename), Len(GetFilePart(psFilename)) - Len(GetExtensionPart(psFilename)) - 1))
        ; Output File
        SetGadgetText(#String_06, Left(GetFilePart(psFilename), Len(GetFilePart(psFilename)) - Len(GetExtensionPart(psFilename)) - 1))
        ; Working Directory
        SetGadgetText(#String_07, GetTemporaryDirectory()+ "Moebius" + #System_Separator + Left(GetFilePart(psFilename), Len(GetFilePart(psFilename)) - Len(GetExtensionPart(psFilename)) - 1) + #System_Separator)
      ;}
      ;{ Userlib
        ; Filename
        SetGadgetText(#String_09, psFilename)
        ; Project Name
        SetGadgetText(#String_10, Left(GetFilePart(psFilename), Len(GetFilePart(psFilename)) - Len(GetExtensionPart(psFilename)) - 1))
        ; Working Directory
        SetGadgetText(#String_11, GetTemporaryDirectory()+ "Moebius" + #System_Separator + Left(GetFilePart(psFilename), Len(GetFilePart(psFilename)) - Len(GetExtensionPart(psFilename)) - 1) + #System_Separator)
      ;}
    EndIf
  EndIf
EndProcedure
Procedure MoebiusGUI_OpenWindow()
  Protected plDirectory.l
  Protected plInc.l
  Protected psDefaultPath.s
  If OpenWindow(#Window_00, 436, 106, 402, 400, dimLanguageItems(1), #PB_Window_SystemMenu|#PB_Window_TitleBar|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
    PanelGadget(#Panel_00, 5, 5, 390, 390)
      ;{ Configuration
        AddGadgetItem(#Panel_00, -1, dimLanguageItems(5))
          ; Chemins PureBasic
          Frame3DGadget(#Frame3D_00, 5, 5, 375, 170, dimLanguageItems(29))
            TextGadget(#Text_00, 10, 25, 65, 15, dimLanguageItems(26))
            StringGadget(#String_00, 80, 25, 185, 20, "", #PB_String_ReadOnly)
            ButtonGadget(#Button_00, 275, 25, 60, 20, dimLanguageItems(14))
            TextGadget(#Image_00, 340, 25, 25, 20,  "")
            
            TextGadget(#Text_01, 10, 55, 65, 15, dimLanguageItems(27))
            StringGadget(#String_01, 80, 55, 185, 20, "", #PB_String_ReadOnly)
            ButtonGadget(#Button_01, 275, 55, 60, 20, dimLanguageItems(14))
            TextGadget(#Image_01, 340, 55, 25, 20,  "")
            
            TextGadget(#Text_02, 10, 85, 65, 15, "Fasm")
            StringGadget(#String_02, 80, 85, 185, 20, "", #PB_String_ReadOnly)
            ButtonGadget(#Button_02, 275, 85, 60, 20, dimLanguageItems(14))
            TextGadget(#Image_02, 340, 85, 25, 20, "")
            
            TextGadget(#Text_03, 10, 115, 65, 15, "Obj2Lib")
            StringGadget(#String_03, 80, 115, 185, 20, "", #PB_String_ReadOnly)
            ButtonGadget(#Button_03, 275, 115, 60, 20, dimLanguageItems(14))
            TextGadget(#Image_03, 340, 115, 25, 20,  "")
            
            TextGadget(#Text_04, 10, 145, 65, 15, "LibMaker")
            StringGadget(#String_04, 80, 145, 185, 20, "", #PB_String_ReadOnly)
            ButtonGadget(#Button_04, 275, 145, 60, 20, dimLanguageItems(14))
            TextGadget(#Image_04, 340, 145, 25, 20,  "")

          ; Préférences
          Frame3DGadget(#Frame3D_01, 5, 180, 375, 65, dimLanguageItems(22))
            TextGadget(#Text_05, 10, 200, 70, 15, dimLanguageItems(32)+" :")
            ComboBoxGadget(#ComboBox_00, 80, 195, 295, 25)
            ;{ Listing Languages
              plDirectory = ExamineDirectory(#PB_Any, gsPath+"Prefs"+#System_Separator, "*.ini")
              If plDirectory
                While NextDirectoryEntry(plDirectory)
                  If DirectoryEntryType(plDirectory) = #PB_DirectoryEntry_File
                    If Left(LCase(DirectoryEntryName(plDirectory)), 4) = "lng_"
                      AddGadgetItem(#ComboBox_00, -1, Mid(DirectoryEntryName(plDirectory), 5, Len(DirectoryEntryName(plDirectory)) - 4 - 4))
                    EndIf
                  EndIf
                Wend
                FinishDirectory(plDirectory)
                ; Set Language
                For plInc = 0 To CountGadgetItems(#ComboBox_00) - 1
                  If LCase(GetGadgetItemText(#ComboBox_00, plInc)) = LCase(gGUIPrefs\sLanguage)
                    SetGadgetState(#ComboBox_00, plInc)
                    Break
                  EndIf
                Next
              EndIf
            ;}
            CheckBoxGadget(#CheckBox_00, 10, 225, 365, 15, dimLanguageItems(31))
          
          ; Plugins
          Frame3DGadget(#Frame3D_07, 5, 250, 375, 50, dimLanguageItems(49))
            ButtonGadget(#Button_20, 10, 265, 180, 25, dimLanguageItems(50))
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              ButtonGadget(#Button_21, 195, 265, 180, 25, dimLanguageItems(51))
            CompilerEndIf
          
          ; Profils
          Frame3DGadget(#Frame3D_02, 5, 305, 375, 55, dimLanguageItems(23))
            ComboBoxGadget(#ComboBox_01, 20, 325, 180, 25)
            AddGadgetItem(#ComboBox_01, 0, "<"+dimLanguageItems(0)+">")
            ;{ Listing Profiles
              plDirectory = ExamineDirectory(#PB_Any, gsPath+"Prefs"+#System_Separator, "*.ini")
              If plDirectory
                While NextDirectoryEntry(plDirectory)
                  If DirectoryEntryType(plDirectory) = #PB_DirectoryEntry_File
                    If Left(LCase(DirectoryEntryName(plDirectory)), 8) = "profile_"
                      AddGadgetItem(#ComboBox_01, -1, Mid(DirectoryEntryName(plDirectory), 9, Len(DirectoryEntryName(plDirectory)) - 8 - 4))
                    EndIf
                  EndIf
                Wend
                FinishDirectory(plDirectory)
                ; Set Profile
                If CountGadgetItems(#ComboBox_01) = 1 ; Create Profile
                  If PureBasic_CreateProfile() = #True
                    AddGadgetItem(#ComboBox_01, 1, "Default")
                    SetGadgetState(#ComboBox_01, 1)
                    M_GUI_ProfilePB_Load()
                  EndIf
                Else
                  SetGadgetState(#ComboBox_01, 1)
                  For plInc = 0 To CountGadgetItems(#ComboBox_01) - 1
                    If GetGadgetItemText(#ComboBox_01, plInc) = gGUIPrefs\sProfile
                      SetGadgetState(#ComboBox_01, plInc)
                      Break
                    EndIf
                  Next
                  M_GUI_ProfilePB_Load()
                EndIf
              EndIf
            ;}
            ButtonGadget(#Button_05, 215, 325, 75, 25, dimLanguageItems(24))
            ButtonGadget(#Button_06, 295, 325, 75, 25, dimLanguageItems(25))
      ;}
      ;{ Create a resident
        AddGadgetItem(#Panel_00, -1, dimLanguageItems(2))
        TextGadget(#Text_06, 10, 5, 85, 15, dimLanguageItems(3)+" :")
        StringGadget(#String_08, 95, 5, 215, 20, "", #PB_String_ReadOnly)
        ButtonGadget(#Button_07, 315, 5, 65, 20, dimLanguageItems(14))
        PanelGadget(#Panel_01, 5, 30, 375, 325)
          ;{ Options
            AddGadgetItem(#Panel_01, -1, dimLanguageItems(4))
              Frame3DGadget(#Frame3D_03, 5, 5, 355, 95, dimLanguageItems(5))
                CheckBoxGadget(#CheckBox_01, 10, 20, 170, 20, dimLanguageItems(6))
                CheckBoxGadget(#CheckBox_02, 180, 20, 170, 20, dimLanguageItems(7))
                CheckBoxGadget(#CheckBox_03, 10, 45, 170, 20, dimLanguageItems(8))
                CheckBoxGadget(#CheckBox_04, 180, 45, 170, 20, dimLanguageItems(9))
                CheckBoxGadget(#CheckBox_11, 10, 70, 170, 20, dimLanguageItems(53))
                CheckBoxGadget(#CheckBox_13, 180, 70, 170, 20,dimLanguageItems(11))
              TextGadget(#Text_07, 5, 110, 80, 15, dimLanguageItems(19))
              StringGadget(#String_05, 100, 110, 260, 20, "")
              TextGadget(#Text_08, 5, 135, 80, 15, dimLanguageItems(12))
              StringGadget(#String_06, 100, 135, 260, 20, "")
              TextGadget(#Text_09, 5, 160, 90, 15, dimLanguageItems(16))
              StringGadget(#String_07, 100, 160, 195, 20, "")
              ButtonGadget(#Button_19, 300, 160, 60, 20, dimLanguageItems(14))
              ButtonGadget(#Button_08, 295, 215, 65, 25, dimLanguageItems(18))
              Frame3DGadget(#Frame3D_04, 5, 240, 360, 55, dimLanguageItems(23))
                ComboBoxGadget(#ComboBox_02, 20, 260, 175, 25)
                ;{ Listing Profiles
                  M_GUI_LoadProfile(#ComboBox_02, Resident)
                ;}
                ButtonGadget(#Button_09, 205, 260, 75, 25, dimLanguageItems(24))
                ButtonGadget(#Button_10, 285, 260, 75, 25, dimLanguageItems(25))
          ;}
          ;{ Build Resident
            AddGadgetItem(#Panel_01, -1, dimLanguageItems(21))
              ButtonGadget(#Button_11, 5, 5, 75, 25, dimLanguageItems(20))
              EditorGadget(#Editor_00, 5, 35, 360, 260, #PB_Editor_ReadOnly)
          ;}
        CloseGadgetList()
      ;}
      ;{ Create an userlib from PB
        AddGadgetItem(#Panel_00, -1, dimLanguageItems(28))
        TextGadget(#Text_14, 10, 5, 85, 15, dimLanguageItems(3)+" :")
        StringGadget(#String_09, 95, 5, 215, 20, "", #PB_String_ReadOnly)
        ButtonGadget(#Button_12, 315, 5, 65, 20, dimLanguageItems(14))
        PanelGadget(#Panel_02, 5, 30, 375, 323)
          ;{ Options
            AddGadgetItem(#Panel_02, -1, dimLanguageItems(4))
              Frame3DGadget(#Frame3D_05, 5, 5, 355, 110, dimLanguageItems(5))
                CheckBoxGadget(#CheckBox_05, 10, 20, 170, 20, dimLanguageItems(6))
                CheckBoxGadget(#CheckBox_06, 180, 20, 170, 20, dimLanguageItems(7))
                CheckBoxGadget(#CheckBox_07, 10, 44, 170, 20, dimLanguageItems(8))
                CheckBoxGadget(#CheckBox_08, 180, 44, 170, 20, dimLanguageItems(9))
                CheckBoxGadget(#CheckBox_09, 10, 68, 170, 20, dimLanguageItems(10))
                CheckBoxGadget(#CheckBox_10, 180, 68, 170, 20,dimLanguageItems(11))
                CheckBoxGadget(#CheckBox_12, 10, 92, 170, 20,dimLanguageItems(53))
              TextGadget(#Text_10, 5, 120, 90, 15, dimLanguageItems(12))
              StringGadget(#String_10, 100, 115, 260, 20, "")
              TextGadget(#Text_11, 5, 145, 90, 15, dimLanguageItems(16))
              StringGadget(#String_11, 100, 140, 195, 20, "")
              ButtonGadget(#Button_13, 300, 140, 60, 20, dimLanguageItems(14))
              TextGadget(#Text_12, 5, 170, 90, 15, dimLanguageItems(15))
              StringGadget(#String_12, 100, 165, 195, 20, "")
              ButtonGadget(#Button_14, 300, 165, 60, 20, dimLanguageItems(14))
              TextGadget(#Text_13, 5, 195, 90, 15, dimLanguageItems(17))
              ComboBoxGadget(#ComboBox_04, 100, 190, 260, 25)
              ButtonGadget(#Button_15, 295, 215, 65, 25, dimLanguageItems(18))
              Frame3DGadget(#Frame3D_06, 5, 240, 360, 55, dimLanguageItems(23))
                ComboBoxGadget(#ComboBox_03, 20, 260, 175, 25)
                ;{ Listing Profiles
                  M_GUI_LoadProfile(#ComboBox_03, Userlib)
                ;}
                ButtonGadget(#Button_16, 205, 260, 75, 25, dimLanguageItems(24))
                ButtonGadget(#Button_17, 285, 260, 75, 25, dimLanguageItems(25))
          ;}
          ;{ Build Userlib
            AddGadgetItem(#Panel_02, -1, dimLanguageItems(30))
              ButtonGadget(#Button_18, 5, 5, 75, 25, dimLanguageItems(20))
              EditorGadget(#Editor_01, 5, 35, 360, 260, #PB_Editor_ReadOnly)
         ;}
        CloseGadgetList()
      ;}
    CloseGadgetList()

    ;{ Init some parts of GUI
      ; Validate paths
      M_GUI_ProfilePB_ValidateAll()
     ;}
  EndIf
EndProcedure
Procedure MoebiusGUI_ValidatePaths(lPath.l)
  Protected plDirectory.l
  Select lPath
    Case #String_00 ;{ PureBasic
      If FileSize(GetGadgetText(#String_00)) = -2
        SetGadgetColor(#Image_00, #PB_Gadget_BackColor, RGB(0,255,0))
        ; SubSystems if the path is valid
        plDirectory = ExamineDirectory(#PB_Any, GetGadgetText(#String_00)+"subsystems"+#System_Separator, "*.*")
        If plDirectory
          ClearGadgetItems(#ComboBox_04)
          AddGadgetItem(#ComboBox_04, 0, "")
          While NextDirectoryEntry(plDirectory)
            If DirectoryEntryType(plDirectory) = #PB_DirectoryEntry_Directory 
              If DirectoryEntryName(plDirectory) <> "." And DirectoryEntryName(plDirectory) <> ".."
                AddGadgetItem(#ComboBox_04, -1, "subsystems"+#System_Separator+DirectoryEntryName(plDirectory) +#System_Separator)
              EndIf
            EndIf
          Wend
          FinishDirectory(plDirectory)
        EndIf
      Else
        SetGadgetColor(#Image_00, #PB_Gadget_BackColor, RGB(255,0,0))
      EndIf
    ;}
    Case #String_01 ;{ PBCompiler
      If LCase(GetFilePart(GetGadgetText(#String_01))) = "pbcompiler"+#System_ExtExec And FileSize(GetGadgetText(#String_01)) > 0
        SetGadgetColor(#Image_01, #PB_Gadget_BackColor, RGB(0,255,0))
      Else
        SetGadgetColor(#Image_01, #PB_Gadget_BackColor, RGB(255,0,0))
      EndIf
    ;}
    Case #String_02 ;{ PBFasm
      If LCase(GetFilePart(GetGadgetText(#String_02))) = "fasm"+#System_ExtExec And FileSize(GetGadgetText(#String_02)) > 0
        SetGadgetColor(#Image_02, #PB_Gadget_BackColor, RGB(0,255,0))
      Else
        SetGadgetColor(#Image_02, #PB_Gadget_BackColor, RGB(255,0,0))
      EndIf
    ;}
    Case #String_03 ;{ PBObj2Lib
     ;{
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          If LCase(GetFilePart(GetGadgetText(#String_03))) = "ar" And FileSize(GetGadgetText(#String_03)) > 0 ; }
        ;}
        CompilerCase #PB_OS_Windows;{
          If LCase(GetFilePart(GetGadgetText(#String_03))) = "polib.exe" And FileSize(GetGadgetText(#String_03)) > 0 ;}
        ;}
      CompilerEndSelect ;}
        SetGadgetColor(#Image_03, #PB_Gadget_BackColor, RGB(0,255,0))
      Else
        SetGadgetColor(#Image_03, #PB_Gadget_BackColor, RGB(255,0,0))
      EndIf
    ;}
    Case #String_04 ;{ PBLibMaker
      If (LCase(GetFilePart(GetGadgetText(#String_04))) = "pblibrarymaker" Or LCase(GetFilePart(GetGadgetText(#String_04))) = "librarymaker.exe")  And FileSize(GetGadgetText(#String_04)) > 0 
        SetGadgetColor(#Image_04, #PB_Gadget_BackColor, RGB(0,255,0))
      Else
        SetGadgetColor(#Image_04, #PB_Gadget_BackColor, RGB(255,0,0))
      EndIf
    ;}
  EndSelect
EndProcedure
Procedure PureBasic_CreateProfile()
  Protected psPBFolder.s = PB_GetPBFolder()
  If psPBFolder <> ""
    CreatePreferences(gsPath+"Prefs"+#System_Separator+"Profile_Default.ini")
      PreferenceGroup("PATH")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux ;{
          WritePreferenceString("PureBasic", psPBFolder)
          WritePreferenceString("PBCompiler", psPBFolder+"compilers"+#System_Separator+"pbcompiler")
          WritePreferenceString("PBFasm", psPBFolder+"compilers"+#System_Separator+"fasm")
          WritePreferenceString("PBObj2Lib", "/usr/bin/ar")
          WritePreferenceString("PBLibMaker", psPBFolder+"compilers"+#System_Separator+"pblibrarymaker")
        ;}
        CompilerCase #PB_OS_MacOS ;{
          MessageRequester(dimLanguageItems(1), "Function PureBasic_CreateProfile() : PB_GetPBFolder() missing")
        ;}
        CompilerCase #PB_OS_Windows ;{
          WritePreferenceString("PureBasic", psPBFolder)
          WritePreferenceString("PBCompiler", psPBFolder+"compilers"+#System_Separator+"pbcompiler.exe")
          WritePreferenceString("PBFasm", psPBFolder+"compilers"+#System_Separator+"fasm.exe")
          WritePreferenceString("PBObj2Lib", psPBFolder+"compilers"+#System_Separator+"polib.exe")
          WritePreferenceString("PBLibMaker", psPBFolder+"SDK"+#System_Separator+"LibraryMaker.exe")
        ;}
      CompilerEndSelect
    ClosePreferences()
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure
Procedure PureBasic_RegisterPlugin()
  Protected psToolsPrefsLocations.s
  Protected plFile.l
  Protected plToolsCount.l
  Protected plInc.l
  Protected pbToolsEverExisting.b
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ;{
      psToolsPrefsLocations = GetHomeDirectory() + ".purebasic" + #System_Separator + "tools.prefs"
    ;}
    CompilerCase #PB_OS_MacOS ;{
      MessageRequester(dimLanguageItems(1), "Function PureBasic_RegisterPlugin() : Where is the tools prefs file ?")
    ;}
    CompilerCase #PB_OS_Windows ;{
      psToolsPrefsLocations = GetHomeDirectory() + "Application Data" + #System_Separator + "PureBasic" + #System_Separator + "Tools.prefs"
    ;}
  CompilerEndSelect
  
  If psToolsPrefsLocations <> ""
    If FileSize(psToolsPrefsLocations) = -1
      plFile = CreateFile(#PB_Any, psToolsPrefsLocations)
      If plFile
        CloseFile(plFile)
      EndIf
    EndIf
    If OpenPreferences(psToolsPrefsLocations) <> 0
      PreferenceGroup("ToolsInfo")
      plToolsCount = ReadPreferenceLong("ToolCount", 0)
      If plToolsCount > 0
        For plInc = 0 To plToolsCount -1
          PreferenceGroup("Tool_"+Str(plInc))
          If ReadPreferenceString("MenuItemName", "") = dimLanguageItems(1) + " - Userlib"
            pbToolsEverExisting = #True
            Break
          EndIf
        Next
      EndIf
      If pbToolsEverExisting = #False
        PreferenceGroup("ToolsInfo")
          WritePreferenceLong("ToolCount", plToolsCount + 2)
        
        PreferenceGroup("Tool_"+Str(plToolsCount))
          WritePreferenceString("Command", ProgramFilename())
          WritePreferenceString("Arguments","/USERLIB %FILE")
          WritePreferenceString("WorkingDir","")
          WritePreferenceString("MenuItemName",dimLanguageItems(1) + " - Userlib")
          WritePreferenceLong("Shortcut",0)
          WritePreferenceLong("ConfigLine",0)
          WritePreferenceLong("Trigger",0)
          WritePreferenceLong("Flags",0)
          WritePreferenceLong("ReloadSource",0)
          WritePreferenceLong("HideEditor",0)
          WritePreferenceLong("HideFromMenu",0)
          WritePreferenceLong("SourceSpecific",0)
          WritePreferenceLong("Deactivate",0)
        PreferenceGroup("Tool_"+Str(plToolsCount+1))
          WritePreferenceString("Command", ProgramFilename())
          WritePreferenceString("Arguments","/RESIDENT %FILE")
          WritePreferenceString("WorkingDir","")
          WritePreferenceString("MenuItemName",dimLanguageItems(1) + " - Resident")
          WritePreferenceLong("Shortcut",0)
          WritePreferenceLong("ConfigLine",0)
          WritePreferenceLong("Trigger",0)
          WritePreferenceLong("Flags",0)
          WritePreferenceLong("ReloadSource",0)
          WritePreferenceLong("HideEditor",0)
          WritePreferenceLong("HideFromMenu",0)
          WritePreferenceLong("SourceSpecific",0)
          WritePreferenceLong("Deactivate",0)
      EndIf
      ClosePreferences()
    EndIf
  EndIf
EndProcedure


;@desc Error Handler : draws a messagerequester which contains infos on error
ProcedureDLL Main_ErrorHandler()
  Protected psErrorMessage.s
  psErrorMessage = "A program error was detected:" + Chr(13)
  psErrorMessage + Chr(13)
  psErrorMessage + "Error Message:   " + ErrorMessage()      + Chr(13)
  psErrorMessage + "Error Code:      " + Str(ErrorCode())    + Chr(13)
  psErrorMessage + "Code Address:    " + Str(ErrorAddress()) + Chr(13)
  If ErrorCode() = #PB_OnError_InvalidMemory   
    psErrorMessage + "Target Address:  " + Str(ErrorTargetAddress()) + Chr(13)
  EndIf
  If ErrorLine() = -1
    psErrorMessage + "Sourcecode line: Enable OnError lines support to get code line information." + Chr(13)
  Else
    psErrorMessage + "Sourcecode line: " + Str(ErrorLine()) + Chr(13)
    psErrorMessage + "Sourcecode file: " + ErrorFile() + Chr(13)
  EndIf
  psErrorMessage + Chr(13)
  psErrorMessage + "Register content:" + Chr(13)
  CompilerSelect #PB_Compiler_Processor
    CompilerCase #PB_Processor_x86 ;{
      psErrorMessage + "EAX = " + Str(ErrorRegister(#PB_OnError_EAX)) + Chr(13)
      psErrorMessage + "EBX = " + Str(ErrorRegister(#PB_OnError_EBX)) + Chr(13)
      psErrorMessage + "ECX = " + Str(ErrorRegister(#PB_OnError_ECX)) + Chr(13)
      psErrorMessage + "EDX = " + Str(ErrorRegister(#PB_OnError_EDX)) + Chr(13)
      psErrorMessage + "EBP = " + Str(ErrorRegister(#PB_OnError_EBP)) + Chr(13)
      psErrorMessage + "ESI = " + Str(ErrorRegister(#PB_OnError_ESI)) + Chr(13)
      psErrorMessage + "EDI = " + Str(ErrorRegister(#PB_OnError_EDI)) + Chr(13)
      psErrorMessage + "ESP = " + Str(ErrorRegister(#PB_OnError_ESP)) + Chr(13)
    ;}
    CompilerCase #PB_Processor_x64 ;{
      psErrorMessage + "RAX = " + Str(ErrorRegister(#PB_OnError_RAX)) + Chr(13)
      psErrorMessage + "RBX = " + Str(ErrorRegister(#PB_OnError_RBX)) + Chr(13)
      psErrorMessage + "RCX = " + Str(ErrorRegister(#PB_OnError_RCX)) + Chr(13)
      psErrorMessage + "RDX = " + Str(ErrorRegister(#PB_OnError_RDX)) + Chr(13)
      psErrorMessage + "RBP = " + Str(ErrorRegister(#PB_OnError_RBP)) + Chr(13)
      psErrorMessage + "RSI = " + Str(ErrorRegister(#PB_OnError_RSI)) + Chr(13)
      psErrorMessage + "RDI = " + Str(ErrorRegister(#PB_OnError_RDI)) + Chr(13)
      psErrorMessage + "RSP = " + Str(ErrorRegister(#PB_OnError_RSP)) + Chr(13)
      psErrorMessage + "Display of registers R8-R15 skipped."         + Chr(13)
    ;}
    CompilerCase #PB_Processor_PowerPC ;{
      psErrorMessage + "r0 = " + Str(ErrorRegister(#PB_OnError_r0)) + Chr(13)
      psErrorMessage + "r1 = " + Str(ErrorRegister(#PB_OnError_r1)) + Chr(13)
      psErrorMessage + "r2 = " + Str(ErrorRegister(#PB_OnError_r2)) + Chr(13)
      psErrorMessage + "r3 = " + Str(ErrorRegister(#PB_OnError_r3)) + Chr(13)
      psErrorMessage + "r4 = " + Str(ErrorRegister(#PB_OnError_r4)) + Chr(13)
      psErrorMessage + "r5 = " + Str(ErrorRegister(#PB_OnError_r5)) + Chr(13)
      psErrorMessage + "r6 = " + Str(ErrorRegister(#PB_OnError_r6)) + Chr(13)
      psErrorMessage + "r7 = " + Str(ErrorRegister(#PB_OnError_r7)) + Chr(13)
      psErrorMessage + "Display of registers r8-R31 skipped."       + Chr(13)
  ;}
  CompilerEndSelect
  MessageRequester(dimLanguageItems(1), psErrorMessage)
  End
EndProcedure
