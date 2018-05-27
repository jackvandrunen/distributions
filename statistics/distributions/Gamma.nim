import ../distributions
import ../functions
import ../roots
import math
include ./utils

export distributions

type
  TGamma* = object
    alpha*: float
    beta*: float
    ga: float
    srinv: float
    aprev: float
    binv: float
    m: float
    v: float

proc Gamma*(alpha: float, beta: float): TGamma =
  TGamma(alpha: alpha, beta: beta,
    ga: lgamma(alpha),
    srinv: (-alpha * ln(beta)) - lgamma(alpha),
    aprev: alpha - 1.0,
    binv: 1.0 / beta,
    m: alpha * beta, v: alpha * (beta * beta))

proc pdf*(d: TGamma, x: float): float =
  if x > 0.0:
    result = exp(d.srinv + (d.aprev * ln(x)) + (-x * d.binv))

proc cdf*(d: TGamma, x: float): float =
  if x > 0.0:
    result = exp(lgammainc(d.alpha, x * d.binv) - d.ga)

proc quantile*(d: TGamma, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 1.0)

proc mean*(d: TGamma): float =
  d.m

proc variance*(d: TGamma): float =
  d.v

converter toDistribution*(d: TGamma): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
