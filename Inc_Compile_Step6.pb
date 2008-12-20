
ProcedureDLL Moebius_Compile_Step6()
  ; 6. Cleans the place
;   Protected hFile = ReadFile(#PB_Any,gConf_SourceDir+#System_Separator+"purebasic.out")
;   If hFile
;     CloseFile(hFile)
;     DeleteFile(gConf_SourceDir+#System_Separator+"purebasic.out")
;   EndIf
  Log_End()
  Batch_End()
EndProcedure