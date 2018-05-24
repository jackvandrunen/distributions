import math

proc erfinv*(x: float): float =
  var w = - ln((1.0 - x) * (1.0 + x))
  if w < 6.25:
    w = w - 3.125
    result =  -3.6444120640178196996e-21
    result =   -1.685059138182016589e-19 + result * w
    result =   1.2858480715256400167e-18 + result * w
    result =    1.115787767802518096e-17 + result * w
    result =   -1.333171662854620906e-16 + result * w
    result =   2.0972767875968561637e-17 + result * w
    result =   6.6376381343583238325e-15 + result * w
    result =  -4.0545662729752068639e-14 + result * w
    result =  -8.1519341976054721522e-14 + result * w
    result =   2.6335093153082322977e-12 + result * w
    result =  -1.2975133253453532498e-11 + result * w
    result =  -5.4154120542946279317e-11 + result * w
    result =    1.051212273321532285e-09 + result * w
    result =  -4.1126339803469836976e-09 + result * w
    result =  -2.9070369957882005086e-08 + result * w
    result =   4.2347877827932403518e-07 + result * w
    result =  -1.3654692000834678645e-06 + result * w
    result =  -1.3882523362786468719e-05 + result * w
    result =    0.0001867342080340571352 + result * w
    result =  -0.00074070253416626697512 + result * w
    result =   -0.0060336708714301490533 + result * w
    result =      0.24015818242558961693 + result * w
    result =       1.6536545626831027356 + result * w
  elif w < 16.0:
    w = sqrt(w) - 3.25
    result =   2.2137376921775787049e-09
    result =   9.0756561938885390979e-08 + result * w
    result =  -2.7517406297064545428e-07 + result * w
    result =   1.8239629214389227755e-08 + result * w
    result =   1.5027403968909827627e-06 + result * w
    result =   -4.013867526981545969e-06 + result * w
    result =   2.9234449089955446044e-06 + result * w
    result =   1.2475304481671778723e-05 + result * w
    result =  -4.7318229009055733981e-05 + result * w
    result =   6.8284851459573175448e-05 + result * w
    result =   2.4031110387097893999e-05 + result * w
    result =   -0.0003550375203628474796 + result * w
    result =   0.00095328937973738049703 + result * w
    result =   -0.0016882755560235047313 + result * w
    result =    0.0024914420961078508066 + result * w
    result =   -0.0037512085075692412107 + result * w
    result =     0.005370914553590063617 + result * w
    result =       1.0052589676941592334 + result * w
    result =       3.0838856104922207635 + result * w
  else:
    w = sqrt(w) - 5.0
    result =  -2.7109920616438573243e-11
    result =  -2.5556418169965252055e-10 + result * w
    result =   1.5076572693500548083e-09 + result * w
    result =  -3.7894654401267369937e-09 + result * w
    result =   7.6157012080783393804e-09 + result * w
    result =  -1.4960026627149240478e-08 + result * w
    result =   2.9147953450901080826e-08 + result * w
    result =  -6.7711997758452339498e-08 + result * w
    result =   2.2900482228026654717e-07 + result * w
    result =  -9.9298272942317002539e-07 + result * w
    result =   4.5260625972231537039e-06 + result * w
    result =  -1.9681778105531670567e-05 + result * w
    result =   7.5995277030017761139e-05 + result * w
    result =  -0.00021503011930044477347 + result * w
    result =  -0.00013871931833623122026 + result * w
    result =       1.0103004648645343977 + result * w
    result =       4.8499064014085844221 + result * w
  return result * x

proc lgammainc*(s, z: float): float =
  result = s + 12.0
  result = s + 11.0 + ((6.0 * z) / result)
  result = s + 10.0 - ((s + 5.0) * z / result)
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
  result = -ln(result) + (s * ln(z)) - z

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
