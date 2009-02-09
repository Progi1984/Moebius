Structure S_Project
  sFileName.s           ; PB Filename for compiling
  sFileDesc.s           ; Desc File
  sFileCHM.s
  sFileOutput.s         ; filename (without path) of the library
  sFileLog.s
  
  sLibName.s            ; library name
  sSubsystem.s
  
  sDirProject.s         ; Dir > Temp for compiling
  sDirAsm.s             ; Dir > containing asm files
  sDirObj.s             ; Dir > containing objects
  sDirLib.s             ; Dir > containing lib & desc
  sDirBat.s             ; Dir > containing Bat or SH
  sDirLogs.s            ; Dir > containing logs by default
  
  bUnicode.b
  bThreadSafe.b
  bDontBuildLib.b
  bDontKeepSrcFiles.b
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
Global hFileLog.l
Global hFileBatch.l
Global Moebius_Compile_Step2_sCodeShared.s
Global gConf_PureBasic_Path.s
Global gConf_Path_PBCOMPILER.s
Global gConf_Path_FASM.s
Global gConf_Path_OBJ2LIB.s
Global gConf_Path_PBLIBMAKER.s
Global gConf_SourceDir.s
;Global gConf_ProjectDir.s
Global gConf_Ini_Purebasic.s
Global gConf_Ini_Project.s

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
Macro M_IsDigit(c)
  ((c >= '0') And (c <= '9'))
EndMacro 
Macro M_Moebius_InitDir(isCHM = #False, isLog = #False, isOutput = #False)
  gProject\sDirBat  = gProject\sDirProject + "BAT" + #System_Separator
  gProject\sDirLogs = gProject\sDirProject + "LOGS"+ #System_Separator
  gProject\sDirAsm  = gProject\sDirProject + "ASM" + #System_Separator
  gProject\sDirObj  = gProject\sDirProject + "OBJ" + #System_Separator
  gProject\sDirLib  = gProject\sDirProject + "LIB" + #System_Separator
    gProject\sFileDesc = gProject\sDirLib + gProject\sLibName+".desc"      
  If isCHM = #False
    gProject\sFileCHM  = gProject\sLibName + #System_ExtHelp
    CompilerIf Defined(Moebius_App, #PB_Constant) = #True
      SetGadgetText(#String_2, gProject\sFileCHM)
    CompilerEndIf
  EndIf
  If isLog = #False
    gProject\sFileLog  = gProject\sDirProject+"LOGS"+#System_Separator+"Log_"+FormatDate("%yyyy_%mm_%dd_%hh_%ii_%ss", Date())+".log"
  EndIf
  If isOutput = #False
    gProject\sFileOutput  = gProject\sLibName
  EndIf
EndMacro
Macro M_LibName_Clean(name)
  ReplaceString(gProject\sLibName, " ", "_")
EndMacro

Global Dim D_Parameters.s(9)
