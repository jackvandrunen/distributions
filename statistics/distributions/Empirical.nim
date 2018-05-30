import ../distributions
import ../private/tables2
import math
include ./utils

export distributions

type
  EmpiricalDistribution*[T: SomeNumber] = ref object of Distribution[T]
    s: OrderedCountTable[T]
    m: float
    v: float

converter Empirical*[T](s: openarray[T]): EmpiricalDistribution[T] =
  var
    t = initOrderedCountTable(s)
    m: float
    v: float
  for i in t.items():
    m += float(i.k) * float(i.v)
  m = m / float(s.len)
  for i in t.items():
    v += pow(float(i.k) - m, 2.0) * float(i.v)
  v = v / float(s.len - 1)
  EmpiricalDistribution[T](s: t, m: m, v: v)

converter Empirical*[T](s: seq[T]): EmpiricalDistribution[T] =
  Empirical(openarray(s))

method pmf*[T](d: EmpiricalDistribution[T], x: T): float =
  float(d.s.getOrDefault(x)) / float(d.s.counter)

method cdf*[T](d: EmpiricalDistribution[T], x: T): float =
  for i in d.s.items():
    if i.k > x:
      break
    result += float(i.v)
  return result / float(d.s.counter)

method quantile*[T](d: EmpiricalDistribution[T], q: float): T =
  let counter = float(d.s.counter)
  var sum: float
  checkNormal(q)
  for i in d.s.items():
    sum += float(i.v) / counter
    if sum >= q:
      return i.k

method mean*[T](d: EmpiricalDistribution[T]): float =
  d.m

method variance*[T](d: EmpiricalDistribution[T]): float =
  d.v
