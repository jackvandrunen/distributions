import ../distributions
import ../roots
import math
include ./utils

export distributions

type
  PoissonDistribution* = ref object of Distribution[int]
    lambda*: float
    nlambda: float

proc Poisson*(lambda: float): PoissonDistribution =
  PoissonDistribution(lambda: lambda, nlambda: exp(-1.0 * lambda))

method pmf*(d: PoissonDistribution, x: int): float =
  if x >= 0:
    result = pow(d.lambda, float(x)) * d.nlambda / float(fac(x))

method cdf*(d: PoissonDistribution, x: int): float =
  for i in 0..x:
    result += pow(d.lambda, float(i)) / float(fac(i))
  result *= d.nlambda

method quantile*(d: PoissonDistribution, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 0)

method mean*(d: PoissonDistribution): float =
  d.lambda

method variance*(d: PoissonDistribution): float =
  d.lambda

method mode*(d: PoissonDistribution): seq[int] =
  @[int(d.lambda)]
