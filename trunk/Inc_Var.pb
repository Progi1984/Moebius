Structure S_Project
  Name.s
  FileName.s
  LibName.s
  FileAsm.s
  FileDesc.s
  DirObj.s
  FileLib.s
  FileCHM.s
EndStructure
Structure S_DLLFunctions
  FuncName.s
  FuncRetType.s
  FuncDesc.s
  Params.s
  ParamsRetType.s
  Code.s
  IsDLLFunction.b
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

Global NewList LL_DLLFunctions.S_DLLFunctions()
Global NewList LL_PBFunctions.S_PBFunctionInfo()
Global NewList LL_Functions.s()
Global NewList LL_LibUsed.s()
Global NewList LL_DLLUsed.s()

; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 39
; Folding = w
; EnableXP