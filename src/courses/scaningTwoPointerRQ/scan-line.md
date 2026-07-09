# 掃描線

在介紹何謂掃描線之前，我們先來看一個例子。

~~~admonish note title="問題描述"
有一個預約系統，每個預約都有一個開始時間與結束時間，
因為教室有限，所以希望能知道同一時間內最多有多少個預約同時進行，方便分配教室。

舉例而言，假設有三個預約，分別為：
- 預約 A：開始時間 1，結束時間 3
- 預約 B：開始時間 2，結束時間 4
- 預約 C：開始時間 3，結束時間 5

這樣代表在時間 3 時，預約 A 與預約 B 都還在進行中，而預約 C 剛好在時間 3 開始，所以在時間 3 時，總共有三個預約同時進行。

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
3
```
~~~

我們先有一個粗略的直覺，對於每一個時間點，透過二分搜尋法找出有多少個預約正在進行中，然後取最大值。

這樣的時間複雜度為 $O(x \log n)$，$x$ 為時間點的數量，$n$ 為預約的數量。
因為本題的 $x = 10^9$，所以這樣的做法顯然不夠快。

我們可以進一步觀察，所謂的 **「同一時間內最多有多少個預約同時進行」**，這個數值，只會在某些時間點改變，這些時間點就是所有預約的開始時間與結束時間。

與其用時間來搜尋預約，不如只記錄所有預約的開始時間與結束時間，然後依照時間排序，接著從最小的時間開始掃描，遇到開始時間就將同時進行的預約數量加一，遇到結束時間就將同時進行的預約數量減一。
這樣就可以在 $O(n \log n)$ 的時間內解決這個問題。

這也是所謂的掃描線技巧，因為我們就像一條線從最小的時間掃描到最大的時間，並且在每個時間點更新同時進行的預約數量，
經過排序之後，我們只需要掃描所有的時間點，並且在每個時間點更新同時進行的預約數量，最後取最大值即可。


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

    // 依照時間排序，若時間相同，先處理開始時間，再處理結束時間，這樣才能正確計算同時進行的預約數量 
    events.sortWith(compareBy({ it.first }, { -it.second }))

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
        .sortedWith(compareBy({ it.first }, { -it.second }))
        .runningFold(0) { acc, (_, type) -> acc + type }
        .maxOrNull() ?: 0
    println(maxConcurrent)
}
```
~~~

