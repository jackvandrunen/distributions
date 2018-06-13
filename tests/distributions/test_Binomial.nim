import ../../statistics/distributions/Binomial
import ../ut_utils
import sets
import unittest

suite "statistics-Binomial":
  let d = Binomial(10, 0.35)

  test "object stuff":
    check($d == "Binomial(10, 0.35)")
    var s = initSet[BinomialDistribution]()
    s.incl(d)

  test "pmf":
    check(approx(d.pmf(-1), 0.0))
    check(approx(d.pmf(0), 0.01346))
    check(approx(d.pmf(1), 0.07249))
    check(approx(d.pmf(3), 0.25221))
    check(approx(d.pmf(6), 0.06890))

  test "cdf":
    check(approx(d.cdf(-1), 0.0))
    check(approx(d.cdf(0), 0.01346))
    check(approx(d.cdf(1), 0.08595))
    echo d.cdf(0)
    echo d.cdf(1)
    echo d.cdf(3)
    echo d.cdf(6)
    check(approx(d.cdf(3), 0.51382))
    check(approx(d.cdf(6), 0.97397))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.001) == 0)
    check(d.quantile(0.08) == 1)
    check(d.quantile(0.51) == 3)
    check(d.quantile(0.97) == 6)

  test "expectation":
    check(d.median == d.quantile(0.5))
    check(d.mode()[0] == 3)
    check(approx(d.mean, 3.5))
    check(approx(d.variance, 2.275))
    check(approx(d.std, 1.50831))
    check(approx(d.skewness, 0.198898))
    check(approx(d.kurtosis, -0.16044))
