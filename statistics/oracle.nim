import ./private/arc4

const Discard = 3072

var defaultState: Oracle

proc initOracle*(seed: uint64): Oracle =
  result = initARC4(cast[array[0..7, uint8]](seed))
  for b in generate(result, Discard):
    discard

when not defined(nimscript):
  import times

  proc initOracle*(): Oracle =
    initOracle(uint64(epochTime() * 1_000_000_000))

  defaultState = initOracle()
else:
  {.error: "oracle is not supported for the nimscript target".}

proc rand*(state: var Oracle): float =
  var bytes: array[0..7, uint8]
  var number: uint64
  var i = 0
  for b in generate(state, 8):
    bytes[i] = b
    inc i
  number = cast[uint64](bytes)
  number = (0x3FFu64 shl 52) or (number shr 12)
  cast[float64](number) - 1.0

proc rand*(): float =
  rand(defaultState)
