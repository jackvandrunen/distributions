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

proc findParams*(f: proc(x: openarray[float], p: openarray[float]): float,
                 xData: seq[seq[float]], yData: seq[float],
                 pGuess: openarray[float], rate = 0.01, delta = 0.0001): seq[float] =
  proc mse(p: openarray[float]): float =
    for i, x in xData:
      let error = f(x, p) - yData[i]
      result += error * error
    result /= float(xData.len)
  proc partial(p: openarray[float], i: int): float =
    var params = newSeq[float](p.len)
    for j in 0..p.len - 1:
      params[j] = p[j]
    params[i] = p[i] + delta
    let h = mse(params)
    params[i] = p[i] - delta
    let l = mse(params)
    (h - l) / (2.0 * delta)
  var
    prev = Inf
    loss = mse(pGuess)
    paramsHigh = pGuess.len - 1
  result = newSeq[float](pGuess.len)
  for i in 0..paramsHigh:
    result[i] = pGuess[i]
  var estimate = newSeq[float](pGuess.len)
  while true:
    for i in 0..paramsHigh:
      estimate[i] = result[i] - (rate * partial(result, i))
    prev = loss
    loss = mse(estimate)
    if loss >= prev:
      break
    for i in 0..paramsHigh:
      result[i] = estimate[i]
