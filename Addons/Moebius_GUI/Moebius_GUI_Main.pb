#Moebius_App = #True

IncludePath "./"
  XIncludeFile "MGUI_Inc_Var.pb"
  XIncludeFile "MGUI_Inc_Func.pb"

IncludePath "../../"
  XIncludeFile "Moebius_Main.pb"

; Open the main window
Main_Open()
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
            ;}
            Case #CheckBox_1 ;{ Threadsafe
              gProject\bUnicode = GetGadgetState(#CheckBox_1)
            ;}
            Case #CheckBox_2 ;{ Batch
              gProject\bBatFile = GetGadgetState(#CheckBox_2)
            ;}
            Case #CheckBox_3 ;{ Log
              gProject\bLogFile = GetGadgetState(#CheckBox_3)
            ;}
            Case #CheckBox_4 ;{ Don't Build Lib
              gProject\bDontBuildLib = GetGadgetState(#CheckBox_4)
            ;}
            Case #CheckBox_5 ;{ Don't Keep Src Files
              gProject\bDontKeepSrcFiles = GetGadgetState(#CheckBox_5)
            ;}
          
            Case #Button_0 ;{ Browse "PureBasic Params"
              bWinPBParams_Opened = #True
              PBParams_Open()
            ;}
            Case #Button_1 ;{ Source File
              sRetString = OpenFileRequester("Source File", "", "Fichiers Purebasic|*.pb|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gProject\FileName = sRetString
                SetGadgetText(#String_1, gProject\FileName)
                gProject\LibName  = Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)
                SetGadgetText(#String_0, gProject\LibName)
                gConf_SourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
              EndIf
            ;}
            Case #Button_2 ;{ Help File
              sRetString = OpenFileRequester("Source File", "", "Fichiers d'aide|*"+#System_ExtHelp+"|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gProject\FileCHM = sRetString
                SetGadgetText(#String_2, gProject\FileCHM)
              EndIf
            ;}
            Case #Button_3 ;{ Compile
              Moebius_MainThread(0)
            ;}
          EndSelect
        ;}
        Case #Window_1;{
          Select Evt_Gadget
            Case #Button_4 ;{ Purebasic path
              sRetString = PathRequester("Purebasic path", "")
              If sRetString
                gConf_PureBasic_Path = sRetString
                SetGadgetText(#String_3, gConf_PureBasic_Path)
              EndIf
            ;}
            Case #Button_5 ;{ Compiler
              sRetString = OpenFileRequester("Compiler", gConf_PureBasic_Path+"compilers"+#System_Separator, "Compiler|pbcompiler"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gConf_Path_PBCOMPILER = sRetString
                SetGadgetText(#String_4, gConf_Path_PBCOMPILER)
              EndIf
            ;}
            Case #Button_6 ;{ Fasm
              sRetString = OpenFileRequester("Fasm", gConf_PureBasic_Path+"compilers"+#System_Separator, "Fasm|fasm"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
              If sRetString
                gConf_Path_FASM = sRetString
                SetGadgetText(#String_5, gConf_Path_FASM)
              EndIf
            ;}
            Case #Button_7 ;{ Obj2Lib
              CompilerSelect #PB_Compiler_OS
                CompilerCase #PB_OS_Linux ;{
                  sRetString = OpenFileRequester("ar", "/usr/bin/", "ar|ar|Tous les fichiers (*.*)|*.*",0)
                ;}
                CompilerCase #PB_OS_Windows ;{
                  sRetString = OpenFileRequester("Polib", gConf_PureBasic_Path+"compilers\", "Polib |polib.exe|Tous les fichiers (*.*)|*.*",0)
                ;}
              CompilerEndSelect              
              If sRetString
                gConf_Path_OBJ2LIB = sRetString
                SetGadgetText(#String_6, gConf_Path_OBJ2LIB)
              EndIf
            ;}
            Case #Button_8 ;{ LibMaker 
              CompilerSelect #PB_Compiler_OS
                CompilerCase #PB_OS_Linux ;{
                  sRetString = OpenFileRequester("Library Maker", gConf_PureBasic_Path+"compilers"+#System_Separator, "LibMaker|pblibrarymaker"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
                ;}
                CompilerCase #PB_OS_Windows ;{
                  sRetString = OpenFileRequester("Library Maker", gConf_PureBasic_Path+"compilers"+#System_Separator, "LibMaker|LibraryMaker"+#System_ExtExec+"|Tous les fichiers (*.*)|*.*",0)
                ;}
              CompilerEndSelect
              If sRetString
                gConf_Path_PBLIBMAKER = sRetString
                SetGadgetText(#String_7, gConf_Path_PBLIBMAKER)
              EndIf
            ;}
            Case #Button_9 ;{ Validate Purebasic paths
              bPBParams_Valid = #False
              SetGadgetText(#Text_1, "NOK")
              SetGadgetColor(#Text_1, #PB_Gadget_FrontColor, RGB(255, 0, 0))
              If gConf_PureBasic_Path <> ""
                If FileSize(gConf_PureBasic_Path) = -2
                  SetGadgetColor(#Text_7, #PB_Gadget_BackColor, RGB(0,255,0))
                  bPBParams_Valid +1
                  ; SubSystems if the path is valid
                  If ExamineDirectory(0, gConf_PureBasic_Path+"subsystems"+#System_Separator, "*.*")  
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
              If gConf_Path_PBCOMPILER <> ""
                If LCase(GetFilePart(gConf_Path_PBCOMPILER)) = "pbcompiler"+#System_ExtExec
                  SetGadgetColor(#Text_9, #PB_Gadget_BackColor, RGB(0,255,0))
                  bPBParams_Valid +1
                EndIf
              EndIf
              If gConf_Path_FASM <> ""
                If LCase(GetFilePart(gConf_Path_FASM)) = "fasm"+#System_ExtExec
                  SetGadgetColor(#Text_11, #PB_Gadget_BackColor, RGB(0,255,0))
                  bPBParams_Valid +1
                EndIf
              EndIf
              If gConf_Path_OBJ2LIB <> ""
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux;{
                    If LCase(GetFilePart(gConf_Path_OBJ2LIB)) = "ar"
                  ;}
                  CompilerCase #PB_OS_Windows;{
                    If LCase(GetFilePart(gConf_Path_OBJ2LIB)) = "polib.exe"
                  ;}
                ;}
                CompilerEndSelect
                  SetGadgetColor(#Text_13, #PB_Gadget_BackColor, RGB(0,255,0))
                  bPBParams_Valid +1
                EndIf
              EndIf
              If gConf_Path_PBLIBMAKER <> ""
                If LCase(GetFilePart(gConf_Path_PBLIBMAKER)) = "pblibrarymakker" Or LCase(GetFilePart(gConf_Path_PBLIBMAKER)) = "librarymaker.exe"
                  SetGadgetColor(#Text_15, #PB_Gadget_BackColor, RGB(0,255,0))
                  bPBParams_Valid +1
                EndIf
              EndIf
              If bPBParams_Valid = 5
                SetGadgetText(#Text_1, "OK")
                SetGadgetColor(#Text_1, #PB_Gadget_FrontColor, RGB(0, 255, 0))
                MessageRequester("Purebasic Paths", "Les chemins sont valides.")
              EndIf
            ;}
            Case #Button_10 ;{ Fermer
              CloseWindow(#Window_1)
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
