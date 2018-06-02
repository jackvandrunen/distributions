import ../distributions
import ../functions
import ../roots
import math
import strformat
include ./utils

export distributions

type
  BetaDistribution* = ref object of Distribution[float]
    alpha*: float
    beta*: float
    aprev: float
    bprev: float
    bab: float
    m: float
    v: float

proc Beta*(alpha: float, beta: float): BetaDistribution =
  BetaDistribution(alpha: alpha, beta: beta,
    aprev: alpha - 1.0,
    bprev: beta - 1.0,
    bab: 1.0 / beta(alpha, beta),
    m: alpha / (alpha + beta),
    v: alpha * beta / ((alpha + beta) * (alpha + beta) * (alpha + beta + 1)))

converter `$`*(d: BetaDistribution): string =
  fmt"Beta({d.alpha}, {d.beta})"

method pdf*(d: BetaDistribution, x: float): float =
  if x > 0.0 and x < 1.0:
    result = pow(x, d.aprev) * pow(1.0 - x, d.bprev) * d.bab

method cdf*(d: BetaDistribution, x: float): float =
  if x > 0.0 and x < 1.0:
    result = betaincreg(x, d.alpha, d.beta)
  if x >= 1.0:
    result = 1.0

method quantile*(d: BetaDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 0.5)

method mean*(d: BetaDistribution): float =
  d.m

method variance*(d: BetaDistribution): float =
  d.v

method mode*(d: BetaDistribution): seq[float] =
  if d.alpha >= 1.0 and d.beta >= 1.0:
    return @[d.aprev / (d.alpha + d.beta - 2)]
  raise newException(ValueError, "Mode not well-defined for parameters")
