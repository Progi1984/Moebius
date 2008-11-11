DeclareDLL Moebius_Compile_Step0()
DeclareDLL Moebius_Compile_Step1()
DeclareDLL Moebius_Compile_Step2()
DeclareDLL Moebius_Compile_Step3()
DeclareDLL Moebius_Compile_Step4()
DeclareDLL Moebius_Compile_Step5()

ProcedureDLL Moebius_MainThread(Param.l)
  Moebius_Compile_Step0()
  Moebius_Compile_Step1()
  Moebius_Compile_Step2()
  Moebius_Compile_Step3()
  Moebius_Compile_Step4()
  Moebius_Compile_Step5()
EndProcedure

ProcedureDLL Moebius_Compile_Step0()
  ; 0. Prepares the location for Moebius
  DeleteDirectory(#Work_Dir+"Lib_Source"+#System_Separator+gProject\Name+#System_Separator, "*.*", #PB_FileSystem_Force | #PB_FileSystem_Recursive)
  CreateDirectory(#Work_Dir+"Lib_Source"+#System_Separator+gProject\Name+#System_Separator)
EndProcedure
ProcedureDLL Moebius_Compile_Step1()
  ; 1. PBCOMPILER creates the EXE (using POLINK) that we don't need, but also the ASM file (/COMMENTED)
  RunProgram(#PureBasic_Path+"compilers"+#System_Separator+"pbcompiler"+#System_ExtExec, #Sample_Dir+"Sample_00.pb "+#Switch_Commented,"", #PB_Program_Wait)
EndProcedure
ProcedureDLL Moebius_Compile_Step2()
  ; 2. TAILBITE grabs the ASM file, splits it, rewrites some parts
  Protected CodeContent.s, CodeCleaned.s, CodeCleaned2.s, CodeField.s, TrCodeField.s, FunctionList.s
  Protected Inc.l, IncA.l, NotCapture.l
  If ReadFile(0, #Work_Dir  +"purebasic.asm")
    CodeContent = Space(Lof(0)+1)
    ReadData(0,@CodeContent, Lof(0))
    CloseFile(0)
  EndIf
  ;{ Extracts information for the future creation of the DESC File
  For Inc = 0 To CountString(CodeContent, #System_EOL)
    CodeField = StringField(CodeContent, Inc, #System_EOL)
    TrCodeField = Trim(CodeField)
    If Left(TrCodeField, 1) =";"
      TrCodeField = Right(TrCodeField, Len(TrCodeField) - 2)
      If TrCodeField <> ""
        If Left(LCase(TrCodeField), 12) = "proceduredll" Or Left(LCase(TrCodeField), 13) = "procedurecdll"
          AddElement(LL_DLLFunctions())
          TrCodeField = ReplaceString(TrCodeField, "proceduredll", "")
          TrCodeField = ReplaceString(TrCodeField, "ProcedureDLL", "")
          TrCodeField = ReplaceString(TrCodeField, "procedurecdll", "")
          TrCodeField = ReplaceString(TrCodeField, "ProcedureCDLL", "")
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
              Case "b"  : LL_DLLFunctions()\FuncRetType = ", Byte"
              Case "c"  : LL_DLLFunctions()\FuncRetType = ", Character"
              Case "d"  : LL_DLLFunctions()\FuncRetType = ", Double"
              Case "f"  : LL_DLLFunctions()\FuncRetType = ", Float"
              Case "q"  : LL_DLLFunctions()\FuncRetType = ", Quad"
              Case "s"  : LL_DLLFunctions()\FuncRetType = ", String"
              Case "w"  : LL_DLLFunctions()\FuncRetType = ", Word"
              Default  : LL_DLLFunctions()\FuncRetType = ", Long"
            EndSelect
          Else
            LL_DLLFunctions()\FuncRetType = ", Long"
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
              LL_LibUsed() = LibName
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
                  CodeCleaned + ";TB-Function-List" + #System_EOL
                Default
                  ;Do nothing
              EndSelect
            EndIf
          ;}
          Case "macro"     
          ;{
            NotCapture = 0            
            CodeCleaned + CodeField + #System_EOL
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
          Default
          ;{
            If NotCapture = 0
              CodeCleaned + CodeField + #System_EOL
            EndIf
          ;}
        EndSelect
    EndIf
  Next
  ;}
  ;{ Add some ASM code
  CodeCleaned.s = RemoveString(CodeCleaned, #CR$)
  ForEach LL_Functions()
    FunctionList.s + "public " + LL_Functions() + #System_EOL
  Next
  ForEach LL_DLLFunctions()
    FunctionList.s + "public " + "PB_"+LL_DLLFunctions()\FuncName + #System_EOL
  Next
  CodeCleaned2 = ReplaceString(CodeCleaned, ";TB-Function-List", FunctionList)
  ;}
  ;{ Rewrite the new ASM Code
  If CreateFile(0, gProject\FileAsm)
    WriteString(0,CodeCleaned2)
    CloseFile(0)
  EndIf
  ;}
EndProcedure
ProcedureDLL Moebius_Compile_Step3()
  ; 3. FASM compiles the ASM files created by tailbite To OBJ
  ;     Compiling ASM sources
  RunProgram(#Path_FASM+#System_ExtExec, Chr(34)+gProject\FileAsm+Chr(34)+" "+Chr(34)+gProject\FileO+Chr(34), "", #PB_Program_Wait) 
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
        DeleteElement(LL_LibUsed(), 1)
        ; libused ()="./linux/glibc"
      EndIf
      If FindString(StringTmp,"~"+libused()+"~",1)
        DeleteElement(libused(),1)
      Else
        StringTmp=StringTmp+"~"+libused()+"~"
      EndIf
    Next
    WriteStringN(hDescFile,Str(CountList(LL_LibUsed())))
    StringTmp=""
    ForEach LL_LibUsed()
      WriteStringN(hDescFile,LL_LibUsed())
    Next
    WriteStringN(hDescFile,gProject\LibName)
    ForEach LL_DLLFunctions()
      WriteStringN(hDescFile,LL_DLLFunctions()\FuncName+LL_DLLFunctions()\Params+"("+LL_DLLFunctions()\ParamsRetType+") - "+LL_DLLFunctions()\FuncDesc)
      WriteStringN(hDescFile,LL_DLLFunctions()\FuncRetTypel+" | StdCall")        
    Next
    CloseFile(hDescFile)
  EndIf
  ; Creating archive
EndProcedure
ProcedureDLL Moebius_Compile_Step5()
  ; 5. LibraryMaker creates userlibrary from the LIB file
EndProcedure
; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 216
; FirstLine = 9
; Folding = IAQBAHG5
; EnableXP
; UseMainFile = Moebius_Main.pb