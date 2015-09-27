#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>
#include <getopt.h>

static void do_grep(regex_t *pat, FILE *src, int flg_invert);

int
main(int argc, char *argv[])
{
    regex_t pat;
    int err;
    int opt;
    int flg_icase  = 0;
    int flg_invert = 0;
    int ctflags;
    int argind;

    while ((opt = getopt(argc, argv, "iv")) != -1) {
        switch (opt) {
        case 'i':
            flg_icase = 1;
            break;
        case 'v':
            flg_invert = 1;
            break;
        case '?':
            fprintf(stderr, "Usage: %s [-i -v]\n", argv[0]);
            exit(1);
        }
    }

    if (argc == optind) {
        fputs("no pattern\n", stderr);
        exit(1);
    }

    ctflags = REG_EXTENDED | REG_NOSUB | REG_NEWLINE;
    if (flg_icase) {
        ctflags |= REG_ICASE;
    }

    err = regcomp(&pat, argv[optind], ctflags);
    if (err != 0) {
        char buf[1024];
        regerror(err, &pat, buf, sizeof buf);
        puts(buf);
        exit(1);
    }

    argind = optind + 1;
    if ((argc - argind) == 0) {
        do_grep(&pat, stdin, flg_invert);
    }
    else {
        int i;
        for (i = argind; i < argc; i++) {
            FILE *f;
            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            do_grep(&pat, f, flg_invert);
            fclose(f);
        }
    }
    regfree(&pat);
    exit(0);
}

static void
do_grep(regex_t *pat, FILE *src, int flg_invert)
{
    char buf[4096];

    if (flg_invert) {
        while (fgets(buf, sizeof buf, src)) {
            if (regexec(pat, buf, 0, NULL, 0) != 0) {
                fputs(buf, stdout);
            }
        }
    }
    else {
        while (fgets(buf, sizeof buf, src)) {
            if (regexec(pat, buf, 0, NULL, 0) == 0) {
                fputs(buf, stdout);
            }
        }
    }
}
