#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

static void do_cat(FILE *f);

static int convt;
static int convn;

int
main(int argc, char *argv[])
{
    int opt;

    while ((opt = getopt(argc, argv, "tn")) != -1) {
        switch (opt) {
        case 't':
            convt = 1;
            break;
        case 'n':
            convn = 1;
            break;
        case '?':
            fprintf(stderr, "Usage: %s [-t -n]\n", argv[0]);
            exit(1);
        }
    }

    if (optind == argc) {
        do_cat(stdin);
    }
    else {
        int i;
        for (i = optind; i < argc; i++) {
            FILE *f;

            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            do_cat(f);
            fclose(f);
        }
    }
    exit(0);
}

static void
do_cat(FILE *f)
{
    int c;

    while ((c = fgetc(f)) != EOF) {
        switch (c) {
        case '\t':
            if (convt == 1) {
                if (fputs("\\t", stdout) == EOF) exit(1);
            } else {
                if (putchar(c) < 0) exit(1);
            }
            break;
        case '\n':
            if (convn == 1) {
                if (fputs("$\n", stdout) == EOF) exit(1);
            } else {
                if (putchar(c) < 0) exit(1);
            }
            break;
        default:
            if (putchar(c) < 0) exit(1);
            break;
        }
    }
}
