;@desc FASM compiles the ASM files To OBJ
;@return #Error_018 > Error : FASM has returned an error
;@return #Error_019 > Error : FASM can't be launched
ProcedureDLL Moebius_Userlib_Step3()
  Protected lPgm_Fasm.l
  Protected sFASMError.s, sFASMString.s, sReadPgm.s
  
  gState = #State_Step3
  
  ForEach LL_DLLFunctions()
    lPgm_Fasm = RunProgram(gConf\sPath_FASM, " "+#DQuote+gProject\sDirAsm+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide | #PB_Program_Error)
    Output_Add(#DQuote+gConf\sPath_FASM+#DQuote+" "+#DQuote+gProject\sDirAsm+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, #Output_Log|#Output_Bat, 2)
    If lPgm_Fasm
      sFASMString = ""
      sFASMError = ""
      While ProgramRunning(lPgm_Fasm)
        ; Read from Main Stream of the program
        sReadPgm = Trim(ReadProgramString(lPgm_Fasm))
        If sReadPgm <> ""
          sFASMString + Space(2)+sReadPgm+#System_EOL
        EndIf
        ; Read from Error Stream of the program
        sReadPgm = Trim(ReadProgramError(lPgm_Fasm))
        If sReadPgm <> ""
          sFASMError + Space(2)+sReadPgm+#System_EOL
        EndIf
      Wend
      If sFASMString <> ""
        Output_Add("FASM String", #Output_Log, 2)
        Output_Add(sFASMString, #Output_Log, 0)
      EndIf
      If sFASMError <> ""
        Output_Add("FASM Error", #Output_Log, 2)
        Output_Add(sFASMError, #Output_Log, 0)
      EndIf
    Else
      Output_Add("Error in RunProgram FASM", #Output_Log, 2)
      ProcedureReturn #Error_019
    EndIf
    Output_Add("", #Output_Log, 2)
    CloseProgram(lPgm_Fasm)
    If sFASMError <> ""
      ProcedureReturn #Error_018
    EndIf
  Next
  ProcedureReturn #Error_000
EndProcedure
