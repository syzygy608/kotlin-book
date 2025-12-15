# 函數與 Lambda


## 為什麼需要「函數」？

### 問題情境：重複的程式碼容易出錯

```kotlin
println(3 * 3.14159 * 2 * 2) // 圓面積
println(3 * 3.14159 * 3 * 3) // 圓面積
println(3 * 3.14159 * 5 * 5) // 圓面積
```

* 重複：若要改 PI 的精度要全部修改。
* 可讀性差：不容易看出 "計算圓面積" 的意圖。

### 函數的三個核心價值

1. **抽象化**：把一段邏輯用名字包起來（例如 `areaOfCircle(radius)`），呼叫者只要知道 "做什麼"，不需看內部怎麼做。
2. **重用**：寫一次、用多次。
3. **模組化**：把大型問題拆成小步驟，方便單元測試與多人協作。

## 函數基本語法

```kotlin
fun add(a: Int, b: Int): Int {
    return a + b
}

// 更簡潔的寫法
fun addShort(a: Int, b: Int) = a + b
```

* `fun`：關鍵字
* `add`：函數名稱，跟變數一樣，應該有意義。
* 參數列：每個參數都帶型別（`a: Int`）
* 回傳型別：`:` 後面（若型別可推斷可省略）

如果內容只有一行，可以省略大括號，寫成 `fun add(a: Int, b: Int) = a + b`。

### 常用特性

* **Default arguments（預設參數）**

```kotlin
fun greet(name: String = "World") {
    println("Hello, $name")
}
```

事先定義好預設值，呼叫時可以省略。

```
greet() // Hello, World
greet("Alice") // Hello, Alice
```

* **Named arguments（命名呼叫）**

```kotlin
fun connect(host: String, port: Int) { /*...*/ }
connect(port = 8080, host = "localhost")
```

如果我們有很多參數，這樣可以提高可讀性，也可以避免順序錯誤，直接指定參數名稱。

* **局部函數（local / nested functions）**

```kotlin
fun outer(x: Int) {
    fun inner(y: Int) = x + y
    println(inner(3))
}
```

局部函數可以讓我們在函數內部定義其他函數，這樣可以封裝邏輯，避免污染全域命名空間。

保持函數單一職責（Single Responsibility），
每個函數應該只做一件事。這樣便於命名、測試與重用。

我們用來快速輸出入的 Buffer 也可以包成函數方便使用

```kotlin
import java.io.*

val br = BufferedReader(InputStreamReader(System.`in`))
val bw = BufferedWriter(OutputStreamWriter(System.`out`))
fun readLine() = br.readLine()!!
fun write(x: Any) = bw.write(x.toString())
fun writeln(x: Any) = bw.write("$x\n")
fun flush() = bw.flush()
```

~~~admonish note title="例題"
給定一個正整數 $n$，代表接下來會有一個 $n$ 次多項式，$a_0 x^0 + a_1 x^1 + ... + a_{n-1} x^{n-1}$，
接下來第二行有 $n$ 個整數 $a_0, a_1, ..., a_{n-1}$，代表這個多項式的係數。

接下來有一個整數 $x$，代表要計算多項式在 $x$ 處的值，
請使用函數來計算這個多項式在 $x$ 處的值。
~~~

~~~admonish info title="範例" collapsible=true
```kotlin
import java.io.*
import java.math.*
import java.util.*
import kotlin.math.*

val br = BufferedReader(InputStreamReader(System.`in`))
val bw = BufferedWriter(OutputStreamWriter(System.`out`))
fun readLine() = br.readLine()!!
fun write(x: Any) = bw.write(x.toString())
fun writeln(x: Any) = bw.write("$x\n")
fun flush() = bw.flush()

fun polynomialValue(coefficients: List<Int>, x: Int): Int {
    var result = 0
    coefficients.forEachIndexed { index, coeff ->
        result += coeff * x.toDouble().pow(index.toDouble()).toInt()
    }
    return result
}
fun main() {
    val n = readLine().toInt()
    val coefficients = readLine().split(" ").map { it.toInt() }
    val x = readLine().toInt()
    writeln(polynomialValue(coefficients, x))
    flush()
}
```

`forEachIndexed` 可以同時取得索引與值，這樣就可以在計算多項式時使用，
因為多項式的每一項都是 $a_i x^i$，所以我們需要知道係數與指數。

接著透過 .pow() 函數計算 $x^i$ 的值，然後乘上係數，最後累加起來就是多項式在 $x$ 處的值。

~~~

## 純函數（Pure Function）

### 定義

純函數在相同輸入下，**永遠**產生相同輸出，並且不會產生任何外部副作用（不改變外部狀態、不讀寫全域變數、不要做 I/O、不要亂改傳入的資料結構）。

也許會多花費額外的記憶體空間，但是可以換來更好的可預測性與可重用性，
對於初學者來說，純函數是理解函數式程式設計的基礎。

純函數像「計算器」：輸入相同的數字，結果永遠一樣，不改變其他東西。
非純函數像「收銀機」：不只計算價格，還會改變庫存、印發票（副作用）。


