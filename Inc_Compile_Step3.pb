
ProcedureDLL Moebius_Compile_Step3()
  ; 3. FASM compiles the ASM files created by tailbite To OBJ
  ;     Compiling ASM sources
  Protected Pgm_Fasm.l
  ForEach LL_DLLFunctions()
    Pgm_Fasm = RunProgram(gConf_Path_FASM, " "+#DQuote+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
    Log_Add(#DQuote+gConf_Path_FASM+#DQuote+" "+#DQuote+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, 2)
    If Pgm_Fasm
      While ProgramRunning(Pgm_Fasm)
        Log_Add(ReadProgramString(Pgm_Fasm),2)
      Wend
    Else
      Log_Add("Error in RunProgram", 2)
    EndIf
    CloseProgram(Pgm_Fasm)
  Next
EndProcedure
