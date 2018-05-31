import ../../statistics/distributions/LogNormal
import ../ut_utils
import unittest

suite "statistics-LogNormal":
  let d = LogNormal(0.0, 1.0)

  test "pdf":
    check(approx(d.pdf(0.0), 0.0))
    check(approx(d.pdf(1.1), 0.361031))
    check(approx(d.pdf(3.4), 0.0554914))

  test "cdf":
    check(approx(d.cdf(0.0), 0.0))
    check(approx(d.cdf(1.1), 0.537966))
    check(approx(d.cdf(3.4), 0.889482))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.537966), 1.1))
    check(approx(d.quantile(0.889482), 3.4))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mode()[0], 0.367879))
    check(approx(d.mean, 1.0))
    check(approx(d.variance, 4.67077427))
    check(approx(d.std, 2.161197))
