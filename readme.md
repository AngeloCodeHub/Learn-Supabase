# Learn 說明

## Scope

- Linux OS 管理（不包含 WSL 架設與使用）
- NginX Web Server
- 資料庫技術（不包含伺服器架設，MySQL伺服器架設歸類在Wamp64）：PostgreSQL、MySQL
- Docker、Kubernetes 技術
- Supabase BaaS 全攻略
- CI/CD、DevOps

## Production

1. 安裝 Hyper-V
2. 建立 Ubuntu 虛擬機器
3. 安裝 Docker
4. 安裝 Supabase

## Development

1. 安裝WSL
2. 安裝 Docker Desktop
3. 安裝 Supabase

## Docker 使用指南

* `docker --version`：檢查 Docker 版本。
* `docker pull <image>`：從 Docker Hub 下載映像檔。
* `docker images`：列出本地所有 Docker 映像檔。
* `docker rmi <image>`：刪除指定的 Docker 映像檔。
* `docker run <image>`：運行指定的 Docker 映像檔。
* `docker ps`：列出正在運行的容器。
* `docker stop <container>`：停止指定的容器。
* `docker exec -it <container> /bin/bash`：進入正在運行的容器。
* `docker container start 3d499f659935`：
  啟動指定的容器。
* `docker commit ap1 myimage:latest`：
  將容器 ap1 的變更提交為新的映像檔 myimage:latest。
