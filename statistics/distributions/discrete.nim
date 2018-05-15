import ../distributions
import ../roots
import math

type
  PointMass* = object
    a*: int
  DiscreteUniform* = object
    k*: int
  Bernoulli* = object
    p*: float
  Binomial* = object
    n*: int
    p*: float
  Geometric* = object
    p*: float
  Poisson* = object
    lambda*: float

converter PointMassDistribution*(d: PointMass): IntDistribution =
  IntDistribution(
    pmf: proc (x: int): float =
      if x == d.a:
        result = 1.0,
    cdf: proc (x: int): float =
      if x >= d.a:
        result = 1.0,
    quantile: proc (x: float): int =
      d.a
  )

converter DiscreteUniformDistribution*(d: DiscreteUniform): IntDistribution =
  let kf = float(d.k)
  let kinv = 1.0 / kf
  IntDistribution(
    pmf: proc (x: int): float =
      if 1 <= x and x <= d.k:
        result = kinv,
    cdf: proc (x: int): float =
      min(1.0, max(0.0, kinv * float(x))),
    quantile: proc (x: float): int =
      int(kf * x) + 1
  )

converter BernoulliDistribution*(d: Bernoulli): IntDistribution =
  let q = 1.0 - d.p
  IntDistribution(
    pmf: proc (x: int): float =
      if x == 0:
        result = q
      elif x == 1:
        result = d.p,
    cdf: proc (x: int): float =
      if x < 0: 0.0
      elif x < 1: q
      else: 1.0,
    quantile: proc (x: float): int =
      if x < q: 0
      else: 1
  )

converter BinomialDistribution*(d: Binomial): IntDistribution =
  let q = 1.0 - d.p
  result = IntDistribution(
    pmf: proc (x: int): float =
      if x >= 0:
        result = float(binom(d.n, x)) * pow(d.p, float(x)) * pow(q, float(d.n - x)),
    cdf: proc (x: int): float =
      # TODO: non-iterative approximation?
      for i in 0..x:
        result += float(binom(d.n, i)) * pow(d.p, float(i)) * pow(q, float(d.n - i))
  )
  let dist = addr result
  result.quantile = proc (x: float): int =
    discreteInf(dist[].cdf, x, 0)

converter GeometricDistribution*(d: Geometric): IntDistribution =
  let q = 1.0 - d.p
  result = IntDistribution(
    pmf: proc (x: int): float =
      if x > 0:
        result = d.p * pow(q, float(x - 1)),
    cdf: proc (x: int): float =
      if x > 0:
        result = 1.0 - pow(q, float(x))
  )
  let dist = addr result
  result.quantile = proc (x: float): int =
    discreteInf(dist[].cdf, x, 1)

converter PoissonDistribution*(d: Poisson): IntDistribution =
  let nlambda = exp(-1.0 * d.lambda)
  result = IntDistribution(
    pmf: proc (x: int): float =
      if x >= 0:
        result = pow(d.lambda, float(x)) * nlambda / float(fac(x)),
    cdf: proc (x: int): float =
      # TODO: non-iterative approximation?
      for i in 0..x:
        result += pow(d.lambda, float(i)) / float(fac(i))
      result *= nlambda
  )
  let dist = addr result
  result.quantile = proc (x: float): int =
    discreteInf(dist[].cdf, x, 0)
