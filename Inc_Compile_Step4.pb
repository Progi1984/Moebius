
ProcedureDLL Moebius_Compile_Step4()
  ; 4. POLIB creates the LIB library from the *.OBJ files
  ; Creating descriptor file
  Log_Add("Creating descriptor file", 2)
  Protected StringTmp.s
  Protected hDescFile.l = CreateFile(#PB_Any, gProject\FileDesc)
  If hDescFile
    WriteStringN(hDescFile,"ASM") 
    Log_Add("ASM", 4)
    ; Lib Systems
    WriteStringN(hDescFile,Str(CountList(LL_DLLUsed())))
    Log_Add(Str(CountList(LL_DLLUsed())), 4)
    ForEach LL_DLLUsed()
      WriteStringN(hDescFile, LL_DLLUsed())
      Log_Add(LL_DLLUsed(), 4)
    Next
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
    WriteStringN(hDescFile,Str(CountList(LL_LibUsed())))
    Log_Add(Str(CountList(LL_LibUsed())), 4)
    StringTmp=""
    ForEach LL_LibUsed()
      WriteStringN(hDescFile,LL_LibUsed())
      Log_Add(LL_LibUsed(), 4)
    Next
    WriteStringN(hDescFile, gProject\FileCHM)
    Log_Add(gProject\FileCHM, 4)
    ForEach LL_DLLFunctions()
      If LL_DLLFunctions()\InDescFile = #True
        If LL_DLLFunctions()\FuncRetType <> "InitFunction"
          If LL_DLLFunctions()\IsDLLFunction = #True
            StringTmp = LL_DLLFunctions()\FuncName+LL_DLLFunctions()\ParamsRetType+" ("+LL_DLLFunctions()\Params+")"
            If LL_DLLFunctions()\FuncDesc <> ""
              StringTmp + " - "+LL_DLLFunctions()\FuncDesc
            EndIf
            WriteStringN(hDescFile, StringTmp)
            Log_Add(StringTmp, 4)
            StringTmp = LL_DLLFunctions()\FuncRetType+" | StdCall"
            If LL_DLLFunctions()\FlagsReturn <> ""
              StringTmp + LL_DLLFunctions()\FlagsReturn
            EndIf
            WriteStringN(hDescFile, StringTmp) 
            Log_Add(StringTmp, 4)
          EndIf
        Else ; FuncType = InitFunction
          WriteStringN(hDescFile, LL_DLLFunctions()\FuncName)
          Log_Add(LL_DLLFunctions()\FuncName, 4)
          WriteStringN(hDescFile, LL_DLLFunctions()\FuncRetType+" | StdCall") 
          Log_Add(LL_DLLFunctions()\FuncRetType+" | StdCall", 4)
        EndIf
      EndIf
    Next
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
      Log_Add(gConf_Path_OBJ2LIB+"/out:"+#DQuote+gProject\FileLib+#DQuote+" @"+#DQuote+gProject\DirObj+"ObjList.txt"+#DQuote, 2)
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
      system_(@StringTmp)
    ;}
  CompilerEndSelect
EndProcedure
