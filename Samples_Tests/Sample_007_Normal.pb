Define.l varLong
Define.l varMaxRandom = Random(30)

Dim AnyArrayL.l(varMaxRandom)
For varLong = 0 To varMaxRandom - 1
  AnyArrayL(varLong) = Random(255)
Next

Dim AnyArrayS.s(varMaxRandom)
For varLong = 0 To varMaxRandom - 1
  AnyArrayS(varLong) = "S006_" + Str(Random(255)) + "_S006"
Next

Dim AnyArrayPoint.Point(varMaxRandom)
For varLong = 0 To varMaxRandom - 1
  AnyArrayPoint(varLong)\x = Random(255)
  AnyArrayPoint(varLong)\y = Random(255)
Next

S007_FunctionArrayLong(AnyArrayL(), varMaxRandom)
S007_FunctionArrayString(AnyArrayS(), varMaxRandom)
S007_FunctionArrayStructured(AnyArrayPoint(), varMaxRandom)