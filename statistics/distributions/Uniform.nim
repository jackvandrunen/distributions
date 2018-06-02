import ../distributions
import strformat
include ./utils

export distributions

type
  UniformDistribution* = ref object of Distribution[float]
    a*: float
    b*: float
    r: float
    rinv: float
    m: float
    v: float

proc Uniform*(a, b: float): UniformDistribution =
  UniformDistribution(a: a, b: b, r: b - a, rinv: 1.0 / (b - a),
    m: (a + b) / 2.0, v: ((b - a) * (b - a)) / 12.0)

converter `$`*(d: UniformDistribution): string =
  fmt"Uniform({d.a}, {d.b})"

method pdf*(d: UniformDistribution, x: float): float =
  if d.a <= x and x <= d.b:
    result = d.rinv

method cdf*(d: UniformDistribution, x: float): float =
  min(1.0, max(0.0, (x - d.a) * d.rinv))

method quantile*(d: UniformDistribution, q: float): float =
  checkNormal(q)
  d.r * q

method mean*(d: UniformDistribution): float =
  d.m

method variance*(d: UniformDistribution): float =
  d.v
