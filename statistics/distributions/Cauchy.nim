import ../distributions
import math
include ./utils

export distributions

type
  CauchyDistribution* = ref object of Distribution[float]

proc Cauchy*(): CauchyDistribution =
  CauchyDistribution()

method pdf*(d: CauchyDistribution, x: float): float =
  1.0 / (PI * (1.0 + (x * x)))

method cdf*(d: CauchyDistribution, x: float): float =
  (arctan(x) / PI) + 0.5

method quantile*(d: CauchyDistribution, q: float): float =
  checkNormal(q)
  tan((q - 0.5) * PI)
