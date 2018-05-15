import nake
import strformat
import os

const
  UTIL = "tests/ut_utils.nim"
  CACHE = "tests/nimcache"
  BuildFlags = "--verbosity:0"

const
  tests = @[
    @[
      "tests/test_random.nim",
      "statistics/random.nim",
      UTIL
    ],
    @[
      "tests/test_distributions.nim",
      "statistics/distributions.nim",
        "statistics/roots.nim",
        "statistics/functions.nim",
      UTIL
    ],
    @[
      "tests/test_variables.nim",
      "statistics/variables.nim",
        "statistics/distributions.nim",
          "statistics/roots.nim",
          "statistics/functions.nim",
        "statistics/random.nim",
      UTIL
    ]
  ]

proc buildAll(): seq[string] =
  result = newSeq[string]()
  for testFiles in tests:
    let target = testFiles[0][0..^5]
    if needsRefresh(target, testFiles):
      echo fmt"Building {target}..."
      direShell(nimExe, "c", BuildFlags, target)
      result.add(target)

proc runTests(testsToRun: openarray[string]) =
  for target in testsToRun:
    direShell(target)

proc clean() =
  for testFiles in tests:
    let target = testFiles[0][0..^5]
    echo fmt"Removing {target}..."
    removeFile(target)
  echo fmt"Removing {CACHE}..."
  removeDir(CACHE)

task "test", "Run unit tests on all newly modified files":
  let testsToRun = buildAll()
  runTests(testsToRun)
  echo "\pAll tests passed!"

task "clean", "Delete all test binaries and cache":
  clean()
