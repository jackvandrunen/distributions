import ../distributions
import ../functions
import math

type
  TNormal* = object
    mu*: float
    sigma*: float
    dnorm: float
    vnorm: float
    r2v: float

proc Normal*(mu: float, sigma: float): TNormal =
  TNormal(mu: mu, sigma: sigma,
    dnorm: 1.0 / (sqrt(2.0 * PI) * sigma),
    vnorm: 1.0 / (2.0 * (sigma * sigma)),
    r2v: sqrt(2.0) * sigma)

proc pdf*(d: TNormal, x: float): float =
  let xm = x - d.mu
  d.dnorm / exp(d.vnorm * (xm * xm))

proc cdf*(d: TNormal, x: float): float =
  0.5 * (1.0 + erf((x - d.mu) / d.r2v))

proc quantile*(d: TNormal, q: float): float =
  checkNormal(q)
  d.mu + (d.r2v * erfinv((2.0 * q) - 1.0))

converter toDistribution*(d: TNormal): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q)
  )
