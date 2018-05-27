import ../../statistics/distributions
import ../../statistics/distributions/Poisson
import ../ut_utils
import unittest

suite "statistics-Poisson":
  let d = Poisson(4.0)
  let d2: IDistribution[int] = d

  test "pmf":
    check(approx(d.pmf(-1), 0.0))
    check(approx(d.pmf(0), 0.01832))
    check(approx(d.pmf(1), 0.07326))
    check(approx(d.pmf(4), 0.19537))
    check(approx(d.pmf(10), 0.00529))

  test "cdf":
    check(approx(d.cdf(-1), 0.0))
    check(approx(d.cdf(0), 0.01832))
    check(approx(d.cdf(1), 0.09158))
    check(approx(d.cdf(4), 0.62884))
    check(approx(d.cdf(10), 0.99716))
  
  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.01831) == 0)
    check(d.quantile(0.09157) == 1)
    check(d.quantile(0.62883) == 4)
    check(d.quantile(0.99715) == 10)

  test "expectation":
    check(d.median == d.quantile(0.5))
    check(approx(d.mean, 4.0))
    check(approx(d.variance, 4.0))
    check(approx(d.std, 2.0))

  test "pmf-i":
    check(approx(d2.pdf(-1), 0.0))
    check(approx(d2.pdf(0), 0.01832))
    check(approx(d2.pdf(1), 0.07326))
    check(approx(d2.pdf(4), 0.19537))
    check(approx(d2.pdf(10), 0.00529))

  test "cdf-i":
    check(approx(d2.cdf(-1), 0.0))
    check(approx(d2.cdf(0), 0.01832))
    check(approx(d2.cdf(1), 0.09158))
    check(approx(d2.cdf(4), 0.62884))
    check(approx(d2.cdf(10), 0.99716))
  
  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(d2.quantile(0.01831) == 0)
    check(d2.quantile(0.09157) == 1)
    check(d2.quantile(0.62883) == 4)
    check(d2.quantile(0.99715) == 10)
