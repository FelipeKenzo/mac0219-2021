// miniEP1
// Felipe Kenzo Kusakawa Mashuda
// gcc sieve.c -o sieve

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv) {
    int N;
    scanf("%d", &N);
    N = 1 << N;
    int primes = 0;
    int specialPrimes = 0;
    _Bool* sieve = malloc(N * sizeof (_Bool));
    for (int i = 2; i <= N; i++) {
        sieve[i] = 1;
    }
    for (int i = 2; i <= N; i++) {;
        if (sieve[i]) {
            primes++;
            if (i % 4 != 3) specialPrimes++;
            for (int j = i*2; j <= N; j += i) {
                sieve[j] = 0;
            }
        }
    }
    printf("%d %d", primes, specialPrimes);
}