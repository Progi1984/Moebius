
ProcedureDLL Moebius_Compile_Step2()
  ; 2. TAILBITE grabs the ASM file, splits it, rewrites some parts
  Protected CodeContent.s, CodeCleaned.s, CodeCleaned2.s, CodeField.s, TrCodeField.s, FunctionList.s
  Protected Inc.l, IncA.l, NotCapture.l, lFound.l
  Protected bInFunction.b, bInSystemLib.b, bFunctionEverAdded.b, bInSharedCode.b, bInBSSSection.b
  Protected sNameOfFunction.s, sCallExtrn.s, sFuncName.s, sReturnValField.s, sFuncNameCleared.s, sCodeShared.s, sTmpString.s
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
    sTmpString  = StringField(CodeContent, Inc+2, #System_EOL)
    sTmpString  = StringField(sTmpString, 1, " ")
    sTmpString  = ReplaceString(sTmpString, Chr(13), "")
    sTmpString  = ReplaceString(sTmpString, Chr(10), "")
    sTmpString  = Trim(sTmpString)
    If Left(TrCodeField, 1) =";" And sTmpString  = "macro"
      TrCodeField = Right(TrCodeField, Len(TrCodeField) - 2)
      If TrCodeField <> ""
        CodeCleaned2 = Trim(StringField(TrCodeField, 1, " "))
        CodeCleaned2 = Trim(StringField(CodeCleaned2, 1, "."))
        CodeCleaned2 = Trim(CodeCleaned2)
        If LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedurecdll" Or LCase(CodeCleaned2) = "procedurec" Or LCase(CodeCleaned2) = "procedure"
          ;{ Clears the line for extracting informations
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
            sFuncName = StringField(TrCodeField, 2, " ")
            sReturnValField = StringField(TrCodeField, 1, " ")
          Else
            sFuncName = StringField(TrCodeField, 1, " ")
            sReturnValField = sFuncName
          EndIf;}
          ; we cleared the name of the function
          If FindString(sFuncName, "(", 0) > 0
            sFuncNameCleared = Mid(sFuncName, 1, FindString(sFuncName, "(", 0)-1)
          EndIf
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_DEBUG", "", #PB_String_NoCase)
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_MMX", "", #PB_String_NoCase)
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_SSE2", "", #PB_String_NoCase)
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_SSE", "", #PB_String_NoCase)
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_3DNOW", "", #PB_String_NoCase)
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_THREAD", "", #PB_String_NoCase)
          sFuncNameCleared = ReplaceString(sFuncNameCleared, "_UNICODE", "", #PB_String_NoCase)
          ; we looked if the function already exists
          bFunctionEverAdded = #False
          ForEach LL_DLLFunctions()
            If LL_DLLFunctions()\FuncName = sFuncNameCleared
              bFunctionEverAdded = #True
              Break
            EndIf
          Next
          ; the function has been ever added but return flags are differents
          If bFunctionEverAdded = #True
            If FindString(UCase(sFuncName), "_DEBUG", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "debuggercheck", 0) = 0
              LL_DLLFunctions()\FlagsReturn + " | DebuggerCheck"
            EndIf
            If FindString(UCase(sFuncName), "_MMX", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "mmx", 0) = 0
              LL_DLLFunctions()\FlagsReturn + " | MMX"
            EndIf
            If FindString(UCase(sFuncName), "_SSE2", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "sse2", 0) = 0
              LL_DLLFunctions()\FlagsReturn + " | SSE2"
            Else
              If FindString(UCase(sFuncName), "_SSE", 0) > 0 And (FindString(LCase(LL_DLLFunctions()\FlagsReturn), "sse", 0) = 0 Or (FindString(LCase(LL_DLLFunctions()\FlagsReturn), "sse", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "sse2", 0) <> 0))
                LL_DLLFunctions()\FlagsReturn + " | SSE"
              EndIf
            EndIf
            If FindString(UCase(sFuncName), "_3DNOW", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "3dnow", 0) = 0
              LL_DLLFunctions()\FlagsReturn + " | 3DNOW"
            EndIf
            If FindString(UCase(sFuncName), "_THREAD", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "thread", 0) = 0
              LL_DLLFunctions()\FlagsReturn + " | Thread"
            EndIf
            If FindString(UCase(sFuncName), "_UNICODE", 0) > 0 And FindString(LCase(LL_DLLFunctions()\FlagsReturn), "unicode", 0) = 0
              LL_DLLFunctions()\FlagsReturn + " | Unicode"
            EndIf
          EndIf
          LastElement(LL_DLLFunctions())
          If AddElement(LL_DLLFunctions())
            LL_DLLFunctions()\FuncName = sFuncName
            If LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedurecdll"
              LL_DLLFunctions()\IsDLLFunction = #True
            Else
              LL_DLLFunctions()\IsDLLFunction = #False
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
            LL_DLLFunctions()\InDescFile = 1-bFunctionEverAdded
            Log_Add("LL_DLLFunctions()\InDescFile > "+Str(LL_DLLFunctions()\InDescFile), 4)
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
            lFound = #False
            ForEach LL_LibUsed()
              If LL_LibUsed() = LibName
                lFound = #True
                Break
              EndIf
            Next
            If lFound = #False
              If AddElement(LL_LibUsed())
                LL_LibUsed() = LCase(LibName)
              EndIf
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
          ElseIf StringField(TrCodeField, 2, " ") = "'.data'"
            If sCodeShared = ""
              sCodeShared = TrCodeField + #System_EOL
              sCodeShared + "" + #System_EOL
            EndIf
          ElseIf StringField(TrCodeField, 2, " ") = "'.bss'" ; variables globales non initialisee
            sCodeShared = TrCodeField + #System_EOL
            sCodeShared + "" + #System_EOL
            bInBSSSection = #True  
          EndIf
        ;}
        Case "}"
        ;{
          If bInFunction = #True
            bInFunction = #False
          EndIf
          CodeCleaned + TrCodeField + #System_EOL
        ;}
        Case "_SYS_StaticStringStart:"
        ;{
          bInSharedCode = #True
          sCodeShared + TrCodeField + #System_EOL
        ;}
        Case "_SYS_StaticStringEnd:"
        ;{
          bInSharedCode = #False
          sCodeShared + TrCodeField + #System_EOL
        ;}
        Case "I_BSSEnd:"
        ;{
          bInBSSSection = #False
          CodeCleaned + TrCodeField + #System_EOL
        ;}
        Case "pb_public"
        ;{
          If bInSharedCode = #True
            ; Don't write PB_NullString in sSharedCode
          EndIf
        ;}
        Case "RET"
        ;{
          If NotCapture = 0 And bInFunction = #True
            If LL_DLLFunctions()\IsDLLFunction = #True And LL_DLLFunctions()\FuncRetType = "String" And #PB_Compiler_OS = #PB_OS_Windows
              LL_DLLFunctions()\Code + TrCodeField + " + 4" + #System_EOL
            Else
              LL_DLLFunctions()\Code + TrCodeField + #System_EOL
            EndIf
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
            If bInSharedCode = #True
              sCodeShared + TrCodeField + #System_EOL
            EndIf
            If bInBSSSection >= #True
              If TrCodeField = "_PB_BSSSection:"
                sCodeShared + TrCodeField + #System_EOL
              ElseIf TrCodeField = "I_BSSStart:"
                bInBSSSection + 1
              Else
                If bInBSSSection > #True
                  If Left(TrCodeField, 2) = "PB" And StringField(TrCodeField, 1, " ") <> "PB_DataPointer"
                    ; Don't Write in SharedCode
                  Else
                    sCodeShared + TrCodeField + #System_EOL
                  EndIf
                EndIf
              EndIf
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
      CodeField   = LL_DLLFunctions()\FuncName                ; Function Name
      TrCodeField = LL_DLLFunctions()\Win_ASMNameFunc  ; ASM Function Name
      ForEach LL_DLLFunctions()
        If LL_DLLFunctions()\FuncName <> CodeField
          LL_DLLFunctions()\Code = ReplaceString(LL_DLLFunctions()\Code, TrCodeField, ReplaceString(gProject\Name, " ", "_")+"_"+CodeField)
        EndIf
      Next  
    Next  
    
    ForEach LL_DLLFunctions()
      ClearList(LL_ASM_extrn())
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
          Select LCase(StringField(CodeField, 1, " "))
            Case "call";{
              lFound = #False
              ForEach LL_ASM_extrn()
                If LL_ASM_extrn() = StringField(CodeField, CountString(CodeField, " ")+1, " ")
                  lFound = #True
                  Break
                EndIf
              Next
              If lFound = #False
                If AddElement(LL_ASM_extrn())
                  LL_ASM_extrn() = StringField(CodeField, CountString(CodeField, " ")+1, " ")
                EndIf
              EndIf
            ;}
;             Case "mov";{
;               TrCodeField = Trim(StringField(CodeField, 2, ","))
;               If TrCodeField <> "0"
;                 If Left(TrCodeField, 1) = "[" Or Left(TrCodeField, 2) = "_S"
;                   TrCodeField = ReplaceString(TrCodeField, "[", "")
;                   TrCodeField = ReplaceString(TrCodeField, "]", "")
;                   lFound = #False
;                   ForEach LL_ASM_extrn()
;                     If LL_ASM_extrn() = TrCodeField
;                       lFound = #True
;                       Break
;                     EndIf
;                   Next
;                   If lFound = #False
;                     If AddElement(LL_ASM_extrn())
;                       LL_ASM_extrn() = TrCodeField
;                     EndIf
;                   EndIf
;                 EndIf
;               EndIf
;             ;}
            Default;{
              If FindString(CodeField, "[", 0) > 0 And FindString(CodeField, "]", 0) > 0
                TrCodeField = Mid(CodeField, FindString(CodeField, "[", 0)+1, FindString(CodeField, "]", 0) - FindString(CodeField, "[", 0) -1)
                If TrCodeField <> ""
                  If CreateRegularExpression(0, "e[a-z]x")
                    If CreateRegularExpression(1, "e[a-z]p")
                      If MatchRegularExpression(0, TrCodeField) = #False
                        If MatchRegularExpression(1, TrCodeField) = #False
                          lFound = #False
                          ForEach LL_ASM_extrn()
                            If LL_ASM_extrn() = TrCodeField
                              lFound = #True
                              Break
                            EndIf
                          Next
                          If lFound = #False
                            If AddElement(LL_ASM_extrn())
                              LL_ASM_extrn() = TrCodeField
                            EndIf
                          EndIf
                        EndIf
                      EndIf
                    EndIf
                  EndIf
                EndIf
              Else
                TrCodeField = Trim(StringField(CodeField, 2, ","))
                If TrCodeField <> "0" And Left(TrCodeField, 2) = "_S"
                  TrCodeField = ReplaceString(TrCodeField, "[", "")
                  TrCodeField = ReplaceString(TrCodeField, "]", "")
                  lFound = #False
                  ForEach LL_ASM_extrn()
                    If LL_ASM_extrn() = TrCodeField
                      lFound = #True
                      Break
                    EndIf
                  Next
                  If lFound = #False
                    If AddElement(LL_ASM_extrn())
                      LL_ASM_extrn() = TrCodeField
                    EndIf
                  EndIf
                EndIf
              EndIf
            ;}
          EndSelect 
        Next
        If CountList(LL_ASM_extrn()) > 0
          ForEach LL_ASM_extrn()
            WriteStringN(lFile, "extrn "+LL_ASM_extrn())
          Next
        EndIf
        ;}
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
      LL_DLLFunctions()\IsDLLFunction = #False
      LL_DLLFunctions()\InDescFile = #True
    EndIf
    lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
    If lFile
      WriteStringN(lFile, LL_DLLFunctions()\Code)
      CloseFile(lFile)
    EndIf
    ; Shared Code
    If AddElement(LL_DLLFunctions())
      LL_DLLFunctions()\FuncName = ReplaceString(gProject\Name, " ", "_")+"_Shared" 
      LL_DLLFunctions()\FuncRetType = "SharedCode"
      LL_DLLFunctions()\FuncDesc = ""
      LL_DLLFunctions()\Params = ""
      LL_DLLFunctions()\ParamsRetType = ""
      LL_DLLFunctions()\Code =sCodeShared
      LL_DLLFunctions()\IsDLLFunction = #False
      LL_DLLFunctions()\InDescFile = #False
    EndIf
    lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
    If lFile
      WriteStringN(lFile, "format "+#System_LibFormat + #System_EOL)
      WriteStringN(lFile, "" + #System_EOL)
      For IncA = 0 To CountString(sCodeShared, #System_EOL)
        CodeField = Trim(StringField(LL_DLLFunctions()\Code, IncA, #System_EOL))
        CodeField = ReplaceString(CodeField, Chr(13), "")
        CodeField = ReplaceString(CodeField, Chr(10), "")
        CodeField = Trim(CodeField)
        If FindString(CodeField, ":", 0) > 0 And FindString(CodeField, "SYS", 0) = 0
          WriteStringN(lFile, "public "+StringField(CodeField, 1, ":"))
        EndIf
      Next
      
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
