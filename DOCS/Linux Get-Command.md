---
description: New prompt created from chat session
mode: ask
model: Auto (copilot)
---
<user>
ubuntu linux 有沒有像 Powershell 的get-command的指令，可抓出執行檔所在位置?
</user>
<assistant>
在 Ubuntu 可用以下指令類似 PowerShell Get-Command 取得執行檔路徑:

1. which 可列出 PATH 中第一個匹配
2. command -v 與 type -a 可顯示 shell 解析結果 (含別名/函式)
3. type -a 指令 顯示所有解析來源
4. whereis 指令 顯示二進位/原始碼/man 位置
5. readlink -f "$(which 指令)" 取得實際檔案(展開 symlink)

範例:
````bash
# ...existing code...
sudo apt install gnome-text-editor
# ...existing code...
gnome-text-editor /etc/apt/sources.list
# ...existing code...
service docker status
# 新增示例：
which docker
command -v docker
type -a docker
whereis docker
readlink -f "$(which docker)"
````

說明簡述:
- 建議優先用 command -v (POSIX) 或 type -a (查多重解析)
- whereis 粗略 (用資料庫), 不一定只顯示實際執行檔
- 若有 alias/函式, 用 type -a 可看清來源

如果要查套件安裝檔案:
dpkg -L 套件名 | grep '/docker$'說明簡述:
- 建議優先用 command -v (POSIX) 或 type -a (查多重解析)
- whereis 粗略 (用資料庫), 不一定只顯示實際執行檔
- 若有 alias/函式, 用 type -a 可看清來源

如果要查套件安裝檔案:
dpkg -L 套件名 | grep '/docker$'
</assistant>