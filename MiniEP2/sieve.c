// miniEP1
// Felipe Kenzo Kusakawa Mashuda
// gcc sieve.c -o sieve -O3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printArray(_Bool* array, int N) {
    printf("[");
    for (int i = 0; i <= N; i++) {
        printf("%d ", array[i]);
    }
    printf("]\n");
}

int main(int argc, char* argv) {
    int N;
    scanf("%d", &N);
    N = 1 << N;
    int primes = 1;
    int specialPrimes = 1;
    _Bool* sieve = malloc(N * sizeof (_Bool));
    memset(sieve, 1, N+1);
    for (unsigned long int i = 2; i <= N; i+=2) {;
        if (sieve[i]) {
            primes++;
            if (i % 4 != 3) specialPrimes++;
            for (unsigned long int j = i*i; j <= N; j+=2*i) {
                sieve[j] = 0;
            }
        }
    }
    printf("%d %d\n", primes, specialPrimes);
}
