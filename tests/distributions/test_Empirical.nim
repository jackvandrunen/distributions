import ../../statistics/distributions/Empirical
import ../ut_utils
import unittest

suite "statistics-Empirical":
  let s = @[1, 2, 3, 2, 4, 2, 2, 3, 1, 6, 5, 2]
  let s2 = @[1, 2, 3, 3, 5, 4, 5, 4, 4, 5]
  let d = Empirical(s)
  let d2 = Empirical(s2)

  test "converter":
    check(approx(s.variance, d.variance))

  test "pmf":
    check(approx(d.pmf(0), 0.0))
    check(approx(d.pmf(2), 5.0 / 12.0))
    check(approx(d.pmf(6), 1.0 / 12.0))
    check(approx(d.pmf(10), 0.0))

  test "cdf":
    check(approx(d.cdf(0), 0.0))
    check(approx(d.cdf(2), 7.0 / 12.0))
    check(approx(d.cdf(6), 1.0))
    check(approx(d.cdf(10), 1.0))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.01) == 1)
    check(d.quantile((7.0 / 12.0) - 0.0001) == 2)
    check(d.quantile((7.0 / 12.0) + 0.0001) == 3)
    check(d.quantile(0.99) == 6)

  test "expectation":
    check(d.median == d.quantile(0.5))
    check(d.mode == @[2])
    check(d2.mode == @[4, 5])
    check(approx(d.mean, 2.75))
    check(approx(d.variance, 2.386364))
    check(approx(d.std, 1.544786))
