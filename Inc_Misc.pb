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

ProcedureDLL Log_Init()
  If gProject\bLogFile = #True
    hFileLog = OpenFile(#PB_Any, gProject\sFileLog)
    WriteStringN(hFileLog, "PARAM > gProject\FileName = "+gProject\FileName)
    WriteStringN(hFileLog, "PARAM > gProject\LibName = "+gProject\LibName)
    WriteStringN(hFileLog, "PARAM > gProject\FileAsm = "+gProject\FileAsm)
    WriteStringN(hFileLog, "PARAM > gProject\FileDesc = "+gProject\FileDesc)
    WriteStringN(hFileLog, "PARAM > gProject\DirObj = "+gProject\DirObj)
    WriteStringN(hFileLog, "PARAM > gProject\FileLib = "+gProject\FileLib)
    WriteStringN(hFileLog, "PARAM > gProject\FileCHM = "+gProject\FileCHM)
    WriteStringN(hFileLog, "PARAM > gProject\sFileOutput = "+gProject\sFileOutput)
    WriteStringN(hFileLog, "PARAM > gProject\sSubsystem = "+gProject\sSubsystem)
    WriteStringN(hFileLog, "PARAM > gProject\sFileLog = "+gProject\sFileLog)
    WriteStringN(hFileLog, "PARAM > gProject\bDontBuildLib = "+Str(gProject\bDontBuildLib))
    WriteStringN(hFileLog, "PARAM > gProject\bDontKeepSrcFiles = "+Str(gProject\bDontKeepSrcFiles))
    WriteStringN(hFileLog, "PARAM > gProject\bLogFile = "+Str(gProject\bLogFile))
    WriteStringN(hFileLog, "PARAM > gProject\bUnicode = "+Str(gProject\bUnicode))
    WriteStringN(hFileLog, "PARAM > gProject\bThreadSafe = "+Str(gProject\bThreadSafe))
    WriteStringN(hFileLog, "PARAM > gProject\bBatFile = "+Str(gProject\bBatFile))
    WriteStringN(hFileLog, "PARAM > gConf_SourceDir = "+gConf_SourceDir)
    WriteStringN(hFileLog, "PARAM > gConf_ProjectDir = "+gConf_ProjectDir)
    WriteStringN(hFileLog, "PARAM > gConf_Ini_Purebasic = "+gConf_Ini_Purebasic)
    WriteStringN(hFileLog, "PARAM > gConf_Ini_Project = "+gConf_Ini_Project)
    WriteStringN(hFileLog, "")
  EndIf
EndProcedure
ProcedureDLL Log_Add(Content.s, NumTab.l = 0)
  If gProject\bLogFile = #True
    If hFileLog
      WriteStringN(hFileLog, Space(NumTab) + Content)
    EndIf
    CompilerIf #PB_Compiler_Debugger = #True
      Debug "LOG > "+Space(NumTab) + Content
    CompilerEndIf
  EndIf
  CompilerIf Defined(Moebius_App, #PB_Constant) = #True
    AddGadgetItem(#Editor_0, -1, Space(NumTab) + Content)
  CompilerEndIf
EndProcedure
ProcedureDLL Log_End()
  If gProject\bLogFile = #True
    If hFileLog
      CloseFile(hFileLog)
    EndIf
  EndIf
EndProcedure
ProcedureDLL Batch_Init()
  If gProject\bBatFile = #True
    hFileBatch = OpenFile(#PB_Any, gConf_ProjectDir+"BAT"+#System_Separator+"Script"+#System_ExtBatch)
  EndIf
EndProcedure
ProcedureDLL Batch_Add(Content.s)
  If gProject\bBatFile = #True
    If hFileBatch
      WriteStringN(hFileBatch, Content)
    EndIf
    CompilerIf #PB_Compiler_Debugger = #True
      Debug "BATCH > "+Content
    CompilerEndIf
  EndIf
EndProcedure
ProcedureDLL Batch_End()
  If gProject\bBatFile = #True
    If hFileBatch
      CloseFile(hFileBatch)
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux : RunProgram("chmod", "+x "+"Script"+#System_ExtBatch,gConf_ProjectDir+"BAT"+#System_Separator)
      CompilerEndSelect
    EndIf
  EndIf
EndProcedure
;@desc Permits to know if a string is a numeric
;@returnvalue : #true if it's a numeric, else #false
Procedure.l IsNumeric(String.s)
  Protected Numeric.l, *String.Character
  If String
    Numeric = #True
    *String = @String
    While Numeric And *String\c
      Numeric = IsDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
  ProcedureReturn Numeric
EndProcedure