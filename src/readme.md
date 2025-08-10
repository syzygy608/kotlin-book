# Welcome to Kotlin Book

Kotlin Book 使用 Rust 團隊的 MDBook 作為網站的內容管理系統，加上 [MDBook Admonish](https://github.com/tommilligan/mdbook-admonish) 來美化網站布局、[MDBbook Katex](https://github.com/lzanini/mdbook-katex) 來改善數學式渲染，並使用 Vercel 作為靜態網站的部署平台。

Kotlin 是一個現代化的程式語言，具有簡潔的語法和強大的功能，適用於各種應用程式開發，包括 Android 應用程式、Web 應用程式和後端服務。Kotlin 的設計目標是提高開發效率，減少錯誤，並提供更好的可讀性。近年來 ICPC 系列賽事中，Kotlin 也逐漸成為一個受歡迎的選擇，
但是台灣社群缺少對於 Kotlin 的競程相關內容，因此我們決定建立這個網站，提供一個完整的 Kotlin 競程學習資源。

## 使用說明

### 內容管理    

如果你想要新增或修改內容，請透過 Github 的 Pull Request 功能來提交你的修改，
對本網站的 [Repository](https://github.com/syzygy608/kotlin-book) 進行 Fork，然後在你的 Fork 上進行修改，最後提交 Pull Request。

可以在左邊導覽列中查看預計的內容結構，選擇你想要的主題進行撰寫。
如果你不熟悉 Pull Request 的流程，可以參考 [GitHub 的官方說明](https://docs.github.com/en/get-started/quickstart/contributing-to-projects)。

在經過審核後，修改將會被合併到主分支中，等待下一次部署時，網站內容將會更新。

歡迎使用圖片協助說明教學，圖片請放在與 md 檔同位置的 image 資料夾底下，
另外，Latex 公式也可以直接使用，請使用 `$` 來包覆行內公式，或使用 `$$` 來包覆多行公式。

### MDBook 本地開發

如果你想要了解如何使用 MDBook 來撰寫內容，可以參考 [MDBook 的官方文檔](https://rust-lang.github.io/mdBook/index.html)。

因為本專案使用了 MDBook Admonish 以及 MDBook Katex，所以你需要安裝這兩個插件，
使用 Cargo 來安裝這些插件需要耗費大量時間，
因此建議使用本專案的 `vercel.sh` 腳本來安裝這些插件，
這個腳本會自動安裝 MDBook 以及所需的插件 binaries，
減少安裝時間。

