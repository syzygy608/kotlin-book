# 遞迴

我們先來看看數學的遞迴，以最常見的斐波那契數列為例：

$$
f(n) = 
\begin{cases}
n & \text{if } n \leq 1 \\
f(n-1) + f(n-2) & \text{if } n > 1
\end{cases}
$$

為什麼我們很信任數學的遞迴定義？因為它有明確的基本情況（$n \le 1$）和<br>遞迴關係（`f(n) = f(n-1) + f(n-2)`），
透過數學歸納法來證明這個定義是正確的。

這樣我們就可以從基礎情況開始，逐步計算出更大的值。
像是 `f(0) = 0`，`f(1) = 1`，然後 `f(2) = f(1) + f(0) = 1 + 0 = 1`，以此類推。

那程式中的遞迴呢？我們稱函數呼叫自己為遞迴（recursion），
這樣可以解決一些問題，像是計算階乘、斐波那契數列等。

## 基本語法

```kotlin
fun fabonacci(n: Int): Int {
    if(n <= 1)
        return n
    else
        return fabonacci(n - 1) + fabonacci(n - 2)
}
```

為什麼我們會有點害怕遞迴？因為跟數學的遞迴式不同，
程式中的遞迴都是從結尾開始往前推的，
像是 `fabonacci(5)` 會先計算 `fabonacci(4)`，然後 `fabonacci(3)`，依此類推，
直到 $n \le 1$ 為止，然後再一層一層回傳結果。
我們不知道中間會發生什麼事情，不像數學的遞迴式是層層展開的。

那麼我們要怎麼寫出一個值得信任的遞迴函數呢？

1. **明確的基礎情況**：必須有明確的條件來終止遞迴，否則會無限循環。
2. **正確的遞迴關係**：每次呼叫都應該縮小問題的規模，最終能夠達到基礎情況。
3. **練習使用 pure function**：遞迴函數應該是純函數，這樣更容易理解和測試。

## 子集合枚舉 (Subsets Enumeration)

假設我們有一個集合 $\{1, 2, 3\}$，它的子集合就是所有可能的組合，包括空集合、單元素集合、雙元素集合和全集合。
像是 $\{\}, \{1\}, \{2\}, \{3\}, \{1, 2\}, \{1, 3\}, \{2, 3\}, \{1, 2, 3\}$。

假設現在沒有任何元素，我們的子集合就是空集合 $\{\}$；<br>
如果最多包含一個元素 $1$，那麼我們的子集合就是 $\{\}, \{1\}$；<br>
如果最多包含兩個元素 $1, 2$，那麼我們的子集合就是 $\{\}, \{1\}, \{2\}, \{1, 2\}$；<br>
如果最多包含三個元素 $1, 2, 3$，那麼我們的子集合就是 $\{\}, \{1\}, \{2\}, \{1, 2\}, \{3\}, \{1, 3\}, \{2, 3\}, \{1, 2, 3\}$

你有發現什麼事情嗎？除了空集合以外，每新增一個元素其實就是將原本的結果複製一份，然後在新複製那份的每個子集合中加入這個新元素。

假設我們有一個集合 $S$，它的子集合表示為 $P(S)$，那麼我們可以用遞迴來定義子集合的生成：

$$
P(S) =
\begin{cases}
\{\} & \text{if } S = \emptyset \\
P(S - \{x\}) \cup (P(S - \{x\}) \cup \{x\}) & \text{if } S = S' \cup \{x\}
\end{cases}
$$

這裡的 $S'$ 是 $S$ 去掉元素 $x$ 的集合。

自然地，我們可以用 Pure Function 來實作這個遞迴：

```kotlin
fun subsets(s: List<Int>): List<List<Int>> {
    // 空集合
    if(s.isEmpty())
        return listOf(emptyList())
    // 取出最後一個元素，並遞迴計算剩餘部分的子集
    val last = s.last()
    val subsetsWithoutFirst = subsets(s.subList(0, s.size - 1))
    // 將第一個元素加入每個子集，生成新的子集
    val subsetsWithFirst = subsetsWithoutFirst.map { it + last }
    // 合併不包含 first 的子集和包含 first 的子集
    return subsetsWithoutFirst + subsetsWithFirst
}
```

