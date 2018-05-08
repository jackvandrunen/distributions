import math

type
  FloatDistribution* = object
    pmf*: proc(x: float): float
    cdf*: proc(x: float): float
    quantile*: proc(q: float): float
  IntDistribution* = object
    pmf*: proc(x: int): float
    cdf*: proc(x: int): float
    quantile*: proc(q: float): int

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
  Uniform* = object
    a*: float
    b*: float
  Normal* = object
    mean*: float
    variance*: float

template checkNormal(x: float) =
  assert(0.0 <= x and x <= 1.0)

proc pmf*(d: FloatDistribution, x: float): float {.inline.} =
  d.pmf(x)

proc pmf*(d: IntDistribution, x: int): float {.inline.} =
  d.pmf(x)

proc cdf*(d: FloatDistribution, x: float): float {.inline.} =
  d.cdf(x)

proc cdf*(d: IntDistribution, x: int): float {.inline.} =
  d.cdf(x)

proc quantile*(d: FloatDistribution, q: float): float {.inline.} =
  d.quantile(q)

proc quantile*(d: IntDistribution, q: float): int {.inline.} =
  d.quantile(q)

converter PointMassDistribution*(d: PointMass): FloatDistribution =
  FloatDistribution(
    pmf: proc (x: float): float =
      if x == d.a:
        result = 1.0,
    cdf: proc (x: float): float =
      if x >= d.a:
        result = 1.0,
    quantile: proc (x: float): float =
      checkNormal(x)
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
      checkNormal(x)
      int(ceil(kf * x))
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
      checkNormal(x)
      if x < q: 0
      else: 1
  )

converter BinomialDistribution*(d: Binomial): IntDistribution =
  let q = 1.0 - d.p
  IntDistribution(
    pmf: proc (x: int): float =
      if x >= 0:
        result = float(binom(d.n, x)) * pow(d.p, float(x)) * pow(q, float(d.n - x)),
    cdf: proc (x: int): float =
      for i in 0..x:
        result += float(binom(d.n, i)) * pow(d.p, float(i)) * pow(q, float(d.n - i))
  )

converter GeometricDistribution*(d: Geometric): IntDistribution =
  let q = 1.0 - d.p
  IntDistribution(
    pmf: proc (x: int): float =
      if x > 0:
        result = d.p * pow(q, float(x - 1)),
    cdf: proc (x: int): float =
      if x > 0:
        result = 1.0 - pow(q, float(x))
  )

converter PoissonDistribution*(d: Poisson): IntDistribution =
  let nlambda = exp(-1.0 * d.lambda)
  IntDistribution(
    pmf: proc (x: int): float =
      if x >= 0:
        result = pow(d.lambda, float(x)) * nlambda / float(fac(x)),
    cdf: proc (x: int): float =
      for i in 0..x:
        result += pow(d.lambda, float(i)) / float(fac(i))
      result *= nlambda
  )

converter UniformDistribution*(d: Uniform): FloatDistribution =
  let r = d.b - d.a
  let rinv = 1.0 / r
  FloatDistribution(
    pmf: proc (x: float): float =
      if d.a <= x and x <= d.b:
        result = rinv,
    cdf: proc (x: float): float =
      min(1.0, max(0.0, (x - d.a) * rinv)),
    quantile: proc (x: float): float =
      checkNormal(x)
      x
  )

converter NormalDistribution*(d: Normal): FloatDistribution =
  let dnorm = 1.0 / sqrt(2.0 * PI * d.variance)
  let vnorm = 1.0 / (2.0 * d.variance)
  let r2v = sqrt(2.0 * d.variance)
  FloatDistribution(
    pmf: proc (x: float): float =
      let xm = x - d.mean
      dnorm / exp(vnorm * xm * xm),
    cdf: proc (x: float): float =
      0.5 * (1.0 + erf((x - d.mean) / r2v)),
    quantile: proc (x: float): float =
      checkNormal(x)
      d.mean + (r2v * erfc((2 * x) - 1))
  )
