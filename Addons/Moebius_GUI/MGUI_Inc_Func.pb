DeclareDLL Main_Open()
DeclareDLL PBParams_Open()

;@desc Opens the main window for Moebius
ProcedureDLL Main_Open()
  If OpenWindow(#Window_0, 353, 5, 600, 575, "Moebius",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
    Frame3DGadget(#Frame3D_0, 10, 10, 580, 70, "Etape 1 : Purebasic")
      TextGadget(#Text_0, 80, 40, 40, 20, "Etat : ")
      ButtonGadget(#Button_0, 450, 30, 130, 40, "Configurer")
      TextGadget(#Text_1, 250, 30, 100, 40, "NOK", #PB_Text_Center)
        SetGadgetFont(#Text_1, FontID)
        SetGadgetColor(#Text_1, #PB_Gadget_FrontColor, RGB(255, 0, 0))
    
    Frame3DGadget(#Frame3D_1, 10, 80, 580, 260, "Etape 2 : Configuration du projet")
      CheckBoxGadget(#CheckBox_0, 30, 100, 250, 20, "Mode Unicode")
      CheckBoxGadget(#CheckBox_1, 330, 100, 250, 20, "Mode Threadsafe")
      CheckBoxGadget(#CheckBox_2, 30, 130, 250, 20, "Générer un fichier Batch")
      CheckBoxGadget(#CheckBox_3, 330, 130, 250, 20, "Générer un fichier Log")
      CheckBoxGadget(#CheckBox_4, 30, 160, 290, 20, "Ne pas compiler la librairie, seulement les fichiers sources")
      CheckBoxGadget(#CheckBox_5, 330, 160, 250, 20, "Effacer les fichiers sources aprés compilation")
        gProject\bDontKeepSrcFiles = #True
      
      TextGadget(#Text_2, 30, 190, 120, 20, "Nom de la librairie")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#String_0, 160, 186, 330, 28, "")
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#String_0, 160, 190, 330, 20, "")
        ;}      
      CompilerEndSelect
      
      TextGadget(#Text_3, 30, 220, 120, 20, "Fichier Source :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#String_1, 160, 216, 330, 28, "")
          ButtonGadget(#Button_1, 500, 216, 80, 28, "Parcourir")
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#String_1, 160, 220, 330, 20, "")
          ButtonGadget(#Button_1, 500, 220, 80, 20, "Parcourir")
        ;}      
      CompilerEndSelect
      
      TextGadget(#Text_4, 30, 250, 120, 20, "Fichier Aide :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#String_2, 160, 246, 330, 28, "")
          ButtonGadget(#Button_2, 500, 246, 80, 28, "Parcourir")
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#String_2, 160, 250, 330, 20, "")
          ButtonGadget(#Button_2, 500, 250, 80, 20, "Parcourir")
        ;}      
      CompilerEndSelect
      
      TextGadget(#Text_16, 30, 280, 120, 20, "Dossier de Travail :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          StringGadget(#String_8, 160, 276, 330, 28, "")
          ButtonGadget(#Button_13, 500, 276, 80, 28, "Parcourir")
        ;}
        CompilerCase #PB_OS_Windows;{
          StringGadget(#String_8, 160, 280, 330, 20, "")
          ButtonGadget(#Button_13, 500, 280, 80, 20, "Parcourir")
        ;}      
      CompilerEndSelect

      TextGadget(#Text_5, 30, 310, 120, 20, "Sous-système :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          ComboBoxGadget(#Combo_0, 160, 306, 330, 28)
          ButtonGadget(#Button_11, 500, 306, 80, 28, "Valider")
        ;}
        CompilerCase #PB_OS_Windows;{
          ComboBoxGadget(#Combo_0, 160, 306, 330, 20)
          ButtonGadget(#Button_11, 500, 306, 80, 20, "Valider")
        ;}      
      CompilerEndSelect
        DisableGadget(#Button_11, #True)

    Frame3DGadget(#Frame3D_2, 10, 340, 580, 180, "Etape 3 : Compilation du projet")
      EditorGadget(#Editor_0, 20, 390, 560, 120, #PB_Editor_ReadOnly)
      ButtonGadget(#Button_3, 20, 356, 110, 28, "Compiler")
      CheckBoxGadget(#CheckBox_6, 140, 356, 110, 28, "Activer le log")
        DisableGadget(#Button_3, #True)
        DisableGadget(#CheckBox_6, #True)

    Frame3DGadget(#Frame3D_3, 10, 520, 580, 50, "")
      TextGadget(#Text_17, 30, 540, 120, 20, "Profil :")
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux;{
          ComboBoxGadget(#Combo_1, 160, 536, 250, 28)
          ButtonGadget(#Button_14, 415, 536, 80, 28, "Charger")
          ButtonGadget(#Button_15, 500, 536, 80, 28, "Sauver")
        ;}
        CompilerCase #PB_OS_Windows;{
          ComboBoxGadget(#Combo_1, 160, 536, 250, 20)
          ButtonGadget(#Button_14, 420, 536, 80, 20, "Charger")
          ButtonGadget(#Button_15, 500, 536, 80, 20, "Sauver")
        ;}      
      CompilerEndSelect
        M_GUI_ReloadProfiles()
        ; Load the default preference group if existant
        If FileSize("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini") > 0
          If OpenPreferences("Prefs"+#System_Separator+"MoebiusGUI_Profiles.ini")
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
        SetGadgetState(#Combo_1, 1)
  EndIf
EndProcedure
;@desc Set Purebasic params
ProcedureDLL PBParams_Open()
  If OpenWindow(#Window_1, 488, 98, 520, 200, "Moebius : PureBasic",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
    TextGadget(#Text_6, 10, 10, 110, 20, "Path Purebasic :", #PB_Text_Center)
    StringGadget(#String_3, 130, 10, 260, 20, "")
    SetGadgetText(#String_3, gConf\sPureBasic_Path)
    ButtonGadget(#Button_4, 400, 6, 80, 28, "Parcourir")
    TextGadget(#Text_7, 486, 6, 28, 28, "")
      SetGadgetColor(#Text_7, #PB_Gadget_BackColor, RGB(255, 0, 0))

    TextGadget(#Text_8, 10, 40, 110, 20, "Compilateur :", #PB_Text_Center)
    StringGadget(#String_4, 130, 40, 260, 20, "")
    SetGadgetText(#String_4, gConf\sPath_PBCOMPILER)
    ButtonGadget(#Button_5, 400, 36, 80, 28, "Parcourir")
    TextGadget(#Text_9, 486, 36, 28, 28, "")
      SetGadgetColor(#Text_9, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Text_10, 10, 70, 110, 20, "Fasm :", #PB_Text_Center)
    StringGadget(#String_5, 130, 70, 260, 20, "")
    SetGadgetText(#String_5, gConf\sPath_FASM)
    ButtonGadget(#Button_6, 400, 66, 80, 28, "Parcourir")
    TextGadget(#Text_11, 486, 66, 28, 28, "")
      SetGadgetColor(#Text_11, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Text_12, 10, 100, 110, 20, "Obj2Lib :", #PB_Text_Center)
    StringGadget(#String_6, 130, 100, 260, 20, "")
    SetGadgetText(#String_6, gConf\sPath_OBJ2LIB)
    ButtonGadget(#Button_7, 400, 96, 80, 28, "Parcourir")
    TextGadget(#Text_13, 486, 96, 28, 28, "")
      SetGadgetColor(#Text_13, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Text_14, 10, 130, 110, 20, "LibMaker :", #PB_Text_Center)
    StringGadget(#String_7, 130, 130, 260, 20, "")
    SetGadgetText(#String_7, gConf\sPath_PBLIBMAKER)
    ButtonGadget(#Button_8, 400, 126, 80, 28, "Parcourir")
    TextGadget(#Text_15, 486, 126, 28, 28, "")
      SetGadgetColor(#Text_15, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    ButtonGadget(#Button_12, 220, 160, 90, 30, "Sauver")
    ButtonGadget(#Button_9, 320, 160, 90, 30, "Valider")
    ButtonGadget(#Button_10, 420, 160, 90, 30, "Fermer")
  EndIf
EndProcedure
;@desc Validate Purebasic paths
;@param InWindow : If #True, this is the window param
  ;@+  If #False, that validates params at startup
ProcedureDLL PBParams_Validate(InWindow.b)
  bPBParams_Valid = #False
  SetGadgetText(#Text_1, "NOK")
  SetGadgetColor(#Text_1, #PB_Gadget_FrontColor, RGB(255, 0, 0))
  If gConf\sPureBasic_Path <> ""
    If FileSize(gConf\sPureBasic_Path) = -2
      If InWindow = #True
        SetGadgetColor(#Text_7, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
      ; SubSystems if the path is valid
      If ExamineDirectory(0, gConf\sPureBasic_Path+"subsystems"+#System_Separator, "*.*")  
        ClearGadgetItems(#Combo_0)
        While NextDirectoryEntry(0)
          If DirectoryEntryType(0) = #PB_DirectoryEntry_Directory 
            If DirectoryEntryName(0) <> "." And DirectoryEntryName(0) <> ".."
              AddGadgetItem(#Combo_0, -1, "subsystems"+#System_Separator+DirectoryEntryName(0) +#System_Separator)
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
        SetGadgetColor(#Text_9, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If gConf\sPath_FASM <> ""
    If LCase(GetFilePart(gConf\sPath_FASM)) = "fasm"+#System_ExtExec And FileSize(gConf\sPath_FASM) > 0
      If InWindow = #True
        SetGadgetColor(#Text_11, #PB_Gadget_BackColor, RGB(0,255,0))
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
        SetGadgetColor(#Text_13, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If gConf\sPath_PBLIBMAKER <> "" And FileSize(gConf\sPath_PBLIBMAKER) > 0
    If LCase(GetFilePart(gConf\sPath_PBLIBMAKER)) = "pblibrarymaker" Or LCase(GetFilePart(gConf\sPath_PBLIBMAKER)) = "librarymaker.exe"
      If InWindow = #True
        SetGadgetColor(#Text_15, #PB_Gadget_BackColor, RGB(0,255,0))
      EndIf
      bPBParams_Valid +1
    EndIf
  EndIf
  If bPBParams_Valid = 5
    SetGadgetText(#Text_1, "OK")
    SetGadgetColor(#Text_1, #PB_Gadget_FrontColor, RGB(0, 255, 0))
    If InWindow = #True
      MessageRequester("Purebasic Paths", "Les chemins sont valides.")
    Else
      ; Step 1
      DisableGadget(#Button_0, #True)
      ; Step 2
      DisableGadget(#Button_11, #False)
      ; Step 3
      DisableGadget(#Button_3, #True)
      DisableGadget(#CheckBox_6, #True)
    EndIf
  EndIf
EndProcedure
ProcedureDLL PBParams_LoadIni()
Protected bPrefsPresent.b
Protected sDefaultPath.s
  CompilerIf #PB_Editor_CreateExecutable = #True
    If FileSize("Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini") > 0
      bPrefsPresent = #True
      OpenPreferences("Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini")
    EndIf
  CompilerElse
    If FileSize(".."+#System_Separator+".."+#System_Separator+"Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini") > 0
      bPrefsPresent = #True
      OpenPreferences(".."+#System_Separator+".."+#System_Separator+"Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini")
    EndIf
  CompilerEndIf
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
ProcedureDLL PBParams_SaveIni()
  CompilerIf #PB_Editor_CreateExecutable = #True
    bPrefsPresent = CreatePreferences("Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini")
  CompilerElse
    bPrefsPresent = CreatePreferences(".."+#System_Separator+".."+#System_Separator+"Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini")
  CompilerEndIf
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

;@desc : Return #False if the gadget is enabled
ProcedureDLL GetDisableGadget(Gadget.l)
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux;{
      Protected *Widget.GtkWidget = GadgetID(Gadget)
      Protected *Object.GtkObject = *Widget\object
      If *Object\flags & #GTK_SENSITIVE <> 0
        ProcedureReturn #False
      Else
        ProcedureReturn #True
      EndIf
    ;}
    CompilerCase #PB_OS_Windows;{
      ProcedureReturn #True - IsWindowEnabled_(GadgetID(gadget))
    ;}
  CompilerEndSelect
EndProcedure
