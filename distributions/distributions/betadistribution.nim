import ../basedistribution
import ../functions
import ../roots
import math
import strformat
include ./utils

export basedistribution

type
  BetaDistribution* = ref object of Distribution[float]
    alpha*: float
    beta*: float

proc Beta*(alpha: float, beta: float): BetaDistribution =
  BetaDistribution(alpha: alpha, beta: beta)

converter `$`*(d: BetaDistribution): string =
  fmt"Beta({d.alpha}, {d.beta})"

method pdf*(d: BetaDistribution, x: float): float =
  if x > 0.0 and x < 1.0:
    result = pow(x, d.alpha - 1.0) * pow(1.0 - x, d.beta - 1.0) / beta(d.alpha, d.beta)

method cdf*(d: BetaDistribution, x: float): float =
  if x > 0.0 and x < 1.0:
    result = incbet(d.alpha, d.beta, x)
  if x >= 1.0:
    result = 1.0

method quantile*(d: BetaDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 0.5)

method mean*(d: BetaDistribution): float =
  d.alpha / (d.alpha + d.beta)

method variance*(d: BetaDistribution): float =
  let ab = d.alpha + d.beta
  d.alpha * d.beta / (ab * ab * (ab + 1.0))

method skewness*(d: BetaDistribution): float =
  2.0 * (d.beta - d.alpha) * sqrt(d.alpha + d.beta + 1.0) /
    ((d.alpha + d.beta + 2.0) * sqrt(d.alpha * d.beta))

method kurtosis*(d: BetaDistribution): float =
  let amb = d.alpha - d.beta
  let apb = d.alpha + d.beta
  let atb = d.alpha * d.beta
  6.0 * ((amb * amb * (apb + 1.0)) - (atb * (apb + 2.0))) /
    (atb * (apb + 2.0) * (apb + 3.0))

method mode*(d: BetaDistribution): seq[float] =
  if d.alpha >= 1.0 and d.beta >= 1.0:
    return @[(d.alpha - 1.0) / (d.alpha + d.beta - 2)]
  raise newException(ValueError, "Mode not well-defined for parameters")
