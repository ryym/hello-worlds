# C言語(のポインタ)に関する雑記メモ

## メモリ構成

C言語では、プログラム及びその中で定義される関数や変数を一定のルールに
従ってメモリ上に配置する。スタックは上方から下方へ、ヒープは下方から
上方へ向かって領域を増やしていく。  
なお、OSからプログラムに割り当てられるのは仮想メモリであり、実際の
(ハードウェアとしての?)メモリのアドレスとは異なる。

### スタック

* ローカル変数
* 関数からの復帰情報

### ヒープ

* alloc系関数で動的に確保される領域

### データセグメント、BSS

* グローバル定数(初期化済み)
* スタティック変数
* グローバル定数(未初期化)(BBS)

### テキストセグメント

* 文字列定数(リテラル)
* プログラム本体

### バイトオーダー
CPUによっては、データを下位バイトから並べる方式をとる。
このようなバイトオーダーをリトルエンディアンという。

```
value: 0x12345678 (4 byte)
little endian: 78 56 34 12
big endian: 12 34 56 78
```

## リンク

複数のソースファイルをまとめてコンパイルし、1つの実行可能ファイルを生成する事を
分割コンパイルという。その際、各ソースファイル(`*.c`)はコンパイルされてオブジェクトファイル(`*.o`)
となる。それらオブジェクトファイルとライブラリがリンカによってリンクされ、実行可能ファイルとなる。
リンクされるライブラリには以下の2種類がある。

### スタティックライブラリ(静的リンク)
リンクすると、ライブラリ内の関数がそのままリンクされテキストセグメントに配置される。

### 共有ライブラリ(ダイナミックリンク)
WindowsではDDL(Dynamic link library)という。リンクすると、ライブラリ内の関数の呼び出し方法だけがリンクされ、
テキストセグメントに配置される。これはライブラリのコードを複数のプログラムで共有するため。
ライブラリはマシン上で動いている様々なプログラムによって使用され得るため、
単純に各プログラムのテキストセグメントに配置するとメモリの無駄遣いとなってしまう。

## ポインタ

### 基本的な記法

```c
// 通常の変数
int i = 999;

// int型のポインタ変数
int *p;

// iのアドレスをpに代入する。
p = &i;

printf("p = %p\n", p);  /* pはアドレスを持つ */
printf("p = %d\n", *p); /* *pでアトレスの中身を参照 */

// *pに値を代入すると、pが指していたアドレスに値を持っているiも当然変わる。
*p = 10;
printf("i = %d\n", i); // => 10

```

### ポインタ変数の型
ポインタ変数はアドレスを格納しているだけなので、int型のポインタであろうとchar型のポインタであろうと
常に4バイトの大きさしか持たない(とはいえ厳密には処理系依存のよう)。にもかかわらずポインタ変数に型が
必要なのは、アドレスだけではそこに格納されている値をどのように解釈すればよいのかわからないため。
つまりポインタ変数の型はそのポインタが指すアドレスの中身のためにある。
また、ポインタをインクリメントするとその型のバイト数分だけアドレスに加算される。

```c
char *pc = 0;
int *pi  = 0;

pc++; // => 0x1

pi++; // => 0x4
```

### void型のポインタ
void型のポインタには、任意の型のポインタを代入する事ができる。
逆に、void型のポインタは任意の型のポインタに代入する事もできる(C++ではできない)。
これが可能なおかげで、`malloc`などのメモリ割り当て関数の戻り値を型変換せずに
そのまま任意の型のポインタ変数に代入する事ができる。

## 配列とポインタ

Cにおいては、配列を添字なしで参照すると先頭要素のアドレスが取得できる。

### ポインタと配列の違い
* 配列は宣言時に指定された大きさのメモリが確保されるが、ポインタは常に4バイト
* ポインタは指し示すアドレスを自由に変更できるが、配列はメモリの位置を変更できない

配列=ポインタでは当然なく、**配列はポインタによって処理されている**だけ。

```c
// 添字による配列へのアクセスは右のようにも書ける。
address[index] == *(address + index);
```

### 配列のポインタ

配列を関数に渡す場合、実際に渡るのは配列(の先頭アドレス)へのポインタなので、仮引数の記述では添字を省略できる。
しかし2次元配列を関数の引数に渡す場合には、2つ目の配列の添字が必須となる。

```c
void printKuku(int kuku[][9]) // 9の部分は省略不可
```

この理由も、配列がポインタによって処理されている事を考えるとよくわかる。例えばint型の配列であれば、
ある要素の次の要素にアクセスする場合には、アドレスをint型のサイズ分(4byte)進めればよい。逆に言えば、
配列の各要素に正しくアクセスするためには、その配列が持つ型の大きさがわかっている必要がある。
2次元配列とはつまるところ配列の配列なので、ある要素の次の要素にアクセスするためには、要素である配列の大きさが
わからなければならない。  
2次元配列は以下のように配列のポインタとしても記述できる。

```c
int kuku[9][9];

// 配列のポインタ。kuku++ で要素9つ分(sizeof(int) * 9)インクリメントされる。
int (*kuku2)[9];

kuku2 = kuku;
```

### 配列としての文字列

Cには`String`のような文字列型は存在せず、文字列は常に文字型(`char`)の配列として扱われる。
また文字列は`"\0"`で終端する決まりがあるので、ある文字列を`char`型の配列に格納したい場合、
その文字数 + 1の要素数を持つ配列が必要となる。

```c
char *str = "abcde";

// どちらも意味は同じ
printf( "%p == %p", str, &(str[0]) );
```

`main`関数には実行時の引数文字列が配列として渡されるが、あれは配列の配列ではなく
ポインタの配列である。2次元配列の場合は各要素が一定の長さを持っている必要があるが、
ポインタの配列であれば可変長な2次元配列を実現できる。
