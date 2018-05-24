import ../../statistics/distributions
import ../../statistics/distributions/DiscreteUniform
import ../ut_utils
import unittest

suite "statistics-DiscreteUniform":
  let d = DiscreteUniform(10)
  let d2: IDistribution[int] = d
  
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
    expect(ValueError):
      discard d.quantile(-0.1)
    expect(ValueError):
      discard d.quantile(1.1)
    check(d.quantile(0.05) == 1)
    check(d.quantile(0.7) == 8)
    check(d.quantile(0.75) == 8)
    check(d.quantile(0.9) == 10)

  test "pmf-i":
    check(approx(d2.pdf(-5), 0.0))
    check(approx(d2.pdf(2), 0.1))
    check(approx(d2.pdf(10), 0.1))
    check(approx(d2.pdf(40), 0.0))

  test "cdf-i":
    check(approx(d2.cdf(-5), 0.0))
    check(approx(d2.cdf(7), 0.7))
    check(approx(d2.cdf(10), 1.0))
    check(approx(d2.cdf(40), 1.0))

  test "quantile-i":
    expect(ValueError):
      discard d2.quantile(-0.1)
    expect(ValueError):
      discard d2.quantile(1.1)
    check(d2.quantile(0.05) == 1)
    check(d2.quantile(0.7) == 8)
    check(d2.quantile(0.75) == 8)
    check(d2.quantile(0.9) == 10)

# suite "statistics-Bernoulli":
#   let d = Bernoulli(p: 0.7)
  
#   test "pmf":
#     check(approx(d.pmf(-1), 0.0))
#     check(approx(d.pmf(0), 0.3))
#     check(approx(d.pmf(1), 0.7))
#     check(approx(d.pmf(3), 0.0))
  
#   test "cdf":
#     check(approx(d.cdf(-1), 0.0))
#     check(approx(d.cdf(0), 0.3))
#     check(approx(d.cdf(1), 1.0))
#     check(approx(d.cdf(3), 1.0))

#   test "quantile":
#     checkQuantileBounds(d)
#     check(d.quantile(0.1) == 0)
#     check(d.quantile(0.29) == 0)
#     check(d.quantile(0.31) == 1)
#     check(d.quantile(0.7) == 1)

# suite "statistics-Binomial":
#   let d = Binomial(n: 10, p: 0.35)

#   test "pmf":
#     check(approx(d.pmf(-1), 0.0))
#     check(approx(d.pmf(0), 0.01346))
#     check(approx(d.pmf(1), 0.07249))
#     check(approx(d.pmf(3), 0.25221))
#     check(approx(d.pmf(6), 0.06890))

#   test "cdf":
#     check(approx(d.cdf(-1), 0.0))
#     check(approx(d.cdf(0), 0.01346))
#     check(approx(d.cdf(1), 0.08595))
#     check(approx(d.cdf(3), 0.51382))
#     check(approx(d.cdf(6), 0.97397))

#   test "quantile":
#     checkQuantileBounds(d)
#     check(d.quantile(0.001) == 0)
#     check(d.quantile(0.08) == 1)
#     check(d.quantile(0.51) == 3)
#     check(d.quantile(0.97) == 6)

# suite "statistics-Geometric":
#   let d = Geometric(p: 0.01)

#   test "pmf":
#     check(approx(d.pmf(-1), 0.0))
#     check(approx(d.pmf(0), 0.0))
#     check(approx(d.pmf(10), 0.00913))
#     check(approx(d.pmf(50), 0.00611))
#     check(approx(d.pmf(100), 0.003697))

#   test "cdf":
#     check(approx(d.cdf(-1), 0.0))
#     check(approx(d.cdf(0), 0.0))
#     check(approx(d.cdf(10), 0.09562))
#     check(approx(d.cdf(50), 0.39499))
#     check(approx(d.cdf(100), 0.63397))
#     check(approx(d.cdf(300), 0.95096))

#   test "quantile":
#     checkQuantileBounds(d)
#     check(d.quantile(0.09561) == 10)
#     check(d.quantile(0.39498) == 50)
#     check(d.quantile(0.63396) == 100)
#     check(d.quantile(0.95095) == 300)

# suite "statistics-Poisson":
#   let d = Poisson(lambda: 4.0)

#   test "pmf":
#     check(approx(d.pmf(-1), 0.0))
#     check(approx(d.pmf(0), 0.01832))
#     check(approx(d.pmf(1), 0.07326))
#     check(approx(d.pmf(4), 0.19537))
#     check(approx(d.pmf(10), 0.00529))

#   test "cdf":
#     check(approx(d.cdf(-1), 0.0))
#     check(approx(d.cdf(0), 0.01832))
#     check(approx(d.cdf(1), 0.09158))
#     check(approx(d.cdf(4), 0.62884))
#     check(approx(d.cdf(10), 0.99716))
  
#   test "quantile":
#     checkQuantileBounds(d)
#     check(d.quantile(0.01831) == 0)
#     check(d.quantile(0.09157) == 1)
#     check(d.quantile(0.62883) == 4)
#     check(d.quantile(0.99715) == 10)
