
int sum(int a, int b);
int use_sum();

/* extern をつけて宣言すると、いずれかのモジュールで実体を作成しないと
 * コンパイルエラーになる。
 */
 extern int public_var;
