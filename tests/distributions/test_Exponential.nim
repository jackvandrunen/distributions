import ../../statistics/distributions
import ../../statistics/distributions/Exponential
import ../ut_utils
import unittest

suite "statistics-Exponential":
  let d = Exponential(2.0)
  let d2: IDistribution[float] = d

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
    check(approx(d.mean, 2.0))
    check(approx(d.variance, 4.0))
    check(approx(d.std, 2.0))

  test "pdf-i":
    check(approx(d2.pdf(-1.0), 0.0))
    check(approx(d2.pdf(0.0), 0.0))
    check(approx(d2.pdf(1.0), 0.303265))
    check(approx(d2.pdf(5.0), 0.041043))

  test "cdf-i":
    check(approx(d2.cdf(-1.0), 0.0))
    check(approx(d2.cdf(0.575364), 0.25))
    check(approx(d2.cdf(1.38629), 0.5))
    check(approx(d2.cdf(2.77259), 0.75))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(approx(d2.quantile(0.25), 0.575364))
    check(approx(d2.quantile(0.5), 1.38629))
    check(approx(d2.quantile(0.75), 2.77259))