### 純函數的兩大特性

純函數有兩個重要特性：**確定性（Deterministic）** 與 **無副作用（No Side Effect）**，理解這兩點有助於掌握純函數的本質。

#### 1. 確定性（Deterministic）

純函數在相同輸入下，**每次都會產生相同的輸出**，這使得程式行為可預測、容易測試。

```kotlin
fun square(x: Int): Int {
    return x * x
}

println(square(3))  // 輸出 9
println(square(3))  // 輸出 9（每次輸入 3，結果一樣）
```

在上例中，無論呼叫多少次，`square(3)` 的輸出永遠是 9，符合確定性的要求。

#### 2. 無副作用（No Side Effect）

純函數在執行過程中，**不會改變外部狀態，也不會影響函數外的資料**。

```kotlin
var count = 0

fun increaseCount() {
    count++   // 改變外部變數，造成副作用
}

fun pureIncrease(x: Int): Int {
    return x + 1   // 不改變外部變數，沒有副作用
}

println(count)    // 0
increaseCount()
println(count)    // 1（外部狀態被改變）

println(pureIncrease(5))  // 6
println(count)            // 1（純函數不改變外部狀態）
```

`increaseCount()` 會修改外部變數 `count`，產生副作用；
`pureIncrease()` 僅回傳計算結果，沒有改變外部資料，屬於無副作用。

---

#### 非純函數範例

```kotlin
var pi = 3.14
fun areaWithMutablePi(radius: Double): Double {
    return pi * radius * radius
}
// 借用全域變數 pi，這樣就不是純函數了。
```

```kotlin
fun printArea(radius: Double) {
    println("area = ${areaOfCircle(radius)}") // 有輸出（副作用）
}
```

建議把輸出與邏輯分開，純粹函數只做計算，不做 I/O。

### 為什麼要傾向純函數？

* **可預測**：更容易推理與測試。
* **可多次重複使用**：可以在不同上下文中使用而不擔心副作用。
* **與數學定義一致**：純函數符合數學函數的定義，便於理解。

尤其是下個章節，因為純函數更加貼近數學定義，
所以以純函數的角度來理解遞迴是更加清晰的。

## 匿名函數（Lambda）與函數型別

### 什麼是 Lambda？

Lambda 就是「沒有名字的函數」，可以像變數一樣被傳遞或儲存。常用於一次性的行為（callback、集合處理）。

### 基本語法

```kotlin

val sum: (Int, Int) -> Int = { a, b -> a + b }
println(sum(3, 4)) // 7

// 省略型別（編譯器推斷）
val mul = { a: Int, b: Int -> a * b }
```

### 常見簡寫

* 單參數 lambda 可以使用 `it`：

```kotlin
val isEven: (Int) -> Boolean = { it % 2 == 0 }
```

* 當 lambda 是函數的最後一個參數時，支援 trailing lambda 語法，省略小括號

```kotlin
val list = listOf(1,2,3,4)
val evens = list.filter { it % 2 == 0 }
```

我們的 `filter` 函數接受一個 lambda 作為參數，這樣可以讓我們更方便地過濾集合，
所以當 lambda 是最後一個參數時，可以把它移到括號外面，這樣更清晰。

像是我們常用的 `map` 就是這樣的用法：

```kotlin
var list = readLine().split(" ").map { it.toInt() }
```

後面的 `{ it.toInt() }` 就是 lambda，這樣可以把每個字串轉成整數。


* 函數型別描述：`(A, B) -> C` 表示接收 A、B 回傳 C 的函數。


### 匿名函數 vs 構造 `fun`

* Lambda 語法更簡短
* 可以搭配 filter、map 等操作更加方便


## 高階函數（Higher-order Functions）

高階函數是指以函數為引數或回傳函數的函數。

### 範例：把 lambda 傳給函數

```kotlin
fun operate(a: Int, b: Int, op: (Int, Int) -> Int): Int {
    return op(a, b)
}

fun main() {
    println(operate(3, 4, { x, y -> x + y }))
    println(operate(3, 4) { x, y -> x * y }) // Trailing lambda
}
```

### 集合 API（map / filter / reduce）就是高階函數的常見使用場景

```kotlin
val nums = listOf(1,2,3,4,5)
val squares = nums.map { it * it }
val evens = nums.filter { it % 2 == 0 }
val sum = nums.reduce { acc, v -> acc + v }
```

`map` 常用來轉換每個元素，`filter` 用來過濾元素，`reduce` 用來累加或合併，
這些函數我們在之後會詳細介紹。


## 實作習題

### 練習 1

把下列程式重構成函數 `areaOfCircle`，並使用它計算半徑 1, 2, 3 的面積。

**解答要點**：定義 `fun areaOfCircle(radius: Double): Double = Math.PI * radius * radius`。

### 練習 2

以下哪些是純函數？為什麼？

```kotlin
var x = 0
fun a(n: Int) = n * 2
fun b(n: Int) = { x += n; x }
fun c(n: Int) { println(n) }
```

**解答要點**：`a` 是純函數，`b` 非純（修改外部變數），`c` 非純（輸出為副作用）。

