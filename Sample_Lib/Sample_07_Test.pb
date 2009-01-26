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

S07_GetVarL(AnyListL(), 5)
S07_GetVarS(5, AnyListS())
S07_GetVarPoint(AnyListPoint())