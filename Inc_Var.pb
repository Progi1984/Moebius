Structure S_Project
  Name.s
  FileName.s
  LibName.s
  FileAsm.s
  FileDesc.s
  DirObj.s
  FileLib.s
  FileCHM.s
  sFileOutput.s
  
  bUnicode.b
  bThreadSafe.b
  bDontBuildLib.b
  bKeepSrcFiles.b
  bLogFile.b
  bBatFile.b
EndStructure
Structure S_DLLFunctions
  FuncName.s
  FuncRetType.s
  FuncDesc.s
  CallingConvention.s
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
Global gConf_PureBasic_Path.s
Global gConf_Path_PBCOMPILER.s
Global gConf_Path_FASM.s
Global gConf_Path_OBJ2LIB.s
Global gConf_Path_PBLIBMAKER.s
Global gConf_SourceDir.s
Global gConf_ProjectDir.s
Global gConf_Ini_Purebasic.s

Global NewList LL_DLLFunctions.S_DLLFunctions()
Global NewList LL_PBFunctions.S_PBFunctionInfo()
Global NewList LL_Functions.s()
Global NewList LL_LibUsed.s()
Global NewList LL_DLLUsed.s()
Global NewList LL_ImportUsed.s()
Global NewList LL_ASM_extrn.s()


#DQuote = Chr(34)

Macro M_SetConstantPrefs(Name, ValL, ValS, ValSl)
  #Name#_l = ValL
  #Name#_s = ValS
  #Name#_sl = ValSl
EndMacro

Global Dim D_Parameters.s(9)