; Import "C:\Program Files\PureBasic\Compilers\ObjectManager.lib"
;   Object_GetOrAllocateID (Objects, Object.l) As "_PB_Object_GetOrAllocateID@8"
;   Object_GetObject       (Objects, Object.l) As "_PB_Object_GetObject@8"
;   Object_IsObject        (Objects, Object.l) As "_PB_Object_IsObject@8"
;   Object_EnumerateAll    (Objects, ObjectEnumerateAllCallback, *VoidData) As "_PB_Object_EnumerateAll@12"
;   Object_EnumerateStart  (Objects) As "_PB_Object_EnumerateStart@4"
;   Object_EnumerateNext   (Objects, *object.Long) As "_PB_Object_EnumerateNext@8"
;   Object_EnumerateAbort  (Objects) As "_PB_Object_EnumerateAbort@4"
;   Object_FreeID          (Objects, Object.l) As "_PB_Object_FreeID@8"
;   Object_Init            (StructureSize.l, IncrementStep.l, ObjectFreeFunction) As "_PB_Object_Init@12"
;   Object_GetThreadMemory (MemoryID.l) As "_PB_Object_GetThreadMemory@4"
;   Object_InitThreadMemory(Size.l, InitFunction, EndFunction) As "_PB_Object_InitThreadMemory@12"
; EndImport
; 
; Procedure S11Free(Id.l)
;   Protected *Test.Point
;   If Id <> #PB_Any And Object_IsObject(TestObjects, Id)
;    *Test = Object_GetObject(TestObjects, Id)
;   EndIf
;   If *Test
;    Object_FreeID(TestObjects,Id)
;   EndIf
;   ProcedureReturn #True
; EndProcedure
; ProcedureDLL S11_GetX(Id.l)
;   Protected *Object.Point = Object_GetObject(TestObjects, Id)
;   If *Object
;     ProcedureReturn *Object\x
;   Else
;     ProcedureReturn -1
;   EndIf
; EndProcedure
; ProcedureDLL S11_GetY(Id.l)
;   Protected *Object.Point = Object_GetObject(TestObjects, Id)
;   If *Object
;     ProcedureReturn *Object\y
;   Else
;     ProcedureReturn -1
;   EndIf
; EndProcedure
; ProcedureDLL S11_SetX(Id.l, x.l)
;   Protected *Object.Point = Object_GetObject(TestObjects, Id)
;   If *Object
;     *Object\x = x
;     ProcedureReturn #True
;   Else
;     ProcedureReturn #False
;   EndIf
; EndProcedure
; ProcedureDLL S11_SetY(Id.l, y.l)
;   Protected *Object.Point = Object_GetObject(TestObjects, Id)
;   If *Object
;     *Object\y = y
;     ProcedureReturn #True
;   Else
;     ProcedureReturn #False
;   EndIf
; EndProcedure
; 
; ProcedureDLL S11_Free(Id.l)
;   ProcedureReturn S11Free(Id)
; EndProcedure
; ProcedureDLL S11_Create(Id.l, x.l, y.l)
;   Protected *Object.Point = Object_GetOrAllocateID(TestObjects, Id)
;   If *Object
;     *Object\x = x
;     *Object\y = y
;     ProcedureReturn *Object
;   Else
;     ProcedureReturn -1
;   EndIf
; EndProcedure
; ProcedureDLL S11_Init()
;   Global TestObjects
;   TestObjects = Object_Init(SizeOf(Point), 1, @S11Free())
;   If IsWindow(#PB_Any)
;   EndIf
; EndProcedure

Import "C:\Program Files\PureBasic\Compilers\ObjectManager.lib"
  Object_GetOrAllocateID  (Objects, Object.l) As "_PB_Object_GetOrAllocateID@8"
  Object_GetObject        (Objects, Object.l) As "_PB_Object_GetObject@8"
  Object_IsObject         (Objects, Object.l) As "_PB_Object_IsObject@8"
  Object_EnumerateAll     (Objects, ObjectEnumerateAllCallback, *VoidData) As "_PB_Object_EnumerateAll@12"
  Object_EnumerateStart   (Objects) As "_PB_Object_EnumerateStart@4"
  Object_EnumerateNext    (Objects, *object.Long) As "_PB_Object_EnumerateNext@8"
  Object_EnumerateAbort   (Objects) As "_PB_Object_EnumerateAbort@4"
  Object_FreeID           (Objects, Object.l) As "_PB_Object_FreeID@8"
  Object_Init             (StructureSize.l, IncrementStep.l, ObjectFreeFunction) As "_PB_Object_Init@12"
  Object_GetThreadMemory  (MemoryID.l) As "_PB_Object_GetThreadMemory@4"
  Object_InitThreadMemory (Size.l, InitFunction, EndFunction) As "_PB_Object_InitThreadMemory@12"
EndImport

Structure S_RTmp_Union
  URL.s
EndStructure
Structure S_RTmp
  ID.l
  type.l
  StructureUnion
    Union.S_RTmp_Union
  EndStructureUnion
EndStructure 

;- Macros
Macro RTmp_ID(object)
  Object_GetObject(RTmpObjects, object)
EndMacro
Macro RTmp_IS(object)
  Object_IsObject(RTmpObjects, object)
EndMacro
Macro RTmp_NEW(object)
  Object_GetOrAllocateID(RTmpObjects, object)
EndMacro
Macro RTmp_FREEID(object)
  If object <> #PB_Any And RTmp_IS(object) = #True
    Object_FreeID(RTmpObjects, object)
  EndIf
EndMacro
Macro RTmp_INITIALIZE(hCloseFunction)
  Object_Init(SizeOf(S_RTmp), 1, hCloseFunction)
EndMacro


ProcedureDLL RTmpFree(Id.l)
  Protected *RObject.S_RTmp
   If *RObject
    RTmp_FREEID(Id)
  EndIf
  ProcedureReturn #True
EndProcedure
ProcedureDLL RTmp_Init()
  Global RTmpObjects
  RTmpObjects = RTmp_INITIALIZE(@RTmpFree())
  Global NewList LL_RLog_Logs.l()
EndProcedure
ProcedureDLL.l RTmp_GetType(Id.l)
  Protected *RObject.S_RTmp = RTmp_ID(Id)
  If *RObject
    ProcedureReturn *RObject\Type
  Else
    ProcedureReturn -1
  EndIf
EndProcedure
ProcedureDLL.l RTmp_(Id.l)
  Protected *RObject.S_RTmp = RTmp_ID(Id)
EndProcedure
ProcedureDLL.l RTmp_Create(Id.l, type.l)
  Protected *RObject.S_RTmp = RTmp_NEW(Id)
   With *RObject
      \ID = *RObject
      \Type = type
   EndWith
  ProcedureReturn *RObject
EndProcedure 


; IDE Options = PureBasic 4.30 (Windows - x86)
; EnableXP