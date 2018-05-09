TESTBINS = tests/test_random tests/test_distributions
UTIL = tests/ut_utils.nim
TESTSRC = tests/test_
UNITSRC = tests/ut_utils.nim $(TESTSRC)
SRC = statistics/
NCFLAGS = --verbosity:0 --hints:off
UTFLAGS = $(NCFLAGS) -r
NC = nim c

test: $(TESTBINS)

tests/test_random: $(UNITSRC)random.nim $(SRC)random.nim
	$(NC) $(UTFLAGS) $(TESTSRC)random.nim

tests/test_distributions: $(UNITSRC)distributions.nim $(SRC)distributions.nim $(SRC)roots.nim
	$(NC) $(UTFLAGS) $(TESTSRC)distributions.nim

clean:
	/bin/rm -f $(TESTBINS)
	/bin/rm -rf tests/nimcache
