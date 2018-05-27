template checkNormal(x: float) =
  if not (0.0 < x and x < 1.0):
    raise newException(ValueError, "Quantile function is defined on (0,1)")
