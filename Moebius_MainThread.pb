DeclareDLL Moebius_Compile_Step0()
DeclareDLL Moebius_Compile_Step1()
DeclareDLL Moebius_Compile_Step2()
DeclareDLL Moebius_Compile_Step3()
DeclareDLL Moebius_Compile_Step4()
DeclareDLL Moebius_Compile_Step5()
DeclareDLL Moebius_Compile_Step6()

ProcedureDLL Moebius_MainThread(Param.l)
  Protected RetValue.l
  RetValue = Moebius_Compile_Step0()
  Log_Add("Moebius_Compile_Step0()")
  If RetValue = #True
    Log_Add("Moebius_Compile_Step1()")
    RetValue = Moebius_Compile_Step1()
    If RetValue = #True
      Log_Add("Moebius_Compile_Step2()")
      Moebius_Compile_Step2()
      Log_Add("Moebius_Compile_Step3()")
      Moebius_Compile_Step3()
      Log_Add("Moebius_Compile_Step4()")
      Moebius_Compile_Step4()
      Log_Add("Moebius_Compile_Step5()")
      Moebius_Compile_Step5()
      Log_Add("Moebius_Compile_Step6()")
      Moebius_Compile_Step6()
    Else
      Log_Add("Step1 > Error > "+Str(RetValue))
    EndIf
  Else
    Log_Add("Step0 > Error > "+Str(RetValue))
  EndIf
EndProcedure

