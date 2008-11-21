EnableExplicit
XIncludeFile "Inc_Var.pb"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  XIncludeFile "Inc_OS_Windows.pb"
CompilerElse
  XIncludeFile "Inc_OS_Linux.pb"
CompilerEndIf
XIncludeFile "Inc_Prefs.pb"
XIncludeFile "Inc_PB.pb"
XIncludeFile "Moebius_MainThread.pb"

Moebius_ReadPrefs()

gProject\LibName  = Left(GetFilePart(gProject\FileName), Len(GetFilePart(gProject\FileName)) - Len(GetExtensionPart(gProject\FileName))-1)
gProject\FileAsm  = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
gProject\FileDesc = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName+".desc"      
gProject\DirObj   = gConf_ProjectDir + "OBJ" + #System_Separator
gProject\FileLib  = gConf_ProjectDir + "LIB" + #System_Separator + gProject\LibName + #System_ExtLib
gProject\FileCHM  = gProject\LibName + #System_ExtHelp

;CreateThread(@Moebius_MainThread(),0)
Moebius_MainThread(0)
; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 17
; Folding = -
; Executable = Moebius.exe