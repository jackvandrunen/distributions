import ./distributions
import ./random

type FloatRandomVariable* = iterator(): float
type IntRandomVariable* = iterator(): int

proc RandomVariable*(d: FloatDistribution, oracle: proc(): float): FloatRandomVariable =
  (iterator(): float =
    while true:
      yield d.quantile(oracle()))

proc RandomVariable*(d: FloatDistribution): FloatRandomVariable =
  RandomVariable(d, rand)

proc RandomVariable*(d: IntDistribution, oracle: proc(): float): IntRandomVariable =
  (iterator(): int =
    while true:
      yield d.quantile(oracle()))

proc RandomVariable*(d: IntDistribution): IntRandomVariable =
  RandomVariable(d, rand)
