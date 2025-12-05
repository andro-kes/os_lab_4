#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

# Resolve script directory and build dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"

# Ensure build dir exists
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}Build directory not found: $BUILD_DIR${NC}"
    exit 2
fi

# Helper: run a program and extract numeric result from first printed line like "... = 3.14"
run_and_extract() {
    local workdir=$1
    local prog_cmd=$2
    local input=$3
    # run from workdir so dlopen("./lib1.so") finds libs
    echo "$input" | (cd "$workdir" && eval "$prog_cmd") 2>/dev/null | head -n 1 | grep -oP '= \K[0-9]+(\.[0-9]+)?' || true
}

# Function to run a test (program path is full or a bash command)
run_test() {
    local test_name=$1
    local prog_cmd=$2    # command to run (e.g. "./program2" or "$BUILD_DIR/program1")
    local input=$3
    local expected=$4
    local workdir=${5:-"$BUILD_DIR"} # optional working dir (default build)

    echo -n "Testing $test_name... "

    result=$(run_and_extract "$workdir" "$prog_cmd" "$input")

    if [ -z "$result" ]; then
        echo -e "${RED}FAILED${NC} (no output)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return
    fi

    # Compare within tolerance 0.01
    diff=$(echo "scale=6; if ($result - $expected < 0.01 && $result - $expected > -0.01) 1 else 0" | bc -l)

    if [ "$diff" = "1" ]; then
        echo -e "${GREEN}PASSED${NC} (got $result)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}FAILED${NC} (expected $expected, got $result)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo "========================================"
echo "Testing Program 1 (Static Linking)"
echo "========================================"

# check program1 exists
if [ ! -x "$BUILD_DIR/program1" ]; then
    echo -e "${RED}program1 not found or not executable: $BUILD_DIR/program1${NC}"
    exit 2
fi

# Test Pi with K=1000 (should be close to 3.14159)
run_test "Pi(1000) Leibniz" "$BUILD_DIR/program1" "1 1000" "3.14" "$BUILD_DIR"
# Test Square for rectangle 5x4 = 20
run_test "Square(5,4) Rectangle" "$BUILD_DIR/program1" "2 5 4" "20" "$BUILD_DIR"

echo ""
echo "========================================"
echo "Testing Program 2 (Dynamic Loading)"
echo "========================================"

# check program2 exists
if [ ! -x "$BUILD_DIR/program2" ]; then
    echo -e "${RED}program2 not found or not executable: $BUILD_DIR/program2${NC}"
    exit 2
fi

# For program2 we must run it from BUILD_DIR so that dlopen("./lib1.so") finds libs.
run_test "Pi(1000) Leibniz (lib1)" "bash -c './program2'" "1 1000" "3.14" "$BUILD_DIR"
run_test "Square(5,4) Rectangle (lib1)" "bash -c './program2'" "2 5 4" "20" "$BUILD_DIR"

# Test switching to lib2 and Square for triangle 5x4 = 10
echo -n "Testing Library Switch and Square(5,4) Triangle (lib2)... "
result=$(run_and_extract "$BUILD_DIR" "bash -c './program2'" $'0\n2 5 4')
if [ -z "$result" ]; then
    echo -e "${RED}FAILED${NC} (no output)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
else
    diff=$(echo "scale=6; if ($result - 10 < 0.01 && $result - 10 > -0.01) 1 else 0" | bc -l)
    if [ "$diff" = "1" ]; then
        echo -e "${GREEN}PASSED${NC} (got $result)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}FAILED${NC} (expected 10, got $result)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
fi

# Test Pi with K=100 using lib2 (Wallis) after switch
echo -n "Testing Pi(100) Wallis (lib2) after switch... "
result=$(run_and_extract "$BUILD_DIR" "bash -c './program2'" $'0\n1 100')
if [ -z "$result" ]; then
    echo -e "${RED}FAILED${NC} (no output)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
else
    diff=$(echo "scale=6; if ($result - 3.14 < 0.1 && $result - 3.14 > -0.1) 1 else 0" | bc -l)
    if [ "$diff" = "1" ]; then
        echo -e "${GREEN}PASSED${NC} (got $result)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}FAILED${NC} (expected ~3.14, got $result)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
fi

echo ""
echo "========================================"
echo "Test Summary"
echo "========================================"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
fi