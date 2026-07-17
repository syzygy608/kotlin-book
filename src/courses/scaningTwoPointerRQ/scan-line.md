# 掃描線

在介紹何謂掃描線之前，我們先來看一個例子。

~~~admonish note title="問題描述"
有一個預約系統，每個預約都有一個開始時間與結束時間，
因為教室有限，所以希望能知道同一時間內最多有多少個預約同時進行，方便分配教室。

舉例而言，假設有三個預約，分別為：
- 預約 A：開始時間 1，結束時間 3
- 預約 B：開始時間 2，結束時間 4
- 預約 C：開始時間 3，結束時間 5

這樣代表在時間 3 時，預約 A 與預約 B 都還在進行中，而預約 C 在時間 3 才開始，所以在時間 3 時，總共有兩個預約同時進行。

## Specification
- $1 \leq n \leq 10^5$
- $1 \leq start_i < end_i \leq 10^9$
## Input
```
3
1 3
2 4
3 5
```
## Output
```
2
```
~~~

我們先有一個粗略的直覺，對於每一個時間點，透過二分搜尋法找出有多少個預約正在進行中，然後取最大值。

這樣的時間複雜度為 $O(x \log n)$，$x$ 為時間點的數量，$n$ 為預約的數量。
因為本題的 $x = 10^9$，所以這樣的做法顯然不夠快。

我們可以進一步觀察，所謂的 **「同一時間內最多有多少個預約同時進行」**，這個數值，只會在某些時間點改變，這些時間點就是所有預約的開始時間與結束時間。

與其用時間來搜尋預約，不如只記錄所有預約的開始時間與結束時間，然後依照時間排序，接著從最小的時間開始掃描，遇到開始時間就將同時進行的預約數量加一，遇到結束時間就將同時進行的預約數量減一。
這樣就可以在 $O(n \log n)$ 的時間內解決這個問題。

這類問題我們只需要關心狀態改變的瞬間，這個將區間拆分成兩個事件，透過事先將事件排序之後，在端點上處理計算的作法，我們就稱為掃描線（一維）。

~~~admonish info title="範例程式碼" collapsible=true
```kotlin
fun main() {
    val n = readLine()!!.toInt()
    val events = mutableListOf<Pair<Int, Int>>()

    repeat(n) {
        val (start, end) = readLine()!!.split(" ").map { it.toInt() }
        events.add(Pair(start, 1)) // 開始時間，增加同時進行的預約數量
        events.add(Pair(end, -1)) // 結束時間，減少同時進行的預約數量
    }

    // 依照時間排序，若時間相同，先處理結束事件
    events.sortWith(compareBy({ it.first }, { it.second }))

    var current = 0
    var maxConcurrent = 0

    for ((time, type) in events) {
        current += type
        maxConcurrent = maxOf(maxConcurrent, current)
    }

    println(maxConcurrent)
}
```
~~~

~~~admonish info title="範例程式碼 2 (More FP Way)" collapsible=true
```kotlin
fun main() {
    val n = readLine()!!.toInt()
    val events = mutableListOf<Pair<Int, Int>>()

    repeat(n) {
        val (start, end) = readLine()!!.split(" ").map { it.toInt() }
        events.add(Pair(start, end))
    }
    val maxConcurrent = events.flatMap { listOf(Pair(it.first, 1), Pair(it.second, -1)) }
        .sortedWith(compareBy({ it.first }, { it.second }))
        .scan(0) { acc, (_, type) -> acc + type }
        .maxOrNull() ?: 0
    println(maxConcurrent)
}
```
~~~

排序的時候，需要注意一些邊界情況，例如 $(1, 3)$ 和 $(3, 4)$ 這兩個區間，在題目的敘述中是否算是有重疊？
上面的例題中是視為沒有重合的，假設我們要算的是所有區間覆蓋的長度，理論上 $(1, 3)$ 和 $(3, 4)$ 應該是完美接軌的，
這時候就應該先處理完進入事件才處理離開事件。

### 掃描線的核心步驟

1. 把所有事件依座標(通常是 x 或時間)排序
2. 用一個「掃描指標」沿座標軸移動
3. 每碰到一個事件,就更新目前維護的資料結構
4. 在需要的時間點查詢/記錄目前狀態

### 練習題單

- [Codeforces 22D](https://codeforces.com/problemset/problem/22/D)
- [AtCoder ABC 183 D](https://atcoder.jp/contests/abc183/tasks/abc183_d)
- [Codeforces 1915 F](https://codeforces.com/problemset/problem/1915/F)
