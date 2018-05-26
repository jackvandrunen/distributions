import ../statistics/private/tables2
import tables
import unittest

suite "statistics-tables2":
  var sample = @[1, 2, 3, 2, 4, 2, 2, 3, 1, 6, 5, 2]
  var t = initOrderedCountTable(sample)
  var c = newCountTable(sample)

  test "counts":
    for i in t.items():
      check(c[i.k] == i.v)
    check(t.counter == 12)
  
  test "accessors":
    check(t[2] == 5)
    check(t.getOrDefault(10) == 0)
    check(t.getOrDefault(10, 1) == 1)
