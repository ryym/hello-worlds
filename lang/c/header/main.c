#include <stdio.h>
#include "sum.h"

int main(int argc, char *argv[]) {
    int num;
    num = use_sum(10, 20);
    printf("num = %d, public_var = %d\n", num, public_var);
    return 0;
}
