import ../distributions
import ../functions
import ../roots
import math
include ./utils

type
  TStudentT* = object
    nu*: float
    a: float
    b: float
    c: float

proc StudentT*(nu: float): TStudentT =
  TStudentT(nu: nu,
    a: -0.5 * (nu + 1.0),
    b: 1.0 / (sqrt(nu) * beta(0.5, 0.5 * nu)),
    c: 0.5 * nu)

proc pdf*(d: TStudentT, x: float): float =
  d.b * pow(1.0 + ((x * x) / d.nu), d.a)

proc cdf*(d: TStudentT, x: float): float =
  let x2 = x * x
  result = 0.5 * (betaincreg(x2 / (x2 + d.nu), 0.5, d.c) + 1.0)
  if x < 0.0:
    result = 1.0 - result

proc quantile*(d: TStudentT, q: float): float =
  checkNormal(q)
  findRoot(proc(x: float): float = d.cdf(x), q, 0.0)

proc mean*(d: TStudentT): float =
  if d.nu > 1.0:
    0.0
  else:
    raise newException(ValueError, "mean not defined for nu <= 1")

proc variance*(d: TStudentT): float =
  if d.nu > 2.0:
    d.nu / (d.nu - 2.0)
  else:
    raise newException(ValueError, "variance not defined for nu <= 2")

converter toDistribution*(d: TStudentT): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
