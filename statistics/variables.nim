import ./distributions
import ./oracle

proc random*[T](d: IDistribution[T], oracle: proc(): float = rand): T =
  d.quantile(oracle())

proc sample*[T](d: IDistribution[T], n: int, oracle: proc(): float = rand): seq[T] {.inline.} =
  result = newSeq[T](n)
  for i in 0..n-1:
    result[i] = d.random(oracle)
