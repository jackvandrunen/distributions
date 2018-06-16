import ../distributions
import ../functions
import ../roots
import math
import strformat
include ./utils

export distributions

type
  StudentTDistribution* = ref object of Distribution[float]
    nu*: float

proc StudentT*(nu: float): StudentTDistribution =
  StudentTDistribution(nu: nu)

converter `$`*(d: StudentTDistribution): string =
  fmt"StudentT({d.nu})"

method pdf*(d: StudentTDistribution, x: float): float =
  pow(1.0 + ((x * x) / d.nu), -0.5 * (d.nu + 1.0)) / (sqrt(d.nu) * beta(0.5, 0.5 * d.nu))

method cdf*(d: StudentTDistribution, x: float): float =
  let x2 = x * x
  result = 0.5 * (incbet(0.5, 0.5 * d.nu, x2 / (x2 + d.nu)) + 1.0)
  if x < 0.0:
    result = 1.0 - result

method quantile*(d: StudentTDistribution, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 0.0)

method mean*(d: StudentTDistribution): float =
  if d.nu > 1.0:
    0.0
  else:
    raise newException(ValueError, "mean not defined for nu <= 1")

method variance*(d: StudentTDistribution): float =
  if d.nu > 2.0:
    d.nu / (d.nu - 2.0)
  else:
    raise newException(ValueError, "variance not defined for nu <= 2")

method skewness*(d: StudentTDistribution): float =
  if d.nu > 3.0:
    0.0
  else:
    raise newException(ValueError, "skewness not defined for nu <= 3")

method kurtosis*(d: StudentTDistribution): float =
  if d.nu > 4.0:
    6.0 / (d.nu - 4.0)
  else:
    raise newException(ValueError, "kurtosis not defined for nu <= 4")

method mode*(d: StudentTDistribution): seq[float] =
  @[0.0]
