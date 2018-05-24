import ../../statistics/distributions
import ../../statistics/distributions/Binomial
import ../ut_utils
import unittest

suite "statistics-Binomial":
  let d = Binomial(10, 0.35)
  let d2: IDistribution[int] = d

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

  test "pmf-i":
    check(approx(d2.pdf(-1), 0.0))
    check(approx(d2.pdf(0), 0.01346))
    check(approx(d2.pdf(1), 0.07249))
    check(approx(d2.pdf(3), 0.25221))
    check(approx(d2.pdf(6), 0.06890))

  test "cdf-i":
    check(approx(d2.cdf(-1), 0.0))
    check(approx(d2.cdf(0), 0.01346))
    check(approx(d2.cdf(1), 0.08595))
    check(approx(d2.cdf(3), 0.51382))
    check(approx(d2.cdf(6), 0.97397))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(d2.quantile(0.001) == 0)
    check(d2.quantile(0.08) == 1)
    check(d2.quantile(0.51) == 3)
    check(d2.quantile(0.97) == 6)
