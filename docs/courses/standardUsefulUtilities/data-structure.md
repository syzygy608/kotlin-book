# 常用容器介紹

在 Kotlin 中，除了基本的 `Array` 外，我們在競技程式中更常根據需求選擇不同的容器。Kotlin 提供了與 Java 集合框架 (Java Collections Framework) 無縫接軌的接口，這讓我們可以使用多種具備高效能搜尋、排序特性的資料結構。

## 常用容器類別

* `ArrayList<T>`: 動態陣列，等同於 C++ 的 `std::vector`。支援隨機存取。
* `Pair<A, B>`: 儲存兩個相關聯的值，等同於 C++ 的 `std::pair`。
* `Triple<A, B, C>`: 儲存三個相關聯的值。
* `ArrayDeque<T>`: 雙端隊列，等同於 C++ 的 `std::deque`。在處理 BFS 或滑動窗口問題時，比 `Stack` 或 `LinkedList` 更快。
* `PriorityQueue<T>`: 優先權隊列，等同於 C++ 的 `std::priority_queue`。預設為**最小堆積 (Min-heap)**。
* `HashMap<K, V>`: 雜湊表，等同於 C++ 的 `std::unordered_map`。提供平均  的查找與插入速度。
* `HashSet<T>`: 雜湊集合，等同於 C++ 的 `std::unordered_set`。用於快速去重或判斷元素是否存在。
* `TreeMap<K, V>`: 樹狀對映，等同於 C++ 的 `std::map`。Key 會自動按順序排列，支援  的查找。
* `TreeSet<T>`: 樹狀集合，等同於 C++ 的 `std::set`。元素自動排序且不重複。

## 容器初始化與常用操作

### Pair / Triple (對/三元組)

Pair 和 Triple 用於儲存兩個或三個相關聯的值，常用於返回多個值或在資料結構中存放座標等資訊。

```kotlin
val point: Pair<Int, Int> = Pair(10, 20)
val triple: Triple<String, Int, Double> = Triple("Alice", 25, 68.5)
```

可以儲存任意型態的資料，但是 Pair 和 Triple 本身是不可變的 (immutable)，無法修改其中的值，同時無法進行排序。

#### 自訂資料類型

在需要儲存多個相關聯的值時，除了使用 Pair 或 Triple 外，我們也可以自訂資料類型 (data class) 來達到更好的可讀性與擴展性。

```kotlin
data class Student(val name: String, val age: Int, val gpa: Double)
val student = Student("Bob", 22, 3.8)
```

class 稱為類別，而 data class 則是專門用來儲存資料的類別，因為 Pair 和 Triple 預設沒有比較功能，所以在需要排序的情況下，建議使用 data class 並實作 `Comparable`。

```kotlin
data class Student(val name: String, val age: Int, val gpa: Double) : Comparable<Student> {
    override fun compareTo(other: Student): Int {
        if (this.gpa != other.gpa) {
            return other.gpa.compareTo(this.gpa) // 依 GPA 降冪排序
        }
        return this.name.compareTo(other.name) // GPA 相同則依姓名升冪排序
    }
}
```

### ArrayDeque (雙端隊列)

一般的 ArrayList 只能在尾端進行插入與刪除操作，而 ArrayDeque 支援在頭尾兩端進行高效的插入與刪除操作，時間複雜度皆為 $\mathcal{O}(1)$。

- `addFirst(element)`: 在隊列前端插入元素。
- `addLast(element)`: 在隊列後端插入元素。
- `removeFirst()`: 移除並返回隊列前端的元素。
- `removeLast()`: 移除並返回隊列後端的元素。
- `peekFirst()`: 取得但不移除隊列前端的元素。
- `peekLast()`: 取得但不移除隊列後端的元素。

但相較於 ArrayList，ArrayDeque 不支援隨機存取 (random access)，因此無法使用索引直接存取中間的元素。


### PriorityQueue (優先權隊列)

當我們在安排任務的問題中，我們常常需要一個能夠快速取得「目前最重要任務」的資料結構，
因為假設每次取出任務都需要遍歷整個清單，時間複雜度會是 $\mathcal{O}(n^2)$，這在任務數量龐大時會非常低效。

所以前人設計了 `Heap` (堆積) 這種資料結構，能夠在 $\mathcal{O}(\log n)$ 的時間內完成插入與取出最大/最小元素的操作，大幅提升效率。
而 Kotlin 提供的 `PriorityQueue` 就是基於堆積實作的優先權隊列。

