import ../../statistics/distributions
import ../../statistics/distributions/Normal
import ../ut_utils
import unittest

suite "statistics-Normal":
  let d = Normal(0.0, 1.0)
  let d2: IDistribution[float] = d

  test "pdf":
    check(approx(d.pdf(-3.4), 0.00123))
    check(approx(d.pdf(-1.1), 0.21785))
    check(approx(d.pdf(0.0), 0.39894))
    check(approx(d.pdf(1.1), 0.21785))
    check(approx(d.pdf(3.4), 0.00123))

  test "cdf":
    check(approx(d.cdf(-3.4), 0.000337))
    check(approx(d.cdf(-1.1), 0.135667))
    check(approx(d.cdf(0.0), 0.5))
    check(approx(d.cdf(1.1), 0.864334))
    check(approx(d.cdf(3.4), 0.999663))

  test "quantile":
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(approx(d.quantile(0.000337), -3.4))
    check(approx(d.quantile(0.135667), -1.1))
    check(approx(d.quantile(0.5), 0.0))
    check(approx(d.quantile(0.864334), 1.1))
    check(approx(d.quantile(0.999663), 3.4))

  test "pdf-i":
    check(approx(d2.pdf(-3.4), 0.00123))
    check(approx(d2.pdf(-1.1), 0.21785))
    check(approx(d2.pdf(0.0), 0.39894))
    check(approx(d2.pdf(1.1), 0.21785))
    check(approx(d2.pdf(3.4), 0.00123))

  test "cdf-i":
    check(approx(d2.cdf(-3.4), 0.000337))
    check(approx(d2.cdf(-1.1), 0.135667))
    check(approx(d2.cdf(0.0), 0.5))
    check(approx(d2.cdf(1.1), 0.864334))
    check(approx(d2.cdf(3.4), 0.999663))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(approx(d2.quantile(0.000337), -3.4))
    check(approx(d2.quantile(0.135667), -1.1))
    check(approx(d2.quantile(0.5), 0.0))
    check(approx(d2.quantile(0.864334), 1.1))
    check(approx(d2.quantile(0.999663), 3.4))
