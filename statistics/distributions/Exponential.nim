import ../distributions
import math

type
  TExponential* = object
    beta*: float
    binv: float

proc Exponential*(beta: float): TExponential =
  TExponential(beta: beta, binv: 1.0 / beta)

proc pdf*(d: TExponential, x: float): float =
  if x > 0.0:
    result = d.binv * exp(-x * d.binv)

proc cdf*(d: TExponential, x: float): float =
  if x > 0.0:
    result = 1.0 - exp(-x * d.binv)

proc quantile*(d: TExponential, q: float): float =
  checkNormal(q)
  -ln(1.0 - q) * d.beta

converter toDistribution*(d: TExponential): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q)
  )