注意：`PriorityQueue` 預設是**最小的先出**，這點與 C++ 相反。

```kotlin
// 最小堆積 (預設)
val minHeap = PriorityQueue<Int>()

// 最大堆積 (需自定義比較器)
val maxHeap = PriorityQueue<Int>(compareByDescending { it })

maxHeap.add(10)
maxHeap.add(30)
val top = maxHeap.poll() // 取得並移除 30

```

還有幾個常用的方法：
* `peek()`: 取得但不移除隊首元素。
* `isEmpty()`: 判斷隊列是否為空。
* `isNotEmpty()`: 判斷隊列是否不為空。
* `size`: 取得隊列中元素的數量。
* `clear()`: 清空隊列中的所有元素。
* `addAll(collection)`: 將一個集合的所有元素加入隊列中。

### TreeMap / TreeSet (有序集合)

Tree 系列的資料結構底層是使用二元搜尋樹 (Binary Search Tree, BST) 實作的，能夠在 $\mathcal{O}(\log n)$ 的時間內完成插入、刪除與搜尋操作，並且能夠保持元素的有序性。

當你需要找「大於等於 $x$ 的最小元素」時，這類容器非常有用。

```kotlin
val set = TreeSet<Int>()
set.addAll(listOf(10, 20, 30, 40))

val higher = set.higher(25) // 取得大於 25 的最小元素：30
val lower = set.lower(25)   // 取得小於 25 的最大元素：20

```

#### TreeSet 常用方法
* `ceiling(element)`: 取得大於等於指定元素的最小元素
* `floor(element)`: 取得小於等於指定元素的最大元素
* `first()`: 取得集合中的最小元素
* `last()`: 取得集合中的最大元素
* `add(element)`: 插入元素
* `remove(element)`: 刪除元素
* `contains(element)`: 判斷元素是否存在於集合中
* `size`: 取得集合中元素的數量

#### TreeMap 常用方法
* `ceilingKey(key)`: 取得大於等於指定鍵的最小鍵
* `floorKey(key)`: 取得小於等於指定鍵的最大鍵
* `firstKey()`: 取得映射中的最小鍵
* `lastKey()`: 取得映射中的最大鍵
* `put(key, value)`: 插入鍵值對
* `remove(key)`: 刪除指定鍵的鍵值對
* `get(key)`: 根據鍵取得對應的值
* `containsKey(key)`: 判斷鍵是否存在於映射中
* `size`: 取得映射中鍵值對的數量

### HashMap / HashSet (雜湊集合)

Hash 系列的資料結構底層是使用雜湊表 (Hash Table) 實作的，能夠在平均 $\mathcal{O}(1)$ 的時間內完成插入、刪除與搜尋操作，非常適合用於需要快速查找的場景。

```kotlin
val map = HashMap<String, Int>()
map["Alice"] = 25
map["Bob"] = 30
val age = map["Alice"] // 取得 Alice 的年齡：25
```

#### HashMap 常用方法
* `put(key, value)`: 插入鍵值對
* `remove(key)`: 刪除指定鍵的鍵值對
* `get(key)`: 根據鍵取得對應的值
* `containsKey(key)`: 判斷鍵是否存在於映射中
* `size`: 取得映射中鍵值對的數量
#### HashSet 常用方法
* `add(element)`: 插入元素
* `remove(element)`: 刪除元素
* `contains(element)`: 判斷元素是否存在於集合中
* `size`: 取得集合中元素的數量

## 容器轉換擴充函式

Kotlin 讓容器之間的轉換變得極其簡單：

* `toTypedArray()`: 將串列轉換為一般陣列。
* `toIntArray()`: 將 `List<Int>` 轉換為效能較高的原生 `int[]`。
* `toMutableList()`: 將唯讀串列或陣列轉換為可變的 `ArrayList`。
* `toHashSet()` / `toTreeSet()`: 快速去重並轉換成對應集合。
* `associateBy { it.id }`: 將串列轉換為 `Map`，以物件的某個屬性作為 Key。

**範例**

```kotlin
val nums = intArrayOf(3, 1, 2, 2, 1)
val uniqueSorted = nums.toTreeSet() 
bw.write("Unique: $uniqueSorted\n") // 輸出: Unique: [1, 2, 3]

```

透過選擇正確的容器，我們可以在不改變演算法邏輯的情況下，大幅度地降低程式的時間複雜度。
