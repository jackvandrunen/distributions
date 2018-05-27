import ../distributions
import ../roots
import math
include ./utils

type
  TPoisson* = object
    lambda*: float
    nlambda: float

proc Poisson*(lambda: float): TPoisson =
  TPoisson(lambda: lambda, nlambda: exp(-1.0 * lambda))

proc pmf*(d: TPoisson, x: int): float =
  if x >= 0:
    result = pow(d.lambda, float(x)) * d.nlambda / float(fac(x))

proc cdf*(d: TPoisson, x: int): float =
  for i in 0..x:
    result += pow(d.lambda, float(i)) / float(fac(i))
  result *= d.nlambda

proc quantile*(d: TPoisson, q: float): int =
  checkNormal(q)
  discreteInf(proc(x: int): float = d.cdf(x), q, 0)

proc mean*(d: TPoisson): float =
  d.lambda

proc variance*(d: TPoisson): float =
  d.lambda

converter toDistribution*(d: TPoisson): IDistribution[int] =
  (
    pdf: proc(x: int): float = pmf(d, x),
    cdf: proc(x: int): float = cdf(d, x),
    quantile: proc(q: float): int = quantile(d, q),
    mean: proc(): float = mean(d),
    variance: proc(): float = variance(d)
  )
