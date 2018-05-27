import ../../statistics/distributions/DiscreteUniform
import ../ut_utils
import unittest

suite "statistics-DiscreteUniform":
  let d = DiscreteUniform(10)
  
  test "pmf":
    check(approx(d.pmf(-5), 0.0))
    check(approx(d.pmf(2), 0.1))
    check(approx(d.pmf(10), 0.1))
    check(approx(d.pmf(40), 0.0))

  test "cdf":
    check(approx(d.cdf(-5), 0.0))
    check(approx(d.cdf(7), 0.7))
    check(approx(d.cdf(10), 1.0))
    check(approx(d.cdf(40), 1.0))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.05) == 1)
    check(d.quantile(0.7) == 8)
    check(d.quantile(0.75) == 8)
    check(d.quantile(0.9) == 10)
  
  test "expectation":
    check(d.median == d.quantile(0.5))
    check(approx(d.mean, 5.5))
    check(approx(d.variance, 6.75))
    check(approx(d.std, 2.59808))
