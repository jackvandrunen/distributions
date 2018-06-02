import ../distributions
import strformat
include ./utils

export distributions

type
  DiscreteUniformDistribution* = ref object of Distribution[int]
    k*: int
    kf: float
    kinv: float
    m: float
    v: float

proc DiscreteUniform*(k: int): DiscreteUniformDistribution =
  DiscreteUniformDistribution(k: k, kf: float(k), kinv: 1.0 / float(k),
    m: float(1 + k) / 2.0, v: float((k - 1) * (k - 1)) / 12.0)

converter `$`*(d: DiscreteUniformDistribution): string =
  fmt"DiscreteUniform({d.k})"

method pmf*(d: DiscreteUniformDistribution, x: int): float =
  if 1 <= x and x <= d.k:
    result = d.kinv

method cdf*(d: DiscreteUniformDistribution, x: int): float =
  min(1.0, max(0.0, d.kinv * float(x)))

method quantile*(d: DiscreteUniformDistribution, q: float): int =
  checkNormal(q)
  int(d.kf * q) + 1

method mean*(d: DiscreteUniformDistribution): float =
  d.m

method variance*(d: DiscreteUniformDistribution): float =
  d.v
