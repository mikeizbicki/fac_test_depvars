#!/bin/bash

# These tests verify that weird variable combinations work

source ../framework.sh

# first check that building from scratch works
reset_git
fac 'sub$LEVEL1/summary_NOVAR.md'
ls -R | dotest checkpoint_NOVAR

reset_git
fac 'sub$LEVEL1/summary_SAMEVAR.md'
ls -R | dotest checkpoint_SAMEVAR

reset_git
fac 'sub$LEVEL1/summary_VARSUBSET.md'
ls -R | dotest checkpoint_VARSUBSET

reset_git
fac 'sub$LEVEL1/summary_FOO.md'
ls -R | dotest checkpoint_FOO

reset_git
fac 'sub$LEVEL1/summary_DEP.md'
ls -R | dotest checkpoint_DEP

reset_git
fac 'sub$LEVEL1/summary_EMPTY.md'
ls -R | dotest checkpoint_EMPTY

# now run tests where we are not building from scratch
# (we still call reset_git before each test,
# but we build other targets before the test target)
reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_NOVAR.md'
ls -R | dotest checkpoint_NOVAR

reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_SAMEVAR.md'
ls -R | dotest checkpoint_SAMEVAR

# the tests below will not exactly match the from scratch tests because
# the final test does not include all of 'sub$LEVEL1/sub$LEVEL2/outline.json';
# for this reason, they have different checkpoints
reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_VARSUBSET.md'
ls -R | dotest checkpoint_VARSUBSET_noscratch

reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_FOO.md'
ls -R | dotest checkpoint_FOO_noscratch

reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_DEP.md'
ls -R | dotest checkpoint_DEP_noscratch

reset_git
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_EMPTY.md'
ls -R | dotest checkpoint_EMPTY_noscratch


finalize_tests
