import ../distributions
import math
include ./utils

export distributions

type
  ExponentialDistribution* = ref object of Distribution[float]
    beta*: float
    binv: float
    v: float

proc Exponential*(beta: float): ExponentialDistribution =
  ExponentialDistribution(beta: beta, binv: 1.0 / beta, v: beta * beta)

method pdf*(d: ExponentialDistribution, x: float): float =
  if x > 0.0:
    result = d.binv * exp(-x * d.binv)

method cdf*(d: ExponentialDistribution, x: float): float =
  if x > 0.0:
    result = 1.0 - exp(-x * d.binv)

method quantile*(d: ExponentialDistribution, q: float): float =
  checkNormal(q)
  -ln(1.0 - q) * d.beta

method mean*(d: ExponentialDistribution): float =
  d.beta

method variance*(d: ExponentialDistribution): float =
  d.v

method mode*(d: ExponentialDistribution): seq[float] =
  @[0.0]
