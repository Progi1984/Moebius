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
  Global hFileLog = OpenFile(#PB_Any, gConf_ProjectDir+"LOGS"+#System_Separator+"Log_"+FormatDate("%yyyy_%mm_%dd_%hh_%ii_%ss", Date())+".log")
EndProcedure
ProcedureDLL Log_Add(Content.s, NumTab.l = 0)
  If hFileLog
    WriteStringN(hFileLog, Space(NumTab) + Content)
  EndIf
  CompilerIf #PB_Compiler_Debugger = #True
    Debug Space(NumTab) + Content
  CompilerEndIf
EndProcedure
ProcedureDLL Log_End()
  If hFileLog
    CloseFile(hFileLog)
  EndIf
EndProcedure
ProcedureDLL Batch_Init()
  Global hFileBatch = OpenFile(#PB_Any, gConf_ProjectDir+"BAT"+#System_Separator+"Script"+#System_ExtBatch)
EndProcedure
ProcedureDLL Batch_Add(Content.s)
  If hFileBatch
    WriteStringN(hFileBatch, Content)
  EndIf
  CompilerIf #PB_Compiler_Debugger = #True
    Debug "BATCH > "+Content
  CompilerEndIf
EndProcedure
ProcedureDLL Batch_End()
  If hFileBatch
    CloseFile(hFileBatch)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux : RunProgram("chmod", "+x "+"Script"+#System_ExtBatch,gConf_ProjectDir+"BAT"+#System_Separator)
    CompilerEndSelect
  EndIf
EndProcedure