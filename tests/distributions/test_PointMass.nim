import ../../statistics/distributions
import ../../statistics/distributions/PointMass
import ../ut_utils
import unittest

suite "statistics-PointMass":
  let d = PointMass(12)
  let d2: IDistribution[int] = d

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

  test "pmf-i":
    check(approx(d2.pdf(9), 0.0))
    check(approx(d2.pdf(12), 1.0))
    check(approx(d2.pdf(30), 0.0))

  test "cdf-i":
    check(approx(d2.cdf(9), 0.0))
    check(approx(d2.cdf(12), 1.0))
    check(approx(d2.cdf(30), 1.0))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(d2.quantile(0.1) == 12)
    check(d2.quantile(0.5) == 12)
    check(d2.quantile(0.9) == 12)
