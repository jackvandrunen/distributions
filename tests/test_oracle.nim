import ../statistics/private/arc4
import ../statistics/oracle
import unittest

suite "statistics-oracle":
  let v1 = @[116u8, 148, 194, 231, 16, 75, 8, 121, 13, 75, 213, 83, 50, 143, 30, 252]
  let v2 = @[219u8, 194, 74, 211, 97, 45, 11, 136, 238, 223, 113, 170, 94, 82, 11, 45]
  var r1 = initARC4(@[0x01u8, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF])
  var r2 = initARC4(@[0xFEu8, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10])

  test "arc4":
    check(r1.randbytes(16) == v1)
    check(r2.randbytes(16) == v2)

  test "default state":
    let
      x = rand()
      y = rand()
    check(x != y)
