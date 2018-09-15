import math

proc erfinv*(x: float64): float64 =
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

proc beta*(a, b: float): float =
  exp(lgamma(a) + lgamma(b) - lgamma(a + b))

const MAXGAM: float64 = 34.84425627277176174
const MAXLOG: float64 = 7.08396418532264106224E2
const MINLOG: float64 = -7.08396418532264106224E2
const MACHEP: float64 = 1.11022302462515654042E-16

const big: float64 = 4.503599627370496e15
const biginv: float64 =  2.22044604925031308085e-16

proc igam*(a, x: float64): float64

proc igamc*(a, x: float64): float64 =
  var ax, y, z, c, pkm2, qkm2, pkm1, qkm1, yc, pk, qk, r, t: float64
  if x <= 0.0 or a <= 0.0:
    return 1.0
  if x < 1.0 or x < a:
    return 1.0 - igam(a, x)
  ax = a * ln(x) - x - lgamma(a)
  if ax < -MAXLOG:
    return 0.0
  ax = exp(ax)
  y = 1.0 - a
  z = x + y + 1.0
  c = 0.0
  pkm2 = 1.0
  qkm2 = x
  pkm1 = x + 1.0
  qkm1 = z * x
  result = pkm1 / qkm1
  while true:
    c += 1.0
    y += 1.0
    z += 2.0
    yc = y * c
    pk = pkm1 * z - pkm2 * yc
    qk = qkm1 * z - qkm2 * yc
    if qk != 0:
      r = pk / qk
      t = abs((result - r) / r)
      result = r
    else:
      t = 1.0
    pkm2 = pkm1
    pkm1 = pk
    qkm2 = qkm1
    qkm1 = qk
    if abs(pk) > big:
      pkm2 *= biginv
      pkm1 *= biginv
      qkm2 *= biginv
      qkm1 *= biginv
    if t <= MACHEP:
      break
  result *= ax

proc igam*(a, x: float64): float64 =
  var ax, r, c: float64
  if x <= 0.0 or a <= 0.0:
    return 0.0
  if x > 1.0 and x > a:
    return 1.0 - igamc(a, x)
  ax = a * ln(x) - x - lgamma(a)
  if (ax < -MAXLOG):
    return 0.0
  ax = exp(ax)
  r = a
  c = 1.0
  result = 1.0
  while true:
    r += 1.0
    c *= x / r
    result += c
    if c / result <= MACHEP:
      break
  result *= ax / a

proc incbcf(a, b, x: float64): float64

proc incbd(a, b, x: float64): float64

proc pseries(a, b, x: float64): float64

proc incbet*(aa, bb, xx: float64): float64 =
  var a, b, t, x, xc, w, y: float64
  var flag: bool
  if aa <= 0.0 or bb <= 0.0:
    return 0.0
  if xx <= 0.0 or xx >= 1.0:
    if xx == 0.0:
      return 0.0
    if xx == 1.0:
      return 1.0
    return 0.0
  if bb * xx <= 1.0 and xx <= 0.95:
    return pseries(aa, bb, xx)
  w = 1.0 - xx
  if xx > (aa / (aa + bb)):
    flag = true
    a = bb
    b = aa
    xc = xx
    x = w
  else:
    a = aa
    b = bb
    xc = w
    x = xx
  if flag and b * x <= 1.0 and x <= 0.95:
    t = pseries(a, b, x)
    if t <= MACHEP:
      t = 1.0 - MACHEP
    else:
      t = 1.0 - t
    return t
  y = x * (a + b - 2.0) - (a - 1.0)
  if y < 0.0:
    w = incbcf(a, b, x)
  else:
    w = incbd(a, b, x) / xc
  y = a * ln(x)
  t = b * ln(xc)
  if a + b < MAXGAM and abs(y) < MAXLOG and abs(t) < MAXLOG:
    t = pow(xc, b)
    t *= pow(x, a)
    t /= a
    t *= w
    t *= gamma(a + b) / (gamma(a) * gamma(b))
    if flag:
      if t <= MACHEP:
        t = 1.0 - MACHEP
      else:
        t = 1.0 - t
    return t
  y += t + lgamma(a + b) - lgamma(a) - lgamma(b)
  y += ln(w / a)
  if y < MINLOG:
    t = 0.0
  else:
    t = exp(y)
  if flag:
    if t <= MACHEP:
      t = 1.0 - MACHEP
    else:
      t = 1.0 - t
  return t

