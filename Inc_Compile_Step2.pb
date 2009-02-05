ProcedureDLL Moebius_Compile_Step2_ExtractMainInformations(CodeContent.s)
  Protected Inc.l, IncA.l, lPos.l
  Protected CodeField.s, TrCodeField.s, sTmpString.s, CodeCleaned2.s, sFuncName.s, sFuncNameCleared.s, sReturnValField.s, sParamItem.s
  Protected sIsParameterDefautValueStart.s, sIsParameterDefautValueEnd.s, sCallingConvention.s
  Protected bFunctionEverAdded.b, bFunctionEverAdded_NbParams.b, bHasNumberInLastPlace.b
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
    If Left(TrCodeField, 1) =";"
      TrCodeField = Right(TrCodeField, Len(TrCodeField) - 2)
      If TrCodeField <> ""
        CodeCleaned2 = Trim(StringField(TrCodeField, 1, " "))
        CodeCleaned2 = Trim(StringField(CodeCleaned2, 1, "."))
        CodeCleaned2 = Trim(CodeCleaned2)
        If (LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedurecdll" Or LCase(CodeCleaned2) = "procedurec" Or LCase(CodeCleaned2) = "procedure") And sTmpString  = "macro"
          If LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedure"
            sCallingConvention = "StdCall"
          ElseIf LCase(CodeCleaned2) = "procedurecdll" Or LCase(CodeCleaned2) = "procedurec"
            sCallingConvention = "CDecl"
          EndIf
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
          ;}
          sFuncName = TrCodeField
          ;{ we cleared the name of the function
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
          sFuncNameCleared = Trim(sFuncNameCleared)
          ;}
          If Left(sFuncNameCleared, 1) = "."
            sFuncNameCleared = Trim(Right(sFuncNameCleared, Len(sFuncNameCleared) - FindString(sFuncNameCleared, " ", 1)))
          EndIf
          Repeat
            bHasNumberInLastPlace = #False
            For IncA = 0 To 9
              If Right(sFuncNameCleared, 1) = Str(IncA)
                sFuncNameCleared = Left(sFuncNameCleared, Len(sFuncNameCleared) - 1)
                bHasNumberInLastPlace = #True
              EndIf
            Next
          Until bHasNumberInLastPlace = #False
          Log_Add("LL_DLLFunctions()\sFuncNameCleared > "+sFuncNameCleared, 4)
          ;{ we looked if the function already exists
          bFunctionEverAdded = -1
          ForEach LL_DLLFunctions()
            If LL_DLLFunctions()\FuncName = sFuncNameCleared
              bFunctionEverAdded = ListIndex(LL_DLLFunctions())
              bFunctionEverAdded_NbParams = LL_DLLFunctions()\ParamsNumber
              Break
            EndIf
          Next
          ;}
          ;{ the function has been ever added but return flags are differents
          If bFunctionEverAdded > -1
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
          ;}
          LastElement(LL_DLLFunctions())
          If AddElement(LL_DLLFunctions())
            ;{ Name of the function
            LL_DLLFunctions()\FuncName = sFuncName
            If LCase(CodeCleaned2) = "proceduredll" Or LCase(CodeCleaned2) = "procedurecdll"
              LL_DLLFunctions()\IsDLLFunction = #True
            Else
              LL_DLLFunctions()\IsDLLFunction = #False
            EndIf
            Log_Add("LL_DLLFunctions()\FuncName Full> "+LL_DLLFunctions()\FuncName, 4)
            ;}
            ;{ Calling Convention
            LL_DLLFunctions()\CallingConvention = sCallingConvention
            Log_Add("LL_DLLFunctions()\CallingConvention > "+sCallingConvention, 4)
            ;}
            ;{ Description
            If FindString(sFuncName, ";",1) > 0
              LL_DLLFunctions()\FuncDesc = Right(sFuncName, Len(sFuncName) - FindString(sFuncName, ";",1))
              sFuncName = Trim(Left(sFuncName, Len(sFuncName) - Len(LL_DLLFunctions()\FuncDesc)-1))
            EndIf
            Log_Add("LL_DLLFunctions()\FuncDesc > "+LL_DLLFunctions()\FuncDesc, 4)
            ;}
            
            LL_DLLFunctions()\Params = Right(sFuncName, Len(sFuncName)-(FindString(sFuncName, "(", 1)))
            If Right(LL_DLLFunctions()\Params, 1) = ")"
              LL_DLLFunctions()\Params = Left(LL_DLLFunctions()\Params, Len(LL_DLLFunctions()\Params)-1)
            Else
              For IncA = Len(LL_DLLFunctions()\Params) To 0 Step -1
                If Mid(LL_DLLFunctions()\Params, IncA, 1) = ")"
                  Break
                EndIf
              Next
              LL_DLLFunctions()\Params = Left(LL_DLLFunctions()\Params, IncA-1)
            EndIf
            Log_Add("LL_DLLFunctions()\Params > "+LL_DLLFunctions()\Params, 4)
            
            If Left(Trim(LL_DLLFunctions()\FuncName), 1) = "."
              sReturnValField = Mid(Trim(LL_DLLFunctions()\FuncName), 2, 1)
            Else
              sReturnValField = ""
            EndIf
            LL_DLLFunctions()\FuncName = Trim(Left(sFuncName, FindString(sFuncName, "(", 1)-1))
            LL_DLLFunctions()\FuncName = Trim(Right(LL_DLLFunctions()\FuncName, Len(LL_DLLFunctions()\FuncName) - FindString(LL_DLLFunctions()\FuncName, " ", 1)))
            Log_Add("LL_DLLFunctions()\FuncName Light> "+LL_DLLFunctions()\FuncName, 4)
            
            ;{ Type of the Return Value
            If sReturnValField <> ""
              Select sReturnValField
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
                  Default  : LL_DLLFunctions()\FuncRetType = "Long"
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
            ;}
            ;{ Number of Params
            If Trim(LL_DLLFunctions()\Params) <> ""
              LL_DLLFunctions()\ParamsNumber = CountString(LL_DLLFunctions()\Params, ",")+1
            Else
              LL_DLLFunctions()\ParamsNumber = 0
            EndIf
            ;}
            ;{ Type of Parameters
            If Trim(LL_DLLFunctions()\Params) <> ""
              For IncA = 1 To LL_DLLFunctions()\ParamsNumber
                sParamItem = Trim(StringField(LL_DLLFunctions()\Params, IncA, ","))
                ; If an another functions exists with the same name AND if it has less parameters than the previous
                If IncA > bFunctionEverAdded_NbParams And bFunctionEverAdded > -1
                  sIsParameterDefautValueStart = "["
                  sIsParameterDefautValueEnd = "]"
                Else
                  sIsParameterDefautValueStart = ""
                  sIsParameterDefautValueEnd = ""
                EndIf
                
                ; If the parameters is an array or an linkedlist
                If LCase(StringField(sParamItem, 1, " ")) = "list" Or LCase(StringField(sParamItem, 1, " ")) = "array"
                  If LCase(StringField(sParamItem, 1, " ")) = "list" 
                    LL_DLLFunctions()\ParamsRetType +  ", "+sIsParameterDefautValueStart+"LinkedList"+sIsParameterDefautValueEnd
                  ElseIf LCase(StringField(sParamItem, 1, " ")) = "array"
                    LL_DLLFunctions()\ParamsRetType +  ", "+sIsParameterDefautValueStart+"Array"+sIsParameterDefautValueEnd
                  EndIf
                  If LL_DLLFunctions()\ParamsClean =""
                    LL_DLLFunctions()\ParamsClean = sIsParameterDefautValueStart+Trim(Right(sParamItem, Len(sParamItem) - Len(StringField(sParamItem, 1, " "))))+sIsParameterDefautValueEnd
                  Else
                    LL_DLLFunctions()\ParamsClean + ", "+sIsParameterDefautValueStart+Trim(Right(sParamItem, Len(sParamItem) - Len(StringField(sParamItem, 1, " "))))+sIsParameterDefautValueEnd
                  EndIf
                Else
                  ; Get the last character of the param
                  lPos = FindString(sParamItem, ".", 1)
                  If lPos > 0
                    sReturnValField = Mid(sParamItem, lPos+1, Len(sParamItem) - lPos+1)
                  Else
                    If Right(sParamItem, 1) = "$"
                      sReturnValField = "s"
                    Else  
                      sReturnValField = ""
                    EndIf
                  EndIf
                  If sReturnValField <> ""
                    Select sReturnValField
                      Case "b"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Byte"+sIsParameterDefautValueEnd
                      Case "c"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Character"+sIsParameterDefautValueEnd
                      Case "d"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Double"+sIsParameterDefautValueEnd
                      Case "f"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Float"+sIsParameterDefautValueEnd
                      Case "q"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Quad"+sIsParameterDefautValueEnd
                      Case "s"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"String"+sIsParameterDefautValueEnd
                      Case "w"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Word"+sIsParameterDefautValueEnd
                      CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                        Default  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                      CompilerElse ; 430
                        Case "l"  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                        Default  : LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                      CompilerEndIf
                    EndSelect
                  Else
                    LL_DLLFunctions()\ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                  EndIf
                  If LL_DLLFunctions()\ParamsClean =""
                    LL_DLLFunctions()\ParamsClean = sIsParameterDefautValueStart+sParamItem+sIsParameterDefautValueEnd
                  Else
                    LL_DLLFunctions()\ParamsClean + ", "+sIsParameterDefautValueStart+sParamItem+sIsParameterDefautValueEnd
                  EndIf
                EndIf
              Next
              sIsParameterDefautValueStart = LL_DLLFunctions()\ParamsClean
              sIsParameterDefautValueEnd = LL_DLLFunctions()\ParamsRetType
            Else
              LL_DLLFunctions()\ParamsRetType = ""
              LL_DLLFunctions()\ParamsClean = ""
            EndIf
            Log_Add("LL_DLLFunctions()\ParamsRetType > "+LL_DLLFunctions()\ParamsRetType, 4)
            Log_Add("LL_DLLFunctions()\ParamsClean > "+LL_DLLFunctions()\ParamsClean, 4)
            ;}
            If bFunctionEverAdded > -1
              LL_DLLFunctions()\InDescFile = #False
              ; For functions with default parameter, define values for DESC file
              SelectElement(LL_DLLFunctions(),bFunctionEverAdded)
              LL_DLLFunctions()\ParamsClean = sIsParameterDefautValueStart
              LL_DLLFunctions()\ParamsRetType = sIsParameterDefautValueEnd
              LastElement(LL_DLLFunctions())
              bFunctionEverAdded = #True
            Else
              LL_DLLFunctions()\InDescFile = #True
              bFunctionEverAdded = #False
            EndIf
            Log_Add("LL_DLLFunctions()\InDescFile > "+Str(LL_DLLFunctions()\InDescFile), 4)
            Log_Add("", 4)
          EndIf
        EndIf
      EndIf
    EndIf
  Next
  ;}
