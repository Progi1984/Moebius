;-#Switch_Commented = ""
;-#Switch_Unicode = ""
;-#Switch_ThreadSafe = ""
;-#Switch_InlineASM = ""
;-#Switch_Executable = ""
;-#Switch_StandBy = ""
;-#Switch_SubSystem = ""

;-#Switch_NoUnicodeWarning = ""

;-#System_ExtExec = ""
;-#System_ExtObj = ""
;-#System_ExtLib = ""
;-#System_ExtHelp = ""
;-#System_ExtBatch = ""

#System_Separator = ":"
#System_EOL = Chr(13)
;-#System_LibFormat = ""
#System_OS = "MacOS"

;-#PB_FileSystem_Normal = ?

M_SetConstantPrefs(Switch_Param_Help, 0, "-h", "--chm")
M_SetConstantPrefs(Switch_Param_DontBuildLib, 1, "-n", "--dontbuildlib")
M_SetConstantPrefs(Switch_Param_DontKeepSrcFiles, 2, "-k", "--dontkeepsrcfiles")
M_SetConstantPrefs(Switch_Param_LibName, 3, "-l", "--libname")
M_SetConstantPrefs(Switch_Param_LogFile, 4, "-f", "--logfile")
M_SetConstantPrefs(Switch_Param_OutputLib, 5, "-o", "--output")
M_SetConstantPrefs(Switch_Param_Unicode, 6, "-u", "--unicode")
M_SetConstantPrefs(Switch_Param_ThreadSafe, 7, "-t", "--threadsafe")
M_SetConstantPrefs(Switch_Param_BatchFile, 8, "-b", "--batchfile")
M_SetConstantPrefs(Switch_Param_PB_Path, 9, "-pbp", "--pbpath")
M_SetConstantPrefs(Switch_Param_PB_Compiler, 10, "-pbc", "--pbcompiler")
M_SetConstantPrefs(Switch_Param_PB_Obj2Lib, 11, "-pbo", "--pbobj2lib")
M_SetConstantPrefs(Switch_Param_PB_Fasm, 12, "-pbf", "--pbfasm")
M_SetConstantPrefs(Switch_Param_PB_LibMaker, 13, "-pbl", "--pblibmaker")
M_SetConstantPrefs(Switch_Param_PB_Ini, 14, "-pbi", "--pbini")
M_SetConstantPrefs(Switch_Param_Project_Ini, 15, "-p", "--projectini")
M_SetConstantPrefs(Switch_Param_Subsytem, 16, "-s", "--subsystem")
M_SetConstantPrefs(Switch_Param_LogFileName, 17, "-log", "--logfilename")
M_SetConstantPrefs(Switch_Param_ProjectDir, 18, "-d", "--projectdir")
M_SetConstantPrefs(Switch_Param_LogFileInStream, 19, "-fs", "--logfileinstream")
M_SetConstantPrefs(Switch_Param_Last, 20, "", "")