proc incbcf(a, b, x: float64): float64 =
  var xk, pk, pkm1, pkm2, qk, qkm1, qkm2, k1, k2, k3, k4, k5, k6, k7, k8, r, t, thresh: float64
  k1 = a
  k2 = a + b
  k3 = a
  k4 = a + 1.0
  k5 = 1.0
  k6 = b - 1.0
  k7 = k4
  k8 = a + 2.0
  pkm2 = 0.0
  qkm2 = 1.0
  pkm1 = 1.0
  qkm1 = 1.0
  result = 1.0
  r = 1.0
  thresh = 3.0 * MACHEP
  for n in 0..299:
    xk = -(x * k1 * k2) / (k3 * k4)
    pk = pkm1 + pkm2 * xk
    qk = qkm1 + qkm2 * xk
    pkm2 = pkm1
    pkm1 = pk
    qkm2 = qkm1
    qkm1 = qk
    xk = (x * k5 * k6) / (k7 * k8)
    pk = pkm1 + pkm2 * xk
    qk = qkm1 + qkm2 * xk
    pkm2 = pkm1
    pkm1 = pk
    qkm2 = qkm1
    qkm1 = qk
    if qk != 0.0:
      r = pk / qk
    if r != 0.0:
      t = abs((result - r) / r)
      result = r
    else:
      t = 1.0
    if t < thresh:
      break
    k1 += 1.0
    k2 += 1.0
    k3 += 2.0
    k4 += 2.0
    k5 += 1.0
    k6 -= 1.0
    k7 += 2.0
    k8 += 2.0
    if abs(qk) + abs(pk) > big:
      pkm2 *= biginv
      pkm1 *= biginv
      qkm2 *= biginv
      qkm1 *= biginv
    if abs(qk) < biginv or abs(pk) < biginv:
      pkm2 *= big
      pkm1 *= big
      qkm2 *= big
      qkm1 *= big

proc incbd(a, b, x: float64): float64 =
  var xk, pk, pkm1, pkm2, qk, qkm1, qkm2, k1, k2, k3, k4, k5, k6, k7, k8, r, t, z, thresh: float64
  k1 = a
  k2 = b - 1.0
  k3 = a
  k4 = a + 1.0
  k5 = 1.0
  k6 = a + b
  k7 = a + 1.0
  k8 = a + 2.0
  pkm2 = 0.0
  qkm2 = 1.0
  pkm1 = 1.0
  qkm1 = 1.0
  z = x / (1.0 - x)
  result = 1.0
  r = 1.0
  thresh = 3.0 * MACHEP
  for n in 0..299:
    xk = -(z * k1 * k2) / (k3 * k4)
    pk = pkm1 + pkm2 * xk
    qk = qkm1 + qkm2 * xk
    pkm2 = pkm1
    pkm1 = pk
    qkm2 = qkm1
    qkm1 = qk
    xk = (z * k5 * k6) / (k7 * k8)
    pk = pkm1 + pkm2 * xk
    qk = qkm1 + qkm2 * xk
    pkm2 = pkm1
    pkm1 = pk
    qkm2 = qkm1
    qkm1 = qk
    if qk != 0.0:
      r = pk / qk
    if r != 0.0:
      t = abs((result - r) / r)
      result = r
    else:
      t = 1.0
    if t < thresh:
      break
    k1 += 1.0
    k2 -= 1.0
    k3 += 2.0
    k4 += 2.0
    k5 += 1.0
    k6 += 1.0
    k7 += 2.0
    k8 += 2.0
    if abs(qk) + abs(pk) > big:
      pkm2 *= biginv
      pkm1 *= biginv
      qkm2 *= biginv
      qkm1 *= biginv
    if abs(qk) < biginv or abs(pk) < biginv:
      pkm2 *= big
      pkm1 *= big
      qkm2 *= big
      qkm1 *= big

proc pseries(a, b, x: float64): float64 =
  var s, t, u, v, n, t1, z, ai: float64
  ai = 1.0 / a
  u = (1.0 - b) * x
  v = u / (a + 1.0)
  t1 = v
  t = u
  n = 2.0
  s = 0.0
  z = MACHEP * ai
  while abs(v) > z:
    u = (n - b) * x / n
    t *= u
    v = t / (a + n)
    s += v
    n += 1.0
  s += t1
  s += ai
  u = a * ln(x)
  if a + b < MAXGAM and abs(u) < MAXLOG:
    t = gamma(a + b) / (gamma(a) * gamma(b))
    s = s * t * pow(x, a)
  else:
    t = lgamma(a + b) - lgamma(a) - lgamma(b) + u + ln(s)
    if t < MINLOG:
      s = 0.0
    else:
      s = exp(t)
  return s