;@returnvalue : 1  > Success
;@returnvalue : 0  > Error : Can't delete files of old projects
;@returnvalue : -1 > Error : Can't create the directory of project
;@returnvalue : -2 > Error : Can't create the directory "Project\ASM"
;@returnvalue : -3 > Error : Can't create the directory "Project\LOGS"
;@returnvalue : -4 > Error : Can't create the directory "Project\LIB"
;@returnvalue : -5 > Error : Can't create the directory "Project\OBJ"
;@returnvalue : -6 > Error : Can't delete the old userlibrary
ProcedureDLL Moebius_Compile_Step0()
  ; 0. Cleaning & Preparing
  ;Cleans the old userlib
  If FileSize(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\LibName) > 0
    If DeleteFile(gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator+gProject\LibName) = 0
      ProcedureReturn #False -6
    EndIf
  EndIf
  ;Prepares the location For Moebius
  If FileSize(gConf_ProjectDir) = -2
    If DeleteDirectory(gConf_ProjectDir, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive) = 0
      ProcedureReturn #False
    EndIf
  EndIf
  If CreateDirectoryEx(gConf_ProjectDir)
    Log_Init()
    If CreateDirectoryEx(gConf_ProjectDir+"ASM"+#System_Separator)
      If CreateDirectoryEx(gConf_ProjectDir+"LOGS"+#System_Separator)
        If CreateDirectoryEx(gConf_ProjectDir+"LIB"+#System_Separator)
          If CreateDirectoryEx(gConf_ProjectDir+"OBJ"+#System_Separator)
            ProcedureReturn #True
          Else
            ProcedureReturn #False -5
          EndIf
        Else
          ProcedureReturn #False -4
        EndIf
      Else
        ProcedureReturn #False -3
      EndIf
    Else
      ProcedureReturn #False -2
    EndIf
  Else
    ProcedureReturn #False -1
  EndIf
EndProcedure

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
  
  Select LCase(GetExtensionPart(gProject\FileName))
    Case "pb" ; we define the name of executable file
      FichierExe = gConf_ProjectDir + Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName)) -1) + #System_ExtExec
    Case "pbi" ; we define the name of executable file
      FichierExe = gConf_ProjectDir + Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName)) -1) + #System_ExtExec
    Default ; it's not a purebasic file
      ProcedureReturn #False
  EndSelect
  
  ; we delete the last asm created
  SetFileAttributes(gConf_ProjectDir + "PureBasic.asm", #PB_FileSystem_Normal)
  DeleteFile(gConf_ProjectDir + "PureBasic.asm")
  Param = #Switch_InlineASM+" "
  Param + #Switch_Commented+" "
  If gProject\isUnicode
    Param + #Switch_Unicode+" "
  EndIf
  If gProject\isThreadSafe
    Param + #Switch_ThreadSafe+" "
  EndIf
  Param +#Switch_Executable+" "+#DQuote+FichierExe+#DQuote
  Compilateur = RunProgram(gConf_Path_PBCOMPILER, #DQuote+gProject\FileName+#DQuote+" "+Param, gConf_ProjectDir, #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Log_Add( gConf_Path_PBCOMPILER)
  Log_Add(#DQuote+gProject\FileName+#DQuote+" "+Param)
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
      Log_Add(Sortie)
      ; we delete the last executable created
      DeleteFile(FichierExe)
      ProcedureReturn #True
    Else
      Log_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -2" + Chr(10) + Sortie)
      ; we delete the last executable created
      DeleteFile(FichierExe)
      ProcedureReturn -2
    EndIf
  Else
    Log_Add("Erreur de compilation > Le compilateur a retourné l'erreur suivante : -3" + Chr(10) + Sortie)
    ; we delete the last executable created
    DeleteFile(FichierExe)
    ProcedureReturn -3
  EndIf 
EndProcedure

ProcedureDLL Moebius_Compile_Step2()
  ; 2. TAILBITE grabs the ASM file, splits it, rewrites some parts
  Protected CodeContent.s, CodeCleaned.s, CodeCleaned2.s, CodeField.s, TrCodeField.s, FunctionList.s, sReturnValField.s
  Protected Inc.l, IncA.l, NotCapture.l, lFound.l
  Protected bInFunction.b, bInSystemLib.b
  Protected sNameOfFunction.s, sCallExtrn.s
  If ReadFile(0, gConf_ProjectDir+"purebasic.asm")
    CodeContent = Space(Lof(0)+1)
    ReadData(0,@CodeContent, Lof(0))
    CloseFile(0)
  EndIf
  Log_Add("Extracts information for the future creation of the DESC File", 2)
  ;{ Extracts information for the future creation of the DESC File
  For Inc = 0 To CountString(CodeContent, #System_EOL)
    CodeField = StringField(CodeContent, Inc+1, #System_EOL)
    TrCodeField = ReplaceString(CodeField, Chr(13), "")
    TrCodeField = ReplaceString(TrCodeField, Chr(10), "")
    TrCodeField = Trim(TrCodeField)
    If Left(TrCodeField, 1) =";"
      TrCodeField = Right(TrCodeField, Len(TrCodeField) - 2)
      If TrCodeField <> ""
        CodeCleaned2 = Trim(StringField(TrCodeField, 1, " "))
        CodeCleaned2 = Trim(StringField(CodeCleaned2, 1, "."))
        CodeCleaned2 = Trim(CodeCleaned2)
        If LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedurecdll" Or LCase(CodeCleaned2) = "procedurec" Or LCase(CodeCleaned2) = "procedure"
          If AddElement(LL_DLLFunctions())
            If LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedurecdll"
              LL_DLLFunctions()\IsDLLFunction = #True
            Else
              LL_DLLFunctions()\IsDLLFunction = #False
            EndIf
            TrCodeField = ReplaceString(TrCodeField, "proceduredll", "", #PB_String_NoCase)
            TrCodeField = ReplaceString(TrCodeField, "procedurecdll", "", #PB_String_NoCase)
            TrCodeField = ReplaceString(TrCodeField, "procedure", "", #PB_String_NoCase)
            TrCodeField = ReplaceString(TrCodeField, "procedurec", "", #PB_String_NoCase)
            TrCodeField = Trim(TrCodeField)
            TrCodeField = ReplaceString(TrCodeField, "  ", " ")
            TrCodeField = ReplaceString(TrCodeField, " .", ".")
            TrCodeField = ReplaceString(TrCodeField, " ,", ",")
            TrCodeField = ReplaceString(TrCodeField, ", ", ",")
            TrCodeField = ReplaceString(TrCodeField, " (", "(")
            If Left(StringField(TrCodeField, 1, " "), 1) = "."
              LL_DLLFunctions()\FuncName = StringField(TrCodeField, 2, " ")
              sReturnValField = StringField(TrCodeField, 1, " ")
            Else
              LL_DLLFunctions()\FuncName = StringField(TrCodeField, 1, " ")
              sReturnValField = LL_DLLFunctions()\FuncName
            EndIf
            Log_Add("LL_DLLFunctions()\FuncName > "+LL_DLLFunctions()\FuncName, 4)
            LL_DLLFunctions()\Params = Right(LL_DLLFunctions()\FuncName, Len(LL_DLLFunctions()\FuncName)-(FindString(LL_DLLFunctions()\FuncName, "(", 1)))
            LL_DLLFunctions()\Params = Left(LL_DLLFunctions()\Params, (FindString(LL_DLLFunctions()\Params, ")", 1)-1))
            LL_DLLFunctions()\FuncName = Trim(Left(LL_DLLFunctions()\FuncName, FindString(LL_DLLFunctions()\FuncName, "(", 1)-1))
            If FindString(TrCodeField, ";",1) > 0
              LL_DLLFunctions()\FuncDesc = Right(TrCodeField, Len(TrCodeField) - FindString(TrCodeField, ";",1))
            EndIf
            Log_Add("LL_DLLFunctions()\Params > "+LL_DLLFunctions()\Params, 4)
            Log_Add("LL_DLLFunctions()\FuncName > "+LL_DLLFunctions()\FuncName, 4)
            Log_Add("LL_DLLFunctions()\FuncDesc > "+LL_DLLFunctions()\FuncDesc, 4)
            ; Type of the Return Value
            If Mid(sReturnValField, Len(sReturnValField)-1, 1) = "."
              Select Mid(sReturnValField, Len(sReturnValField), 1)
                Case "b"  : LL_DLLFunctions()\FuncRetType = "Byte"
                Case "c"  : LL_DLLFunctions()\FuncRetType = "Character"
                Case "d"  : LL_DLLFunctions()\FuncRetType = "Double"
                Case "f"  : LL_DLLFunctions()\FuncRetType = "Float"
                Case "q"  : LL_DLLFunctions()\FuncRetType = "Quad"
                Case "s"  : LL_DLLFunctions()\FuncRetType = "String"
                Case "w"  : LL_DLLFunctions()\FuncRetType = "Word"
                CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                  Default  : LL_DLLFunctions()\FuncRetType = "Long"
                CompilerElse ; 430
                  Case "l"  : LL_DLLFunctions()\FuncRetType = "Long"
                  Default  : LL_DLLFunctions()\FuncRetType = "Integer"
                CompilerEndIf
              EndSelect
            Else
              CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                LL_DLLFunctions()\FuncRetType = "Long"
              CompilerElse ; 430
                LL_DLLFunctions()\FuncRetType = "Long"
              CompilerEndIf
            EndIf
            Log_Add("LL_DLLFunctions()\FuncRetType > "+LL_DLLFunctions()\FuncRetType, 4)
            ; Type of Parameters
            For IncA = 1 To CountString(LL_DLLFunctions()\Params, ",")+1
              Select Right(Trim(StringField(LL_DLLFunctions()\Params, IncA, ",")), 1)
                Case "b"  : LL_DLLFunctions()\ParamsRetType + ", Byte"
                Case "c"  : LL_DLLFunctions()\ParamsRetType + ", Character"
                Case "d"  : LL_DLLFunctions()\ParamsRetType + ", Double"
                Case "f"  : LL_DLLFunctions()\ParamsRetType + ", Float"
                Case "q"  : LL_DLLFunctions()\ParamsRetType + ", Quad"
                Case "s"  : LL_DLLFunctions()\ParamsRetType + ", String"
                Case "w"  : LL_DLLFunctions()\ParamsRetType + ", Word"
                CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                  Default  : LL_DLLFunctions()\ParamsRetType + ", Long"
                CompilerElse ; 430
                  Case "l"  : LL_DLLFunctions()\ParamsRetType = ", Long"
                  Default  : LL_DLLFunctions()\ParamsRetType = ", Long"
                CompilerEndIf
              EndSelect
            Next
            Log_Add("LL_DLLFunctions()\ParamsRetType > "+LL_DLLFunctions()\ParamsRetType, 4)
          EndIf
        Else
          If TrCodeField = ":System"
            bInSystemLib = #True
          Else
            If Left(TrCodeField, 1) = ":"
              bInSystemLib = #False
            Else
              If bInSystemLib = #True
                AddElement(LL_DLLUsed())
                LL_DLLUsed() = TrCodeField
                Log_Add("LL_DLLUsed() > "+LL_DLLUsed(), 4)
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  Next
  CodeCleaned2 = ""
  ;}
  Log_Add("Remove some ASM code", 2)
  ;{ Remove some ASM code
  For Inc = 0 To CountString(CodeContent, #System_EOL)
    CodeField = StringField(CodeContent, Inc+1, #System_EOL)
    TrCodeField = ReplaceString(CodeField, Chr(13), "")
    TrCodeField = ReplaceString(TrCodeField, Chr(10), "")
    TrCodeField = Trim(TrCodeField)
    If Left(TrCodeField, 4) = "_PB_" And TrCodeField <> "_PB_EOP:" And TrCodeField <> "_PB_EOP_NoValue:" And TrCodeField <> "_PB_BSSSection:"    
    ; In cases of functions not defined in ProcedureDLL
      CodeCleaned + "PB_" + Right(CodeField, Len(CodeField)-4) + #System_EOL
      If AddElement(LL_Functions())
        LL_Functions() = Right(CodeField, Len(CodeField)-4)
        LL_Functions() = Left(TrCodeField, Len(TrCodeField)-1)
      EndIf
    Else    
        Select StringField(TrCodeField, 1, " ")
          Case "extrn"
          ;{
            Protected Function.s = StringField(TrCodeField, 2, " ")
            Protected Pos.l = FindString(Function, "_", 2)
            Protected LibName.s
            If Pos < Len(Function)-2
              Function = Right(Function, Len(Function)-Pos)
            EndIf
            LibName = Trim(PB_ListFunctions(Function))
            If LibName <> ""
              If AddElement(LL_LibUsed())
                LL_LibUsed() = LCase(LibName)
              EndIf
            EndIf
            If NotCapture = 0
              CodeCleaned + TrCodeField + #System_EOL
            EndIf
          ;}
          Case "public"
          ;{
            If NotCapture = 0
              Select StringField(TrCodeField, 2, " ")
                Case "main"
                  ;CodeCleaned + ";TB-Function-List" + #System_EOL
                Default
                  ;Do nothing
              EndSelect
            EndIf
          ;}
          Case "macro"     
          ;{
            If NotCapture = 1
              CodeCleaned + StringField(CodeContent, Inc-1, #System_EOL)+#System_EOL
            EndIf
            CodeCleaned + TrCodeField + #System_EOL
            NotCapture = 0
            sNameOfFunction = StringField(CodeContent, Inc, #System_EOL)
            sNameOfFunction = ReplaceString(sNameOfFunction, Chr(13), "")
            sNameOfFunction = ReplaceString(sNameOfFunction, Chr(10), "")
            sNameOfFunction = Trim(sNameOfFunction)
            sNameOfFunction = StringField(sNameOfFunction, 3, " ")
            sNameOfFunction = StringField(sNameOfFunction, 1, "(")
            sNameOfFunction = StringField(sNameOfFunction, 1, ".")
            ForEach LL_DLLFunctions()
              If LL_DLLFunctions()\FuncName = sNameOfFunction
                bInFunction = #True
                LL_DLLFunctions()\Win_ASMNameFunc = StringField(CodeContent, Inc+2, #System_EOL)
                LL_DLLFunctions()\Win_ASMNameFunc = ReplaceString(LL_DLLFunctions()\Win_ASMNameFunc, Chr(13), "")
                LL_DLLFunctions()\Win_ASMNameFunc = ReplaceString(LL_DLLFunctions()\Win_ASMNameFunc, Chr(10), "")
                LL_DLLFunctions()\Win_ASMNameFunc = Trim(LL_DLLFunctions()\Win_ASMNameFunc)
                LL_DLLFunctions()\Win_ASMNameFunc = ReplaceString(LL_DLLFunctions()\Win_ASMNameFunc, ":", "")
                Break
              EndIf
            Next
          ;}
          Case "main:"
          ;{
            NotCapture = 1
          ;}
          Case "JMP"
          ;{
            If NotCapture = 1
              NotCapture = 0
            Else
              CodeCleaned + TrCodeField + #System_EOL  
              If bInFunction = #True
                LL_DLLFunctions()\Code + TrCodeField + #System_EOL
              EndIf
            EndIf
          ;}
          Case "section"
          ;{
            If StringField(TrCodeField, 2, " ") = "'.text'"
              CodeCleaned + ";TB-Function-List" +#System_EOL + TrCodeField + #System_EOL
            EndIf
          ;}
          Case "}"
          ;{
            If bInFunction = #True
              bInFunction = #False
            EndIf
            CodeCleaned + TrCodeField + #System_EOL
          ;}
          Default
          ;{
            If NotCapture = 0
              CodeCleaned + TrCodeField + #System_EOL
              If bInFunction = #True
                LL_DLLFunctions()\Code + TrCodeField + #System_EOL
              EndIf
            EndIf
          ;}
        EndSelect
    EndIf
  Next
  ;}
  Log_Add("Create ASM Files", 2)
  ;{ Create ASM Files
    Protected lFile.l
    ; private functions
    For IncA = 0 To CountList(LL_DLLFunctions())-1
      SelectElement(LL_DLLFunctions(), IncA)
      CodeField   = LL_DLLFunctions()\FuncName        ;     Function Name
      TrCodeField = LL_DLLFunctions()\Win_ASMNameFunc ; ASM Function Name
      ForEach LL_DLLFunctions()
        If LL_DLLFunctions()\FuncName <> CodeField
          LL_DLLFunctions()\Code = ReplaceString(LL_DLLFunctions()\Code, TrCodeField, ReplaceString(gProject\Name, " ", "_")+"_"+CodeField)
        EndIf
      Next  
    Next  
    
    ForEach LL_DLLFunctions()
      lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
      If lFile
        WriteStringN(lFile, "format "+#System_LibFormat)
        WriteStringN(lFile, "")
        ;{ déclarations
        If LL_DLLFunctions()\IsDLLFunction = #True
          WriteStringN(lFile, "public PB_"+LL_DLLFunctions()\FuncName)
        Else
          WriteStringN(lFile, "public "+ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName)
        EndIf;}
        WriteStringN(lFile, "")
        ;{ extrn
        For IncA = 0 To CountString(LL_DLLFunctions()\Code, #System_EOL)
          CodeField = Trim(StringField(LL_DLLFunctions()\Code, IncA, #System_EOL))
          CodeField = ReplaceString(CodeField, Chr(13), "")
          CodeField = ReplaceString(CodeField, Chr(10), "")
          If LCase(StringField(CodeField, 1, " ")) = "call"
            WriteStringN(lFile, "extrn "+StringField(CodeField, CountString(CodeField, " ")+1, " "))
          EndIf
        Next;}
        WriteStringN(lFile, "")      
        ;{ code
        If LL_DLLFunctions()\IsDLLFunction = #True
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
            ;{
              CodeField = LL_DLLFunctions()\Code
              CodeField = Trim(StringField(CodeField, 1, #System_EOL))+#System_EOL
              CodeField + "PB_"+LL_DLLFunctions()\FuncName +":"+#System_EOL
              CodeField + Right(LL_DLLFunctions()\Code, Len(LL_DLLFunctions()\Code) - Len(StringField(LL_DLLFunctions()\Code, 1, #System_EOL)))
            ;}
            CompilerCase #PB_OS_Linux
            ;{
              CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName,"PB_"+LL_DLLFunctions()\FuncName)
            ;}
          CompilerEndSelect
          WriteStringN(lFile, CodeField)
        Else
          CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName, ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName)
          If Right(Trim(StringField(CodeField, 1, #System_EOL)), 1) = ":" ; declaration de la function
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Windows
              ;{
                TrCodeField = Trim(StringField(CodeField, 1, #System_EOL))+#System_EOL
                TrCodeField + ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
              ;}
              CompilerCase #PB_OS_Linux
              ;{
                TrCodeField = ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
              ;}
            CompilerEndSelect
            TrCodeField + Right(CodeField, Len(CodeField) - Len(StringField(CodeField, 1, #System_EOL)))
          EndIf
          WriteStringN(lFile, TrCodeField)
        EndIf;}
        CloseFile(lFile)
      EndIf
    Next
    ; _Init Function
    If AddElement(LL_DLLFunctions())
      LL_DLLFunctions()\FuncName = ReplaceString(gProject\Name, " ", "_")+"_Init" 
      LL_DLLFunctions()\FuncRetType = "InitFunction"
      LL_DLLFunctions()\FuncDesc = ""
      LL_DLLFunctions()\Params = ""
      LL_DLLFunctions()\ParamsRetType = ""
      LL_DLLFunctions()\Code = "format "+#System_LibFormat + #System_EOL
      LL_DLLFunctions()\Code + "" + #System_EOL
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows : LL_DLLFunctions()\Code + "extrn _SYS_InitString@0" + #System_EOL
        CompilerCase #PB_OS_Linux : LL_DLLFunctions()\Code + "extrn SYS_InitString" + #System_EOL
      CompilerEndSelect
      LL_DLLFunctions()\Code + "" + #System_EOL
      LL_DLLFunctions()\Code + "Public PB_"+ReplaceString(gProject\Name, " ", "_")+"_Init"  + #System_EOL
      LL_DLLFunctions()\Code + "" + #System_EOL
      LL_DLLFunctions()\Code + "PB_"+ReplaceString(gProject\Name, " ", "_")+"_Init:" + #System_EOL
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows : LL_DLLFunctions()\Code + "CALL _SYS_InitString@0" + #System_EOL
        CompilerCase #PB_OS_Linux : LL_DLLFunctions()\Code + "CALL SYS_InitString" + #System_EOL
      CompilerEndSelect
      LL_DLLFunctions()\Code + "RET " + #System_EOL
      LL_DLLFunctions()\IsDLLFunction.b = #False
    EndIf
    lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
    If lFile
      WriteStringN(lFile, LL_DLLFunctions()\Code)
      CloseFile(lFile)
    EndIf

;     CodeCleaned.s = RemoveString(CodeCleaned, #CR$)
;     ForEach LL_Functions()
;       FunctionList.s + "public " + LL_Functions() + #System_EOL
;     Next
;     ForEach LL_DLLFunctions()
;       FunctionList.s + "public PB_" +  LL_DLLFunctions()\FuncName + #System_EOL
;     Next
;     CodeCleaned = ReplaceString(CodeCleaned, ";TB-Function-List", FunctionList)
;     For Inc = 0 To CountString(CodeCleaned, #System_EOL)
;       CodeField = StringField(CodeCleaned, Inc, #System_EOL)
;       TrCodeField = Trim(CodeField)
;       ForEach LL_DLLFunctions()
;         If LL_DLLFunctions()\FuncName+":" = TrCodeField
;           TrCodeField = "PB_"+TrCodeField
;           Break
;         EndIf
;       Next
;       CodeCleaned2 + TrCodeField + #System_EOL
;     Next
  ;}
  Log_Add("Rewrite the new ASM Code", 2)
  ;{ Rewrite the new ASM Code
  If CreateFile(0, gProject\FileAsm)
    WriteString(0,CodeCleaned)
    CloseFile(0)
  EndIf
  ;}
EndProcedure

ProcedureDLL Moebius_Compile_Step3()
  ; 3. FASM compiles the ASM files created by tailbite To OBJ
  ;     Compiling ASM sources
  ForEach LL_DLLFunctions()
    RunProgram(gConf_Path_FASM, #DQuote+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+#DQuote+" "+#DQuote+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote, "", #PB_Program_Wait|#PB_Program_Hide)
  Next
EndProcedure

ProcedureDLL Moebius_Compile_Step4()
  ; 4. POLIB creates the LIB library from the *.OBJ files
  ; Creating descriptor file
  Log_Add("Creating descriptor file", 2)
  Protected StringTmp.s
  Protected hDescFile.l = CreateFile(#PB_Any, gProject\FileDesc)
  If hDescFile
    WriteStringN(hDescFile,"ASM") 
    Log_Add("ASM", 4)
    ; Lib Systems
    WriteStringN(hDescFile,Str(CountList(LL_DLLUsed())))
    Log_Add(Str(CountList(LL_DLLUsed())), 4)
    ForEach LL_DLLUsed()
      WriteStringN(hDescFile, LL_DLLUsed())
      Log_Add(LL_DLLUsed(), 4)
    Next
    WriteStringN(hDescFile,"LIB")
    Log_Add("LIB", 4)
    StringTmp=""
    ForEach LL_LibUsed()
      If LL_LibUsed() = "glibc"
        DeleteElement(LL_LibUsed())
      EndIf
    Next
    ForEach LL_LibUsed()
      If FindString(StringTmp,"~"+LL_LibUsed()+"~",1)
        DeleteElement(LL_LibUsed(),1)
      EndIf
    Next
    ForEach LL_LibUsed()
      StringTmp=StringTmp+"~"+LL_LibUsed()+"~"
    Next
    WriteStringN(hDescFile,Str(CountList(LL_LibUsed())))
    Log_Add(Str(CountList(LL_LibUsed())), 4)
    StringTmp=""
    ForEach LL_LibUsed()
      WriteStringN(hDescFile,LL_LibUsed())
      Log_Add(LL_LibUsed(), 4)
    Next
    WriteStringN(hDescFile, gProject\FileCHM)
    Log_Add(gProject\FileCHM, 4)
    ForEach LL_DLLFunctions()
      If LL_DLLFunctions()\FuncRetType <> "InitFunction"
        If LL_DLLFunctions()\IsDLLFunction = #True
          StringTmp = LL_DLLFunctions()\FuncName+LL_DLLFunctions()\ParamsRetType+" ("+LL_DLLFunctions()\Params+")"
          If LL_DLLFunctions()\FuncDesc = ""
            LL_DLLFunctions()\FuncDesc + " - "+LL_DLLFunctions()\FuncDesc
          EndIf
          WriteStringN(hDescFile, StringTmp)
          Log_Add(StringTmp, 4)
          WriteStringN(hDescFile, LL_DLLFunctions()\FuncRetType+" | StdCall") 
          Log_Add(LL_DLLFunctions()\FuncRetType+" | StdCall", 4)
        EndIf
      Else ; FuncType = InitFunction
        WriteStringN(hDescFile, LL_DLLFunctions()\FuncName)
        Log_Add(LL_DLLFunctions()\FuncName, 4)
        WriteStringN(hDescFile, LL_DLLFunctions()\FuncRetType+" | StdCall") 
        Log_Add(LL_DLLFunctions()\FuncRetType+" | StdCall", 4)
      EndIf
    Next
    CloseFile(hDescFile)
  EndIf
  ; Creating archive
  Log_Add("Creating archive", 2)
  ; Generates a file which contains all objects files
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows;{
      Protected hObjFile.l = CreateFile(#PB_Any, gProject\DirObj+"ObjList.txt")
      If hObjFile
        ForEach LL_DLLFunctions()
          WriteStringN(hObjFile, #DQuote+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote)
        Next
        CloseFile(hObjFile)
      EndIf
      RunProgram(gConf_Path_OBJ2LIB, "/out:"+#DQuote+gProject\FileLib+#DQuote+" @"+#DQuote+gProject\DirObj+"ObjList.txt"+#DQuote, "", #PB_Program_Wait|#PB_Program_Hide)
    ;}
    CompilerCase #PB_OS_Linux;{
      StringTmp = "ar rvs "
      StringTmp + #DQuote+gProject\FileLib+#DQuote+" "
      StringTmp + gProject\DirObj + "*"+#System_ExtObj
      system_(@StringTmp)
    ;}
  CompilerEndSelect
EndProcedure

ProcedureDLL Moebius_Compile_Step5()
  ; 5. LibraryMaker creates userlibrary from the LIB file
  Protected DirUserLibrary.s = gConf_PureBasic_Path + "purelibraries"+#System_Separator+"userlibraries"+#System_Separator
  RunProgram(gConf_Path_PBLIBMAKER, #DQuote+gProject\FileDesc+#DQuote+" /To "+#DQuote+DirUserLibrary+#DQuote+" "+#Switch_NoUnicodeWarning, gConf_ProjectDir, #PB_Program_Wait|#PB_Program_Hide)
  If FileSize(DirUserLibrary+gProject\LibName)>0
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
EndProcedure

ProcedureDLL Moebius_Compile_Step6()
  ; 6. Cleans the place
;   Protected hFile = ReadFile(#PB_Any,gConf_SourceDir+#System_Separator+"purebasic.out")
;   If hFile
;     CloseFile(hFile)
;     DeleteFile(gConf_SourceDir+#System_Separator+"purebasic.out")
;   EndIf
  Log_End()
EndProcedure

; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; EnableXP
; UseMainFile = Moebius_Main.pb