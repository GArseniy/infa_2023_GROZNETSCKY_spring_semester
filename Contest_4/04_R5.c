#include <stdio.h>


#define BUF_SIZE 4096


int f(unsigned char *key, unsigned char *str1, unsigned char *str2) { // ebx, ecx, edx
    for (int i = 0; i != 255; ++i) {
        key[i] = i;
    }

    while (*str1) {
        if (!*str2) return 0;

        key[*str1++] = *str2++;
    }

    return !*str2;
}


void p(const unsigned char *key, unsigned char *str) { // edx eax
    while (*str) {
        *str = key[*str];
        str++;
    }
}


void s(unsigned char *str, int size) {
    fgets((char *) str, size, stdin);
}


int main(void) {
    unsigned char str1[256];
    s(str1, 256);

    unsigned char str2[256];
    s(str2, 256);

    unsigned char key[256];

    if (f(key, str1, str2)) {
        int n;
        scanf("%d", &n);

        unsigned char str[BUF_SIZE];
        s(str, BUF_SIZE);

        for (int i = 0; i < n; ++i) {
            s(str, BUF_SIZE);
            p(key, str);
            printf("%s", str);
        }
    }

    return 0;
}
