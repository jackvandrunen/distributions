import ../distributions
include ./utils

export distributions

type
  BernoulliDistribution* = ref object of Distribution[int]
    p*: float
    q: float
    v: float

proc Bernoulli*(p: float): BernoulliDistribution =
  BernoulliDistribution(p: p, q: 1.0 - p, v: p * (1.0 - p))

method pmf*(d: BernoulliDistribution, x: int): float =
  if x == 0:
    result = d.q
  elif x == 1:
    result = d.p

method cdf*(d: BernoulliDistribution, x: int): float =
  if x < 0: 0.0
  elif x < 1: d.q
  else: 1.0

method quantile*(d: BernoulliDistribution, q: float): int =
  checkNormal(q)
  if q < d.q: 0
  else: 1

method mean*(d: BernoulliDistribution): float =
  d.p

method variance*(d: BernoulliDistribution): float =
  d.v

method mode*(d: BernoulliDistribution): seq[int] =
  if d.q > d.q:
    @[0]
  elif d.q < d.p:
    @[1]
  else:
    @[0, 1]
