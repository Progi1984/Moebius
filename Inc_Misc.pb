;@author : Le Soldat Inconnu
;@desc : This code permits you to create a directory which parents directories doesn't exist.
;@sample :
; ; I wish create a directory "C:\Program files\truc\bidule"
; ; Only the directory "C:\Program files\" exists
; ; If I use CreateDirectory("C:\Program files\truc\bidule"), that doesn't work because the directory "C:\Program files\truc\" doesn't exist
; ; If I use CreateDirectoryEx("C:\Program files\truc\bidule"), all these directories will be created :
; - C:\Program files\
; - C:\Program files\truc\
; - C:\Program files\truc\bidule
;@returns : 1 if the creation of the directory has a success
;@+ 0 if not
ProcedureDLL.l CreateDirectoryEx(FolderPath.s)
 Protected Folder.s, Txt.s, Cpt.l
 If FileSize(Folder) = -1
  Folder = StringField(FolderPath, 1, #System_Separator) + #System_Separator
  Cpt     = 1
  Repeat
   Cpt + 1
   Txt      = StringField(FolderPath, Cpt, #System_Separator)
   Folder = Folder + Txt + #System_Separator
   CreateDirectory(Folder)
  Until Txt = ""
 EndIf
 If FileSize(FolderPath) = -2
  ProcedureReturn #True
 Else
  ProcedureReturn #False
 EndIf
EndProcedure 

; IDE Options = PureBasic 4.20 (Linux - x86)
; CursorPosition = 12
; Folding = +
; EnableXP