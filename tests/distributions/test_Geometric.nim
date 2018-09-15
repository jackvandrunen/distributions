import ../../distributions/distributions/geometricdistribution
import ../ut_utils
import sets
import unittest

suite "statistics-Geometric":
  let d = Geometric(0.01)

  test "object stuff":
    check($d == "Geometric(0.01)")
    var s = initSet[GeometricDistribution]()
    s.incl(d)

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
    check(d.mode()[0] == 1)
    check(approx(d.mean, 100.0))
    check(approx(d.variance, 9900.0))
    check(approx(d.std, 99.4987))
    check(approx(d.skewness, 2.00003))
    check(approx(d.kurtosis, 6.0001))
