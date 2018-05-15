type
  FloatDistribution* = object
    pdf*: proc(x: float): float
    cdf*: proc(x: float): float
    quantile*: proc(q: float): float
  IntDistribution* = object
    pmf*: proc(x: int): float
    cdf*: proc(x: int): float
    quantile*: proc(q: float): int

template checkNormal(x: float) =
  if not (0.0 < x and x < 1.0):
    raise newException(ValueError, "Quantile function is defined on (0,1)")

proc pdf*(d: FloatDistribution, x: float): float {.inline.} =
  d.pdf(x)

proc pdf*(d: FloatDistribution): (proc(x: float): float) {.inline.} =
  d.pdf

proc pmf*(d: IntDistribution, x: int): float {.inline.} =
  d.pmf(x)

proc pmf*(d: IntDistribution): (proc(x: int): float) {.inline.} =
  d.pmf

proc cdf*(d: FloatDistribution, x: float): float {.inline.} =
  d.cdf(x)

proc cdf*(d: FloatDistribution): (proc(x: float): float) {.inline.} =
  d.cdf

proc cdf*(d: IntDistribution, x: int): float {.inline.} =
  d.cdf(x)

proc cdf*(d: IntDistribution): (proc(x: int): float) {.inline.} =
  d.cdf

proc quantile*(d: FloatDistribution, q: float): float {.inline.} =
  checkNormal(q)
  d.quantile(q)

proc quantile*(d: FloatDistribution): (proc(q: float): float) {.inline.} =
  d.quantile

proc quantile*(d: IntDistribution, q: float): int {.inline.} =
  checkNormal(q)
  d.quantile(q)

proc quantile*(d: IntDistribution): (proc(q: float): int) {.inline.} =
  d.quantile
