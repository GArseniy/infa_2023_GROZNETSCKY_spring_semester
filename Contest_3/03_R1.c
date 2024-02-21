#include <stdio.h>


int main(void) {
    int n;
    scanf("%d", &n);

    int fib = 0;
    int fib_next = 1;

    for (int i = n; i > 0; --i) {
        int tmp = fib;
        fib = fib_next;
        fib_next = tmp;

        fib_next += fib;
    }

    printf("%d\n", fib);

    return 0;
}
