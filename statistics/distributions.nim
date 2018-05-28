import math
import typetraits

type
  Distribution*[T: SomeNumber] = ref object {.inheritable.}

method pmf*[T](d: Distribution[T], x: T): float {.base.} =
  raise newException(ValueError, d.type.name & ".pmf")

method pdf*[T](d: Distribution[T], x: T): float {.base.} =
  raise newException(ValueError, d.type.name & ".pdf")

method cdf*[T](d: Distribution[T], x: T): float {.base.} =
  raise newException(ValueError, d.type.name & ".cdf")

method quantile*[T](d: Distribution[T], q: float): T {.base.} =
  raise newException(ValueError, d.type.name & ".quantile")

method mean*[T](d: Distribution[T]): float {.base.} =
  raise newException(ValueError, d.type.name & ".mean")

method variance*[T](d: Distribution[T]): float {.base.} =
  raise newException(ValueError, d.type.name & ".variance")

method median*[T](d: Distribution[T]): T {.base.} =
  d.quantile(0.5)

method std*[T](d: Distribution[T]): float {.base.} =
  sqrt(d.variance)
