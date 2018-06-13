import ../distributions
import strformat
include ./utils

export distributions

type
  DiscreteUniformDistribution* = ref object of Distribution[int]
    k*: int

proc DiscreteUniform*(k: int): DiscreteUniformDistribution =
  DiscreteUniformDistribution(k: k)

converter `$`*(d: DiscreteUniformDistribution): string =
  fmt"DiscreteUniform({d.k})"

method pmf*(d: DiscreteUniformDistribution, x: int): float =
  if 1 <= x and x <= d.k:
    result = 1.0 / float(d.k)

method cdf*(d: DiscreteUniformDistribution, x: int): float =
  min(1.0, max(0.0, float(x) / float(d.k)))

method quantile*(d: DiscreteUniformDistribution, q: float): int =
  checkNormal(q)
  int(float(d.k) * q) + 1

method mean*(d: DiscreteUniformDistribution): float =
  0.5 * float(1 + d.k)

method variance*(d: DiscreteUniformDistribution): float =
  let kprev = float(d.k - 1)
  float(kprev * kprev / 12.0)

method skewness*(d: DiscreteUniformDistribution): float =
  0.0

method kurtosis*(d: DiscreteUniformDistribution): float =
  let k2 = float(d.k * d.k)
  -6.0 * (k2 + 1) / (5.0 * (k2 - 1))
