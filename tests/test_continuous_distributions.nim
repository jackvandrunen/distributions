import ../statistics/distributions
import ../statistics/distributions/continuous
import ./ut_utils
import unittest

template checkQuantileBounds(d): untyped =
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)

suite "statistics-Uniform":
  let d = Uniform(a: 0.0, b: 5.0)
  
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
    checkQuantileBounds(d)
    check(approx(d.quantile(0.2), 1.0))
    check(approx(d.quantile(0.9), 4.5))

suite "statistics-Normal":
  let d = Normal(mean: 0.0, variance: 1.0)

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
    checkQuantileBounds(d)
    check(approx(d.quantile(0.000337), -3.4))
    check(approx(d.quantile(0.135667), -1.1))
    check(approx(d.quantile(0.5), 0.0))
    check(approx(d.quantile(0.864334), 1.1))
    check(approx(d.quantile(0.999663), 3.4))

suite "statistics-Exponential":
  let d = Exponential(beta: 2.0)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.0), 0.0))
    check(approx(d.pdf(1.0), 0.303265))
    check(approx(d.pdf(5.0), 0.041043))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.575364), 0.25))
    check(approx(d.cdf(1.38629), 0.5))
    check(approx(d.cdf(2.77259), 0.75))

  test "quantile":
    checkQuantileBounds(d)
    check(approx(d.quantile(0.25), 0.575364))
    check(approx(d.quantile(0.5), 1.38629))
    check(approx(d.quantile(0.75), 2.77259))

suite "statistics-Gamma":
  # Same as Exponential(beta: 2.0) for easy testing
  let d = Gamma(alpha: 1.0, beta: 2.0)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.0), 0.0))
    check(approx(d.pdf(1.0), 0.303265))
    check(approx(d.pdf(5.0), 0.041043))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.575364), 0.25))
    check(approx(d.cdf(1.38629), 0.5))
    check(approx(d.cdf(2.77259), 0.75))

  test "quantile":
    checkQuantileBounds(d)
    check(approx(d.quantile(0.25), 0.575364))
    check(approx(d.quantile(0.5), 1.38629))
    check(approx(d.quantile(0.75), 2.77259))

suite "statistics-Beta":
  let d = Beta(alpha: 1.0, beta: 2.0)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.0), 0.0))
    check(approx(d.pdf(0.1), 1.8))
    check(approx(d.pdf(0.5), 1.0))
    check(approx(d.pdf(0.9), 0.2))
  
  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.0), 0.0))
    check(approx(d.cdf(0.1), 0.19))
    check(approx(d.cdf(0.5), 0.75))
    check(approx(d.cdf(0.9), 0.99))

  test "quantile":
    checkQuantileBounds(d)
    check(approx(d.quantile(0.19), 0.1))
    check(approx(d.quantile(0.75), 0.5))
    check(approx(d.quantile(0.99), 0.9))

suite "statistics-StudentT":
  let d = StudentT(nu: 1)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.159155))
    check(approx(d.pdf(0.0), 0.31831))
    check(approx(d.pdf(1.0), 0.159155))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.25))
    check(approx(d.cdf(0.0), 0.5))
    check(approx(d.cdf(1.0), 0.75))

  test "quantile":
    checkQuantileBounds(d)
    check(approx(d.quantile(0.25), -1.0))
    check(approx(d.quantile(0.5), 0.0))
    check(approx(d.quantile(0.75), 1.0))

suite "statistics-Cauchy":
  let d = Cauchy()

  test "pdf":
    check(approx(d.pdf(-1.0), 0.159155))
    check(approx(d.pdf(0.0), 0.31831))
    check(approx(d.pdf(1.0), 0.159155))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.25))
    check(approx(d.cdf(0.0), 0.5))
    check(approx(d.cdf(1.0), 0.75))

  test "quantile":
    checkQuantileBounds(d)
    check(approx(d.quantile(0.25), -1.0))
    check(approx(d.quantile(0.5), 0.0))
    check(approx(d.quantile(0.75), 1.0))

suite "statistics-ChiSquared":
  let d = ChiSquared(p: 3)

  test "pdf":
    check(approx(d.pdf(-1.0), 0.0))
    check(approx(d.pdf(0.5), 0.219696))
    check(approx(d.pdf(1.0), 0.241971))
    check(approx(d.pdf(3.0), 0.15418))

  test "cdf":
    check(approx(d.cdf(-1.0), 0.0))
    check(approx(d.cdf(0.5), 0.0811086))
    check(approx(d.cdf(1.0), 0.198748))
    check(approx(d.cdf(3.0), 0.608375))

  test "quantile":
    checkQuantileBounds(d)
    check(approx(d.quantile(0.0811086), 0.5))
    check(approx(d.quantile(0.198748), 1.0))
    check(approx(d.quantile(0.608375), 3.0))
