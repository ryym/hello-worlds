#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>
#include <getopt.h>

static void do_grep(regex_t *pat, FILE *src);

static int opt_invert = 0;
static int opt_ignorecase = 0;

int main(int argc, char *argv[]) {
    regex_t pat;
    int err;
    int opt;
    int re_mode;

    while ((opt = getopt(argc, argv, "iv")) != -1) {
        switch (opt) {
        case 'i':
            opt_ignorecase = 1;
            break;
        case 'v':
            opt_invert = 1;
            break;
        case '?':
            fprintf(stderr, "Usage: %s [-iv] [PATTERN] \n", argv[0]);
            exit(1);
        }
    }

    /* 
     * 配列の添字 0 の位置(アドレス)を変更している。
     *  [a,b,c] += 1 => [b,c,null]
     *  これにより argc, argv の両変数からオプションの情報を
     *  取り除ける。
     */
    argv += optind;
    argc -= optind;

    if (argc < 1) {
        fputs("no pattern\n", stderr);
        exit(1);
    }

    re_mode = REG_EXTENDED | REG_NOSUB | REG_NEWLINE;
    if (opt_ignorecase) {
        re_mode |= REG_ICASE;
    }

    err = regcomp(&pat, argv[0], re_mode);
    if (err != 0) {
        char buf[1024];
        regerror(err, &pat, buf, sizeof buf);
        puts(buf);
        exit(1);
    }

    if (argc == 1) {
        do_grep(&pat, stdin);
    }
    else {
        int i;
        for (i = 1; i < argc; i++) {
            FILE *f;
            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            do_grep(&pat, f);
            fclose(f);
        }
    }
    regfree(&pat);
    exit(0);
}

static void do_grep(regex_t *pat, FILE *src) {
    char buf[4096];

    if (opt_invert) {
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
