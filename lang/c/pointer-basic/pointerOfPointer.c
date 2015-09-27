#include <stdio.h>

/** ポインタのポインタ */

int
main(int argc, char *argv[])
{
    char *pc = "abcdef";
    char **ppc = &pc;

    // %sは、渡されたポインタからNULL文字にあたるまで
    // アドレスを1バイトずつ増やしては中身を参照して文字を表示する。
    printf("pc  = %s\n", pc);  // == "abcdef"

    printf("pc  = %p\n", pc);  // == pcが格納する文字列定数の先頭アドレス
    printf("&pc = %p\n", &pc); // == pc変数自体のアドレス

    // 文字列定数の先頭アドレスの中身を参照している。pc[0]
    printf("*pc = %c\n", *pc);  // == 'a'

    // ppcはpcのアドレスを持っている(ppc == &pc)。
    // そのppcを*付きで参照するのは、pcを参照するのと同じなので、
    // pcの中身である「文字列定数の先頭アドレス」が得られ、"abcdef"が
    // 表示される。
    printf("*ppc = %s\n", *ppc);   // == "abcdef"
    printf("*ppc = %p\n", *ppc);   // == pcが格納する文字列定数の先頭アドレス
    printf("**ppc = %c\n", **ppc); // == 'a'
}
