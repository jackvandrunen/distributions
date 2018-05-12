import ../statistics/distributions
import ./ut_utils
import unittest

template checkQuantileBounds(d): untyped =
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)

suite "statistics-PointMass":
  let d = PointMass(a: 12)

  test "pmf":
    check(approx(d.pmf(9), 0.0))
    check(approx(d.pmf(12), 1.0))
    check(approx(d.pmf(30), 0.0))

  test "cdf":
    check(approx(d.cdf(9), 0.0))
    check(approx(d.cdf(12), 1.0))
    check(approx(d.cdf(30), 1.0))

  test "quantile":
    checkQuantileBounds(d)
    check(d.quantile(0.1) == 12)
    check(d.quantile(0.5) == 12)
    check(d.quantile(0.9) == 12)

suite "statistics-DiscreteUniform":
  let d = DiscreteUniform(k: 10)
  
  test "pmf":
    check(approx(d.pmf(-5), 0.0))
    check(approx(d.pmf(2), 0.1))
    check(approx(d.pmf(10), 0.1))
    check(approx(d.pmf(40), 0.0))

  test "cdf":
    check(approx(d.cdf(-5), 0.0))
    check(approx(d.cdf(7), 0.7))
    check(approx(d.cdf(10), 1.0))
    check(approx(d.cdf(40), 1.0))

  test "quantile":
    checkQuantileBounds(d)
    check(d.quantile(0.05) == 1)
    check(d.quantile(0.7) == 8)
    check(d.quantile(0.75) == 8)
    check(d.quantile(0.9) == 10)

suite "statistics-Bernoulli":
  let d = Bernoulli(p: 0.7)
  
  test "pmf":
    check(approx(d.pmf(-1), 0.0))
    check(approx(d.pmf(0), 0.3))
    check(approx(d.pmf(1), 0.7))
    check(approx(d.pmf(3), 0.0))
  
  test "cdf":
    check(approx(d.cdf(-1), 0.0))
    check(approx(d.cdf(0), 0.3))
    check(approx(d.cdf(1), 1.0))
    check(approx(d.cdf(3), 1.0))

  test "quantile":
    checkQuantileBounds(d)
    check(d.quantile(0.1) == 0)
    check(d.quantile(0.29) == 0)
    check(d.quantile(0.31) == 1)
    check(d.quantile(0.7) == 1)

suite "statistics-Binomial":
  let d = Binomial(n: 10, p: 0.35)

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
    checkQuantileBounds(d)
    check(d.quantile(0.001) == 0)
    check(d.quantile(0.08) == 1)
    check(d.quantile(0.51) == 3)
    check(d.quantile(0.97) == 6)

suite "statistics-Geometric":
  let d = Geometric(p: 0.01)

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
    checkQuantileBounds(d)
    check(d.quantile(0.09561) == 10)
    check(d.quantile(0.39498) == 50)
    check(d.quantile(0.63396) == 100)
    check(d.quantile(0.95095) == 300)

suite "statistics-Poisson":
  let d = Poisson(lambda: 4.0)

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
    checkQuantileBounds(d)
    check(d.quantile(0.01831) == 0)
    check(d.quantile(0.09157) == 1)
    check(d.quantile(0.62883) == 4)
    check(d.quantile(0.99715) == 10)

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
