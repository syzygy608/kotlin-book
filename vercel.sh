#!/bin/bash

# 下載並解壓 mdbook
curl -Lo mdbook.tar.gz https://github.com/rust-lang/mdBook/releases/download/v0.4.52/mdbook-v0.4.52-x86_64-unknown-linux-musl.tar.gz;
tar xvzf mdbook.tar.gz

# 下載並解壓 katex plugin
curl -Lo mdbook-katex.tar.gz https://github.com/lzanini/mdbook-katex/releases/download/0.9.3-binaries/mdbook-katex-v0.9.3-x86_64-unknown-linux-musl.tar.gz
tar xvzf mdbook-katex.tar.gz

# 下載並解壓 admonish plugin
curl -Lo mdbook-admonish.tar.gz https://github.com/tommilligan/mdbook-admonish/releases/download/v1.20.0/mdbook-admonish-v1.20.0-x86_64-unknown-linux-musl.tar.gz
tar xvzf mdbook-admonish.tar.gz

# 設定 PATH
export PATH="$(pwd):$PATH"
mdbook build