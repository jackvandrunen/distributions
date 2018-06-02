import ../distributions
import ../functions
import math
import strformat
include ./utils

export distributions

type
  LogNormalDistribution* = ref object of Distribution[float]
    mu*: float
    sigma*: float
    v: float
    dnorm: float
    vnorm: float
    r2v: float

proc LogNormal*(mean: float, variance: float): LogNormalDistribution =
  let sigma = sqrt(variance)
  LogNormalDistribution(mu: mean, sigma: sigma, v: variance,
    dnorm: 1.0 / (sqrt(2.0 * PI) * sigma),
    vnorm: 1.0 / (2.0 * variance),
    r2v: sqrt(2.0) * sigma)

converter `$`*(d: LogNormalDistribution): string =
  fmt"LogNormal({d.mu}, {d.v})"

method pdf*(d: LogNormalDistribution, x: float): float =
  if x > 0.0:
    let xm = ln(x) - d.mu
    result = d.dnorm / (x * exp(d.vnorm * (xm * xm)))

method cdf*(d: LogNormalDistribution, x: float): float =
  if x > 0.0:
    result = 0.5 * erfc(-(ln(x) - d.mu) / d.r2v)

method quantile*(d: LogNormalDistribution, q: float): float =
  checkNormal(q)
  exp(d.mu + (d.r2v * erfinv((2.0 * q) - 1.0)))

method mean*(d: LogNormalDistribution): float =
  exp(d.mu)

method variance*(d: LogNormalDistribution): float =
  (exp(d.v) - 1.0) * exp((2.0 * d.mu) + d.v)

method mode*(d: LogNormalDistribution): seq[float] =
  @[exp(d.mu - d.v)]
