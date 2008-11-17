Global gConf_PureBasic_Path.s = #PB_Compiler_Home
Global gConf_Path_PBCOMPILER.s = #PB_Compiler_Home+"compilers\pbcompiler.exe"
Global gConf_Path_FASM.s = #PB_Compiler_Home+"compilers\fasm.exe"
Global gConf_Path_OBJ2LIB.s = #PB_Compiler_Home+"compilers\polib.exe"
Global gConf_Path_PBLIBMAKER.s = #PB_Compiler_Home+"Library SDK\LibraryMaker.exe"

gProject\Name = "Samples00Windows"
gProject\FileName = "C:\ZPersoSpace\Proj_Moebius\Lib_Source\Sample_00.pb"
;gProject\FileName = "K:\Proj_Moebius\Lib_Source\Sample_00.pb"

;Global gConf_ProjectDir.s = "K:\Proj_Moebius\Lib_Source\"+gProject\Name+"\"
Global gConf_ProjectDir.s = "C:\ZPersoSpace\Proj_Moebius\Lib_Source\"+gProject\Name+"\"
;Global gConf_SourceDir.s = "K:\Proj_Moebius\Lib_Source\"
Global gConf_SourceDir.s = "C:\ZPersoSpace\Proj_Moebius\Lib_Source\"

#Switch_Commented = "/COMMENTED"
#Switch_Unicode = "/UNICODE"
#Switch_ThreadSafe = "/THREAD"
#Switch_InlineASM = "/INLINEASM"
#Switch_Executable = "/EXE"

#System_ExtExec = ".exe"
#System_ExtObj = ".obj"
#System_Separator = "\"
#System_EOL = Chr(13)+Chr(10)

; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 8
; Folding = -
; EnableXP