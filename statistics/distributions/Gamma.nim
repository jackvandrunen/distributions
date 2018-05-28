import ../distributions
import ../functions
import ../roots
import math
include ./utils

export distributions

type
  GammaDistribution* = ref object of Distribution[float]
    alpha*: float
    beta*: float
    ga: float
    srinv: float
    aprev: float
    binv: float
    m: float
    v: float

proc Gamma*(alpha: float, beta: float): GammaDistribution =
  GammaDistribution(alpha: alpha, beta: beta,
    ga: lgamma(alpha),
    srinv: (-alpha * ln(beta)) - lgamma(alpha),
    aprev: alpha - 1.0,
    binv: 1.0 / beta,
    m: alpha * beta, v: alpha * (beta * beta))

method pdf*(d: GammaDistribution, x: float): float =
  if x > 0.0:
    result = exp(d.srinv + (d.aprev * ln(x)) + (-x * d.binv))

method cdf*(d: GammaDistribution, x: float): float =
  if x > 0.0:
    result = exp(lgammainc(d.alpha, x * d.binv) - d.ga)

method quantile*(d: GammaDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 1.0)

method mean*(d: GammaDistribution): float =
  d.m

method variance*(d: GammaDistribution): float =
  d.v
