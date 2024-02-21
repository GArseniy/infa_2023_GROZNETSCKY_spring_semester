#include <stdio.h>

#define BUF_SIZE 4095

unsigned int hash(unsigned char *str) {
    unsigned int arr[256];

    for (unsigned int j = 0; j != 256; ++j) {
        unsigned int tmp = j;

        for (int i = 0; i != 8; ++i) {
            tmp = (tmp >> 1) ^ (0xedb88320 * (tmp & 1));
        }

        arr[j] = tmp;
    }


    unsigned int a = 0xFFFFFFFF;

    while (*str) {
        a = (a >> 8) ^ arr[(*str++ ^ a) & 0xFF];
    }

    return ~a;
}


int main(void) {
    static unsigned char str[BUF_SIZE + 1];

    fgets(str, BUF_SIZE, stdin);
    str[BUF_SIZE] = 0;

    printf("%x\n", hash(str));

    return 0;
}
