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
    check(approx(d.pdf(0.5), 0.735759))
    check(approx(d.pdf(1.0), 0.270671))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.143841), 0.25))
    check(approx(d.cdf(0.346574), 0.5))
    check(approx(d.cdf(0.693147), 0.75))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.25), 0.143841))
    check(approx(d.quantile(0.5), 0.346574))
    check(approx(d.quantile(0.75), 0.693147))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mode()[0], 0.0))
    check(approx(d.mean, 0.5))
    check(approx(d.variance, 0.25))
    check(approx(d.std, 0.5))
    check(approx(d.skewness, 2.0))
    check(approx(d.kurtosis, 6.0))
