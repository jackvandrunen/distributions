import ../distributions
import ../functions
import ../roots
import math

type
  TChiSquared* = object
    p*: int
    pf: float
    a: float
    b: float
    c: float

proc ChiSquared*(p: int): TChiSquared =
  let a = 0.5 * float(p)
  let b = exp(-lgamma(a))
  TChiSquared(p: p, pf: float(p),
    a: a,
    b: b,
    c: b / pow(2.0, a))

proc pdf*(d: TChiSquared, x: float): float =
  if x > 0.0:
    result = d.c * pow(x, d.a - 1.0) * exp(-0.5 * x)

proc cdf*(d: TChiSquared, x: float): float =
  if x > 0.0:
    result = exp(ln(d.b) + lgammainc(d.a, 0.5 * x))

proc quantile*(d: TChiSquared, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, d.pf)

converter toDistribution*(d: TChiSquared): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q)
  )
