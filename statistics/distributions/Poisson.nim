import ../distributions
import ../functions
import ../roots
import math
import strformat
include ./utils

export distributions

type
  PoissonDistribution* = ref object of Distribution[int]
    lambda*: float

proc Poisson*(lambda: float): PoissonDistribution =
  PoissonDistribution(lambda: lambda)

converter `$`*(d: PoissonDistribution): string =
  fmt"Poisson({d.lambda})"

method pmf*(d: PoissonDistribution, x: int): float =
  if x >= 0:
    result = pow(d.lambda, float(x)) * exp(-d.lambda) / float(fac(x))

method cdf*(d: PoissonDistribution, x: int): float =
  if x >= 0:
    let xf = float(x + 1)
    result = exp(ugammainc(xf, d.lambda) - lgamma(xf))

method quantile*(d: PoissonDistribution, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 0)

method mean*(d: PoissonDistribution): float =
  d.lambda

method variance*(d: PoissonDistribution): float =
  d.lambda

method skewness*(d: PoissonDistribution): float =
  pow(d.lambda, -0.5)

method kurtosis*(d: PoissonDistribution): float =
  1.0 / d.lambda

method mode*(d: PoissonDistribution): seq[int] =
  @[int(d.lambda)]
