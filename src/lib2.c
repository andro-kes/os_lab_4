#include "lib.h"

// Implementation B: Wallis formula for Pi
// Pi/2 = (2/1) * (2/3) * (4/3) * (4/5) * (6/5) * (6/7) * ...
float Pi(int K) {
    float product = 1.0;
    for (int i = 1; i <= K; i++) {
        float numerator = 4.0 * i * i;
        float denominator = 4.0 * i * i - 1.0;
        product *= numerator / denominator;
    }
    return 2 * product;
}

// Implementation B: Right triangle area
float Square(float A, float B) {
    return (A * B) / 2.0;
}
