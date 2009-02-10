ProcedureDLL Moebius_Compile_Step3()
  ; 3. FASM compiles the ASM files created by tailbite To OBJ
  ;     Compiling ASM sources
  Protected Pgm_Fasm.l
  Protected sFASMError.s, sReadPgm.s
  ForEach LL_DLLFunctions()
    Pgm_Fasm = RunProgram(gConf_Path_FASM, " "+#DQuote+gProject\sDirProject+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide | #PB_Program_Error)
    Output_Add(#DQuote+gConf_Path_FASM+#DQuote+" "+#DQuote+gProject\sDirProject+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, #Output_Log|#Output_Bat, 2)
    If Pgm_Fasm
      sFASMError = ""
      While ProgramRunning(Pgm_Fasm)
        ; Read from Main Stream of the program
        sReadPgm = Trim(ReadProgramString(Pgm_Fasm))
        If sReadPgm <> ""
          Output_Add(sReadPgm, #Output_Log, 2)
        EndIf
        ; Read from Error Stream of the program
        sReadPgm = Trim(ReadProgramError(Pgm_Fasm))
        If sReadPgm <> ""
          sFASMError + Space(2)+sReadPgm+#System_EOL
        EndIf
      Wend
      If sFASMError <>""
        Output_Add(sFASMError, #Output_Log, 0)
      EndIf
    Else
      Output_Add("Error in RunProgram", #Output_Log, 2)
    EndIf
    Output_Add("", #Output_Log, 2)
    CloseProgram(Pgm_Fasm)
  Next
EndProcedure
