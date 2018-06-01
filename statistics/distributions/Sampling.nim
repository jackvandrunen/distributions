import ../distributions
import ../private/tables2
import math
include ./utils

export distributions

type
  SamplingDistribution*[T: SomeNumber] = ref object of Distribution[T]
    s: OrderedCountTable[T]
    m: float
    v: float

converter Sampling*[T](s: openarray[T]): SamplingDistribution[T] =
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
  SamplingDistribution[T](s: t, m: m, v: v)

converter Sampling*[T](s: seq[T]): SamplingDistribution[T] =
  Sampling(openarray(s))

method pmf*[T](d: SamplingDistribution[T], x: T): float =
  float(d.s.getOrDefault(x)) / float(d.s.counter)

method cdf*[T](d: SamplingDistribution[T], x: T): float =
  for i in d.s.items():
    if i.k > x:
      break
    result += float(i.v)
  return result / float(d.s.counter)

method quantile*[T](d: SamplingDistribution[T], q: float): T =
  let counter = float(d.s.counter)
  var sum: float
  checkNormal(q)
  for i in d.s.items():
    sum += float(i.v) / counter
    if sum >= q:
      return i.k

method mean*[T](d: SamplingDistribution[T]): float =
  d.m

method variance*[T](d: SamplingDistribution[T]): float =
  d.v

method mode*[T](d: SamplingDistribution[T]): seq[T] =
  var current = -1
  for i in d.s.items():
    if i.v > current:
      result = newSeq[T]()
      result.add(i.k)
      current = i.v
    elif i.v == current:
      result.add(i.k)
