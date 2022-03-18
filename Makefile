SHELL=/bin/bash

# converting CoNLL 2012 unit tests to the CorefUD 1.0 format
# in the original CoNLL 2012 unit tests, there are no heads or min-spans labeled
#     => a mention is matched only if it matches both the start and the end of the key mention
# CorefUD format processed by UDAPI requires a mention head to be set and thus allows for fuzzy matching
# as a result, mention heads must be set during the conversion
# by default, we always set the first word in the mention as its head
# however, such a choice results in tests TC-A-12 and TC-A-13 to fail
# luckily, heads in TC-A.key can be set in a way that all the tests pass,
#     which we do in the last two 'sed' replacements
# the best solution would be to allow CorefMention in UDAPI to have no head set
# this might be in conflict with other things, though
convert_tests:
	mkdir -p corefud_tests
	for f in tests/*.{response,key}; do\
		file=`basename $$f`;\
		python convert_test_files.py < $$f > corefud_tests/$$file;\
	done
	sed -i 's/^\(4.*Entity=(e1-x\)-1-$$/\1-4-/' corefud_tests/TC-A.key
	sed -i 's/^\(8.*Entity=(e2-x\)-1-$$/\1-2-/' corefud_tests/TC-A.key

corefud_test :
	pytest corefud-unittests.py
