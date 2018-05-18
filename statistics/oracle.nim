import times

type
  Oracle = object
    s: array[0..3, uint64]
var
  defaultState: Oracle

proc rotl(x: uint64, k: int): uint64 {.inline.} =
  (x shl k) or (x shr (64 - k))

proc `^=`(a: var uint64, b: uint64) {.inline.} =
  a = a xor b

proc normalize(x: uint64): float64 {.inline.} =
  cast[float64]((0x3FFu64 shl 52) or (x shr 12)) - 1.0

proc splitmix64(x: var uint64): uint64 =
  var z: uint64
  x += 0x9e3779b97f4a7c15u64
  z = x
  z = (z xor (z shr 30)) * 0xbf58476d1ce4e5b9u64
  z = (z xor (z shr 27)) * 0x94d049bb133111ebu64
  z xor (z shr 31)

proc rand*(state: var Oracle): float =
  let t = state.s[1] shl 17
  result = normalize(rotl(state.s[1] * 5, 7) * 9)
  state.s[2] ^= state.s[0];
  state.s[3] ^= state.s[1];
  state.s[1] ^= state.s[2];
  state.s[0] ^= state.s[3];
  state.s[2] ^= t
  state.s[3] = rotl(state.s[3], 45)

proc rand*(): float =
  rand(defaultState)

proc initOracle*(seed: uint64): Oracle =
  var x = seed
  Oracle(s: [
    splitmix64(x),
    splitmix64(x),
    splitmix64(x),
    splitmix64(x)
  ])

proc initOracle*(): Oracle =
  initOracle(cast[uint64](epochTime()))

defaultState = initOracle()
