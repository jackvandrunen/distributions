import ./distributions

proc random*[T](d: Distribution[T], oracle: proc(): float): T =
  d.quantile(oracle())

proc sample*[T](d: Distribution[T], n: int, oracle: proc(): float): seq[T] =
  result = newSeq[T](n)
  for i in 0..n-1:
    result[i] = d.random(oracle)

when not defined(nimscript):
  import ./oracle

  proc random*[T](d: Distribution[T]): T =
    d.random(rand)

  proc sample*[T](d: Distribution[T]): seq[T] =
    d.sample(rand)
