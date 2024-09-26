TEST_DIR="$(pwd)/tmp_test"

setup() {
  rm -rf "$TEST_DIR"
  mkdir -p "$TEST_DIR"
  source ./ps1style.sh
}

teardown() {
  rm -rf "$TEST_DIR"
}

test_jobCountAsString_ShouldReturnEmptyStringPerDefault() {
  source .gprofile

  result=$( getJobCount )

  assertEquals 0 "$result"
}

test_jobCountAsString_ShouldCountWhenExistant() {
  # start process squelching the output
  (ping localhost -c 1  > /dev/null ) &

  result=$( getJobCount )

  killTillDead $(jobs -p)

  assertEquals 1 "$result"
}

test_getNestingDepthIndicator() {
  nestingDepth=$((LC_NESTING_DEPTH))

  result=$( getNestingDepthIndicator )

  if [[ ${#result} != $nestingDepth ]]; then
    fail "expected $nestingDepth, got '${#result}' (from '$result')"
  fi
  if [[ $result != "$PRE_CHAR"* ]]; then
    fail "expected '$result' to start with got '$PRE_CHAR'"
  fi
}

# @Ignore (session count dependent)
# test_getTmuxSessionCount() {
#     result=$(getTmuxSessionCount)

#     if [[ $result != 1 ]]; then
#         fail "expected 3, got '$result'"
#     fi
# }

test_intToSubScript_ShouldHandleAll() {
  result=''
  for i in {1..8}; do
    result=$result$(intToSubScript $i)
  done

  assertEquals '₁₂₃₄₅₆₇₈' "$result"
}

test_intToSuperScript_ShouldHandleAll() {
  result=''
  for i in {1..8}; do
    result=$result$(intToSuperScript $i)
  done

  assertEquals '¹²³⁴⁵⁶⁷⁸' "$result"
}

test_should_indicate_changes() {
  cd $TEST_DIR
  initEmptyGitRepo

  # no change no indicator
  assertEquals "" "$(getGitStatusIndicator)"

  # has changes to tracked files
  echo "a" > file.txt
  assertEquals "-" "$(getGitStatusIndicator)"

  # changes to tracked files are all added to index
  git add .
  assertEquals "+" "$(getGitStatusIndicator)"

  # changes that are partly added to index
  echo "b" >> file.txt
  assertEquals "+-" "$(getGitStatusIndicator)"

  # also untracked files
  touch newFile.txt
  assertEquals "+-?" "$(getGitStatusIndicator)"

  # only untracked files
  git reset --hard &>/dev/null
  assertEquals "?" "$(getGitStatusIndicator)"
}

test_getPrettyGitState() {
  cd "$TEST_DIR" || :
  initEmptyGitRepo
  echo "a" > file.txt

  result=$(getPrettyGitState)

  assertEquals '-main' "$result"
}

# HELPERS
#--------------------------------------------------------------------------------

killTillDead() {
  echo "$@" | xargs kill -9 2>/dev/null
  # this takes a little bit, so wait to not mess up the other tests.
  wait "$@"
}

initEmptyGitRepo() {
  ( cd $TEST_DIR
    git init -q
    touch file.txt
    git add .
    git commit -q -m "init"
  )
}
