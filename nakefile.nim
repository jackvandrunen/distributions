import nake
import strformat
import os
import osproc
import sets
import strutils
import sequtils


## This is a small module which dynamically detects module dependencies, useful
## for automatically recompiling and running unit tests based on which files
## have been updated since the test harness was built last.
## TODO: This should probably end up as its own library on Nimble


proc joinPaths(path1, path2: string): string =
  if path1[^1] == '/':
    path1 & path2
  else:
    path1 & "/" & path2

proc parentPath(path: string): string =
  var i = path.len - 2  # ignore trailing slash
  while path[i] != '/':
    dec i
  path[0..i]

proc expandPath(filename, root: string): string =
  if filename[0..1] == "./":
    joinPaths(root, filename[2..^1])
  elif filename[0..2] == "../":
    joinPaths(parentPath(root), filename[3..^1])
  elif filename[0] == '/':
    filename
  else:
    joinPaths(root, filename)

proc followDependencyTree(path: string, includes: ptr HashSet[string]) =
  let imports = splitLines(execProcess("/bin/grep", @["import \\.", path], options={}))
  let root = parentPath(path)
  for i in 0..imports.len-1:
    if imports[i].len > 0 and not includes[].contains(imports[i]):
      let newInclude = expandPath(imports[i][7..^1] & ".nim", root)
      includes[].incl(newInclude)
      followDependencyTree(newInclude, includes)

proc getRelativeImports(path: string): HashSet[string] =
  result = initSet[string]()
  followDependencyTree(path, addr result)

proc includeTests(path: string, exclude: openarray[string]): seq[seq[string]] =
  result = newSeq[seq[string]]()
  let testsDir = expandFilename(path)
  var toExclude = initSet[string](exclude.len)
  for excludeFile in exclude:
    toExclude.incl(expandPath(excludeFile, testsDir))
  for testSrc in walkFiles(joinPaths(testsDir, "*.nim")):
    if toExclude.contains(testSrc):
      continue
    result.add(concat(@[testSrc], toSeq(getRelativeImports(testSrc).items())))


## This is the actual code for the nakefile


const
  TESTS = "tests"
  EXCLUDES = @["ut_utils.nim"]
  CACHE = "tests/nimcache"
  BuildFlags = "--verbosity:0 --hints:off"

proc buildAll(): seq[string] =
  result = newSeq[string]()
  for testFiles in includeTests(TESTS, EXCLUDES):
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
  for testFiles in includeTests(TESTS, EXCLUDES):
    let target = testFiles[0][0..^5]
    echo fmt"Removing {target}..."
    removeFile(target)
  echo fmt"Removing {CACHE}..."
  removeDir(CACHE)

task "test", "Run unit tests on all newly modified files":
  let testsToRun = buildAll()
  runTests(testsToRun)
  echo "\pAll tests updated!"

task "clean", "Delete all test binaries and cache":
  clean()
