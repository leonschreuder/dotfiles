
setup() {
    source .gprofile
}

test_jobCountAsString_ShouldReturnEmptyStringPerDefault() {
    source .gprofile

    result=$( getJobCount )

    if [[ $result != 0 ]]; then
        fail "expected 0, got $result"
    fi
}

test_jobCountAsString_ShouldCountWhenExistant() {
    # start process squelching the output
    (ping localhost -c 1  > /dev/null ) &

    result=$( getJobCount )

    killTillDead $(jobs -p)

    expected=1
    if [[ $result != $expected ]]; then
        fail "expected '$expected', got '$result'"
    fi
}

test_getNestingDepth() {
    expectedDepth=$((LC_NESTING_DEPTH + 1))

    result=$( getNestingDepth )

    if [[ $result != $expectedDepth ]]; then
        fail "expected $expectedDepth, got '$result'"
    fi
}

test_getPrequal() {
    nestingDepth=$(getNestingDepth)

    result=$( getPrequal )

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

    expected='₁₂₃₄₅₆₇₈'
    if [[ $result != $expected ]]; then
        fail "expected '$expected', got '$result'"
    fi
}

test_intToSuperScript_ShouldHandleAll() {
    result=''
    for i in {1..8}; do
        result=$result$(intToSuperScript $i)
    done

    expected='¹²³⁴⁵⁶⁷⁸'
    if [[ $result != $expected ]]; then
        fail "expected '$expected', got '$result'"
    fi
}

# HELPERS
#--------------------------------------------------------------------------------

killTillDead() {
    echo $1 &> /dev/null | xargs kill -9
    # this takes a little bit, so wait to not mess up the other tests.
    wait $1
}
