# 遞迴

我們先來看看數學的遞迴，以最常見的斐波那契數列為例：

$$
f(n) = 
\begin{cases}
n & \text{if } n \leq 1 \\
f(n-1) + f(n-2) & \text{if } n > 1
\end{cases}
$$

為什麼我們很信任數學的遞迴定義？因為它有明確的基礎情況（`n <= 1`）和遞迴關係（`f(n) = f(n-1) + f(n-2)`），
這樣我們就可以從基礎情況開始，逐步計算出更大的值。
像是 `f(0) = 0`，`f(1) = 1`，然後 `f(2) = f(1) + f(0) = 1 + 0 = 1`，依此類推。

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
直到遇到基礎情況 `n <= 1`。

我們不知道中間會發生什麼事情，不像數學的遞迴式是層層展開的。

那麼我們要怎麼寫出一個值得信任的遞迴函數呢？

1. **明確的基礎情況**：必須有明確的條件來終止遞迴，否則會無限循環。
2. **正確的遞迴關係**：每次呼叫都應該縮小問題的規模，最終能夠達到基礎情況。
3. **練習使用 pure function**：遞迴函數應該是純函數，這樣更容易理解和測試。

## 子集合枚舉 (Subsets Enumeration)

首先什麼是子集合，假設我們有一個集合 $\{1, 2, 3\}$，它的子集合就是所有可能的組合，包括空集合、單元素集合、雙元素集合和全集合。
像是 $\{\}, \{1\}, \{2\}, \{3\}, \{1, 2\}, \{1, 3\}, \{2, 3\}, \{1, 2, 3\}$。

假設現在沒有任何元素，我們的子集合就是空集合 $\{\}$；<br>
如果我們有一個元素 $1$，那麼我們的子集合就是 $\{\}, \{1\}$；<br>
如果我們有兩個元素 $1, 2$，那麼我們的子集合就是 $\{\}, \{1\}, \{2\}, \{1, 2\}$；<br>
如果我們有三個元素 $1, 2, 3$，那麼我們的子集合就是 $\{\}, \{1\}, \{2\}, \{1, 2\}, \{3\}, \{1, 3\}, \{2, 3\}, \{1, 2, 3\}$

你有發現什麼事情嗎？除了空集合以外，每新增一個元素其實就是將原本的結果複製一份，然後在每個子集合中加入這個新元素。

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
    // 基礎情況：空集合只有一個子集，即空集合
    if(s.isEmpty())
        return listOf(emptyList())
    // 取出最後個元素，並遞迴計算剩餘部分的子集
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
~~~

## 遞迴小結

- 遞迴是萬能的
    - 透過遞迴可以列出所有可能
    - 思考問題的出發點

- 遞迴是萬萬不能的
    - 所需要耗費的時間巨大 ($n$ 個元素的子集合有 $2^n$ 個，排列有 $n!$ 個)
    - 在大部分情況下，顯然有更好的解法

## 萬年河內塔

河內塔（Tower of Hanoi）是一個經典的遞迴問題，目標是將一組盤子從一根柱子移動到另一根柱子，
並且遵循以下規則：
1. 每次只能移動一個盤子。
2. 不能將較大的盤子放在較小的盤子上面。

問題的關鍵是我們要將最下面的盤子移動到目標柱子上，
剩下的盤子才可以繼續移動。

那麼要怎麼移動剩下的盤子呢？是不是又要先把最下面的一個盤子移到暫存柱子上，
然後再將剩下的盤子移到目標柱子上，這樣不斷重複，直到只剩下一個盤子可以直接移動到目標柱子上。

所以問題可以拆解成三個部分
1. 將 $n-1$ 個盤子從起始柱子移動到暫存柱子。
2. 將最下面的盤子從起始柱子移動到目標柱子。
3. 將 $n-1$ 個盤子從暫存柱子移動到目標柱子。

而第 3. 步驟又可以被拆解成三個部分，這就是遞迴。

為什麼這個思想是正確的？我們可以透過數學歸納法來證明。

證明我們可以把 $n$ 個盤子從起始柱子移動到目標柱子。

1. **Base case**：當 $n=1$ 時，直接將盤子從起始柱子移動到目標柱子。
2. **Inductive step**：假設對於 $n=k$ 的情況是正確的，即可以將 $k$ 個盤子從起始柱子移動到目標柱子。
3. 現在考慮 $n=k+1$ 的情況，我們可以將 $k$ 個盤子從起始柱子移動到暫存柱子，因為根據假設這是正確的。<br>
我們就可以把最下面的盤子從起始柱子移動到目標柱子，因為只有一個盤子，所以這個操作也是合法的，<br>
接著再把剩下的 $k$ 個盤子從暫存柱子移動到目標柱子，這也是根據假設是正確的。

