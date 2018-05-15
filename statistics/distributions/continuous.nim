import ../distributions
import ../functions
import ../roots
import math

type
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
  Cauchy* = object

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
    findRoot(dist[].cdf, x, 0.5)

converter StudentsDistribution*(d: Students): FloatDistribution =
  discard

converter CauchyDistribution*(d: Cauchy): FloatDistribution =
  discard
