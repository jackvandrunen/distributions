import ../distributions
import ../private/tables2
import math
import strformat
import typetraits
include ./utils

export distributions

type
  SamplingDistribution*[T: SomeNumber] = ref object of Distribution[T]
    s: OrderedCountTable[T]
    m1: float
    m2: float
    m3: float
    m4: float

converter Sampling*[T](s: openarray[T]): SamplingDistribution[T] =
  var
    t = initOrderedCountTable(s)
    m1, m2p, m2, m3, m4: float
  for i in t.items():
    m1 += float(i.k) * float(i.v)
  m1 /= float(s.len)
  for i in t.items():
    m2 += pow(float(i.k) - m1, 2.0) * float(i.v)
    m3 += pow(float(i.k) - m1, 3.0) * float(i.v)
    m4 += pow(float(i.k) - m1, 4.0) * float(i.v)
  m2p = m2 / float(s.len)
  m2 /= float(s.len - 1)
  m3 /= float(s.len) * pow(m2p, 1.5)
  m4 /= float(s.len) * (m2p * m2p)
  SamplingDistribution[T](s: t, m1: m1, m2: m2, m3: m3, m4: m4 - 3.0)

converter `$`*[T](d: SamplingDistribution[T]): string =
  let dType = T.name
  let sHash = hash(d.s)
  fmt"Sampling[{dType}]({sHash})"

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
  d.m1

method variance*[T](d: SamplingDistribution[T]): float =
  d.m2

method skewness*[T](d: SamplingDistribution[T]): float =
  d.m3

method kurtosis*[T](d: SamplingDistribution[T]): float =
  d.m4

method mode*[T](d: SamplingDistribution[T]): seq[T] =
  var current = -1
  for i in d.s.items():
    if i.v > current:
      result = newSeq[T]()
      result.add(i.k)
      current = i.v
    elif i.v == current:
      result.add(i.k)
