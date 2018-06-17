type
  PCG32Random = ref tuple[state, stream: uint64]
  Oracle = ref object
    seed*: array[0..3, uint64]
    s1, s2: PCG32Random

var defaultState: Oracle

proc toUniform(a, b: uint32): float64 =
  (float64(a shr 6) * 134217728.0 + float64(b shr 5)) / 9007199254740992.0

proc initOracle*(seed: array[0..3, uint64]): Oracle =
  result = new Oracle
  result.seed = seed
  result.s1 = new PCG32Random
  result.s1.state = seed[0]
  result.s1.stream = seed[1] or 1'u64
  result.s2 = new PCG32Random
  result.s2.state = seed[2] 
  result.s2.stream = seed[3] or 1'u64

proc rand(rng: var PCG32Random): uint32 =
  let oldstate = rng.state
  rng.state = oldstate * 6364136223846793005'u64 + rng.stream
  let xorshifted = uint32(((oldstate shr 18'u64) xor oldstate) shr 27'u64)
  let rot = int(oldstate shr 59'u64)
  (xorshifted shr rot) or (xorshifted shl ((-rot) and 31))

proc rand*(oracle: var Oracle): float64 =
  toUniform(rand(oracle.s1), rand(oracle.s2))

proc rand*(): float64 =
  rand(defaultState)

when defined(nimscript):
  proc initOracle*(): Oracle =
    initOracle([0x853c49e6748fea9b'u64, 0xda3e39cb94b95bdb'u64, 0x9bea8f74e6493c85'u64, 0xdb5bb994cb393eda'u64])
else:
  import times
  proc initOracle*(): Oracle =
    var s1 = new PCG32Random
    s1.state = uint64(epochTime() * 1_000_000_000)
    s1.stream = uint64(cast[int](addr s1)) or 1'u64
    var s2 = new PCG32Random
    s2.state = uint64(epochTime() * 1_000_000_000)
    s2.stream = uint64(cast[int](addr s2)) or 1'u64
    result = new Oracle
    result.s1 = s1
    result.s2 = s2
    result.seed = [s1.state, s1.stream, s2.state, s2.stream]

defaultState = initOracle()
