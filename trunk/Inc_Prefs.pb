ProcedureDLL Moebius_ReadPrefs()
  Protected IniFile.s
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    IniFile = "Prefs\Moebius_Windows.ini"
  CompilerElse
    IniFile = "Prefs/Moebius_Linux.ini"
  CompilerEndIf
  
  ; ReadPreferences > Path
  If OpenPreferences(IniFile) <> 0
    PreferenceGroup("PATH")
    Global gConf_PureBasic_Path.s = ReadPreferenceString("PureBasic", "")
    Global gConf_Path_PBCOMPILER.s = ReadPreferenceString("PBCompiler", "")
    Global gConf_Path_FASM.s = ReadPreferenceString("PBFasm","")
    Global gConf_Path_OBJ2LIB.s = ReadPreferenceString("PBObj2Lib","")
    Global gConf_Path_PBLIBMAKER.s = ReadPreferenceString("PBLibMaker","")
    ClosePreferences()
  EndIf

  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    IniFile = "Prefs\Project_Sample00.ini"
  CompilerElse
    IniFile = "Prefs/Project_Sample00.ini"
  CompilerEndIf
  ; ReadPreferences > Project
  If OpenPreferences(IniFile) <> 0
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      PreferenceGroup("WINDOWS")
    CompilerElse
      PreferenceGroup("LINUX")
    CompilerEndIf
    gProject\Name = ReadPreferenceString("Name", "")
    gProject\FileName = ReadPreferenceString("FileName", "")
    
    Global gConf_SourceDir.s = ReadPreferenceString("SourceDir", "")
    Global gConf_ProjectDir.s = gConf_SourceDir + gProject\Name + #System_Separator
    
    ClosePreferences()
  EndIf
 EndProcedure
; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 37
; Folding = -
; EnableXP