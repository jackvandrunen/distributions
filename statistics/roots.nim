proc discreteInf*(cdf: proc(x: int): float, q: float, start = 0): int =
  var i = start
  while true:
    if cdf(i) >= q:
      return i
    inc i
