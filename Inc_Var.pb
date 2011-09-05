;-{ Structures }
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
  Structure S_PBConf
    sPureBasic_Path.s
    sPath_PBCOMPILER.s
    sPath_FASM.s
    sPath_OBJ2LIB.s
    sPath_PBLIBMAKER.s
    sSourceDir.s
    sIni_Purebasic.s
    sIni_Project.s
  EndStructure
  Structure S_PBFunctionInfo
    FuncName.s
    FuncDesc.s
    Params.s
    LibContaining.s
  EndStructure
  Structure S_Project
    sFileName.s           ; PB Filename for compiling
    sPBPFileName.s        ; PBP Filename for extracting the target
    sPBPTarget.s 
    bTypeOutput.b
    sFileOutput.s         ; filename (without path) of the library
    
    sFileDesc.s           ; Desc File
    sFileCHM.s
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
    bInlineASM.b
    bDontBuildLib.b
    bDontKeepSrcFiles.b
    bLogFile.b
    bLogInStreaming.b
    bBatFile.b
  EndStructure
  Structure S_Seeker
    StructureUnion
      b.b
      w.w
      l.l
    EndStructureUnion
  EndStructure
  Structure S_CodeLine
    function.s
    line.s
  EndStructure
  Structure S_LabelsList
    function.s
    label.s
  EndStructure
  Structure S_StringBuilder
    pString.l
    StringSize.l
    MemSize.l
    BlockSize.l
    InitDone.l
    ; Initialized to 0 (FALSE) at creation.  Means by default
    ; we have not initialized the structure/class.
  EndStructure 
;}
;-{ Linked Lists }
  Global NewList LL_DLLFunctions.S_DLLFunctions()
  Global NewList LL_PBFunctions.S_PBFunctionInfo()
  Global NewList LL_Logs.s()
  Global NewList LL_Lines.S_CodeLine()
  Global NewList LL_LabelsInFunctions.S_LabelsList()
;}
;-{ Maps}
  Global NewMap MAP_ASM_extrn.s()
  Global NewMap MAP_ASM_extrn_Removed.s()
  Global NewMap MAP_DLLUsed.s()
  Global NewMap MAP_Functions.s()
  Global NewMap MAP_ImportUsed.s()
  Global NewMap MAP_LibUsed.s()
;}
;-{ Arrays }
  Global Dim D_Parameters.s(9)
;}
;-{ Globals }
  Global gProject.S_Project
  Global gConf.S_PBConf
  Global hCompiler.l
  Global hFileLog.l
  Global hFileBatch.l
  Global lTimeStart.l
  Global gState.l
  Global gError.l
  Global gFileMemContent.l
  Global gFileMemContentLen.l
  Global gsErrorContent.s
;}
;-{ Constants }
  #DQuote = Chr(34)
  #Output_Log = $001
  #Output_Bat = $002
 
  Enumeration 0
    #State_StepStart
    #State_Step0
    #State_Step1
    #State_Step2
    #State_Step3
    #State_Step4
    #State_Step5
    #State_Step6
    #State_StepLast
  EndEnumeration
  Enumeration 0
    #Error_000
    #Error_001
    #Error_002
    #Error_003
    #Error_004
    #Error_005
    #Error_006
    #Error_007
    #Error_008
    #Error_009
    #Error_010
    #Error_011
    #Error_012
    #Error_013
    #Error_014
    #Error_015
    #Error_016
    #Error_017
    #Error_018
    #Error_019
    #Error_020
    #Error_021
    #Error_022
    #Error_023
    #Error_024
    #Error_025
    #Error_026
    #Error_027
    #Error_028
    #Error_029
    #Error_030
    #Error_031
    #Error_032
    #Error_033
    #Error_034
    #Error_035
    #Error_036
    #Error_037
    #Error_Last
  EndEnumeration
  Enumeration 0
    #Regex_enx
    #Regex_enp
    #Regex_eni
    #Regex_Last
  EndEnumeration
  Enumeration 0
    #TypeOutput_UserLib
    #TypeOutput_Resident
  EndEnumeration
;}
;-{ Macros }
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
        SetGadgetText(#String_12, gProject\sFileCHM)
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
  Macro M_ClearBeforeBuilding()
    ; Clear the log editor
    CompilerIf Defined(Moebius_App, #PB_Constant) = #True
      gStateOld = #State_StepStart
      If gProject\bTypeOutput =  #TypeOutput_Resident
        If IsGadget(#Editor_00)
          ClearGadgetItems(#Editor_00)
        EndIf
      ElseIf gProject\bTypeOutput =  #TypeOutput_UserLib
        If IsGadget(#Editor_01)
          ClearGadgetItems(#Editor_01)
        EndIf
      EndIf
    CompilerEndIf
    ; Clear variables before any compilation
    ClearList(LL_DLLFunctions())
    ClearList(LL_PBFunctions())
    ClearMap(MAP_ASM_extrn())
    ClearMap(MAP_ASM_extrn_Removed())
    ClearMap(MAP_DLLUsed())
    ClearMap(MAP_Functions())
    ClearMap(MAP_ImportUsed())
    ClearMap(MAP_LibUsed())
    hCompiler = #False
    hFileLog = #False
    hFileBatch = #False
    gsErrorContent  = ""
    gState = #State_StepStart
  EndMacro
;}
