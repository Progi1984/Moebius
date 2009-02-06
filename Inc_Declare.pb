; Inc_Prefs.pb
DeclareDLL Moebius_ReadPrefs()
DeclareDLL Moebius_ReadParameters()

; Inc_Misc.pb
DeclareDLL.l CreateDirectoryEx(FolderPath.s)
DeclareDLL Log_Init()
DeclareDLL Log_Add(Content.s, NumTab.l = 0)
DeclareDLL Log_End()
DeclareDLL Batch_Init()
DeclareDLL Batch_Add(Content.s)
DeclareDLL Batch_End()

; Inc_PB.pb
Declare PB_GetInfoUserLib(LibFileName.s)
Declare PB_GetInfoLib(FileName.s)
Declare.s PB_ListFunctions(Function.s)
Declare.s PB_GetPBFolder()
DeclareDLL PB_Connect()
DeclareDLL PB_DisConnect()

; Inc_Compile_Step0.pb
DeclareDLL Moebius_Compile_Step0()
; Inc_Compile_Step1.pb
DeclareDLL Moebius_Compile_Step1()
; Inc_Compile_Step2.pb
DeclareDLL Moebius_Compile_Step2_ExtractData(CodeContent.s)
DeclareDLL Moebius_Compile_Step2_ModifyASM(CodeContent.s)
DeclareDLL.s Moebius_Compile_Step2_WriteASMForArrays(lFile.l)
DeclareDLL Moebius_Compile_Step2_AddExtrn(Part.s)
DeclareDLL Moebius_Compile_Step2()
; Inc_Compile_Step3.pb
DeclareDLL Moebius_Compile_Step3()
; Inc_Compile_Step4.pb
DeclareDLL Moebius_Compile_Step4()
; Inc_Compile_Step5.pb
DeclareDLL Moebius_Compile_Step5()
; Inc_Compile_Step6.pb
DeclareDLL Moebius_Compile_Step6()

; Moebius_MainThread.pb
DeclareDLL Moebius_MainThread(Param.l)
