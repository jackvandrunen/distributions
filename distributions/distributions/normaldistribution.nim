import ../basedistribution
import ../functions
import math
import strformat
include ./utils

export basedistribution

type
  NormalDistribution* = ref object of Distribution[float]
    m*: float
    v*: float

let Z* = NormalDistribution(m: 0.0, v: 1.0)

proc Normal*(mean: float, variance: float): NormalDistribution =
  NormalDistribution(m: mean, v: variance)

converter `$`*(d: NormalDistribution): string =
  fmt"Normal({d.m}, {d.v})"

method pdf*(d: NormalDistribution, x: float): float =
  let xm = x - d.m
  1.0 / (sqrt(TAU * d.v) * exp((xm * xm) / (2.0 * d.v)))

method cdf*(d: NormalDistribution, x: float): float =
  0.5 * (1.0 + erf((x - d.m) / sqrt(2.0 * d.v)))

method quantile*(d: NormalDistribution, q: float): float =
  checkNormal(q)
  d.m + (sqrt(2.0 * d.v) * erfinv((2.0 * q) - 1.0))

method mean*(d: NormalDistribution): float =
  d.m

method variance*(d: NormalDistribution): float =
  d.v

method skewness*(d: NormalDistribution): float =
  0.0

method kurtosis*(d: NormalDistribution): float =
  0.0

method mode*(d: NormalDistribution): seq[float] =
  @[d.m]
