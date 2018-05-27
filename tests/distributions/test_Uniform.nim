import ../../statistics/distributions
import ../../statistics/distributions/Uniform
import ../ut_utils
import unittest

suite "statistics-Uniform":
  let d = Uniform(0.0, 5.0)
  let d2: IDistribution[float] = d
  
  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.0), 0.2))
    check(approx(d.pdf(1.0), 0.2))
    check(approx(d.pdf(5.0), 0.2))
    check(approx(d.pdf(6.0), 0.0))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.0), 0.0))
    check(approx(d.cdf(1.0), 0.2))
    check(approx(d.cdf(5.0), 1.0))
    check(approx(d.cdf(6.0), 1.0))
  
  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.2), 1.0))
    check(approx(d.quantile(0.9), 4.5))

  test "expectation":
    check(approx(d.median, d.quantile(0.5)))
    check(approx(d.mean, 2.5))
    check(approx(d.variance, 2.08333))
    check(approx(d.std, 1.44338))

  test "pdf-i":
    check(approx(d2.pdf(-1.0), 0.0))
    check(approx(d2.pdf(0.0), 0.2))
    check(approx(d2.pdf(1.0), 0.2))
    check(approx(d2.pdf(5.0), 0.2))
    check(approx(d2.pdf(6.0), 0.0))

  test "cdf-i":
    check(approx(d2.cdf(-1.0), 0.0))
    check(approx(d2.cdf(0.0), 0.0))
    check(approx(d2.cdf(1.0), 0.2))
    check(approx(d2.cdf(5.0), 1.0))
    check(approx(d2.cdf(6.0), 1.0))
  
  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(approx(d2.quantile(0.2), 1.0))
    check(approx(d2.quantile(0.9), 4.5))
