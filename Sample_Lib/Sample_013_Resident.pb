;- Macros
Macro S013_ID(object)
  Object_GetObject(S013Objects, object)
EndMacro
Macro S013_IS(object)
  Object_IsObject(S013Objects, object)
EndMacro
Macro S013_NEW(object)
  Object_GetOrAllocateID(S013Objects, object)
EndMacro
Macro S013_FREEID(object)
  If object <> #PB_Any And S013_IS(object) = #True
    Object_FreeID(S013Objects, object)
  EndIf
EndMacro
Macro S013_INITIALIZE(hCloseFunction)
  Object_Init(SizeOf(S_S013), 1, hCloseFunction)
EndMacro

;- Structures
Structure S_S013
  ID.l
  Type.l
EndStructure 