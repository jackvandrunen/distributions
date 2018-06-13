import ../distributions
import strformat
include ./utils

export distributions

type
  UniformDistribution* = ref object of Distribution[float]
    a*: float
    b*: float

proc Uniform*(a, b: float): UniformDistribution =
  UniformDistribution(a: a, b: b)

converter `$`*(d: UniformDistribution): string =
  fmt"Uniform({d.a}, {d.b})"

method pdf*(d: UniformDistribution, x: float): float =
  if d.a <= x and x <= d.b:
    result = 1.0 / (d.b - d.a)

method cdf*(d: UniformDistribution, x: float): float =
  min(1.0, max(0.0, (x - d.a) / (d.b - d.a)))

method quantile*(d: UniformDistribution, q: float): float =
  checkNormal(q)
  (d.b - d.a) * q

method mean*(d: UniformDistribution): float =
  (d.a + d.b) / 2.0

method variance*(d: UniformDistribution): float =
  let ba = d.b - d.a
  (ba * ba) / 12.0

method skewness*(d: UniformDistribution): float =
  0.0

method kurtosis*(d: UniformDistribution): float =
  -1.2
