#!/usr/bin/fish

IDE=("https://download.jetbrains.com.cn/cpp/CLion-2023.1.3.tar.gz")

download() {
  for url in $IDE; do
    curl -L "${url}"
  done
}
