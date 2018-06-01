import ../distributions
import ../roots
import math
include ./utils

export distributions

type
  BinomialDistribution* = ref object of Distribution[int]
    n*: int
    p*: float
    q: float
    m: float
    v: float

proc Binomial*(n: int, p: float): BinomialDistribution =
  BinomialDistribution(n: n, p: p, q: 1.0 - p, m: float(n) * p, v: float(n) * p * (1.0 - p))

method pmf*(d: BinomialDistribution, x: int): float =
  if x >= 0:
    result = float(binom(d.n, x)) * pow(d.p, float(x)) * pow(d.q, float(d.n - x))

method cdf*(d: BinomialDistribution, x: int): float =
  for i in 0..x:
    result += float(binom(d.n, i)) * pow(d.p, float(i)) * pow(d.q, float(d.n - i))

method quantile*(d: BinomialDistribution, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 0)

method mean*(d: BinomialDistribution): float =
  d.m

method variance*(d: BinomialDistribution): float =
  d.v

method mode*(d: BinomialDistribution): seq[int] =
  @[int(float(d.n + 1) * d.p)]
