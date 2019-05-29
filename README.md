10 min fizzbuzz
======


Fizzbuzzが動くRuby to JavaScriptコンパイラを10分で作ります。


Files
---

* `fizzbuzz.rb`
  * 今回コンパイルする対象のコード
* `compiler.rb`
  * コンパイラのひな型
* `goal.rb`
  * 今回作るコンパイラの完成形



必要なもの
---


* Ruby 2.7+
  * Pattern Matching

あると便利なもの
---

* RubyVM::AST::Nodeをさくっと表示するもの
  * https://pocke.hatenablog.com/entry/2019/05/28/012227

前提知識
---

* `RubyVM::AbstractSyntaxTree.parse(ruby_code)`で、RubyのコードからAST(抽象構文木)を手に入れることができます。
  * 抽象構文木はソースコードが構造化されたものです。そのためプログラムからソースコードを扱うのが容易になります。
  * Ruby 2.6からの機能です
* `case in`でパターンマッチを行います。
  * ```ruby
    case x
    in [1, 2, 3]
      # x == [1, 2, 3]
    in [1, y, 3]
      # x == [1, なにか, 3]
      p y # => x[1]
    in [1, 2, [3, y]]
      # x == [1, 2, [3, なにか]]
      p y # => x[2][1]
    end
    ```
  * `case when`と似ていますが、任意の値にマッチさせて、マッチさせた値を変数に格納することができます。
  * Ruby 2.7からの機能です。


実装手順
---

### 1. 20をコンパイルしてみる

単なる数値リテラルをコンパイルできるようにします。
これには`LIT`と`SCOPE`の2つのtypeの対応が必要です。

TODO

