;@desc LibraryMaker creates userlibrary from the LIB file
;@return #Error_025 > LibMaker can't be launched
;@return #Error_026 > The userlib isn't generated
;@return #Error_027 > The userlib can't be renamed
;@return #Error_028 > PBCompiler can't be restarted
ProcedureDLL Moebius_Userlib_Step5()
  Protected DirUserLibrary.s = gConf\sPureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator
  Protected lPgm_LibMaker ; #Error_025
  gState = #State_Step5
  
  ; Only if we want to build the userlib
  If gProject\bDontBuildLib = #False
    ;@infocode : http://www.purebasic.fr/english/viewtopic.php?f=23&t=39002
    CompilerIf #PB_Compiler_Version < 430
      lPgm_LibMaker = RunProgram(gConf\sPath_PBLIBMAKER, " "+#DQuote+gProject\sFileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, gProject\sDirProject, #PB_Program_Wait|#PB_Program_Hide)
      Output_Add(#DQuote+gConf\sPath_PBLIBMAKER+#DQuote+" "+#DQuote+gProject\sFileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, #Output_Log | #Output_Bat, 2)
    CompilerElse    
      lPgm_LibMaker = RunProgram(gConf\sPath_PBLIBMAKER, " /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning+" "+#DQuote+gProject\sFileDesc+#DQuote, gProject\sDirProject, #PB_Program_Wait|#PB_Program_Hide)
      Output_Add(#DQuote+gConf\sPath_PBLIBMAKER+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning+" "+#DQuote+gProject\sFileDesc+#DQuote, #Output_Log | #Output_Bat, 2)
    CompilerEndIf
    If lPgm_LibMaker = 0
      ProcedureReturn #Error_025
    EndIf
    
    If FileSize(DirUserLibrary+LCase(gProject\sLibName))>0
      ;{ Rename the userlib just generated
        If gProject\sFileOutput <> ""
          If gProject\sLibName <> gProject\sFileOutput
            If RenameFile(DirUserLibrary+gProject\sLibName, DirUserLibrary+gProject\sFileOutput)
              Output_Add("Rename the userlib DONE : OLD >"+#DQuote+gProject\sLibName+#DQuote+" ; NEW >"+#DQuote+gProject\sFileOutput+#DQuote, #Output_Log, 2)
            Else
              Output_Add("Rename the userlib NOT DONE : OLD >"+#DQuote+gProject\sLibName+#DQuote+" ; NEW >"+#DQuote+gProject\sFileOutput+#DQuote, #Output_Log, 2)
              ProcedureReturn #Error_027
            EndIf
          EndIf
        EndIf
      ;}
      ;{ Restart the compiler
        If PB_Connect() = #True
          If PB_DisConnect() = #True
            If PB_Connect() = #True
              If PB_DisConnect() = #True
                ProcedureReturn #Error_000
              Else
                ProcedureReturn #Error_028
              EndIf
            Else
              ProcedureReturn #Error_028
            EndIf
          Else
            ProcedureReturn #Error_028
          EndIf
        Else
          ProcedureReturn #Error_028
        EndIf
      ;}
    Else
      ProcedureReturn #Error_026
    EndIf 
  EndIf
EndProcedure
