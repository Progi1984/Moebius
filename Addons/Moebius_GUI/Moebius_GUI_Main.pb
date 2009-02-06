#Moebius_App = #True

IncludePath "../../"
; Some includes must be included before others because of some specifics vars are called
  XIncludeFile "Inc_Declare.pb"
  XIncludeFile "Inc_Var.pb" 
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows : XIncludeFile "Inc_OS_Windows.pb"
    CompilerCase #PB_OS_Linux : XIncludeFile "Inc_OS_Linux.pb"
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
            ;}
            Case #CheckBox_1 ;{ Threadsafe
              gProject\bThreadSafe = GetGadgetState(#CheckBox_1)
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
              gProject\bDontKeepSrcFiles = 1-GetGadgetState(#CheckBox_5)
            ;}
            Case #CheckBox_6 ;{ Enable Logging
              bEnableLogEditor = GetGadgetState(#CheckBox_6)
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
                If GetGadgetText(#String_0) <> ""
                  gProject\LibName  = Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)
                  SetGadgetText(#String_0, gProject\LibName)
                  gProject\sFileOutput  = Project\LibName
                EndIf 
                gConf_SourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
                gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
                gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
                gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
                gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
                gProject\FileCHM  = gProject\LibName + #System_ExtHelp
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
                If gProject\FileName <> "" And FileSize(gProject\FileName) > 0
                  If gProject\LibName = ""
                    gProject\LibName = Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)
                    gConf_SourceDir = GetTemporaryDirectory() + "Moebius" + #System_Separator
                    gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
                    gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
                    gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
                    gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
                    gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
                    If GetGadgetText(#String_2) = ""
                      gProject\FileCHM  = gProject\LibName + #System_ExtHelp
                      SetGadgetText(#String_2, gProject\FileCHM)
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
                gConf_SourceDir = sRetString
                gConf_ProjectDir = gConf_SourceDir + gProject\LibName + #System_Separator
                gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
                gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
                gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
                gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
                If GetGadgetText(#String_2) = ""
                  gProject\FileCHM  = gProject\LibName + #System_ExtHelp
                  SetGadgetText(#String_2, gProject\FileCHM)
                EndIf
                SetGadgetText(#String_8, gConf_SourceDir)
              EndIf            
            ;}
            
            Case #String_0 ;{ LibName
              sRetString = GetGadgetText(#String_0)
              If sRetString 
                gProject\LibName  = Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)
              EndIf
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
                  sRetString = OpenFileRequester("ar", "/usr/bin/ar", "ar|ar|Tous les fichiers (*.*)|*.*",0)
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
                gConf_PureBasic_Path = sRetString
                gConf_Path_PBCOMPILER = gConf_PureBasic_Path+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec
                gConf_Path_FASM = gConf_PureBasic_Path+"compilers"+#System_Separator+"fasm"+#System_ExtExec
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Windows;{
                    gConf_Path_OBJ2LIB = gConf_PureBasic_Path+"compilers"+#System_Separator+"polib"+#System_ExtExec
                    gConf_Path_PBLIBMAKER = gConf_PureBasic_Path+"SDK"+#System_Separator+"LibraryMaker"+#System_ExtExec
                  ;}
                  CompilerCase #PB_OS_Linux;{
                    gConf_Path_OBJ2LIB = "/usr/bin/ar"
                    gConf_Path_PBLIBMAKER = gConf_PureBasic_Path+"compilers"+#System_Separator+"pblibrarymaker"+#System_ExtExec
                  ;}
                CompilerEndSelect
                SetGadgetText(#String_4, gConf_Path_PBCOMPILER)
                SetGadgetText(#String_5, gConf_Path_FASM)
                SetGadgetText(#String_6, gConf_Path_OBJ2LIB)
                SetGadgetText(#String_7, gConf_Path_PBLIBMAKER)
              EndIf
            ;}
            Case #String_4 ;{ PbCompiler
              sRetString = GetGadgetText(#String_4)
              If sRetString
                gConf_Path_PBCOMPILER = sRetString
              EndIf
            ;}
            Case #String_5 ;{ Fasm
              sRetString = GetGadgetText(#String_5)
              If sRetString
                gConf_Path_FASM = sRetString
              EndIf
            ;}
            Case #String_6 ;{ OBJ2LIB
              sRetString = GetGadgetText(#String_6)
              If sRetString
                gConf_Path_OBJ2LIB = sRetString
              EndIf
            ;}
            Case #String_7 ;{ PBLibMaker
              sRetString = GetGadgetText(#String_7)
              If sRetString
                gConf_Path_PBLIBMAKER = sRetString
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
