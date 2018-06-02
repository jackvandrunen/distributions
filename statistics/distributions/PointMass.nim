import ../distributions
import strformat
include ./utils

export distributions

type
  PointMassDistribution*[T: SomeNumber] = ref object of Distribution[T]
    a*: T

proc PointMass*[T](a: T): PointMassDistribution[T] =
  PointMassDistribution[T](a: a)

converter `$`*[T](d: PointMassDistribution[T]): string =
  fmt"PointMass({d.a})"

method pmf*[T](d: PointMassDistribution[T], x: T): float =
  if x == d.a:
    result = 1.0

method cdf*[T](d: PointMassDistribution[T], x: T): float =
  if x >= d.a:
    result = 1.0

method quantile*[T](d: PointMassDistribution[T], q: float): T =
  checkNormal(q)
  d.a

method mean*[T](d: PointMassDistribution[T]): float =
  float(d.a)

method variance*[T](d: PointMassDistribution[T]): float =
  0.0

method mode*[T](d: PointMassDistribution[T]): seq[T] =
  @[d.a]
