template approx*(x, y: float, epsilon = 0.0001): bool =
  abs(x - y) <= epsilon
