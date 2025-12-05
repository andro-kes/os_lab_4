#include <stdio.h>
#include "lib.h"

int main() {
    int command;
    
    while (scanf("%d", &command) == 1) {
        if (command == 1) {
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
    
    return 0;
}
