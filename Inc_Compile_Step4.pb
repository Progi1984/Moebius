ProcedureDLL Moebius_Compile_Step4()
  Protected StringTmp.s, sDescContent.s, sProgRequest.s, sProgReturn.s
  Protected hDescFile.l, lNbImportLib.l
  ; 4. POLIB creates the LIB library from the *.OBJ files
  ;{ Creating descriptor file
    Output_Add("Creating descriptor file", #Output_Log, 2)
    ;{ Langage used to code the library
      sDescContent = "; Langage used to code the library" + #System_EOL
      sDescContent + "ASM" + #System_EOL
      sDescContent + "" + #System_EOL
    ;}
    ;{ Lib Systems
      sDescContent + "; Number of Libraries than the library need" + #System_EOL
      sDescContent + Str(ListSize(LL_DLLUsed())) + #System_EOL
      ForEach LL_DLLUsed()
        sDescContent + LL_DLLUsed() + #System_EOL
      Next
      sDescContent + "" + #System_EOL
    ;}
    ;{ Library Type
      sDescContent + "; Library Type" + #System_EOL
      sDescContent + "LIB" + #System_EOL
      ForEach LL_LibUsed()
        If LL_LibUsed() = "glibc"
          DeleteElement(LL_LibUsed())
        EndIf
      Next
      sDescContent + "" + #System_EOL
    ;}
    ;{ PureBasic library needed by the library
      sDescContent + "; PureBasic library needed by the library" + #System_EOL
      sDescContent + Str(ListSize(LL_LibUsed())) + #System_EOL
      ForEach LL_LibUsed()
        sDescContent + LL_LibUsed() + #System_EOL
      Next
      sDescContent + "" + #System_EOL
    ;}
    ;{ Help directory name
      sDescContent + "; Help directory name" + #System_EOL
      sDescContent + gProject\sFileCHM + #System_EOL
      sDescContent + "" + #System_EOL
    ;}
    ;{ Library functions
      sDescContent + "; Library functions" + #System_EOL
      ForEach LL_DLLFunctions()
        If LL_DLLFunctions()\InDescFile = #True
          If LL_DLLFunctions()\IsDLLFunction = #True
            sDescContent + LL_DLLFunctions()\FuncName+LL_DLLFunctions()\ParamsRetType+", ("+LL_DLLFunctions()\ParamsClean+")"
            If LL_DLLFunctions()\FuncDesc <> ""
              sDescContent + " - "+LL_DLLFunctions()\FuncDesc
            EndIf
            sDescContent + #System_EOL
            sDescContent + LL_DLLFunctions()\FuncRetType+" | "+LL_DLLFunctions()\CallingConvention
            If LL_DLLFunctions()\FlagsReturn <> ""
              sDescContent + LL_DLLFunctions()\FlagsReturn
            EndIf
            sDescContent + #System_EOL
          EndIf
        EndIf
      Next
    ;}
    hDescFile = CreateFile(#PB_Any, gProject\sFileDesc)
    If hDescFile
      WriteString(hDescFile, sDescContent)
      CloseFile(hDescFile)
    EndIf
  ;}
  ;{ Working on Import .lib/.a
    Output_Add("Working on Import", #Output_Log, 2)
    ForEach LL_ImportUsed()
      CopyFile(LL_ImportUsed(), gProject\sDirObj+"ImportedLib_"+Str(lNbImportLib)+"."+GetExtensionPart(LL_ImportUsed()))
      Output_Add("IN  > "+LL_ImportUsed(), #Output_Log, 4)
      LL_ImportUsed() = gProject\sDirObj+"ImportedLib_"+Str(lNbImportLib)+"."+GetExtensionPart(LL_ImportUsed())
      Output_Add("OUT > "+LL_ImportUsed(), #Output_Log, 4)
    Next
  ;}
  ; Creating archive
  Output_Add("Creating archive", #Output_Log, 2)
  ;{ Generates a file which contains all objects files
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows;{
      Protected hObjFile.l = CreateFile(#PB_Any, gProject\sDirObj+"ObjList.txt")
      Protected hPgm_Polib.l
      
      If hObjFile
        ForEach LL_DLLFunctions()
          WriteStringN(hObjFile, #DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote)
        Next
        ForEach LL_ImportUsed()
          WriteStringN(hObjFile, #DQuote+LL_ImportUsed()+#DQuote)
        Next
        CloseFile(hObjFile)
      EndIf
      sProgRequest = "/out:" + #DQuote + gProject\sDirLib + M_LibName_Clean(gProject\sLibName) + ".lib" + #DQuote
      sProgRequest + " @" + #DQuote + gProject\sDirObj + "ObjList.txt" + #DQuote
      hPgm_Polib = RunProgram(gConf_Path_OBJ2LIB, sProgRequest, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
      If hPgm_Polib
        While ProgramRunning(hPgm_Polib)
          sProgReturn + ReadProgramString(hPgm_Polib) + #System_EOL
        Wend
      Else
        sProgReturn = "Error in RunProgram"
      EndIf
      CloseProgram(hPgm_Polib)
    ;}
    CompilerCase #PB_OS_Linux;{
      sProgRequest = "ar rvs "
      sProgRequest + #DQuote+gProject\sDirLib+#DQuote+" "
      sProgRequest + gProject\sDirObj + "*"
      sProgReturn = Str(system_(@sProgRequest))
    ;}
  CompilerEndSelect
  Output_Add(sProgRequest, #Output_Log | #Output_Bat, 2)
  Output_Add(sProgReturn, #Output_Log, 2)
  ;}
EndProcedure
