  Debug "RTmp_Create>"+Str(RTmp_Create(1, 0))
  Debug "RTmp_GetType>"+Str(RTmp_GetType(1))
  Debug "--------------------"
  IDTmp = RTmp_Create(#PB_Any, 2)
  Debug "RTmp_Create>"+Str(IDTmp)
  Debug "RTmp_GetType>"+Str(RTmp_GetType(IDTmp))
  Debug "--------------------"
  Debug "RTmp_Create>"+Str(RTmp_Create(2, 1))
  Debug "RTmp_GetType>"+Str(RTmp_GetType(2))
  Debug "--------------------"
  IDTmp2 = RTmp_Create(#PB_Any, 3)
  Debug "RTmp_Create>"+Str(IDTmp2)
  Debug "RTmp_GetType>"+Str(RTmp_GetType(IDTmp2)) 