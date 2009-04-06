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
;@returnvalue 1 if the creation of the directory has a success
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
;@returnvalue #True if it's a numeric, else #False
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
      WriteStringN(hFileLog, "PARAM >gProject\sFileName ="+gProject\sFileName)
      WriteStringN(hFileLog, "PARAM >gProject\sFileDesc ="+gProject\sFileDesc)
      WriteStringN(hFileLog, "PARAM >gProject\sFileCHM ="+gProject\sFileCHM)
      WriteStringN(hFileLog, "PARAM >gProject\sFileOutput ="+gProject\sFileOutput)
      WriteStringN(hFileLog, "PARAM >gProject\sFileLog ="+gProject\sFileLog)
      
      WriteStringN(hFileLog, "PARAM >gProject\sLibName ="+gProject\sLibName)
      WriteStringN(hFileLog, "PARAM >gProject\sSubsystem ="+gProject\sSubsystem)
      
      WriteStringN(hFileLog, "PARAM >gProject\sDirProject ="+gProject\sDirProject)
      WriteStringN(hFileLog, "PARAM >gProject\sDirAsm ="+gProject\sDirAsm)
      WriteStringN(hFileLog, "PARAM >gProject\sDirObj ="+gProject\sDirObj)
      WriteStringN(hFileLog, "PARAM >gProject\sDirLib ="+gProject\sDirLib)
      WriteStringN(hFileLog, "PARAM >gProject\sDirBat ="+gProject\sDirBat)
      WriteStringN(hFileLog, "PARAM >gProject\sDirLogs ="+gProject\sDirLogs)
      
      WriteStringN(hFileLog, "PARAM >gProject\bUnicode ="+Str(gProject\bUnicode))
      WriteStringN(hFileLog, "PARAM >gProject\bThreadSafe ="+Str(gProject\bThreadSafe))
      WriteStringN(hFileLog, "PARAM >gProject\bDontBuildLib ="+Str(gProject\bDontBuildLib))
      WriteStringN(hFileLog, "PARAM >gProject\bDontKeepSrcFiles ="+Str(gProject\bDontKeepSrcFiles))
      WriteStringN(hFileLog, "PARAM >gProject\bLogFile ="+Str(gProject\bLogFile))
      WriteStringN(hFileLog, "PARAM >gProject\bLogInStreaming ="+Str(gProject\bLogInStreaming))
      WriteStringN(hFileLog, "PARAM >gProject\bBatFile ="+Str(gProject\bBatFile))

      WriteStringN(hFileLog, "PARAM >gConf\sPureBasic_Path = "+gConf\sPureBasic_Path)
      WriteStringN(hFileLog, "PARAM >gConf\sPath_PBCOMPILER = "+gConf\sPath_PBCOMPILER)
      WriteStringN(hFileLog, "PARAM >gConf\sPath_FASM = "+gConf\sPath_FASM)
      WriteStringN(hFileLog, "PARAM >gConf\sPath_OBJ2LIB = "+gConf\sPath_OBJ2LIB)
      WriteStringN(hFileLog, "PARAM >gConf\sPath_PBLIBMAKER = "+gConf\sPath_PBLIBMAKER)
      WriteStringN(hFileLog, "PARAM >gConf\sSourceDir = "+gConf\sSourceDir)
      WriteStringN(hFileLog, "PARAM >gConf\sIni_Purebasic = "+gConf\sIni_Purebasic)
      WriteStringN(hFileLog, "PARAM >gConf\sIni_Project = "+gConf\sIni_Project)

      WriteStringN(hFileLog, "")
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
        CompilerCase #PB_OS_Linux : RunProgram("chmod", "+x "+"Script"+#System_ExtBatch,gProject\sDirBat)
      CompilerEndSelect
    EndIf
  EndIf
