EnableExplicit

Declare.s PB_GetPBFolder()
Global Sample.s = "03"

XIncludeFile "Inc_Var.pb" 
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows : XIncludeFile "Inc_OS_Windows.pb"
  CompilerCase #PB_OS_Linux : XIncludeFile "Inc_OS_Linux.pb"
CompilerEndSelect
XIncludeFile "Inc_Misc.pb"
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
; CursorPosition = 26
; FirstLine = 2
; Folding = -
; Executable = Moebius.exe