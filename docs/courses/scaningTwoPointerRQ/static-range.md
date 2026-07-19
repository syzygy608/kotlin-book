# 靜態區間操作：前綴和、高維前綴和與差分

當我們需要針對一個靜態（不會被修改，或修改次數遠少於查詢次數）的陣列，
反覆回答「某個區間的總和是多少？」這種問題時，
如果每次查詢都老老實實地把區間內的元素加總一遍，
時間複雜度會隨著查詢次數線性成長，很容易超出時限。

這篇教學會依序介紹三個緊密相關的技巧：**前綴和**、**高維前綴和**、以及它們的逆運算 **差分** 。

## 前綴和 (Prefix Sum)


!!! note "問題描述"
    給定一個長度為 $n$ 的整數陣列 $a$，接下來有 $q$ 筆查詢，
    每筆查詢給定 `l, r`，請回答 `a[l] + a[l+1] + ... + a[r]` 是多少？
    
    #### 技術規格
    
    - $1 \leq n, q \leq 2 \times 10^5$
    - $-10^9 \leq a[i] \leq 10^9$
    - $0 \leq l \leq r < n$

如果對於每一筆查詢都直接用一個迴圈把 `a[l..r]` 加起來，
單次查詢是 $\mathcal{O}(n)$，`q` 筆查詢下來就是 $\mathcal{O}(nq)$，
在 `n, q` 都到 $2 \times 10^5$ 的情況下，`nq` 會逼近 $4 \times 10^{10}$，
這遠遠超過我們能接受的範圍，一定會 TLE。

觀察一下，其實我們反覆在問的都是「從某個位置到某個位置的總和」，
如果我們先花一次的功夫，把「從頭加到第 `i` 個位置」的總和都預先算好，
之後要回答任何一個區間的總和，就只需要用兩個「從頭加到某位置」的結果相減即可，
不需要每次都重新掃過整個區間。

我們把「從頭加到第 `i` 個位置（不含）」的總和定義成 `prefix[i]`，
也就是 `prefix[0] = 0`，`prefix[i] = a[0] + a[1] + ... + a[i-1]`。

有了這個陣列之後，`a[l] + a[l+1] + ... + a[r]` 就等於 `prefix[r+1] - prefix[l]`，
因為 `prefix[r+1]` 已經包含了 `a[0..r]` 全部的總和，
把 `a[0..l-1]` 這一段用 `prefix[l]` 減掉，剩下的正好就是 `a[l..r]`。

在 Kotlin 中，「把陣列變成累積結果的陣列」正是 `scan`（早期版本叫 `runningFold`）這個高階函數在做的事情：
它會拿著一個初始值，依序把每個元素「摺」進去，並且把每一步的中間結果都記錄下來，
剛好對應到我們想要的前綴和陣列。

```kotlin
// prefix[0] = 0, prefix[i] = a[0] + a[1] + ... + a[i-1]
fun prefixSum(a: List<Long>): List<Long> =
    a.scan(0L) { acc, x -> acc + x }

// 查詢 a[l..r] 的總和，l, r 皆為 0-indexed 且區間包含兩端
fun rangeSum(prefix: List<Long>, l: Int, r: Int): Long =
    prefix[r + 1] - prefix[l]
```

有了 `prefix` 之後，建置的成本是 $\mathcal{O}(n)$，
之後每一筆查詢都只是一次減法，是 $\mathcal{O}(1)$，
`q` 筆查詢的總成本是 $\mathcal{O}(q)$，
整體時間複雜度從 $\mathcal{O}(nq)$ 降到 $\mathcal{O}(n + q)$，這就是前綴和的威力。

```kotlin
fun main() {
    val a = listOf(3L, 2L, 4L, 5L, 1L, 1L, 5L, 3L)
    val prefix = prefixSum(a)
    println(rangeSum(prefix, 1, 3)) // 2 + 4 + 5 = 11
    println(rangeSum(prefix, 4, 5)) // 1 + 1 = 2
    println(rangeSum(prefix, 0, 7)) // 全部加總 = 24
}
```

