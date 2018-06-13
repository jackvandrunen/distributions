import ../distributions
import ../functions
import ../roots
import math
import strformat
include ./utils

export distributions

type
  ChiSquaredDistribution* = ref object of Distribution[float]
    p*: float

proc ChiSquared*(p: int): ChiSquaredDistribution =
  ChiSquaredDistribution(p: float(p))

converter `$`*(d: ChiSquaredDistribution): string =
  fmt"ChiSquared({int(d.p)})"

method pdf*(d: ChiSquaredDistribution, x: float): float =
  let a = 0.5 * d.p
  let b = exp(-lgamma(a))
  if x > 0.0:
    result = (b / pow(2.0, a)) * pow(x, a - 1.0) * exp(-0.5 * x)

method cdf*(d: ChiSquaredDistribution, x: float): float =
  let a = 0.5 * d.p
  if x > 0.0:
    result = exp(-lgamma(a) + lgammainc(a, 0.5 * x))

method quantile*(d: ChiSquaredDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, d.p)

method mean*(d: ChiSquaredDistribution): float =
  d.p

method variance*(d: ChiSquaredDistribution): float =
  2.0 * d.p

method skewness*(d: ChiSquaredDistribution): float =
  sqrt(8.0 / d.p)

method kurtosis*(d: ChiSquaredDistribution): float =
  12.0 / d.p

method mode*(d: ChiSquaredDistribution): seq[float] =
  @[max(d.p - 2.0, 0.0)]
