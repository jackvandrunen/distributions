import ../statistics/variables
import ../statistics/distributions/DiscreteUniform
import ../statistics/distributions/Uniform
import ./ut_utils
import unittest

suite "statistics-variables":
  let fd = Uniform(0.0, 5.0)
  let id = DiscreteUniform(5)
  proc testOracle(): float =
    0.5

  test "random variable":
    discard fd.random()
    discard id.random()
    check(approx(fd.random(testOracle), 2.5))
    check(id.random(testOracle) == 3)

  test "random sample":
    discard fd.sample(10)
    discard id.sample(10)
    let fsamp = fd.sample(10, testOracle)
    let isamp = id.sample(10, testOracle)
    for i in 0..9:
      check(approx(fsamp[i], 2.5))
      check(isamp[i] == 3)
