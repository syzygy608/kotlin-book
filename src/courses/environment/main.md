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

因為 IDEA 裡面同時撰寫多個 Kotlin 檔案時會造成編譯錯誤，因為相同的函數名稱會被多個檔案定義，
所以我們需要將檔案分開不同的 `modules` 來解決這個問題。

## 新增 Module

點擊左上角的 "New" -> "Module"，選擇 "Kotlin" 作為模組類型，然後選擇 "JVM | IDEA" 作為模組 SDK。

![](/assets/environment/module.png)

![](/assets/environment/new_module.png)

這樣就有獨立的模組了，可以在這個模組裡面撰寫 Kotlin 程式碼。