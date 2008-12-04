ProcedureDLL Moebius_ReadPrefs()
  ; ReadPreferences > Path
  If OpenPreferences("Prefs"+#System_Separator+"Moebius_"+#System_OS+".ini") <> 0
    PreferenceGroup("PATH")
    Global gConf_PureBasic_Path.s = ReadPreferenceString("PureBasic", PB_GetPBFolder())
    Global gConf_Path_PBCOMPILER.s = ReadPreferenceString("PBCompiler", gConf_PureBasic_Path+#System_Separator+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec)
    Global gConf_Path_FASM.s = ReadPreferenceString("PBFasm",gConf_PureBasic_Path+#System_Separator+"compilers"+#System_Separator+"fasm"+#System_ExtExec)
    Global gConf_Path_OBJ2LIB.s = ReadPreferenceString("PBObj2Lib","")
    Global gConf_Path_PBLIBMAKER.s = ReadPreferenceString("PBLibMaker","")
    ClosePreferences()
  EndIf

  ; ReadPreferences > Project
  If OpenPreferences("Prefs"+#System_Separator+"Project_Sample"+Sample+".ini") <> 0
    PreferenceGroup(UCase(#System_OS))
    gProject\Name = ReadPreferenceString("Name", "")
    gProject\FileName = ReadPreferenceString("FileName", "")
    
    Global gConf_SourceDir.s = GetTemporaryDirectory() + "Moebius" + #System_Separator
    Global gConf_ProjectDir.s = gConf_SourceDir + gProject\Name + #System_Separator
    
    PreferenceGroup("PROJECT")
    gProject\isUnicode = ReadPreferenceLong("Unicode", #False)
    gProject\isThreadSafe = ReadPreferenceLong("ThreadSafe", #False)
    
    ClosePreferences()
  EndIf
 EndProcedure
 
; IDE Options = PureBasic 4.20 (Linux - x86)
; EnableXP