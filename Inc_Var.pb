;{ Structures
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
  Structure S_ReadFile_BuildArrayInfo
    FileName.S
    ExecStatus.I
    
    *SeqBegin
    *SeqEnd
    SeqSize.I ; En octet
    
    *ArrayTable
    *ArrayTableEnd
    ArrayTableSize.I ; (nombre de pointeurs)
    
    LineMeanLength.I ; Taille moyenne d'une ligne  
  EndStructure 
  Structure S_TextLineInfo
    TextLine.s[1 << 24]
  EndStructure
;}
;{ Linked lists
  Global NewList LL_DLLFunctions.S_DLLFunctions()
  Global NewList LL_PBFunctions.S_PBFunctionInfo()
  Global NewList LL_Functions.s()
  Global NewList LL_LibUsed.s()
  Global NewList LL_DLLUsed.s()
  Global NewList LL_ImportUsed.s()
  Global NewList LL_ASM_extrn.s()
  Global NewList LL_Logs.s()
;}
;{ Arrays
  Global Dim D_Parameters.s(9)
;}
;{ Globals
  Global gProject.S_Project
  Global gConf.S_PBConf
  Global hCompiler.l
  Global hFileLog.l
  Global hFileBatch.l
  Global lTimeStart.l
  Global gState.l
  Global gError.l
  Global *DimLines.S_TextLineInfo
  Global gReadFileInfo.S_ReadFile_BuildArrayInfo
;}
;{ Constants
  #DQuote = Chr(34)
  #Output_Log = $001
  #Output_Bat = $002
  
  #FileRead_FileOpened   = 1
  #FileRead_MemAllocated = 2
  #FileRead_FileLoaded   = 4
  #FileRead_TableCreated = 8 
  
  Enumeration 
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
    #Error_Last
  EndEnumeration
;}
;{ Macros
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
        SetGadgetText(#Window_0_String_2, gProject\sFileCHM)
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
      If IsGadget(#Window_0_Editor_0)
        ClearGadgetItems(#Window_0_Editor_0)
      EndIf
    CompilerEndIf
    ; Clear variables before any compilation
    ClearList(LL_DLLFunctions())
    ClearList(LL_PBFunctions())
    ClearList(LL_Functions())
    ClearList(LL_LibUsed())
    ClearList(LL_DLLUsed())
    ClearList(LL_ImportUsed())
    ClearList(LL_ASM_extrn())
    hCompiler = #False
    hFileLog = #False
    hFileBatch = #False
    gState = #State_StepStart
  EndMacro
  Macro M_AddInLLWithDichotomicSearch(LinkedList, StringCompared, StringSearched, Add = #True)
    Define.s DichoSearch_sValue
    Define.q DichoSearch_qIndStart, DichoSearch_qIndEnd, DichoSearch_qIndMid
    Define.b DichoSearch_bFound
    Define.l DichoSearch_lCompare
    ResetList(LinkedList)
    DichoSearch_bFound = #False
    DichoSearch_qIndStart = 0
    DichoSearch_qIndEnd = ListSize(LinkedList) -1
    If DichoSearch_qIndEnd >= 0
      While DichoSearch_qIndStart <= DichoSearch_qIndEnd
        DichoSearch_qIndMid = (DichoSearch_qIndStart + DichoSearch_qIndEnd +1) >>1
        SelectElement(LinkedList, DichoSearch_qIndMid)
        DichoSearch_sValue = StringCompared
        DichoSearch_lCompare = CompareMemoryString(@DichoSearch_sValue, @StringSearched, #PB_String_NoCase)
        If DichoSearch_lCompare = 0
          DichoSearch_bFound = #True
          DichoSearch_qIndStart = DichoSearch_qIndEnd + 1
        ElseIf DichoSearch_lCompare > 0
          DichoSearch_qIndEnd = DichoSearch_qIndMid -1
        ElseIf DichoSearch_lCompare < 0
          DichoSearch_qIndStart = DichoSearch_qIndMid +1
        EndIf
      Wend
    EndIf
    If Add = #True
      If DichoSearch_bFound = #False
        AddElement(LinkedList)
        LinkedList = StringSearched
        SortList(LinkedList, #PB_Sort_Ascending | #PB_Sort_NoCase)
      EndIf
    EndIf
  EndMacro

;}
