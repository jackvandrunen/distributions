import ../distributions
import ../roots
import math
import strformat
include ./utils

export distributions

type
  GeometricDistribution* = ref object of Distribution[int]
    p*: float

proc Geometric*(p: float): GeometricDistribution =
  GeometricDistribution(p: p)

converter `$`*(d: GeometricDistribution): string =
  fmt"Geometric({d.p})"

method pmf*(d: GeometricDistribution, x: int): float =
  if x > 0:
    result = d.p * pow(1.0 - d.p, float(x - 1))

method cdf*(d: GeometricDistribution, x: int): float =
  if x > 0:
    result = 1.0 - pow(1.0 - d.p, float(x))

method quantile*(d: GeometricDistribution, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 1)

method mean*(d: GeometricDistribution): float =
  1.0 / d.p

method variance*(d: GeometricDistribution): float =
  (1.0 - d.p) / (d.p * d.p)

method skewness*(d: GeometricDistribution): float =
  (2.0 - d.p) / sqrt(1.0 - d.p)

method kurtosis*(d: GeometricDistribution): float =
  6.0 + ((d.p * d.p) / (1.0 - d.p))

method mode*(d: GeometricDistribution): seq[int] =
  @[1]
