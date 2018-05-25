import sequtils

type
  Oracle* = ref array[0..255, uint8]

proc schedule*(S: var Oracle, key: openarray[uint8]) =
  var j: uint8
  for i in 0..255:
    S[i] = uint8(i)
  for i in 0..255:
    let temp = S[i]
    j = (j + S[i] + key[i mod key.len]) and 0xffu8
    S[i] = S[j]
    S[j] = temp

iterator generate*(S: var Oracle, n: int): uint8 =
  var i, j, temp: uint8
  for k in 0..n-1:
    i = (i + 1) and 0xffu8
    j = (j + S[i]) and 0xffu8
    temp = S[i]
    S[i] = S[j]
    S[j] = temp
    yield S[(S[i] + S[j]) and 0xffu8]

proc randbytes*(S: var Oracle, n: int): seq[uint8] =
  toSeq(generate(S, n))

proc initARC4*(key: openarray[uint8]): Oracle =
  result = new Oracle
  schedule(result, key)
