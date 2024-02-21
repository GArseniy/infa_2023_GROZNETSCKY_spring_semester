#include <stdio.h>


int f1(int a, int b) {
    return a * b;
}

int f2(int a, int b) {
    return a + b;
}

int f3(int a, int b) {
    return a - b;
}

int f4(int a, int b) {
    return a / b;
}


int main(void) {
    int (*a[]) (int, int) = {f1, f2, 0, f3, 0, f4};

    int x, y;
    char c;
    scanf("%d %c %d", &x, &c, &y);

    c -= 42;

    printf("%d", a[(int)c](x, y));


    return 0;
}
