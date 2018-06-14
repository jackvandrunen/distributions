import ../distributions
import math
import strformat
import algorithm
import hashes
include ./utils

export distributions

type
  SamplingDistribution*[T: SomeNumber] = ref object of Distribution[T]
    s: seq[T]
    m1: float
    m2: float
    m3: float
    m4: float

converter Sampling*[T](s: openarray[T]): SamplingDistribution[T] =
  var
    t = sorted(s, proc(a, b: T): int = int(a - b))
    m1, m2p, m2, m3, m4: float
  m1 = float(sum(t)) / float(t.len)
  for i in t:
    m2 += pow(float(i) - m1, 2.0)
    m3 += pow(float(i) - m1, 3.0)
    m4 += pow(float(i) - m1, 4.0)
  m2p = m2 / float(s.len)
  m2 /= float(s.len - 1)
  m3 /= float(s.len) * pow(m2p, 1.5)
  m4 /= float(s.len) * (m2p * m2p)
  SamplingDistribution[T](s: t, m1: m1, m2: m2, m3: m3, m4: m4 - 3.0)

converter `$`*[T](d: SamplingDistribution[T]): string =
  fmt"Sampling({d.s})"

converter Sampling*[T](s: seq[T]): SamplingDistribution[T] =
  Sampling(openarray(s))

method pmf*[T](d: SamplingDistribution[T], x: T): float =
  var i = binarySearch(d.s, x)
  let iMax = d.s.len - 1
  if i < 0:
    return 0.0
  while i > 0 and d.s[i - 1] == x:
    dec i
  let start = i
  while i < iMax and d.s[i + 1] == x:
    inc i
  float((i - start) + 1) / float(d.s.len)

method cdf*[T](d: SamplingDistribution[T], x: T): float =
  var count = 0
  for i in d.s:
    if i > x:
      break
    inc count
  return float(count) / float(d.s.len)

method quantile*[T](d: SamplingDistribution[T], q: float): T =
  checkNormal(q)
  d.s[int(q * float(d.s.len))]

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
  var count = 0
  var prev = d.s[0]
  for i in d.s:
    if i == prev:
      inc count
    else:
      if count > current:
        result = newSeq[T]()
        result.add(prev)
        current = count
      elif count == current:
        result.add(prev)
      count = 1
      prev = i
  if count > current:
    result = newSeq[T]()
    result.add(prev)
    current = count
  elif count == current:
    result.add(prev)
