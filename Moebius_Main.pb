EnableExplicit

XIncludeFile "Inc_Declare.pb"
XIncludeFile "Inc_Var.pb" 
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows : XIncludeFile "Inc_OS_Windows.pb"
  CompilerCase #PB_OS_Linux : XIncludeFile "Inc_OS_Linux.pb"
  CompilerCase #PB_OS_MacOS: XIncludeFile "Inc_OS_MacOS.pb"
CompilerEndSelect
XIncludeFile "Inc_Prefs.pb"
XIncludeFile "Inc_Misc.pb"
XIncludeFile "Inc_PB.pb"
XIncludeFile "Inc_Compile_Step0.pb"
XIncludeFile "Inc_Compile_Step1.pb"
XIncludeFile "Inc_Compile_Step2.pb"
XIncludeFile "Inc_Compile_Step3.pb"
XIncludeFile "Inc_Compile_Step4.pb"
XIncludeFile "Inc_Compile_Step5.pb"
XIncludeFile "Inc_Compile_Step6.pb"
XIncludeFile "Moebius_MainThread.pb"

M_ClearBeforeBuilding()
CompilerIf Defined(Moebius_App, #PB_Constant) = #False
  Moebius_ReadParameters()
  Moebius_ReadPrefs()
  Moebius_MainThread(0)
CompilerEndIf

; /b /l "Sample_00" /f /pbi "Prefs/Moebius_Windows.ini" "C:\Documents and Settings\franklin\Bureau\nono2009_source\nono2009.pb"
; /b /l "Sample_00" /f /pbi "Prefs/Moebius_Windows.ini" "K:\Proj_Moebius\Sample_Lib\Sample_00.pb"
; -b -l "Sample_05" -f -pbi "Prefs/Moebius_Linux.ini" "/home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Sample_Lib/Sample_05.pb"
; -b -l "Sample_11" -f -pbi "Prefs/Moebius_Linux.ini" "/home/franklin/Bureau/DD_PureBasic/Proj_Moebius/Sample_Lib/Sample_11.pb"