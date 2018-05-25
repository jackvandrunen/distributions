import ./private/arc4

const Discard = 3072

var defaultState: Oracle

when not defined(nimscript):
  import times
  let seed = uint64(epochTime() * 1_000_000_000)
  defaultState = initARC4(cast[array[0..7, uint8]](seed))
  for b in generate(defaultState, Discard):
    discard
else:
  {.error: "oracle is not supported for the nimscript target".}

proc rand*(): float =
  var bytes: array[0..7, uint8]
  var number: uint64
  var i = 1
  for b in generate(defaultState, 7):
    bytes[i] = b
    inc i
  number = cast[uint64](bytes)
  number = (0x3FFu64 shl 52) or (number shr 12)
  cast[float64](number) - 1.0
