## 迴圈與陣列

~~~admonish note title="作者"
D1stance (吳翰平)
~~~

在上一節中，我們學習了如何使用 `println()` 和 `readLn()` 函數來輸入和輸出資料。現在，我們將進一步探討如何使用迴圈來處理多個資料項目，以及如何使用 List 來儲存和操作資料。

### 迴圈

#### While 迴圈

假設我們要輸出 `Hello, World!` 這個訊息 10 次，我們可以使用 `while` 迴圈來實現：

```kotlin
while(true) {
    writeln("Hello, World!")
}
```

這樣的程式碼會無限迴圈地輸出 `Hello, World!`，直到我們手動停止程式，
我們可以在 idea 中按下 `Ctrl + C` 來終止程式。

那如果我們要指定輸出 10 次呢？我們可以用一個變數來看當前的次數，然後在每次輸出後將這個變數加 1，直到它達到 10 為止：

```kotlin
var count = 0
while (count < 10) {
    writeln("Hello, World!")
    count++
}
```

這樣的程式碼會輸出 `Hello, World!` 10 次。

#### For 迴圈

但其實如果已知要輸出 10 次，我們可以使用 `for` 迴圈來簡化程式碼：

```kotlin
for (i in 1..10) {
    writeln("Hello, World!")
}
```

這個 i..10 的語法表示從 1 到 10 的範圍，這樣我們就可以直接使用 `for` 迴圈來輸出 10 次 `Hello, World!`。

雖然我們還沒有教 List，但眾所周知這類陣列型態的資料結構索引都是從 0 開始的，
所以這個 .. 就有點顯得不近人情了，因此我們還有 `until` 這個語法可以使用：

```kotlin
for (i in 0 until 10) {
    writeln("Hello, World!")
}
```

這樣 i 的值就會從 0 到 9，總共輸出 10 次 `Hello, World!`。

倒序的話就是 `downTo`：

```kotlin
for (i in 10 downTo 1) {
    writeln("Hello, World!")
}
```

這裡的 `downTo` 會讓 i 從 10 開始遞減到 1。

如果今天要輸出範圍內的所有偶數呢？我們可以使用 `step` 來指定步長：

```kotlin
for (i in 0..10 step 2) {
    writeln("偶數: $i")
}
```

這樣的程式碼會輸出 0、2、4、6、8、10 這些偶數。

當然， `downTo` 跟 `until` 也可以搭配 `step` 使用：

```kotlin
for (i in 10 downTo 0 step 2) {
    writeln("偶數: $i")
}
for (i in 0 until 11 step 2) {
    writeln("偶數: $i")
}
```

#### Repeat

Repeat 是 Kotlin 中的一個特殊迴圈，它會重複執行指定次數的程式碼塊：

```kotlin
repeat(10) {
    writeln("Hello, World!")
}
```

比起 `for` 迴圈，`repeat` 更加簡潔，特別是當我們只需要重複執行某段程式碼而不需要使用迴圈變數時，
`repeat` 是一個很好的選擇。

#### Do-While 迴圈

有時候我們需要在迴圈內至少執行一次程式碼，即使條件不成立。這時候可以使用 `do-while` 迴圈：

```kotlin
var count = 0
do {
    writeln("Hello, World!")
    count++
} while (count < 10)
```

這樣的程式碼會先執行一次 `writeln("Hello, World!")`，然後再檢查條件是否成立。

### 陣列

Kotlin 中的陣列類有兩種：`Array` 和 `List`。

#### Array

`Array` 是一種固定大小的資料結構，可以儲存多個相同類型的元素。可以使用 `arrayOf()` 函數來創建一個陣列：

```kotlin
val numbers = arrayOf(1, 2, 3, 4, 5)
```

這樣我們就創建了一個包含 5 個整數的陣列。

我們可以使用索引來訪問陣列中的元素：

```kotlin
writeln(numbers[0]) // 輸出 1
writeln(numbers[1]) // 輸出 2
```

也可以像其他語言的陣列一樣，透過索引來修改陣列中的元素：

```kotlin
numbers[0] = 10
writeln(numbers[0]) // 輸出 10
```

~~~admonish caution title="注意"
我們的 `numbers` 宣告為 `val`，你一定會想說這樣不是不能修改嗎？其實 `val` 只是表示我們不能重新指派 `numbers` 這個變數，
像是 `numbers = arrayOf(6, 7, 8)` 這樣的操作會報錯，但我們可以修改陣列中的元素。
這是因為 `Array` 是一個可變的資料結構，雖然我們不能重新指派，但可以修改其內容。

如果我們要一個完全不可變的陣列，可以使用 `List`。
~~~

當我們需要預先定義陣列的大小時，可以使用 `Array` 類別：

```kotlin
val array = Array(5) { 0 } // 創建一個大小為 5 的陣列，初始值為 0
writeln(array[0]) // 輸出 0
```

這裡比較特別的是 `{ }` 中的部分，它是一個 lambda 表達式，下一節我們會詳細介紹 lambda 的用法。
這裡可以填入任意的初始值，比起 C 語言的陣列初始化方式，這樣的寫法更為靈活。

或者指定陣列的類型：

```kotlin
val array = Array<Int>(5) { 0 } // 創建一個大小為 5 的整數陣列，初始值為 0
writeln(array[0]) // 輸出 0
```

#### List

`List` 是一種不可變的資料結構，與 `Array` 不同的是，`List` 不只大小固定，而且一旦創建後就無法修改其內容。

可以使用 `listOf()` 函數來創建一個 List：

```kotlin
val numbers = listOf(1, 2, 3, 4, 5)
```

所以是一個比較少用的資料結構，但它在某些情況下仍然很有用，特別是當我們需要一個不可變的資料集合時。

#### MutableList

如果我們需要一個可以修改的 List，可以使用 `mutableListOf()` 函數來創建一個可變的 List：

```kotlin
val numbers = mutableListOf(1, 2, 3, 4, 5)
```

這樣我們就可以對 List 進行添加、刪除和修改操作：

```kotlin
numbers.add(6) // 添加元素 6
writeln(numbers) // 輸出 [1, 2, 3, 4, 5, 6]
numbers.removeAt(0) // 刪除索引為 0 的元素
writeln(numbers) // 輸出 [2, 3, 4, 5, 6]
numbers[0] = 10 // 修改索引為 0 的元素
writeln(numbers) // 輸出 [10, 3, 4, 5, 6]
```

也可以宣告一個空的 `MutableList`：

```kotlin
val emptyList = mutableListOf<Int>() // 創建一個空的可變整數 List
```

再根據後續的需要添加元素，
所以`MutableList` 是一個非常靈活的資料結構，可以用來儲存和操作可變的資料集合，
比較相似於　C++ `Vector`, Python `List` 等資料結構。 

我們如果需要遍歷 List 中的元素，可以使用 `for` 迴圈：

```kotlin
for (i in numbers.indices) {
    writeln(numbers[i])
}
```

或者使用 `forEach` 函數：

```kotlin
numbers.forEach { writeln(it) }
```

就可以很方便地遍歷 List 中的所有元素。

### 小結
在這一節中，我們學習了如何使用迴圈來處理多個資料項目，包括 `while`、`for`、`repeat` 和 `do-while` 迴圈。
我們還學習了如何使用 `Array` 和 `List` 來儲存和操作資料。
這些基礎知識將為我們後續的程式設計打下堅實的基礎。
在下一節中，我們將學習如何使用函式和 lambda 表達式來進行更複雜的資料處理和操作。