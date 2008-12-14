Structure S_Project
  Name.s
  FileName.s
  LibName.s
  FileAsm.s
  FileDesc.s
  DirObj.s
  FileLib.s
  FileCHM.s
  IsUnicode.b
  IsThreadSafe.b
EndStructure
Structure S_DLLFunctions
  FuncName.s
  FuncRetType.s
  FuncDesc.s
  Params.s
  ParamsClean.s
  ParamsNumber.l
  ParamsRetType.s
  FlagsReturn.s ; FlagsReturn for specific options : MMX, SSE, SSE2, etc...
  InDescFile.b
  Code.s
  IsDLLFunction.b
  Win_ASMNameFunc.s
EndStructure
Structure S_PBFunctionInfo
  FuncName.s
  FuncDesc.s
  Params.s
  LibContaining.s
EndStructure
Structure S_Seeker
  StructureUnion
    b.b
    w.w
    l.l
  EndStructureUnion
EndStructure

Global gProject.S_Project
Global hCompiler.l
Global Moebius_Compile_Step2_sCodeShared.s

Global NewList LL_DLLFunctions.S_DLLFunctions()
Global NewList LL_PBFunctions.S_PBFunctionInfo()
Global NewList LL_Functions.s()
Global NewList LL_LibUsed.s()
Global NewList LL_DLLUsed.s()
Global NewList LL_ASM_extrn.s()


#DQuote = Chr(34)
