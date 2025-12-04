#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name=$1
    local program=$2
    local input=$3
    local expected=$4
    
    echo -n "Testing $test_name... "
    
    # Get only stdout, ignore stderr
    result=$(echo "$input" | ./$program 2>/dev/null | head -n 1 | grep -oP '= \K[0-9]+(\.[0-9]+)?')
    
    # Compare using bc for floating point comparison
    if [ -z "$result" ]; then
        echo -e "${RED}FAILED${NC} (no output)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return
    fi
    
    # Check if result is close to expected (within 0.01)
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

# Test Pi with K=1000 (should be close to 3.14159)
run_test "Pi(1000) Leibniz" "program1" "1 1000" "3.14"

# Test Square for rectangle 5x4 = 20
run_test "Square(5,4) Rectangle" "program1" "2 5 4" "20"

echo ""
echo "========================================"
echo "Testing Program 2 (Dynamic Loading)"
echo "========================================"

# Test Pi with K=1000 using lib1 (Leibniz)
run_test "Pi(1000) Leibniz (lib1)" "program2" "1 1000" "3.14"

# Test Square for rectangle 5x4 = 20 using lib1
run_test "Square(5,4) Rectangle (lib1)" "program2" "2 5 4" "20"

# Test switching to lib2 and Square for triangle 5x4 = 10
echo -n "Testing Library Switch and Square(5,4) Triangle (lib2)... "
result=$(echo -e "0\n2 5 4" | ./program2 2>/dev/null | head -n 1 | grep -oP '= \K[0-9]+(\.[0-9]+)?')
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
result=$(echo -e "0\n1 100" | ./program2 2>/dev/null | head -n 1 | grep -oP '= \K[0-9]+(\.[0-9]+)?')
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
