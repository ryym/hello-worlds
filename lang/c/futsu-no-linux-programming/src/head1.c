/*
 *  簡易`head`コマンド
 * ・標準入力からのみ処理対象を受け取る。
 * ・表示したい行数は最初のコマンドライン引数で受け取る。
 */

#include <stdio.h>
#include <stdlib.h>

static void do_head(FILE *f, long nlines);

int
main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s n\n", argv[0]);
        exit(1);
    }

    do_head(stdin, atoi(argv[1]));
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
