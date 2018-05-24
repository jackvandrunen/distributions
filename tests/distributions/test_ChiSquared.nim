import ../../statistics/distributions
import ../../statistics/distributions/ChiSquared
import ../ut_utils
import unittest

suite "statistics-ChiSquared":
  let d = ChiSquared(3)
  let d2: IDistribution[float] = d

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

  test "pdf-i":
    check(approx(d2.pdf(-1.0), 0.0))
    check(approx(d2.pdf(0.5), 0.219696))
    check(approx(d2.pdf(1.0), 0.241971))
    check(approx(d2.pdf(3.0), 0.15418))

  test "cdf-i":
    check(approx(d2.cdf(-1.0), 0.0))
    check(approx(d2.cdf(0.5), 0.0811086))
    check(approx(d2.cdf(1.0), 0.198748))
    check(approx(d2.cdf(3.0), 0.608375))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(approx(d2.quantile(0.0811086), 0.5))
    check(approx(d2.quantile(0.198748), 1.0))
    check(approx(d2.quantile(0.608375), 3.0))
