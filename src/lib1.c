#include "lib.h"

// Рассчитываем Пи через Лейбница
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

// Вычисляем площадь прямоугольника
float Square(float A, float B) {
    return A * B;
}
