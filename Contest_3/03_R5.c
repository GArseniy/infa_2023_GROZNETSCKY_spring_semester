#include <stdio.h>


int main(void) {
    unsigned int n;
    scanf("%u", &n);

    int scholar_multi = 0;

    if (!(n % 2)) {
        for (int i = (int) (n >> 1); i > 0; --i) {
            int a, b;
            scanf("%d %d", &a, &b);
            scholar_multi += a * b;
        }
    }

    printf("%d\n", scholar_multi);

    return 0;
}
