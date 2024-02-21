#include <stdio.h>


const unsigned int MAX_UNSIGNED_INT = 0xffffffff;


int main(void) {
    unsigned int min = MAX_UNSIGNED_INT;

    unsigned int a;
    scanf("%u", &a);

    while (a) {
        if (a < min) {
            min = a;
        }

        scanf("%u", &a);
    }

    printf("%u", min);

    return 0;
}