> **練習題**
>
> - [CSES 1646 - Static Range Sum Queries](https://cses.fi/problemset/task/1646)：本節例題的原型。
> - [CSES 1650 - Range Xor Queries](https://cses.fi/problemset/task/1650)：把「加法」換成「XOR」，
>   因為 XOR 的反運算就是自己 (`x xor x = 0`)，一樣可以用同樣的 `scan` 套路，
>   只是把 `acc + x` 換成 `acc xor x`，把減法換成 XOR，思考一下為什麼查詢公式仍然成立。

## 高維前綴和 (Higher-Dimensional Prefix Sum)

!!! note "問題描述"
  
    給定一個 $n \times n$ 的方格，每格上有一個數字，接下來有 $q$ 筆查詢，
    每筆查詢給定左上角 `(r1, c1)` 與右下角 `(r2, c2)`，
    請回答這個矩形範圍內所有數字的總和。
    
    #### 技術規格
    
    - $1 \leq n \leq 10^3$
    - $1 \leq q \leq 2 \times 10^5$

一維的想法可以直接類推：<br>先把「從左上角 `(0,0)` 到某一格 `(i,j)`（不含）」這塊矩形的總和都預先算好，
存成一個二維的 `prefix` 陣列，之後每筆查詢就變成幾個 `prefix` 值的加減。

問題是，二維的矩形總和不能只靠「兩個位置相減」得到，
因為單純減去上方跟左方兩塊，左上角那一小塊會被重複扣掉兩次，
所以必須用排容原理把它加回來：

```
sum = prefix[r2+1][c2+1] - prefix[r1][c2+1] - prefix[r2+1][c1] + prefix[r1][c1]
```

二維前綴和其實就是「先對每一列做一次一維前綴和，再對每一行做一次一維前綴和」，
也就是把同一個 `scan` 動作，沿著不同的維度各套用一次。

```kotlin
/**
 * 對每一列做一維前綴和：
 * rowPrefix[i][j] = a[i][0] + a[i][1] + ... + a[i][j-1]
 */
private fun sumEachRow(a: List<List<Long>>): List<List<Long>> =
    a.map { row -> row.scan(0L) { acc, x -> acc + x } }
```

這裡我們拆解一下語法：
`a` 是一個二維 List, `a.map` 取出 `a` 的每一列，以 `row` 表示，
透過 `row` 呼叫 `scan` 得到一維前綴和。

```kotlin
/**
 * 對「每列已經是前綴和」的結果，沿著列的方向再做一次前綴和（逐欄相加）。
 */
fun prefixSum2D(a: List<List<Long>>): List<List<Long>> {
    val cols = if (a.isEmpty()) 0 else a[0].size
    val rowPrefix = sumEachRow(a)
    val zeroRow = List(cols + 1) { 0L }
    return rowPrefix.scan(zeroRow) { prevRow, curRow ->
        curRow.zip(prevRow) { x, y -> x + y }
    }
}
```

`rowPrefix` 是一個二維 List, `rowPrefix.scan` 取出 `rowPrefix` 的每一列，以 `prevRow`, `curRow` 表示 前後兩列，
因為列跟列不能直接相加，會變成串接兩個 List，這時就要想起我們的 `zip`，一般情況下使用 `zip` 可以得到兩個 List 中相同位置的元素，像是

```kotlin
val a = listOf(1, 2, 3)
val b = listOf(4, 5, 6)
val c = a.zip(b)
println(c) // [(1, 4), (2, 5), (3, 6)]
```

這樣的組合形式，但是 zip 其實有提供第二個參數，可以用來指定兩個 List 中相同位置的元素如何組合。
因此透過 `curRow.zip(prevRow) { x, y -> x + y }` 可以將兩列的數值加起來，得到新的一列。

```kotlin
// 查詢矩形 (r1,c1) ~ (r2,c2) 的總和，皆為 0-indexed 且區間包含兩端
fun rangeSum2D(prefix: List<List<Long>>, r1: Int, c1: Int, r2: Int, c2: Int): Long =
    prefix[r2 + 1][c2 + 1] - prefix[r1][c2 + 1] - prefix[r2 + 1][c1] + prefix[r1][c1]
```

相較於一維的前綴和，我們不能單純扣掉上方跟左方的區塊和，因為這樣左上方的區塊會被扣掉兩次，
要再加一次回來。


```kotlin
fun main() {
    val grid = listOf(
        listOf(1L, 2L, 3L),
        listOf(4L, 5L, 6L),
        listOf(7L, 8L, 9L)
    )
    val prefix = prefixSum2D(grid)
    println(rangeSum2D(prefix, 0, 0, 1, 1)) // 1+2+4+5 = 12
    println(rangeSum2D(prefix, 1, 1, 2, 2)) // 5+6+8+9 = 28
}
```

### 推廣到更高的維度

觀察剛才的作法，二維前綴和其實就是「沿著第一維做一次一維前綴和，再沿著第二維做一次一維前綴和」，
這個想法可以直接推廣：**`d` 維前綴和，就是把同一支一維 `scan` 依序套用在 `d` 個維度上各一次**，
跟維度數量無關，每一次套用的都是完全一樣的「把陣列變成累積和」的動作。

查詢公式的部分，排容原理也會跟著維度數增加而變成 $2^d$ 項相加減，
符號則取決於「這個角落用了幾次下界」：用偶數次下界的角落是正的，奇數次是負的。
以三維為例，查詢立方體 `(x1,y1,z1) ~ (x2,y2,z2)` 的公式會長這樣：

```kotlin
fun prefixSum3D(a: List<List<List<Long>>>): List<List<List<Long>>> {
    // 依序對第三維、第二維、第一維各做一次前綴和，即可推廣到三維
    val sumZ = a.map { plane -> plane.map { row -> row.scan(0L) { acc, x -> acc + x } } }
    val sumYZ = sumZ.map { plane ->
        val cols = if (plane.isEmpty()) 0 else plane[0].size
        val zeroRow = List(cols) { 0L }
        plane.scan(zeroRow) { prevRow, curRow -> curRow.zip(prevRow) { x, y -> x + y } }
    }
    val rows = if (sumYZ.isEmpty()) 0 else sumYZ[0].size
    val cols = if (rows == 0) 0 else sumYZ[0][0].size
    val zeroPlane = List(rows) { List(cols) { 0L } }
    return sumYZ.scan(zeroPlane) { prevPlane, curPlane ->
        curPlane.zip(prevPlane) { rowC, rowP -> rowC.zip(rowP) { x, y -> x + y } }
    }
}
```

可以看到，每多一個維度，就只是多一次「沿著這個維度 `scan`」的動作，

> **練習題**
>
> - [CSES 1652 - Forest Queries](https://cses.fi/problemset/task/1652)：本節例題的原型，
>   矩陣中只有 `0/1`，query 是矩形範圍內 `1` 的個數。
> - 試著把 `prefixSum3D` 的查詢公式（`2^3 = 8` 項排容）也寫成一個函式，
>   並觀察每一項的正負號跟「取了幾次上界 / 下界」之間的關係。

## 差分 (Difference Array)

!!! note "問題描述"
    給定一個長度為 $n$、初始值全為 $0$ 的陣列，接下來有 $q$ 筆區間加值的操作，
    每筆操作給定 `l, r, v`，代表把 `a[l], a[l+1], ..., a[r]` 都加上 `v`，
    請問所有操作結束後，這個陣列長什麼樣子？

    #### 技術規格
    
    - $1 ≤ n ≤ 2 × 10^5$
    - $1 ≤ q ≤ 2 × 10^5$

如果每筆操作都乖乖地用迴圈把 `a[l..r]` 全部加上 `v`，
單次操作最差是 $\mathcal{O}(n)$，`q` 筆操作下來又是 $\mathcal{O}(nq)$，跟前綴和一開始遇到的問題一模一樣，
只是這次「慢的地方」從查詢變成了更新。

前綴和的技巧，是把「陣列」轉換成「陣列的累積和」，讓區間查詢變成兩點相減；
差分則是反過來：把「陣列」轉換成「相鄰元素的差」，讓區間更新變成兩個點的加減。

我們定義差分陣列 `diff[0] = a[0]`，`diff[i] = a[i] - a[i-1]`（$i ≥ 1$）。
關鍵的觀察是：**對 `diff` 陣列取前綴和，會剛好還原出原本的 `a` 陣列**，
因為 `diff` 的前綴和公式攤開來，中間的項會一路互相抵銷，只留下 `a[i]` 本身，
換句話說，**差分是前綴和的逆運算**。

這個性質讓「區間加值」變得非常輕巧：
如果要把 `a[l..r]` 都加上 `v`，我們不需要真的去改動 `l` 到 `r` 之間的每一個元素，
只需要讓 `diff[l] += v`（讓 `a[l]` 之後的前綴和都多了 `v`），
再讓 `diff[r+1] -= v`（把 `v` 的效果在 `r` 之後抵銷掉），這樣對 `diff` 取一次前綴和，
就會得到「`a[l..r]` 都加了 `v`，其餘位置不變」的結果——單次更新只花 $\mathcal{O}(1)$。

以函數式的方式來看，每一筆「區間加值」的操作，本質上是兩個獨立的「事件」：
在位置 `l` 發生 `+v`，在位置 `r+1` 發生 `-v`。我們可以把所有操作先攤平成事件列表，
用 `groupBy` 依照發生的位置分組、把同一個位置的事件加總，
最後再對整條陣列做一次 `scan` 把事件「積分」回原本的陣列，全程不需要任何可變的 `Array`。

```kotlin
data class RangeAdd(val l: Int, val r: Int, val v: Long)

/**
 * 給定長度 n 的陣列（初始值皆為 0）與一連串的區間加值操作，
 * 回傳所有操作結束後的最終陣列。
 */
fun applyRangeAdds(n: Int, updates: List<RangeAdd>): List<Long> {
    val events = updates.flatMap { (l, r, v) ->
        buildList {
            add(l to v)
            if (r + 1 < n) add((r + 1) to -v)
        }
    }
    val diffMap = events
        .groupBy({ it.first }, { it.second })
        .mapValues { (_, vs) -> vs.sum() }

    val diff = (0 until n).map { i -> diffMap[i] ?: 0L }
    return diff.scan(0L) { acc, x -> acc + x }.drop(1) // 對差分陣列做前綴和，還原出 a
}
```

`flatMap` 的角色跟 `map` 類似，只是它會把每個元素轉換成一個序列，然後把所有序列攤平成一個單一的序列。
`buildList` 的作用是建立一個可變的列表，並在其中添加元素，所以裡面的 `add` 就是在添加元素。
`add(l to v)` 就是在添加一個 `Pair` 到列表中，其中 `l` 是區間的左邊界，`v` 是區間的加值。

因為可能有很多個重複的索引，例如 (1, 5) 跟 (1, 3)，所以我們用 `groupBy` 將 pair 按照 `first` 進行分組，然後對每個分組的 `second` 進行加總。

接著由於我們只會在有被區間操作的地方有值，但我們要計算每個位置的加總，所以 (0 untill n) 是用來創造長度為 $n + 1$ 的序列，如果有在 `diffMap` 中找不到的索引，則用 `0L` 作為預設值。

最後就是我們的老朋友 scan，對差分序列作前墜和相當於還原序列的值。

```kotlin
fun main() {
    val updates = listOf(
        RangeAdd(0, 2, 5),
        RangeAdd(1, 4, 3),
        RangeAdd(3, 3, -2)
    )
    println(applyRangeAdds(6, updates))
    // [5, 8, 8, 6, 3, 0]
}
```

因為建立事件列表是 $\mathcal{O}(q)$，`groupBy` 跟最後的 `scan` 都是 $\mathcal{O}(n + q)$，
整體時間複雜度是 $\mathcal{O}(n + q)$，遠比 $\mathcal{O}(nq)$ 的暴力解法快得多。

### 推廣到二維差分

差分跟前綴和互為逆運算這件事，在高維的情況下依然成立：
如果我們想對一個矩形範圍 `(r1,c1) ~ (r2,c2)` 都加上 `v`，
一樣可以用排容原理，只在矩形的四個角落各放一個帶正負號的事件，
放完事件之後，對整個矩陣做一次前面寫好的 `prefixSum2D`，就能直接還原出更新後的陣列——
這正好呼應了上一節「二維前綴和」的實作，差分只是反過來使用它。

```kotlin
data class RectAdd(val r1: Int, val c1: Int, val r2: Int, val c2: Int, val v: Long)

fun applyRectAdds(rows: Int, cols: Int, updates: List<RectAdd>): List<List<Long>> {
    val events = updates.flatMap { (r1, c1, r2, c2, v) ->
        buildList {
            add((r1 to c1) to v)
            if (c2 + 1 < cols) add((r1 to (c2 + 1)) to -v)
            if (r2 + 1 < rows) add(((r2 + 1) to c1) to -v)
            if (r2 + 1 < rows && c2 + 1 < cols) add(((r2 + 1) to (c2 + 1)) to v)
        }
    }
    val diffMap = events.groupBy({ it.first }, { it.second }).mapValues { it.value.sum() }
    val diff = (0 until rows).map { r -> (0 until cols).map { c -> diffMap[r to c] ?: 0L } }

    // 對差分矩陣做二維前綴和，直接還原出所有操作結束後的矩陣
    val prefix = prefixSum2D(diff)
    return (1..rows).map { r -> (1..cols).map { c -> prefix[r][c] } }
}
```

這裡完整重用了前一節寫好的 `prefixSum2D`，
沒有另外再實作一次「二維前綴和」的邏輯，這也是函數式風格的一個好處：
只要「前綴和」跟「差分互為逆運算」這個關係抽出來共用，
一維、二維甚至更高維度的差分，都可以直接借用同一套前綴和的程式碼來還原結果。

> **練習題**
>
> - [AtCoder ABC183 D - Water Heater](https://atcoder.jp/contests/abc183/tasks/abc183_d)：
>   本節例題的原型，是差分陣列（日文常稱「いもす法」）最經典的入門題之一。
> - 承上題，試著把 `applyRectAdds` 改寫成可以回答「任意矩形範圍的總和」，
>   而不只是還原整個矩陣——提示：對還原出來的矩陣再做一次 `prefixSum2D` 即可，
>   感受一下「差分處理更新、前綴和處理查詢」兩者疊在一起使用的威力。

## 結論

### 前綴和與差分的對照

| | 前綴和 (Prefix Sum) | 差分 (Difference Array) |
| --- | --- | --- |
| 解決的問題 | 大量「區間查詢」 | 大量「區間更新」 |
| 核心動作 | 對原陣列做 `scan`（累加） | 對更新事件做 `groupBy` 後再 `scan` |
| 單次操作複雜度 | 建置 `O(n)`，查詢 `O(1)` | 建置 `O(1)`，還原 `O(n)` |
| 彼此的關係 | 差分陣列的前綴和 = 原陣列 | 原陣列的差分 = 差分陣列 |

兩者互為逆運算，而且都可以透過「沿著每一個維度各套用一次同樣的一維操作」推廣到任意維度，
這也是為什麼在函數式的寫法下，二維、三維甚至 `d` 維的版本，
程式的骨架幾乎不需要改變——真正在變的只有「沿著哪一個維度做 `scan`」而已。

要注意的是，前綴和跟差分都只適合「所有更新做完之後才一次查詢」或「所有查詢在更新之前就先做完」的**靜態**情境；
如果需要「一邊更新一邊查詢」交錯進行，則需要用到樹狀陣列（Fenwick Tree）或線段樹等資料結構，
那就是超出本篇範圍的另一個主題了。

## 題單

- [CSES 1646 - Static Range Sum Queries](https://cses.fi/problemset/task/1646)
- [CSES 1650 - Range Xor Queries](https://cses.fi/problemset/task/1650)
- [CSES 1652 - Forest Queries](https://cses.fi/problemset/task/1652)
- [AtCoder ABC183 D - Water Heater](https://atcoder.jp/contests/abc183/tasks/abc183_d)

CSES 平台沒有提供 Kotlin，但你還是可以學習核心精神。
