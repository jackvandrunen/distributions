import ../distributions

type
  TUniform* = object
    a*: float
    b*: float
    r: float
    rinv: float

proc Uniform*(a, b: float): TUniform =
  TUniform(a: a, b: b, r: b - a, rinv: 1.0 / (b - a))

proc pdf*(d: TUniform, x: float): float =
  if d.a <= x and x <= d.b:
    result = d.rinv

proc cdf*(d: TUniform, x: float): float =
  min(1.0, max(0.0, (x - d.a) * d.rinv))

proc quantile*(d: TUniform, q: float): float =
  checkNormal(q)
  d.r * q

converter toDistribution*(d: TUniform): IDistribution[float] =
  (
    pdf: proc(x: float): float = pdf(d, x),
    cdf: proc(x: float): float = cdf(d, x),
    quantile: proc(q: float): float = quantile(d, q)
  )
