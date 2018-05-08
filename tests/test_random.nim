import ../statistics/random

when isMainModule:
  var state = initRand(0)
  echo "initRand(0)"
  echo state.rand()
  echo state.rand()
  echo state.rand()
  echo state.rand()
  echo state.rand()
  echo()

  echo "default state:"
  echo rand()
  echo rand()
  echo rand()
  echo rand()
  echo rand()
  echo()

  var
    state1 = initRand()
    state2 = initRand()
    state3 = initRand()
  echo "initRand()"
  echo state1.rand()
  echo state1.rand()
  echo state1.rand()
  echo state1.rand()
  echo state1.rand()
  echo()

  echo "initRand()"
  echo state2.rand()
  echo state2.rand()
  echo state2.rand()
  echo state2.rand()
  echo state2.rand()
  echo()

  echo "initRand()"
  echo state3.rand()
  echo state3.rand()
  echo state3.rand()
  echo state3.rand()
  echo state3.rand()
  echo()
