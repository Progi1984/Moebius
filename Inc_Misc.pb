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
;@desc Returns the error message in function of Error Number
ProcedureDLL.s GetStringError(Error.l)
  Select Error
    Case #Error_000 : ProcedureReturn "Step0 : Success"+Chr(0)
    Case #Error_001 : ProcedureReturn "Step0 : Can't delete userlibs of old projects"
    Case #Error_002 : ProcedureReturn "Step0 : Can't delete the directory ASM of project"
    Case #Error_003 : ProcedureReturn "Step0 : Can't delete the directory BAT of project"
    Case #Error_004 : ProcedureReturn "Step0 : Can't delete the directory LIB of project"
    Case #Error_005 : ProcedureReturn "Step0 : Can't delete the directory OBJ of project"
    Case #Error_006 : ProcedureReturn "Step0 : Can't create the directory of project"
    Case #Error_007 : ProcedureReturn "Step0 : Can't create the directory "+#DQuote+"Project\BAT"+#DQuote
    Case #Error_008 : ProcedureReturn "Step0 : Can't create the directory "+#DQuote+"Project\ASM"+#DQuote
    Case #Error_009 : ProcedureReturn "Step0 : Can't create the directory "+#DQuote+"Project\LOGS"+#DQuote
    Case #Error_010 : ProcedureReturn "Step0 : Can't create the directory "+#DQuote+"Project\LIB"+#DQuote
    Case #Error_011 : ProcedureReturn "Step0 : Can't create the directory "+#DQuote+"Project\OBJ"+#DQuote
    Case #Error_012 : ProcedureReturn "Step1 : Not a PureBasic file"
    Case #Error_013 : ProcedureReturn "Step1 : Program not launched"
    Case #Error_014 : ProcedureReturn "Step1 : Compiler Error"
    Case #Error_015 : ProcedureReturn "Step1 : Compiler Exit Code Error"
    Case #Error_016 : ProcedureReturn "Step2 : Purebasic.asm Not Found"
    Case #Error_017 : ProcedureReturn "Step2 : Can't generate the asm files"
    Case #Error_018 : ProcedureReturn "Step3 : FASM has returned an error"
    Case #Error_019 : ProcedureReturn "Step3 : FASM can't be launched"
    Case #Error_020 : ProcedureReturn "Step4 : Can't create the DESC File"
    Case #Error_021 : ProcedureReturn "Step4 : Can't copy the lib"
    Case #Error_022 : ProcedureReturn "Step4 : Can't create the file ObjList.txt"
    Case #Error_023 : ProcedureReturn "Step4 : polib can't be launched"
    Case #Error_024 : ProcedureReturn "Step4 : the library isn't generated"
    Case #Error_025 : ProcedureReturn "Step5 : LibMaker can't be launched"
    Case #Error_026 : ProcedureReturn "Step5 : The userlib isn't generated"
    Case #Error_027 : ProcedureReturn "Step5 : The userlib can't be renamed"
    Case #Error_028 : ProcedureReturn "Step5 :  PBCompiler can't be restarted"
    Case #Error_029 : ProcedureReturn "Step6 : The directory ASM can't be deleted"
    Case #Error_030 : ProcedureReturn "Step6 : The directory OBJ can't be deleted"
    Case #Error_031 : ProcedureReturn "Step6 : The directory LIB  can't be deleted"
    Case #Error_032 : ProcedureReturn "Step6 : The directory BAT can't be deleted"
    Case #Error_033 : ProcedureReturn "Compilation build !!!"
  EndSelect
EndProcedure