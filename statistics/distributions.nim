import ./roots
import ./functions
import math

type
  FloatDistribution* = object
    pdf*: proc(x: float): float
    cdf*: proc(x: float): float
    quantile*: proc(q: float): float
  IntDistribution* = object
    pmf*: proc(x: int): float
    cdf*: proc(x: int): float
    quantile*: proc(q: float): int

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
  Uniform* = object
    a*: float
    b*: float
  Normal* = object
    mean*: float
    variance*: float
  Exponential* = object
    beta*: float
  Gamma* = object
    alpha*: float
    beta*: float
  Beta* = object
    alpha*: float
    beta*: float
  Students* = object
    nu*: float

template checkNormal(x: float) =
  if not (0.0 < x and x < 1.0):
    raise newException(ValueError, "Quantile function is defined on (0,1)")

proc pdf*(d: FloatDistribution, x: float): float {.inline.} =
  d.pdf(x)

proc pdf*(d: FloatDistribution): (proc(x: float): float) {.inline.} =
  d.pdf

proc pmf*(d: IntDistribution, x: int): float {.inline.} =
  d.pmf(x)

proc pmf*(d: IntDistribution): (proc(x: int): float) {.inline.} =
  d.pmf

proc cdf*(d: FloatDistribution, x: float): float {.inline.} =
  d.cdf(x)

proc cdf*(d: FloatDistribution): (proc(x: float): float) {.inline.} =
  d.cdf

proc cdf*(d: IntDistribution, x: int): float {.inline.} =
  d.cdf(x)

proc cdf*(d: IntDistribution): (proc(x: int): float) {.inline.} =
  d.cdf

proc quantile*(d: FloatDistribution, q: float): float {.inline.} =
  d.quantile(q)

proc quantile*(d: FloatDistribution): (proc(q: float): float) {.inline.} =
  d.quantile

proc quantile*(d: IntDistribution, q: float): int {.inline.} =
  d.quantile(q)

proc quantile*(d: IntDistribution): (proc(q: float): int) {.inline.} =
  d.quantile

converter PointMassDistribution*(d: PointMass): IntDistribution =
  IntDistribution(
    pmf: proc (x: int): float =
      if x == d.a:
        result = 1.0,
    cdf: proc (x: int): float =
      if x >= d.a:
        result = 1.0,
    quantile: proc (x: float): int =
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
      checkNormal(x)
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
    checkNormal(x)
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
    checkNormal(x)
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
    checkNormal(x)
    discreteInf(dist[].cdf, x, 0)

converter UniformDistribution*(d: Uniform): FloatDistribution =
  let r = d.b - d.a
  let rinv = 1.0 / r
  FloatDistribution(
    pdf: proc (x: float): float =
      if d.a <= x and x <= d.b:
        result = rinv,
    cdf: proc (x: float): float =
      min(1.0, max(0.0, (x - d.a) * rinv)),
    quantile: proc (x: float): float =
      checkNormal(x)
      r * x
  )

converter NormalDistribution*(d: Normal): FloatDistribution =
  let dnorm = 1.0 / sqrt(2.0 * PI * d.variance)
  let vnorm = 1.0 / (2.0 * d.variance)
  let r2v = sqrt(2.0 * d.variance)
  FloatDistribution(
    pdf: proc (x: float): float =
      let xm = x - d.mean
      dnorm / exp(vnorm * xm * xm),
    cdf: proc (x: float): float =
      0.5 * (1.0 + erf((x - d.mean) / r2v)),
    quantile: proc (x: float): float =
      checkNormal(x)
      d.mean + (r2v * erfinv((2.0 * x) - 1.0))
  )

converter ExponentialDistribution*(d: Exponential): FloatDistribution =
  let binv = 1.0 / d.beta
  FloatDistribution(
    pdf: proc (x: float): float =
      if x > 0.0:
        result = binv * exp(-x * binv),
    cdf: proc (x: float): float =
      if x > 0.0:
        result = 1.0 - exp(-x * binv),
    quantile: proc (x: float): float =
      checkNormal(x)
      -ln(1.0 - x) * d.beta
  )

converter GammaDistribution*(d: Gamma): FloatDistribution =
  let ga = tgamma(d.alpha)
  let srinv = 1.0 / (pow(d.beta, d.alpha) * ga)
  let aprev = d.alpha - 1.0
  let binv = 1.0 / d.beta
  result = FloatDistribution(
    pdf: proc (x: float): float =
      if x > 0.0:
        result = srinv * pow(x, aprev) * exp(-x * binv),
    cdf: proc (x: float): float =
      if x > 0.0:
        result = gammainc(d.alpha, x * binv) / ga
  )
  let dist = addr result
  result.quantile = proc (x: float): float =
    checkNormal(x)
    findRoot(dist[].cdf, x, 1.0)

converter BetaDistribution*(d: Beta): FloatDistribution =
  let aprev = d.alpha - 1.0
  let bprev = d.beta - 1.0
  let bab = 1.0 / beta(d.alpha, d.beta)
  result = FloatDistribution(
    pdf: proc (x: float): float =
      if x > 0.0 and x < 1.0:
        result = pow(x, aprev) * pow(1.0 - x, bprev) * bab,
    cdf: proc (x: float): float =
      if x > 0.0 and x < 1.0:
        result = betaincreg(x, d.alpha, d.beta)
      if x >= 1.0:
        result = 1.0
  )
  let dist = addr result
  result.quantile = proc (x: float): float =
    checkNormal(x)
    findRoot(dist[].cdf, x, 0.5)

converter StudentsDistribution*(d: Students): FloatDistribution =
  discard
