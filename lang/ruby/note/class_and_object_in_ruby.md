# RubyにおけるObject, Module, Classについて簡易メモ
* [参考](http://melborne.github.io/2013/02/07/understand-ruby-object/)

## Object, Class
* Objectクラスはあらゆるクラスのスーパークラスである。この「あらゆるクラス」の中にはClassクラスも含まれる。
* Rubyではクラスもまたオブジェクトであり、あらゆるクラスはClassクラスのオブジェクト（インスタンス）である。
この「あらゆるクラス」の中にはObjectクラスも含まれる。

つまり、Objectクラスは自身のサブクラスであるClassクラスのインスタンスである。逆から言えば、Classクラスは自身のスーパークラスである
Objectクラスをインスタンス化する。この循環構造を知ると、以下のようなRubyの挙動を理解できるようになる。  

例えば、全クラスのスーパークラスであるObjectクラスのインスタンスメソッドはあらゆるクラスのインスタンスから呼び出す事ができるが、
のみならず、それらはあらゆるクラスのクラスメソッドとしても呼び出される（`[1].to_s`, `Array.to_s`）。

なぜなら、ObjectクラスのサブクラスであるところのClassクラスのインスタンスメソッドは、あらゆるクラスの
クラスメソッドとして呼び出す事ができるから（なぜならあらゆるクラスはClassクラスのインスタンスだから）。

## Module, Class
* あらゆるモジュールはModuleクラスのインスタンスである。
* ModuleクラスはClassクラスのスーパークラスである。

上記の特性から、ModuleとClassにおいてもObjectとClassにあったのと同じ循環構造が生じる。
つまり、Moduleクラスに作られるインスタンスメソッドはClassクラスのインスタンスメソッドとなり、
そのClassクラスのインスタンスメソッドは（Moduleクラスを含む）あらゆるクラスのクラスメソッドとなる。
なおModuleクラスのクラスメソッドはあらゆるモジュールのクラスメソッドとなる。

## Object, Module, Class, and others..
```
Object > Module > Class
            .new -> Object, Module, String, Array...
Object > Module
            .new -> module
Object > String
            .new -> ""
Object > Array
            .new -> []
```

## Rubyのクラスはただの「型」ではない
静的型言語においてクラスは普通オブジェクトの雛形だが、Rubyの世界ではその雛形さえオブジェクトであり、
その意味ではクラスとクラスから生成されるインスタンスの間に違いはない。Rubyはデータ型を動的に決定する
にとどまらず、（実体を伴わない）型という概念自体を廃して、全てを実体あるオブジェクトとして扱う。
