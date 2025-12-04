#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

// Function pointer types
typedef float (*PiFunc)(int);
typedef float (*SquareFunc)(float, float);

int main() {
    void *lib_handle = NULL;
    PiFunc Pi = NULL;
    SquareFunc Square = NULL;
    int current_lib = 1;  // Start with lib1
    
    // Load initial library (lib1)
    lib_handle = dlopen("./lib1.so", RTLD_LAZY);
    if (!lib_handle) {
        fprintf(stderr, "Error loading lib1.so: %s\n", dlerror());
        return 1;
    }
    
    // Get function pointers
    Pi = (PiFunc)dlsym(lib_handle, "Pi");
    Square = (SquareFunc)dlsym(lib_handle, "Square");
    
    if (!Pi || !Square) {
        fprintf(stderr, "Error loading functions: %s\n", dlerror());
        dlclose(lib_handle);
        return 1;
    }
    
    int command;
    
    while (scanf("%d", &command) == 1) {
        if (command == 0) {
            // Switch library
            dlclose(lib_handle);
            
            if (current_lib == 1) {
                lib_handle = dlopen("./lib2.so", RTLD_LAZY);
                current_lib = 2;
            } else {
                lib_handle = dlopen("./lib1.so", RTLD_LAZY);
                current_lib = 1;
            }
            
            if (!lib_handle) {
                fprintf(stderr, "Error loading library: %s\n", dlerror());
                return 1;
            }
            
            // Reload function pointers
            Pi = (PiFunc)dlsym(lib_handle, "Pi");
            Square = (SquareFunc)dlsym(lib_handle, "Square");
            
            if (!Pi || !Square) {
                fprintf(stderr, "Error loading functions: %s\n", dlerror());
                dlclose(lib_handle);
                return 1;
            }
            
        } else if (command == 1) {
            int K;
            if (scanf("%d", &K) == 1) {
                float result = Pi(K);
                printf("%f\n", result);
            }
        } else if (command == 2) {
            float A, B;
            if (scanf("%f %f", &A, &B) == 2) {
                float result = Square(A, B);
                printf("%f\n", result);
            }
        }
    }
    
    if (lib_handle) {
        dlclose(lib_handle);
    }
    
    return 0;
}
