import ../distributions

type
  TPointMass*[T: SomeNumber] = object
    a*: T

proc PointMass*[T](a: T): TPointMass[T] =
  TPointMass[T](a: a)

proc pmf*[T](d: TPointMass[T], x: T): float =
  if x == d.a:
    result = 1.0

proc cdf*[T](d: TPointMass[T], x: T): float =
  if x >= d.a:
    result = 1.0

proc quantile*[T](d: TPointMass[T], q: float): T =
  checkNormal(q)
  d.a

converter toDistribution*[T](d: TPointMass[T]): IDistribution[T] =
  (
    pdf: proc(x: T): float = pmf(d, x),
    cdf: proc(x: T): float = cdf(d, x),
    quantile: proc(q: float): T = quantile(d, q)
  )
