#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(stderr, "%s: no arguments\n", argv[0]);
        exit(0);
    }
    if (unlink(argv[1]) < 0) {
        perror(argv[1]);
        exit(1);
    }
    exit(0);
}
