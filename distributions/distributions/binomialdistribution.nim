import ../basedistribution
import ../functions
import ../roots
import math
import strformat
include ./utils

export basedistribution

type
  BinomialDistribution* = ref object of Distribution[int]
    n*: int
    p*: float

proc Binomial*(n: int, p: float): BinomialDistribution =
  BinomialDistribution(n: n, p: p)

converter `$`*(d: BinomialDistribution): string =
  fmt"Binomial({d.n}, {d.p})"

method pmf*(d: BinomialDistribution, x: int): float =
  if x >= 0:
    result = float(binom(d.n, x)) * pow(d.p, float(x)) * pow(1.0 - d.p, float(d.n - x))

method cdf*(d: BinomialDistribution, x: int): float =
  incbet(float(d.n - x), 1.0 + float(x), 1.0 - d.p)

method quantile*(d: BinomialDistribution, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 0)

method mean*(d: BinomialDistribution): float =
  float(d.n) * d.p

method variance*(d: BinomialDistribution): float =
  float(d.n) * d.p * (1.0 - d.p)

method skewness*(d: BinomialDistribution): float =
  (1.0 - (2.0 * d.p)) / sqrt(float(d.n) * d.p * (1.0 - d.p))

method kurtosis*(d: BinomialDistribution): float =
  (1.0 - (6.0 * d.p * (1.0 - d.p))) / (float(d.n) * d.p * (1.0 - d.p))

method mode*(d: BinomialDistribution): seq[int] =
  @[int(float(d.n + 1) * d.p)]
