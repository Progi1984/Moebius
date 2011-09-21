CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux ;{
    ImportC #PB_Compiler_Home + "/compilers/objectmanager.a"
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
  ;}
  CompilerCase #PB_OS_Windows ;{
    Import #PB_Compiler_Home + "\Compilers\ObjectManager.lib"
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
  ;}
CompilerEndIf

ProcedureDLL.l S013Free(Id.l)
  Protected *RObject.S_S013
  If *RObject
    S013_FREEID(Id)
  EndIf
  ProcedureReturn #True
EndProcedure
ProcedureDLL.l S013_Init()
  Global S013Objects
  S013Objects = S013_INITIALIZE(@S013Free())
  If IsWindow(#PB_Any) : EndIf
EndProcedure
ProcedureDLL.l S013_GetType(pID.l)
  Protected *RObject.S_S013 = S013_ID(pID)
  If *RObject
    ProcedureReturn *RObject\Type
  Else
    ProcedureReturn -1
  EndIf
EndProcedure
ProcedureDLL.l S013_CreateObject(pID.l, pType.l)
  Protected *RObject.S_S013 = S013_NEW(pID)
   With *RObject
      \ID   = *RObject
      \Type = pType
   EndWith
  ProcedureReturn *RObject
EndProcedure 
