
ProcedureDLL Moebius_Compile_Step4()
  ; 4. POLIB creates the LIB library from the *.OBJ files
  ; Creating descriptor file
  Log_Add("Creating descriptor file", 2)
  Protected StringTmp.s
  Protected hDescFile.l = CreateFile(#PB_Any, gProject\FileDesc)
  If hDescFile
    ;{ Langage used to code the library
    WriteStringN(hDescFile,"; Langage used to code the library") 
    Log_Add("; Langage used to code the library", 4)
    WriteStringN(hDescFile,"ASM") 
    Log_Add("ASM", 4)
    WriteStringN(hDescFile, ""):Log_Add("", 4)
    ;}
    ;{ Lib Systems
    WriteStringN(hDescFile,"; Number of Libraries than the library need")
    Log_Add("; Number of Libraries than the library need", 4)
    WriteStringN(hDescFile,Str(ListSize(LL_DLLUsed())))
    Log_Add(Str(ListSize(LL_DLLUsed())), 4)
    ForEach LL_DLLUsed()
      WriteStringN(hDescFile, LL_DLLUsed())
      Log_Add(LL_DLLUsed(), 4)
    Next
    WriteStringN(hDescFile, ""):Log_Add("", 4)
    ;}
    ;{ Library Type
    WriteStringN(hDescFile,"; Library Type")
    Log_Add("; Library Type", 4)
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
    WriteStringN(hDescFile, ""):Log_Add("", 4)
    ;}
    ;{ PureBasic library needed by the library
    WriteStringN(hDescFile,"; PureBasic library needed by the library")
    Log_Add("; PureBasic library needed by the library", 4)
    WriteStringN(hDescFile,Str(ListSize(LL_LibUsed())))
    Log_Add(Str(ListSize(LL_LibUsed())), 4)
    StringTmp=""
    ForEach LL_LibUsed()
      WriteStringN(hDescFile,LL_LibUsed())
      Log_Add(LL_LibUsed(), 4)
    Next
    WriteStringN(hDescFile, ""):Log_Add("", 4)
    ;}
    ;{ Help directory name
    WriteStringN(hDescFile,"; Help directory name")
    Log_Add("; Help directory name", 4)
    WriteStringN(hDescFile, gProject\FileCHM)
    Log_Add(gProject\FileCHM, 4)
    WriteStringN(hDescFile, ""):Log_Add("", 4)
    ;}
    ;{ Library functions
    WriteStringN(hDescFile,"; Library functions")
    Log_Add("; Library functions", 4)
    ForEach LL_DLLFunctions()
      If LL_DLLFunctions()\InDescFile = #True
        If LL_DLLFunctions()\IsDLLFunction = #True
          StringTmp = LL_DLLFunctions()\FuncName+LL_DLLFunctions()\ParamsRetType+", ("+LL_DLLFunctions()\ParamsClean+")"
          If LL_DLLFunctions()\FuncDesc <> ""
            StringTmp + " - "+LL_DLLFunctions()\FuncDesc
          EndIf
          WriteStringN(hDescFile, StringTmp)
          Log_Add(StringTmp, 4)
          StringTmp = LL_DLLFunctions()\FuncRetType+" | "+LL_DLLFunctions()\CallingConvention
          If LL_DLLFunctions()\FlagsReturn <> ""
            StringTmp + LL_DLLFunctions()\FlagsReturn
          EndIf
          WriteStringN(hDescFile, StringTmp) 
          Log_Add(StringTmp, 4)
        EndIf
      EndIf
    Next
    ;}
    CloseFile(hDescFile)
  EndIf
  ; Creating archive
  Log_Add("Creating archive", 2)
  ; Generates a file which contains all objects files
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows;{
      Protected hObjFile.l = CreateFile(#PB_Any, gProject\DirObj+"ObjList.txt")
      Protected Pgm_Polib.l
      If hObjFile
        ForEach LL_DLLFunctions()
          WriteStringN(hObjFile, #DQuote+gProject\DirObj+LL_DLLFunctions()\FuncName+#System_ExtObj+#DQuote)
        Next
        CloseFile(hObjFile)
      EndIf
      Pgm_Polib = RunProgram(gConf_Path_OBJ2LIB, "/out:"+#DQuote+gProject\FileLib+#DQuote+" @"+#DQuote+gProject\DirObj+"ObjList.txt"+#DQuote, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
      Log_Add(#DQuote+gConf_Path_OBJ2LIB+#DQuote+" /out:"+#DQuote+gProject\FileLib+#DQuote+" @"+#DQuote+gProject\DirObj+"ObjList.txt"+#DQuote, 2)
      Batch_Add(#DQuote+gConf_Path_OBJ2LIB+#DQuote+" /out:"+#DQuote+gProject\FileLib+#DQuote+" @"+#DQuote+gProject\DirObj+"ObjList.txt"+#DQuote)
      If Pgm_Polib
        While ProgramRunning(Pgm_Polib)
          Log_Add(ReadProgramString(Pgm_Polib),2)
        Wend
      Else
        Log_Add("Error in RunProgram", 2)
      EndIf
      CloseProgram(Pgm_Polib)
    ;}
    CompilerCase #PB_OS_Linux;{
      StringTmp = "ar rvs "
      StringTmp + #DQuote+gProject\FileLib+#DQuote+" "
      StringTmp + gProject\DirObj + "*"+#System_ExtObj
      Log_Add(StringTmp, 2)
      Batch_Add(StringTmp)
      system_(@StringTmp)
    ;}
  CompilerEndSelect
EndProcedure
