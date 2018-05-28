import ../distributions
import ../roots
import math
include ./utils

export distributions

type
  GeometricDistribution* = ref object of Distribution[int]
    p*: float
    q: float
    m: float
    v: float

proc Geometric*(p: float): GeometricDistribution =
  GeometricDistribution(p: p, q: 1.0 - p, m: 1.0 / p, v: (1.0 - p) / (p * p))

method pmf*(d: GeometricDistribution, x: int): float =
  if x > 0:
    result = d.p * pow(d.q, float(x - 1))

method cdf*(d: GeometricDistribution, x: int): float =
  if x > 0:
    result = 1.0 - pow(d.q, float(x))

method quantile*(d: GeometricDistribution, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 1)

method mean*(d: GeometricDistribution): float =
  d.m

method variance*(d: GeometricDistribution): float =
  d.v
