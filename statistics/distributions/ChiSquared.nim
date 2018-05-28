import ../distributions
import ../functions
import ../roots
import math
include ./utils

export distributions

type
  ChiSquaredDistribution* = ref object of Distribution[float]
    p*: int
    pf: float
    a: float
    b: float
    c: float

proc ChiSquared*(p: int): ChiSquaredDistribution =
  let a = 0.5 * float(p)
  let b = exp(-lgamma(a))
  ChiSquaredDistribution(p: p, pf: float(p),
    a: a,
    b: b,
    c: b / pow(2.0, a))

method pdf*(d: ChiSquaredDistribution, x: float): float =
  if x > 0.0:
    result = d.c * pow(x, d.a - 1.0) * exp(-0.5 * x)

method cdf*(d: ChiSquaredDistribution, x: float): float =
  if x > 0.0:
    result = exp(ln(d.b) + lgammainc(d.a, 0.5 * x))

method quantile*(d: ChiSquaredDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, d.pf)

method mean*(d: ChiSquaredDistribution): float =
  d.pf

method variance*(d: ChiSquaredDistribution): float =
  2.0 * d.pf
