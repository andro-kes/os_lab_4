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
    int current_lib = 1;  
    
    // Загружаем библиотеку через относительные пути
    lib_handle = dlopen("./lib1.so", RTLD_LAZY);
    if (!lib_handle) {
        fprintf(stderr, "Error loading lib1.so: %s\n", dlerror());
        return 1;
    }
    
    dlerror();
    Pi = (PiFunc)dlsym(lib_handle, "Pi");
    char *error = dlerror();
    if (error != NULL) {
        fprintf(stderr, "Error loading Pi: %s\n", error);
        dlclose(lib_handle);
        return 1;
    }
    
    dlerror();
    Square = (SquareFunc)dlsym(lib_handle, "Square");
    error = dlerror();
    if (error != NULL) {
        fprintf(stderr, "Error loading Square: %s\n", error);
        dlclose(lib_handle);
        return 1;
    }
    
    int command;
    
    while (scanf("%d", &command) == 1) {
        if (command == 0) {
            // 1. Если пользователь вводит команду «0», 
            // то программа переключает одну реализацию контрактов на другую
            dlclose(lib_handle);
            
            const char *lib_name;
            int new_lib;
            if (current_lib == 1) {
                lib_name = "./lib2.so";
                new_lib = 2;
            } else {
                lib_name = "./lib1.so";
                new_lib = 1;
            }
            
            lib_handle = dlopen(lib_name, RTLD_LAZY);
            if (!lib_handle) {
                fprintf(stderr, "Error loading library: %s\n", dlerror());
                return 1;
            }
            
            current_lib = new_lib;
            fprintf(stderr, "Switched to %s\n", lib_name);
            
            dlerror(); 
            Pi = (PiFunc)dlsym(lib_handle, "Pi");
            char *error = dlerror();
            if (error != NULL) {
                fprintf(stderr, "Error loading Pi: %s\n", error);
                dlclose(lib_handle);
                return 1;
            }
            
            dlerror();  
            Square = (SquareFunc)dlsym(lib_handle, "Square");
            error = dlerror();
            if (error != NULL) {
                fprintf(stderr, "Error loading Square: %s\n", error);
                dlclose(lib_handle);
                return 1;
            }
            
        } else if (command == 1) {
            int K;
            if (scanf("%d", &K) == 1) {
                float result = Pi(K);
                printf("Pi(K=%d) = %f\n", K, result);
            } else {
                fprintf(stderr, "Invalid input\n");
            }
        } else if (command == 2) {
            float A, B;
            if (scanf("%f %f", &A, &B) == 2) {
                float result = Square(A, B);
                printf("Square(A=%f, B=%f) = %f\n", A, B, result);
            } else {
                fprintf(stderr, "Invalid input\n");
            }
        } else {
            fprintf(stderr, "Unknown command\n");
        }
    }
    
    if (lib_handle) {
        dlclose(lib_handle);
    }
    
    return 0;
}
