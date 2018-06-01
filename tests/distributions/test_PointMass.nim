import ../../statistics/distributions/PointMass
import ../ut_utils
import unittest

suite "statistics-PointMass":
  let d = PointMass(12)

  test "pmf":
    check(approx(d.pmf(9), 0.0))
    check(approx(d.pmf(12), 1.0))
    check(approx(d.pmf(30), 0.0))

  test "cdf":
    check(approx(d.cdf(9), 0.0))
    check(approx(d.cdf(12), 1.0))
    check(approx(d.cdf(30), 1.0))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.1) == 12)
    check(d.quantile(0.5) == 12)
    check(d.quantile(0.9) == 12)
  
  test "expectation":
    check(d.median == d.quantile(0.5))
    check(d.mode()[0] == 12)
    check(approx(d.mean, 12.0))
    check(approx(d.variance, 0.0))
    check(approx(d.std, 0.0))
