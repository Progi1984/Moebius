DeclareDLL Moebius_Compile_Step0()
DeclareDLL Moebius_Compile_Step1()
DeclareDLL Moebius_Compile_Step2()
DeclareDLL Moebius_Compile_Step3()
DeclareDLL Moebius_Compile_Step4()
DeclareDLL Moebius_Compile_Step5()
DeclareDLL Moebius_Compile_Step6()

ProcedureDLL Moebius_MainThread(Param.l)
  Moebius_Compile_Step0()
  Moebius_Compile_Step1()
  Moebius_Compile_Step2()
  Moebius_Compile_Step3()
  Moebius_Compile_Step4()
  Moebius_Compile_Step5()
  Moebius_Compile_Step6()
EndProcedure

ProcedureDLL Moebius_Compile_Step0()
  ; 0. Prepares the location for Moebius
  DeleteDirectory(gConf_ProjectDir, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
  CreateDirectory(gConf_ProjectDir)
  CreateDirectory(gConf_ProjectDir+"ASM"+#System_Separator)
  CreateDirectory(gConf_ProjectDir+"DESC"+#System_Separator)
  CreateDirectory(gConf_ProjectDir+"LIB"+#System_Separator)
  CreateDirectory(gConf_ProjectDir+"OBJ"+#System_Separator)
EndProcedure
ProcedureDLL Moebius_Compile_Step1()
  ; 1. PBCOMPILER creates the EXE (using POLINK) that we don't need, but also the ASM file (/COMMENTED)
  RunProgram(gConf_Path_PBCOMPILER, gConf_SourceDir+"Sample_00.pb "+#Switch_Commented,gConf_ProjectDir, #PB_Program_Wait)
EndProcedure
ProcedureDLL Moebius_Compile_Step2()
  ; 2. TAILBITE grabs the ASM file, splits it, rewrites some parts
  Protected CodeContent.s, CodeCleaned.s, CodeCleaned2.s, CodeField.s, TrCodeField.s, FunctionList.s
  Protected Inc.l, IncA.l, NotCapture.l, lFound.l
  Protected bInFunction.b
  Protected sNameOfFunction.s, sCallExtrn.s
  If ReadFile(0, gConf_ProjectDir+"purebasic.asm")
    CodeContent = Space(Lof(0)+1)
    ReadData(0,@CodeContent, Lof(0))
    CloseFile(0)
  EndIf
  ;{ Extracts information for the future creation of the DESC File
  Debug CountString(CodeContent, #System_EOL)
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
          AddElement(LL_DLLFunctions())
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
          Debug StringField(TrCodeField, 1, " ")
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
      EndIf
    EndIf
  Next
  CodeCleaned2 = ""
  ;}
  ;{ Remove some ASM code
  For Inc = 0 To CountString(CodeContent, #System_EOL)
    CodeField = StringField(CodeContent, Inc, #System_EOL)
    TrCodeField = Trim(CodeField)
    If Left(TrCodeField, 4) = "_PB_" And TrCodeField <> "_PB_EOP:" And TrCodeField <> "_PB_EOP_NoValue:" And TrCodeField <> "_PB_BSSSection:"    
    ; In cases of functions not defined in ProcedureDLL
        CodeCleaned + "PB_" + Right(CodeField, Len(CodeField)-4) + #System_EOL
        AddElement(LL_Functions())
        LL_Functions() = Right(CodeField, Len(CodeField)-4)
        LL_Functions() = Left(TrCodeField, Len(TrCodeField)-1)    
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
              AddElement(LL_LibUsed())
              LL_LibUsed() = LCase(LibName)
            EndIf
            If NotCapture = 0
              CodeCleaned + CodeField + #System_EOL
            EndIf
          ;}
          Case "public"
          ;{
            If NotCapture = 0
              Select StringField(CodeField, 2, " ")
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
            CodeCleaned + CodeField + #System_EOL
            NotCapture = 0
            sNameOfFunction = StringField(StringField(StringField(StringField(CodeContent, Inc-1, #System_EOL), 3, " "), 1, "("), 1, ".")
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
              CodeCleaned + CodeField + #System_EOL
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
            CodeCleaned + CodeField + #System_EOL
          ;}
          Default
          ;{
            If NotCapture = 0
              CodeCleaned + CodeField + #System_EOL
              If bInFunction = #True
                LL_DLLFunctions()\Code + CodeField + #System_EOL
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
      WriteStringN(lFile, "format ELF")
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
        CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName,"PB_"+LL_DLLFunctions()\FuncName)
        WriteStringN(lFile, CodeField)
      Else
        CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName, ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName)
        If Right(Trim(StringField(CodeField, 1, #System_EOL)), 1) = ":" ; declaration de la function
          TrCodeField = ReplaceString(gProject\Name, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
          TrCodeField + Right(CodeField, Len(CodeField) - Len(StringField(CodeField, 1, #System_EOL)))
        EndIf
        WriteStringN(lFile, TrCodeField)
      EndIf;}
      CloseFile(lFile)
    Next
    ; _Init Function
    AddElement(LL_DLLFunctions())
    LL_DLLFunctions()\FuncName = ReplaceString(gProject\Name, " ", "_")+"_Init" 
    LL_DLLFunctions()\FuncRetType = "InitFunction"
    LL_DLLFunctions()\FuncDesc = ""
    LL_DLLFunctions()\Params = ""
    LL_DLLFunctions()\ParamsRetType = ""
    LL_DLLFunctions()\Code = "format ELF" + #System_EOL
    LL_DLLFunctions()\Code + "extrn _SYS_InitString@0" + #System_EOL
    LL_DLLFunctions()\Code + "Public PB_"+ReplaceString(gProject\Name, " ", "_")+"_Init"  + #System_EOL
    ;LL_DLLFunctions()\Code + "section '.text' code readable executable" + #System_EOL
    LL_DLLFunctions()\Code + "PB_"+ReplaceString(gProject\Name, " ", "_")+"_Init:" + #System_EOL
    LL_DLLFunctions()\Code + "call _SYS_InitString@0" + #System_EOL
    LL_DLLFunctions()\Code + "RET " + #System_EOL
    LL_DLLFunctions()\IsDLLFunction.b = #False
    lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
      WriteStringN(lFile, LL_DLLFunctions()\Code)
    CloseFile(lFile)


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
    RunProgram(gConf_Path_FASM, Chr(34)+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm"+Chr(34)+" "+Chr(34)+gProject\DirObj+#System_Separator+LL_DLLFunctions()\FuncName+#System_ExtObj+Chr(34), "", #PB_Program_Wait)
  Next
EndProcedure
ProcedureDLL Moebius_Compile_Step4()
  ; 4. POLIB creates the LIB library from the *.OBJ files
  ; Creating descriptor file
  Protected StringTmp.s
  Protected hDescFile.l = CreateFile(#PB_Any, gProject\FileDesc)
  If hDescFile
    WriteStringN(hDescFile,"ASM")
    WriteStringN(hDescFile,"0")
    WriteStringN(hDescFile,"OBJ")
    StringTmp=""
    ForEach LL_LibUsed()
      If LL_LibUsed() = "glibc"
        DeleteElement(LL_LibUsed())
      EndIf
    Next
    ForEach LL_LibUsed()
      If FindString(StringTmp,"~"+LL_LibUsed()+"~",1)
        DeleteElement(LL_LibUsed(),1)
      Else
        StringTmp=StringTmp+"~"+LL_LibUsed()+"~"
      EndIf
    Next
    WriteStringN(hDescFile,Str(CountList(LL_LibUsed())))
    StringTmp=""
    ForEach LL_LibUsed()
      WriteStringN(hDescFile,LL_LibUsed())
    Next
    WriteStringN(hDescFile,gProject\LibName)
    ForEach LL_DLLFunctions()
      If LL_DLLFunctions()\FuncRetType <> "InitFunction"
        WriteStringN(hDescFile,LL_DLLFunctions()\FuncName+LL_DLLFunctions()\ParamsRetType+" ("+LL_DLLFunctions()\Params+") - "+LL_DLLFunctions()\FuncDesc)
      Else ; FuncType = InitFunction
        WriteStringN(hDescFile,LL_DLLFunctions()\FuncName)
      EndIf
      WriteStringN(hDescFile,LL_DLLFunctions()\FuncRetType+" | StdCall")        
    Next
    CloseFile(hDescFile)
  EndIf
  ; Creating archive
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    RunProgram(gConf_Path_OBJ2LIB, "/out:"+Chr(34)+gProject\FileLib+Chr(34)+" "+Chr(34)+gProject\DirObj +Chr(34), "", #PB_Program_Wait)
  CompilerElse
    StringTmp = "rvs "
    StringTmp + Chr(34)+gProject\FileLib+Chr(34)+" "
    StringTmp + gProject\DirObj + "*"+#System_ExtObj
    ;ForEach LL_DLLFunctions()
    ;  StringTmp + Chr(34)+gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+#System_ExtObj+Chr(34)+" "
    ;Next
    Debug StringTmp
    RunProgram("ar ", StringTmp, "", #PB_Program_Wait)
    ;RunProgram("ar ", "rvs "+Chr(34)+gProject\FileA+Chr(34)+" "+gProject\DirObj+"*"+#System_ExtObj, "", #PB_Program_Wait)
  CompilerEndIf
EndProcedure
ProcedureDLL Moebius_Compile_Step5()
  ; 5. LibraryMaker creates userlibrary from the LIB file
  ;RunProgram(gConf_Path_PBLIBMAKER, Chr(34)+gProject\FileDesc+Chr(34)+" /To "+Chr(34)+gConf_PureBasic_Path+"purelibraries"+#System_Separator+"userlibraries"+#System_Separator+Chr(34), gConf_ProjectDir, #PB_Program_Wait)
EndProcedure
ProcedureDLL Moebius_Compile_Step6()
  ; 6. Cleans the place
;   Protected hFile = ReadFile(#PB_Any,gConf_SourceDir+#System_Separator+"purebasic.out")
;   If hFile
;     CloseFile(hFile)
;     DeleteFile(gConf_SourceDir+#System_Separator+"purebasic.out")
;   EndIf
EndProcedure

; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 55
; Folding = AAAg
; EnableXP
; UseMainFile = Moebius_Main.pb