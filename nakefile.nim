import nake
import findtests
import strformat
import sequtils

const
  TESTS = "tests"
  EXCLUDES = @["ut_utils.nim"]
  CACHE = "tests/nimcache"
  BuildFlags = "--verbosity:0 --hints:off"

proc buildAll(): seq[string] =
  result = newSeq[string]()
  for testFiles in findTests(TESTS, EXCLUDES):
    let target = testFiles[0][0..^5]
    if needsRefresh(target, testFiles):
      echo fmt"Building {target}..."
      direShell(nimExe, "c", BuildFlags, target)
      result.add(target)

proc runTests(testsToRun: openarray[string]) =
  putEnv("NIMTEST_OUTPUT_LVL", "PRINT_FAILURES")
  for target in testsToRun:
    shell(target)

proc clean() =
  for testFiles in findTests(TESTS, EXCLUDES):
    let target = testFiles[0][0..^5]
    echo fmt"Removing {target}..."
    removeFile(target)
  echo fmt"Removing {CACHE}..."
  removeDir(CACHE)

task "test", "Run unit tests on all newly modified files":
  let testsToRun = buildAll()
  runTests(testsToRun)
  echo "\pAll tests updated!"

task "retest", "Run all unit tests":
  runTask("clean")
  runTask("test")

task "clean", "Delete all test binaries and cache":
  clean()
