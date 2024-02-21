#include <stdio.h>


unsigned int f(unsigned int x, int i) {
    return x ? (x & 1u) + f(x >> 1, i - 1) : 0;
}


int main(void) {
    unsigned int a;
    scanf("%u", &a);

    printf("%d\n", 32 - f(a, 32));

    return 0;
}
