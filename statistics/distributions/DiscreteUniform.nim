import ../distributions
include ./utils

export distributions

type
  TDiscreteUniform* = object
    k*: int
    kf: float
    kinv: float
    m: float
    v: float

proc DiscreteUniform*(k: int): TDiscreteUniform =
  TDiscreteUniform(k: k, kf: float(k), kinv: 1.0 / float(k),
    m: float(1 + k) / 2.0, v: float((k - 1) * (k - 1)) / 12.0)

proc pmf*(d: TDiscreteUniform, x: int): float =
  if 1 <= x and x <= d.k:
    result = d.kinv

proc cdf*(d: TDiscreteUniform, x: int): float =
  min(1.0, max(0.0, d.kinv * float(x)))

proc quantile*(d: TDiscreteUniform, q: float): int =
  checkNormal(q)
  int(d.kf * q) + 1

proc mean*(d: TDiscreteUniform): float =
  d.m

proc variance*(d: TDiscreteUniform): float =
  d.v

converter toDistribution*(d: TDiscreteUniform): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
