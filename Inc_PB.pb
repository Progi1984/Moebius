;@desc Extracts all informations from userlibs
ProcedureDLL PB_GetInfoUserLib(LibFileName.s)
  Protected LibName.s = GetFilePart(LibFileName)
  Protected LibSize.l, hDLL.l, hPL.l, IncA.l, lTest.l
  Protected *MemLib_Header, *MemLib_Footer
  Protected DLLName.s, PLName.s
  Protected *MemSeeker.S_Seeker
  Protected Arging.b
  If ReadFile(0, LibFileName)
    LibSize = Lof(0)
    *MemLib_Header = AllocateMemory(LibSize)
    If *MemLib_Header
      ReadData(0,*MemLib_Header, LibSize)
      CloseFile(0)
    EndIf
    *MemLib_Footer = *MemLib_Header+LibSize
    *MemSeeker = *MemLib_Header
    If *MemSeeker\l='PURE' And PeekL(*MemSeeker+8)='LIB3' And PeekL(*MemSeeker+16)='3BIL'
      *MemSeeker = *MemLib_Header+20
      While *MemSeeker\b<>0:*MemSeeker+1:Wend
      *MemSeeker+2
      If *MemSeeker>=*MemLib_Footer:ProcedureReturn:EndIf
      
      hDLL = *MemSeeker\b
      If hDLL
        For IncA=1 To hDLL
          *MemSeeker+1
          DLLName+", "+PeekS(*MemSeeker)
          *MemSeeker+Len(PeekS(*MemSeeker))
        Next IncA
        DLLName = Right(DLLName, Len(DLLName)-2)
        *MemSeeker+1
      EndIf
      *MemSeeker+1
      While *MemSeeker\b<>0:*MemSeeker+1:Wend
      *MemSeeker+1
      If *MemSeeker>=*MemLib_Footer:ProcedureReturn:EndIf
      
      hPL = *MemSeeker\b
      If hPL
        For IncA=1 To hPL
          *MemSeeker+1
          PLName+", "+PeekS(*MemSeeker)
          *MemSeeker+Len(PeekS(*MemSeeker))
        Next IncA
        PLName = Right(PLName, Len(PLName)-2)
      EndIf
      *MemSeeker+1
      If *MemSeeker>=*MemLib_Footer:ProcedureReturn:EndIf
      
      While PeekL(*MemSeeker)<>'PURE' And PeekL(*MemSeeker+8)<>'DAT1'
        lTest = AddElement(LL_PBFunctions())
        If lTest
          LL_PBFunctions()\FuncName = PeekS(*MemSeeker)
          
          *MemSeeker+Len(LL_PBFunctions()\FuncName)+1
          *MemSeeker+*MemSeeker\b+5
          While *MemSeeker\b=0:*MemSeeker+1:Wend
          
          LL_PBFunctions()\Params = ""
          LL_PBFunctions()\FuncDesc = ""
          LL_PBFunctions()\LibContaining = LibName
          If *MemSeeker\b='('
            Arging = #True
            While *MemSeeker\b<>0
              If *MemSeeker\b='-'
                Arging = #False
              EndIf
              If Arging
                LL_PBFunctions()\Params+Chr(*MemSeeker\b)
              Else
                LL_PBFunctions()\FuncDesc+Chr(*MemSeeker\b)
              EndIf
              *MemSeeker+1
            Wend
            LL_PBFunctions()\Params = LTrim(RTrim(LL_PBFunctions()\Params))
            LL_PBFunctions()\FuncDesc = LTrim(RTrim(RemoveString(LL_PBFunctions()\FuncDesc, "- ")))
            *MemSeeker+1
          EndIf
        EndIf
      Wend
    EndIf
    If *MemLib_Header
      FreeMemory(*MemLib_Header)
    EndIf
  EndIf
