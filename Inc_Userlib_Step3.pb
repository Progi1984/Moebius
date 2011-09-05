;@desc FASM compiles the ASM files To OBJ
;@return #Error_000 > Success
;@return #Error_018 > Error : FASM has returned an error
;@return #Error_019 > Error : FASM can't be launched
ProcedureDLL Moebius_Userlib_Step3()
  Protected piPgm_Fasm.i
  Protected psFASMError.s, psFASMString.s, psReadPgm.s, psCmdLine.s
  
  gState = #State_Step3
  
  ForEach LL_DLLFunctions()
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
      CompilerCase #PB_OS_Windows ;{
        psCmdLine = " "+#DQuote+gProject\sDirAsm+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote
      ;}
      CompilerCase #PB_OS_MacOS ;{
        psCmdLine = " -f macho -o "+#DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote+" "+#DQuote+gProject\sDirAsm+LL_DLLFunctions()\FuncName+".asm"+#DQuote
      ;}
    CompilerEndSelect
    piPgm_Fasm = RunProgram(gConf\sPath_FASM, psCmdLine, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide | #PB_Program_Error)
    Output_Add(#DQuote+gConf\sPath_FASM+#DQuote+psCmdLine, #Output_Log|#Output_Bat, 2)
    If piPgm_Fasm
      psFASMString = ""
      psFASMError = ""
      While ProgramRunning(piPgm_Fasm)
        ; Read from Main Stream of the program
        psReadPgm = Trim(ReadProgramString(piPgm_Fasm))
        If sReadPgm <> ""
          psFASMString + Space(2)+psReadPgm+#System_EOL
        EndIf
        ; Read from Error Stream of the program
        psReadPgm = Trim(ReadProgramError(piPgm_Fasm))
        If sReadPgm <> ""
          psFASMError + Space(2)+psReadPgm+#System_EOL
        EndIf
      Wend
      
      If psFASMString <> ""
        Output_Add("FASM String", #Output_Log, 2)
        Output_Add(psFASMString, #Output_Log, 0)
      EndIf
      If psFASMError <> ""
        gsErrorContent = psFASMError
        Output_Add("FASM Error", #Output_Log, 2)
        Output_Add(psFASMError, #Output_Log, 0)
      Else
        gsErrorContent = ""
      EndIf
    Else
      Output_Add("Error with RunProgram FASM", #Output_Log, 2)
      ProcedureReturn #Error_019
    EndIf
    Output_Add("", #Output_Log, 2)
    CloseProgram(piPgm_Fasm)
    If psFASMError <> ""
      ProcedureReturn #Error_018
    EndIf
  Next
  ProcedureReturn #Error_000
EndProcedure
