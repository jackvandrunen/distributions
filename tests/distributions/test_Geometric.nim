import ../../statistics/distributions
import ../../statistics/distributions/Geometric
import ../ut_utils
import unittest

suite "statistics-Geometric":
  let d = Geometric(0.01)
  let d2: IDistribution[int] = d

  test "pmf":
    check(approx(d.pmf(-1), 0.0))
    check(approx(d.pmf(0), 0.0))
    check(approx(d.pmf(10), 0.00913))
    check(approx(d.pmf(50), 0.00611))
    check(approx(d.pmf(100), 0.003697))

  test "cdf":
    check(approx(d.cdf(-1), 0.0))
    check(approx(d.cdf(0), 0.0))
    check(approx(d.cdf(10), 0.09562))
    check(approx(d.cdf(50), 0.39499))
    check(approx(d.cdf(100), 0.63397))
    check(approx(d.cdf(300), 0.95096))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.09561) == 10)
    check(d.quantile(0.39498) == 50)
    check(d.quantile(0.63396) == 100)
    check(d.quantile(0.95095) == 300)

  test "expectation":
    check(d.median == d.quantile(0.5))
    check(approx(d.mean, 100.0))
    check(approx(d.variance, 9900.0))
    check(approx(d.std, 99.4987))

  test "pmf-i":
    check(approx(d2.pdf(-1), 0.0))
    check(approx(d2.pdf(0), 0.0))
    check(approx(d2.pdf(10), 0.00913))
    check(approx(d2.pdf(50), 0.00611))
    check(approx(d2.pdf(100), 0.003697))

  test "cdf-i":
    check(approx(d2.cdf(-1), 0.0))
    check(approx(d2.cdf(0), 0.0))
    check(approx(d2.cdf(10), 0.09562))
    check(approx(d2.cdf(50), 0.39499))
    check(approx(d2.cdf(100), 0.63397))
    check(approx(d2.cdf(300), 0.95096))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(d2.quantile(0.09561) == 10)
    check(d2.quantile(0.39498) == 50)
    check(d2.quantile(0.63396) == 100)
    check(d2.quantile(0.95095) == 300)
