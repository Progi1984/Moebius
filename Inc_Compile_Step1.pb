;@returnvalue : 1  > Success
;@returnvalue : 0  > Error : Not a purebasic file
;@returnvalue : -1 > Error : Program not launched
;@returnvalue : -2 > Error : Compiler Error
;@returnvalue : -3 > Error : Compiler Exit Code Error
ProcedureDLL Moebius_Compile_Step1()
  ; 1. PBCOMPILER creates the EXE (using POLINK) that we don't need, but also the ASM file (/COMMENTED)
 
  ; Retourne #true si le fichier asm a correctement été créé sinon retourne une valeur négative
  ; qui dépend du lieu de l'erreur, permet de trouver rapidement ou se situe l'erreur

  ; mémorise le nom du fichier exe, mais en fait la variable est vide
  Protected FichierExe.s = ""
  ; mémorise la chaine retournée par le compilateur lors de la création du fichier asm
  Protected Sortie.s = ""
  ; mémorise le résultat de la fonction Runprogram
  Protected Compilateur
  Protected Param.s
  ; on teste si le fichier se fini par "pb ou pbi"
  ; si oui on continue sinon on retourrne #False
  
  Select LCase(GetExtensionPart(gProject\sFileName))
    Case "pb" ; we define the name of executable file
      FichierExe = gProject\sDirProject + Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName)) -1) + #System_ExtExec
    Case "pbi" ; we define the name of executable file
      FichierExe = gProject\sDirProject + Left(GetFilePart(gProject\sFileName), Len(GetFilePart(gProject\sFileName)) - Len(GetExtensionPart(gProject\sFileName)) -1) + #System_ExtExec
    Default ; it's not a purebasic file
      ProcedureReturn #False
  EndSelect
  
  ; we delete the last asm created
  SetFileAttributes(gProject\sDirProject + "PureBasic.asm", #PB_FileSystem_Normal)
  DeleteFile(gProject\sDirProject + "PureBasic.asm")
  Param = #Switch_InlineASM+" "
  Param + #Switch_Commented+" "
  If gProject\bUnicode
    Param + #Switch_Unicode+" "
  EndIf
  If gProject\bThreadSafe
    Param + #Switch_ThreadSafe+" "
  EndIf
  If gProject\sSubSystem <> ""
    Param + #Switch_SubSystem + #DQuote + gProject\sSubSystem + #DQuote
  EndIf
  Param +#Switch_Executable+" "+#DQuote+FichierExe+#DQuote
  Compilateur = RunProgram(gConf_Path_PBCOMPILER, #DQuote+gProject\sFileName+#DQuote+" "+Param, gProject\sDirProject, #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  
  Output_Add(#DQuote+gConf_Path_PBCOMPILER+#DQuote+" " + #DQuote+gProject\sFileName+#DQuote+" "+Param, #Output_Log)
  
  If Compilateur
    While ProgramRunning(Compilateur)
      Sortie + ReadProgramString(Compilateur) + Chr(13)
    Wend
  Else
    ProcedureReturn -1
  EndIf

  If ProgramExitCode(Compilateur) = 0 Or (#PB_Compiler_Version = 420 And #PB_Compiler_OS = #PB_OS_Linux)
    ; #PB_Compiler_Version = 420 And #PB_Compiler_OS = #PB_OS_Linux => http://www.purebasic.fr/english/viewtopic.php?t=35379
    ; Test if the result is true 
    ; The last returned ligne is "- Feel the ..PuRe.. Power -"
    If FindString(Sortie, "- Feel the ..PuRe.. Power -", 0)
      Output_Add(Sortie, #Output_Log)
      ; we delete the last executable created
      DeleteFile(FichierExe)
      ProcedureReturn #True
    Else
      Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -2" + Chr(10) + Sortie, #Output_Log)
      ; we delete the last executable created
      DeleteFile(FichierExe)
      ProcedureReturn -2
    EndIf
  Else
    Output_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -3" + Chr(10) + Sortie, #Output_Log)
    ; we delete the last executable created
    DeleteFile(FichierExe)
    ProcedureReturn -3
  EndIf 
EndProcedure
