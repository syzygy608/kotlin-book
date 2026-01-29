# 內建常用函數

我們已經學過了陣列以及迴圈，在這一章會介紹一些 Kotlin 標準函式庫中常用的擴充函式 (Extension Functions)，
這些函式可以讓我們更方便地操作陣列、串列等資料結構，提升程式的可讀性與開發效率。

## 陣列與串列的常用函式

- `fill()`: 將陣列或串列的所有元素設置為指定值。
- `sum()`: 計算陣列或串列中所有數值元素的總和。
- `average()`: 計算陣列或串列中所有數值元素的平均值。
- `maxOrNull()`: 返回陣列或串列中的最大值，若為空則返回 null。
- `minOrNull()`: 返回陣列或串列中的最小值，若為空則返回 null。
- `count(lambda)`: 計算符合條件的元素數量。
- `filter(lambda)`: 過濾出符合條件的元素，返回一個新的串列。
- `map(lambda)`: 對每個元素應用指定的函數，返回一個新的串列。
- `distinct()`: 移除重複的元素，返回一個只包含唯一元素的串列，但不會排序。
- `slice(startIndex, endIndex)`: 返回指定範圍內的元素子串列。
- `reverse()`: 將陣列或串列的元素順序反轉。
- `reverseArray()`: 將陣列的元素順序反轉，並返回一個新的陣列。
- `take(n)`: 取得前 n 個元素，返回一個新的串列。
- `drop(n)`: 丟棄前 n 個元素，返回剩餘的串列。
- `joinToString(separator)`: 將陣列或串列的元素連接成一個字串，元素之間以指定的分隔符號分隔。

順便複習之前介紹過的
- `sort()`: 將陣列或串列的元素進行排序，會修改原本的結構。
- `sortDescending()`: 將陣列或串列的元素進行降序排序，會修改原本的結構。
- `sorted()`: 將陣列或串列的元素進行排序，返回一個新的排序後的串列。
- `sortedDescending()`: 將陣列或串列的元素進行降序排序，返回一個新的排序後的串列。

我們可以把這些函數組合起來使用，以達到更複雜的資料處理需求。例如：

```kotlin
val numbers = arrayOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
val evenSquares = numbers
    .filter { it % 2 == 0 }        // 過濾出偶數
    .map { it * it }               // 計算平方
    .toList()                      // 轉換為串列
bw.write("偶數的平方: $evenSquares\n") // 輸出: 偶數的平方: [4, 16, 36, 64, 100]
```

雖然這些操作都可以透過傳統的迴圈來實現，但使用這些內建函數能讓程式碼更簡潔易讀。

### ForEach 迴圈

Kotlin 提供了 `forEach` 函式來遍歷陣列或串列中的每個元素，語法如下：

```kotlin
array.forEach { element ->
    // 對 element 執行操作
}
```

比起 `for` + `in` 迴圈，`forEach` 更加簡潔，特別是在需要對每個元素執行相同操作時。

### Zip & fold

- `zip(otherList)`: 將兩個串列的元素配對，返回一個包含配對元素的串列。

**範例**

```kotlin
val list1 = listOf(1, 2, 3)
val list2 = listOf("a", "b", "c")
val zipped = list1.zip(list2)
bw.write("Zipped: $zipped\n") // 輸出: Zipped: [(1, a), (2, b), (3, c)]
```

這樣打包資料可以方便我們同時處理兩個串列的對應元素。

- `zipWithNext()`: 將串列中相鄰的元素配對，返回一個包含配對元素的串列。

**範例**

```kotlin
val numbers = listOf(1, 2, 3, 4)
val differences = numbers.zipWithNext { a, b -> b - a }
bw.write("Differences: $differences\n") // 輸出: Differences: [1, 1, 1]
```

```kotlin
val numbers = listOf(5, 10, 15, 20)
val isIncreasing = numbers.zipWithNext { a, b -> a < b }.all { it }
bw.write("Is Increasing: $isIncreasing\n") // 輸出: Is Increasing: true
```

- `fold(initial, operation)`: 從初始值開始，依序將串列中的元素與累積值進行操作，返回最終的累積結果。

**範例**

```kotlin
val numbers = listOf(1, 2, 3, 4)
val sum = numbers.fold(0) { acc, num -> acc + num }
bw.write("Sum: $sum\n") // 輸出: Sum: 10
```

fold 函式非常適合用來進行累積計算，例如求和、乘積等。
雖然求和已經有內建的 `sum()` 函式，但 fold 提供了更靈活的方式來定義累積邏輯。

我們也可以用來處理字串，用上一個字元來決定下一個字元的加入：

```kotlin
val chars = listOf('K', 'o', 't', 'l', 'i', 'n')
val result = chars.fold("") { acc, c -> 
    if (acc.isEmpty()) c.toString() else acc + "-" + c
}
bw.write("Folded String: $result\n") // 輸出: Folded String: K-o-t-l-i-n
```

fold 函式讓我們能夠以更函數式的方式來處理資料，提升程式碼的可讀性與維護性。

## 對單變數作用的常用函數

- `coreceIn(min, max)`: 將數值限制在指定範圍內。
- `toInt(radix)`: 將字串轉換為指定進位的整數。
- `toString(radix)`: 將物件轉換為字串表示，可指定進位。

- `a = b.also { b = a }`: 交換兩個變數的值。

`also` 指的是順便進行，所以將 b 的值賦給 a 時，b 還沒被改變，因此可以成功交換兩個變數的值。