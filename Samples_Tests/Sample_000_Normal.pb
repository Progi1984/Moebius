RandomSeed(ElapsedMilliseconds())
Debug S000_FunctionByte(64)
Debug "==> 64"
Debug S000_FunctionWord(16384)
Debug "==> 16384"
Debug S000_FunctionLong(1073741824)
Debug "==> 1073741824"
CompilerSelect #PB_Compiler_Processor
  CompilerCase #PB_Processor_x86
    Debug S000_FunctionInteger(1073741824)
  CompilerCase #PB_Processor_x64
    Debug S000_FunctionInteger(4611686018427387904)
CompilerEndSelect
Debug "==> 32 bits : 1073741824"
Debug "==> 64 bits : 4611686018427387904"
Debug S000_FunctionFloat(123.5e-10)
Debug "==> 0.00000001235"
Debug S000_FunctionQuad(4611686018427387904)
Debug "==> 4611686018427387904"
Debug S000_FunctionDouble(123.5e-20)
Debug "==> 0.000000000000000001235"
Debug S000_FunctionString("alpha")
Debug "==> alpha"
Debug S000_FunctionParamTwo("alpha", "beta")
Debug "==> alphabeta"
Debug S000_FunctionParamThree("alpha", "beta", "delta")
Debug "==> alphabetadelta"
Debug S000_FunctionParamFour("alpha", "beta", "delta", "epsilon")
Debug "==> alphabetadeltaepsilon"
*Mem = AllocateMemory(1024)
Debug S000_FunctionMem(*Mem)
Debug "==> "+Str(*Mem)
FreeMemory(*Mem)
Debug S000_FunctionPrivate(10)
Debug "==> 20"