EndProcedure
ProcedureDLL Moebius_Compile_Step2_ModifyASM(CodeContent.s)
  Protected Inc.l
  Protected CodeField.s, TrCodeField.s, CodeCleaned.s, sNameOfFunction.s, sTmpString.s
  Protected bFound.b, bNotCapture.b, bInFunction.b, bInBSSSection.b, bInSharedCode.b, bInSystemLib.b, bInImportLib.b, bInPBLib.b

  ;{ Permits in functions of some code to extract, remove some code & informations
  For Inc = 0 To CountString(CodeContent, #System_EOL)
    CodeField = StringField(CodeContent, Inc+1, #System_EOL)
    TrCodeField = ReplaceString(CodeField, Chr(13), "")
    TrCodeField = ReplaceString(TrCodeField, Chr(10), "")
    TrCodeField = Trim(TrCodeField)
    If Left(TrCodeField, 4) = "_PB_" And TrCodeField <> "_PB_EOP:" And TrCodeField <> "_PB_EOP_NoValue:" And TrCodeField <> "_PB_BSSSection:"    
    ; In cases of functions not defined in ProcedureDLL
      If AddElement(LL_Functions())
        LL_Functions() = Right(CodeField, Len(CodeField)-4)
        LL_Functions() = Left(TrCodeField, Len(TrCodeField)-1)
      EndIf
    Else
      Select Trim(StringField(TrCodeField, 1, " "))
        Case "extrn" ;{ Extracts extrn functions
          Protected Function.s = StringField(TrCodeField, 2, " ")
          Protected Pos.l = FindString(Function, "_", 2)
          Protected LibName.s
          If Pos < Len(Function)-2
            Function = Right(Function, Len(Function)-Pos)
          EndIf
          ; Searchs in libs where the function is contained
          LibName = Trim(PB_ListFunctions(Function))
          If LibName <> ""
            bFound = #False
            ; in lib ?
            ForEach LL_LibUsed()
              If LL_LibUsed() = LCase(LibName)
                bFound = #True
                Break
              EndIf
            Next
            ; in DLL ?
            If bFound = #False
              ForEach LL_DLLUsed()
                If LCase(LL_DLLUsed()) = LCase(LibName)
                  bFound = #True
                  Break
                EndIf
              Next
            EndIf
            ; else we add it
            If bFound = #False
              If AddElement(LL_LibUsed())
                LL_LibUsed() = LCase(LibName)
              EndIf
            EndIf
          EndIf
        ;}
        Case "public" ;{
          If bNotCapture = 0
            Select StringField(TrCodeField, 2, " ")
              Case "main"
              Default
                ;Do nothing
            EndSelect
          EndIf
        ;}
        Case "macro" ;{
          bNotCapture = 0
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
        Case "main:" ;{
          bNotCapture = 1
        ;}
        Case "JMP" ;{
          If bNotCapture = 1
            bNotCapture = 0
          Else
            If bInFunction = #True
              LL_DLLFunctions()\Code + TrCodeField + #System_EOL
            EndIf
          EndIf
        ;}
        Case "}" ;{
          If bInFunction = #True
            bInFunction = #False
          EndIf
        ;}
        Case "RET" ;{
          If bNotCapture = 0 And bInFunction = #True
            LL_DLLFunctions()\Code + TrCodeField
            If LL_DLLFunctions()\IsDLLFunction = #True 
              If LL_DLLFunctions()\FuncRetType = "String" 
                If #PB_Compiler_OS = #PB_OS_Windows
                  LL_DLLFunctions()\Code + " + 4"
                EndIf
              EndIf
            EndIf
            LL_DLLFunctions()\Code + #System_EOL
          EndIf
        ;}
        Case ";" ;{
          If StringField(TrCodeField, 2, " ") = ":System"
            bInSystemLib = #True
            bInImportLib = #False
            bInPBLib     = #False
          ElseIf StringField(TrCodeField, 2, " ") = ":Import"
            bInSystemLib = #False
            bInImportLib = #True
            bInPBLib     = #False
          ElseIf TrCodeField = "; The header must remain intact for Re-Assembly"
            bInSystemLib = #False
            bInImportLib = #False
            bInPBLib     = #True
          Else
            If Left(StringField(TrCodeField, 2, " "), 1) = ":"
              bInSystemLib = #False
              bInImportLib = #False
              bInPBLib     = #False
            Else
              If bInSystemLib = #True And StringField(TrCodeField, 2, " ") <> ""
                AddElement(LL_DLLUsed())
                LL_DLLUsed() = StringField(TrCodeField, 2, " ")
                Log_Add("LL_DLLUsed() > "+LL_DLLUsed(), 4)
              ElseIf bInImportLib = #True And StringField(TrCodeField, 2, " ") <> ""
                AddElement(LL_ImportUsed())
                LL_ImportUsed() = Trim(RemoveString(TrCodeField, ";"))
                Log_Add("LL_ImportUsed() > "+LL_ImportUsed(), 4)
              ElseIf bInPBLib = #True And StringField(TrCodeField, 2, " ") <> ""
                AddElement(LL_LibUsed())
                LL_LibUsed() = Trim(LCase(RemoveString(TrCodeField, ";")))
                Log_Add("LL_LibUsed() > "+LL_LibUsed(), 4)
              EndIf
            EndIf
          EndIf
        ;}
        Default ;{
          If bNotCapture = 0
            ; In the function, getting the code
            If bInFunction = #True 
              LL_DLLFunctions()\Code + TrCodeField + #System_EOL
            EndIf
          EndIf
        ;}
      EndSelect
    EndIf
  Next
  ;}
EndProcedure
ProcedureDLL.s Moebius_Compile_Step2_WriteASMForArrays(lFile.l)
  Protected lIncA.l, lIncB.l, lOffset.l
  Protected sItemParam.s, sReturnDataSection.s
  Protected bNbArrays.b
  If FindString(LCase(LL_DLLFunctions()\ParamsRetType), "array", 0)  > 0
    For lIncA = 1 To CountString(LL_DLLFunctions()\ParamsRetType, ",")
      ; Param's Type
      sItemParam = StringField(LL_DLLFunctions()\ParamsRetType, lIncA +1, ",")
      sItemParam = LCase(sItemParam)
      sItemParam = Trim(sItemParam)
      If sItemParam = "array"
        ; Offset
        If lIncA = 1 
          lOffset  = 4
        Else
          lOffset  = 0
          For lIncB = 1 To lIncA - 1
            sItemParam = StringField(LL_DLLFunctions()\ParamsRetType, lIncA +1, ",")
            sItemParam = LCase(sItemParam)
            sItemParam = Trim(sItemParam)
            Select sItemParam
              Case "array"  : lOffset +4
              Case "linkedlist"  : lOffset +4
              Default:lOffset+SizeOf(sItemParam)
            EndSelect
          Next
          lOffset +4
        EndIf
        WriteStringN(lFile, "MOV  edx, dword [esp+"+Str(lOffset)+"]") 
        WriteStringN(lFile, "MOV  dword [_Ptr_Array_"+Str(bNbArrays)+"], edx ")
        WriteStringN(lFile, "MOV  dword [esp+"+Str(lOffset)+"], _Ptr_Array_"+Str(bNbArrays))
        If sReturnDataSection = ""
          sReturnDataSection = "Macro align value { rb (value-1) - ($-_"+LL_DLLFunctions()\FuncName+" + value-1) mod value }"+ #System_EOL
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows : sReturnDataSection + "section '.Arrays' readable writeable"+ #System_EOL
            CompilerCase #PB_OS_Linux : sReturnDataSection + "section '.Arrays' writeable"+ #System_EOL
          CompilerEndSelect
          sReturnDataSection + "_"+LL_DLLFunctions()\FuncName+":"+ #System_EOL
          sReturnDataSection + "align 4"+ #System_EOL
        EndIf
        sReturnDataSection + "_Ptr_Array_"+Str(bNbArrays)+":"+ #System_EOL
        sReturnDataSection + "rd 1"+ #System_EOL
        bNbArrays +1
      EndIf
    Next
  Else
    sReturnDataSection = ""
  EndIf 
  ProcedureReturn sReturnDataSection
EndProcedure
ProcedureDLL Moebius_Compile_Step2_AddExtrn(Part.s)
  Protected TrCodeField.s
  Protected bFound.b
  If CreateRegularExpression(0, "^e[a-z]{1}x")
    If CreateRegularExpression(1, "^e[a-z]{1}p")
      If CreateRegularExpression(2, "^e[a-z]{1}i")
        If MatchRegularExpression(0, Part) = #False
          If MatchRegularExpression(1, Part) = #False
            If MatchRegularExpression(2, Part) = #False
              If IsNumeric(Part) = #False
                If FindString(Part, "+", 1) > 0
                  TrCodeField = StringField(Part, 1, "+")
                Else
                  TrCodeField = Part
                EndIf
                If TrCodeField <> ""
                  If IsNumeric(TrCodeField) = #False
                    bFound = #False
                    ForEach LL_ASM_extrn()
                      If LL_ASM_extrn() = TrCodeField
                        bFound = #True
                        Break
                      EndIf
                    Next
                    If bFound = #False
                      If AddElement(LL_ASM_extrn())
                        LL_ASM_extrn() = TrCodeField
                      EndIf
                      ProcedureReturn #True
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  EndIf
  ProcedureReturn #False
EndProcedure

ProcedureDLL Moebius_Compile_Step2_SharedFunction(CodeContent.s)
  Protected sCodeShared.s, sCodeField.s, sTmp.s
  Protected lFile.l, lInc.l
  Protected bInSharedCode.b = #False - 1
  ;{ Adding function in LL_DLLFunctions()
    If AddElement(LL_DLLFunctions())
      LL_DLLFunctions()\FuncName = ReplaceString(gProject\LibName, " ", "_")+"_Shared" 
      LL_DLLFunctions()\FuncRetType = "SharedCode"
      LL_DLLFunctions()\FuncDesc = ""
      LL_DLLFunctions()\Params = ""
      LL_DLLFunctions()\ParamsRetType = ""
      LL_DLLFunctions()\Code =Moebius_Compile_Step2_sCodeShared
      LL_DLLFunctions()\IsDLLFunction = #False
      LL_DLLFunctions()\InDescFile = #False
    EndIf
  ;}
  ;{ Extracting SharedCode from MainFile
  For lInc = 0 To CountString(CodeContent, #System_EOL)
    sCodeField = StringField(CodeContent, lInc+1, #System_EOL)
    sCodeField = ReplaceString(sCodeField, Chr(13), "")
    sCodeField = ReplaceString(sCodeField, Chr(10), "")
    sCodeField = Trim(sCodeField)
    If StringField(sCodeField, 1, " ") = "section"
      ; we verify if we are at the start of code
      If bInSharedCode = - 1
        CompilerSelect #PB_Compiler_OS
          CompilerCase #PB_OS_Windows : sTmp = StringField(CodeContent, lInc+4, #System_EOL)
          CompilerCase #PB_OS_Linux   : sTmp = StringField(CodeContent, lInc+3, #System_EOL)
        CompilerEndSelect
        sTmp = ReplaceString(sTmp, Chr(13), "")
        sTmp = ReplaceString(sTmp, Chr(10), "")
        sTmp = Trim(sTmp)
        ; "public main" for Linux
        ; "PureBasicStart:" for Windows
        If sTmp = "public main" Or sTmp = "PureBasicStart:"
          bInSharedCode = #False
        EndIf
      ElseIf bInSharedCode = #False ; we start the shared code
        bInSharedCode = #True
      EndIf
    EndIf
    If bInSharedCode = #True  
      sCodeShared + sCodeField + #System_EOL
    EndIf
  Next
  ;}
  ;{ Deleting unuseful code 
  CodeContent = sCodeShared
  sCodeShared = ""
  For lInc = 0 To CountString(CodeContent, #System_EOL)
    sCodeField = StringField(CodeContent, lInc+1, #System_EOL)
    sCodeField = ReplaceString(sCodeField, Chr(13), "")
    sCodeField = ReplaceString(sCodeField, Chr(10), "")
    sCodeField = Trim(sCodeField)
    Select StringField(sCodeField, 1, " ") 
      Case "pb_public": lInc+1
      Default
        ; we are not adding these lines
        If Left(StringField(sCodeField, 1, " "), 2) = "PB"
        ElseIf StringField(sCodeField, 1, ":") = "_PB_ExecutableType"
        Else
          sCodeShared + sCodeField + #System_EOL
        EndIf
    EndSelect
  Next
  ;}
  ;{ Search extrn
    ClearList(LL_ASM_extrn())
    For lInc = 0 To CountString(sCodeShared, #System_EOL)
      sCodeField = StringField(sCodeShared, lInc+1, #System_EOL)
      sCodeField = ReplaceString(sCodeField, Chr(13), "")
      sCodeField = ReplaceString(sCodeField, Chr(10), "")
      sCodeField = Trim(sCodeField)
      If FindString(sCodeField, ":", 0) > 0 
        If FindString(sCodeField, "SYS", 0) = 0 
          If StringField(sCodeField, 1, " ") <> "file"
            If StringField(sCodeField, 1, " ") <> "public"
              Moebius_Compile_Step2_AddExtrn(StringField(sCodeField, 1, ":"))
            EndIf
          EndIf
        EndIf
      Else
        If Left(StringField(sCodeField, 1, " "), 2) = "v_" And FindString(sCodeField, "rd",0) > 0
          Moebius_Compile_Step2_AddExtrn(StringField(sCodeField, 1, " "))
        EndIf
      EndIf
    Next
  ;}
  ; Begin to write the SharedFunction in file
  lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
  If lFile
    WriteStringN(lFile, "format "+#System_LibFormat)
    WriteStringN(lFile, "")
    ;{ Declare public
      ForEach LL_ASM_extrn()
        WriteStringN(lFile, "public "+LL_ASM_extrn())
      Next
    ;}
    WriteStringN(lFile, "")
    WriteStringN(lFile, sCodeShared)
    CloseFile(lFile)
  EndIf
EndProcedure

ProcedureDLL Moebius_Compile_Step2()
  ; 2. TAILBITE grabs the ASM file, splits it, rewrites some parts
  Protected CodeContent.s, CodeField.s, TrCodeField.s, sTmpString.s, CodeCleaned.s, sDataSectionForArray.s
  Protected IncA.l, IncB.l, lPos.l, lPosLast.l, lFile.l
  Protected bFound.b, bLastIsLabel.b, bIsDLLFunction.b
  If ReadFile(0, gConf_ProjectDir+"purebasic.asm")
    CodeContent = Space(Lof(0)+1)
    ReadData(0,@CodeContent, Lof(0))
    CloseFile(0)
  EndIf
  Log_Add("Extracts information for the future creation of the DESC File", 2)
  Moebius_Compile_Step2_ExtractMainInformations(CodeContent)
  Log_Add("Remove some ASM code", 2)
  Moebius_Compile_Step2_ModifyASM(CodeContent)
  Log_Add("Create ASM Files", 2)
  ;{ Create ASM Files
    ; private functions
    For IncA = 0 To ListSize(LL_DLLFunctions())-1
      SelectElement(LL_DLLFunctions(), IncA)
      CodeField     = LL_DLLFunctions()\FuncName         ; Function Name
      TrCodeField   = LL_DLLFunctions()\Win_ASMNameFunc  ; ASM Function Name
      bIsDLLFunction= LL_DLLFunctions()\IsDLLFunction
      ForEach LL_DLLFunctions()
        If LL_DLLFunctions()\FuncName <> CodeField 
          If bIsDLLFunction = #False
            sTmpString = ReplaceString(gProject\LibName, " ", "_")+"_"+CodeField
          Else
            sTmpString ="PB_"+CodeField
          EndIf
          If CreateRegularExpression(0, TrCodeField+"(?=\s|])")
            LL_DLLFunctions()\Code  = ReplaceRegularExpression(0, LL_DLLFunctions()\Code, sTmpString)
          Else
            Log_Add("ERREUR Regex > "+RegularExpressionError(),4)
          EndIf
        EndIf
      Next  
    Next  
    
    ForEach LL_DLLFunctions()
      ClearList(LL_ASM_extrn())
      lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
      If UCase(Right(LL_DLLFunctions()\FuncName,5)) = "_INIT"
        LL_DLLFunctions()\FuncRetType = "InitFunction"
      EndIf
      If UCase(Right(LL_DLLFunctions()\FuncName,4)) = "_END"
        LL_DLLFunctions()\FuncRetType = "EndFunction"
      EndIf
      If lFile
        WriteStringN(lFile, "format "+#System_LibFormat)
        WriteStringN(lFile, "")
        ;{ declarations
        If LL_DLLFunctions()\IsDLLFunction = #True
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows :
            ;{
              If UCase(Right(LL_DLLFunctions()\FuncName,6)) = "_DEBUG"
                WriteStringN(lFile, "public _PB_"+LL_DLLFunctions()\FuncName)
              Else
                WriteStringN(lFile, "public PB_"+LL_DLLFunctions()\FuncName)
              EndIf
            ;}
            CompilerCase #PB_OS_Linux
            ;{
              WriteStringN(lFile, "public PB_"+LL_DLLFunctions()\FuncName)
            ;}
          CompilerEndSelect
        Else
          WriteStringN(lFile, "public "+ReplaceString(gProject\LibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName)
        EndIf;}
        WriteStringN(lFile, "")
        ;{ extrn
        For IncA = 0 To CountString(LL_DLLFunctions()\Code, #System_EOL)
          CodeField = Trim(StringField(LL_DLLFunctions()\Code, IncA, #System_EOL))
          CodeField = ReplaceString(CodeField, Chr(13), "")
          CodeField = ReplaceString(CodeField, Chr(10), "")
          Select LCase(StringField(CodeField, 1, " "))
            Case "call", "push";{
              TrCodeField = StringField(CodeField, CountString(CodeField, " ")+1, " ")
              If FindString(TrCodeField, "[", 0) > 0 And FindString(TrCodeField, "]", 0) > 0
                sTmpString = Trim(Mid(TrCodeField, FindString(TrCodeField, "[", 0)+1, FindString(TrCodeField, "]", 0) - FindString(TrCodeField, "[", 0) -1))
                If sTmpString <> ""
                  Moebius_Compile_Step2_AddExtrn(sTmpString)
                EndIf
              Else
                Moebius_Compile_Step2_AddExtrn(TrCodeField)
              EndIf
            ;}
            Default;{
              ; If the cleaned line contained a call which didn't contain any registry
              If Left(CodeField, 1) <> ";"
                If FindString(CodeField, "[", 0) > 0 And FindString(CodeField, "]", 0) > 0
                  TrCodeField = Trim(Mid(CodeField, FindString(CodeField, "[", 0)+1, FindString(CodeField, "]", 0) - FindString(CodeField, "[", 0) -1))
                  If TrCodeField <> ""
                    Moebius_Compile_Step2_AddExtrn(TrCodeField)
                  EndIf
                Else

                  ; If the cleaned line contained a string call
                  TrCodeField = Trim(CodeField)
                  ; It's not a comment or a label
                  If Left(TrCodeField, 1) <> ";" And Right(TrCodeField, 1) <> ":"
                    ; Looking for strings
                    lPos = FindString(TrCodeField, "_S", 1)
                    If lPos > 0
                      TrCodeField = Right(TrCodeField, Len(TrCodeField) - lPos +1)
                      lPos = FindString(TrCodeField, " ", 1)
                      If lPos > 0
                        TrCodeField = Left(TrCodeField, lPos-1)
                      EndIf 
                      Moebius_Compile_Step2_AddExtrn(TrCodeField)
                    EndIf
                    ; Looking for "what ?"
                    lPos = FindString(TrCodeField, "l_", 1)
                    If lPos > 0
                      TrCodeField = Right(TrCodeField, Len(TrCodeField) - lPos +1)
                      lPos = FindString(TrCodeField, " ", 1)
                      If lPos > 0
                        TrCodeField = Left(TrCodeField, lPos-1)
                      EndIf 
                      Moebius_Compile_Step2_AddExtrn(TrCodeField)
                    EndIf
                  EndIf
                EndIf
              EndIf
            ;}
          EndSelect 
        Next
        If ListSize(LL_ASM_extrn()) > 0
          ForEach LL_ASM_extrn()
            WriteStringN(lFile, "extrn "+LL_ASM_extrn())
          Next
        EndIf
        If LL_DLLFunctions()\FuncRetType = "InitFunction"
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows : WriteStringN(lFile, "extrn _SYS_InitString@0")
            CompilerCase #PB_OS_Linux : WriteStringN(lFile, "extrn SYS_InitString")
          CompilerEndSelect
        EndIf
        ;}
        WriteStringN(lFile, "")      
        ;{ code
        If LL_DLLFunctions()\FuncRetType = "InitFunction"
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows :  LL_DLLFunctions()\Code = "CALL _SYS_InitString@0" + #System_EOL + LL_DLLFunctions()\Code
            CompilerCase #PB_OS_Linux : LL_DLLFunctions()\Code = "CALL SYS_InitString" + #System_EOL + LL_DLLFunctions()\Code
          CompilerEndSelect
        EndIf
        If LL_DLLFunctions()\IsDLLFunction = #True
          CodeField = LL_DLLFunctions()\Code
          CodeField = Trim(StringField(CodeField, 1, #System_EOL))+#System_EOL
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows :
            ;{
              If UCase(Right(LL_DLLFunctions()\FuncName,6)) = "_DEBUG"
                CodeField + "_PB_"+LL_DLLFunctions()\FuncName +":"+#System_EOL
              Else
                CodeField + "PB_"+LL_DLLFunctions()\FuncName +":"+#System_EOL
              EndIf
            ;}
            CompilerCase #PB_OS_Linux
            ;{
              CodeField + "PB_"+LL_DLLFunctions()\FuncName +":"+#System_EOL
            ;}
          CompilerEndSelect
          CodeField + Right(LL_DLLFunctions()\Code, Len(LL_DLLFunctions()\Code) - Len(StringField(LL_DLLFunctions()\Code, 1, #System_EOL)))
          TrCodeField = CodeField
        Else
          CodeField = ReplaceString(LL_DLLFunctions()\Code, LL_DLLFunctions()\FuncName, ReplaceString(gProject\LibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName)
          If Right(Trim(StringField(CodeField, 1, #System_EOL)), 1) = ":" ; declaration de la function
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Windows ;{
                TrCodeField = Trim(StringField(CodeField, 1, #System_EOL))+#System_EOL
                TrCodeField + ReplaceString(gProject\LibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
              ;}
              CompilerCase #PB_OS_Linux;{
                TrCodeField = ReplaceString(gProject\LibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
              ;}
            CompilerEndSelect
            TrCodeField + Right(CodeField, Len(CodeField) - Len(StringField(CodeField, 1, #System_EOL)))
          EndIf
        EndIf;}
        ; We initialize the var for testing if the line contains a label
        bLastIsLabel = #True
        For IncA = 0 To CountString(TrCodeField, #System_EOL)
          sTmpString = StringField(TrCodeField, IncA+1, #System_EOL)
          sTmpString = ReplaceString(sTmpString, Chr(13), "")
          sTmpString = ReplaceString(sTmpString, Chr(10), "")
          sTmpString = Trim(sTmpString)
          If bLastIsLabel <> #False
            If Right(sTmpString, 1) = ":" ; so it's a label
              bLastIsLabel = #True
            Else
              If bLastIsLabel = #True
                Log_Add("Moebius_Compile_Step2_WriteASMForArrays()", 2)
                sDataSectionForArray = Moebius_Compile_Step2_WriteASMForArrays(lFile)
                bLastIsLabel = #False
              EndIf
            EndIf
          EndIf
          WriteStringN(lFile, sTmpString)
        Next
        WriteStringN(lFile, sDataSectionForArray)
        CloseFile(lFile)
      EndIf
    Next
  ;}
  ;{ Init Function
    ; We search if an Init Function exists
    bFound = #False
    ForEach LL_DLLFunctions()
      If UCase(Right(LL_DLLFunctions()\FuncName,5)) = "_INIT"
        bFound = #True
        Break
      EndIf
    Next
    ; The Init Function doesn't exist
    If bFound = #False
      If AddElement(LL_DLLFunctions())
        LL_DLLFunctions()\FuncName = ReplaceString(gProject\LibName, " ", "_")+"_Init" 
        LL_DLLFunctions()\FuncRetType = "InitFunction"
        LL_DLLFunctions()\CallingConvention = "StdCall"
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
        LL_DLLFunctions()\Code + "public PB_"+ReplaceString(gProject\LibName, " ", "_")+"_Init"  + #System_EOL
        LL_DLLFunctions()\Code + "" + #System_EOL
        LL_DLLFunctions()\Code + "PB_"+ReplaceString(gProject\LibName, " ", "_")+"_Init:" + #System_EOL
        CompilerSelect #PB_Compiler_OS 
          CompilerCase #PB_OS_Windows : LL_DLLFunctions()\Code + "CALL _SYS_InitString@0" + #System_EOL
          CompilerCase #PB_OS_Linux : LL_DLLFunctions()\Code + "CALL SYS_InitString" + #System_EOL
        CompilerEndSelect
        LL_DLLFunctions()\Code + "RET " + #System_EOL
        LL_DLLFunctions()\IsDLLFunction = #True
        LL_DLLFunctions()\InDescFile = #True
      EndIf
      lFile = CreateFile(#PB_Any, gConf_ProjectDir+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
      If lFile
        WriteStringN(lFile, LL_DLLFunctions()\Code)
        CloseFile(lFile)
      EndIf
    EndIf
  ;}
  ;{ Shared Code
    Moebius_Compile_Step2_SharedFunction(CodeContent.s)
  ;}
  Log_Add("Rewrite the new ASM Code", 2)
EndProcedure
