;@desc Compile the program file for extracting all ASM files
;@returnvalue #Error_000 > Success
;@returnvalue #Error_012 > Error : Not a purebasic file
;@returnvalue #Error_013 > Error : Program not launched
;@returnvalue #Error_014 > Error : Compiler Error
;@returnvalue #Error_015 > Error : Compiler Exit Code Error
ProcedureDLL Moebius_Userlib_Step1()
  Protected sExeFile.s = "" ; the name of the executable's output
  Protected sCompilerOutput.s = "" ; the output for the compiler
  Protected lCompiler.l ; the pointer for the compiler
  Protected sCompilerParam.s ; parameters for compiler
  
  gState = #State_Step1
  
  ; we test the extension part if it is "pb or pbi" ; in this case, we continue, else we return #False
  Select LCase(GetExtensionPart(gProject\sFileName))
    Case "pb" ; we define the name of executable file
      sExeFile = gProject\sDirProject + Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName)) -1) + #System_ExtExec
    Case "pbi" ; we define the name of executable file
      sExeFile = gProject\sDirProject + Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName)) -1) + #System_ExtExec
    Default ; it's not a purebasic file
      ProcedureReturn #Error_012
  EndSelect
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ;{
      ; we define these environment variables for the compiler
      SetEnvironmentVariable("PUREBASIC_HOME", gConf\sPureBasic_Path)
      SetEnvironmentVariable("PATH", GetEnvironmentVariable("PATH") + ":" + gConf\sPureBasic_Path+ "/compilers")
    ;}
  CompilerEndSelect
  
  ; we delete the last asm created
  SetFileAttributes(gProject\sDirProject + "PureBasic.asm", #PB_FileSystem_Normal)
  DeleteFile(gProject\sDirProject + "PureBasic.asm")
  
  ; we define param for compiler
  sCompilerParam = #Switch_Commented+" "
  If gProject\bUnicode
    sCompilerParam + #Switch_Unicode+" "
  EndIf
  If gProject\bThreadSafe
    sCompilerParam + #Switch_ThreadSafe+" "
  EndIf
  If gProject\sSubSystem <> ""
    sCompilerParam + #Switch_SubSystem + #DQuote + gProject\sSubSystem + #DQuote
  EndIf
  sCompilerParam +#Switch_Executable+" "+#DQuote+sExeFile+#DQuote
  
  ; launch the compiler
  lCompiler = RunProgram(gConf\sPath_PBCOMPILER, #DQuote+gProject\sFileName+#DQuote+" "+sCompilerParam, gProject\sDirProject, #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output_Add("From > "+gProject\sDirProject, #Output_Log)
  Output_Add(#DQuote+gConf\sPath_PBCOMPILER+#DQuote+" " + #DQuote+gProject\sFileName+#DQuote+" "+sCompilerParam, #Output_Log)
  
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
    If FindString(sCompilerOutput, "- Feel the ..PuRe.. Power -", 0)
      Output_Add(sCompilerOutput, #Output_Log)
      ; we delete the last executable created
      DeleteFile(sExeFile)
      ProcedureReturn #Error_000
    Else
      Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -2" + Chr(10) + sCompilerOutput, #Output_Log)
      ; we delete the last executable created
      DeleteFile(sExeFile)
      ProcedureReturn #Error_014
    EndIf
  Else
    Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -3" + Chr(10) + sCompilerOutput, #Output_Log)
    ; we delete the last executable created
    DeleteFile(sExeFile)
    ProcedureReturn #Error_015
  EndIf 
EndProcedure
