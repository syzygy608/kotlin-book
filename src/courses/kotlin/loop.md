## 迴圈與陣列

```admonish note title="作者"
D1stance (吳翰平)
```

在上一節中，我們學習了基本的輸入輸出操作，現在將介紹如何用迴圈處理重複性任務，以及如何使用陣列和串列來儲存多筆資料。

---

### 迴圈

迴圈是程式中用來重複執行程式碼區塊的結構。Kotlin 支援多種迴圈形式，適合不同的使用場景。

#### While 迴圈

`while` 迴圈會在每次執行前先判斷條件是否成立，條件為真才會執行區塊。

```kotlin
var count = 0
while (count < 10) {
    writeln("Hello, World!")
    count++
}
```

此範例會輸出 10 次 "Hello, World!"。
注意若條件永遠成立，會造成無限迴圈：

```kotlin
while (true) {
    writeln("無限輸出")
}
```

要避免無限迴圈，通常會在迴圈內更新條件變數。

---

#### Do-While 迴圈

`do-while` 與 `while` 不同之處在於它會先執行一次迴圈區塊，然後再判斷條件是否成立，因此至少執行一次。

```kotlin
var count = 0
do {
    writeln("至少會執行一次")
    count++
} while (count < 10)
```

---

#### For 迴圈

`for` 迴圈是最常用的迴圈形式，適合用於已知重複次數或範圍的狀況。

```kotlin
for (i in 1..10) {
    writeln("第 $i 次輸出")
}
```

`1..10` 表示從 1 到 10 的閉區間（包含 10）。
若想使用左閉右開區間（不包含結尾），可用 `until`：

```kotlin
for (i in 0 until 10) {
    writeln(i) // i 從 0 到 9
}
```

倒序可用 `downTo`：

```kotlin
for (i in 10 downTo 1) {
    writeln(i)
}
```

搭配步長 `step` 可以指定間隔：

```kotlin
for (i in 0..10 step 2) {
    writeln(i) // 輸出偶數：0,2,4,6,8,10
}
```

不只是 `..`，`until` 和 `downTo` 也可以搭配 `step`。

---

#### Repeat 迴圈

當不需要使用迴圈計數變數時，`repeat` 是更簡潔的選擇：

```kotlin
repeat(10) {
    writeln("重複執行此行10次")
}
```

---

### 陣列與串列

資料結構是用來儲存多筆資料的容器。Kotlin 提供多種陣列型結構，常見有 `Array`、`List` 和 `MutableList`。

---

#### Array（陣列）

* **固定大小、可變元素**
* 以索引存取，索引從 0 開始
* 可修改元素，但無法變更大小

建立範例：

```kotlin
val arr = arrayOf(1, 2, 3, 4, 5)
```

訪問及修改元素：

```kotlin
writeln(arr[0])   // 1
arr[0] = 10
writeln(arr[0])   // 10
```

---

##### `val` 和 `var` 的差異

```kotlin
val arr = arrayOf(1, 2, 3)
// arr = arrayOf(4, 5, 6) // 編譯錯誤，因為 val 不可重新指派
arr[0] = 100  // 可修改陣列內容
```

---

##### 指定大小與初始值

```kotlin
val zeros = Array(5) { 0 }  // 大小5，全部初始化為0
```

其中 `{ 0 }` 是一個 lambda 表達式，表示每個位置的初始值。

---

#### List（串列）

* **不可變資料結構**（大小與內容均不可變）
* 適合存放不需要修改的集合

建立不可變串列：

```kotlin
val list = listOf(1, 2, 3, 4, 5)
```

不可修改元素：

```kotlin
// list[0] = 10 // 編譯錯誤
```

---

#### ArrayList（可變串列）

* 支援動態增加、刪除、修改元素
* 功能與 C++ vector 或 Python list 類似

建立可變串列：

```kotlin
val arrayList = arrayList<Int>()
arrayList.add(1)
arrayList.add(2)
arrayList[0] = 10 // 修改第一個元素
writeln(arrayList[0]) // 輸出 10
arrayList.removeAt(1) // 刪除第二個元素
```

---

### 遍歷

遍歷陣列或串列最常用的方法：

```kotlin
for (i in arr.indices) {
    writeln(arr[i])
}

for (item in list) {
    writeln(item)
}

// 或使用高階函數
list.forEach { writeln(it) }
```

---

### 二維陣列與二維 List

處理矩陣型資料時，我們會用到二維結構。

#### 二維陣列 (Array\<Array<T>>)

指定大小：

```kotlin
val rows = 3
val cols = 4
val matrix = Array(rows) { Array(cols) { 0 } }
```

訪問與修改：

```kotlin
matrix[0][0] = 10
writeln(matrix[0][0]) // 輸出 10
```

直接初始化：

```kotlin
val matrix = arrayOf(
    arrayOf(1, 2, 3),
    arrayOf(4, 5, 6),
    arrayOf(7, 8, 9)
)
```

---

#### 二維 List (List\<List<T>>)

不可變：

```kotlin
val listMatrix = listOf(
    listOf(1, 2, 3),
    listOf(4, 5, 6),
    listOf(7, 8, 9)
)
```

---

#### 可變二維 List (ArrayList\<ArrayList<T>>)

```kotlin
val arrayListMatrix = arrayListOf(
    arrayListOf(1, 2, 3),
    arrayListOf(4, 5, 6),
    arrayListOf(7, 8, 9)
)
arrayListMatrix[0][0] = 10
writeln(arrayListMatrix[0][0]) // 輸出 10
```

---

#### 遍歷二維結構

```kotlin
for (row in matrix) {
    for (item in row) {
        write("$item ")
    }
    writeln("")
}
```

或索引遍歷：

```kotlin
for (i in matrix.indices) {
    for (j in matrix[i].indices) {
        write("${matrix[i][j]} ")
    }
    writeln("")
}
```

---

### 小結

* 迴圈可靈活控制程式重複執行次數
* `Array` 是固定大小且可變的陣列
* `List` 為不可變串列，適合存放不需修改的資料
* `ArrayList` 是可變串列，支援動態增刪改
* 二維資料結構適用於矩陣問題，使用雙層結構和雙重迴圈遍歷
* 根據需求選擇適合的資料結構

