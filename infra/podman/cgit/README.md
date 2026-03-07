# CGit Docker

基于 Alpine Linux 的 CGit 容器化部署方案。

## 简介

[CGit](https://git.zx2c4.com/cgit/) 是一个用 C 语言编写的高速 Git Web 界面，专为性能而设计。

## 构建镜像

```bash
cd infrastructure/podman/cgit
podman build -t cgit .
```

## 运行容器

### 基本运行

```bash
podman run -d \
  --name cgit \
  -p 8080:80 \
  -v /path/to/repos:/opt/cgit/repos:ro \
  cgit
```

### 持久化配置

```bash
podman run -d \
  --name cgit \
  -p 8080:80 \
  -v /path/to/repos:/opt/cgit/repos:ro \
  -v /path/to/config:/opt/cgit/config:ro \
  -v cgit-cache:/opt/cgit/cache \
  cgit
```

## 配置说明

### 挂载仓库目录

将 Git 仓库目录挂载到 `/opt/cgit/repos`：

```bash
-v /srv/git:/opt/cgit/repos:ro
```

### 自定义配置

修改 `cgit.conf` 配置文件：

```conf
CGIT_SCRIPT_PATH = /opt/cgit/app
CGIT_CONFIG = /opt/cgit/config/cgit.conf
CACHE_ROOT = /opt/cgit/cache
prefix = /opt/cgit
libdir = $(prefix)
filterdir = $(libdir)/filters

# 仓库根目录
repos-root = /opt/cgit/repos

# 默认分支
default-branch = main

# 启用功能
enable-git-config = 1
enable-index-links = 1
```

## 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `CGIT_REPOS_DIR` | Git 仓库目录 | `/opt/cgit/repos` |

## 端口

- **80**: HTTP 服务端口

## 目录结构

```
cgit/
├── Dockerfile              # 容器构建文件
├── cgit.conf               # CGit 构建配置
├── README.md               # 本文档
└── rootfs/                 # 容器运行时文件
    ├── etc/
    │   ├── fcgiwrap.conf   # fcgiwrap 配置
    │   └── nginx/
    │       └── conf.d/
    │           └── cgit.conf  # nginx 配置
    └── usr/
        └── local/
            └── bin/
                └── start.sh   # 启动脚本
```

## 健康检查

容器内置健康检查，每 30 秒检查一次 HTTP 服务状态。

```bash
podman inspect --format='{{.State.Health.Status}}' cgit
```

## 许可证

CGit 遵循 GPL-2.0 许可证。