EndProcedure
;@desc Extracts function names and libs which are containing them
ProcedureDLL PB_GetInfoLib(FileName.s)
  Protected LibName.s = GetFilePart(FileName)
  Protected hFile = ReadFile(#PB_Any, FileName)
  Protected Ndx.l
  Protected Filesize.q = FileSize(FileName)
  If hFile
    If Filesize>0
      Ndx = 2
      While ((Ndx>0) And ((Loc(hFile) + 1)<Lof(hFile)))
        If ReadByte(hFile) = 0
          Ndx-1
        EndIf
      Wend
      If (Loc(hFile)<(Lof(hFile)-2))
        FileSeek(hFile, Loc(hFile) + 2)
      EndIf
      While Eof(hFile) = 0
      If AddElement(LL_PBFunctions())
        LL_PBFunctions()\FuncName = ReadString(hFile)
        LL_PBFunctions()\LibContaining = LibName
        If (Loc(hFile)<(Lof(hFile)-2))
          FileSeek(hFile, Loc(hFile) + 2)
        Else ; erreur
          CloseFile(hFile)
          ProcedureReturn -1  ; erreur sur le déplacement dans le fichier
        EndIf
      Else ; erreur
        CloseFile(hFile)
        ProcedureReturn -1  ; erreur sur le déplacement dans le fichier
      EndIf
    Wend
    CloseFile(hFile)
  Else
    CloseFile(hFile)
    ProcedureReturn -1  ; erreur sur le fichier (taille ou inexsistant)
  EndIf
  Else
    ProcedureReturn -1  ; erreur sur l'ouverture du fichier
  EndIf
EndProcedure
;@desc List all functions contained in purelibraries & {System}Libraries
ProcedureDLL.s PB_GetLibFromFunctionName(Function.s)
  Protected sTrFunction.s, sLibContaining.s
  Protected qIndEnd.q, qIndStart.q, qIndMid.q
  Protected lCompare.l
  Protected sValue.s
  Protected bFound.b

  sTrFunction = LCase(Trim(Function))
  If Left(sTrFunction, 1) = "_"
    sTrFunction = Right(sTrFunction, Len(sTrFunction) - 1)
  EndIf
  If FindString(sTrFunction, "@", 1) > 0
    sTrFunction = StringField(sTrFunction, 1, "@")
  EndIf
  If Right(sTrFunction, 1) =  "a"
    sTrFunction = Left(sTrFunction, Len(sTrFunction) - 1)
  EndIf
  ResetList(LL_PBFunctions())
  bFound = #False
  qIndStart = 0
  qIndEnd = ListSize(LL_PBFunctions()) -1
  If qIndEnd >= 0
    While qIndStart <= qIndEnd
      qIndMid = (qIndStart + qIndEnd +1) >>1
      SelectElement(LL_PBFunctions(), qIndMid)
      sValue = LL_PBFunctions()\FuncName
      lCompare = CompareMemoryString(@sValue, @sTrFunction, #PB_String_NoCase)
      If lCompare = 0
        bFound = #True
        sLibContaining = LL_PBFunctions()\LibContaining
        qIndStart = qIndEnd + 1
      ElseIf lCompare > 0
        qIndEnd = qIndMid -1
      ElseIf lCompare < 0
        qIndStart = qIndMid +1
      EndIf
    Wend
  EndIf
  If bFound = #True
    ProcedureReturn sLibContaining
  EndIf
  ;ProcedureReturn sLibContaining
EndProcedure
;@desc Create Functions List from Pure & User Libraries
ProcedureDLL PB_CreateFunctionsList()
  Protected NextDir.l, lTest.l
  Protected NameOfLib.s, LibFileName.s
  If ListSize(LL_PBFunctions()) = 0
    ; List all functions contained in purelibraries
    If ExamineDirectory(0, gConf\sPureBasic_Path+"purelibraries"+#System_Separator, "")
      NextDir = NextDirectoryEntry(0)
      Repeat
        NameOfLib = DirectoryEntryName(0)
        LibFileName = gConf\sPureBasic_Path+"purelibraries"+#System_Separator+NameOfLib
        PB_GetInfoUserLib(LibFileName)
        NextDir = NextDirectoryEntry(0)
      Until NextDir = #False
    EndIf
    
    ; List all functions contained in {System}Libraries
    lTest = ExamineDirectory(0, gConf\sPureBasic_Path+"purelibraries"+#System_Separator+LCase(#System_OS)+#System_Separator, "")
    If lTest
      NextDir = NextDirectoryEntry(0)
      Repeat
        NameOfLib = DirectoryEntryName(0)
        LibFileName = gConf\sPureBasic_Path+"purelibraries"+#System_Separator+LCase(#System_OS)+#System_Separator+NameOfLib
        PB_GetInfoLib(LibFileName)
        NextDir = NextDirectoryEntry(0)
      Until NextDir = #False
    EndIf
    
    ; List all functions contained in PureLibraries\UserLibrairies
    If ExamineDirectory(0, gConf\sPureBasic_Path+"purelibraries"+#System_Separator+"userlibraries"+#System_Separator, "")
      NextDir = NextDirectoryEntry(0)
      Repeat
        NameOfLib = DirectoryEntryName(0)
        LibFileName = gConf\sPureBasic_Path+"purelibraries"+#System_Separator+"userlibraries"+#System_Separator+NameOfLib
        PB_GetInfoUserLib(LibFileName)
        NextDir = NextDirectoryEntry(0)
      Until NextDir = #False
    EndIf
    
    SortList(LL_PBFunctions(), #PB_Sort_Ascending | #PB_Sort_NoCase)
  EndIf
EndProcedure
;@desc Retrieves Purebasic folder [empty string if not installed]
;@return Purebasic Path
ProcedureDLL.s PB_GetPBFolder()
  Protected psPBFolder.s
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
    CompilerCase #PB_OS_MacOS  ;{
      Protected hCompiler.l
      hCompiler = RunProgram("which", "pbcompiler ", "", #PB_Program_Open|#PB_Program_Read)
      If hCompiler
        While ProgramRunning(hCompiler)
          psPBFolder + ReadProgramString(hCompiler) + Chr(13)
        Wend
        CloseProgram(hCompiler)
      Else
        psPBFolder = ""
      EndIf
      If psPBFolder = "" 
        If GetEnvironmentVariable ( "PUREBASIC_HOME" ) <> ""
          psPBFolder = GetEnvironmentVariable ( "PUREBASIC_HOME" )
          If Right(psPBFolder, 1) <> #System_Separator
            psPBFolder + #System_Separator
          EndIf
        EndIf
      Else
        psPBFolder = RemoveString(psPBFolder, Chr(13))
        psPBFolder = GetPathPart(psPBFolder)
        psPBFolder = GetPathPart(Left(psPBFolder, Len(psPBFolder) - 1))
        If Right(psPBFolder, 1) <> #System_Separator
            psPBFolder + #System_Separator
        EndIf
      EndIf
      ProcedureReturn PBFolder
    ;}
    CompilerCase #PB_OS_Windows ;{
      Protected hKey1.l, Type.l, Res.l, lpbData.l, cbData.l, WindowsVersion.l
      cbData = (#MAX_PATH * 2) + 2
      lpbData = AllocateMemory(cbData)
      hKey1=0
      Type=0
      Res=-1
      Select OSVersion()
        Case #PB_OS_Windows_95, #PB_OS_Windows_98, #PB_OS_Windows_ME;{
          Res=RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, "Software\Classes\PureBasic.exe\shell\open\command", 0, #KEY_ALL_ACCESS, @hKey1)
        ;}
        Case #PB_OS_Windows_NT3_51, #PB_OS_Windows_NT_4, #PB_OS_Windows_2000, #PB_OS_Windows_XP, #PB_OS_Windows_Server_2003;{
          Res=RegOpenKeyEx_(#HKEY_CLASSES_ROOT, "Applications\PureBasic.exe\shell\open\command", 0, #KEY_ALL_ACCESS, @hKey1)
        ;}
        Default;{ Win Vista / Server 2008
          Res=RegOpenKeyEx_(#HKEY_CURRENT_USER, "Software\Classes\PureBasic.exe\shell\open\command", 0, #KEY_ALL_ACCESS , @hKey1)
        ;}
      EndSelect
      If Res = #ERROR_SUCCESS And hKey1
        If RegQueryValueEx_(hKey1, "", 0, @Type, lpbData, @cbData)=#ERROR_SUCCESS
          psPBFolder = PeekS(lpbData)
          psPBFolder = GetPathPart(StringField(psPBFolder,2,Chr(34)))
        EndIf
        RegCloseKey_(hKey1)
      EndIf
      If lpbData
        FreeMemory(lpbData)
        lpbData=0
      EndIf
      If psPBFolder = ""
        If GetEnvironmentVariable ( "PUREBASIC_HOME" ) <> ""
          psPBFolder = GetEnvironmentVariable ( "PUREBASIC_HOME" )
          If Right(psPBFolder, 1) <> #System_Separator
            psPBFolder + #System_Separator
          EndIf
        EndIf
      EndIf
      ProcedureReturn psPBFolder
    ;}
  CompilerEndSelect
EndProcedure
;@desc Connects to PBCompiler for restarting the compiler
ProcedureDLL PB_Connect()
  Protected ReponseComp.s
  hCompiler = RunProgram(gConf\sPath_PBCOMPILER, #Switch_StandBy, "", #PB_Program_Open|#PB_Program_Read|#PB_Program_Write|#PB_Program_Hide)
  If hCompiler = 0
    ProcedureReturn #False
  Else
    While ProgramRunning(hCompiler)
      If AvailableProgramOutput(hCompiler)
        ReponseComp = ReadProgramString(hCompiler)
        If ReponseComp = "READY"
          ProcedureReturn #True
        EndIf
      EndIf
    Wend
  EndIf
EndProcedure
;@desc Disconnects to PBCompiler for restarting the compiler
ProcedureDLL PB_DisConnect()
  WriteProgramStringN(hCompiler, "END")
  CloseProgram(hCompiler)
  ProcedureReturn #True
EndProcedure
