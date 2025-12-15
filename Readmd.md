# Kotlin Book

一個使用 Kotlin 語言的基礎競程入門教學網站

Webiste: [Click Here](https://kotlin-book.vercel.app/)

## Local Development

### Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Install Packages

```bash
cargo install --version 0.4.52 mdbook 
cargo install --version 0.9.3 mdbook-katex
cargo install --version 1.20.0 mdbook-admonish
```

### Build

```bash
mdbook serve
```

```bash
mdbook build
```