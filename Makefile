UTIL = tests/ut_utils.nim
NCFLAGS = --verbosity:0 --hints:off
NC = nim c

test: tests/test_random tests/test_distributions
	tests/test_random
	tests/test_distributions

tests/test_random: $(UTIL) tests/test_random.nim statistics/random.nim
	$(NC) $(NCFLAGS) tests/test_random.nim

tests/test_distributions: $(UTIL) tests/test_distributions.nim statistics/distributions.nim statistics/roots.nim
	$(NC) $(NCFLAGS) tests/test_distributions.nim
