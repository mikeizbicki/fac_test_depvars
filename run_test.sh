#!/bin/sh

#set -ex
alias fac='python3 -m fac --auto_commit=False'

# The idea of this test script is that we will run a series of build commands
# and check to see if the files that have been created match the files that should have been created.
# This function performs the actual check to see if the files match and will be called by the test cases below.
dotest() {
    # NOTE:
    # The testing procedure is inspired by the standard for postgresql test scripts.
    # This function should be called with a single parameter,
    # which is the name of the test case.
    # The ground truth files that should exist will be stored in the `.expected` folder,
    # and the files that actually exist after the run of these tests will be stored in the `.results` folder.
    # The `.results` folder should never be added to the git repo.
    # We use hidden folder names (prefixed with the dot) so that they do not get tracked with the ls -R command.
    mkdir -p .results
    ls -R > .results/"$1" # ls -R lists all files, including those in subfolders
    diff .results/"$1" .expected/"$1"
}

# This function cleans all files in the repo except those in the .results folder.
# It is useful for writing tests that build from scratch.
clean_repo() {
    git clean -fd -e .results/
}

# The checks will all fail if there are uncommitted files in the repo.
# We therefore ensure there are no uncommitted files before performing the tests.
if ! [ -z "$(git status --porcelain)" ]; then
    echo 'ERROR: The git repo is not clean (i.e. you may have uncommitted files), but the test script requires a clean repo. You should either commit the files or delete them.'
    echo 'HINT: You can delete all uncommitted files with the `git clean -fd` command.'
    exit 1
fi

# first check that building from scratch works
clean_repo
fac 'sub$LEVEL1/summary_NOVAR.md'
dotest checkpoint_NOVAR

clean_repo
fac 'sub$LEVEL1/summary_SAMEVAR.md'
dotest checkpoint_SAMEVAR

clean_repo
fac 'sub$LEVEL1/summary_VARSUBSET.md'
dotest checkpoint_VARSUBSET

clean_repo
fac 'sub$LEVEL1/summary_FOO.md'
dotest checkpoint_FOO

clean_repo
fac 'sub$LEVEL1/summary_DEP.md'
dotest checkpoint_DEP_noscratch

# verify that we get the same results when not building from scratch
clean_repo
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_NOVAR.md'
dotest checkpoint_NOVAR

clean_repo
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_SAMEVAR.md'
dotest checkpoint_SAMEVAR

# these will be slightly different because we didn't build all of 'sub$LEVEL1/sub$LEVEL2/outline.json' when building from scratch, only those portions needed by the subset
clean_repo
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_VARSUBSET.md'
dotest checkpoint_VARSUBSET_noscratch

clean_repo
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_FOO.md'
dotest checkpoint_FOO_noscratch

clean_repo
fac 'sub$LEVEL1/sub$LEVEL2/outline.json'
fac 'sub$LEVEL1/summary_DEP.md'
dotest checkpoint_DEP_noscratch

# Finally, we remove all of the build artifacts that we've created.
# But we leave the "results/" folder so that it can be used to create the "expected" folder if desired.
clean_repo
