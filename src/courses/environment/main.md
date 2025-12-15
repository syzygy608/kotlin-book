# 環境架設與基礎介紹

~~~admonish note title="作者"
D1stance (吳翰平)
~~~

相較於 C++ 需要安裝編譯器、IDE 等工具，Kotlin 的環境架設相對簡單許多。  
只要安裝 [JetBrains 的 IntelliJ IDEA](https://www.jetbrains.com/idea/) 就可以開始撰寫 Kotlin 程式碼，並享受完善的語法提示與自動完成。

## 為什麼在競賽中選擇 Kotlin？

在競賽程式設計（Competitive Programming, CP）領域，Kotlin 雖然不像 C++ 那麼主流，但它有一些值得考慮的優勢：

- **內建大數支援**  
  Kotlin 可以使用  `BigInteger` 與 `BigDecimal`，處理大數運算比 C++ 方便，而在速度上又比 Python 快。

- **更安全的語言設計**  
  Null 安全 (`?`、`!!`、`?:`) 讓許多不安全的記憶體操作在編譯階段就能被發現，減少低級失誤。

- **現代語法與高可讀性**  
  Kotlin 提供 Lambda、集合操作函式（`map`、`filter`、`reduce` 等），寫法簡潔，可快速表達演算法邏輯。

- **跨平台與 Java 互通性**  
  能直接呼叫 Java 標準函式庫與資料結構，例如 `ArrayList`、`HashMap`，並享有 Java 生態的豐富資源。

- **缺點與挑戰**
  - 執行速度普遍略慢於 C++
  - I/O 預設較慢 → 建議自訂 `BufferedReader` 與 `BufferedWriter` 模板來加速。

---

## 安裝 IntelliJ IDEA

前往 [JetBrains 的下載頁面](https://www.jetbrains.com/idea/download/) 下載 IntelliJ IDEA 的安裝程式，根據你的作業系統選擇合適的版本進行安裝。

![](/assets/environment/idea.png)

下載好安裝程式後，執行它並按照指示完成安裝，一直按下一步直到出現這個畫面：

![](/assets/environment/idea_path.png)

將 `idea` 的路徑加入到系統的環境變數中。

安裝完成後，啟動 IntelliJ IDEA，並選擇 **"Create New Project"**，選擇 **"Kotlin"** 作為專案類型，然後選擇 **"JVM | IDEA"** 作為專案 SDK。

![](/assets/environment/new_project.png)

新增好之後就會自動生成一個範例程式碼，按下播放鍵來執行，就能看到輸出結果：

![](/assets/environment/sample.png)

---

## 多檔案編譯注意事項

在 IDEA 裡同時撰寫多個 Kotlin 檔案時，如果多個檔案定義了相同名稱的函數，會發生編譯錯誤。  
解決方法之一是**將檔案分到不同的 Module** 中，確保命名空間不衝突。

---

## 新增 Module

1. 在左上角專案面板中點擊 **"New" → "Module"**。
2. 選擇 **"Kotlin"** 作為模組類型，並選擇 **"JVM | IDEA"** 作為模組 SDK。

![](/assets/environment/module.png)

![](/assets/environment/new_module.png)

這樣就有獨立的模組了，可以在這個模組裡撰寫 Kotlin 程式碼，避免名稱衝突。

---

## C++ 與 Kotlin 環境對照表

| 功能           | C++                  | Kotlin                              |
|----------------|----------------------|--------------------------------------|
| 編譯器         | g++, clang++         | kotlinc（隨 IntelliJ 附帶）          |
| I/O 加速       | `ios::sync_with_stdio(false)` | 使用 `BufferedReader` / `BufferedWriter` |
| 大數支援       | 無內建   | 內建 `BigInteger` / `BigDecimal`     |
| Null 安全檢查  | 無                    | 編譯器檢查（`?`、`!!`、`?:`）        |

