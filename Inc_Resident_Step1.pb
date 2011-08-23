ProcedureDLL Moebius_Resident_Step1()
  Protected sResFile.s = "" ; the name of the executable's output
  Protected sCompilerOutput.s = "" ; the output for the compiler
  Protected lCompiler.l ; the pointer for the compiler
  Protected sCompilerParam.s ; parameters for compiler
  
  gState = #State_Step1
  
  ; Define the Resident File
  sResFile = gConf\sPureBasic_Path + "residents" + #System_Separator
  If gProject\bUnicode = #True
    sResFile + "unicode" + #System_Separator
  EndIf
  sResFile + gProject\sFileOutput
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ;{
      ; we define these environment variables for the compiler
      SetEnvironmentVariable("PUREBASIC_HOME", gConf\sPureBasic_Path)
      SetEnvironmentVariable("PATH", GetEnvironmentVariable("PATH") + ":" + gConf\sPureBasic_Path+ "/compilers")
    ;}
    CompilerCase #PB_OS_MacOS ;{
      MessageRequester("Moebius", "Inc_Resident_Step1.pb l16")
    ;}
  CompilerEndSelect
  
  ; Define param for compiler
  sCompilerParam = #Switch_Resident + " "
  If gProject\bUnicode
    sCompilerParam + #Switch_Unicode + " "
  EndIf
  If gProject\bInlineASM
    sCompilerParam + #Switch_InlineASM + " "
  EndIf
  
  sCompilerParam + #DQuote + sResFile + #DQuote
  
  ; launch the compiler
  lCompiler = RunProgram(gConf\sPath_PBCOMPILER, #DQuote + gProject\sFileName + #DQuote + " " + sCompilerParam, GetPathPart(gProject\sFileName), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output_Add("From > " + GetPathPart(gProject\sFileName), #Output_Log)
  Output_Add(#DQuote + gConf\sPath_PBCOMPILER + #DQuote + " " + #DQuote + gProject\sFileName + #DQuote + " " + sCompilerParam, #Output_Log|#Output_Bat)
  
  ; keep the output compiler for log and test success
  If lCompiler
    While ProgramRunning(lCompiler)
      sCompilerOutput + ReadProgramString(lCompiler) + Chr(13)
    Wend
  Else
    ProcedureReturn #Error_013
  EndIf

  If ProgramExitCode(lCompiler) = 0 Or (#PB_Compiler_Version = 420 And #PB_Compiler_OS = #PB_OS_Linux)
    ; #PB_Compiler_Version = 420 And #PB_Compiler_OS = #PB_OS_Linux => http://www.purebasic.fr/english/viewtopic.php?t=35379
    ; Test if the result is true 
    ; The last returned ligne is "- Feel the ..PuRe.. Power -"
    If FindString(sCompilerOutput, "Resident", 0)
      If FindString(sCompilerOutput, "created", 0)
        Output_Add(sCompilerOutput, #Output_Log)
        ProcedureReturn #Error_000
      Else
        Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -2" + Chr(10) + sCompilerOutput, #Output_Log)
        ProcedureReturn #Error_014
      EndIf
    Else
      Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -2" + Chr(10) + sCompilerOutput, #Output_Log)
      ProcedureReturn #Error_014
    EndIf
  Else
    Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -3" + Chr(10) + sCompilerOutput, #Output_Log)
    ProcedureReturn #Error_015
  EndIf 
EndProcedure