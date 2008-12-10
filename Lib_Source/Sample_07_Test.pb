NewList AnyListL.l()
For Inc = 0 To 10
  AddElement(AnyListL())
  AnyListL() = Random(255)
Next

NewList AnyListS.s()
For Inc = 0 To 10
  AddElement(AnyListS())
  AnyListS() = "S"+Str(Random(255))+"S"
Next

NewList AnyListPoint.Point()
For Inc = 0 To 10
  AddElement(AnyListPoint())
  AnyListPoint()\x = Random(255)
  AnyListPoint()\y = Random(255)
Next

S07_GetVarL(AnyListL())
S07_GetVarS(AnyListS())
S07_GetVarPoint(AnyListPoint())