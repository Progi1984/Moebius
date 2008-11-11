EnableExplicit

XIncludeFile "Inc_Var.pb"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  XIncludeFile "Inc_OS_Windows.pb"
CompilerElse
  XIncludeFile "Inc_OS_Linux.pb"
CompilerEndIf
XIncludeFile "Inc_PB.pb"
XIncludeFile "Moebius_MainThread.pb"

gProject\Name = "Sample_00 Project"
gProject\FileName = "/home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Sample_00.pb"
gProject\LibName = Left(GetFilePart(gProject\FileName),Len(GetFilePart(gProject\FileName))-Len(GetExtensionPart(gProject\FileName))-1)
gProject\FileAsm   = #Work_Dir+"Lib_Source"+#System_Separator+gProject\Name+#System_Separator+"Moebius_"+gProject\LibName+".asm"
gProject\FileDesc  = #Work_Dir+"Lib_Source"+#System_Separator+gProject\Name+#System_Separator+gProject\LibName+".desc"      
gProject\FileO        = #Work_Dir+"Lib_Source"+#System_Separator+gProject\Name+#System_Separator+gProject\LibName+".o"
gProject\FileA        = #Work_Dir+"Lib_Source"+#System_Separator+gProject\Name+#System_Separator+gProject\LibName+".a"
;CreateThread(@Moebius_MainThread(),0)
Moebius_MainThread(0)
; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 12
; Folding = -
; EnableThread
; Executable = Moebius.exe