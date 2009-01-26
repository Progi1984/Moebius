CompilerIf #PB_Compiler_OS = #PB_OS_Windows
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
CompilerElse
  Import "/media/DISK/Programs/purebasic/compilers/objectmanager.a"
    Object_GetOrAllocateID  (Objects, Object.l) As "PB_Object_GetOrAllocateID"
    Object_GetObject        (Objects, Object.l) As "PB_Object_GetObject"
    Object_IsObject         (Objects, Object.l) As "PB_Object_IsObject"
    Object_EnumerateAll     (Objects, ObjectEnumerateAllCallback, *VoidData) As "PB_Object_EnumerateAll"
    Object_EnumerateStart   (Objects) As "PB_Object_EnumerateStart"
    Object_EnumerateNext    (Objects, *object.Long) As "PB_Object_EnumerateNext"
    Object_EnumerateAbort   (Objects) As "PB_Object_EnumerateAbort"
    Object_FreeID           (Objects, Object.l) As "PB_Object_FreeID"
    Object_Init             (StructureSize.l, IncrementStep.l, ObjectFreeFunction) As "PB_Object_Init"
    Object_GetThreadMemory  (MemoryID.l) As "PB_Object_GetThreadMemory"
    Object_InitThreadMemory (Size.l, InitFunction, EndFunction) As "PB_Object_InitThreadMemory"
  EndImport
CompilerEndIf

Structure S_S11_Union
  URL.s
EndStructure
Structure S_S11
  ID.l
  Type.l
  StructureUnion
    Union.S_S11_Union
  EndStructureUnion
EndStructure 
; 
; ;- Macros
Macro S11_ID(object)
  Object_GetObject(S11Objects, object)
EndMacro
Macro S11_IS(object)
  Object_IsObject(S11Objects, object)
EndMacro
Macro S11_NEW(object)
  Object_GetOrAllocateID(S11Objects, object)
EndMacro
Macro S11_FREEID(object)
  If object <> #PB_Any And S11_IS(object) = #True
    Object_FreeID(S11Objects, object)
  EndIf
EndMacro
Macro S11_INITIALIZE(hCloseFunction)
  Object_Init(SizeOf(S_S11), 1, hCloseFunction)
EndMacro


ProcedureDLL S11Free(Id.l)
  Protected *RObject.S_S11
   If *RObject
    S11_FREEID(Id)
  EndIf
  ProcedureReturn #True
EndProcedure
ProcedureDLL S11_Init()
  Global S11Objects
  S11Objects = S11_INITIALIZE(@S11Free())
  If IsWindow(#PB_Any)
  EndIf
EndProcedure
ProcedureDLL.l S11_GetType(Id.l)
  Protected *RObject.S_S11 = S11_ID(Id)
  If *RObject
    ProcedureReturn *RObject\Type
  Else
    ProcedureReturn -1
  EndIf
EndProcedure
ProcedureDLL.l S11_Create(Id.l, type.l)
  Protected *RObject.S_S11 = S11_NEW(Id)
   With *RObject
      \ID = *RObject
      \Type = type
   EndWith
  ProcedureReturn *RObject
EndProcedure 

