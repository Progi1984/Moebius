;@desc Load the content of purebasic.asm in memory
ProcedureDLL Moebius_Userlib_Step2_LoadASMFileInMemory()
  Protected plFileID.l = ReadFile(#PB_Any, gProject\sDirProject+"purebasic.asm")
  If plFileID
    gFileMemContentLen = Lof(plFileID)
    If gFileMemContentLen
      gFileMemContent = AllocateMemory(gFileMemContentLen)
      If gFileMemContent
        If ReadData(plFileID, gFileMemContent, gFileMemContentLen) = gFileMemContentLen
          CloseFile(plFileID)
        EndIf
      EndIf
    EndIf
  EndIf 
EndProcedure
;@desc Extracts information for the future creation of the DESC File
ProcedureDLL Moebius_Userlib_Step2_ExtractMainInformations()
  Protected Inc.l, IncA.l, lPos.l, lNbLines.l, lMaxInc.l
  Protected sLineCurrentTrimmed.s, sWordLineCurrent.s, sLineNext.s, sWordLineNext.s, sFuncName.s, sFuncNameCleared.s, sReturnValField.s, sParamItem.s
  Protected sIsParameterDefautValueStart.s, sIsParameterDefautValueEnd.s, sCallingConvention.s
  Protected bFunctionEverAdded.b, bFunctionEverAdded_NbParams.b, bHasNumberInLastPlace.b, bLineNext.b
  sLineCurrentTrimmed = PeekLine(gFileMemContent, gFileMemContentLen)
  Repeat
    If Left(sLineCurrentTrimmed, 1) =";"
      sLineCurrentTrimmed = Right(sLineCurrentTrimmed, Len(sLineCurrentTrimmed) - 2)
      If sLineCurrentTrimmed <> ""
        ; get the first word of the line
        sWordLineCurrent = Trim(StringField(sLineCurrentTrimmed, 1, " "))
        sWordLineCurrent = Trim(StringField(sWordLineCurrent, 1, "."))
        
        sLineNext  = PeekLine()
        bLineNext = #True
        sWordLineNext = Trim(StringField(sLineNext, 1, " "))
        sWordLineNext = Trim(StringField(sWordLineNext, 1, "."))
        ; if the line begins by "procedure*"
        If (LCase(sWordLineCurrent) = "proceduredll" Or LCase(sWordLineCurrent) = "procedurecdll" Or LCase(sWordLineCurrent) = "procedurec" Or LCase(sWordLineCurrent) = "procedure") And sWordLineNext  = "macro"
          ;{ define the calling convention from the procedure type
            If LCase(sWordLineCurrent) = "proceduredll" Or LCase(sWordLineCurrent) = "procedure"
              sCallingConvention = "StdCall"
            ElseIf LCase(sWordLineCurrent) = "procedurecdll" Or LCase(sWordLineCurrent) = "procedurec"
              sCallingConvention = "CDecl"
            EndIf
          ;}
          ;{ clears the line for extracting informations
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, "proceduredll", "", #PB_String_NoCase)
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, "procedurecdll", "", #PB_String_NoCase)
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, "procedure", "", #PB_String_NoCase)
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, "procedurec", "", #PB_String_NoCase)
            sLineCurrentTrimmed = Trim(sLineCurrentTrimmed)
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, "  ", " ")
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, " .", ".")
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, " ,", ",")
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, ", ", ",")
            sLineCurrentTrimmed = ReplaceString(sLineCurrentTrimmed, " (", "(")
          ;}
          ;{ clears the name of the function
            sFuncName = sLineCurrentTrimmed
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
            If Left(sFuncNameCleared, 1) = "."
              sFuncNameCleared = Trim(Right(sFuncNameCleared, Len(sFuncNameCleared) - FindString(sFuncNameCleared, " ", 1)))
            EndIf
            ; tests in the name of function if there is a number at the end and clears the name of the function
            Repeat
              bHasNumberInLastPlace = #False
              For IncA = 0 To 9
                If Right(sFuncNameCleared, 1) = Str(IncA)
                  sFuncNameCleared = Left(sFuncNameCleared, Len(sFuncNameCleared) - 1)
                  bHasNumberInLastPlace = #True
                EndIf
              Next
            Until bHasNumberInLastPlace = #False
            Output_Add("LL_DLLFunctions()\sFuncNameCleared > "+sFuncNameCleared, #Output_Log, 4)
          ;}
          ;{ looks if the function already exists
            bFunctionEverAdded = -1
            ForEach LL_DLLFunctions()
              With LL_DLLFunctions()
                If \FuncName = sFuncNameCleared
                  bFunctionEverAdded = ListIndex(LL_DLLFunctions())
                  bFunctionEverAdded_NbParams = \ParamsNumber
                  Break
                EndIf
              EndWith
            Next
          ;}
          ;{ the function has been ever added but return flags are differents
            If bFunctionEverAdded > -1
              With LL_DLLFunctions()
                If FindString(UCase(sFuncName), "_DEBUG", 0) > 0 And FindString(LCase(\FlagsReturn), "debuggercheck", 0) = 0
                  \FlagsReturn + " | DebuggerCheck"
                EndIf
                If FindString(UCase(sFuncName), "_MMX", 0) > 0 And FindString(LCase(\FlagsReturn), "mmx", 0) = 0
                  \FlagsReturn + " | MMX"
                EndIf
                If FindString(UCase(sFuncName), "_SSE2", 0) > 0 And FindString(LCase(\FlagsReturn), "sse2", 0) = 0
                  \FlagsReturn + " | SSE2"
                Else
                  If FindString(UCase(sFuncName), "_SSE", 0) > 0 And (FindString(LCase(\FlagsReturn), "sse", 0) = 0 Or (FindString(LCase(\FlagsReturn), "sse", 0) > 0 And FindString(LCase(\FlagsReturn), "sse2", 0) <> 0))
                    \FlagsReturn + " | SSE"
                  EndIf
                EndIf
                If FindString(UCase(sFuncName), "_3DNOW", 0) > 0 And FindString(LCase(\FlagsReturn), "3dnow", 0) = 0
                  \FlagsReturn + " | 3DNOW"
                EndIf
                If FindString(UCase(sFuncName), "_THREAD", 0) > 0 And FindString(LCase(\FlagsReturn), "thread", 0) = 0
                  \FlagsReturn + " | Thread"
                EndIf
                If FindString(UCase(sFuncName), "_UNICODE", 0) > 0 And FindString(LCase(\FlagsReturn), "unicode", 0) = 0
                  \FlagsReturn + " | Unicode"
                EndIf
              EndWith
            EndIf
          ;}
          LastElement(LL_DLLFunctions())
          If AddElement(LL_DLLFunctions())
            With LL_DLLFunctions()
              ;{ Name of the function
                \FuncName = sFuncName
                If LCase(sWordLineCurrent) = "proceduredll" Or LCase(sWordLineCurrent) = "procedurecdll"
                  \IsDLLFunction = #True
                Else
                  \IsDLLFunction = #False
                EndIf
                Output_Add("LL_DLLFunctions()\FuncName Full> "+\FuncName, #Output_Log, 4)
              ;}
              ;{ Calling Convention
                \CallingConvention = sCallingConvention
                Output_Add("LL_DLLFunctions()\CallingConvention > "+sCallingConvention, #Output_Log, 4)
              ;}
              ;{ Description
                If FindString(sFuncName, ";",1) > 0
                  \FuncDesc = Right(sFuncName, Len(sFuncName) - FindString(sFuncName, ";",1))
                  sFuncName = Trim(Left(sFuncName, Len(sFuncName) - Len(\FuncDesc)-1))
                EndIf
                Output_Add("LL_DLLFunctions()\FuncDesc > "+\FuncDesc, #Output_Log, 4)
              ;}
              ;{ Parameters
                \Params = Right(sFuncName, Len(sFuncName)-(FindString(sFuncName, "(", 1)))
                If Right(\Params, 1) = ")"
                  \Params = Left(\Params, Len(\Params)-1)
                Else
                  lMaxInc = Len(\Params)
                  For IncA = lMaxInc To 0 Step -1
                    If Mid(\Params, IncA, 1) = ")"
                      Break
                    EndIf
                  Next
                  \Params = Left(\Params, IncA-1)
                EndIf
                Output_Add("LL_DLLFunctions()\Params > "+\Params, #Output_Log, 4)
              ;}
              ;{ Return the value type of the function
                If Left(Trim(\FuncName), 1) = "."
                  sReturnValField = Mid(Trim(\FuncName), 2, 1)
                Else
                  sReturnValField = ""
                EndIf
              ;}
              ;{ Clears the function name
                \FuncName = Trim(Left(sFuncName, FindString(sFuncName, "(", 1)-1))
                \FuncName = Trim(Right(\FuncName, Len(\FuncName) - FindString(\FuncName, " ", 1)))
                Output_Add("LL_DLLFunctions()\FuncName Light> "+\FuncName, #Output_Log, 4)
              ;}
              ;{ Type of the Return Value
                If sReturnValField <> ""
                  Select sReturnValField
                    Case "b"  : \FuncRetType = "Byte"
                    Case "c"  : \FuncRetType = "Character"
                    Case "d"  : \FuncRetType = "Double"
                    Case "f"  : \FuncRetType = "Float"
                    Case "q"  : \FuncRetType = "Quad"
                    Case "s"  : \FuncRetType = "String"
                    Case "w"  : \FuncRetType = "Word"
                    CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                      Default  : \FuncRetType = "Long"
                    CompilerElse ; 430
                      Case "l"  : \FuncRetType = "Long"
                      Default  : \FuncRetType = "Long"
                    CompilerEndIf
                  EndSelect
                Else
                  CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                    \FuncRetType = "Long"
                  CompilerElse ; 430
                    \FuncRetType = "Long"
                  CompilerEndIf
                EndIf
                Output_Add("LL_DLLFunctions()\FuncRetType > "+\FuncRetType, #Output_Log, 4)
              ;}
              ;{ Number of Params
                If Trim(\Params) <> ""
                  \ParamsNumber = CountString(\Params, ",")+1
                Else
                  \ParamsNumber = 0
                EndIf
              ;}
              ;{ Type of Parameters
                If Trim(\Params) <> ""
                  lMaxInc = \ParamsNumber
                  For IncA = 1 To lMaxInc
                    sParamItem = Trim(StringField(\Params, IncA, ","))
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
                        \ParamsRetType +  ", "+sIsParameterDefautValueStart+"LinkedList"+sIsParameterDefautValueEnd
                      ElseIf LCase(StringField(sParamItem, 1, " ")) = "array"
                        \ParamsRetType +  ", "+sIsParameterDefautValueStart+"Array"+sIsParameterDefautValueEnd
                      EndIf
                      If \ParamsClean =""
                        \ParamsClean = sIsParameterDefautValueStart+Trim(Right(sParamItem, Len(sParamItem) - Len(StringField(sParamItem, 1, " "))))+sIsParameterDefautValueEnd
                      Else
                        \ParamsClean + ", "+sIsParameterDefautValueStart+Trim(Right(sParamItem, Len(sParamItem) - Len(StringField(sParamItem, 1, " "))))+sIsParameterDefautValueEnd
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
                          Case "b"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Byte"+sIsParameterDefautValueEnd
                          Case "c"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Character"+sIsParameterDefautValueEnd
                          Case "d"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Double"+sIsParameterDefautValueEnd
                          Case "f"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Float"+sIsParameterDefautValueEnd
                          Case "q"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Quad"+sIsParameterDefautValueEnd
                          Case "s"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"String"+sIsParameterDefautValueEnd
                          Case "w"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Word"+sIsParameterDefautValueEnd
                          CompilerIf #PB_Compiler_Version < 430 ; 420 and inferior
                            Default  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                          CompilerElse ; 430
                            Case "l"  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                            Default  : \ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                          CompilerEndIf
                        EndSelect
                      Else
                        \ParamsRetType + ", "+sIsParameterDefautValueStart+"Long"+sIsParameterDefautValueEnd
                      EndIf
                      If \ParamsClean =""
                        \ParamsClean = sIsParameterDefautValueStart+sParamItem+sIsParameterDefautValueEnd
                      Else
                        \ParamsClean + ", "+sIsParameterDefautValueStart+sParamItem+sIsParameterDefautValueEnd
                      EndIf
                    EndIf
                  Next
                  sIsParameterDefautValueStart = \ParamsClean
                  sIsParameterDefautValueEnd = \ParamsRetType
                Else
                  \ParamsRetType = ""
                  \ParamsClean = ""
                EndIf
                Output_Add("LL_DLLFunctions()\ParamsRetType > "+\ParamsRetType, #Output_Log, 4)
                Output_Add("LL_DLLFunctions()\ParamsClean > "+\ParamsClean, #Output_Log, 4)
              ;}
              ;{ If the function has been ever added, we change some parameters of the function
                If bFunctionEverAdded > -1
                  \InDescFile = #False
                  ; For functions with default parameter, define values for DESC file
                  SelectElement(LL_DLLFunctions(), bFunctionEverAdded)
                  \ParamsClean = sIsParameterDefautValueStart
                  \ParamsRetType = sIsParameterDefautValueEnd
                  LastElement(LL_DLLFunctions())
                  bFunctionEverAdded = #True
                Else
                  \InDescFile = #True
                  bFunctionEverAdded = #False
                EndIf
              ;}
              ;{ End or Init Function ?
                If LCase(Right(\FuncName,5)) = "_init"
                  \FuncRetType = "InitFunction"
                EndIf
                If LCase(Right(\FuncName,4)) = "_end"
                  \FuncRetType = "EndFunction"
                EndIf
              ;}
              Output_Add("LL_DLLFunctions()\InDescFile > "+Str(\InDescFile), #Output_Log, 4)
              Output_Add("", #Output_Log, 4)
            EndWith
          EndIf
        EndIf
      EndIf
    EndIf
    If bLineNext = #True
      bLineNext = #False
      sLineCurrentTrimmed = sLineNext
    Else
      sLineCurrentTrimmed = PeekLine()
    EndIf
  Until sLineCurrentTrimmed = Chr(1)
EndProcedure
;@desc Permits in functions of some code to extract, remove some code & informations
ProcedureDLL Moebius_Userlib_Step2_ModifyASM()
  Protected Inc.l, lNbLines.l
  Protected sLineCurrentTrimmed.s, sNameOfFunction.s, sLinePrevious.s, sLineNext.s
  Protected bFound.b, bNotCapture.b, bInFunction.b, bInBSSSection.b, bInSharedCode.b, bInSystemLib.b, bInImportLib.b, bInPBLib.b, bLineNext.b
  Protected bInHeader.b = #True
  sLineCurrentTrimmed = Trim(PeekLine(gFileMemContent, gFileMemContentLen))
  sLinePrevious = ""
  Repeat
    If PeekB(@sLineCurrentTrimmed) <> ';' Or bInHeader = #True
      If sLineCurrentTrimmed <> ""
        If Left(sLineCurrentTrimmed, 4) = "_PB_" And sLineCurrentTrimmed <> "_PB_EOP:" And sLineCurrentTrimmed <> "_PB_EOP_NoValue:" And sLineCurrentTrimmed <> "_PB_BSSSection:"    
          ; In the case of functions not defined in ProcedureDLL
          If AddElement(LL_Functions())
            LL_Functions() = Right(sLineCurrentTrimmed, Len(sLineCurrentTrimmed)-4)
            LL_Functions() = Left(sLineCurrentTrimmed, Len(sLineCurrentTrimmed)-1)
          EndIf
        Else
          Select Trim(StringField(sLineCurrentTrimmed, 1, " "))
            Case "extrn" ;{ Extracts extrn functions
              Protected sFunction.s = StringField(sLineCurrentTrimmed, 2, " ")
              Protected sLibName.s
              Protected lPos.l = FindString(sFunction, "_", 2)
              If lPos < Len(sFunction)-2
                sFunction = Right(sFunction, Len(sFunction) - lPos)
              EndIf
              ; Searchs in libs where the function is contained
              sLibName = Trim(PB_GetLibFromFunctionName(sFunction))
              If sLibName <> ""
                bFound = #False
                ; in DLL ?
                ForEach LL_DLLUsed()
                  If LCase(LL_DLLUsed()) = LCase(sLibName)
                    bFound = #True
                    Break
                  EndIf
                Next
                ; in Lib ?
                If bFound = #False
                  ;M_AddInLLWithDichotomicSearch(LL_LibUsed(), LL_LibUsed(), sLibName)
                  If Not FindMapElement(MAP_LibUsed(), sLibName)
                    AddMapElement(MAP_LibUsed(), sLibName)
                  EndIf
                EndIf
              EndIf
            ;}
            Case "public" ;{
              If bNotCapture = #False
                ; not add in funccode
              EndIf
            ;}
            Case "%macro"
            Case "macro" ;{ Extracts the name of function
              bNotCapture = #False
              sNameOfFunction = sLinePrevious
              sNameOfFunction = StringField(sNameOfFunction, 3, " ")
              sNameOfFunction = StringField(sNameOfFunction, 1, "(")
              sNameOfFunction = StringField(sNameOfFunction, 1, ".")
              ForEach LL_DLLFunctions()
                With LL_DLLFunctions()
                  If \FuncName = sNameOfFunction
                    bInFunction = #True
                    ; Extracts the ASM Name of function
                    sLineNext = Trim(PeekLine())
                    bLineNext = #True
                    \Win_ASMNameFunc = sLineNext
                    \Win_ASMNameFunc = ReplaceString(\Win_ASMNameFunc, ":", "")
                    Break
                  EndIf
                EndWith
              Next
            ;}
            Case "main:" ;{
              bNotCapture = #True
            ;}
            Case "JMP" ;{
              If bNotCapture = #True
                bNotCapture = #False
              Else
                If bInFunction = #True
                  ; add code in func code
                  AddElement(LL_Lines())
                  With LL_Lines()
                    \Function = LL_DLLFunctions()\FuncName
                    \Line = sLineCurrentTrimmed
                  EndWith
                EndIf
              EndIf
            ;}
            Case "%endmacro"
            Case "}" ;{ finish the code function
              If bInFunction = #True
                bInFunction = #False
              EndIf
            ;}
            Case "RET" ;{
              If bNotCapture = #False And bInFunction = #True
                ; we add the line to the funccode
                AddElement(LL_Lines())
                With LL_Lines()
                  \Function = LL_DLLFunctions()\FuncName
                  \Line = sLineCurrentTrimmed
                  If LL_DLLFunctions()\IsDLLFunction = #True 
                    If LL_DLLFunctions()\FuncRetType = "String" 
                      ; if it's a string return function, we add +4 to the RET value
                      If #PB_Compiler_OS = #PB_OS_Windows
                        \Line + " + 4"
                      EndIf
                    EndIf
                  EndIf
                EndWith
              EndIf
            ;}
            Case ";" ;{
              If bInHeader = #True
                If StringField(sLineCurrentTrimmed, 2, " ") = ":System" ; in system declarations
                  bInSystemLib = #True
                  bInImportLib = #False
                  bInPBLib     = #False
                ElseIf StringField(sLineCurrentTrimmed, 2, " ") = ":Import"; in import declarations
                  bInSystemLib = #False
                  bInImportLib = #True
                  bInPBLib     = #False
                ElseIf sLineCurrentTrimmed = "; The header must remain intact for Re-Assembly" ; in pb asm code
                  bInSystemLib = #False
                  bInImportLib = #False
                  bInPBLib     = #True
                Else
                  If Left(StringField(sLineCurrentTrimmed, 2, " "), 1) = ":"
                    bInSystemLib = #False
                    bInImportLib = #False
                    bInPBLib     = #False
                  Else
                    ; add the lib, import or dll
                    If StringField(sLineCurrentTrimmed, 2, " ") <> ""
                      If bInSystemLib = #True 
                        AddElement(LL_DLLUsed())
                        LL_DLLUsed() = StringField(sLineCurrentTrimmed, 2, " ")
                        Output_Add("LL_DLLUsed() > "+LL_DLLUsed(), #Output_Log, 4)
                      ElseIf bInImportLib = #True
                        AddElement(LL_ImportUsed())
                        LL_ImportUsed() = Trim(RemoveString(sLineCurrentTrimmed, ";"))
                        Output_Add("LL_ImportUsed() > "+LL_ImportUsed(), #Output_Log, 4)
                      ElseIf bInPBLib = #True
                        AddMapElement(MAP_LibUsed(), sLibName)
                        MAP_LibUsed() =  Trim(LCase(RemoveString(sLineCurrentTrimmed, ";")))
                        ;AddElement(LL_LibUsed())
                        ;LL_LibUsed() = Trim(LCase(RemoveString(sLineCurrentTrimmed, ";")))
                        Output_Add("MAP_LibUsed() > "+MAP_LibUsed(), #Output_Log, 4)
                      EndIf
                    EndIf
                  EndIf
                EndIf
              EndIf
            ;}
            Case "format" ;{
              bInHeader = #False
            ;}
            Default ;{ In the function, getting the code
              If bNotCapture = 0 And bInFunction = #True 
                AddElement(LL_Lines())
                With LL_Lines()
                  \Function = LL_DLLFunctions()\FuncName
                  \Line = sLineCurrentTrimmed
                EndWith
              EndIf
            ;}
          EndSelect
        EndIf
        ; if it's a label, add to the LL for searching after
        If Right(sLineCurrentTrimmed, 1) = ":"
          If Left(sLineCurrentTrimmed, 2) = "l_"
            If FindString(sLineCurrentTrimmed, " ", 1) = 0
              AddElement(LL_LabelsInFunctions())
              With LL_LabelsInFunctions()
                \Function = LL_DLLFunctions()\FuncName
                \Label = sLineCurrentTrimmed
              EndWith
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
    sLinePrevious = sLineCurrentTrimmed
    If bLineNext = #True
      bLineNext = #False
      sLineCurrentTrimmed = sLineNext
    Else
      sLineCurrentTrimmed = Trim(PeekLine())
    EndIf
    sLineNext = ""
  Until sLineCurrentTrimmed = Chr(1)
  ; sort the list for a dichotomic search
  SortStructuredList(LL_LabelsInFunctions(), #PB_Sort_Ascending | #PB_Sort_NoCase, OffsetOf(S_LabelsList\label), #PB_Sort_String)
EndProcedure
;@desc Write some asm code for arrays in asm code
ProcedureDLL.s Moebius_Userlib_Step2_WriteASMForArrays()
  Protected lIncA.l, lIncB.l, lOffset.l, lNbParams.l, lReturnString.l
  Protected sParamItem.s,  sParamsList.s, sReturnString.s
  Protected bNbArrays.b
  lReturnString = sbCreate(2048)
  sParamsList = LCase(Right(LL_DLLFunctions()\ParamsRetType, Len(LL_DLLFunctions()\ParamsRetType)-1))
  lNbParams = CountString(sParamsList, ",") +1
  For lIncA = 1 To lNbParams
    ; Param's Type
    sParamItem = Trim(StringField(sParamsList, lIncA, ","))
    If sParamItem = "array"
      ; Offset
      If lIncA = 1 
        lOffset = 4
      Else
        lOffset = 0
        For lIncB = 1 To lIncA - 1
          sParamItem = Trim(StringField(sParamsList, lIncA +1, ","))
          Select sParamItem
            Case "array" : lOffset + 4
            Case "linkedlist" : lOffset + 4
            Default : lOffset + SizeOf(sParamItem)
          EndSelect
        Next
        lOffset + 4
      EndIf
      sbAddLiteral(lReturnString, "MOV  edx, dword [esp+"+Str(lOffset)+"]" + #System_EOL)
      sbAddLiteral(lReturnString, "MOV  dword [_ptr_array_"+Str(bNbArrays)+"], edx " + #System_EOL)
      sbAddLiteral(lReturnString, "MOV  dword [esp+"+Str(lOffset)+"], _ptr_array_"+Str(bNbArrays) + #System_EOL)
      bNbArrays +1
    EndIf
  Next
  sReturnString = sbGetString(lReturnString)
  sbDestroy(lReturnString)
  ProcedureReturn sReturnString
EndProcedure
;@desc Adds some extern and verify some contrainsts
ProcedureDLL Moebius_Userlib_Step2_AddExtrn(sPart.s)
  Protected bFound.b
  Protected qIndStart.q, qIndEnd.q, qIndMid.q
  Protected sValue.s, sPartCleaned.s
  Protected lCompare.l
  ;{ search if it's the same than the ASM Name for Windows
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      If sPart = LL_DLLFunctions()\Win_ASMNameFunc
        ProcedureReturn #False
      EndIf
    CompilerEndIf
  ;}
  ;{ search some asm in part
    If MatchRegularExpression(#Regex_enx, sPart) = #True
      ProcedureReturn #False
    EndIf
    If MatchRegularExpression(#Regex_enp, sPart) = #True
      ProcedureReturn #False
    EndIf
    If MatchRegularExpression(#Regex_eni, sPart) = #True
      ProcedureReturn #False
    EndIf
  ;}
  ;{ search if part is numeric
    If IsNumeric(sPart) = #True
      ProcedureReturn #False
    EndIf
  ;}
  ;{ cleans or extracts the part
    If FindString(sPart, "+", 1) > 0
      sPartCleaned = StringField(sPart, 1, "+")
    Else
      sPartCleaned = sPart
    EndIf
  ;}
  ;{ if part is empty
    If sPartCleaned = ""
      ProcedureReturn #False
    EndIf
  ;}
  ;{ search if part is numeric
    If IsNumeric(sPartCleaned) = #True
      ProcedureReturn #False
    EndIf
  ;}
  ;{ verify if part must not removed
  ForEach LL_ASM_extrn_Removed()
    If sPartCleaned = LL_ASM_extrn_Removed()
      ProcedureReturn #False
    EndIf
  Next
  ;}
  ;{ add to linked lists only if doesn't exist
    ResetList(LL_ASM_extrn())
    bFound = #False
    qIndStart = 0
    qIndEnd = ListSize(LL_ASM_extrn()) -1
    If qIndEnd > 0
      Repeat
        qIndMid = qIndStart + ((qIndEnd-qIndStart) / 2)
        SelectElement(LL_ASM_extrn(), qIndMid)
        sValue = LL_ASM_extrn()
        lCompare = CompareMemoryString(@sValue, @sPartCleaned, #PB_String_NoCase)
        If lCompare = 0
          bFound = #True
        ElseIf lCompare > 0 ; svalue > sPartCleaned
          qIndEnd = qIndMid -1
          If qIndEnd >= 0
            SelectElement(LL_ASM_extrn(), qIndEnd)
            If LL_ASM_extrn() = sPartCleaned
              qIndMid = qIndEnd
              bFound = #True
            EndIf
          EndIf
        ElseIf lCompare < 0 ; svalue < sPartCleaned
          qIndStart = qIndMid +1
          SelectElement(LL_ASM_extrn(), qIndStart)
          If LL_ASM_extrn() = sPartCleaned
            qIndMid = qIndStart
            bFound = #True
          EndIf
        EndIf
      Until (bFound = #True) Or (qIndStart >= qIndEnd)
    ElseIf qIndEnd = 0
      SelectElement(LL_ASM_extrn(), qIndEnd)
      If LL_ASM_extrn() = sPartCleaned
        bFound = #True
      EndIf
    EndIf
    If bFound = #False
      If AddElement(LL_ASM_extrn())
        LL_ASM_extrn() = sPartCleaned
        SortList(LL_ASM_extrn(), #PB_Sort_Ascending | #PB_Sort_NoCase)
      EndIf
    EndIf
  ;}
EndProcedure
;@desc Create Shared Code
ProcedureDLL Moebius_Userlib_Step2_CreateSharedFunction()
  Protected sCodeShared.s, sLineCurrentTrimmed.s, sASMMainFunction.s
  Protected sNextString_1.s, sNextString_2.s, sNextString_3.s
  Protected lFile.l, lInc.l, lNbLines.l, lCodeShared.l, l, lASMShared.l
  Protected bInSharedCode.b = #False - 1
  
  Output_Add("Adding function in LL_DLLFunctions()", #Output_Log, 4)
  ;{ Adding function in LL_DLLFunctions()
    If AddElement(LL_DLLFunctions())
      With LL_DLLFunctions()
        \FuncName       = ReplaceString(gProject\sLibName, " ", "_")+"_Shared" 
        \FuncRetType    = "SharedCode"
        \FuncDesc       = ""
        \Params         = ""
        \ParamsRetType  = ""
        \Code           = ""
        \IsDLLFunction  = #False
        \InDescFile     = #False
      EndWith
    EndIf
  ;}
  Output_Add("Extracting SharedCode from MainFile & Deleting unuseful code", #Output_Log, 4)
  ;{ Extracting SharedCode from MainFile & Deleting unuseful code
    sLineCurrentTrimmed = Trim(PeekLine(gFileMemContent, gFileMemContentLen))
    lCodeShared = sbCreate(2048)
    If lCodeShared
      Repeat
        If sLineCurrentTrimmed <> ""
          Select StringField(sLineCurrentTrimmed, 1, " ")
            Case "pb_public";{
              sLineCurrentTrimmed = Trim(PeekLine())
            ;}
            Case "public" ; don't write labels
            Case "section";{
              ; we verify if we are at the start of code
              If bInSharedCode = - 1
                sNextString_1 = Trim(PeekLine())
                sNextString_2 = Trim(PeekLine())
                sNextString_3 = Trim(PeekLine())
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux   : sASMMainFunction = sNextString_2
                  CompilerCase #PB_OS_MacOS   : sASMMainFunction = sNextString_2
                  CompilerCase #PB_OS_Windows : sASMMainFunction = sNextString_3
                CompilerEndSelect
                ; "public main" for Linux
                ; "global _main" for MacOs
                ; "PureBasicStart:" for Windows
                If sASMMainFunction = "public main" Or sASMMainFunction = "global _main" Or sASMMainFunction = "PureBasicStart:"
                  bInSharedCode = #False
                EndIf
              ElseIf bInSharedCode = #False ; we start the shared code
                bInSharedCode = #True
              EndIf
            ;}
            Default;{
              If bInSharedCode = #True
                If Left(StringField(sLineCurrentTrimmed, 1, " "), 2) = "PB" 
                  ; we remove lines began by "PB"
                ElseIf StringField(sLineCurrentTrimmed, 1, ":") = "_PB_ExecutableType"
                  ; we remove labels with _PB_ExecutableType
                Else
                  sbAddLiteral(lCodeShared, sLineCurrentTrimmed + #System_EOL) 
                EndIf
              EndIf
            ;}
          EndSelect
        EndIf
        If sNextString_1 = ""
          sLineCurrentTrimmed = Trim(PeekLine())
        Else
          If sNextString_3 = ""
            If sNextString_2 = ""
              sLineCurrentTrimmed = sNextString_1
              sNextString_1 = ""
            Else
              sLineCurrentTrimmed = sNextString_1
              sNextString_1 = sNextString_2
              sNextString_2 = ""
            EndIf
          Else
            sLineCurrentTrimmed = sNextString_1
            sNextString_1 = sNextString_2
            sNextString_2 = sNextString_3
            sNextString_3 = ""
          EndIf
        EndIf
      Until sLineCurrentTrimmed =Chr(1)
      sCodeShared = sbGetStringAndDestroy(lCodeShared) 
    EndIf
  ;}
  Output_Add("Search extrn", #Output_Log, 4)
  ;{ Search extrn
    ClearList(LL_ASM_extrn())
    lCodeShared = AllocateMemory((Len(sCodeShared) + 1)*SizeOf(Character))
    If lCodeShared
      PokeS(lCodeShared, sCodeShared, Len(sCodeShared))
      sLineCurrentTrimmed = Trim(PeekLine(lCodeShared, Len(sCodeShared)))
      Repeat
        If FindString(sLineCurrentTrimmed, ":", 0) > 0 
          If FindString(StringField(sLineCurrentTrimmed, 1, ":"), "SYS", 0) = 0 
            If StringField(sLineCurrentTrimmed, 1, " ") <> "file"
              If StringField(sLineCurrentTrimmed, 1, " ") <> "public"
                Moebius_Userlib_Step2_AddExtrn(StringField(sLineCurrentTrimmed, 1, ":"))
              EndIf
            EndIf
          EndIf
        Else
          If Left(StringField(sLineCurrentTrimmed, 1, " "), 2) = "v_" Or Left(StringField(sLineCurrentTrimmed, 1, " "), 2) = "t_"
            If FindString(sLineCurrentTrimmed, "rd",0) > 0
              Moebius_Userlib_Step2_AddExtrn(StringField(sLineCurrentTrimmed, 1, " "))
            EndIf
          EndIf
        EndIf
        sLineCurrentTrimmed = Trim(PeekLine())
      Until sLineCurrentTrimmed = Chr(1)
      FreeMemory(lCodeShared)
    EndIf
  ;}
  Output_Add("Begin to write the SharedFunction in file", #Output_Log, 4)
  ;{ Write the SharedFunction in file
    lFile = CreateFile(#PB_Any, gProject\sDirProject+"ASM"+#System_Separator+LL_DLLFunctions()\FuncName+".asm")
    If lFile
      Output_Add("Write Header", #Output_Log, 6)
      lASMShared = sbCreate(2048)
      If lASMShared
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          sbAddLiteral(lASMShared, "format "+ #System_LibFormat + #System_EOL) 
          sbAddLiteral(lASMShared, #System_EOL) 
        CompilerElse
          sbAddLiteral(lASMShared, "%macro extrn 1"+#System_EOL+"extern %1"+#System_EOL+"%endmacro"+#System_EOL) 
          sbAddLiteral(lASMShared, "%macro Extrn 1"+#System_EOL+"extern %1"+#System_EOL+"%endmacro"+#System_EOL) 
          sbAddLiteral(lASMShared, "%macro Public 1"+#System_EOL+"global %1"+#System_EOL+"%endmacro"+#System_EOL) 
          sbAddLiteral(lASMShared, #System_EOL) 
        CompilerEndIf
        WriteStringN(lFile, sbGetStringAndDestroy(lASMShared))
      EndIf 
      Output_Add("Write Extrn", #Output_Log, 6)
      lASMShared = sbCreate(2048)
      If lASMShared
        ForEach LL_ASM_extrn()
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            sbAddLiteral(lASMShared, "public "+LL_ASM_extrn() + #System_EOL) 
          CompilerElse
            sbAddLiteral(lASMShared, "global "+LL_ASM_extrn() + #System_EOL) 
          CompilerEndIf
        Next
        WriteStringN(lFile, sbGetStringAndDestroy(lASMShared))
      EndIf
      Output_Add("Write SharedCode", #Output_Log, 6)
      WriteStringN(lFile, sCodeShared)
      CloseFile(lFile)
    EndIf  
  ;}
  Output_Add("Finish to write the SharedFunction in file", #Output_Log, 4)
EndProcedure
;@desc Create Init Function Code
ProcedureDLL Moebius_Userlib_Step2_CreateInitFunction()
  Protected lFile.l, lCodeInit.l
  If AddElement(LL_DLLFunctions())
    LL_DLLFunctions()\FuncName = ReplaceString(gProject\sLibName, " ", "_")+"_Init" 
    LL_DLLFunctions()\FuncRetType = "InitFunction"
    LL_DLLFunctions()\CallingConvention = "StdCall"
    LL_DLLFunctions()\FuncDesc = ""
    LL_DLLFunctions()\Params = ""
    LL_DLLFunctions()\ParamsRetType = ""
    LL_DLLFunctions()\IsDLLFunction = #True
    LL_DLLFunctions()\InDescFile = #True

    lCodeInit = sbCreate(2048)
    sbAddLiteral(lCodeInit, "format "+#System_LibFormat + #System_EOL)
    sbAddLiteral(lCodeInit,  "" + #System_EOL)
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Linux : sbAddLiteral(lCodeInit, "extrn SYS_InitString" + #System_EOL)
      CompilerCase #PB_OS_MacOS : sbAddLiteral(lCodeInit, "extern _SYS_InitString" + #System_EOL)
      CompilerCase #PB_OS_Windows : sbAddLiteral(lCodeInit, "extrn _SYS_InitString@0" + #System_EOL)
    CompilerEndSelect
    sbAddLiteral(lCodeInit, "" + #System_EOL)
    CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
      sbAddLiteral(lCodeInit, "public PB_"+ReplaceString(gProject\sLibName, " ", "_")+"_Init"  + #System_EOL )
    CompilerElse
      sbAddLiteral(lCodeInit, "global PB_"+ReplaceString(gProject\sLibName, " ", "_")+"_Init"  + #System_EOL )
    CompilerEndIf
    sbAddLiteral(lCodeInit, "" + #System_EOL)
    sbAddLiteral(lCodeInit, "PB_"+ReplaceString(gProject\sLibName, " ", "_")+"_Init:" + #System_EOL)
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Linux : sbAddLiteral(lCodeInit, "CALL SYS_InitString" + #System_EOL)
      CompilerCase #PB_OS_MacOS : sbAddLiteral(lCodeInit, "CALL _SYS_InitString" + #System_EOL)
      CompilerCase #PB_OS_Windows : sbAddLiteral(lCodeInit, "CALL _SYS_InitString@0" + #System_EOL)
    CompilerEndSelect
    sbAddLiteral(lCodeInit, "RET " + #System_EOL)
    LL_DLLFunctions()\Code = sbGetStringAndDestroy(lCodeInit)
  EndIf
  lFile = CreateFile(#PB_Any, gProject\sDirAsm+LL_DLLFunctions()\FuncName+".asm")
  If lFile
    WriteStringN(lFile, LL_DLLFunctions()\Code)
    CloseFile(lFile)
  EndIf
EndProcedure
;@desc Create ASM Files
;@return #True if the function init has been found
;@return #False if the function init has not been found
ProcedureDLL.b Moebius_Userlib_Step2_CreateASMFiles()
  Protected sFuncNameReplaced.s, sFuncName.s, sLineCurrentTrimmed.s, sLinePart.s, sValue.s, sSearchedLabel.s
  Protected bExistsInitFunction.b, bLastIsLabel.b, bFound.b
  Protected lMaxInc.l, lIncA.l, lPos.l, lFile.l, lListSizeLines.l, lLastPos.l, lASMContent.l, lCompare.l
  Protected cNbParams.c
  Protected qIndStart.q, qIndEnd.q, qIndMid.q
  Output_Add("Private functions", #Output_Log, 4)
  ;{ Private functions
    Output_Add("Create Regex for searching all PBName Functions and replacing ASM Name Functions", #Output_Log, 6)
    ForEach LL_DLLFunctions()
      If CreateRegularExpression(ListIndex(LL_DLLFunctions())+#Regex_Last, LL_DLLFunctions()\Win_ASMNameFunc+"(?=\s|])") = 0
        Output_Add("ERREUR Regex > "+RegularExpressionError(), #Output_Log, 8)
      EndIf
    Next
    Output_Add("Replace pb name functions by asm name functions", #Output_Log, 6)
    ForEach LL_Lines()
      ForEach LL_DLLFunctions()
        If LL_Lines()\Function = LL_DLLFunctions()\FuncName
      		If LL_DLLFunctions()\IsDLLFunction = #False
      		  sFuncNameReplaced = ReplaceString(gProject\sLibName, " ", "_") + "_" + LL_DLLFunctions()\FuncName
      		Else
      		  sFuncNameReplaced ="PB_" + LL_DLLFunctions()\FuncName
      		EndIf
          LL_Lines()\Line = ReplaceRegularExpression(ListIndex(LL_DLLFunctions())+#Regex_Last, LL_Lines()\Line, sFuncNameReplaced)
        Else
          If FindString(LL_Lines()\Line, "_Procedure", 1) > 0
            If Right(LL_Lines()\Line, 1) <> ":"
        		  If LL_DLLFunctions()\IsDLLFunction = #False
          		  sFuncNameReplaced = ReplaceString(gProject\sLibName, " ", "_") + "_" + LL_DLLFunctions()\FuncName
          		Else
          		  sFuncNameReplaced ="PB_" + LL_DLLFunctions()\FuncName
          		EndIf
          		LL_Lines()\Line = StrRreplace(LL_Lines()\Line, LL_DLLFunctions()\Win_ASMNameFunc, sFuncNameReplaced)
            EndIf
          EndIf
        EndIf
      Next
    Next
    Output_Add("Free Regex", #Output_Log, 6)
    For lIncA = 0 To lMaxInc
      If IsRegularExpression(lIncA+#Regex_Last) <> 0
        FreeRegularExpression(lIncA+#Regex_Last)
      EndIf
    Next
  ;}
  Output_Add("Asm code", #Output_Log, 4)
  ;{ Asm code
    ; Replace the priv name functions by the replaced name
    ForEach LL_DLLFunctions()
      Output_Add(LL_DLLFunctions()\FuncName+" > Loading sASMContent", #Output_Log, 6)
      
      ClearList(LL_ASM_extrn())
      ClearList(LL_ASM_extrn_Removed())
      lASMContent = sbCreate(2048)
      
      Output_Add("Format", #Output_Log, 8)
      ;{ Format  
        sbAddLiteral(lASMContent, "format "+#System_LibFormat + #System_EOL)
      ;}
      sbAddLiteral(lASMContent, "" + #System_EOL)

      Output_Add("Main Declaration", #Output_Log, 8)
      ;{ Main Declaration
        If LL_DLLFunctions()\IsDLLFunction = #True
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Linux ;{
              sbAddLiteral(lASMContent, "public PB_"+LL_DLLFunctions()\FuncName + #System_EOL)
            ;}
            CompilerCase #PB_OS_MacOS ;{
              sbAddLiteral(lASMContent, "global PB_"+LL_DLLFunctions()\FuncName + #System_EOL)
            ;}
            CompilerCase #PB_OS_Windows ;{
              If LCase(Right(LL_DLLFunctions()\FuncName, 6)) = "_debug"
                sbAddLiteral(lASMContent, "public _PB_"+LL_DLLFunctions()\FuncName + #System_EOL)
              Else
                sbAddLiteral(lASMContent, "public PB_"+LL_DLLFunctions()\FuncName + #System_EOL)
              EndIf
            ;}
          CompilerEndSelect
        Else
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            sbAddLiteral(lASMContent, "public "+ReplaceString(gProject\sLibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName + #System_EOL)
          CompilerElse
            sbAddLiteral(lASMContent, "global "+ReplaceString(gProject\sLibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName + #System_EOL)
          CompilerEndIf
        EndIf
      ;}
      sbAddLiteral(lASMContent, "" + #System_EOL)

      Output_Add("Extrn", #Output_Log, 8)
      ;{ Extrn
        lListSizeLines = ListSize(LL_Lines())
        For lIncA = 0 To lListSizeLines -1
          SelectElement(LL_Lines(), lIncA)
          If LL_Lines()\Function = LL_DLLFunctions()\FuncName
            sLineCurrentTrimmed = Trim(LL_Lines()\Line)
            Select LCase(StringField(sLineCurrentTrimmed, 1, " "))
              Case "call", "push" ;{ some asm calls
                sLinePart = StringField(sLineCurrentTrimmed, CountString(sLineCurrentTrimmed, " ")+1, " ")
                If FindString(sLinePart, "[", 0) > 0 And FindString(sLinePart, "]", 0) > 0
                  sLinePart = Trim(Mid(sLinePart, FindString(sLinePart, "[", 0)+1, FindString(sLinePart, "]", 0) - FindString(sLinePart, "[", 0) -1))
                  Moebius_Userlib_Step2_AddExtrn(sLinePart)
                Else
                  Moebius_Userlib_Step2_AddExtrn(sLinePart)
                EndIf
              ;}
              Case "extrn" ;{
                sLinePart = StringField(sLineCurrentTrimmed, CountString(sLineCurrentTrimmed, " ")+1, " ")
                If sLinePart <> ""
                  AddElement(LL_ASM_extrn_Removed())
                  LL_ASM_extrn_Removed() = sLinePart
                EndIf
              ;}
              Default ;{
                ; If the cleaned line contained a call which didn't contain any registry
                If Left(sLineCurrentTrimmed, 1) <> ";"
                  If FindString(sLineCurrentTrimmed, "[", 0) > 0 And FindString(sLineCurrentTrimmed, "]", 0) > 0
                    sLinePart = Trim(Mid(sLineCurrentTrimmed, FindString(sLineCurrentTrimmed, "[", 0)+1, FindString(sLineCurrentTrimmed, "]", 0) - FindString(sLineCurrentTrimmed, "[", 0) -1))
                    If sLinePart <> ""
                      Moebius_Userlib_Step2_AddExtrn(sLinePart)
                    EndIf
                  Else
                    sLinePart = sLineCurrentTrimmed
                   
                    ; It's not a comment or a label
                    If Left(sLinePart, 1) <> ";" And Right(sLinePart, 1) <> ":"
                      ;{ Looking for strings
                        lPos = FindString(sLinePart, "_S", 1)
                        If lPos > 0
                          sLinePart = Right(sLinePart, Len(sLinePart) - lPos +1)
                          lPos = FindString(sLinePart, " ", 1)
                          If lPos > 0
                            sLinePart = Left(sLinePart, lPos-1)
                          EndIf 
                          Moebius_Userlib_Step2_AddExtrn(sLinePart)
                        EndIf
                      ;}
                      ;{ Looking for labels
                        lPos = FindString(sLinePart, "l_", 1)
                        If lPos > 0
                          sLinePart = Right(sLinePart, Len(sLinePart) - lPos +1)
                          lPos = FindString(sLinePart, " ", 1)
                          If lPos > 0
                            sLinePart = Left(sLinePart, lPos-1)
                          EndIf 
                          ;{ Dichotomic Search
                            lLastPos = ListIndex(LL_Lines())
                            ResetList(LL_LabelsInFunctions())
                            bFound = #False
                            sSearchedLabel = sLinePart+":"
                            qIndStart = 0
                            qIndEnd = ListSize(LL_LabelsInFunctions()) -1
                            If qIndEnd >= 0
                              Repeat
                                qIndMid = qIndStart + ((qIndEnd - qIndStart)/2)
                                Debug qIndMid
                                Debug sValue
                                Debug sSearchedLabel
                                SelectElement(LL_LabelsInFunctions(), qIndMid)
                                sValue = LL_LabelsInFunctions()\Label
                                lCompare = CompareMemoryString(@sValue, @sSearchedLabel, #PB_String_NoCase)
                                If lCompare = 0
                                  If LL_LabelsInFunctions()\function = LL_DLLFunctions()\FuncName
                                    If sValue = sSearchedLabel
                                      bFound = #True
                                    Else
                                      qIndStart = qIndStart + 1
                                    EndIf
                                  Else
                                    qIndStart = qIndStart + 1
                                  EndIf
                                ElseIf lCompare > 0 ; svalue > sSearchedLabel
                                  qIndEnd = qIndMid -1
                                  If qIndEnd < 0 
                                    qIndEnd = 0
                                  EndIf
                                  SelectElement(LL_LabelsInFunctions(), qIndEnd)
                                  If LL_LabelsInFunctions()\function = LL_DLLFunctions()\FuncName
                                    If LL_LabelsInFunctions()\Label = sSearchedLabel
                                      qIndMid = qIndEnd
                                      bFound = #True
                                    EndIf
                                  EndIf
                                ElseIf lCompare < 0 ; svalue < sSearchedLabel
                                  qIndStart = qIndMid +1
                                  SelectElement(LL_LabelsInFunctions(), qIndStart)
                                  If LL_LabelsInFunctions()\function = LL_DLLFunctions()\FuncName
                                    If LL_LabelsInFunctions()\Label = sSearchedLabel
                                      qIndMid = qIndStart
                                      bFound = #True
                                    EndIf
                                  EndIf
                                EndIf
                              Until (bFound = #True) Or (qIndStart >= qIndEnd)
                            EndIf
                            If bFound = #False
                              Moebius_Userlib_Step2_AddExtrn(sLinePart)
                            Else
                              bFound - 1
                            EndIf
                            SelectElement(LL_Lines(), lLastPos)
                          ;}
                        EndIf
                      ;}
                    EndIf
                  EndIf
                EndIf
              ;}
            EndSelect 
          EndIf
        Next
        
        ; Extrn
        Output_Add("Extrn > Write", #Output_Log, 10)
        If ListSize(LL_ASM_extrn()) > 0
          ForEach LL_ASM_extrn()
            CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
              sbAddLiteral(lASMContent, "extrn "+LL_ASM_extrn() + #System_EOL)
            CompilerElse
              sbAddLiteral(lASMContent, "extern "+LL_ASM_extrn() + #System_EOL)
            CompilerEndIf
          Next
        EndIf
        
        ; Extrn > InitFunction
        Output_Add("Extrn > InitFunction", #Output_Log, 10)
        If LL_DLLFunctions()\FuncRetType = "InitFunction"
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Linux : sbAddLiteral(lASMContent, "extrn SYS_InitString" + #System_EOL)
            CompilerCase #PB_OS_MacOS : sbAddLiteral(lASMContent, "extern _SYS_InitString" + #System_EOL)
            CompilerCase #PB_OS_Windows : sbAddLiteral(lASMContent, "extrn _SYS_InitString@0" + #System_EOL)
          CompilerEndSelect
          bExistsInitFunction = #True
        EndIf
      ;}
      sbAddLiteral(lASMContent, "" + #System_EOL)

      Output_Add("Code", #Output_Log, 8)
      ;{ Code
        ;{ Code > InitFunction
          If LL_DLLFunctions()\FuncRetType = "InitFunction"
            FirstElement(LL_Lines())
            If InsertElement(LL_Lines())
              LL_Lines()\Function = LL_DLLFunctions()\FuncName
              CompilerSelect #PB_Compiler_OS 
                CompilerCase #PB_OS_Linux : LL_Lines()\Line = "CALL SYS_InitString"
                CompilerCase #PB_OS_MacOS : MessageRequester("Moebius", "Inc_Userlib_Step2.pb l1028")
                CompilerCase #PB_OS_Windows : LL_Lines()\Line = "CALL _SYS_InitString@0"
              CompilerEndSelect
            EndIf
          EndIf
        ;}
        ;{ Code > Add the label for DLL Function
          ; Search the start of function lines
          ForEach LL_Lines()
            If LL_Lines()\Function = LL_DLLFunctions()\FuncName
              Break
            EndIf
          Next
          
          ; Go after the first label
          If LL_DLLFunctions()\IsDLLFunction = #True
            If Right(LL_Lines()\Line, 1) = ":"
              NextElement(LL_Lines())
            EndIf
          EndIf
          
          If InsertElement(LL_Lines())
            If LL_DLLFunctions()\IsDLLFunction = #True
              LL_Lines()\Function = LL_DLLFunctions()\FuncName
              CompilerSelect #PB_Compiler_OS 
                CompilerCase #PB_OS_Linux ;{
                  LL_Lines()\Line = ""
                ;}
                CompilerCase #PB_OS_MacOS ;{
                  MessageRequester("Moebius", "Inc_Userlib_Step2.pb l1054")
                ;}
                CompilerCase #PB_OS_Windows ;{
                  If UCase(Right(LL_DLLFunctions()\FuncName,6)) = "_DEBUG"
                    LL_Lines()\Line = "_"
                  Else
                    LL_Lines()\Line = ""
                  EndIf
                ;}
              CompilerEndSelect
              LL_Lines()\Line + "PB_"+LL_DLLFunctions()\FuncName +":"
            Else
              LL_Lines()\Function = LL_DLLFunctions()\FuncName
              LL_Lines()\Line = ReplaceString(gProject\sLibName, " ", "_")+"_"+LL_DLLFunctions()\FuncName +":"
            EndIf
          EndIf
        ;}
        ;{ Code > If the func has "arrays"' type's params, work on lines
          If FindString(LCase(LL_DLLFunctions()\ParamsRetType), "array", 1) > 0
            ; Initialize the var for testing if the line contains a label
            bLastIsLabel = #True
            ForEach LL_Lines()
              If LL_Lines()\Function = LL_DLLFunctions()\FuncName
                sLineCurrentTrimmed = Trim(LL_Lines()\Line)
                If bLastIsLabel = #True
                  If Right(sLineCurrentTrimmed, 1) = ":" ; so it's a label
                    bLastIsLabel = #True
                  Else 
                    ; we are just after the two labels (one for PB FuncName and ASM FuncName) 
                    ;+ and we want To add the code For asm arrays
                    Output_Add("Moebius_Userlib_Step2_WriteASMForArrays() > "+LL_DLLFunctions()\FuncName, #Output_Log, 2)
                    sbAddLiteral(lASMContent, Moebius_Userlib_Step2_WriteASMForArrays() + #System_EOL)
                    bLastIsLabel = #False
                  EndIf
                EndIf
                sbAddLiteral(lASMContent, sLineCurrentTrimmed + #System_EOL)
              EndIf
            Next

            ;{ Macro Final
              sbAddLiteral(lASMContent, #System_EOL)
              sbAddLiteral(lASMContent, "macro align value { rb (value-1) - ($-_"+LL_DLLFunctions()\FuncName+" + value-1) mod value }" + #System_EOL)
              sbAddLiteral(lASMContent, #System_EOL)
              CompilerSelect #PB_Compiler_OS 
                CompilerCase #PB_OS_Linux;{
                  sbAddLiteral(lASMContent, "section '.arrays' writeable" + #System_EOL)
                ;}
                CompilerCase #PB_OS_MacOS;{
                  sbAddLiteral(lASMContent, "section .arrays" + #System_EOL)
                ;}
                CompilerCase #PB_OS_Windows;{
                  sbAddLiteral(lASMContent, "section '.arrays' readable writeable" + #System_EOL)
                ;}
              CompilerEndSelect
              sbAddLiteral(lASMContent, "_"+LL_DLLFunctions()\FuncName+":" + #System_EOL)
              sbAddLiteral(lASMContent, "align 4" + #System_EOL)
              
              cNbParams = CountString(LCase(LL_DLLFunctions()\ParamsRetType), "array")
              For lIncA = 0 To cNbParams - 1
                sbAddLiteral(lASMContent, "_ptr_array_"+Str(lIncA)+":" + #System_EOL)
                sbAddLiteral(lASMContent, "rd 1" + #System_EOL)
              Next
            ;}
          Else
            ForEach LL_Lines()
              With LL_Lines()
                If \Function = LL_DLLFunctions()\FuncName
                  sbAddLiteral(lASMContent, \Line + #System_EOL)
                EndIf
              EndWith
            Next
          EndIf
        ;}
      ;}
      
      Output_Add(LL_DLLFunctions()\FuncName+" > Writing File", #Output_Log, 6)
      lFile = CreateFile(#PB_Any, gProject\sDirAsm+LL_DLLFunctions()\FuncName+".asm")
      If lFile
        WriteStringN(lFile, sbGetStringAndDestroy(lASMContent))
        CloseFile(lFile)
      Else
        ProcedureReturn #Error_017
      EndIf
    Next
  ;}
  ProcedureReturn bExistsInitFunction
EndProcedure
;@desc This step grabs the ASM file, splits it, rewrites some parts
;@return #Error_016 > Error : purebasic.asm Not Found
;@return #Error_017 > Error : can't generate the asm files
ProcedureDLL Moebius_Userlib_Step2()
  Protected bExistsInitFunction.b
  
  gState = #State_Step2
  
  Output_Add("Load the content of purebasic.asm in memory", #Output_Log, 2)
  ;{ load the content of purebasic.asm in memory
    Moebius_Userlib_Step2_LoadASMFileInMemory()
  ;}
  
  Output_Add("Create Functions List from Pure & User Libraries", #Output_Log, 2)
  ;{ get the function list from pure & user libs
    PB_CreateFunctionsList()
  ;}
  
  Output_Add("Extracts information for the future creation of the DESC File", #Output_Log, 2)
  ;{ extracts some informations from the asm file
    Moebius_Userlib_Step2_ExtractMainInformations()
  ;}
  
  Output_Add("Remove some ASM code", #Output_Log, 2)
  ;{ remove some asm code from the main file
    Moebius_Userlib_Step2_ModifyASM()
  ;}
  
  Output_Add("Create ASM Files", #Output_Log, 2)
  ;{ create ASM Files
    bExistsInitFunction = Moebius_Userlib_Step2_CreateASMFiles()
  ;}

  Output_Add("Init Function Code", #Output_Log, 2)
  ;{ Init Function
    If bExistsInitFunction = #False
      Moebius_Userlib_Step2_CreateInitFunction()
    EndIf
  ;}

  Output_Add("Shared Code", #Output_Log, 2)
  ;{ Shared Code
    Moebius_Userlib_Step2_CreateSharedFunction()
  ;}
  ProcedureReturn #Error_000
EndProcedure
