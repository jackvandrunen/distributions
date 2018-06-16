import ../distributions
import ../functions
import ../roots
import math
import strformat
include ./utils

export distributions

type
  GammaDistribution* = ref object of Distribution[float]
    alpha*: float
    beta*: float

proc Gamma*(alpha: float, beta: float): GammaDistribution =
  GammaDistribution(alpha: alpha, beta: beta)

converter `$`*(d: GammaDistribution): string =
  fmt"Gamma({d.alpha}, {d.beta})"

method pdf*(d: GammaDistribution, x: float): float =
  if x > 0.0:
    result = exp(((d.alpha * ln(d.beta)) - lgamma(d.alpha)) + ((d.alpha - 1.0) * ln(x)) + (-x * d.beta))

method cdf*(d: GammaDistribution, x: float): float =
  if x > 0.0:
    result = igam(d.alpha, x * d.beta)

method quantile*(d: GammaDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 1.0)

method mean*(d: GammaDistribution): float =
  d.alpha / d.beta

method variance*(d: GammaDistribution): float =
  d.alpha / (d.beta * d.beta)

method skewness*(d: GammaDistribution): float =
  2.0 / sqrt(d.alpha)

method kurtosis*(d: GammaDistribution): float =
  6.0 / d.alpha

method mode*(d: GammaDistribution): seq[float] =
  if d.alpha >= 1.0:
    return @[(d.alpha - 1.0) / d.beta]
  raise newException(ValueError, "Mode not well-defined for parameters")
