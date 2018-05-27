import ../../statistics/distributions
import ../../statistics/distributions/Cauchy
import ../ut_utils
import unittest

suite "statistics-Cauchy":
  let d = Cauchy()
  let d2: IDistribution[float] = d

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
    expect(ValueError):
      discard d.mean()
    expect(ValueError):
      discard d.variance()
    expect(ValueError):
      discard d.std()

  test "pdf-i":
    check(approx(d2.pdf(-1.0), 0.159155))
    check(approx(d2.pdf(0.0), 0.31831))
    check(approx(d2.pdf(1.0), 0.159155))

  test "cdf-i":
    check(approx(d2.cdf(-1.0), 0.25))
    check(approx(d2.cdf(0.0), 0.5))
    check(approx(d2.cdf(1.0), 0.75))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(approx(d2.quantile(0.25), -1.0))
    check(approx(d2.quantile(0.5), 0.0))
    check(approx(d2.quantile(0.75), 1.0))
