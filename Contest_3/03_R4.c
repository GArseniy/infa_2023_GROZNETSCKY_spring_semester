#include <stdio.h>


int main(void) {
    unsigned int mask[] = {0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333, 0x55555555};

    unsigned int a;
    scanf("%u", &a);

    unsigned int *b = mask + 16 / sizeof(unsigned int);
    int c = 1;

    while (b + 8 != mask) {
        a = (a & *b) << c | (a & ~*b) >> c;
        c <<= 1;
        b -= 4 / sizeof(unsigned int);
    }

    printf("%u\n", a);


    return 0;
}
