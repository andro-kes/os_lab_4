#include <math.h>
#include "lib.h"

// Implementation A: Leibniz series for Pi
// Pi/4 = 1 - 1/3 + 1/5 - 1/7 + ...
float Pi(int K) {
    float sum = 0.0;
    for (int i = 0; i < K; i++) {
        float term = 1.0 / (2 * i + 1);
        if (i % 2 == 0) {
            sum += term;
        } else {
            sum -= term;
        }
    }
    return 4 * sum;
}

// Implementation A: Rectangle area
float Square(float A, float B) {
    return A * B;
}
