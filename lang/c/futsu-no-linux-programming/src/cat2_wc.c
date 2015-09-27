#include <stdio.h>
#include <stdlib.h>

static void wc(FILE *f);

int
main(int argc, char *argv[])
{
    int i;

    if (argc == 1) {
        wc(stdin);
    }
    else {
        for (i = 1; i < argc; i++) {
            FILE *f;

            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            wc(f);
            fclose(f);
        }
    }
    exit(0);
}

static void
wc(FILE *f)
{
    int c;
    unsigned long n_lines = 0;
    int prev = '\n';

    while((c = fgetc(f)) != EOF) {
        if (c == '\n') {
            n_lines++;
        }
        prev = c;
    }
    if (prev != '\n') {
        n_lines++;
    }
    printf("%lu\n", n_lines);
}
