import ../distributions
import ../functions
import math
import strformat
include ./utils

export distributions

type
  LogNormalDistribution* = ref object of Distribution[float]
    m*: float
    v*: float

proc LogNormal*(m: float, v: float): LogNormalDistribution =
  LogNormalDistribution(m: m, v: v)

converter `$`*(d: LogNormalDistribution): string =
  fmt"LogNormal({d.m}, {d.v})"

method pdf*(d: LogNormalDistribution, x: float): float =
  if x > 0.0:
    let xm = ln(x) - d.m
    result = 1.0 / (sqrt(TAU * d.v) * x * exp((xm * xm) / (2.0 * d.v)))

method cdf*(d: LogNormalDistribution, x: float): float =
  if x > 0.0:
    result = 0.5 * erfc(-(ln(x) - d.m) / sqrt(2.0 * d.v))

method quantile*(d: LogNormalDistribution, q: float): float =
  checkNormal(q)
  exp(d.m + (sqrt(2.0 * d.v) * erfinv((2.0 * q) - 1.0)))

method mean*(d: LogNormalDistribution): float =
  exp(d.m)

method variance*(d: LogNormalDistribution): float =
  (exp(d.v) - 1.0) * exp((2.0 * d.m) + d.v)

method skewness*(d: LogNormalDistribution): float =
  let ev = exp(d.v)
  (ev + 2.0) * sqrt(ev - 1)

method kurtosis*(d: LogNormalDistribution): float =
  exp(4.0 * d.v) + (2.0 * exp(3.0 * d.v)) + (3.0 * exp(2.0 * d.v)) - 6.0

method mode*(d: LogNormalDistribution): seq[float] =
  @[exp(d.m - d.v)]
