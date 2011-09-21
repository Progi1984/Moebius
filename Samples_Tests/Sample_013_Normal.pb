Define.l VarObject, VarObjectSecond

Debug "S013_Create  > 1 >" + Str(S013_CreateObject(1, 0))
Debug "S013_GetType > 1 >" + Str(S013_GetType(1))

VarObject = S013_Create(#PB_Any, 2)
Debug "S013_Create  > #PB_Any > " + Str(VarObject)
Debug "S013_GetType > #PB_Any > " + Str(S013_GetType(VarObject))

Debug "S013_Create  > 2 >" + Str(S013_CreateObject(2, 1))
Debug "S013_GetType > 2 >" + Str(S013_GetType(2))

VarObjectSecond = S013_Create(#PB_Any, 3)
Debug "S013_Create  > #PB_Any > " + Str(VarObjectSecond)
Debug "S013_GetType > #PB_Any > " + Str(S013_GetType(VarObjectSecond)) 
