import ../../statistics/distributions/Normal
import ../ut_utils
import sets
import unittest

suite "statistics-Normal":
  let d = Normal(0.0, 1.0)

  test "object stuff":
    check($d == "Normal(0.0, 1.0)")
    var s = initSet[NormalDistribution]()
    s.incl(d)

  test "pdf":
    check(approx(d.pdf(-3.4), 0.00123))
    check(approx(d.pdf(-1.1), 0.21785))
    check(approx(d.pdf(0.0), 0.39894))
    check(approx(d.pdf(1.1), 0.21785))
    check(approx(d.pdf(3.4), 0.00123))

  test "cdf":
    check(approx(d.cdf(-3.4), 0.000337))
    check(approx(d.cdf(-1.1), 0.135667))
    check(approx(d.cdf(0.0), 0.5))
    check(approx(d.cdf(1.1), 0.864334))
    check(approx(d.cdf(3.4), 0.999663))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.000337), -3.4))
    check(approx(d.quantile(0.135667), -1.1))
    check(approx(d.quantile(0.5), 0.0))
    check(approx(d.quantile(0.864334), 1.1))
    check(approx(d.quantile(0.999663), 3.4))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mode()[0], 0.0))
    check(approx(d.mean, 0.0))
    check(approx(d.variance, 1.0))
    check(approx(d.std, 1.0))
