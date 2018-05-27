import ../distributions
import ../roots
import math
include ./utils

type
  TGeometric* = object
    p*: float
    q: float
    m: float
    v: float

proc Geometric*(p: float): TGeometric =
  TGeometric(p: p, q: 1.0 - p, m: 1.0 / p, v: (1.0 - p) / (p * p))

proc pmf*(d: TGeometric, x: int): float =
  if x > 0:
    result = d.p * pow(d.q, float(x - 1))

proc cdf*(d: TGeometric, x: int): float =
  if x > 0:
    result = 1.0 - pow(d.q, float(x))

proc quantile*(d: TGeometric, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 1)

proc mean*(d: TGeometric): float =
  d.m

proc variance*(d: TGeometric): float =
  d.v

converter toDistribution*(d: TGeometric): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
