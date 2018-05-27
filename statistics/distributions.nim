import math

type
  Distribution*[T] = concept d
    d.pdf(T) is float
    d.cdf(T) is float
    d.quantile(float) is T
    d.mean() is float
    d.variance() is float
  IDistribution*[T: SomeNumber] = tuple[
    pdf: proc(x: T): float,
    cdf: proc(x: T): float,
    quantile: proc(q: float): T,
    mean: proc(): float,
    variance: proc(): float
  ]

proc median*[T](d: Distribution[T]): T =
  d.quantile(0.5)

proc std*[T](d: Distribution[T]): float =
  sqrt(d.variance())
