Define.l varLong
Define.l varMaxRandom = Random(30)

NewList AnyListL.l()
For varLong = 0 To varMaxRandom
  AddElement(AnyListL())
  AnyListL() = Random(255)
Next

NewList AnyListS.s()
For varLong = 0 To varMaxRandom
  AddElement(AnyListS())
  AnyListS() = "S006_" + Str(Random(255)) + "_S006"
Next

NewList AnyListPoint.Point()
For varLong = 0 To varMaxRandom
  AddElement(AnyListPoint())
  AnyListPoint()\x = Random(255)
  AnyListPoint()\y = Random(255)
Next

S006_FunctionListLong(AnyListL())
S006_FunctionListString(AnyListS())
S006_FunctionListStructured(AnyListPoint())