# CI/CD、DevOps、Docker、Kubernetes、WSL、Hyper-V、Ubuntu、Supabase 使用指南
## Production
1. 安裝 Hyper-V
2. 建立 Ubuntu 虛擬機器
3. 安裝 Docker
4. 安裝 Supabase

## Development
1. 安裝WSL
2. 安裝 Docker Desktop
3. 安裝 Supabase

本地開發好如何移植至生產環境？

## WSL (Windows Subsystem for Linux) 使用指南
* `wsl -l -v`：列出所有 WSL 發行版及其版本。
* `wsl --update`：更新 WSL。
* `wsl --list --online`：列出可用的 WSL 發行版。
* `wsl -d Ubuntu`：啟動指定的 WSL 發行版（例如 Ubuntu）。
* `wsl --terminate Ubuntu`：
  關閉指定的 WSL 發行版（例如 Ubuntu）。
* `wsl --set-default Ubuntu`：將 Ubuntu 設為預設 WSL 發行版。
* `wsl --unregister Ubuntu`：取消註冊 Ubuntu 發行版並刪除資料。
* `wsl --install Ubuntu-24.04 --location d:\WSL-VM`：
  安裝 Ubuntu 24.04 發行版並指定安裝位置。
* `wsl --export Ubuntu-24.04 D:\WSL-VM\Ubuntu-24.04.tar`：
  將 Ubuntu 24.04 發行版導出為 tar 檔案。

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
