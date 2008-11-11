Procedure PB_GetInfoUserLib(LibFileName.s)
  Protected LibName.s = GetFilePart(LibFileName)
  Protected LibSize.l, hDLL.l, hPL.l, IncA.l
  Protected *MemLib_Header, *MemLib_Footer
  Protected DLLName.s, PLName.s
  Protected *MemSeeker.S_Seeker
  Protected Arging.b
  If ReadFile(0, LibFileName)
    LibSize = Lof(0)
    *MemLib_Header = AllocateMemory(LibSize)
    ReadData(0,*MemLib_Header, LibSize)
    CloseFile(0)
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
        AddElement(LL_PBFunctions())
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
      Wend
    EndIf
    FreeMemory(*MemLib_Header)
  EndIf
EndProcedure
Procedure PB_GetInfoLib(FileName.s)
  Protected LibName.s = GetFilePart(FileName)
  Protected hFile = ReadFile(#PB_Any, FileName)
  Protected Ndx.l
  If hFile
    Ndx = 2
    While Ndx > 0
      If ReadByte(hFile) = 0
        Ndx - 1
      EndIf
    Wend
    
    FileSeek(hFile,Loc(hFile)+2)
    
    While Eof(hFile) = 0
      AddElement(LL_PBFunctions())
      LL_PBFunctions()\FuncName = ReadString(hFile)
      LL_PBFunctions()\LibContaining = LibName
      FileSeek(hFile,Loc(hFile)+2)
    Wend
    
    CloseFile(hFile)
  EndIf
EndProcedure

; @desc : List all functions contained in purelibraries & {System}Libraries
Procedure.s PB_ListFunctions(Function.s)
  Protected NextDir.l, NameOfLib.s, LibFileName.s
  Function.s = LCase(Trim(Function))
  If CountList(LL_PBFunctions()) = 0
  
    ; List all functions contained in purelibraries
    ExamineDirectory(0, #PureBasic_Path+"purelibraries"+#System_Separator, "")
    NextDir = NextDirectoryEntry(0)
    Repeat
      NameOfLib = DirectoryEntryName(0)
      LibFileName = #PureBasic_Path+"purelibraries"+#System_Separator+NameOfLib
      PB_GetInfoUserLib(LibFileName)
      NextDir = NextDirectoryEntry(0)
    Until NextDir = #False
    
    ; List all functions contained in {System}Libraries
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux : ExamineDirectory(0, #PureBasic_Path+"purelibraries/linux/", "")
      CompilerCase #PB_OS_Windows : ExamineDirectory(0, #PureBasic_Path+"purelibraries\windows\", "")
    CompilerEndSelect
    NextDir = NextDirectoryEntry(0)
    Repeat
      NameOfLib = DirectoryEntryName(0)
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux : LibFileName = #PureBasic_Path+"purelibraries/linux/"+NameOfLib
        CompilerCase #PB_OS_Windows : LibFileName = #PureBasic_Path+"purelibraries\windows\"+NameOfLib
      CompilerEndSelect
      PB_GetInfoLib(LibFileName)
      NextDir = NextDirectoryEntry(0)
    Until NextDir = #False

    ; List all functions contained in PureLibraries
;     ExamineDirectory(0, #PureBasic_Path+"purelibraries"+#System_Separator+"userlibraries"+#System_Separator, "")
;     NextDir = NextDirectoryEntry(0)
;     Repeat
;       NameOfLib = DirectoryEntryName(0)
;       LibFileName = #PureBasic_Path+"purelibraries"+#System_Separator+"userlibraries"+#System_Separator+NameOfLib
;       GetUserLibInfo(LibFileName)
;       NextDir = NextDirectoryEntry(0)
;     Until NextDir = #False
  EndIf
  
  ForEach LL_PBFunctions()
    If LCase(LL_PBFunctions()\FuncName) = Function
      ProcedureReturn LL_PBFunctions()\LibContaining
    EndIf
  Next
EndProcedure

; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 154
; Folding = +-tc-
; EnableXP
; UseMainFile = Moebius_Main.pb