import ../distributions
import math
import strformat
include ./utils

export distributions

type
  BernoulliDistribution* = ref object of Distribution[int]
    p*: float

proc Bernoulli*(p: float): BernoulliDistribution =
  BernoulliDistribution(p: p)

converter `$`*(d: BernoulliDistribution): string =
  fmt"Bernoulli({d.p})"

method pmf*(d: BernoulliDistribution, x: int): float =
  if x == 0:
    result = 1.0 - d.p
  elif x == 1:
    result = d.p

method cdf*(d: BernoulliDistribution, x: int): float =
  if x < 0: 0.0
  elif x < 1: 1.0 - d.p
  else: 1.0

method quantile*(d: BernoulliDistribution, q: float): int =
  checkNormal(q)
  if q < 1.0 - d.p: 0
  else: 1

method mean*(d: BernoulliDistribution): float =
  d.p

method variance*(d: BernoulliDistribution): float =
  d.p * (1.0 - d.p)

method skewness*(d: BernoulliDistribution): float =
  (1.0 - (2.0 * d.p)) / sqrt(d.p * (1.0 - d.p))

method kurtosis*(d: BernoulliDistribution): float =
  let pq = d.p * (1.0 - d.p)
  (1.0 - (6 * pq)) / pq

method mode*(d: BernoulliDistribution): seq[int] =
  if d.p < 0.5:
    @[0]
  elif d.p > 0.5:
    @[1]
  else:
    @[0, 1]
