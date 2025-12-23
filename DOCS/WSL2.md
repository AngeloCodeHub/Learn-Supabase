## 常用命令
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

## 參考
- [Set up Node.js on WSL 2 | Microsoft Learn](https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl)
- [Windows Subsystem for Linux Documentation | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/)
- [Ubuntu 上安裝 Node.js 最完整指南｜三大方法比較、步驟與常見問題全解析 - オープンソースの力を活用する方法～Ubuntuの世界へようこそ～](https://www.linux.digibeatrix.com/zh/development-environment-setup/ubuntu-nodejs-install-guide/)

## WSL 不適合 Production
- [ChatGPT](https://chatgpt.com/share/694289aa-4460-8006-a11a-95cf5c14ba05)
- [Microsoft Copilot: Your AI companion](https://copilot.microsoft.com/chats/qD6ss2PyPkhXJVubpzR2v)
