#include <stdio.h>


int main(void) {
    unsigned int a;
    scanf("%u", &a);

    unsigned int b = a;
    --b;
    a ^= b;
    a += 1;

    a >>= 1;
    a |= (a == 0) << 31;

    printf("%u\n", a);


    return 0;
}
