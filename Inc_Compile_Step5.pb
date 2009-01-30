
ProcedureDLL Moebius_Compile_Step5()
  ; 5. LibraryMaker creates userlibrary from the LIB file
  Protected DirUserLibrary.s = gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator
  If gProject\bDontBuildLib = #False  
    RunProgram(gConf_Path_PBLIBMAKER, " "+#DQuote+gProject\FileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, gConf_ProjectDir, #PB_Program_Wait|#PB_Program_Hide)
    Log_Add(#DQuote+gConf_Path_PBLIBMAKER+#DQuote+" "+#DQuote+gProject\FileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, 2)
    Batch_Add(#DQuote+gConf_Path_PBLIBMAKER+#DQuote+" "+#DQuote+gProject\FileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning)
    If FileSize(DirUserLibrary+gProject\LibName)>0
      If gProject\sFileOutput <> ""
        If gProject\LibName <> gProject\sFileOutput
          If RenameFile(DirUserLibrary+gProject\LibName, DirUserLibrary+gProject\sFileOutput)
            Log_Add("Rename the userlib DONE : OLD >"+#DQuote+gProject\LibName+#DQuote+" ; NEW >"+#DQuote+gProject\sFileOutput+#DQuote, 2)
          Else
            Log_Add("Rename the userlib NOT DONE : OLD >"+#DQuote+gProject\LibName+#DQuote+" ; NEW >"+#DQuote+gProject\sFileOutput+#DQuote, 2)
          EndIf
        EndIf
      EndIf
      If PB_Connect() = #True
        If PB_DisConnect() = #True
          If PB_Connect() = #True
            If PB_DisConnect() = #True
              ProcedureReturn #True
            Else
              ProcedureReturn #False
            EndIf
          Else
            ProcedureReturn #False
          EndIf
        Else
          ProcedureReturn #False
        EndIf
      Else
        ProcedureReturn #False
      EndIf
    Else
      ProcedureReturn #False
    EndIf 
  EndIf
EndProcedure
