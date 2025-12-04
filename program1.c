#include <stdio.h>
#include <stdlib.h>

// Function prototypes from the library
extern float Pi(int K);
extern float Square(float A, float B);

int main() {
    int command;
    
    while (scanf("%d", &command) == 1) {
        if (command == 1) {
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
    
    return 0;
}
