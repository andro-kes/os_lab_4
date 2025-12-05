#include "lib.h"

float Pi(int K) {
    float product = 1.0;
    for (int i = 1; i <= K; i++) {
        float numerator = 4.0 * i * i;
        float denominator = 4.0 * i * i - 1.0;
        product *= numerator / denominator;
    }
    return 2 * product;
}

float Square(float A, float B) {
    return (A * B) / 2.0;
}
