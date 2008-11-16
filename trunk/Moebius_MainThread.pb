DeclareDLL Moebius_Compile_Step0()
DeclareDLL Moebius_Compile_Step1()
DeclareDLL Moebius_Compile_Step2()
DeclareDLL Moebius_Compile_Step3()
DeclareDLL Moebius_Compile_Step4()
DeclareDLL Moebius_Compile_Step5()
DeclareDLL Moebius_Compile_Step6()

ProcedureDLL Moebius_MainThread(Param.l)
  Protected Step1.l
  Moebius_Compile_Step0()
  Step1 = Moebius_Compile_Step1()
  If Step1 = #True
    Moebius_Compile_Step2()
    Moebius_Compile_Step3()
    Moebius_Compile_Step4()
    Moebius_Compile_Step5()
    ;Moebius_Compile_Step6()
  EndIf
EndProcedure

ProcedureDLL Moebius_Compile_Step0()
  ; 0. Prepares the location for Moebius
  If DeleteDirectory(gConf_ProjectDir, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
    If CreateDirectory(gConf_ProjectDir)
      If CreateDirectory(gConf_ProjectDir+"ASM"+#System_Separator)
        If CreateDirectory(gConf_ProjectDir+"DESC"+#System_Separator)
          If CreateDirectory(gConf_ProjectDir+"LIB"+#System_Separator)
            If CreateDirectory(gConf_ProjectDir+"OBJ"+#System_Separator)
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
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

ProcedureDLL Moebius_Compile_Step1()
  ; 1. PBCOMPILER creates the EXE (using POLINK) that we don't need, but also the ASM file (/COMMENTED)
  ;RunProgram(gConf_Path_PBCOMPILER, gConf_SourceDir+"Sample_00.pb "+#Switch_Commented, gConf_ProjectDir, #PB_Program_Wait)
  
  ; Retourne #true si le fichier asm a correctement été créé sinon retourne une valeur négative
  ; qui dépend du lieu de l'erreur, permet de trouver rapidement ou se situe l'erreur

  ; mémorise le nom du fichier exe, mais en fait la variable est vide
  Protected FichierExe.s = ""
  ; mémorise la chaine retournée par le compilateur lors de la création du fichier asm
  Protected Sortie.s = ""
  ; mémorise le résultat de la fonction Runprogram
  Protected Compilateur
  
  ; on teste si le fichier se fini par "pb ou pbi"
  ; si oui on continue sinon on retourrne #False
  
  Select LCase(GetExtensionPart(gProject\FileName))
    Case "pb" ; we define the name of executable file
      FichierExe = gConf_ProjectDir + Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))) + "exe"
    Case "pbi" ; we define the name of executable file
      FichierExe = gConf_ProjectDir + Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))) + "exe"
    Default ; it's not a purebasic file
      ProcedureReturn #False
  EndSelect

  ; we delete the last asm created
  SetFileAttributes(gConf_ProjectDir + "PureBasic.asm", #PB_FileSystem_Normal)
  DeleteFile(gConf_ProjectDir + "PureBasic.asm")
  
  Compilateur = RunProgram(gConf_Path_PBCOMPILER, Chr(34) + gProject\FileName + Chr(34) + " /INLINEASM /COMMENTED /EXE " + Chr(34) + FichierExe + Chr(34) , gConf_ProjectDir, #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  If Compilateur
    While ProgramRunning(Compilateur)
      Sortie + ReadProgramString(Compilateur) + Chr(13)
    Wend
  EndIf
  
  If ProgramExitCode(Compilateur) = 0
    ; Test if the result is true 
    ; The last returned ligne is "- Feel the ..PuRe.. Power -"
    If FindString(Sortie, "- Feel the ..PuRe.. Power -", 0)
      ; we delete the last excutable created
      If DeleteFile(FichierExe)
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
    Else ; we delete the last executable created
      DeleteFile(FichierExe)
      ProcedureReturn #False - 1
    EndIf
  Else ; we delete the last executable created
    DeleteFile(FichierExe)
    ProcedureReturn #False - 2
  EndIf
EndProcedure

ProcedureDLL Moebius_Compile_Step2()
  ; 2. TAILBITE grabs the ASM file, splits it, rewrites some parts
  Protected CodeContent.s, CodeCleaned.s, CodeCleaned2.s, CodeField.s, TrCodeField.s, FunctionList.s
  Protected Inc.l, IncA.l, NotCapture.l, lFound.l
  Protected bInFunction.b, bInSystemLib.b
  Protected sNameOfFunction.s, sCallExtrn.s
  If ReadFile(0, gConf_ProjectDir+"purebasic.asm")
    CodeContent = Space(Lof(0)+1)
    ReadData(0,@CodeContent, Lof(0))
    CloseFile(0)
  EndIf
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
            TrCodeField = ReplaceString(TrCodeField, "proceduredll", "")
            TrCodeField = ReplaceString(TrCodeField, "ProcedureDLL", "")
            TrCodeField = ReplaceString(TrCodeField, "procedurecdll", "")
            TrCodeField = ReplaceString(TrCodeField, "ProcedureCDLL", "")
            TrCodeField = ReplaceString(TrCodeField, "procedure", "")
            TrCodeField = ReplaceString(TrCodeField, "Procedure", "")
            TrCodeField = ReplaceString(TrCodeField, "procedurec", "")
            TrCodeField = ReplaceString(TrCodeField, "ProcedureC", "")
            TrCodeField = Trim(TrCodeField)
            TrCodeField = ReplaceString(TrCodeField, "  ", " ")
            TrCodeField = ReplaceString(TrCodeField, " .", ".")
            TrCodeField = ReplaceString(TrCodeField, " ,", ",")
            TrCodeField = ReplaceString(TrCodeField, ", ", ",")
            TrCodeField = ReplaceString(TrCodeField, " (", "(")
            LL_DLLFunctions()\FuncName = StringField(TrCodeField, 1, " ")
            LL_DLLFunctions()\Params = Right(LL_DLLFunctions()\FuncName, Len(LL_DLLFunctions()\FuncName)-(FindString(LL_DLLFunctions()\FuncName, "(", 1)))
            LL_DLLFunctions()\Params = Left(LL_DLLFunctions()\Params, (FindString(LL_DLLFunctions()\Params, ")", 1)-1))
            LL_DLLFunctions()\FuncName = Trim(Left(LL_DLLFunctions()\FuncName, FindString(LL_DLLFunctions()\FuncName, "(", 1)-1))
            If FindString(TrCodeField, ";",1) > 0
              LL_DLLFunctions()\FuncDesc = Right(TrCodeField, Len(TrCodeField) - FindString(TrCodeField, ";",1))
            EndIf
            ; Type of the Return Value
            If Mid(LL_DLLFunctions()\FuncName, Len(LL_DLLFunctions()\FuncName)-1, 1) = "."
              Select Mid(LL_DLLFunctions()\FuncName, Len(LL_DLLFunctions()\FuncName), 1)
                Case "b"  : LL_DLLFunctions()\FuncRetType = "Byte"
                Case "c"  : LL_DLLFunctions()\FuncRetType = "Character"
                Case "d"  : LL_DLLFunctions()\FuncRetType = "Double"
                Case "f"  : LL_DLLFunctions()\FuncRetType = "Float"
                Case "q"  : LL_DLLFunctions()\FuncRetType = "Quad"
                Case "s"  : LL_DLLFunctions()\FuncRetType = "String"
                Case "w"  : LL_DLLFunctions()\FuncRetType = "Word"
                Default  : LL_DLLFunctions()\FuncRetType = "Long"
              EndSelect
            Else
              LL_DLLFunctions()\FuncRetType = "Long"
            EndIf
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
                Default  : LL_DLLFunctions()\ParamsRetType + ", Long"
              EndSelect
            Next
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
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  Next
  CodeCleaned2 = ""
  ;}
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
  ;{ Create ASM Files
    Protected lFile.l
    ForEach LL_DLLFunctions()
      lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
      If lFile
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          WriteStringN(lFile, "format MS COFF")
        CompilerElse
          WriteStringN(lFile, "format ELF")
        CompilerEndIf
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
          If LCase(StringField(CodeField, 1, " ")) = "call"
            WriteStringN(lFile, "extrn "+StringField(CodeField, CountString(CodeField, " ")+1, " "))
          EndIf
        Next;}
        WriteStringN(lFile, "")      
        ;{ code
        If LL_DLLFunctions()\IsDLLFunction = #True
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            CodeField = Trim(StringField(CodeField, 1, #System_EOL))+#System_EOL
            CodeField + "PB_"+LL_DLLFunctions()\FuncName +":"
          CompilerElse
            CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName,"PB_"+LL_DLLFunctions()\FuncName)
          CompilerEndIf
          WriteStringN(lFile, CodeField)
        Else
          CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName, ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName)
          If Right(Trim(StringField(CodeField, 1, #System_EOL)), 1) = ":" ; declaration de la function
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              TrCodeField = Trim(StringField(CodeField, 1, #System_EOL))+#System_EOL
              TrCodeField + ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
            CompilerElse
              TrCodeField = ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
            CompilerEndIf
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
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        LL_DLLFunctions()\Code = "format MS COFF" + #System_EOL
      CompilerElse
        LL_DLLFunctions()\Code = "format ELF" + #System_EOL
      CompilerEndIf
      LL_DLLFunctions()\Code + "extrn _SYS_InitString@0" + #System_EOL
      LL_DLLFunctions()\Code + "Public PB_"+ReplaceString(gProject\Name, " ", "_")+"_Init"  + #System_EOL
      LL_DLLFunctions()\Code + "PB_"+ReplaceString(gProject\Name, " ", "_")+"_Init:" + #System_EOL
      LL_DLLFunctions()\Code + "call _SYS_InitString@0" + #System_EOL
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
  ;RunProgram(gConf_Path_FASM, Chr(34)+gProject\FileAsm+Chr(34)+" "+Chr(34)+gProject\FileO+Chr(34), "", #PB_Program_Wait) 
  ForEach LL_DLLFunctions()
    RunProgram(gConf_Path_FASM, Chr(34)+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+Chr(34)+" "+Chr(34)+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+Chr(34), "", #PB_Program_Wait)
  Next
EndProcedure

ProcedureDLL Moebius_Compile_Step4()
  ; 4. POLIB creates the LIB library from the *.OBJ files
  ; Creating descriptor file
  Protected StringTmp.s
  Protected hDescFile.l = CreateFile(#PB_Any, gProject\FileDesc)
  If hDescFile
    WriteStringN(hDescFile,"ASM")
    ; Lib Systems
    WriteStringN(hDescFile,Str(CountList(LL_DLLUsed())))
    ForEach LL_DLLUsed()
      WriteStringN(hDescFile, LL_DLLUsed())
    Next
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      WriteStringN(hDescFile,"LIB")
    CompilerElse
      WriteStringN(hDescFile,"OBJ")
    CompilerEndIf
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
    StringTmp=""
    ForEach LL_LibUsed()
      WriteStringN(hDescFile,LL_LibUsed())
    Next
    WriteStringN(hDescFile, gProject\FileCHM)
    ForEach LL_DLLFunctions()
      If LL_DLLFunctions()\FuncRetType <> "InitFunction"
        If LL_DLLFunctions()\IsDLLFunction = #True
          StringTmp = LL_DLLFunctions()\FuncName+LL_DLLFunctions()\ParamsRetType+" ("+LL_DLLFunctions()\Params+")"
          If LL_DLLFunctions()\FuncDesc = ""
            LL_DLLFunctions()\FuncDesc + " - "+LL_DLLFunctions()\FuncDesc
          EndIf
          WriteStringN(hDescFile, StringTmp)
          WriteStringN(hDescFile, LL_DLLFunctions()\FuncRetType+" | StdCall") 
        EndIf
      Else ; FuncType = InitFunction
        WriteStringN(hDescFile, LL_DLLFunctions()\FuncName)
        WriteStringN(hDescFile, LL_DLLFunctions()\FuncRetType+" | StdCall") 
      EndIf
    Next
    CloseFile(hDescFile)
  EndIf
  ; Creating archive
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ; Generates a file which contains all objects files
    Protected hObjFile.l = CreateFile(#PB_Any, gProject\DirObj+"ObjList.txt")
    If hObjFile
      ForEach LL_DLLFunctions()
        WriteStringN(hObjFile, Chr(34)+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+Chr(34))
      Next
      CloseFile(hObjFile)
    EndIf
    RunProgram(gConf_Path_OBJ2LIB, "/out:"+Chr(34)+gProject\FileLib+Chr(34)+" @"+Chr(34)+gProject\DirObj+"ObjList.txt"+Chr(34), "", #PB_Program_Wait)
  CompilerElse
    StringTmp = "ar rvs "
    StringTmp + Chr(34)+gProject\FileLib+Chr(34)+" "
    StringTmp + gProject\DirObj + "*"+#System_ExtObj
    ;ForEach LL_DLLFunctions()
    ;  StringTmp + Chr(34)+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+#System_ExtObj+Chr(34)+" "
    ;Next
    system_(@StringTmp)
    ;RunProgram("ar ", StringTmp, "", #PB_Program_Wait)
    ;RunProgram("/usr/bin/ar ", "rvs "+Chr(34)+gProject\FileA+Chr(34)+" "+#Work_Dir+"Lib_Source"+#System_Separator+gProject\LibName+#System_Separator+"OBJ"+#System_Separator+"*.o", "", #PB_Program_Wait)
    ;RunProgram("/usr/bin/ar rvs "+Chr(34)+"/home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/LIB/Sample_00.a"+Chr(34)+" /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/OBJ/*.o", "", "", #PB_Program_Wait)
    ;RunProgram("ar ", StringTmp, "", #PB_Program_Wait)
    
    ; Denis
    ;RunProgram("/usr/bin/ar rvs", Chr(34)+" /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/LIB/Sample_00.a"+Chr(34)+" /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/OBJ/*.o"+Chr(34), "", #PB_Program_Wait)
    ;RunProgram("/usr/bin/ar rvs", Chr(34)+" /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/LIB/Sample_00.a /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/OBJ/*.o"+Chr(34), "", #PB_Program_Wait)
    ;RunProgram("/usr/bin/ar", Chr(34)+ " rvs "+Chr(34)+"/home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/LIB/Sample_00.a"+Chr(34)+" /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/OBJ/*.o" +Chr(34), "", #PB_Program_Wait)
    ;RunProgram("/usr/bin/ar", Chr(34)+ " rvs /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/LIB/Sample_00.a /home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Samples00/OBJ/*.o" +Chr(34), "", #PB_Program_Wait)
    ;RunProgram("ar ", "rvs "+Chr(34)+gProject\FileA+Chr(34)+" "+gProject\DirObj+"*"+#System_ExtObj, "", #PB_Program_Wait)
  CompilerEndIf
EndProcedure

ProcedureDLL Moebius_Compile_Step5()
  ; 5. LibraryMaker creates userlibrary from the LIB file
  RunProgram(gConf_Path_PBLIBMAKER, Chr(34)+gProject\FileDesc+Chr(34)+" /To "+Chr(34)+gConf_PureBasic_Path+"purelibraries"+#System_Separator+"userlibraries"+#System_Separator+Chr(34), gConf_ProjectDir, #PB_Program_Wait|#PB_Program_Hide)
EndProcedure

ProcedureDLL Moebius_Compile_Step6()
  ; 6. Cleans the place
;   Protected hFile = ReadFile(#PB_Any,gConf_SourceDir+#System_Separator+"purebasic.out")
;   If hFile
;     CloseFile(hFile)
;     DeleteFile(gConf_SourceDir+#System_Separator+"purebasic.out")
;   EndIf
EndProcedure

; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 522
; Folding = CwHAMAQ3paAAkCKu6
; EnableXP
; UseMainFile = Moebius_Main.pb