可以看到，我們先處理基礎情況，當集合為空時，只有一個子集，即空集合。然後我們取出最後一個元素，並遞迴計算剩餘部分的子集。接著，我們將這個元素加入每個子集中，生成新的子集。最後，我們將不包含這個元素的子集和包含這個元素的子集合併起來。

執行結果如下

![](/assets/function/subset.png)


~~~admonish note title="想想看"
如果今天我們要解決的是列出由 $1 \sim n$ 數字組成的所有排列，
像是 $n=3$ 時，會有 $6$ 種排列：$123, 132, 213, 231, 312, 321$，
我們可以透過類似的方式來解決這個問題嗎？
~~~

~~~admonish info title="想好了再看" collapsible=true

當然可以，我們可以留下一個數字，然後將剩餘的數字遞迴地排列起來。
接著我們就可以選擇這個數字要插在哪個位置，把這個數字插在剩餘數字組成之排列上的每個位置上。

```kotlin
fun permutations(s: List<Int>): List<List<Int>> {
    if(s.isEmpty())
        return listOf(emptyList())
    val first = s.first()
    val permutationsWithoutFirst = permutations(s.subList(1, s.size))
    val result = mutableListOf<List<Int>>()
    permutationsWithoutFirst.forEach { perm ->
        for(i in 0..perm.size) {
            // 在每個位置插入 first
            result.add(perm.subList(0, i) + first + perm.subList(i, perm.size))
        }
    }
    return result
}
```

`forEach` 就是 `for` + `in` 的高階版本，
除了一一列出元素之外，還可以直接操作每個元素。


~~~

## 遞迴小結

- 遞迴是萬能的
    - 透過遞迴可以列出所有可能
    - 思考問題的出發點

- 遞迴是萬萬不能的
    - 所需要耗費的時間巨大 ($n$ 個元素的子集合有 $2^n$ 個，排列有 $n!$ 個)
    - 在大部分情況下，顯然有更好的解法

---

## 萬年河內塔

河內塔（Tower of Hanoi）是一個經典的遞迴問題，目標是將一組盤子從一根柱子移動到另一根柱子，並且遵循以下規則：

1. 每次只能移動一個盤子。
2. 不能將較大的盤子放在較小的盤子上面。

問題的關鍵是我們要將最下面的盤子移動到目標柱子上，剩下的盤子才可以繼續移動。

那麼要怎麼移動剩下的盤子呢？是不是又要先把最下面的一個盤子移到暫存柱子上，然後再將剩下的盤子移到目標柱子上，這樣不斷重複，直到只剩下一個盤子可以直接移動到目標柱子上。

所以問題可以拆解成三個部分：

1. 將 $n-1$ 個盤子從起始柱子移動到暫存柱子。
2. 將最下面的盤子從起始柱子移動到目標柱子。
3. 將 $n-1$ 個盤子從暫存柱子移動到目標柱子。

而第 1, 3 步驟又可以被拆解成三個部分，這就是遞迴。

為什麼這個思想是正確的？我們可以透過數學歸納法來證明。

證明我們可以把 $n$ 個盤子從起始柱子移動到目標柱子。

1. **Base case**：當 $n=1$ 時，直接將盤子從起始柱子移動到目標柱子。
2. **Inductive step**：假設對於 $n=k$ 的情況是正確的，即可以將 $k$ 個盤子從起始柱子移動到目標柱子。
3. 現在考慮 $n=k+1$ 的情況，我們可以將 $k$ 個盤子從起始柱子移動到暫存柱子，因為根據假設這是正確的。

我們就可以把最下面的盤子從起始柱子移動到目標柱子，因為只有一個盤子，所以這個操作也是合法的。

接著再把剩下的 $k$ 個盤子從暫存柱子移動到目標柱子，這也是根據假設是正確的。

因此，根據數學歸納法，我們可以將 $n$ 個盤子從起始柱子根據這套流程移動到目標柱子。

我們會根據上面的流程寫出這樣的傳統遞迴函數：

```kotlin
fun hanoi(n: Int, from: String, to: String, temp: String) {
    if(n == 1) {
        println("Move disk from $from to $to")
    }
    else {
        hanoi(n - 1, from, temp, to) // 將 n-1 個盤子從 from 移到 temp
        hanoi(1, from, to, temp)     // 將最下面的盤子從 from 移到 to
        hanoi(n - 1, temp, to, from) // 將 n-1 個盤子從 temp 移到 to
    }
}

```

