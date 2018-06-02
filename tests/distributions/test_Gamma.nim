import ../../statistics/distributions/Gamma
import ../ut_utils
import sets
import unittest

suite "statistics-Gamma":
  let d = Gamma(1.0, 2.0)

  test "object stuff":
    check($d == "Gamma(1.0, 2.0)")
    var s = initSet[GammaDistribution]()
    s.incl(d)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.0), 0.0))
    check(approx(d.pdf(1.0), 0.303265))
    check(approx(d.pdf(5.0), 0.041043))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.575364), 0.25))
    check(approx(d.cdf(1.38629), 0.5))
    check(approx(d.cdf(2.77259), 0.75))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.25), 0.575364))
    check(approx(d.quantile(0.5), 1.38629))
    check(approx(d.quantile(0.75), 2.77259))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mode()[0], 0.0))
    check(approx(d.mean, 2.0))
    check(approx(d.variance, 4.0))
    check(approx(d.std, 2.0))