因此，根據數學歸納法，我們可以將 $n$ 個盤子從起始柱子根據這套流程移動到目標柱子。

我們會根據上面的流程寫出這樣的遞迴函數：

```kotlin
fun hanoi(n: Int, from: String, to: String, temp: String) {
    if(n == 1) {
        writeln("Move disk from $from to $to")
    }
    else {
        hanoi(n - 1, from, temp, to) // 將 n-1 個盤子從 from 移到 temp
        hanoi(1, from, to, temp) // 將最下面的盤子從 from 移到 to
        hanoi(n - 1, temp, to, from) // 將 n-1 個盤子從 temp 移到 to
    }
}
```

執行結果如下：

![alt text](/assets/function/hanoi.png)

這個函數有什麼問題？首先，我們只知道盤子是怎麼移動的，
並不知道是誰被移動了，而且你也發現這個函數並不是純函數，
所以其實我們很難檢測這個函數的正確性。

### 河內塔遞迴跟 fabonacci 遞迴的差異

- fabonacci 遞迴是純函數，不管呼叫幾次都會得到相同的結果。
- 甚至可以改變呼叫的順序，仍然會得到相同的結果。
    - $f(n) = f(n-1) + f(n-2)$，可以先算 $f(n-1)$ 再算 $f(n-2)$，也可以先算 $f(n-2)$ 再算 $f(n-1)$。
- 但河內塔不行，交換順序就錯了

那麼，如果我們要用純函數來實作河內塔呢？
我們需要知道什麼東西來做為參數，才可以保證每次呼叫都會得到相同的結果？

假設我們要移動 $n$ 個盤子，從 `from` 柱子移動到 `to` 柱子，
但其實根據每根柱子上的狀態不同，移動的方式也會不同，
因為盤子放置是有規則限制的，所以在純函式中，我們需要傳遞每根柱子的狀態。

假設我們有三根柱子 `A`, `B`, `C`，每根柱子上的盤子可以用一個 List 來表示，
我們先寫一個輔助函式來產生移動盤子後的新狀態：

```kotlin
fun moveDisk(state: ArrayList<ArrayList<Int>>, n: Int, from: Int, to: Int): ArrayList<ArrayList<Int>> {
    val newState = ArrayList(state.map { ArrayList(it) }) // 因為我們要符合純函式的要求，所以需要複製一份狀態
    val temp = ArrayList<Int>()
    repeat(n) {
        temp.add(newState[from].removeLast()) // 將盤子拿到暫存區
    }
    repeat(n) {
        newState[to].add(temp.removeLast()) // 將盤子放到 to
    }
    return newState
}
```

這樣才可以好好的處理原本河內塔中移動 $n-1$ 個盤子的問題，
接著我們就可以寫出純函式的河內塔遞迴：

```kotlin
fun hanoi(state: ArrayList<ArrayList<Int>>, n: Int, from: Int, to: Int): ArrayList<ArrayList<ArrayList<Int>>> {
    val res = ArrayList<ArrayList<ArrayList<Int>>>()
    if(n == 1) {
        // 如果只有一個盤子，直接移動
        res.add(moveDisk(state, n, from, to))
        return res
    }
    val aux = 3 - from - to
    // 三根柱子的編號和為 0 + 1 + 2 = 3，所以可以用 3 - from - to 得到暫存柱子的編號
    val s1 = moveDisk(state, n - 1, from, aux)
    // 將 n-1 個盤子從 from 移到 aux 的狀態
    val s2 = moveDisk(s1, 1, from, to)
    // 將最下面的盤子從 from 移到 to 的狀態

    val move1 = hanoi(state, n - 1, from, aux)
    // 遞迴將 n-1 個盤子從 from 移到 aux
    val move2 = hanoi(s1, 1, from, to)
    // 遞迴將最下面的盤子從 from 移到 to
    val move3 = hanoi(s2, n - 1, aux, to)
    // 遞迴將 n-1 個盤子從 aux 移到 to

    // 將三個狀態合併
    move1.forEach { res.add(it) }
    move2.forEach { res.add(it) }
    move3.forEach { res.add(it) }
    return res
}
```

$n = 4$ 的執行結果如下：
```
4 3 2
1
{}

4 3
1
2

4 3
{}
2 1

4
3
2 1

4 1
3
2

4 1
3 2
{}

4
3 2 1
{}

{}
3 2 1
4

{}
3 2
4 1

2
3
4 1

2 1
3
4

2 1
{}
4 3

2
1
4 3

{}
1
4 3 2

{}
{}
4 3 2 1
```


## References

- [南京大學蔣炎岩教授的遞迴課程](https://www.bilibili.com/video/BV1Y2421A7sB/?share_source=copy_web&vd_source=8eb0208b6e349b456c095c16067fb3af)