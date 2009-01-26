;XIncludeFile "Sample_08.pb"
Dim AnyArrayL.l(11)
For Inc = 0 To 10
  AnyArrayL(Inc) = Inc*100
Next

Dim AnyArrayS.s(11)
For Inc = 0 To 10
  AnyArrayS(Inc) = "S"+Str(Random(255))+"S"
Next

Dim AnyArrayPoint.Point(Inc)
For Inc = 0 To 10
  AnyArrayPoint(Inc)\x = Random(255)
  AnyArrayPoint(Inc)\y = Random(255)
Next

S08_GetVarL(AnyArrayL(), 5)
Debug S08_2GetVarL(AnyArrayL(), 5)
S08_GetVarS(5, AnyArrayS())
S08_GetVarPoint(AnyArrayPoint())