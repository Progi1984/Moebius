; Inc_Prefs.pb
DeclareDLL Moebius_ReadPrefs()
DeclareDLL Moebius_ReadParameters()

; Inc_Misc.pb
DeclareDLL.l CreateDirectoryEx(FolderPath.s)
DeclareDLL.l IsNumeric(String.s)
DeclareDLL Output_Init()
DeclareDLL Output_End()
DeclareDLL Output_Add(sContent.s, lFlags.l, lNumTabs.l = 0)
DeclareDLL.s GetStringError(Error.l)

; Inc_PB.pb
DeclareDLL PB_GetInfoUserLib(LibFileName.s)
DeclareDLL PB_GetInfoLib(FileName.s)
DeclareDLL.s PB_GetLibFromFunctionName(Function.s)
DeclareDLL PB_CreateFunctionsList()
DeclareDLL.s PB_GetPBFolder()
DeclareDLL PB_Connect()
DeclareDLL PB_DisConnect()

; Inc_Userlib_Step0.pb
DeclareDLL Moebius_Userlib_Step0()
; Inc_Userlib_Step1.pb
DeclareDLL Moebius_Userlib_Step1()
; Inc_Userlib_Step2.pb
DeclareDLL Moebius_Userlib_Step2_LoadASMFileInMemory()
DeclareDLL Moebius_Userlib_Step2_ExtractMainInformations()
DeclareDLL Moebius_Userlib_Step2_ModifyASM()
DeclareDLL.s Moebius_Userlib_Step2_WriteASMForArrays()
DeclareDLL Moebius_Userlib_Step2_AddExtrn(Part.s)
DeclareDLL Moebius_Userlib_Step2_CreateSharedFunction()
DeclareDLL Moebius_Userlib_Step2_CreateInitFunction()
DeclareDLL.b Moebius_Userlib_Step2_CreateASMFiles()
DeclareDLL Moebius_Userlib_Step2()
; Inc_Userlib_Step3.pb
DeclareDLL Moebius_Userlib_Step3()
; Inc_Userlib_Step4.pb
DeclareDLL Moebius_Userlib_Step4()
; Inc_Userlib_Step5.pb
DeclareDLL Moebius_Userlib_Step5()
; Inc_Userlib_Step6.pb
DeclareDLL Moebius_Userlib_Step6()


; Inc_Resident_Step0.pb
DeclareDLL Moebius_Resident_Step0()
; Inc_Resident_Step1.pb
DeclareDLL Moebius_Resident_Step1()

; Moebius_MainThread.pb
DeclareDLL Moebius_MainThread(Param.l)
