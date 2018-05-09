import math

proc discreteInf*(cdf: proc(x: int): float, q: float, start = 0): int =
  var i = start
  while true:
    if cdf(i) >= q:
      return i
    inc i

proc erfinv*(x: float): float =
  var w = -ln((1.0 - x) * (1.0 + x))
  if w < 5.0:
    w = w - 2.5
    result =   2.81022636e-08
    result =   3.43273939e-07 + (result * w)
    result =   -3.5233877e-06 + (result * w)
    result =  -4.39150654e-06 + (result * w)
    result =    0.00021858087 + (result * w)
    result =   -0.00125372503 + (result * w)
    result =   -0.00417768164 + (result * w)
    result =      0.246640727 + (result * w)
    result =       1.50140941 + (result * w)
  else:
    w = sqrt(w) - 3.0
    result =  -0.000200214257
    result =   0.000100950558 + (result * w)
    result =    0.00134934322 + (result * w)
    result =   -0.00367342844 + (result * w)
    result =    0.00573950773 + (result * w)
    result =    -0.0076224613 + (result * w)
    result =    0.00943887047 + (result * w)
    result =       1.00167406 + (result * w)
    result =       2.83297682 + (result * w)
  result = result * x
