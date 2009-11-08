EnableExplicit

XIncludeFile "Inc_Declare.pb"
XIncludeFile "Inc_Var.pb" 
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux : XIncludeFile "Inc_OS_Linux.pb"
  CompilerCase #PB_OS_MacOS: XIncludeFile "Inc_OS_MacOS.pb"
  CompilerCase #PB_OS_Windows : XIncludeFile "Inc_OS_Windows.pb"
CompilerEndSelect
XIncludeFile "Inc_Prefs.pb"
XIncludeFile "Inc_Misc.pb"
XIncludeFile "Inc_PB.pb"
XIncludeFile "Inc_Userlib_Step0.pb"
XIncludeFile "Inc_Userlib_Step1.pb"
XIncludeFile "Inc_Userlib_Step2.pb"
XIncludeFile "Inc_Userlib_Step3.pb"
XIncludeFile "Inc_Userlib_Step4.pb"
XIncludeFile "Inc_Userlib_Step5.pb"
XIncludeFile "Inc_Userlib_Step6.pb"
XIncludeFile "Inc_Resident_Step0.pb"
XIncludeFile "Inc_Resident_Step1.pb"
XIncludeFile "Inc_Resident_Step2.pb"
XIncludeFile "Moebius_MainThread.pb"

M_ClearBeforeBuilding()
CompilerIf Defined(Moebius_App, #PB_Constant) = #False
  Moebius_ReadParameters()
  Moebius_ReadPrefs()
  Moebius_MainThread(0)
CompilerEndIf
