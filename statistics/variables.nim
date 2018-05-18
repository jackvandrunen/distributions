import ./distributions
import ./oracle

proc random*(d: FloatDistribution, oracle: proc(): float = rand): float {.inline.} =
  d.quantile(oracle())

proc random*(d: IntDistribution, oracle: proc(): float = rand): int {.inline.} =
  d.quantile(oracle())

proc sample*(d: FloatDistribution, n: int, oracle: proc(): float = rand): seq[float] {.inline.} =
  result = newSeq[float](n)
  for i in 0..n-1:
    result[i] = d.random(oracle)

proc sample*(d: IntDistribution, n: int, oracle: proc(): float = rand): seq[int] {.inline.} =
  result = newSeq[int](n)
  for i in 0..n-1:
    result[i] = d.random(oracle)
