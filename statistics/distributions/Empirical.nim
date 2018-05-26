import ../distributions
import ../private/tables2

type
  TEmpirical*[T: SomeNumber] = object
    s: OrderedCountTable[T]

proc Empirical*[T](s: openarray[T]): TEmpirical[T] =
  TEmpirical[T](s: initOrderedCountTable(s))

proc pmf*[T](d: TEmpirical[T], x: T): float =
  float(d.s.getOrDefault(x)) / float(d.s.counter)

proc cdf*[T](d: TEmpirical[T], x: T): float =
  for i in d.s.items():
    if i.k > x:
      break
    result += float(i.v)
  return result / float(d.s.counter)

proc quantile*[T](d: TEmpirical[T], q: float): T =
  let counter = float(d.s.counter)
  var sum: float
  checkNormal(q)
  for i in d.s.items():
    sum += float(i.v) / counter
    if sum >= q:
      return i.k

converter toDistribution*(d: TEmpirical): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q)
  )
