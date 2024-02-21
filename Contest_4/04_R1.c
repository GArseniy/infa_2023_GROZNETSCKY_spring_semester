#include <stdio.h>


unsigned int f(unsigned int a) {
    if (a) {
        --a;
        a = f(a);
        a *= 3;
        return a;
    }

    return 1;
}


int main(void) {
    unsigned int a;
    scanf("%u", &a);
    printf("%u\n", f(a));


    return 0;
}
