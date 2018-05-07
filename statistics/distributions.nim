import math

type
  Distribution* = object
    pmf*: proc(x: float): float
    cdf*: proc(x: float): float

  PointMass* = object
    a*: float
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

proc integer(x: float): bool =
  floor(x) == x

proc integerIn(x, a, b: float): bool =
  integer(x) and a <= x and x <= b

proc pmf*(d: Distribution, x: float): float =
  d.pmf(x)

proc cdf*(d: Distribution, x: float): float =
  d.cdf(x)

converter PointMassDistribution*(d: PointMass): Distribution =
  Distribution(
    pmf: proc (x: float): float =
      if x == d.a:
        result = 1.0,
    cdf: proc (x: float): float =
      if x >= d.a:
        result = 1.0
  )

converter DiscreteUniformDistribution*(d: DiscreteUniform): Distribution =
  let kf = float(d.k)
  Distribution(
    pmf: proc (x: float): float =
      if x.integerIn(1.0, kf):
        result = 1.0 / kf,
    cdf: proc (x: float): float =
      min(1.0, max(0.0, floor(x) / float(d.k)))
  )

converter BernoulliDistribution*(d: Bernoulli): Distribution =
  Distribution(
    pmf: proc (x: float): float =
      if x == 0.0:
        result = 1 - d.p
      elif x == 1.0:
        result = d.p,
    cdf: proc (x: float): float =
      if x < 0.0: 0.0
      elif x < 1.0: 1.0 - d.p
      else: 1.0
  )

converter BinomialDistribution*(d: Binomial): Distribution =
  let q = 1.0 - d.p
  Distribution(
    pmf: proc (x: float): float =
      if integer(x) and x >= 0.0:
        let xi = int(x)
        result = float(binom(d.n, xi)) * pow(d.p, x) * pow(q, float(d.n - xi)),
    cdf: proc (x: float): float =
      let xi = int(x)
      let ptx = pow(d.p, x)
      for i in 0..xi:
        result += float(binom(d.n, i)) * pow(d.p, float(i)) * pow(q, float(d.n - i))
  )

converter GeometricDistribution*(d: Geometric): Distribution =
  let q = 1.0 - d.p
  Distribution(
    pmf: proc (x: float): float =
      if integer(x) and x > 0.0:
        result = d.p * pow(q, x - 1.0),
    cdf: proc (x: float): float =
      if x > 0.0:
        result = 1.0 - pow(q, floor(x))
  )

converter PoissonDistribution*(d: Poisson): Distribution =
  let nlambda = exp(-1.0 * d.lambda)
  Distribution(
    pmf: proc (x: float): float =
      if integer(x) and x >= 0.0:
        result = pow(d.lambda, x) * nlambda / float(fac(int(x))),
    cdf: proc (x: float): float =
      let xi = int(x)
      for i in 0..xi:
        result += pow(d.lambda, float(i)) / float(fac(i))
      result *= nlambda
  )
