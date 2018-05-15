import math

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

proc gammainc*(s, z: float): float =
  result = s + 10.0
  result = s + 9.0 + ((5.0 * z) / result)
  result = s + 8.0 - ((s + 4.0) * z / result)
  result = s + 7.0 + ((4.0 * z) / result)
  result = s + 6.0 - ((s + 3.0) * z / result)
  result = s + 5.0 + ((3.0 * z) / result)
  result = s + 4.0 - ((s + 2.0) * z / result)
  result = s + 3.0 + ((2.0 * z) / result)
  result = s + 2.0 - ((s + 1.0) * z / result)
  result = s + 1.0 + (z / result)
  result = s - (s * z / result)
  result = pow(z, s) * exp(-z) / result

proc beta*(a, b: float): float =
  exp(lgamma(a) + lgamma(b) - lgamma(a + b))

proc betaincreg*(z, a, b: float): float =
  proc r(k: int): float =
    if k mod 2 == 1:
      let kf = (float(k) - 1) / 2.0
      let ap2k = a + (2.0 * kf)
      -1.0 * (a + kf) * (a + b + kf) * z / (ap2k * (ap2k + 1))
    else:
      let kf = float(k) / 2.0
      let ap2k = a + (2.0 * kf)
      kf * (b - kf) * z / (ap2k * (ap2k - 1))
  
  result = 1.0
  result = 1.0 + (r(5) / result)
  result = 1.0 + (r(4) / result)
  result = 1.0 + (r(3) / result)
  result = 1.0 + (r(2) / result)
  result = 1.0 + (r(1) / result)
  result = (pow(z, a) * pow(1.0 - z, b) / (a * beta(a, b))) / result
