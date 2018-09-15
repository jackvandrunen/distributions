proc discreteInf*(cdf: proc(x: int): float, q: float, start = 0): int =
  var i = start
  while true:
    if cdf(i) >= q:
      return i
    inc i

proc findRoot*(f: proc(x: float): float, y: float, xGuess = 0.0, rate = 0.1, delta = 0.0001): float =
  proc mse(z: float): float =
    result = f(z) - y
    result *= result
  proc slope(z: float): float =
    (mse(z + delta) - mse(z - delta)) / (2.0 * delta)
  var
    prev = Inf
    loss = mse(xGuess)
  result = xGuess
  while true:
    let estimate = result - (rate * slope(result))
    prev = loss
    loss = mse(estimate)
    if loss >= prev:
      break
    result = estimate
