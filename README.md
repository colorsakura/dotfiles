# 说明

个人的 Linux 配置文件仓库。
目前主要使用 Arch 滚动发行版.
于 2023-01-11 开始使用 **stow** 来管理配置文件。

## Arch

```shell
# 获取当前系统中主动安装的包
pacman -Qqet > pkglist.txt
# 从列表文件安装软件包
pacman -S --needed - < pkglist.txt
# 如果其中包含AUR等外部包，需要过滤后再执行
pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
# 移除没有列在文件中的包
pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort pkglist.txt))
```

## Windows

> [!note] 需要开启开发者模式才能创建软链接。
