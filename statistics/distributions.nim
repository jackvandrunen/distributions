import math

type
  Distribution*[T: SomeNumber] = ref object {.inheritable.}

method pmf*[T](d: Distribution[T], x: T): float {.base.} =
  raise newException(ValueError, "not implemented")

method pdf*[T](d: Distribution[T], x: T): float {.base.} =
  raise newException(ValueError, "not implemented")

method cdf*[T](d: Distribution[T], x: T): float {.base.} =
  raise newException(ValueError, "not implemented")

method quantile*[T](d: Distribution[T], q: float): T {.base.} =
  raise newException(ValueError, "not implemented")

method mean*[T](d: Distribution[T]): float {.base.} =
  raise newException(ValueError, "not implemented")

method variance*[T](d: Distribution[T]): float {.base.} =
  raise newException(ValueError, "not implemented")

method skewness*[T](d: Distribution[T]): float {.base.} =
  raise newException(ValueError, "not implemented")

method kurtosis*[T](d: Distribution[T]): float {.base.} =
  raise newException(ValueError, "not implemented")

method mode*[T](d: Distribution[T]): seq[T] {.base.} =
  raise newException(ValueError, "not implemented")

method moment*[T](d: Distribution[T], n: float): float {.base.} =
  raise newException(ValueError, "not implemented")

method centralMoment*[T](d: Distribution[T], n: float): float {.base.} =
  raise newException(ValueError, "not implemented")

method standardizedMoment*[T](d: Distribution[T], n: float): float {.base.} =
  raise newException(ValueError, "not implemented")

method median*[T](d: Distribution[T]): T {.base.} =
  d.quantile(0.5)

method std*[T](d: Distribution[T]): float {.base.} =
  sqrt(d.variance)
