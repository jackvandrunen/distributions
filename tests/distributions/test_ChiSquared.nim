import ../../statistics/distributions/ChiSquared
import ../ut_utils
import unittest

suite "statistics-ChiSquared":
  let d = ChiSquared(3)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.5), 0.219696))
    check(approx(d.pdf(1.0), 0.241971))
    check(approx(d.pdf(3.0), 0.15418))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.5), 0.0811086))
    check(approx(d.cdf(1.0), 0.198748))
    check(approx(d.cdf(3.0), 0.608375))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.0811086), 0.5))
    check(approx(d.quantile(0.198748), 1.0))
    check(approx(d.quantile(0.608375), 3.0))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mean, 3.0))
    check(approx(d.variance, 6.0))
    check(approx(d.std, 2.44949))
