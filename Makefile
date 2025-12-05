CC = gcc
CFLAGS = -Wall -Wextra -fPIC -I./src
LDFLAGS = -shared
LDLIBS = -lm -ldl

SRC_DIR = src
BUILD_DIR = build

LIB1_SRC = $(SRC_DIR)/lib1.c
LIB2_SRC = $(SRC_DIR)/lib2.c
PROG1_SRC = $(SRC_DIR)/program1.c
PROG2_SRC = $(SRC_DIR)/program2.c

LIB_H = $(SRC_DIR)/lib.h

all: $(BUILD_DIR) \
     $(BUILD_DIR)/lib1.so \
     $(BUILD_DIR)/lib2.so \
     $(BUILD_DIR)/lib1.a \
     $(BUILD_DIR)/program1 \
     $(BUILD_DIR)/program2

# Create build folder if not exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# ===== Shared libraries =====
$(BUILD_DIR)/lib1.so: $(LIB1_SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

$(BUILD_DIR)/lib2.so: $(LIB2_SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

# ===== Static library (lib1.a) =====
$(BUILD_DIR)/lib1.o: $(LIB1_SRC) $(LIB_H)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lib1.a: $(BUILD_DIR)/lib1.o
	ar rcs $@ $<

# ===== Programs =====
# Static linking to lib1.a
$(BUILD_DIR)/program1: $(PROG1_SRC) $(BUILD_DIR)/lib1.a $(LIB_H)
	$(CC) $(CFLAGS) -o $@ $< $(BUILD_DIR)/lib1.a $(LDLIBS)

# For dynamic loading (dlopen)
$(BUILD_DIR)/program2: $(PROG2_SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

# ===== Test =====
test: all
	@echo "Running tests..."
	@./run_tests.sh

# ===== Clean =====
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean test