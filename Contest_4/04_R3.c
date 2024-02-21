#include <stdio.h>


int m(int a, int c, int d) {
    while (1) {
        if (a < c) {
            a ^= c;
            c ^= a;
            a ^= c;
        } else if (a <= d) {
            break;
        } else {
            a ^= d;
            d ^= a;
            a ^= d;
        }
    }

    return a;
}


int main(void) {
    int a, b, c;
    scanf("%d %d %d", &a, &b, &c);
    printf("%d\n", m(a, b, c));


    return 0;
}