EndProcedure
;@desc Add content to batch or/and log files
ProcedureDLL Output_Add(sContent.s, lFlags.l, lNumTabs.l = 0)
  Protected sLogContent.s = FormatDate("%hh:%ii:%ss", Date())+"  "+Space(lNumTabs) + sContent
  Protected sBatContent.s = sContent
  ; Log
  If gProject\bLogFile = #True
    If lFlags & #Output_Log
      If gProject\bLogInStreaming = #False
        If hFileLog
          WriteStringN(hFileLog, sLogContent)
          CompilerIf #PB_Compiler_Debugger = #True
            Debug "LOG > "+sLogContent
          CompilerEndIf
        EndIf
      Else
        LastElement(LL_Logs())
        If AddElement(LL_Logs())
          LL_Logs() = sLogContent
        EndIf
      EndIf
    EndIf
  EndIf
  ; Log InApp
  CompilerIf Defined(Moebius_App, #PB_Constant) = #True
    If bEnableLogEditor = #True
      AddGadgetItem(#Window_0_Editor_0, -1, sLogContent)
    EndIf
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
;@author Ollivier
ProcedureDLL.l LoadStringArray(*Info.S_ReadFile_BuildArrayInfo)
  Protected *SeqBegin
  Protected *SeqEnd
  Protected *TextLine
  Protected *TableEnd
  Protected FileHnd.I
  Protected ExecStatus.I
  Protected SeqSize.q
  
  FileHnd = OpenFile(#PB_Any, *Info\FileName)
  If FileHnd
    ExecStatus | #FileRead_FileOpened
    SeqSize = Lof(FileHnd)
    *SeqBegin = AllocateMemory(SeqSize)
    If *SeqBegin
      ExecStatus | #FileRead_MemAllocated
      *SeqEnd = *SeqBegin + SeqSize - 1
      If ReadData(FileHnd, *SeqBegin, SeqSize)
        ExecStatus | #FileRead_FileLoaded
        CloseFile(FileHnd)
        *Info\SeqBegin = *SeqBegin
        *Info\SeqEnd = *SeqEnd
        If *Info\LineMeanLength = 0
          *Info\LineMeanLength = 10 ; Moyenne par défaut
        EndIf
        *Info\ArrayTableSize = ((*SeqEnd - *SeqBegin) / *Info\LineMeanLength) << 2
        ;Debug *Info\ArrayTableSize
        If *Info\ArrayTableSize < 1 << 8
          *Info\ArrayTableSize = 1 << 8
        EndIf
        ;Debug *Info\ArrayTableSize
        *Info\ArrayTable = AllocateMemory(*Info\ArrayTableSize)
        If *Info\ArrayTable
          ExecStatus | #FileRead_TableCreated
          *TextLine = *Info\ArrayTable
          ! mov eax, 13           
          ! mov edi, [p.p_SeqBegin]
          ! mov ebp, [p.p_SeqEnd]
          ! mov edx, [p.p_TextLine]
          
          ! mov ecx, ebp ; ecx = EndSeq
          ! sub ecx, edi ;     - BeginSeq
          ! inc ecx      ;     + 1
          LoadStringArrayLoop:
          ! mov ebx, edi ; Retient le début de la chaîne
          ! cld          ; Fixe le sens croissant (convention)
          ! repne scasb  ; Recherche le 13
          
          ! mov byte [edi - 1], 0 ; Remplace le 13 par le 0
          ! inc edi      ; Passe le 10
          
          ! mov [edx], ebx ; Copie l'adresse de début de ligne
          ! add edx, 4 ; ... Et passe au pointeur suivant
          
          ! cmp edi, ebp ; Fin de séquence ?
          ! jng l_loadstringarrayloop ; Non, continue
          
          ! mov [p.p_TableEnd], edx
          *Info\ArrayTableEnd = *TableEnd
          *Info\ArrayTableSize = *TableEnd - *TextLine
          ;Debug "***" + Str(*Info\ArrayTableSize)
          *Info\ArrayTable = ReAllocateMemory(*TextLine, *Info\ArrayTableSize)
        EndIf
      EndIf
    EndIf
  EndIf
  *Info\ExecStatus = ExecStatus
EndProcedure
