# OS Lab 4 - Dynamic Libraries Project

C project with dynamic libraries demonstrating static and dynamic linking.

## Project Structure

- `lib1.c` - Implementation A: Leibniz series for Pi, Rectangle area
- `lib2.c` - Implementation B: Wallis formula for Pi, Right triangle area
- `program1.c` - Static linking to lib1
- `program2.c` - Dynamic loading with runtime library switching
- `Makefile` - Build configuration
- `run_tests.sh` - Test suite

## Functions

### Pi(int K)
- **Implementation A (lib1)**: Leibniz series approximation
  - Formula: π/4 = 1 - 1/3 + 1/5 - 1/7 + ...
- **Implementation B (lib2)**: Wallis formula approximation
  - Formula: π/2 = (2/1) × (2/3) × (4/3) × (4/5) × ...

### Square(float A, float B)
- **Implementation A (lib1)**: Rectangle area
  - Formula: A × B
- **Implementation B (lib2)**: Right triangle area
  - Formula: (A × B) / 2

## Building

```bash
make
```

This creates:
- `lib1.so` - Implementation A library
- `lib2.so` - Implementation B library
- `program1` - Static linking executable
- `program2` - Dynamic loading executable

## Running

### Program 1 (Static Linking)
```bash
./program1
```

Statically linked to lib1 (Leibniz, Rectangle).

### Program 2 (Dynamic Loading)
```bash
./program2
```

Starts with lib1, can switch to lib2 at runtime.

## Input Format

- `1 K` - Calculate Pi with K iterations
- `2 A B` - Calculate area with dimensions A and B
- `0` - Switch library (program2 only)

## Examples

### Program 1
```bash
echo -e "1 1000\n2 5 4" | ./program1
```
Output:
```
3.140593
20.000000
```

### Program 2 - Library Switching
```bash
echo -e "1 1000\n2 5 4\n0\n2 5 4\n0\n1 100" | ./program2
```
Output:
```
3.140593    # Pi using Leibniz (lib1)
20.000000   # Rectangle area (lib1)
10.000000   # Triangle area (lib2)
3.133788    # Pi using Wallis (lib2)
```

## Testing

Run the test suite:
```bash
make test
```

Or directly:
```bash
./run_tests.sh
```

## Clean

Remove build artifacts:
```bash
make clean
```

## Requirements Met

✓ Two dynamic libraries (lib1.so, lib2.so)  
✓ Each implements Pi(int K) and Square(float A, float B)  
✓ Program 1: Static linking to lib1  
✓ Program 2: Dynamic loading with runtime switching via command "0"  
✓ Input format: 1 K → Pi, 2 A B → Square  
✓ Relative paths for library loading
