import ../statistics/oracle
import ./ut_utils
import unittest

suite "statistics-oracle":
  var state = initOracle(0)

  test "zero state":
    check(approx(state.rand(), 0.60126))
    check(approx(state.rand(), 0.74777))
    check(approx(state.rand(), 0.10301))
    check(approx(state.rand(), 0.41658))
    check(approx(state.rand(), 0.73299))

  test "default state":
    let
      x = rand()
      y = rand()
    check(x != y)
