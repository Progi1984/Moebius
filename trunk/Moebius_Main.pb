EnableExplicit
XIncludeFile "Inc_Var.pb"

gProject\Name = "Samples00"
gProject\FileName = "C:\ZPersoSpace\Proj_Moebius\Lib_Source\Sample_00.pb"
;gProject\FileName = "/home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Lib_Source/Sample_00.pb"

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  XIncludeFile "Inc_OS_Windows.pb"
CompilerElse
  XIncludeFile "Inc_OS_Linux.pb"
CompilerEndIf
XIncludeFile "Inc_PB.pb"
XIncludeFile "Moebius_MainThread.pb"

gProject\LibName = Left(GetFilePart(gProject\FileName),Len(GetFilePart(gProject\FileName))-Len(GetExtensionPart(gProject\FileName))-1)
gProject\FileAsm   = gConf_ProjectDir + "ASM" + #System_Separator +"Moebius_" + gProject\LibName + ".asm"
gProject\FileDesc  = gConf_ProjectDir + "DESC" + #System_Separator + gProject\LibName+".desc"      
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  gProject\DirObj      = gConf_ProjectDir + "OBJ"+ #System_Separator
  gProject\FileLib      = gConf_ProjectDir + "LIB"+ #System_Separator + gProject\LibName+".lib"
CompilerElse
  gProject\DirObj      = gConf_ProjectDir + "OBJ"+ #System_Separator
  gProject\FileLib      = gConf_ProjectDir + "LIB"+ #System_Separator + gProject\LibName+".a"
CompilerEndIf
;CreateThread(@Moebius_MainThread(),0)
Moebius_MainThread(0)
; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 4
; Folding = -
; EnableThread
; Executable = Moebius.exe