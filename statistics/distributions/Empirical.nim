import ../distributions
import ../private/tables2
import math
include ./utils

type
  TEmpirical*[T: SomeNumber] = object
    s: OrderedCountTable[T]
    m: float
    v: float

proc Empirical*[T](s: openarray[T]): TEmpirical[T] =
  var
    oct = initOrderedCountTable(s)
    m: float
    v: float
  for i in oct.items():
    m += float(i.k) * float(i.v)
  m = m / float(s.len)
  for i in oct.items():
    v += pow(float(i.k) - m, 2.0) * float(i.v)
  v = v / float(s.len - 1)
  TEmpirical[T](s: oct, m: m, v: v)

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

proc mean*[T](d: TEmpirical[T]): float =
  d.m

proc variance*[T](d: TEmpirical[T]): float =
  d.v

converter toDistribution*[T](d: TEmpirical[T]): IDistribution[T] =
  (
    pdf: proc(x: T): float = pmf(d, x),
    cdf: proc(x: T): float = cdf(d, x),
    quantile: proc(q: float): T = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
