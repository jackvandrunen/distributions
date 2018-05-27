import ../distributions
import math
include ./utils

export distributions

type
  TCauchy* = object

proc Cauchy*(): TCauchy =
  TCauchy()

proc pdf*(d: TCauchy, x: float): float =
  1.0 / (PI * (1.0 + (x * x)))

proc cdf*(d: TCauchy, x: float): float =
  (arctan(x) / PI) + 0.5

proc quantile*(d: TCauchy, q: float): float =
  checkNormal(q)
  tan((q - 0.5) * PI)

proc mean*(d: TCauchy): float =
  raise newException(ValueError, "mean not defined")

proc variance*(d: TCauchy): float =
  raise newException(ValueError, "variance not defined")

converter toDistribution*(d: TCauchy): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
