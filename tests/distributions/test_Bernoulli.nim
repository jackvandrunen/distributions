import ../../distributions/distributions/bernoullidistribution
import ../ut_utils
import sets
import unittest

suite "statistics-Bernoulli":
  let d = Bernoulli(0.7)

  test "object stuff":
    check($d == "Bernoulli(0.7)")
    var s = initSet[BernoulliDistribution]()
    s.incl(d)

  test "pmf":
    check(approx(d.pmf(-1), 0.0))
    check(approx(d.pmf(0), 0.3))
    check(approx(d.pmf(1), 0.7))
    check(approx(d.pmf(3), 0.0))
  
  test "cdf":
    check(approx(d.cdf(-1), 0.0))
    check(approx(d.cdf(0), 0.3))
    check(approx(d.cdf(1), 1.0))
    check(approx(d.cdf(3), 1.0))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.1) == 0)
    check(d.quantile(0.29) == 0)
    check(d.quantile(0.31) == 1)
    check(d.quantile(0.7) == 1)

  test "expectation":
    check(d.median == d.quantile(0.5))
    check(d.mode()[0] == 1)
    check(approx(d.mean, 0.7))
    check(approx(d.variance, 0.21))
    check(approx(d.std, 0.458258))
    check(approx(d.skewness, -0.872872))
    check(approx(d.kurtosis, -1.2381))
