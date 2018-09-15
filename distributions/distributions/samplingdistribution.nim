import ../basedistribution
import ../variables
import ./normaldistribution
import ../oracle
import math
import sequtils
import strformat
import algorithm
import hashes
include ./utils

export basedistribution

type
  SamplingDistribution*[T: SomeNumber] = ref object of Distribution[T]
    s, v: seq[T]
    m1, m2, m3, m4: float

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
  SamplingDistribution[T](s: t, v: toSeq(s.items), m1: m1, m2: m2, m3: m3, m4: m4 - 3.0)

converter `$`*[T](d: SamplingDistribution[T]): string =
  fmt"Sampling({d.s})"

converter Sampling*[T](s: seq[T]): SamplingDistribution[T] =
  Sampling(openarray(s))

proc len*[T](d: SamplingDistribution[T]): int =
  d.s.len

method pmf*[T](d: SamplingDistribution[T], x: T): float =
  var i = binarySearch(d.s, x)
  let iMax = d.len - 1
  if i < 0:
    return 0.0
  while i > 0 and d.s[i - 1] == x:
    dec i
  let start = i
  while i < iMax and d.s[i + 1] == x:
    inc i
  float((i - start) + 1) / float(d.len)

method cdf*[T](d: SamplingDistribution[T], x: T): float =
  var count = 0
  for i in d.s:
    if i > x:
      break
    inc count
  return float(count) / float(d.len)

method quantile*[T](d: SamplingDistribution[T], q: float): T =
  checkNormal(q)
  d.s[int(q * float(d.len))]

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

proc covariance*[T](x, y: SamplingDistribution[T]): float =
  if x.len != y.len:
    raise newException(ValueError, "samples must be of the same size")
  let size = x.len - 1
  let xm = x.mean()
  let ym = y.mean()
  for i in 0..size:
    result += (float(x.v[i]) - xm) * (float(y.v[i]) - ym)
  result /= float(size)

proc correlation*[T](x, y: SamplingDistribution[T]): float =
  covariance(x, y) / (x.std * y.std)

proc jointSample*[T, U](da: SamplingDistribution[T], db: SamplingDistribution[U], n: int): tuple[a: seq[T], b: seq[U]] =
  let scale = float(da.len)
  result = (newSeq[T](n), newSeq[U](n))
  for i in 0..n - 1:
    let r = int(rand() * scale)
    result.a[i] = da.v[r]
    result.b[i] = db.v[r]

proc se*[T, U](d: SamplingDistribution[T], t: proc(d: SamplingDistribution[T]): U, b: int): float =
  var boot = newSeq[U](b)
  for i in 0..b - 1:
    boot[i] = t(d.sample(d.len))
  result = std(boot)

proc se*[T, U, V](da: SamplingDistribution[T], db: SamplingDistribution[V], t: proc(da: SamplingDistribution[T], db: SamplingDistribution[V]): U, b: int): float =
  var boot = newSeq[U](b)
  for i in 0..b - 1:
    let ss = jointSample(da, db, da.len)
    boot[i] = t(ss.a, ss.b)
  result = std(boot)

proc ci*[T, U](d: SamplingDistribution[T], t: proc(d: SamplingDistribution[T]): U, b: int, a = 0.95): tuple[l, u: float] =
  let s = t(d)
  let e = d.se(t, b) * abs(Z.quantile((1.0 - a) / 2.0))
  (s - e, s + e)

proc ci*[T, U, V](da: SamplingDistribution[T], db: SamplingDistribution[V], t: proc(da: SamplingDistribution[T], db: SamplingDistribution[V]): U, b: int, a = 0.95): tuple[l, u: float] =
  let s = t(da, db)
  let e = se(da, db, t, b) * abs(Z.quantile((1.0 - a) / 2.0))
  (s - e, s + e)
