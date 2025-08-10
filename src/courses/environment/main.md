# 環境架設與基礎介紹

~~~admonish note title="作者"
D1stance (吳翰平)
~~~

相較於 C++ 需要安裝編譯器、IDE 等工具，Kotlin 的環境架設相對簡單許多。
我們只要安裝 [JetBrains 的 IntelliJ IDEA](https://www.jetbrains.com/idea/) 就可以開始撰寫 Kotlin 程式碼了。

## 安裝 IntelliJ IDEA

前往 [JetBrains 的下載頁面](https://www.jetbrains.com/idea/download/) 下載 IntelliJ IDEA 的安裝程式，根據你的作業系統選擇合適的版本進行安裝，
有分成 Community 版和 Ultimate 版，Community 版是免費的，適合大多數的使用者。

![](/assets/environment/idea_community.png)

下載好安裝程式後，執行它並按照指示完成安裝，一直按下一步直到出現這個畫面：

![](/assets/environment/idea_path.png)

將 `idea` 的路徑加入到系統的環境變數中。

安裝完成後，啟動 IntelliJ IDEA，並選擇 "Create New Project"，選擇 "Kotlin" 作為專案類型，然後選擇 "JVM | IDEA" 作為專案 SDK。

![](/assets/environment/new_project.png)

新增好之後就有一個範例程式碼，按下播放鍵來執行程式碼，就可以看到輸出，

![](/assets/environment/sample.png)

因為 IDEA 裡面同時撰寫多個 Kotlin 檔案時會造成編譯錯誤，因為相同的函數名稱會被多個檔案定義，所以我們需要將這些檔案放在同一個 package 底下。

## 建立 Kotlin Package

![](/assets/environment/package.png)

在專案視窗中，右鍵點擊 `src` 資料夾，選擇 "New" -> "Package"，輸入你想要的 package 名稱，例如 `example`。

這樣就會在 `src` 資料夾下建立一個新的 package 資料夾。

接著在這個 package 資料夾下建立 Kotlin 檔案，右鍵點擊 package 資料夾，選擇 "New" -> "Kotlin Class/File"，輸入檔案名稱，例如 `Main.kt`，
這樣就會在 package 資料夾下建立一個新的 Kotlin 檔案，檔案開頭會自動加入 package 的宣告。

```kotlin
package example
```

這樣就可以在這個 package 底下撰寫 Kotlin 程式碼了，但記得上傳評測系統的時候，請將這行註解掉。
