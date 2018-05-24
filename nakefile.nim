import nake
import findtests
import strformat
import sequtils

const
  TESTS = "tests"
  EXCLUDES = @["ut_utils.nim"]
  CACHES = @["tests/nimcache", "tests/distributions/nimcache"]
  BuildFlags = "--verbosity:0 --hints:off"

proc buildAll(): seq[string] =
  result = newSeq[string]()
  for testFiles in findTests(TESTS, EXCLUDES):
    let target = testFiles[0][0..^5]
    if needsRefresh(target, testFiles):
      echo fmt"Building {target}..."
      direShell(nimExe, "c", BuildFlags, target)
      result.add(target)

proc getTests(): seq[string] =
  result = newSeq[string]()
  for testFiles in findTests(TESTS, EXCLUDES):
    result.add(testFiles[0][0..^5])

proc runTests(testsToRun: openarray[string]) =
  putEnv("NIMTEST_OUTPUT_LVL", "PRINT_FAILURES")
  for target in testsToRun:
    shell(target)

proc clean() =
  for testFiles in findTests(TESTS, EXCLUDES):
    let target = testFiles[0][0..^5]
    echo fmt"Removing {target}..."
    removeFile(target)
  for cache in CACHES:
    echo fmt"Removing {cache}..."
    removeDir(cache)

task "test", "Run unit tests on all newly modified files":
  discard buildAll()
  let testsToRun = getTests()
  runTests(testsToRun)
  echo "\pAll tests passed!"

task "clean", "Delete all test binaries and cache":
  clean()
