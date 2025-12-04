# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -fPIC
LDFLAGS = -shared
LDLIBS = -lm -ldl

# Targets
all: lib1.so lib2.so lib1.a program1 program2

# Build shared libraries
lib1.so: lib1.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o lib1.so lib1.c $(LDLIBS)

lib2.so: lib2.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o lib2.so lib2.c $(LDLIBS)

# Build static library lib1.a
lib1.o: lib1.c lib.h
	$(CC) $(CFLAGS) -c lib1.c -o lib1.o

lib1.a: lib1.o
	ar rcs lib1.a lib1.o

# Build program1 with static linking to lib1.a
program1: program1.c lib1.a lib.h
	$(CC) $(CFLAGS) -o program1 program1.c lib1.a $(LDLIBS)

# Build program2 with dynamic loading support
program2: program2.c
	$(CC) $(CFLAGS) -o program2 program2.c $(LDLIBS)

# Test target
test: all
	@echo "Running tests..."
	@./run_tests.sh

# Clean build artifacts
clean:
	rm -f lib1.so lib2.so lib1.a lib1.o program1 program2

.PHONY: all test clean
