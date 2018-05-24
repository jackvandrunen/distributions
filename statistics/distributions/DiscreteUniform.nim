import ../distributions

type
  TDiscreteUniform* = object
    k*: int
    kf: float
    kinv: float

proc DiscreteUniform*(k: int): TDiscreteUniform =
  TDiscreteUniform(k: k, kf: float(k), kinv: 1.0 / float(k))

proc pmf*(d: TDiscreteUniform, x: int): float =
  if 1 <= x and x <= d.k:
    result = d.kinv

proc cdf*(d: TDiscreteUniform, x: int): float =
  min(1.0, max(0.0, d.kinv * float(x)))

proc quantile*(d: TDiscreteUniform, q: float): int =
  checkNormal(q)
  int(d.kf * q) + 1

converter toDistribution*(d: TDiscreteUniform): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q)
  )
