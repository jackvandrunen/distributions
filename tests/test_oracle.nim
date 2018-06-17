import ../statistics/oracle
import ./ut_utils
import unittest

suite "statistics-oracle":
  let seed = [0x853c49e6748fea9b'u64, 0xda3e39cb94b95bdb'u64, 0x9bea8f74e6493c85'u64, 0xdb5bb994cb393eda'u64]
  var o = initOracle(seed)

  test "default state":
    let
      x = rand()
      y = rand()
    check(x != y)

  test "seeded":
    check(approx(o.rand(), 0.082713))
    check(approx(o.rand(), 0.009710))
    check(approx(o.rand(), 0.793087))
    check(approx(o.rand(), 0.974792))
    check(approx(o.rand(), 0.112663))
    check(o.seed == seed)
