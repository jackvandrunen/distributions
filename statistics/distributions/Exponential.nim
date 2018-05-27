import ../distributions
import math
include ./utils

export distributions

type
  TExponential* = object
    beta*: float
    binv: float
    v: float

proc Exponential*(beta: float): TExponential =
  TExponential(beta: beta, binv: 1.0 / beta, v: beta * beta)

proc pdf*(d: TExponential, x: float): float =
  if x > 0.0:
    result = d.binv * exp(-x * d.binv)

proc cdf*(d: TExponential, x: float): float =
  if x > 0.0:
    result = 1.0 - exp(-x * d.binv)

proc quantile*(d: TExponential, q: float): float =
  checkNormal(q)
  -ln(1.0 - q) * d.beta

proc mean*(d: TExponential): float =
  d.beta

proc variance*(d: TExponential): float =
  d.v

converter toDistribution*(d: TExponential): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
