import ../distributions
import ../functions
import ../roots
import math
include ./utils

type
  TBeta* = object
    alpha*: float
    beta*: float
    aprev: float
    bprev: float
    bab: float
    m: float
    v: float

proc Beta*(alpha: float, beta: float): TBeta =
  TBeta(alpha: alpha, beta: beta,
    aprev: alpha - 1.0,
    bprev: beta - 1.0,
    bab: 1.0 / beta(alpha, beta),
    m: alpha / (alpha + beta),
    v: alpha * beta / ((alpha + beta) * (alpha + beta) * (alpha + beta + 1)))

proc pdf*(d: TBeta, x: float): float =
  if x > 0.0 and x < 1.0:
    result = pow(x, d.aprev) * pow(1.0 - x, d.bprev) * d.bab

proc cdf*(d: TBeta, x: float): float =
  if x > 0.0 and x < 1.0:
    result = betaincreg(x, d.alpha, d.beta)
  if x >= 1.0:
    result = 1.0

proc quantile*(d: TBeta, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 0.5)

proc mean*(d: TBeta): float =
  d.m

proc variance*(d: TBeta): float =
  d.v

converter toDistribution*(d: TBeta): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
