import ../distributions
include ./utils

export distributions

type
  TBernoulli* = object
    p*: float
    q: float
    v: float

proc Bernoulli*(p: float): TBernoulli =
  TBernoulli(p: p, q: 1.0 - p, v: p * (1.0 - p))

proc pmf*(d: TBernoulli, x: int): float =
  if x == 0:
    result = d.q
  elif x == 1:
    result = d.p

proc cdf*(d: TBernoulli, x: int): float =
  if x < 0: 0.0
  elif x < 1: d.q
  else: 1.0

proc quantile*(d: TBernoulli, q: float): int =
  checkNormal(q)
  if q < d.q: 0
  else: 1

proc mean*(d: TBernoulli): float =
  d.p

proc variance*(d: TBernoulli): float =
  d.v

converter toDistribution*(d: TBernoulli): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
