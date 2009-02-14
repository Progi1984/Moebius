;@desc POLIB or AR creates the LIB library from the *.OBJ files
ProcedureDLL Moebius_Compile_Step4()
  Protected StringTmp.s, sDescContent.s, sProgRequest.s, sProgReturn.s
  Protected lDescFile.l, lNbImportLib.l
  Output_Add("Creating descriptor file", #Output_Log, 2)
  ;{ Creating descriptor file
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
    
    lDescFile = CreateFile(#PB_Any, gProject\sFileDesc)
    If lDescFile
      WriteString(lDescFile, sDescContent)
      Output_Add(sDescContent, #Output_Log, 2)
      CloseFile(lDescFile)
    EndIf
  ;}

  Output_Add("Working on Import", #Output_Log, 2)
  ;{ Working on Import .lib/.a
    ForEach LL_ImportUsed()
      CopyFile(LL_ImportUsed(), gProject\sDirObj+"ImportedLib_"+Str(lNbImportLib)+"."+GetExtensionPart(LL_ImportUsed()))
      Output_Add("IN  > "+LL_ImportUsed(), #Output_Log, 4)
      LL_ImportUsed() = gProject\sDirObj+"ImportedLib_"+Str(lNbImportLib)+"."+GetExtensionPart(LL_ImportUsed())
      Output_Add("OUT > "+LL_ImportUsed(), #Output_Log, 4)
    Next
  ;}
  
  Output_Add("Creating archive", #Output_Log, 2)
  ;{ Generates a file which contains all objects files
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows;{
        Protected lObjFile.l = CreateFile(#PB_Any, gProject\sDirObj+"ObjList.txt")
        Protected lPgm_Polib.l
        
        If lObjFile
          ForEach LL_DLLFunctions()
            WriteStringN(lObjFile, #DQuote+gProject\sDirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote)
          Next
          ForEach LL_ImportUsed()
            WriteStringN(lObjFile, #DQuote+LL_ImportUsed()+#DQuote)
          Next
          CloseFile(lObjFile)
        EndIf
        
        sProgRequest = "/out:" + #DQuote + gProject\sDirLib + M_LibName_Clean(gProject\sLibName) + #System_ExtLib + #DQuote
        sProgRequest + " @" + #DQuote + gProject\sDirObj + "ObjList.txt" + #DQuote
        
        lPgm_Polib = RunProgram(gConf\sPath_OBJ2LIB, sProgRequest, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
        If lPgm_Polib
          While ProgramRunning(lPgm_Polib)
            sProgReturn + ReadProgramString(lPgm_Polib) + #System_EOL
          Wend
        Else
          sProgReturn = "Error in RunProgram"
        EndIf
        CloseProgram(lPgm_Polib)
      ;}
      CompilerCase #PB_OS_Linux;{
        sProgRequest = "ar rvs "
        sProgRequest + #DQuote+gProject\sDirLib+ M_LibName_Clean(gProject\sLibName) + #System_ExtLib+#DQuote+" "
        sProgRequest + gProject\sDirObj + "*"
        
        sProgReturn = Str(system_(@sProgRequest))
      ;}
    CompilerEndSelect
    Output_Add(sProgRequest, #Output_Log | #Output_Bat, 4)
    Output_Add(sProgReturn, #Output_Log, 4)
  ;}
EndProcedure
