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

`compile_expr`と`compile_stmt`を実装していきます。Rubyでは全ての構文要素が値を持ちますが、JavaScriptでは`if`などの文は値を持ちません。
そのため、値を持つ構文要素を`compile_expr`、値を持たないものを`compile_stmt`でコンパイルするようにします。

`ruby compiler.rb fizzbuzz.rb`を実行すると、fizzbuzz.rbに書かれているコードをコンパイルした結果のJavaScriptが得られます。
また、`ruby compiler.rb fizzbuzz.rb | node`とすると、コンパイルした結果をNodeで実行できます。


### 1. 20をコンパイルする

単なる数値リテラルをコンパイルできるようにします。20が20にコンパイルされれば良いですね。
これには`LIT`と`SCOPE`の2つのtypeの対応が必要です。

### 2. puts 20 をコンパイルする


次に`puts 20`をコンパイルしてみましょう。これは`console.log(20)`にコンパイルされれば良いですね。
メソッドの引数は`ARRAY`に包まれているので、それを剥がす必要があります。

### 3. ローカル変数への代入をコンパイルする

`max = 20`をコンパイルします。

### 4. ローカル変数の参照をコンパイルする


`max = 20; puts max`をコンパイルします。
このへんでつまったら`BLOCK`ノードのコンパイルが必要かもしれません。

### 5. 比較演算子 `<=` をコンパイルする

比較演算子が動くようにしてみましょう。

`puts 1 <= 20` とかが動くと良いですね。

### 6. whileをコンパイルする

whileをコンパイルします。
`while i <= max; puts i; end`とかが動くと良いでしょう。無限に`i`(つまり1)を出力し続けます。

### 7. + をコンパイルする

`+`演算子をコンパイルして、`i = i + 1`を動くようにしましょう。
`<=`のコンパイルをすこし工夫すれば良いですね。
ここまで実装すれば、1から20を列挙するコードが動きます。あと少しですね。


### 8. 文字列リテラルをコンパイルする

文字列リテラルをコンパイルします。`puts "fizzbuzz"`が動くと良いでしょう。
文字列の出力には`String#dump`メソッドが便利です。厳密にはRubyとJavaScriptで文字列リテラルは違うものですが、Fizzbuzzを書くぐらいなら気になりません。

### 9. ifをコンパイルする

最後に`if`をコンパイルします。
ここまで実装すると、1から20までのFizzbuzzを出力できます！


ちなみに、`RubyVM::AbstractSyntaxTree`では`if-elsif-end`は次のものと同じ構造のASTになります。(parser gemでも同様です。)

```ruby
if cond1
  body1
elsif cond2
  body2
else
  body3
end

# ↑は↓とおなじ
if cond1
  body1
else
  if cond2
    body2
  else
    body3
  end
end
```

つまり、今回は`elsif`のことは考えずに`if-else-end`をコンパイルできるようにすれば良いだけです。

今回やらないこと
---


* ローカル変数の定義と代入の使い分け
  * 全ての変数は`var`も`let`も`const`もなしで定義します。
  * 真面目にやろうとしたら10分じゃ終わらないので…
* 関数呼び出しの際の関数探索
  * 今回は`console.log`しか呼び出さないので
* そのたたくさん
