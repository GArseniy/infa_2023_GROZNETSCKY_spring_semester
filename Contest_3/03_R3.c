#include <stdio.h>


int main(void) {
    static int n, k;
    scanf("%d %d", &n, &k);

    static int arr_a[21];
    static int arr_b[21];

    int *a = arr_a;
    int *b = arr_b;

    a[0] = 1;

    for (int j = 0; j != n; ++j) {
        b[0] = 1;

        for (int i = 0; i != j + 1; ++i) {
            b[i + 1] = a[i + 1] + a[i];
        }

        b[j + 1] = 1;

        int *t = a;
        a = b;
        b = t;
    }

    printf("%d\n", a[k]);

    return 0;
}
