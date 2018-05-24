import ../distributions
import ../roots
import math

type
  TGeometric* = object
    p*: float
    q: float

proc Geometric*(p: float): TGeometric =
  TGeometric(p: p, q: 1.0 - p)

proc pmf*(d: TGeometric, x: int): float =
  if x > 0:
    result = d.p * pow(d.q, float(x - 1))

proc cdf*(d: TGeometric, x: int): float =
  if x > 0:
    result = 1.0 - pow(d.q, float(x))

proc quantile*(d: TGeometric, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 1)

converter toDistribution*(d: TGeometric): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q)
  )
