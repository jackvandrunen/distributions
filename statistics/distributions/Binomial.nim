import ../distributions
import ../roots
import math
include ./utils

export distributions

type
  TBinomial* = object
    n*: int
    p*: float
    q: float
    m: float
    v: float

proc Binomial*(n: int, p: float): TBinomial =
  TBinomial(n: n, p: p, q: 1.0 - p, m: float(n) * p, v: float(n) * p * (1.0 - p))

proc pmf*(d: TBinomial, x: int): float =
  if x >= 0:
    result = float(binom(d.n, x)) * pow(d.p, float(x)) * pow(d.q, float(d.n - x))

proc cdf*(d: TBinomial, x: int): float =
  for i in 0..x:
    result += float(binom(d.n, i)) * pow(d.p, float(i)) * pow(d.q, float(d.n - i))

proc quantile*(d: TBinomial, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 0)

proc mean*(d: TBinomial): float =
  d.m

proc variance*(d: TBinomial): float =
  d.v

converter toDistribution*(d: TBinomial): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
