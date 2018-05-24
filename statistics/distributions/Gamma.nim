import ../distributions
import ../functions
import ../roots
import math

type
  TGamma* = object
    alpha*: float
    beta*: float
    ga: float
    srinv: float
    aprev: float
    binv: float

proc Gamma*(alpha: float, beta: float): TGamma =
  TGamma(alpha: alpha, beta: beta,
    ga: lgamma(alpha),
    srinv: (-alpha * ln(beta)) - lgamma(alpha),
    aprev: alpha - 1.0,
    binv: 1.0 / beta)

proc pdf*(d: TGamma, x: float): float =
  if x > 0.0:
    result = exp(d.srinv + (d.aprev * ln(x)) + (-x * d.binv))

proc cdf*(d: TGamma, x: float): float =
  if x > 0.0:
    result = exp(lgammainc(d.alpha, x * d.binv) - d.ga)

proc quantile*(d: TGamma, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 1.0)

converter toDistribution*(d: TGamma): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q)
  )
