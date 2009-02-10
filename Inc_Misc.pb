;@author : Le Soldat Inconnu
;@desc : This code permits you to create a directory which parents directories doesn't exist.
;@sample :
; ; I wish create a directory "C:\Program files\truc\bidule"
; ; Only the directory "C:\Program files\" exists
; ; If I use CreateDirectory("C:\Program files\truc\bidule"), that doesn't work because the directory "C:\Program files\truc\" doesn't exist
; ; If I use CreateDirectoryEx("C:\Program files\truc\bidule"), all these directories will be created :
; - C:\Program files\
; - C:\Program files\truc\
; - C:\Program files\truc\bidule
;@returns : 1 if the creation of the directory has a success
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

;@desc Permits to know if a string is a numeric
;@returnvalue : #true if it's a numeric, else #false
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

ProcedureDLL Output_Init()
  ; Log
  If gProject\bLogFile = #True
    hFileLog = OpenFile(#PB_Any, gProject\sFileLog)
    WriteStringN(hFileLog, "PARAM > gProject\sFileName = "+gProject\sFileName)
    WriteStringN(hFileLog, "PARAM > gProject\sLibName = "+gProject\sLibName)
    WriteStringN(hFileLog, "PARAM > gProject\sDirAsm = "+gProject\sDirAsm)
    WriteStringN(hFileLog, "PARAM > gProject\sFileDesc = "+gProject\sFileDesc)
    WriteStringN(hFileLog, "PARAM > gProject\sDirObj = "+gProject\sDirObj)
    WriteStringN(hFileLog, "PARAM > gProject\sDirLib = "+gProject\sDirLib)
    WriteStringN(hFileLog, "PARAM > gProject\sFileCHM = "+gProject\sFileCHM)
    WriteStringN(hFileLog, "PARAM > gProject\sFileOutput = "+gProject\sFileOutput)
    WriteStringN(hFileLog, "PARAM > gProject\sSubsystem = "+gProject\sSubsystem)
    WriteStringN(hFileLog, "PARAM > gProject\sFileLog = "+gProject\sFileLog)
    WriteStringN(hFileLog, "PARAM > gProject\sDirProject = "+gProject\sDirProject)
    WriteStringN(hFileLog, "PARAM > gProject\bDontBuildLib = "+Str(gProject\bDontBuildLib))
    WriteStringN(hFileLog, "PARAM > gProject\bDontKeepSrcFiles = "+Str(gProject\bDontKeepSrcFiles))
    WriteStringN(hFileLog, "PARAM > gProject\bLogFile = "+Str(gProject\bLogFile))
    WriteStringN(hFileLog, "PARAM > gProject\bUnicode = "+Str(gProject\bUnicode))
    WriteStringN(hFileLog, "PARAM > gProject\bThreadSafe = "+Str(gProject\bThreadSafe))
    WriteStringN(hFileLog, "PARAM > gProject\bBatFile = "+Str(gProject\bBatFile))
    WriteStringN(hFileLog, "PARAM > gConf_SourceDir = "+gConf_SourceDir)
    WriteStringN(hFileLog, "PARAM > gConf_Ini_Purebasic = "+gConf_Ini_Purebasic)
    WriteStringN(hFileLog, "PARAM > gConf_Ini_Project = "+gConf_Ini_Project)
    WriteStringN(hFileLog, "")
  EndIf
  ; Batch
  If gProject\bBatFile = #True
    hFileBatch = OpenFile(#PB_Any, gProject\sDirProject+"BAT"+#System_Separator+"Script"+#System_ExtBatch)
  EndIf
EndProcedure
ProcedureDLL Output_End()
  ; Log
  If gProject\bLogFile = #True
    If hFileLog
      CloseFile(hFileLog)
    EndIf
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
ProcedureDLL Output_Add(sContent.s, lFlags.l, lNumTabs.l = 0)
  Protected sLogContent.s = FormatDate("%hh:%ii:%ss", Date())+"  "+Space(lNumTabs) + sContent
  Protected sBatContent.s = sContent
  ; Log
  If gProject\bLogFile = #True
    If lFlags & #Output_Log
      If hFileLog
        WriteStringN(hFileLog, sLogContent)
        CompilerIf #PB_Compiler_Debugger = #True
          Debug "LOG > "+sLogContent
        CompilerEndIf
      EndIf
    EndIf
  EndIf
  ; Log InApp
  CompilerIf Defined(Moebius_App, #PB_Constant) = #True
    If bEnableLogEditor = #True
      AddGadgetItem(#Editor_0, -1, sLogContent)
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
