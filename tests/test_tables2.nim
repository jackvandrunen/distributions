import ../statistics/private/tables2
import ../statistics/variables
import ../statistics/distributions/Uniform
import ./ut_utils
import sequtils
import unittest

suite "statistics-OrderedCountTable":
  let s = @[1, 2, 3, 2, 4, 2, 2, 3, 1, 6, 5, 2]
  let s_inorder = @[(1, 2), (2, 5), (3, 2), (4, 1), (5, 1), (6, 1)]
  var d = initOrderedCountTable(s)
  let d_inorder = toSeq(d.items)
  var empty = initOrderedCountTable(newSeq[int]())
  var empty_inorder = toSeq(empty.items)

  test "inorder":
    check(d_inorder == s_inorder)
    check(empty_inorder == newSeq[tuple[k: int, v: int]]())
  
  test "get":
    check(d.getOrDefault(2) == 5)
    check(d.getOrDefault(10) == 0)
    check(d.getOrDefault(0) == 0)

  test "stress":
    var bigTable = initOrderedCountTable(sample(Uniform(0.0, 1.0), 1_000_000))
    var counter = 0
    var prev = -1.0
    for i in bigTable.items():
      check(prev < i.k)
      prev = i.k
      counter += i.v
    check(counter == 1_000_000)
    check(counter == bigTable.counter)
