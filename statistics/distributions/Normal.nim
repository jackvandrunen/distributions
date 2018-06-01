import ../distributions
import ../functions
import math
include ./utils

export distributions

type
  NormalDistribution* = ref object of Distribution[float]
    mu*: float
    sigma*: float
    v: float
    dnorm: float
    vnorm: float
    r2v: float

proc Normal*(mean: float, variance: float): NormalDistribution =
  let sigma = sqrt(variance)
  NormalDistribution(mu: mean, sigma: sigma, v: variance,
    dnorm: 1.0 / (sqrt(2.0 * PI) * sigma),
    vnorm: 1.0 / (2.0 * variance),
    r2v: sqrt(2.0) * sigma)

method pdf*(d: NormalDistribution, x: float): float =
  let xm = x - d.mu
  d.dnorm / exp(d.vnorm * (xm * xm))

method cdf*(d: NormalDistribution, x: float): float =
  0.5 * (1.0 + erf((x - d.mu) / d.r2v))

method quantile*(d: NormalDistribution, q: float): float =
  checkNormal(q)
  d.mu + (d.r2v * erfinv((2.0 * q) - 1.0))

method mean*(d: NormalDistribution): float =
  d.mu

method variance*(d: NormalDistribution): float =
  d.v

method mode*(d: NormalDistribution): seq[float] =
  @[d.mu]
