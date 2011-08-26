;@author Le Soldat Inconnu
;@desc This code permits you to create a directory which parents directories doesn't exist.
;@sample
;@+ ; I wish create a directory "C:\Program files\truc\bidule"
;@+ ; Only the directory "C:\Program files\" exists
;@+ ; If I use CreateDirectory("C:\Program files\truc\bidule"), that doesn't work because the directory "C:\Program files\truc\" doesn't exist
;@+ ; If I use CreateDirectoryEx("C:\Program files\truc\bidule"), all these directories will be created :
;@+ ; - C:\Program files\
;@+ ; - C:\Program files\truc\
;@+ ; - C:\Program files\truc\bidule
;@return 1 if the creation of the directory has a success
;@+ 0 if not
ProcedureDLL.l CreateDirectoryEx(FolderPath.s)
 Protected Folder.s, Txt.s, Cpt.l
 If FileSize(Folder) = -1
  Folder = StringField(FolderPath, 1, #System_Separator) + #System_Separator
  Cpt     = 1
  Repeat
   Cpt + 1
   Txt      = StringField(FolderPath, Cpt, #System_Separator)
   Folder = Folder + Txt + #System_Separator
   CreateDirectory(Folder)
  Until Txt = ""
 EndIf
 If FileSize(FolderPath) = -2
  ProcedureReturn #True
 Else
  ProcedureReturn #False
 EndIf
EndProcedure 
;@author Dr. Dri
;@desc Permits to know if a string is a numeric
;@return #True if it's a numeric, else #False
ProcedureDLL.l IsNumeric(String.s)
  Protected Numeric.l, *String.Character
  If String
    String = Trim(String)
    If Left(String, 1) = "-"
      String =  Right(String, Len(String) -1)
    EndIf
    Numeric = #True
    *String = @String
    While Numeric And *String\c
      Numeric = M_IsDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
  ProcedureReturn Numeric
EndProcedure
;@desc Initialize batch & log files
ProcedureDLL Output_Init()
  ; Log
  If gProject\bLogFile = #True
    lTimeStart = Date()
    If gProject\bLogInStreaming = #False
      hFileLog = OpenFile(#PB_Any, gProject\sFileLog)
      If hFileLog
        If gProject\bTypeOutput = #TypeOutput_UserLib
          With gProject
            WriteStringN(hFileLog, "PARAM >gProject\sFileName ="+\sFileName)
            WriteStringN(hFileLog, "PARAM >gProject\sFileDesc ="+\sFileDesc)
            WriteStringN(hFileLog, "PARAM >gProject\sFileCHM ="+\sFileCHM)
            WriteStringN(hFileLog, "PARAM >gProject\sFileOutput ="+\sFileOutput)
            WriteStringN(hFileLog, "PARAM >gProject\sFileLog ="+\sFileLog)
            
            WriteStringN(hFileLog, "PARAM >gProject\sLibName ="+\sLibName)
            WriteStringN(hFileLog, "PARAM >gProject\sSubsystem ="+\sSubsystem)
            
            WriteStringN(hFileLog, "PARAM >gProject\sDirProject ="+\sDirProject)
            WriteStringN(hFileLog, "PARAM >gProject\sDirAsm ="+\sDirAsm)
            WriteStringN(hFileLog, "PARAM >gProject\sDirObj ="+\sDirObj)
            WriteStringN(hFileLog, "PARAM >gProject\sDirLib ="+\sDirLib)
            WriteStringN(hFileLog, "PARAM >gProject\sDirBat ="+\sDirBat)
            WriteStringN(hFileLog, "PARAM >gProject\sDirLogs ="+\sDirLogs)
            
            WriteStringN(hFileLog, "PARAM >gProject\bUnicode ="+Str(\bUnicode))
            WriteStringN(hFileLog, "PARAM >gProject\bThreadSafe ="+Str(\bThreadSafe))
            WriteStringN(hFileLog, "PARAM >gProject\bInlineASM ="+Str(\bInlineASM))
            WriteStringN(hFileLog, "PARAM >gProject\bDontBuildLib ="+Str(\bDontBuildLib))
            WriteStringN(hFileLog, "PARAM >gProject\bDontKeepSrcFiles ="+Str(\bDontKeepSrcFiles))
            WriteStringN(hFileLog, "PARAM >gProject\bLogFile ="+Str(\bLogFile))
            WriteStringN(hFileLog, "PARAM >gProject\bLogInStreaming ="+Str(\bLogInStreaming))
            WriteStringN(hFileLog, "PARAM >gProject\bBatFile ="+Str(\bBatFile))
          EndWith
    
          With gConf
            WriteStringN(hFileLog, "PARAM >gConf\sPureBasic_Path = "+\sPureBasic_Path)
            WriteStringN(hFileLog, "PARAM >gConf\sPath_PBCOMPILER = "+\sPath_PBCOMPILER)
            WriteStringN(hFileLog, "PARAM >gConf\sPath_FASM = "+\sPath_FASM)
            WriteStringN(hFileLog, "PARAM >gConf\sPath_OBJ2LIB = "+\sPath_OBJ2LIB)
            WriteStringN(hFileLog, "PARAM >gConf\sPath_PBLIBMAKER = "+\sPath_PBLIBMAKER)
            WriteStringN(hFileLog, "PARAM >gConf\sSourceDir = "+\sSourceDir)
            
            WriteStringN(hFileLog, "PARAM >gConf\sIni_Purebasic = "+\sIni_Purebasic)
            WriteStringN(hFileLog, "PARAM >gConf\sIni_Project = "+\sIni_Project)
          EndWith
        ElseIf gProject\bTypeOutput = #TypeOutput_Resident
          With gProject
            WriteStringN(hFileLog, "PARAM >gProject\sFileName ="+\sFileName)
            WriteStringN(hFileLog, "PARAM >gProject\sFileOutput ="+\sFileOutput)
            WriteStringN(hFileLog, "PARAM >gProject\sFileLog ="+\sFileLog)
            
            WriteStringN(hFileLog, "PARAM >gProject\sLibName ="+\sLibName)
            
            WriteStringN(hFileLog, "PARAM >gProject\sDirProject ="+\sDirProject)
            WriteStringN(hFileLog, "PARAM >gProject\sDirLogs ="+\sDirLogs)
            
            WriteStringN(hFileLog, "PARAM >gProject\bUnicode ="+Str(\bUnicode))
            WriteStringN(hFileLog, "PARAM >gProject\bLogFile ="+Str(\bLogFile))
          EndWith
    
          With gConf
            WriteStringN(hFileLog, "PARAM >gConf\sPureBasic_Path = "+\sPureBasic_Path)
            WriteStringN(hFileLog, "PARAM >gConf\sPath_PBCOMPILER = "+\sPath_PBCOMPILER)
    
            WriteStringN(hFileLog, "PARAM >gConf\sIni_Purebasic = "+\sIni_Purebasic)
            WriteStringN(hFileLog, "PARAM >gConf\sIni_Project = "+\sIni_Project)
          EndWith
        EndIf
        WriteStringN(hFileLog, "")
      EndIf
    Else
      ClearList(LL_Logs())
    EndIf
  EndIf
  ; Batch
  If gProject\bBatFile = #True
    hFileBatch = OpenFile(#PB_Any, gProject\sDirProject+"BAT"+#System_Separator+"Script"+#System_ExtBatch)
  EndIf
EndProcedure
;@desc Close batch & log files
ProcedureDLL Output_End()
  ; Log
  If gProject\bLogFile = #True
    Protected sTimeStart.s = "TIME > Start    > " + FormatDate("%hh:%ii:%ss", lTimeStart)
    Protected sTimeEnd.s = "TIME > End      > " + FormatDate("%hh:%ii:%ss", Date())
    Protected sTimeDuration.s = "TIME > Duration > " + Str(Date() - lTimeStart)+"s"
    If gProject\bLogInStreaming = #False
      If hFileLog
        WriteStringN(hFileLog, sTimeStart)
        WriteStringN(hFileLog, sTimeEnd)
        WriteStringN(hFileLog, sTimeDuration)
        CloseFile(hFileLog)
      EndIf
    Else
      hFileLog = OpenFile(#PB_Any, gProject\sFileLog)
      If hFileLog
        ForEach LL_Logs()
          WriteStringN(hFileLog, LL_Logs())
        Next
        WriteStringN(hFileLog, sTimeStart)
        WriteStringN(hFileLog, sTimeEnd)
        WriteStringN(hFileLog, sTimeDuration)
        CloseFile(hFileLog)
      EndIf
    EndIf
    CompilerIf #PB_Compiler_Debugger = #True
      Debug sTimeStart
      Debug sTimeEnd
      Debug sTimeDuration
    CompilerEndIf
  EndIf
  ; Batch
  If gProject\bBatFile = #True
    If hFileBatch
      CloseFile(hFileBatch)
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux : RunProgram("chmod", "+x Script"+#System_ExtBatch, gProject\sDirBat)
      CompilerEndSelect
    EndIf
  EndIf
EndProcedure
;@desc Add content to batch or/and log files
ProcedureDLL Output_Add(sContent.s, lFlags.l, lNumTabs.l = 0)
  CreateMutex()
  Protected sLogContent.s = FormatDate("%hh:%ii:%ss", Date())+"  "+Space(lNumTabs) + sContent
  Protected sBatContent.s = sContent
  ; Log
  If gProject\bLogFile = #True
    If lFlags & #Output_Log
      If gProject\bLogInStreaming = #False
        If hFileLog
          WriteStringN(hFileLog, sLogContent)
        EndIf
        CompilerIf #PB_Compiler_Debugger = #True
          Debug "LOG > "+sLogContent
        CompilerEndIf
      Else
        LastElement(LL_Logs())
        If AddElement(LL_Logs())
          LL_Logs() = sLogContent
        EndIf
      EndIf
    EndIf
  EndIf
  ; Log InApp
  CompilerIf #PB_Compiler_Version > 440
    CompilerIf Defined(Moebius_App, #PB_Constant) = #True
      If bEnableLogEditor = #True
        If gProject\bTypeOutput = #TypeOutput_Resident
          If IsGadget(#Editor_00) <> 0
            AddGadgetItem(#Editor_00, -1, sLogContent)
          EndIf
        ElseIf gProject\bTypeOutput = #TypeOutput_UserLib
          If IsGadget(#Editor_01) <> 0
            AddGadgetItem(#Editor_01, -1, sLogContent)
          EndIf
        EndIf
      EndIf
    CompilerEndIf
  CompilerEndIf
  ; Batch
  If gProject\bBatFile = #True
    If lFlags & #Output_Bat
      If hFileBatch
        WriteStringN(hFileBatch, sBatContent)
        CompilerIf #PB_Compiler_Debugger = #True
          Debug "BATCH > "+sBatContent
        CompilerEndIf
      EndIf
    EndIf
  EndIf
EndProcedure
;@author Gnozal
ProcedureDLL.s PeekLine(*BufMem = 0, BufLen = 0)
  Protected *ptrChar.Character, *ptrStr.Character, *ptrEof
  Protected lLength.l
  Protected cChar.c, cCharBis.c
  Static MemOffset, MemLen, *MemBuf
  Static bSystem.b
  If *BufMem And BufLen
    *MemBuf = *BufMem
    MemLen = BufLen
    MemOffset = 0
  EndIf
  If *MemBuf And MemLen
    *ptrChar = *MemBuf + MemOffset
    *ptrEof = *MemBuf + MemLen
    *ptrStr = *ptrChar
    If MemOffset < MemLen
      While *ptrChar< *ptrEof
        cChar = *ptrChar\c
        *ptrChar = *ptrChar + SizeOf(Character)
        If cChar = 13
          Break
        EndIf
        If cChar = 10
          Break
        EndIf
        lLength + 1             
      Wend
      If *ptrChar < *ptrEof
        cCharBis = *ptrChar\c
        If cCharBis + cChar = 23
          *ptrChar = *ptrChar + SizeOf(Character)
        EndIf
      EndIf
      MemOffset = *ptrChar - *MemBuf
      ProcedureReturn PeekS(*ptrStr, lLength)
    Else
      ProcedureReturn Chr(1)
    EndIf
  Else
    ProcedureReturn Chr(1)
  EndIf
EndProcedure 
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.l sbCreate(BlockSize.l)
  Protected *sbClass.S_StringBuilder
  *sbClass = AllocateMemory(SizeOf(S_StringBuilder))
  If *sbClass\InitDone
    If *sbClass\pString
      FreeMemory(*sbClass\pString)
    EndIf
  EndIf
  ; If the stringbuilder is already initialized, free the memory of the string.
  ; BlockSize min. 1024 ($400) Byte
  If BlockSize < $400
    BlockSize = $400
  EndIf
  ; BlockSize max. 1 MByte ($100000) Byte
  If BlockSize > $100000
    BlockSize = $100000
  EndIf
  If BlockSize <> (BlockSize & $FC00)
    BlockSize = (BlockSize & $FC00) + 1024
  EndIf
  *sbClass\BlockSize = BlockSize
  *sbClass\StringSize = 0
  If BlockSize > 0
    *sbClass\pString = AllocateMemory(BlockSize)
  EndIf
  ; Allocate the memory needed for our string
  If *sbClass\pString <> 0
    ; Allocation went fine, let the structure know we initialized everything fine.
    *sbClass\InitDone = #True
    *sbClass\MemSize = *sbClass\BlockSize
    ; Set our memory size used to the size of the block.
  Else
    ; Problem with allocation - let it know we did not initialize
    *sbClass\InitDone = #False
    *sbClass\MemSize = 0
  EndIf
  ProcedureReturn *sbClass
  ; Return the pointer to our new stringbuilder class.
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbClear(*inSBClass.S_StringBuilder)
  If *inSBClass\InitDone
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = 0
    *inSBClass\StringSize = 0
    *inSBClass\BlockSize = 0
    *inSBClass\InitDone = #False
    *inSBClass\MemSize = 0
  EndIf
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbDestroy(*inSBClass.S_StringBuilder)
  If *inSBClass\InitDone
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = 0
    *inSBClass\StringSize = 0
    *inSBClass\BlockSize = 0
    *inSBClass\InitDone = #False
    *inSBClass\MemSize = 0
  EndIf
  If *inSBClass
    FreeMemory(*inSBClass)
  EndIf
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbAdd(*inSBClass.S_StringBuilder, inString.l)
  Protected StrLen.l
  Protected pNewString.l
  Protected NewMemSize.l
  Protected NewStringSize.l
  StrLen = MemoryStringLength(inString)
  NewStringSize = StrLen + *inSBClass\StringSize
  If NewStringSize + 1 > *inSBClass\MemSize
    NewMemSize = *inSBClass\MemSize + *inSBClass\BlockSize
    pNewString = AllocateMemory(NewMemSize)
    If pNewString = 0
      ProcedureReturn #False
    EndIf
    CopyMemory(*inSBClass\pString, pNewString, *inSBClass\StringSize)
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = pNewString
    *inSBClass\MemSize = NewMemSize
  EndIf
  CopyMemory(inString, *inSBClass\pString + *inSBClass\StringSize, StrLen)
  *inSBClass\StringSize = NewStringSize
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbAddLiteral(*inSBClass.S_StringBuilder, inString.s)
  Protected sAddress.l, StrLen.l, pNewString.l, NewMemSize.l, NewStringSize.l
  sAddress = @inString
  StrLen = MemoryStringLength(sAddress)
  NewStringSize = StrLen + *inSBClass\StringSize
  If (NewStringSize + 1) > *inSBClass\MemSize
    NewMemSize = *inSBClass\MemSize + *inSBClass\BlockSize
    pNewString = AllocateMemory(NewMemSize)
    If pNewString = 0
      ProcedureReturn #False
    EndIf
    CopyMemory(*inSBClass\pString, pNewString, *inSBClass\StringSize)
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = pNewString
    *inSBClass\MemSize = NewMemSize
  EndIf
  CopyMemory(sAddress, *inSBClass\pString + *inSBClass\StringSize, StrLen)
  *inSBClass\StringSize = NewStringSize
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.s sbGetString(*inSBClass.S_StringBuilder)
  Protected WholeString.s = PeekS(*inSBClass\pString)
  ProcedureReturn WholeString
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.s sbGetStringAndDestroy(*inSBClass.S_StringBuilder)
  Protected WholeString.s = PeekS(*inSBClass\pString)
  sbDestroy(*inSBClass)
  ProcedureReturn WholeString
EndProcedure
;@author Xombie
;@link http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.l sbLength(*inSBClass.S_StringBuilder)
  Protected iLength.l
  iLength = *inSBClass\StringSize
  ProcedureReturn iLength
EndProcedure 
;@author : Dobro
;@link : http://www.purebasic.fr/french/viewtopic.php?t=9395
ProcedureDLL.s StrRreplace(String.s, StrSearched.s, StrReplaced.s)
  Static sPart1.s
  Static lPos.l
  Protected sPart2.s, sPart3.s, sText.s
  
  If lPos = Len(String)
    sText = sPart1
    lPos = 0 
    sPart1 = ""
    ProcedureReturn sText
  ElseIf lPos = Len(string) - Len(StrSearched)
    If Right(String, Len(StrSearched)) = StrSearched
      String = Left(String, Len(string) - Len(StrSearched)) + StrReplaced
    EndIf
  EndIf
  
  lPos = lPos+1
  sPart1 = sPart1 + Mid(String, lPos, 1)
  sPart2 = Mid(String, lPos, Len(StrSearched))
  sPart3 = Mid(String, lPos, Len(StrSearched) + 1)
  If sPart3=StrSearched+"(" Or sPart3=StrSearched+" " Or sPart3=StrSearched+"," Or sPart3=StrSearched+"." Or sPart3=StrSearched+Chr(13) Or sPart3=StrSearched+Chr(10) Or sPart3=StrSearched+";" Or sPart3=StrSearched+"]"
    sPart1 = Left(sPart1, Len(sPart1) - 1)
    sPart1 = sPart1 + StrReplaced
    lPos = lPos + Len(StrSearched) - 1
  EndIf 
  sText = StrRreplace(String,StrSearched,StrReplaced)
  ProcedureReturn sText
EndProcedure 

