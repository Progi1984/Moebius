;@desc POLIB or AR creates the LIB library from the *.OBJ files
;@return : #Error_020 > Error : Can't create the DESC File
;@return : #Error_021 > Error : Can't copy the lib
;@return : #Error_022 > Error : Can't create the file ObjList.txt
;@return : #Error_023 > Error : polib can't be launched
;@return : #Error_024 > Error : the library isn't generated
ProcedureDLL Moebius_Userlib_Step4()
  Protected StringTmp.s, psDescContent.s, psProgRequest.s, psProgReturn.s
  Protected lDescFile.l, lNbImportLib.l, lError.l
  
  gState = #State_Step4
  
  Output_Add("Creating descriptor file", #Output_Log, 2)
  ;{ Creating descriptor file
    ;{ Langage used to code the library
      psDescContent = "; Langage used to code the library" + #System_EOL
      psDescContent + "ASM" + #System_EOL
      psDescContent + "" + #System_EOL
    ;}
    ;{ Lib Systems
      psDescContent + "; Number of Libraries than the library need" + #System_EOL
      psDescContent + Str(ListSize(LL_DLLUsed())) + #System_EOL
      ForEach LL_DLLUsed()
        psDescContent + LL_DLLUsed() + #System_EOL
      Next
      psDescContent + "" + #System_EOL
    ;}
    ;{ Library Type
      psDescContent + "; Library Type" + #System_EOL
      psDescContent + "LIB" + #System_EOL
      ForEach LL_LibUsed()
        If LL_LibUsed() = "glibc"
          DeleteElement(LL_LibUsed())
        EndIf
      Next
      psDescContent + "" + #System_EOL
    ;}
    ;{ PureBasic library needed by the library
      psDescContent + "; PureBasic library needed by the library" + #System_EOL
      psDescContent + Str(ListSize(LL_LibUsed())) + #System_EOL
      ForEach LL_LibUsed()
        psDescContent + LL_LibUsed() + #System_EOL
      Next
      psDescContent + "" + #System_EOL
    ;}
    ;{ Help directory name
      psDescContent + "; Help directory name" + #System_EOL
      psDescContent + gProject\sFileCHM + #System_EOL
      psDescContent + "" + #System_EOL
    ;}
    ;{ Library functions
      psDescContent + "; Library functions" + #System_EOL
      ForEach LL_DLLFunctions()
        With LL_DLLFunctions()
          If \InDescFile = #True
            If \IsDLLFunction = #True
              psDescContent + \FuncName+\ParamsRetType+", ("+\ParamsClean+")"
              If \FuncDesc <> ""
                psDescContent + " - "+\FuncDesc
              EndIf
              psDescContent + #System_EOL
              psDescContent + \FuncRetType+" | "+\CallingConvention
              If \FlagsReturn <> ""
                psDescContent + \FlagsReturn
              EndIf
              psDescContent + #System_EOL
            EndIf
          EndIf
        Next
      Next
    ;}
    
    lDescFile = CreateFile(#PB_Any, gProject\sFileDesc)
    If lDescFile
      WriteString(lDescFile, psDescContent)
      Output_Add(psDescContent, #Output_Log, 2)
      CloseFile(lDescFile)
    Else
      ProcedureReturn #Error_020
    EndIf
  ;}

  Output_Add("Working on Import", #Output_Log, 2)
  ;{ Working on Import .lib/.a
    ForEach LL_ImportUsed()
      If CopyFile(LL_ImportUsed(), gProject\sDirObj+"ImportedLib_"+Str(lNbImportLib)+"."+GetExtensionPart(LL_ImportUsed()))= #False
        ProcedureReturn #Error_021
      Else
        Output_Add("IN  > "+LL_ImportUsed(), #Output_Log, 4)
        LL_ImportUsed() = gProject\sDirObj+"ImportedLib_"+Str(lNbImportLib)+"."+GetExtensionPart(LL_ImportUsed())
        Output_Add("OUT > "+LL_ImportUsed(), #Output_Log, 4)
      EndIf
    Next
  ;}
  
  Output_Add("Creating archive", #Output_Log, 2)
  ;{ Generates a file which contains all objects files
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux;{
        psProgRequest = "ar rvs "
        psProgRequest + #DQuote+gProject\sDirLib+ M_LibName_Clean(gProject\sLibName) + #System_ExtLib+#DQuote+" "
        psProgRequest + gProject\sDirObj + "*"
        
        psProgReturn = Str(system_(@psProgRequest))
      ;}
      CompilerCase #PB_OS_MacOS;{
        MessageRequester("Moebius", "Inc_Userlib_Step4.pb l96")
      ;}
      CompilerCase #PB_OS_Windows;{
        Protected lObjFile.l
        Protected lPgm_Polib.l
        
        lObjFile = CreateFile(#PB_Any, gProject\sDirObj+"ObjList.txt")
        If lObjFile
          ForEach LL_DLLFunctions()
            WriteStringN(lObjFile, #DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote)
          Next
          ForEach LL_ImportUsed()
            WriteStringN(lObjFile, #DQuote+LL_ImportUsed()+#DQuote)
          Next
          CloseFile(lObjFile)
        Else
          ProcedureReturn #Error_022
        EndIf
        
        psProgRequest = "/out:" + #DQuote + gProject\sDirLib + M_LibName_Clean(gProject\sLibName) + #System_ExtLib + #DQuote
        psProgRequest + " @" + #DQuote + gProject\sDirObj + "ObjList.txt" + #DQuote
        
        lPgm_Polib = RunProgram(gConf\sPath_OBJ2LIB, psProgRequest, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
        If lPgm_Polib
          While ProgramRunning(lPgm_Polib)
            psProgReturn + ReadProgramString(lPgm_Polib) + #System_EOL
          Wend
          CloseProgram(lPgm_Polib)
        Else
          psProgReturn = "Error in RunProgram"
          lError = #Error_023
        EndIf
        psProgRequest = #DQuote + gConf\sPath_OBJ2LIB + #DQuote + " " + psProgRequest
      ;}
    CompilerEndSelect
    Output_Add(psProgRequest, #Output_Log | #Output_Bat, 4)
    Output_Add(psProgReturn, #Output_Log, 4)

    If FileSize(gProject\sDirLib + M_LibName_Clean(gProject\sLibName) + #System_ExtLib) = 0
      lError = #Error_024
    EndIf
    If lError <> #Error_000
      ProcedureReturn lError
    Else
      ProcedureReturn #Error_000
    EndIf
  ;}
EndProcedure
;- TODO : sContent de desc in sb
