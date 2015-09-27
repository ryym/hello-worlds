#include <stdio.h>
#include <stdlib.h>

static void do_tail(FILE *f, long nlines);

int
main(int argc, char *argv[])
{
    if (argc == 1) {
        do_tail(stdin, 5);
    }
    else {
        FILE *f;
        int i;
        for (i = 1; i < argc; i++) {
            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            do_tail(f, 5);
            fclose(f);
        }
    }
    exit(0);
}

static void
do_tail(FILE *f, long nlines)
{
    int c;
    int nl = 0;
    int tail_start = 0;

    while ((c = getc(f)) != EOF) {
        if (c == '\n') {
           nl++; 
        }
    }

    tail_start = nl - nlines;
    nl = 0;
    fseek(f, 0, SEEK_SET);
    while ((c = getc(f)) != EOF) {
        if (c == '\n') {
            nl++;
            if (nl == tail_start) break;
        }
    }

    while ((c = getc(f)) != EOF) {
        if (putchar(c) < 0) exit(1);
    }

}
