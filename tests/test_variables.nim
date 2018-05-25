import ../statistics/variables
import ../statistics/distributions/DiscreteUniform
import ../statistics/distributions/Uniform
import ./ut_utils
import math
import unittest

suite "statistics-variables":
  let fd = Uniform(0.0, 5.0)
  let id = DiscreteUniform(5)
  proc testOracle(): float =
    0.5

  test "random variable":
    check(approx(fd.random(testOracle), 2.5))
    check(id.random(testOracle) == 3)

  test "random sample":
    let
      fsamp = fd.sample(10, testOracle)
      isamp = id.sample(10, testOracle)
    for i in 0..9:
      check(approx(fsamp[i], 2.5))
      check(isamp[i] == 3)
  
  test "default oracle":
    let
      x = fd.random()
      y = fd.random()
    check(x != y)
