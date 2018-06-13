import ../../statistics/distributions/StudentT
import ../ut_utils
import sets
import unittest

suite "statistics-StudentT":
  let d = StudentT(1.0)
  let d2 = StudentT(5.0)

  test "object stuff":
    check($d == "StudentT(1.0)")
    var s = initSet[StudentTDistribution]()
    s.incl(d)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.159155))
    check(approx(d.pdf(0.0), 0.31831))
    check(approx(d.pdf(1.0), 0.159155))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.25))
    check(approx(d.cdf(0.0), 0.5))
    check(approx(d.cdf(1.0), 0.75))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.25), -1.0))
    check(approx(d.quantile(0.5), 0.0))
    check(approx(d.quantile(0.75), 1.0))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mode()[0], 0.0))
    expect(ValueError):
      discard d.mean()
    check(approx(d2.mean, 0.0))
    expect(ValueError):
      discard d.variance()
    check(approx(d2.variance, 1.66667))
    expect(ValueError):
      discard d.std()
    check(approx(d2.std, 1.29099))
    expect(ValueError):
      discard d.skewness()
    check(approx(d2.skewness, 0.0))
    expect(ValueError):
      discard d.kurtosis()
    check(approx(d2.kurtosis, 6.0))
