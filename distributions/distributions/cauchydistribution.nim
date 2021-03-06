import ../basedistribution
import math
import strformat
include ./utils

export basedistribution

type
  CauchyDistribution* = ref object of Distribution[float]

proc Cauchy*(): CauchyDistribution =
  CauchyDistribution()

converter `$`*(d: CauchyDistribution): string =
  fmt"Cauchy()"

method pdf*(d: CauchyDistribution, x: float): float =
  1.0 / (PI * (1.0 + (x * x)))

method cdf*(d: CauchyDistribution, x: float): float =
  (arctan(x) / PI) + 0.5

method quantile*(d: CauchyDistribution, q: float): float =
  checkNormal(q)
  tan((q - 0.5) * PI)

method mode*(d: CauchyDistribution): seq[float] =
  @[0.0]
