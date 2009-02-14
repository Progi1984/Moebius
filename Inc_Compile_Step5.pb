;@desc LibraryMaker creates userlibrary from the LIB file
ProcedureDLL Moebius_Compile_Step5()
  Protected DirUserLibrary.s = gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator
  If gProject\bDontBuildLib = #False
    RunProgram(gConf\sPath_PBLIBMAKER, " "+#DQuote+gProject\sFileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, gProject\sDirProject, #PB_Program_Wait|#PB_Program_Hide)
    Output_Add(#DQuote+gConf\sPath_PBLIBMAKER+#DQuote+" "+#DQuote+gProject\sFileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, #Output_Log | #Output_Bat, 2)
    If FileSize(DirUserLibrary+gProject\sLibName)>0
      If gProject\sFileOutput <> ""
        If gProject\sLibName <> gProject\sFileOutput
          If RenameFile(DirUserLibrary+gProject\sLibName, DirUserLibrary+gProject\sFileOutput)
            Output_Add("Rename the userlib DONE : OLD >"+#DQuote+gProject\sLibName+#DQuote+" ; NEW >"+#DQuote+gProject\sFileOutput+#DQuote, #Output_Log, 2)
          Else
            Output_Add("Rename the userlib NOT DONE : OLD >"+#DQuote+gProject\sLibName+#DQuote+" ; NEW >"+#DQuote+gProject\sFileOutput+#DQuote, #Output_Log, 2)
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
