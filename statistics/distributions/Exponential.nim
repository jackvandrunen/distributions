import ../distributions
import math
import strformat
include ./utils

export distributions

type
  ExponentialDistribution* = ref object of Distribution[float]
    beta*: float

proc Exponential*(beta: float): ExponentialDistribution =
  ExponentialDistribution(beta: beta)

converter `$`*(d: ExponentialDistribution): string =
  fmt"Exponential({d.beta})"

method pdf*(d: ExponentialDistribution, x: float): float =
  if x > 0.0:
    result = exp(-x / d.beta) / d.beta

method cdf*(d: ExponentialDistribution, x: float): float =
  if x > 0.0:
    result = 1.0 - exp(-x / d.beta)

method quantile*(d: ExponentialDistribution, q: float): float =
  checkNormal(q)
  -ln(1.0 - q) * d.beta

method mean*(d: ExponentialDistribution): float =
  d.beta

method variance*(d: ExponentialDistribution): float =
  d.beta * d.beta

method skewness*(d: ExponentialDistribution): float =
  2.0

method kurtosis*(d: ExponentialDistribution): float =
  6.0

method mode*(d: ExponentialDistribution): seq[float] =
  @[0.0]
