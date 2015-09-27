/*
 *  簡易`head`コマンド２
 * ・標準入力から処理対象を受け取る。
 * ・表示したい行数は最初のコマンドライン引数で受け取る。
 * ・２つ目以降の引数はファイル名と見なし、それらを処理対象とする。
 */

#include <stdio.h>
#include <stdlib.h>

static void do_head(FILE *f, long nlines);

int
main(int argc, char *argv[])
{
    long nlines;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s n [file file...]\n", argv[0]);
        exit(1);
    }

    nlines = atoi(argv[1]);
    if (argc == 2) {
        do_head(stdin, nlines);
    } else {
        int i;
        for (i = 2; i < argc; i++) {
            FILE *f;

            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }

            do_head(f, nlines);
            fclose(f);
        }
    }
    exit(0);
}

static void
do_head(FILE *f, long nlines)
{
    int c;

    if (nlines <= 0) return;
    while ((c = getc(f)) != EOF) {
        if (putchar(c) < 0) exit(1);
        if (c == '\n') {
            nlines--;
            if (nlines == 0) break;
        }
    }
}