這個函數有什麼問題？首先，我們只知道盤子是怎麼移動的，並不知道是誰被移動了。更重要的是，**這個函數並不是純函數（Pure Function）**，它在內部直接呼叫了 `println` 產生副作用（Side Effects），這使得我們極難寫單元測試來驗證它的正確性。

### 河內塔遞迴跟 Fibonacci 遞迴的差異

* Fibonacci 遞迴是純函數，不管呼叫幾次都會得到相同的結果。
* 甚至可以改變呼叫的順序，仍然會得到相同的結果：
* $f(n) = f(n-1) + f(n-2)$，可以先算 $f(n-1)$ 再算 $f(n-2)$，也可以反過來。


* 但傳統寫法的河內塔不行，它依賴執行的先後順序來印出日誌，交換順序結果就全錯了。

### 擁抱 FP：用資料代表行為

那麼，如果我們要用純函數來實作河內塔呢？
在 FP 中，我們更傾向於**把「移動步驟」本身抽象成不可變的資料（Immutable Data）**。

我們定義一個 `Move` 資料類別，它是一個純粹的資料載體：

```kotlin
data class Move(val disk: Int, val from: Char, val to: Char) {
    override fun toString() = "將第 $disk 個盤子從 $from 移到 $to"
}

```

接著，我們利用 Kotlin 的表達式特性（Expression）與唯讀集合操作，讓函數不再印出東西，而是**直接傳回一個不可變的步驟列表 `List<Move>`**：

```kotlin
fun solveHanoi(n: Int, from: Char, to: Char, aux: Char): List<Move> {
    // 使用 when 表達式直接傳回結果
    return when (n) {
        0 -> emptyList() // 邊界條件：沒有盤子時，步驟為空
        1 -> listOf(Move(1, from, to)) // 只有一個盤子，直接移動
        else -> {
            // 1. 將 n-1 個盤子從 from 移到 aux
            val step1 = solveHanoi(n - 1, from, aux, to)
            
            // 2. 將第 n 個盤子（最大的）從 from 移到 to
            val step2 = listOf(Move(n, from, to))
            
            // 3. 將 n-1 個盤子從 aux 移到 to
            val step3 = solveHanoi(n - 1, aux, to, from)
            
            // 使用 Kotlin 的 + 操作符拼接三個不可變列表，產生全新結果
            step1 + step2 + step3
        }
    }
}

```

### 隔離副作用（Side Effects）

透過上述的重構，`solveHanoi` 變成了一個完美的純函數：**相同的輸入永遠得到相同順序的 List，且不影響外界任何狀態**。

直到程式的最後一刻（系統邊界），我們才把這些資料交給 `main` 函數去執行副作用（印出畫面）：

```kotlin
fun main() {
    val totalDisks = 3
    
    // 呼叫純函數，此時沒有任何東西被印出，只是在記憶體中組合出解答
    val moves = solveHanoi(totalDisks, 'A', 'C', 'B')
    
    // 在程式的最外層才執行副作用
    println("解決 $totalDisks 層河內塔共需要 ${moves.size} 步：")
    moves.forEach { println(it) }
}

```

這種寫法不僅解決了狀態追蹤的問題，也完美契合了 Functional Programming 中「邏輯運算與副作用分離」的核心哲學。

$n = 4$ 的執行結果如下：
```
解決 4 層河內塔共需要 15 步：
將第 1 個盤子從 A 移到 B
將第 2 個盤子從 A 移到 C
將第 1 個盤子從 B 移到 C
將第 3 個盤子從 A 移到 B
將第 1 個盤子從 C 移到 A
將第 2 個盤子從 C 移到 B
將第 1 個盤子從 A 移到 B
將第 4 個盤子從 A 移到 C
將第 1 個盤子從 B 移到 C
將第 2 個盤子從 B 移到 A
將第 1 個盤子從 C 移到 A
將第 3 個盤子從 B 移到 C
將第 1 個盤子從 A 移到 B
將第 2 個盤子從 A 移到 C
將第 1 個盤子從 B 移到 C
```


## References

- [南京大學蔣炎岩教授的遞迴課程](https://www.bilibili.com/video/BV1Y2421A7sB/?share_source=copy_web&vd_source=8eb0208b6e349b456c095c16067fb3af)