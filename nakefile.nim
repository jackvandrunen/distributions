import nake
import findtests
import strformat

const
  TestDir = "build"
  TestBin = "build/run_tests"
  TestSrc = "build/run_tests.nim"
  Tests = "tests"
  Excludes = @["ut_utils.nim"]

task "test", "Build and run all unit tests":
  echo "Generating tests..."
  removeDir(TestDir)
  createDir(TestDir)
  generateTestsFile(TestSrc, Tests, Excludes)
  direSilentShell("Building tests...", nimExe, "c", "-o:" & TestBin, TestSrc)
  direSilentShell("Running tests...", TestBin)
  echo "All tests passed!"

task "clean", "Delete all test binaries and cache":
  echo fmt"Removing {TestDir}..."
  removeDir(TestDir)
