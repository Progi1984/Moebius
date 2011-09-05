;@desc Compile the program file for extracting all ASM files
;@return #Error_000 > Success
;@return #Error_012 > Error : Not a purebasic file
;@return #Error_013 > Error : Program not launched
;@return #Error_014 > Error : Compiler Error
;@return #Error_015 > Error : Compiler Exit Code Error
ProcedureDLL Moebius_Userlib_Step1()
  Protected psExeFile.s = ""        ; the name of the executable's output
  Protected psCompilerOutput.s = "" ; the output for the compiler
  Protected plCompiler.l            ; the pointer for the compiler
  Protected psCompilerParam.s       ; parameters for compiler
  
  gState = #State_Step1
  
  ; we test the extension part if it is "pb or pbi" ; in this case, we continue, else we return #False
  With gProject
    Select LCase(GetExtensionPart(\sFileName))
      Case "pb" ; we define the name of executable file
        psExeFile = \sDirProject + Left(GetFilePart(\sFileName), Len(GetFilePart(\sFileName)) - Len(GetExtensionPart(\sFileName)) -1) + #System_ExtExec
      Case "pbi" ; we define the name of executable file
        psExeFile = \sDirProject + Left(GetFilePart(\sFileName), Len(GetFilePart(\sFileName)) - Len(GetExtensionPart(\sFileName)) -1) + #System_ExtExec
      Default ; it's not a purebasic file
        ProcedureReturn #Error_012
    EndSelect
  EndWith
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux 
    CompilerCase #PB_OS_MacOS;{
      ; we define these environment variables for the compiler
      SetEnvironmentVariable("PUREBASIC_HOME", gConf\sPureBasic_Path)
      SetEnvironmentVariable("PATH", GetEnvironmentVariable("PATH") + ":" + gConf\sPureBasic_Path+ "/compilers")
    ;}
  CompilerEndSelect
  
  ; we delete the last asm created
  SetFileAttributes(gProject\sDirProject + "PureBasic.asm", #PB_FileSystem_Normal)
  DeleteFile(gProject\sDirProject + "PureBasic.asm")
  
  ; we define param for compiler
  psCompilerParam = #Switch_Commented+" "
  If gProject\bUnicode
    psCompilerParam + #Switch_Unicode+" "
  EndIf
  If gProject\bThreadSafe
    psCompilerParam + #Switch_ThreadSafe+" "
  EndIf
  If gProject\bInlineASM
    psCompilerParam + #Switch_InlineASM + " "
  EndIf
  If gProject\sSubSystem <> ""
    psCompilerParam + #Switch_SubSystem + #DQuote + gProject\sSubSystem + #DQuote
  EndIf
  psCompilerParam +#Switch_Executable+" "+#DQuote+psExeFile+#DQuote
  
  ; launch the compiler
  plCompiler = RunProgram(gConf\sPath_PBCOMPILER, #DQuote+gProject\sFileName+#DQuote+" "+psCompilerParam, gProject\sDirProject, #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output_Add("From > "+gProject\sDirProject, #Output_Log)
  Output_Add(#DQuote+gConf\sPath_PBCOMPILER+#DQuote+" " + #DQuote+gProject\sFileName+#DQuote+" "+psCompilerParam, #Output_Log)
  
  ; keep the output compiler for log and test success
  If plCompiler
    While ProgramRunning(plCompiler)
      psCompilerOutput + ReadProgramString(plCompiler) + Chr(13)
    Wend
  Else
    ProcedureReturn #Error_013
  EndIf
  If psCompilerOutput <> ""
    gsErrorContent = psCompilerOutput
  Else
    gsErrorContent = ""
  EndIf
  
  If ProgramExitCode(plCompiler) = 0 Or (#PB_Compiler_Version = 420 And #PB_Compiler_OS = #PB_OS_Linux)
    ; #PB_Compiler_Version = 420 And #PB_Compiler_OS = #PB_OS_Linux => http://www.purebasic.fr/english/viewtopic.php?t=35379
    ; Test if the result is true 
    ; The last returned ligne is "- Feel the ..PuRe.. Power -"
    If FindString(psCompilerOutput, "- Feel the ..PuRe.. Power -", 0)
      Output_Add(psCompilerOutput, #Output_Log)
      ; we delete the last executable created
      DeleteFile(psExeFile)
      ProcedureReturn #Error_000
    Else
      Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -2" + Chr(10) + psCompilerOutput, #Output_Log)
      ; we delete the last executable created
      DeleteFile(psExeFile)
      ProcedureReturn #Error_014
    EndIf
  Else
    Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -3" + Chr(10) + psCompilerOutput, #Output_Log)
    ; we delete the last executable created
    DeleteFile(psExeFile)
    ProcedureReturn #Error_015
  EndIf 
EndProcedure
